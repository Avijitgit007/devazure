public class BillingCalloutService {
    //Implement business and callout logic methods here
 /*   public static void callBillingService(List<Project__c> newList, Map<Id, Project__c> newMap,
            List<Project__c> oldList, Map<Id, Project__c> oldMap) {

        if(!newList.isEmpty()) {
            Project__c project = newList[0];
            if (project.Status__c == 'Billable' && oldMap.get(project.Id).Status__c != 'Billable') {
                // Get Service Credentials from custom settings
                ServiceCredentials__c credentials = ServiceCredentials__c.getInstance('BillingServiceCredential');
                billProject(project.ProjectRef__c, project.Billable_Amount__c, credentials.Username__c, credentials.Password__c);
            }
        }
    }

    @Future(callout=true)
    private static void billProject(String projectRef, Decimal billAmount, String username, String password) {

        BillingServiceProxy.project project = new BillingServiceProxy.project();
        project.projectRef = projectRef;
        project.billAmount = billAmount;
        project.username = username;
        project.password = password;

        BillingServiceProxy.InvoicesPortSoap11 invoiceCall = new BillingServiceProxy.InvoicesPortSoap11();
        // Make the callout and update the Status if callout is successful
        String response = invoiceCall.billProject(project);

        List<Project__c> projects = new List<Project__c>();
        if(response != null && response.equalsIgnoreCase('OK')) {

            projects = [
                    Select Id, Status__c
                    From Project__c
                    Where ProjectRef__c = :projectRef
            ];
            if(!projects.isEmpty()) {
                projects[0].Status__c = 'Billed';
                update projects;
            }
        }

    }*/
}