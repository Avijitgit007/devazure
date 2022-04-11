trigger ClosedOpportunityTrigger on Opportunity(after insert,after update) {

    List<Task> lst_task = new List<Task>();
    if(Trigger.isInsert || Trigger.isUpdate){
        for(Opportunity opp : Trigger.new){
            if(opp.StageName == 'Closed Won'){
                Task newTask = new Task();
                newTask.subject  = 'Follow Up Test Task';
                newTask.WhatId = opp.Id;
                
                lst_task.add(newTask);
            }
        }
        
        if(lst_task.size()>0){
            insert lst_task;
        }
    }    
}