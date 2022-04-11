trigger BatchApexErrorTrigger on BatchApexErrorEvent (after insert) {
    
    List<BatchLeadConvertErrors__c> lst_bactherrtrg = new List<BatchLeadConvertErrors__c>();
    for(BatchApexErrorEvent evtr : Trigger.New){
        BatchLeadConvertErrors__c newbact = new BatchLeadConvertErrors__c();
        newbact.AsyncApexJobId__c = evtr.AsyncApexJobId;
        newbact.Records__c = evtr.JobScope;
        newbact.StackTrace__c = evtr.StackTrace;
        
        lst_bactherrtrg.add(newbact);
    }
    
    insert lst_bactherrtrg;
}