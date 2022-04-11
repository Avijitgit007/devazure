public class BoatSearchResults {
	@AuraEnabled
    public static List<Boat__c> getBoats(String boatTypeId)
    {
        if(boatTypeId == '')
        {
            return [SELECT Id,Name,Description__c,Price__c,Length__c,Contact__r.Name,Contact__r.Email,Contact__r.HomePhone,BoatType__r.Name,Picture__c from Boat__c];
        }
        else
        {
            return [SELECT Id,Name,Description__c,Price__c,Length__c,Contact__r.Name,Contact__r.Email,Contact__r.HomePhone,BoatType__r.Name,Picture__c from Boat__c where BoatType__c = :boatTypeId];
        }
    }
}