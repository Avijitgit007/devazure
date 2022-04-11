public with sharing class MetadataAPIcls {
    
    public static List<RelatedRecords> lst_calMetadata = new List<RelatedRecords>();
    public static List<MetadataService.Metadata> lst_AllMetaData = new List<MetadataService.Metadata>();
    //public static MetadataService.MetadataPort service =  new MetadataService.MetadataPort();

    @AuraEnabled
    public static list<RelatedRecords> csvFileRead(Id contentDocumentId){
        list<Account> accountInsertList = new list<Account>();
        List<RelatedRecords> lst_relObj = new List<RelatedRecords>();
        if(contentDocumentId != null) {
            list<String> csvRowData =  new list<String>();
            // Fetch File Data based on the basic of document id 
            ContentVersion contentVersionObj = [SELECT Id, VersionData FROM ContentVersion WHERE ContentDocumentId =:contentDocumentId];
            // split the file data
            list<String> csvRecordsList = contentVersionObj.VersionData.toString().split('\n');

            for(Integer i = 1; i < csvRecordsList.size(); i++){
                RelatedRecords relObj = new RelatedRecords();
                csvRowData = csvRecordsList[i].split(',');
                //Boolean b = (Boolean) csvRowData[3];
                System.debug('csvRowData====> '+'---'+csvRowData[3]);
                relObj.ruleName = csvRowData[0];
                relObj.objectName = csvRowData[1]; // accNamei                
                relObj.componentType = csvRowData[2];
                if(csvRowData[3].contains('TRUE')){
                    System.debug('0--->');	
                    relObj.status = true;
                }    
                if(relObj.componentType == 'PB'){
                    relObj.vrNumber = Integer.valueOf(csvRowData[4]);
                    relObj.duraPBId = csvRowData[5];
                }
                lst_relObj.add(relObj);
                lst_calMetadata.add(relObj);
                
            }
            try{    
                if(!lst_calMetadata.isEmpty()) {
                    System.debug('1--->');	
                    changeMetadata();
                }
            }
            catch (Exception ex) {
                throw new AuraHandledException(ex.getMessage());
            } 
        }
        return lst_relObj;    
    }

    @AuraEnabled
    public static String changeMetadata(){
        System.debug('2--->');
        List<MetadataService.Metadata> lst_AllMetaData = new List<MetadataService.Metadata>();
        MetadataService.MetadataPort service = new MetadataService.MetadataPort();
        service.SessionHeader = new MetadataService.SessionHeader_element();
        service.SessionHeader.sessionId = Utils.getSessionIdFromVFPage(Page.session);
        service.timeout_x = 40000;
        //service = createService();
        List<String> lst_validatio_Rule = new List<String>();
        List<String> lst_wf_Rule = new List<String>();
        Map<String,Boolean> map_name_status_VR = new Map<String,Boolean>();
        Map<String,Boolean> map_du_status_PB = new Map<String,Boolean>();
        Map<String,Integer> map_du_vr_PB = new Map<String,Integer>();


        if(!lst_calMetadata.isEmpty()) {
            for(RelatedRecords rel : lst_calMetadata){
                if(rel.componentType == 'Validation Rule'){
                    System.debug('rel.ruleName====> '+rel.objectName+'---'+rel.ruleName+'--'+rel.status);
                    lst_validatio_Rule.add(rel.objectName+'.'+rel.ruleName);
                    map_name_status_VR.put(rel.objectName+'.'+rel.ruleName,rel.status);
                    System.debug('validations--->'+map_name_status_VR);	
                }
                if(rel.componentType == 'Workflow Rule'){
                    lst_wf_Rule.add(rel.objectName+'.'+rel.ruleName);
                    map_name_status_VR.put(rel.objectName+'.'+rel.ruleName,rel.status);                    
                }
                //map_name_status_VR.put(rel.objectName+'.'+rel.ruleName,rel.status);
                if(rel.componentType == 'PB'){
                    map_du_status_PB.put(rel.duraPBId,rel.status);
                    map_du_vr_PB.put(rel.duraPBId,rel.vrNumber);
                }
            }
        }
       

        if(!lst_validatio_Rule.isEmpty()) {
            //MetadataService.MetadataPort service = createService();
            List<MetadataService.ValidationRule> validations =
            (List<MetadataService.ValidationRule>) service.readMetadata('ValidationRule', lst_validatio_Rule).getRecords();
            System.debug('validations--->'+validations);	
            for(MetadataService.ValidationRule quickValidation : validations){
                System.debug('active--->'+quickValidation.fullName+'----'+map_name_status_VR.get(quickValidation.fullName));
                quickValidation.active = map_name_status_VR.get(quickValidation.fullName);
                //Boolean.valueOf(map_name_status_VR.get(quickValidation.fullName));
                System.debug('active2--->'+quickValidation.active);
                lst_AllMetaData.add(quickValidation);
            }        
        }

        if(!lst_wf_Rule.isEmpty()) {
            //MetadataService.MetadataPort service = createService();
            List<MetadataService.WorkflowRule> workflowRules =
            (List<MetadataService.WorkflowRule>) service.readMetadata('WorkflowRule', lst_wf_Rule).getRecords();
            //System.debug('validations--->'+validations);	
            for(MetadataService.WorkflowRule quickwf : workflowRules){
                System.debug('active--->'+quickwf.fullName+'----'+map_name_status_VR.get(quickwf.fullName));
                quickwf.active = map_name_status_VR.get(quickwf.fullName);
                //Boolean.valueOf(map_name_status_VR.get(quickValidation.fullName));
                System.debug('active2--->'+quickwf.active);
                lst_AllMetaData.add(quickwf);
            }          
        }

        if(!map_du_status_PB.isEmpty()) {
            for(String strduId : map_du_status_PB.keyset()){
                String strMetadata = '';
                if(map_du_status_PB.get(strduId)){
                    strMetadata  = '{"Metadata":{"activeVersionNumber":'+map_du_vr_PB.get(strduId)+'}}';
                }
                else{
                    strMetadata  = '{"Metadata":{"activeVersionNumber":null}}';
                }
                System.debug('flow--->'+strduId+'----'+strMetadata);
                //strMetadata = strMetadata.replace('\"','\\"');
                //FlowManagerController.updateFlow(strduId,strMetadata);
                FlowManagerController.formFlow(strduId,'');
            }
        }


        if(!lst_AllMetaData.isEmpty()) {
            List<MetadataService.SaveResult> results = service.updateMetadata(lst_AllMetaData);
		    System.debug(results[0]);
            return 'Success';           
        }


        return '';
    }



    public static MetadataService.MetadataPort createService()
    { 
        MetadataService.MetadataPort service = new MetadataService.MetadataPort();
        service.SessionHeader = new MetadataService.SessionHeader_element();
        service.SessionHeader.sessionId = UserInfo.getSessionId();
        service.timeout_x = 40000;
        return service;     
    }    

    /*public static void validationRule(List<String> valRule, Map<String,String> map_name_status_VR){
        List<MetadataService.Metadata> lst_ValMetaData = new List<MetadataService.Metadata>();
        MetadataService.MetadataPort service = createService();
        List<MetadataService.ValidationRule> validations =
        (List<MetadataService.ValidationRule>) service.readMetadata('ValidationRule', valRule).getRecords();
        System.debug('validations--->'+validations);	
        for(MetadataService.ValidationRule quickValidation : validations){
            System.debug('active--->'+quickValidation.active);
            quickValidation.active = map_name_status_VR.get(quickValidation.fullName);
            lst_AllMetaData.add(quickValidation);
        }
        //return lst_ValMetaData;
    }*/

    public class RelatedRecords {    
        @AuraEnabled  
        public List < sObject > allRecords; 
        @AuraEnabled
        public Integer recordCount=0;   
        @AuraEnabled
        public String objectName;  
        @AuraEnabled
        public String ruleName;     
        @AuraEnabled
        public String componentType;
        @AuraEnabled
        public Boolean status=false;
        @AuraEnabled
        public Integer vrNumber;
        @AuraEnabled
        public String duraPBId;

    }  
}