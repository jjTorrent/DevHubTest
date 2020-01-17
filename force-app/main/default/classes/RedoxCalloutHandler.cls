/*******************************************************************************
*   Author: Edgar Chivichon / Torrent Consulting
*   Company Contact: Development@TorrentConsulting.com
*   Purpose: [explain the purpose of the class here]
*
*   Date of Change	Author					Change Summary
*   --------------	---------------------	------------------------------------
*   2019-09-18		Edgar Chivichon			Initial development.
*******************************************************************************/

global class RedoxCalloutHandler {

	global class RedoxCallout {
		@InvocableVariable(required=true)
		global Id sObjectId;

		@InvocableVariable(required=true)
		global String redoxDataModel;

		@InvocableVariable(required=true)
		global String redoxEventType;
	}
	
	class RedoxCalloutException extends Exception {}

	@InvocableMethod(label='Send to Redox' description='Send data/event to Redox from a given SObject.')
	global static void handleCallout(List<RedoxCallout> redoxCallouts) {
		// Start by determining the SObject type by the provided ID from the
		// Process Builder. From there, build out the integration steps using
		// the RedoxRequestHandler class as a guide for how to construct the 
		// data model, but in reverse. You'll use a Map<String, Object> data 
		// type extensively. Query for Redox Mapping Custom Metadata Type 
		// records using all three RedoxCallout inner class attributes.

		// SALESFORCE TO REDOX
		// PULL Custom Metadata records via the three inner class attributes.
		// Use those metadata records to build the JSON strucutre to send to Redox
	}

	@future
	private static void sendToRedox(String jsonString) {
		// HttpRequest send = new HttpRequest
	}

	/**************************************************************************/
	/************ PRIVATE UTILITY METHODS, Alphabetically Ordered *************/
	/**************************************************************************/

	/**
	* Description: Determine the SObject Type of the provided Salesforce ID.
	**/
	private static String getSObjectType(Id sObjectId) {
		return sObjectId.getSObjectType().getDescribe().getName();
	}

}

// List<Map<String, Object>> ids = new List<Map<String, Object>>();
// ids.add(new Map<String, Object>{
// 	'ID' => '1234',
// 	'IDTYPE' => 'MRN'
// });
// ids.add(new Map<String, Object>{
// 	'ID' => '5678',
// 	'IDTYPE' => 'Salesforce'
// });

// Map<String, Object> patient = new Map<String, Object>{
// 	'Identifiers' => ids,
// 	'Demographics' => new Map<String, Object>{
// 		'FirstName' => 'Jonathan',
// 		'LastName' => 'James',
// 		'DOB' => '2019-12-29',
// 		'PhoneNumber' => new Map<String, Object>{
//             'Home' => null,
//             'Office' => null,
//             'Mobile' => '4178487763'
//         },
// 		'EmailAddresses' => new List<String>{
// 			'jonathan@close-far.com',
// 			'cadencereplies@gmail.com'
// 		},
// 		'Address' => new Map<String, Object>{
// 			'StreetAddress' => '123 Golden Ave',
// 			'City' => 'Springfield',
// 			'State' => 'MO',
// 			'ZIP' => '65810',
// 			'County' => 'Greene',
// 			'Country' => 'US'
// 		}
// 	}
// };

// Map<String, Object> demo = (Map<String, Object>)patient.get('Demographics');
// Map<String, Object> emails = (Map<String, Object>)demo.get('EmailAddresses');
// System.debug(LoggingLevel.INFO, emails);

// Map<String, Object> patientAdmin = new Map<String, Object>{
// 	'Meta' => new Map<String, Object>{
// 		'DataModel' => 'PatientAdmin',
// 		'EventType' => 'NewPatient'
// 	},
// 	'Patient' => patient
// };

// String jsonString = JSON.serialize(patientAdmin);
// Object jsonObj = JSON.deserializeUntyped(jsonString);
// // System.debug(LoggingLevel.INFO, jsonObj);
// Map<String, Object> jsonMap = (Map<String, Object>)JSON.deserializeUntyped(jsonString);
// // System.debug(LoggingLevel.INFO, jsonMap);