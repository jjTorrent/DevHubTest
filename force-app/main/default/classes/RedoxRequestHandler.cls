/*******************************************************************************
*   Author: Jonathan James / Torrent Consulting
*   Company Contact: Development@TorrentConsulting.com
*   Purpose: The Redox Engine requires a custom endpoint to which it will push 
*			 all subscribed Data Models and Events. This class inherits the JSON
*			 body from that endpoint and interprets the data into SObjects by 
*			 using mapping information and behavior defined in a Custom Metadata 
*			 Type, Redox Mapping.
*
*			 General note: we could traverse the JSON object only once if we use
*			 a recursive parser and check against the Redox Mappings map for 
*			 every node/path, but that could get difficult when dealing with 
*			 child SObjects. Maybe that's a bad idea.
*
*   Date of Change	Author					Change Summary
*   --------------	---------------------	------------------------------------
*   2018-01-25		Cheyne Pierce			Initial development.
*   2019-09-10		Jonathan James			Refactored.
*******************************************************************************/

public class RedoxRequestHandler {

	private static String PARENT_ID = 'ParentObject';
	private static String DEFAULT_VALUE = 'DEFAULT_VALUE';

	/**
	* Description: Entry point for generating Salesforce data from the custom
	* endpoint that receives JSON messaging from the Redox Engine. All mapping
	* information is derived from a Custom Metadata Type, Redox Mapping.
	**/
	public static RedoxServiceResponse handleRedoxRequest(Map<String, Object> data) {
		if (data.containsKey('Meta')) {
			Map<String, Object> meta = (Map<String, Object>)data.get('Meta');
			String dataModel = (String)meta.get('DataModel');
			String eventType = '%' + (String)meta.get('EventType') + '%';
			return handleDataModel(data, dataModel, eventType);
		} else {
			return new RedoxServiceResponse(false, 'No data model specified');
		}
	}

	/**************************************************************************/
	/************ PRIVATE UTILITY METHODS, Alphabetically Ordered *************/
	/**************************************************************************/

	/**
	* Description: Called by handleDataModel(), this method creates the main 
	* SObject identified in the Data Model and Event Type field mappings. Child
	* records may be generated in subsequent methods.
	**/
	private static SObject createParentSObject(String parentObjectName, Map<String, Object> data, Map<String, List<Redox_Mapping__mdt>> mappingsByPath) {
		SObject parent = Schema.getGlobalDescribe().get(parentObjectName).newSObject();
		if (mappingsByPath.containsKey(DEFAULT_VALUE)) {
			for (Redox_Mapping__mdt m : mappingsByPath.get(DEFAULT_VALUE)) {
				setSObjectValue(m, (Object)m.Salesforce_Default_Value__c, parent);
			}
			mappingsByPath.remove(DEFAULT_VALUE);
		}
		for (String pathString : mappingsByPath.keySet()) {
			Object traverseObj = traversePath(pathString, data);
			for (Redox_Mapping__mdt m : mappingsByPath.get(pathString)) {
				switch on m.Redox_Field_Behavior__c {
					when 'Get Value' {
						Map<String, Object> node = (Map<String, Object>)traverseObj;
						setSObjectValue(m, node.get(m.Redox_Field__c), parent);
					}
					when 'Get Value at List Index' {
						// The Redox Field should already be an integer, enforced by a validation rule on the Redox Mappings metadata.
						if (m.Redox_Field__c.isNumeric()) {
							Integer index = Integer.valueOf(m.Redox_Field__c);
							List<Object> elements = (List<Object>)traverseObj;
							setSObjectValue(m, elements[index], parent);
						}
					}
					// Consider the example of Identifiers node
					when 'Get List Object' {
						//
					}
					// Combine a given field from a list of objects into a single value.
					// This defaults to a String type and was intended to fill multiselect picklists (using semicolon separation).
					when 'Concatenate Strings' {
						Map<String, Object> node = (Map<String, Object>)traverseObj;
						List<Object> elements = (List<Object>)node.get(m.Redox_Field__c);
						List<String> values = new List<String>();
						for (Object elem : elements) {
							values.add((String)elem);
						}
						parent.put(m.Salesforce_Field__c, String.join(values, getDelimiter(m)));
					}
					// Combine a given field from a list of objects into a single value.
					// This defaults to a String type and was intended to fill multiselect picklists (using semicolon separation).
					when 'Concatenate Objects' {
						Map<String, Object> node = (Map<String, Object>)traverseObj;
						List<Map<String, Object>> elements = convertObjectToMaps(node.get(m.Redox_Field__c));
						List<String> values = new List<String>();
						for (Map<String, Object> elem : elements) {
							values.add((String)elem.get(m.Redox_Concatenation_Field__c));
						}
						parent.put(m.Salesforce_Field__c, String.join(values, getDelimiter(m)));
					}
				}
			}
		}
		//Check for SObject type's upsert field (custom metadata type)
		// if (hasUpsertField) {
		// 	upsert parent;
		// } else {
		//Also check the Redox Data Model / Event Type for the operation (insert/update/upsert)
		// 	insert parent;
		// }
		return parent;
	}

