@isTest
private class AccountManagerTest {

	@isTest
	static void getAccount_Test() {
        Id recordId = createTestRecord();
        RestRequest request = new RestRequest();
        request.requestUri =
			URL.getSalesforceBaseUrl() + 
            '/services/apexrest/Account/' +
            recordId + 
			'/contacts';
        request.httpMethod = 'GET';
        RestContext.request = request;

        Account testRecord = AccountManager.getAccount();

        System.assert(testRecord != null);
        System.assertEquals('Test Account', testRecord.Name);
		System.assertEquals(1, testRecord.Contacts.size());
    }

	static Id createTestRecord() {
        Account acc = new Account(
			Name = 'Test Account'
		);
		insert acc;

		Contact con = new Contact(
			FirstName = 'Test',
			LastName = 'Contact',
			AccountId = acc.Id
		);
		insert con;

		return acc.Id;
    }

}