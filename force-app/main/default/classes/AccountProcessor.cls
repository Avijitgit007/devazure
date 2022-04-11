global class AccountProcessor{
  @future
  public static void countContacts(List<Id> recordIds) {
    List<Account> ac = new List<Account>();
    
    for (AggregateResult r : [SELECT AccountId AcctId, Count(id) ContactCount 
                           FROM Contact 
                           WHERE AccountId in: recordIds
                           GROUP BY AccountId]){
        Account a = new Account();
        a.Id = (Id) r.get('AcctId');
        a.Number_of_Contacts__c = (Integer) r.get('ContactCount');
        ac.add(a);
    }    
    update ac;    
   }
}