@isTest
private class TestVerifyDate{

    @isTest static void testCheckDates() {
        Date mydate = VerifyDate.CheckDates(Date.newInstance(2016, 12,1),Date.newInstance(2016, 12,30));
        System.assertEquals(Date.newInstance(2016, 12,30), mydate);
    }
    @isTest static void testCheckDates2() {
        Date mydate = VerifyDate.CheckDates(Date.newInstance(2016, 11,1),Date.newInstance(2016, 12,30));
        System.assertEquals(Date.newInstance(2016, 11,30), mydate);
    }
   
}