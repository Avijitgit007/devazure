@IsTest
public class LeadProcessorTest {
  public static testMethod void testBatch()
    {
        
        List<Lead> LeadList = new List<Lead>();
        for(Integer i=0;i<200;i++)
        {
            Lead Lead = new Lead();
            Lead.Company = 'Test'+i;
            Lead.LastName = 'LName'+i;
            Lead.Status = 'Open - Not Contacted';
            LeadList.add(Lead);
        }
        insert LeadList;
        Test.startTest();
        Database.executeBatch(new LeadProcessor(), 200);
        Test.stopTest();
    }
}