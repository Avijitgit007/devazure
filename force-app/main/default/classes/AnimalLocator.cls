public class AnimalLocator {
    public static String getAnimalNameById(Integer index)
    {
        String returnValue;
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://th-apex-http-callout.herokuapp.com/animals/'+index);
        request.setMethod('GET');
        HttpResponse response = http.send(request);
        if (response.getStatusCode() == 200) {
            Map<String, AnimalLocator.Animal> results = (Map<String, AnimalLocator.Animal>) JSON.deserialize(response.getBody(), Map<String, AnimalLocator.Animal>.class);
            AnimalLocator.Animal animal = (AnimalLocator.Animal) results.get('animal');
            returnValue =  animal.name;
        }
        return returnValue;
    }
    
    
    public class Animal
    {
        public String name;
        public String eats;
        public String says;
        
    }
}