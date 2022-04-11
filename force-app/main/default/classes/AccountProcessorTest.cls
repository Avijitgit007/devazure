@isTest
private class AccountProcessorTest{

    @isTest static void testcountContacts() {
        List<Account> lst_acc = new List<Account>();
        List<Contact> lst_con = new List<Contact>();
        List<Id> lst_acc_id = new List<Id>();
        
        Account acct = new Account(Name='Test Account');
        lst_acc.add(acct);
        insert lst_acc;
        
        for(Account acc : lst_acc){
            Contact con = new Contact(LastName='Test',AccountId=acc.Id);
            lst_con.add(con);
            lst_acc_id.add(acc.Id);
        }
        insert lst_con;
        
        Test.startTest();
        //AccountProcessor accpros = new AccountProcessor();
        AccountProcessor.countContacts(lst_acc_id);
        Test.stopTest();
    }
}