public class ProjectCalloutService {
    //Complete the implementation for business and callout logic
    @InvocableMethod
    public static void postOpportunityToPMS(List<Id> oppIds){
        if(oppIds != null)
        {
            Opportunity opp = [SELECT Id, Name, StageName, account.Name, closeDate, amount from Opportunity where Id = :oppIds[0] LIMIT 1];
            System.enqueueJob(new QueueablePMSCall(opp));
        }
    }
    
    public class OppWrap
    {
        public String opportunityId;
        public String opportunityName;
        public String accountName;
        public String closeDate;
        public Decimal amount;
    }
    
    public class QueueablePMSCall  implements System.Queueable, Database.AllowsCallouts
    {
        public Opportunity opp;
        public QueueablePMSCall(Opportunity oppInput)
        {
            opp = oppInput;
        }
        
        public void execute(QueueableContext context) {
            Http httpObj = new Http();
            HttpRequest req = new HttpRequest();
            req.setEndpoint('callout:ProjectService');
            req.setMethod('POST');
            ServiceTokens__c stObj = ServiceTokens__c.getValues('ProjectServiceToken');
            req.SetHeader('token', stObj.Token__c);
            OppWrap wrap = new OppWrap();
            wrap.opportunityId = opp.id;
            wrap.opportunityName = opp.Name;
            wrap.accountName = opp.Account.Name;
            wrap.closeDate = String.valueOf(opp.closeDate);
            wrap.amount = opp.amount;
            req.setBody(JSON.serialize(wrap));
            req.setHeader('Content-Type', 'application/json;charset=UTF-8');
            system.debug(req.getBody());
            HttpResponse res = httpObj.send(req);
            if(res.getStatusCode() == 201)
            {
                opp.StageName = 'Submitted Project';
            }
            else
            {
                opp.StageName = 'Resubmit Project';
            }
            update opp;
        }
    }
}