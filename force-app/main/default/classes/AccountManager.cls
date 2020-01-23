@RestResource(urlMapping='/Account/*')
global with sharing class AccountManager {

	@HttpGet
    global static Account getAccount() {
		RestRequest request = RestContext.request;
		Integer contacts = request.requestURI.lastIndexOf('/contacts');
        String recordId = request.requestURI.substring(contacts-18, contacts);
		System.debug(recordId);
		Account result = new Account();
		if (String.isNotBlank(recordId)) {
			for (Account a : [SELECT Id, Name, (SELECT Id, Name FROM Contacts) FROM Account WHERE Id = :recordId]) {
				result = a;
			}
		}
		System.debug(result);
        return result;
    }

}