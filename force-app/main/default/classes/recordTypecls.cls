global with sharing class recordTypecls {

    @AuraEnabled
    public static String getRecordTypeNameById(String objectName, Id strRecordTypeId)
    {
        System.debug('-----'+objectName+'----'+strRecordTypeId);
        return Schema.getGlobalDescribe().get(objectName).getDescribe().getRecordTypeInfosById().get(strRecordTypeId).getDeveloperName();
    }  
}