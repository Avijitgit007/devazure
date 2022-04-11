public class MaintenanceRequestHelper {
    
    public static void updateWorkOrders(List<Case> newList, Map<id, Case> oldMap){
        // update workorders
        List<Case> caseList = new List<Case>();
        Map<Id, Case> oldCaseIdToNewCaseMap = new Map<Id, Case>();
        for(Case caseObj : newList)
        {
            if(caseObj.Status != oldMap.get(caseObj.Id).Status && caseObj.Status == 'Closed' 
            && (caseObj.Type == 'Repair' || caseObj.Type == 'Routine Maintenance'))
            {
                caseList.add(caseObj);
                
            }
        }
        
        if(!caseList.isEmpty())
        {
            
            
            List<Work_Part__c> workPartList = new List<Work_Part__c>();
            List<Case> caseListQueried = [Select Id, Vehicle__c, Subject, Equipment__c, Origin, Reason,  (Select Id, Equipment__r.Lifespan_Months__c, Maintenance_Request__c from Work_Parts__r) from Case where Id IN :caseList];
            
            for(Case caseObj: caseListQueried)
            {
                Integer minLifeSpan = null;
                for(Work_Part__c wpObj : caseObj.Work_Parts__r)
                {
                    if((minLifeSpan == null || wpObj.Equipment__r.Lifespan_Months__c < minLifeSpan) && wpObj.Equipment__r.Lifespan_Months__c != null)
                    {
                        minLifeSpan = Integer.valueOf(wpObj.Equipment__r.Lifespan_Months__c);
                    }
                }
                Case cClone = caseObj.clone();
                cClone.Status = 'New';
                cClone.Type = 'Routine Maintenance';
                cClone.Subject = caseObj.Subject!=null?caseObj.Subject:'Routine Maintenance';
                cClone.Date_Reported__c = System.today();
                cClone.Date_Due__c = System.today();
                if(minLifeSpan != null) 
                   cClone.Date_Due__c += minLifeSpan;
                oldCaseIdToNewCaseMap.put(caseObj.id, cClone);
            }
            insert oldCaseIdToNewCaseMap.values();
            for(Case caseObj: caseListQueried)
            {
                for(Work_Part__c wpObj : caseObj.Work_Parts__r)
                {
                    Work_Part__c wpObjClone = wpObj.clone();
                    wpObjClone.Maintenance_Request__c = oldCaseIdToNewCaseMap.get(caseObj.Id).Id;
                    workPartList.add(wpObjClone);
                }
            }
            insert workPartList;
            
        }
    }        
    
}