@isTest
private class Redox_Test {
	@isTest 
	static void testVerify() {
		RestRequest req = new RestRequest(); 
		RestResponse res = new RestResponse();

		req.requestURI = 'https://cs9.salesforce.com/services/apexrest/redox';
		req.httpMethod = 'GET';
		req.addParameter('challenge', 'test');
		
		RestContext.request = req;
		RestContext.response = res;

		Redox.verify();
	}

	@isTest 
	static void testNewPatient() {
		RestRequest req = new RestRequest(); 
		RestResponse res = new RestResponse();

		req.requestURI = 'https://cs9.salesforce.com/services/apexrest/redox';  
		req.httpMethod = 'POST';
		req.requestBody = Blob.valueOf('{"Meta": {"DataModel": "PatientAdmin","EventType": "NewPatient","EventDateTime": "2018-01-09T05:37:16.852Z","Test": true,"Source": {"ID": "7ce6f387-c33c-417d-8682-81e83628cbd9","Name": "Redox Dev Tools"},"Destinations": [{"ID": "af394f14-b34a-464f-8d24-895f370af4c9","Name": "Redox EMR"}],"Message": {"ID": 5565},"Transmission": {"ID": 12414},"FacilityCode": null},"Patient": {"Identifiers": [{"ID": "0000000004","IDType": "MR"},{"ID": "f8c982fd-21a5-4895-993c-2096281c421c","IDType": "EHRID"},{"ID": "c2522c55546940a^^^&1.3.6.1.4.1.21367.2005.13.20.1000&ISO","IDType": "NIST"}],"Demographics": {"FirstName": "Elizabeth","MiddleName": null,"LastName": "Carthwright","DOB": "1970-08-01","SSN": "404-04-0004","Sex": "Female","Race": "White","IsHispanic": true,"MaritalStatus": "Divorced","IsDeceased": null,"DeathDateTime": null,"PhoneNumber": {"Home": "123-321-4567","Office": "987-654-3210","Mobile": "678-543-0987"},"EmailAddresses": ["bethcart@test.net"],"Language": "es","Citizenship": [],"Address": {"StreetAddress": "5770 Winfield Court","City": "Oak Park","State": "CA","ZIP": "91377","County": "Ventura","Country": "US"}},"Notes": [],"Contacts": [{"FirstName": "Selma","MiddleName": null,"LastName": "Adams","Address": {"StreetAddress": "880 Ethan Terrace","City": "Agoura Hills","State": "CA","ZIP": "91301","County": "Los Angelas","Country": "US"},"PhoneNumber": {"Home": "808-555-5310","Office": null,"Mobile": null},"RelationToPatient": "Friend","EmailAddresses": ["selma1956@test.net"],"Roles": ["Emergency Contact","NOK"]}],"Allergies": [{"Code": "7982","Codeset": "RxNorm","Name": "Penicillin","OnsetDateTime": null,"Reaction": [{"Code": "28926001","Codeset": "SNOMED CT","Name": "Rash"},{"Code": "247472004","Codeset": "SNOMED CT","Name": "Hives"}]}],"PCP": {"NPI": "2434534567","FirstName": "Sharon","LastName": "Chalk","Credentials": ["MD","PhD"],"Address": {"StreetAddress": "312 Maple Dr. Suite 400","City": "Verona","State": "WI","ZIP": "53593","County": "Dane","Country": "USA"},"Location": {"Type": null,"Facility": null,"Department": null,"Room": null},"PhoneNumber": {"Office": "+16085559999"},"ID": "2434534567","IDType": "NPI"},"Guarantor": {"Number": null,"FirstName": "Elizabeth","LastName": "Carthwright","DOB": null,"Sex": null,"Spouse": {"FirstName": null,"LastName": null},"Address": {"StreetAddress": "5770 Winfield Court","City": "Oak Park","State": "CA","ZIP": "91377","County": "Ventura","Country": "US"},"PhoneNumber": {"Home": null,"Business": null},"Type": "Individual","RelationToPatient": "Self","Employer": {"Name": "City of Calabasas","Address": {"StreetAddress": "100 Civic Center Way","City": "Calabasas","State": "CA","ZIP": "90302","County": "Los Angeles","Country": "USA"},"PhoneNumber": "+16428642468"}},"Insurances": [{"Plan": {"ID": "607421","IDType": "Payor ID","Name": "Anthem Bronze 60 D EPO","Type": null},"MemberNumber": null,"Company": {"ID": "326362","IDType": null,"Name": "Anthem Blue Cross","Address": {"StreetAddress": "PO Box 38721","City": "Wilmington","State": "DE","ZIP": "19884","County": "New Castle","Country": "USA"},"PhoneNumber": "+12315557843"},"GroupNumber": null,"GroupName": "City of Calabasas","EffectiveDate": "2015-01-01","ExpirationDate": "2020-12-31","PolicyNumber": "W4921 23294-01","AgreementType": null,"CoverageType": null,"Insured": {"LastName": null,"FirstName": null,"Relationship": null,"DOB": null,"Address": {"StreetAddress": null,"City": null,"State": null,"ZIP": null,"County": null,"Country": null}}}]}}');
		
		RestContext.request = req;
		RestContext.response = res;

		Test.startTest();
			Redox.processData();
		Test.stopTest();

		Account acct = [
			SELECT FirstName FROM Account 
			WHERE FirstName='Elizabeth' AND LastName = 'Carthwright'];
		System.assertEquals('Elizabeth', acct.FirstName);
		
		// Patient_Identifier__c[] identifiers = [
		// 	SELECT Source_Id__c, ID_Type__c, ID_Value__c 
		// 	FROM Patient_Identifier__c WHERE Patient__c = :acct.Id];
		// for (Patient_Identifier__c pi : identifiers) {
		// 	System.assertEquals('7ce6f387-c33c-417d-8682-81e83628cbd9', pi.Source_Id__c);	
		// }
	}

