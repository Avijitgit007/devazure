@IsTest
public class MaintenanceRequestTest {
  public static testMethod void testPositive()
    {
        Vehicle__c vObj = new Vehicle__c();
        vobj.Name = 'V1';
        insert vobj;
        
        List<Case> caseList = new List<Case>();
        Case cClone = new Case();
        cClone.Status = 'New';
        cClone.Type = 'Routine Maintenance';
        cClone.Subject = 'Routine Maintenance';
        cClone.Date_Reported__c = System.today();
        cClone.Date_Due__c = System.today()+5;
        cClone.Vehicle__c = vobj.Id;
        caseList.add(cClone);
        Case cClone1 = new Case();
        cClone1.Status = 'New';
        cClone1.Type = 'Routine Maintenance';
        cClone1.Subject = 'Routine Maintenance1';
        cClone1.Date_Reported__c = System.today();
        cClone1.Date_Due__c = System.today()+10;
        cClone1.Vehicle__c = vobj.Id;
        caseList.add(cClone1);
        insert caseList;
        
        List<Product2> prodListToInsert = new List<Product2>();
        Product2 prod = new Product2();
        prod.Replacement_Part__c = true;
        prod.Current_Inventory__c = 10;
        prod.Name = 'Generator1';
        prod.Lifespan_Months__c = 10;
        prod.Maintenance_Cycle__c = 20;
        prod.Cost__c = 120;
        prod.Warehouse_SKU__c = '1111';
        prodListToInsert.add(prod);
        
        Product2 prod1 = new Product2();
        prod1.Replacement_Part__c = true;
        prod1.Current_Inventory__c = 10;
        prod1.Name = 'Generator2';
        prod1.Lifespan_Months__c = 10;
        prod1.Maintenance_Cycle__c = 20;
        prod1.Cost__c = 120;
        prod1.Warehouse_SKU__c = '1112';
        prodListToInsert.add(prod1);
        
        insert prodListToInsert;
        
        List<Work_Part__c> wpList = new List<Work_Part__c>();
        for(Case c : caseList)
        {
            for(Product2 p : prodListToInsert)
            {
                Work_Part__c wp = new Work_Part__c();
                wp.Maintenance_Request__c = c.Id;
                wp.Equipment__c = p.Id;
                wpList.add(wp);
            }
        }
        insert wpList;
        
        Test.startTest();
        
        for(Case c : caseList)
        {
            c.Status = 'Closed';
        }
        update caseList;
        Test.stopTest();
        
        System.assertEquals(4, [SELECT Id from Case].size());
    }
}