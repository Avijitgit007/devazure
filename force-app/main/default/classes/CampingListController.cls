public class CampingListController {
	@AuraEnabled
    public static List<Camping_Item__c> getItems()
    {
        return [Select Id, Name, Quantity__c, Price__c, Packed__c from Camping_Item__c];
    }
    
    @AuraEnabled
    public static void saveItem(Camping_Item__c item)
    {
        insert item;
    }
}