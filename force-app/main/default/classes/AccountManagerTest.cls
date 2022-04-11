@IsTest
private class AccountManagerTest {

    @isTest static void testWebservice() {
        Account a = new Account();
        a.Name = 'Account';
        insert a;
        Contact c = new COntact();
        c.AccountId = a.id;
        c.LastName = 'Contact';
        insert c;
        test.startTest();
        RestRequest request = new RestRequest();
        request.requestUri =
            'https://lightingtrailhead-dev-ed.my.salesforce.com/services/apexrest/Accounts/'+a.Id+'/contacts';
        request.httpMethod = 'GET';
        RestContext.request = request;
        Account accList = AccountManager.getAccount();
        test.stopTest();
        System.assertEquals(1, accList.contacts.size());
    }
}