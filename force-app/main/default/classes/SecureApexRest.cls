@RestResource(urlMapping='/secureApexRest')
global with sharing class SecureApexRest {
    @HttpGet
    global static Contact doGet(){
        Id recordId = RestContext.request.params.get('id');
        Contact result;
        List<Contact> results = new list<contact>();
        if (recordId == null){
            throw new FunctionalException('Id parameter is required');
        }
         try{
             results = [SELECT id, Name, Secret_Key__c FROM Contact WHERE Id = :recordId WITH SECURITY_ENFORCED];
            
        }catch( QueryException e ) {

            System.debug( e.getMessage() );

        }
            if (!results.isEmpty()) {
                result = results[0];
            }
        
        return result;
    }
    public class FunctionalException extends Exception{}
    public class SecurityException extends Exception{}
}