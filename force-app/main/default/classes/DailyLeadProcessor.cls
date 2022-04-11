global class DailyLeadProcessor implements Schedulable {

    global void execute(SchedulableContext ctx) {
        List<Lead> lList = [SELECT ID, LeadSource FROM Lead where LeadSource = '' LIMIT 200];
        for(lead l : lList)
        {
            l.LeadSource = 'Dreamforce';
        }
        update llist;
    }
    
}