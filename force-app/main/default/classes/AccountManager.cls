@RestResource(urlMapping='/Accounts/*/contacts')
global class AccountManager {

    @HttpGet
    global static Account getAccount() {
        RestRequest request = RestContext.request;
        String accId = request.requestURI.substringAfterLast('Accounts/').substringBeforeLast('/contacts');
        return [SELECT Id, Name, (Select Id, name from Contacts) from Account where Id = :accId LIMIT 1];
    }
}