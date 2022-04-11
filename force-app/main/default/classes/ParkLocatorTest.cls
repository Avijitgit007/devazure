@IsTest
public class ParkLocatorTest {
  public static testMethod void testSOAP()
    {
        Test.setMock(WebServiceMock.class, new ParkServiceMock());
        String[] res = ParkLocator.country('India');
        System.assertEquals('Something', res[0]);
    }
        
}