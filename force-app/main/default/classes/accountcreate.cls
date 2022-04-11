public with sharing class accountcreate {
    @AuraEnabled
    public static List<Contact> createAccount(String accName) {
       List<Contact> lst_con = new List<Contact>();
        System.debug('variable'+accname);
        String key = '%' + accName + '%';
        lst_con = [Select Id,Name,Email,Level__c,Secret_Key__c,Number_of_Business__c  from Contact where Account.Name LIKE : key];
        System.debug('lst----'+lst_con);
        return lst_con;
    }

    @AuraEnabled(cacheable=true)
    public static string recordtypedetails(){
        Map<Id, String> rt_Map = new Map<Id, String>();
        Schema.DescribeSObjectResult sobjectResult = Schema.getGlobalDescribe().get('Account').getDescribe();
        List<Schema.RecordTypeInfo> recordTypeInfo = sobjectResult.getRecordTypeInfos();
        for(Schema.RecordTypeInfo info : recordTypeInfo){
            rt_Map.put(info.getRecordTypeId(), info.getName());
        }
        
        return JSON.serialize(rt_Map);
    }
}