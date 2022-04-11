/*
Class Name : ReUsecls
Developer Name : Avijit Das
*/

global with sharing class ReUsecls {
  
 /*
  Method Name : getFieldTypes
  Input Parameters : List of Columns Name, Object Name.
  OutPut Parameter : Map<String, List<String>> | Api Name=(data type,Label Name) | example : MainCompetitors__c=(STRING, Main Competitor(s))
  purpose : It will taka Object and Columns name as input parameter and by using Schema.getGlobalDescribe preparing the Map as utput already given with the example.
 */
    
    @AuraEnabled
    public static Map<String, List<String>> getFieldTypes(String selectedFields,String obj){
        System.debug('Selected---'+selectedFields+'---'+obj);
        Map<String, List<String>> fieldTypeMap = new Map<String,  List<String>>();
        
        try{
            String objectName = obj;
            List<String> lst_str = new List<String>();
            lst_str = selectedFields.split(',');
            

            for(String field : lst_str){
                List<String> lst_objtypelab  = new List<String>();
                if(field.contains('.')){
                    Schema.DescribeSObjectResult describe = Schema.getGlobalDescribe().get(objectName).getDescribe();
                    Map<String, Schema.SObjectField> fieldMap = describe.fields.getMap();
                    String relation = field.substringBefore('.');
                    String originalRelationString = relation;
                    if(relation.endsWith('__r'))
                    {
                        relation = relation.replace('__r', '__c');
                    }
                    else
                    {
                        relation = relation+'Id';
                    }    
                    Schema.DescribeFieldResult fieldResult = fieldMap.get(relation).getDescribe();
                    List<Schema.sObjectType> parentObj = fieldResult.getReferenceTo();
                    Map<String, Schema.SObjectField> parentFieldMap = parentObj[0].getDescribe().fields.getMap();
                    Schema.DescribeFieldResult pfieldResult = parentFieldMap.get(field.substringAfter('.')).getDescribe();
                    If(pfieldResult.isNameField()){
                        lst_objtypelab.add('url');
                        lst_objtypelab.add(originalRelationString+'Link');
                    }
                    else{
                        lst_objtypelab.add(String.valueOf(pfieldResult.getType()));
                    }	
                    lst_objtypelab.add(pfieldResult.getLabel());
                    System.debug('fieldAPI---'+originalRelationString+field.substringAfter('.'));
                    System.debug('2-------'+parentObj[0].getDescribe().getName()+'---'+pfieldResult.isNameField());
                    
                }
                else{
                    Boolean isName = Schema.getGlobalDescribe().get(objectName).getDescribe().fields.getMap().get(field).getDescribe().isNameField();
                    Schema.DisplayType fieldType = Schema.getGlobalDescribe().get(objectName).getDescribe().fields.getMap().get(field).getDescribe().getType();
                    if(isName){
                        lst_objtypelab.add('url');
                        lst_objtypelab.add('recordLink');
                    }
                    else{
                    	lst_objtypelab.add(String.valueOf(fieldType));
                    }
                    lst_objtypelab.add(String.valueOf(String.valueOf(Schema.getGlobalDescribe().get(objectName).getDescribe().fields.getMap().get(field).getDescribe().getLabel())));
                    
                }    
                fieldTypeMap.put(field, lst_objtypelab);
            }
        }catch(Exception e){

        }
        System.debug('fieldTypeMap---'+fieldTypeMap);
        return fieldTypeMap;
    }

 /* 
  Method Name : getObjectRecords
  Input Parameters : List of Columns Name, Object Name, where contions
  OutPut Parameter : List<sObject> as it might be any object
  purpose : It will taka Object,Columns name and filtered conditions (optional) as input parameter and after forming the query retunr the list of records
 */
   @AuraEnabled(cacheable=false)
    public static RelatedRecords getObjectRecords(List<String> selectedFields,String obj,String whcon,String relatedField,Boolean related,String recordId,Integer limitSize, Integer offset,String countAll){
        System.debug('Selected---'+selectedFields+'---'+obj+'---'+related+'---'+relatedField+'---'+whcon);
        System.debug('Integrer---'+limitSize+'----'+offset);
        Schema.DescribeSObjectResult describe = Schema.getGlobalDescribe().get(obj).getDescribe();
        
        RelatedRecords relObj = new RelatedRecords();
        relObj.objectprlName = describe.getLabelPlural();
        try{
            String sfields = '';
            Integer i = 0;
            //Integer totalCount = 0;
            String query ='';
            String totalQuery ='';
            List<sObject> lst_allrecords = new List<sObject>();
            List<sObject> lst_totalrecords = new List<sObject>();
            for(String field : selectedFields){
                if(i == 0){
                    sfields+= field;
                }else{
                    sfields+= ','+field;
                }
                i++;
            }
            query = 'SELECT ' + sfields + ' FROM '+obj;
            if(countAll=='All'){
                totalQuery = 'SELECT Id FROM '+obj;    
            }
            if(related==true && relatedField!=''){
                if(relatedField!=''){
                    query = query+' where '+relatedField+'= \''+recordId+ '\'';
                    if(countAll=='All'){
                        totalQuery = totalQuery+' where '+relatedField+'= \''+recordId+ '\'';
                    }
                }
                if(whcon!='' && whcon!=null){
                    query = query+' and '+whcon;
                    if(countAll=='All'){
                        totalQuery = totalQuery+' and '+whcon;
                    }
                }
            }
            else if(whcon!='' && whcon!=null){
                query = query+' where '+whcon;
                if(countAll=='All'){
                    totalQuery = totalQuery+' where '+whcon;
                }
            }
            query = query+' LIMIT :limitSize OFFSET :offset';
            //String query = 'SELECT ' + s + ' FROM '+obj+' where '+whcon;
            System.debug('query---'+query+'---'+countAll);  
            System.debug('query---'+Database.query(query)); 
            lst_allrecords =  Database.query(query);
            if(countAll=='All'){
                System.debug('totalQuery---'+Database.query(totalQuery)); 
                lst_totalrecords =  Database.query(totalQuery);
                relObj.recordCount  = lst_totalrecords.size();
            }
            relObj.allRecords  = lst_allrecords;
            
        }catch(Exception e){

        }
        System.debug('relObj---'+relObj); 
        return relObj;
    }

    public class RelatedRecords {    
        @AuraEnabled  
        public List < sObject > allRecords; 
        @AuraEnabled
        public Integer recordCount=0;   
        @AuraEnabled
        public String objectprlName;     
    }  
    

}