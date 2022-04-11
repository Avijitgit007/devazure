public with sharing class BoatSearchFormController {
	@AuraEnabled
    public static List<BoatType__c> getAllBoatTypes()
    {
        return [SELECT Id, Name from BoatType__c];
    }
}