	/**
	* Description: Converts an object into a List of Maps.
	**/
	private static List<Map<String, Object>> convertObjectToMaps(Object obj) {
		List<Object> l = (List<Object>)obj;
		List<Map<String, Object>> m = new List<Map<String, Object>>();
		for (Object elem : l) {
			m.add((Map<String, Object>)elem);
		}
		return m;
	}

	/**
	* Description: Convert an Object into a Boolean value.
	**/
	private static Boolean getBooleanValue(Object val) {
		return Boolean.valueOf(val);
	}

	/**
	* Description: Convert an Object into a Date value.
	**/
	private static Date getDateValue(Object val) {
		return parseDate((String)val);
	}

	/**
	* Description: Provides the character(s) String for the delimiter identified
	* in the Redox Mapping Custom Metadata Type.
	**/
	private static String getDelimiter(Redox_Mapping__mdt m) {
		switch on m.Salesforce_Concatenation_Delimiter__c {
			when 'Space' {
				return ' ';
			}
			when 'Comma' {
				return ',';
			}
			when 'Semicolon' {
				return ';';
			}
			when 'Newline' {
				return '\n';
			}
			when 'Blank' {
				return '';
			}
			when 'Pipe' {
				return '|';
			}
			when 'Comma Space' {
				return ', ';
			}
			when else {
				return '';
			}
		}
	}

	/**
	* Description: Gather Redox Mapping Custom Metadata Types (CMT) that match 
	* the given Redox Data Model and Event Type. Sort theses CMTs into a Map by 
	* SObject Type by Redox Path so that, for each SObject generated, the parser
	* only needs to traverse the nodes once.
	**/
	private static Map<String, Map<String, List<Redox_Mapping__mdt>>> getMappingsByDataModelAndEventType(String dataModel, String eventType) {
		String parentObject;
		Map<String, Map<String, List<Redox_Mapping__mdt>>> mappings = new Map<String, Map<String, List<Redox_Mapping__mdt>>>();

		for (Redox_Mapping__mdt mapping : [
			SELECT Redox_Path__c, Redox_Field__c, Redox_Field_Behavior__c, 
				Redox_Concatenation_Field__c, Data_Type__c, 
				Salesforce_Object__c, Salesforce_Field__c, 
				Salesforce_Related_To_Object__c, Salesforce_Related_By_Field__c,
				Salesforce_Concatenation_Delimiter__c, Salesforce_Default_Value__c
			FROM Redox_Mapping__mdt
			WHERE Redox_Data_Model_and_Event_Type__r.Data_Model__c = :dataModel
			AND Redox_Data_Model_and_Event_Type__r.Event_Type__c LIKE :eventType
		]) {
			if (!mappings.containsKey(mapping.Salesforce_Object__c)) {
				mappings.put(mapping.Salesforce_Object__c, new Map<String, List<Redox_Mapping__mdt>>());
			}

			if (String.isBlank(parentObject) && 
				String.isBlank(mapping.Salesforce_Related_To_Object__c)
			) {
				parentObject = mapping.Salesforce_Object__c;
			}

			Map<String, List<Redox_Mapping__mdt>> mappingsByPath = mappings.get(mapping.Salesforce_Object__c);
			if (!mappingsByPath.containsKey(mapping.Redox_Path__c)) {
				mappingsByPath.get(mapping.Redox_Path__c).add(mapping);
			} else {
				mappingsByPath.put(mapping.Redox_Path__c, new List<Redox_Mapping__mdt>{mapping});
			}

			mappings.put(mapping.Salesforce_Object__c, mappingsByPath);
		}

		if (String.isNotBlank(parentObject)) {
			mappings.put(
				PARENT_ID, 
				new Map<String, List<Redox_Mapping__mdt>>{ parentObject => null }
			);
		}
		return mappings;
	}

