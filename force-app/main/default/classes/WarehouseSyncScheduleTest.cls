@IsTest
public class WarehouseSyncScheduleTest {
  public static testMethod void testScenario()
    {
        Product2 prod = new Product2();
        prod.Replacement_Part__c = true;
        prod.Current_Inventory__c = 10;
        prod.Name = 'Generator1';
        prod.Lifespan_Months__c = 10;
        prod.Maintenance_Cycle__c = 20;
        prod.Cost__c = 120;
        prod.Warehouse_SKU__c = '1111';
        insert prod;
        WarehouseCalloutServiceMock.pId = prod.Id;
        Test.setMock(HttpCalloutMock.class, new WarehouseCalloutServiceMock());
        Test.startTest();
        WarehouseSyncSchedule obj = new WarehouseSyncSchedule();
        System.schedule('Scheduled Job 1', '0 0 1 * * ?', new WarehouseSyncSchedule());
        test.stopTest();
        System.assertEquals(1, [SELECT ID from CronJobDetail].size());
    }
}