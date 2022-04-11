public class LwcLookupController {  
    @AuraEnabled(cacheable=true)  
    public static List<sobject> findRecords(String searchKey, String objectName) {  
      string searchText = '\'' + String.escapeSingleQuotes(searchKey) + '%\'';  
      string query = 'SELECT Id, Name FROM ' +objectName+ ' WHERE Name LIKE '+searchText+' LIMIT 6';  
      return Database.query('SELECT Id, Name FROM ' +objectName+ ' WHERE Name LIKE '+searchText+' LIMIT 6');  
    }  

    @AuraEnabled(cacheable=true)  
    public static List<sobject> findLookUpRecords(String searchKey, String objectName,String serchField,String addFieldname,String recordId,String addfiltercriteria) {  
      
      List<sobject> lst_lookupRecords = new List<sobject>();
      String searchText = '';
      try{
        String query ='';
        query = 'SELECT '+recordId+','+serchField;
        if(addFieldname != null && !String.isBlank(addFieldname)){
            query =  query+ ','+addFieldname; 
        }
        query =  query+' FROM ' +objectName;

        if(searchKey != null && !String.isBlank(searchKey)){
            searchText = '\'' + String.escapeSingleQuotes(searchKey) + '%\'';  
            query =  query+' WHERE '+serchField+' LIKE '+searchText;           
        }      
        if(addfiltercriteria != null && !String.isBlank(addfiltercriteria)){
           if(searchKey != null && !String.isBlank(searchKey)){
              query =  query+' and '+addfiltercriteria;  
           }else{
              query =  query+' WHERE '+addfiltercriteria;
           }
        }     
        query =  query+' LIMIT 5';
        lst_lookupRecords =  Database.query(query);
       
      }catch(Exception e){

      }
      return lst_lookupRecords;
      //string searchText = '\'' + String.escapeSingleQuotes(searchKey) + '%\'';  
      //string query = 'SELECT ContactId,Contact.Name FROM ' +objectName+ ' WHERE Contact.Name LIKE '+searchText+' LIMIT 6';  
      //return Database.query('SELECT '+recordId+','+serchField +' FROM ' +objectName+ ' WHERE '+serchField+' LIKE '+searchText+' LIMIT 6');  
    }  


  }