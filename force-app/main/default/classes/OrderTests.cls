@isTest
public class OrderTests {
    
    
    
    //public  static Map<String, List<Object>> testData;  
    
    @testSetup 
    static void SetupTestData (){
        
        TestDataFactory.InsertTestData(5);
        
    }
    
      @isTest static void OrderExtension_UnitTest() {
    
     Order rec = [select id, Status from Order limit 1];
        PageReference pageRef = Page.OrderEdit;
        
        //Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('id',rec.id);
        Test.setCurrentPage(pageRef);
        SetupTestData();
         ApexPages.StandardController sc = new ApexPages.standardController(rec);
        OrderExtension ext = new OrderExtension(sc);        
        System.assertEquals(Constants.DEFAULT_ROWS, ext.orderItemList.size());
        ext.OnFieldChange();
        ext.SelectFamily();
        ext.Save();
        ext.First();
        ext.Next();
        ext.Previous();
        ext.Last();
        ext.GetHasPrevious();
        ext.GetHasNext();
        ext.GetTotalPages();
        ext.GetPageNumber();
        List<SelectOption> options = ext.GetFamilyOptions();
    }
    
    @isTest
    static void OrderUpdate_UnitTest (){
        Test.startTest();
        Order rec = [select id, Status from Order limit 1];
        Product2 prod = [SELECT Family,Id,Name,Quantity_Ordered__c,Quantity_Remaining__c FROM Product2 limit 1];
        system.debug('kkk '+prod.Quantity_Ordered__c);
        rec.status = constants.ACTIVATED_ORDER_STATUS;
        Update rec;
        Product2 updatedprod = [SELECT Family,Id,Name,Quantity_Ordered__c,Quantity_Remaining__c FROM Product2 limit 1];
        
        system.debug('kkk '+updatedprod.Quantity_Ordered__c);
        TestDataFactory.VerifyQuantityOrdered(prod,updatedprod,constants.DEFAULT_ROWS);
        Test.stopTest();
    }
    
    
   
    
    
   
}