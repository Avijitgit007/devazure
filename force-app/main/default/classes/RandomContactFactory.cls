public class RandomContactFactory{
    public static List<Contact> generateRandomContacts(Integer numConts, String lastName) {
        
        Account accts = new Account(Name='TestAccount');        
       
        insert accts;
        
        List<Contact> conts = new List<Contact>();
        for (Integer j=0;j<numConts;j++) {
            
            // For each account just inserted, add Contact
           
            conts.add(new Contact(LastName=lastName,
                                  firstName ='Test ' + j, 
                                   AccountId=accts.Id));
           
        }
        // Insert all Contacts for all accounts.
        
        
        return conts;
    }
}