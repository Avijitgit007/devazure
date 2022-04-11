@isTest
private class BillingCalloutServiceTest {
  //Implement mock callout tests here
  /*private static testMethod void method1()
  {
      Test.setMock(WebServiceMock.class,  new BillingCalloutServiceMock());
      ServiceCredentials__c sc = new ServiceCredentials__c();
      sc.Username__c = 'abc';
      sc.Password__c = 'Password__c';
      sc.Name = 'BillingServiceCredential';
      insert sc;
      Account a = new Account();
      a.name = 'something';
      insert a;
      Opportunity opp = new Opportunity();
      opp.Name = 'xyz';
      opp.StageName = 'Prospecting';
      opp.CloseDate = System.today()+10;
      opp.AccountId = a.Id;
      insert opp;
      Project__c proj = new Project__c();
      proj.Status__c = '';
      proj.Opportunity__c = opp.id;
      insert proj;
      Test.startTest();
      proj.Status__c = 'Billable';
      update proj;
      test.stopTest();
      Project__c projects = [Select Id, Status__c from Project__c where id = :proj.Id];
      System.assertEquals('Billed', projects.Status__c);
  }*/
}