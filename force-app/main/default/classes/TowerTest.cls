@IsTest
public class TowerTest {
    @IsTest
	public static void towertestone()
    {
        Account a = new Account();
        a.Name = 'Account1';
        insert a;
        Tower__c t = new Tower__C();
        t.Name = 't1';
        t.State__c = a.Id;
        t.Tower_Location__Latitude__s = 40.4906;
        t.Tower_Location__Longitude__s = -111.11;
        insert t;
        Test.startTest();
        TowerMapControllerClass.getAllTowers();
        Test.stopTest();
    }
}