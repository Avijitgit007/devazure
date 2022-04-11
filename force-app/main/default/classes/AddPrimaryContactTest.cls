@IsTest
public class AddPrimaryContactTest {
  public static testMethod void testQueueable()
    {
        List<Account> accList = new List<Account>();
        for(Integer i=0;i<100;i++)
        {
            Account acc = new Account();
            acc.Name = 'LName'+i;
            if(i>49)
              acc.billingstate = 'NY';
            else
                acc.billingstate = 'CA';
            acclist.add(acc);
        }
        insert accList;
        
        test.startTest();
        Contact con = new Contact();
        con.LastName = 'sample name';
        System.enqueueJob(new AddPrimaryContact(con, 'CA'));
        test.stopTest();
        
        List<Contact> conList = [SELECT ID from Contact where Account.billingstate = 'CA'];
        System.assertEquals(50, conList.size());
        
    }
}