	@isTest 
	static void tesPatientMerge() {
		RestRequest req = new RestRequest(); 
		RestResponse res = new RestResponse();

		req.requestURI = 'https://cs9.salesforce.com/services/apexrest/redox';  
		req.httpMethod = 'POST';
		req.requestBody = Blob.valueOf('{"Meta":{"DataModel":"PatientAdmin","EventType":"PatientMerge","EventDateTime":"2018-01-30T07:10:19.586Z","Test":true,"Source":{"ID":"7ce6f387-c33c-417d-8682-81e83628cbd9","Name":"Redox Dev Tools"},"Destinations":[{"ID":"af394f14-b34a-464f-8d24-895f370af4c9","Name":"Redox EMR"}],"Message":{"ID":5565},"Transmission":{"ID":12414},"FacilityCode":null},"Patient":{"Identifiers":[{"ID":"0000000001","IDType":"MR"},{"ID":"e167267c-16c9-4fe3-96ae-9cff5703e90a","IDType":"EHRID"},{"ID":"a1d4ee8aba494ca","IDType":"NIST"}],"PreviousIdentifiers":[{"ID":"53700","IDType":"MR"}],"Demographics":{"FirstName":"Timothy","MiddleName":"Paul","LastName":"Bixby","DOB":"2008-01-06","SSN":"101-01-0001","Sex":"Male","Race":"Asian","IsHispanic":null,"MaritalStatus":"Single","IsDeceased":null,"DeathDateTime":null,"PhoneNumber":{"Home":"+18088675301","Office":null,"Mobile":null},"EmailAddresses":[],"Language":"en","Citizenship":[],"Address":{"StreetAddress":"4762 Hickory Street","City":"Monroe","State":"WI","ZIP":"53566","County":"Green","Country":"US"}},"Notes":[]}}');
		
		RestContext.request = req;
		RestContext.response = res;

		Redox.processData();
	}

	@isTest 
	static void testUnsupportedEvent() {
		RestRequest req = new RestRequest(); 
		RestResponse res = new RestResponse();

		req.requestURI = 'https://cs9.salesforce.com/services/apexrest/redox';  
		req.httpMethod = 'POST';
		req.requestBody = Blob.valueOf('{"Meta":{"DataModel":"PatientAdmin","EventType":"UnsupportedEvent","EventDateTime":"2018-01-30T07:10:19.586Z","Test":true,"Source":{"ID":"7ce6f387-c33c-417d-8682-81e83628cbd9","Name":"Redox Dev Tools"},"Destinations":[{"ID":"af394f14-b34a-464f-8d24-895f370af4c9","Name":"Redox EMR"}],"Message":{"ID":5565},"Transmission":{"ID":12414},"FacilityCode":null},"Patient":{"Identifiers":[{"ID":"0000000001","IDType":"MR"},{"ID":"e167267c-16c9-4fe3-96ae-9cff5703e90a","IDType":"EHRID"},{"ID":"a1d4ee8aba494ca","IDType":"NIST"}],"PreviousIdentifiers":[{"ID":"53700","IDType":"MR"}],"Demographics":{"FirstName":"Timothy","MiddleName":"Paul","LastName":"Bixby","DOB":"2008-01-06","SSN":"101-01-0001","Sex":"Male","Race":"Asian","IsHispanic":null,"MaritalStatus":"Single","IsDeceased":null,"DeathDateTime":null,"PhoneNumber":{"Home":"+18088675301","Office":null,"Mobile":null},"EmailAddresses":[],"Language":"en","Citizenship":[],"Address":{"StreetAddress":"4762 Hickory Street","City":"Monroe","State":"WI","ZIP":"53566","County":"Green","Country":"US"}},"Notes":[]}}');
		
		RestContext.request = req;
		RestContext.response = res;

		Redox.processData();
	}

	@isTest 
	static void testServiceResponse() {
		// RedoxServiceResponse resp = new RedoxServiceResponse(true);
		// resp = new RedoxServiceResponse(false, 'test');
		// resp = new RedoxServiceResponse(false, 'test', new PatientAdmin.Patient(new Map<String, Object>{}));
	}

	/***************************************************************************
	*    Description: Create setup data for the test class functions.
	***************************************************************************/
	@TestSetup 
	static void setupData() {
		// Redox_Settings__c setting = new Redox_Settings__c();
		// setting.Redox_Email_Recipients__c = 'zachary.kindall@torrentconsulting.com';		
		// insert setting;
	}

}