	/**
	* Description: Convert an Object into a String.
	**/
	private static String getStringValue(Object val) {
		return (String)val;
	}

	/**
	* Description: Called by the handleRedoxRequest() public method, this method
	* parses the API endpoint's JSON by utilizing Redox Mapping Custom Metadata  
	* Type records to define the mapping of JSON data to Salesforce SObjects.
	**/
	private static RedoxServiceResponse handleDataModel(Map<String, Object> data, String dataModel, String eventType) {
		Map<String, Map<String, List<Redox_Mapping__mdt>>> mappingsBySObjectByPath = getMappingsByDataModelAndEventType(dataModel, eventType);

		if (mappingsBySObjectByPath.isEmpty()) {
			return new RedoxServiceResponse(false, 'Unsupported Redox Data Model');
		} else if (mappingsBySObjectByPath.containsKey(PARENT_ID)) {
			String parentObjectName = new List<String>(mappingsBySObjectByPath.get(PARENT_ID).keySet())[0];
			SObject parent = createParentSObject(parentObjectName, data, mappingsBySObjectByPath.get(parentObjectName));

			Map<String, List<SObject>> objectsByType;
			for (String sObjectType : mappingsBySObjectByPath.keySet()) {
				if (sObjectType != parentObjectName) {
					objectsByType.put(sObjectType, new List<SObject>());
				}
			}
			return new RedoxServiceResponse(true);
		} else {
			return new RedoxServiceResponse(false, 'No base Salesforce Object was identified from the Redox mappings.');
		}
	}

	/**
	* Description: Create a Date value from the date string provided by Redox in
	* the format yyyy-mm-dd.
	**/
	private static Date parseDate(String val) {
		try {
			List<String> parts = val.split('-');
			return Date.newInstance(
				Integer.valueOf(parts[0]), 
				Integer.valueOf(parts[1]), 
				Integer.valueOf(parts[2]));
		} catch (Exception e) {
			System.debug(LoggingLevel.ERROR, e.getMessage());
			return null;
		}
	}

	/**
	* Description: Set an SObject field value using the destination Redox  
	* Mapping Custom Metadata Type and the JSON object's field data value.
	**/
	private static void setSObjectValue(Redox_Mapping__mdt m, Object redoxValue, SObject sObj) {
		switch on m.Data_Type__c {
			when 'String' {
				sObj.put(m.Salesforce_Field__c, getStringValue(redoxValue));
			}
			when 'Date' {
				sObj.put(m.Salesforce_Field__c, getDateValue(redoxValue));
			}
			when 'Boolean' {
				sObj.put(m.Salesforce_Field__c, getBooleanValue(redoxValue));
			}
			when else {
				System.debug(
					LoggingLevel.ERROR, 
					'An unhandled Data Type, ' + m.Data_Type__c + ', was encountered ' +
					'by RedoxHandler setSObjectValue() to set the ' + 
					m.Salesforce_Field__c + ' field.'
				);
			}
		}
	}

	/**
	* Description: This is the path of JSON keys that we will have to traverse 
	* in order to get to the Redox Field. It will be a comma-delimited string. 
	* For example, if the JSON is 
	* { 
	*   "Address": {
	*     "Street": { 
	*		"Line 1": "123 1st St.", 
	*		"Line 2": "Apt 2"
	*	  }	
	*   }
	* }
	* then the path would be "Address,Street" while the Redox Field would be 
	* "Line 1". List nodes are handled somewhat differently in the Custom 
	* Metadata Type, but this traversal remains constant.
	**/
	private static Object traversePath(String pathString, Map<String, Object> obj) {
		Map<String, Object> node = obj;
		Object returnObj;
		List<String> paths = pathString.split(',');
		Integer runs = 0;
		for (String path : paths) {
			runs += 1; 
			if (node.containsKey(path)) {
				returnObj = node.get(path);
				if (paths.size() != runs) {
					node = (Map<String, Object>)returnObj;
				}
			}
		}
		// System.debug(LoggingLevel.INFO, 'RedoxHandler traversePath() NODE\n\n' + JSON.serialize(node));
		return returnObj;
	}

}