@isTest
public class WarehouseCalloutServiceTest {
    // implement your mock callout test here
    public static testMethod void testPositive()
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
        test.startTest();
        WarehouseCalloutService.runWarehouseEquipmentSync();
        test.stopTest();
        System.assertEquals(2, [Select Id from Product2].size());
            
    }
}