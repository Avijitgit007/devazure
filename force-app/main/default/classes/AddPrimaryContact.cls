public class AddPrimaryContact implements Queueable {
    
    private Contact con;
    private String state;
    
    public AddPrimaryContact(Contact con, String state) {
        this.con = con;
        this.state = state;
    }

    public void execute(QueueableContext context) {
        List<Contact> conList = new List<Contact>();
        List<Account> accounts = [select id from account where billingstate = :state LIMIT 200];
        for(Account a : accounts)
        {
            Contact conCopy = con.clone();
            conCopy.AccountId = a.id;
            conList.add(conCopy);
        }
        insert conList;
    }
    
}