public without sharing class OrderHelper {
    
    /**
* @name AfterUpdate
* @description 
* @param List<Order> newList
* @param List<Order> oldList
* @return void
**/
    public static void AfterUpdate(List<Order> newList, List<Order> oldList){
        
        try {
            Set<Id> activatedOrderIds = new Set<Id>();
            for ( Integer i=0; i<newList.size(); i++ ){
                if ( newList[i].Status == Constants.ACTIVATED_ORDER_STATUS && oldList[i].Status != Constants.ACTIVATED_ORDER_STATUS ){
                    activatedOrderIds.add(newList[i].id);
                }
            }
            
            if(!activatedOrderIds.isEmpty())
            {
                RollUpOrderItems(activatedOrderIds);
            }
        }
        catch(Exception e)
        {

        }
        
    }
    
    /**
* @name RollUpOrderItems
* @description Given a set of Activated Order ids, query the child Order Items and related Products to calculate Inventory levels
* @param Set<Id> activatedOrderIds
* @return void
**/
    public static void RollUpOrderItems(Set<Id> activatedOrderIds){
        //ToDo: Declare a Map named "productMap" of Ids to Product2 records
        Map<Id, Product2> prodMap = new Map<Id, Product2>();
        //ToDo: Loop through a query of OrderItems related to the activatedOrderIds
        for ( OrderItem oi : [
            SELECT Id, Product2Id, Product2.Quantity_Ordered__c,Product2.Initial_Inventory__c
            FROM OrderItem
            WHERE OrderId IN :activatedOrderIds
        ])
        {
            prodMap.put(oi.Product2Id, oi.Product2);
        }
        //ToDo: Populate the map with the Id of the related Product2 as the key and Product2 record as the value
        
        for ( AggregateResult ar : [
            SELECT Product2Id,  SUM(Quantity)
            FROM OrderItem
            WHERE Product2Id IN :prodMap.keySet()
            GROUP BY Product2Id
        ])
        {
            prodMap.get((Id)ar.get('Product2Id')).Quantity_Ordered__c = (Decimal) ar.get('expr0');
        }
        //ToDo: Loop through a query that aggregates the OrderItems related to the Products in the ProductMap keyset
        update prodMap.values();
        //ToDo: Perform an update on the records in the productMap
    }
    
}