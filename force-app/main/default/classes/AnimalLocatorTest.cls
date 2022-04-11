@isTest
public class AnimalLocatorTest {
  @isTest static void testPostCallout() {
      Test.setMock(HttpCalloutMock.class, new AnimalLocatorMock());
        String name = AnimalLocator.getAnimalNameById(1);
    }
}