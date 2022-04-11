@IsTest
public class DailyLeadProcessorTest {
  public static testMethod void testScheduler()
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
        DailyLeadProcessor reminder = new DailyLeadProcessor();
        // Seconds Minutes Hours Day_of_month Month Day_of_week optional_year
        String sch = '20 30 8 10 2 ?';
        String jobID = System.schedule('Remind Opp Owners', sch, reminder);
        Test.stopTest();
        List<Lead> lList = [SELECT ID, LeadSource FROM Lead where LeadSource = '' LIMIT 200];
        System.assertEquals(0, llist.size());
        
    }
}