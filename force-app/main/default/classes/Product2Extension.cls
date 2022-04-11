public class Product2Extension {
    
    public List<ProductWrapper> productsToInsert {get;set;}
   
    public Product2Extension(ApexPages.StandardController stdController){
        productsToInsert = new List<ProductWrapper>();
        addRows();
    }
    
    public void AddRows(){
        for ( Integer i=0; i<Constants.DEFAULT_ROWS; i++ ){
            productsToInsert.add( new ProductWrapper() );
        }
    }
    public List<SelectOption> GetFamilyOptions()
    {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption(Constants.SELECT_ONE, Constants.SELECT_ONE));
        for( Schema.PicklistEntry f : Constants.PRODUCT_FAMILY)
        {
            options.add(new SelectOption(f.getLabel(), f.getValue()));
        }    
        
        return options;
    }
    public List<ChartHelper.ChartData> GetInventory(){
        return ChartHelper.GetInventory();
    }
    
    public PageReference Save(){
        SavePoint sp = Database.setSavepoint();
        try {
            List<Product2> prodsToInsert = new List<Product2>();
            List<PricebookEntry> pbeToInsert = new List<PricebookEntry>();
            List<ProductWrapper> validatedItems = new List<ProductWrapper>();
            for(ProductWrapper pw : productsToInsert)
            {
                if(pw.productRecord.Name != null && pw.productRecord.Family != Constants.SELECT_ONE && pw.productRecord.isActive != null && pw.productRecord.Initial_Inventory__c != null && pw.pricebookEntryRecord.UnitPrice != 0)
                    validatedItems.add(pw);
            }
            for(ProductWrapper pw : validatedItems)
            {
                prodsToInsert.add(pw.productRecord);
            }
            insert prodsToInsert;
            
            for(Integer i=0; i< prodsToInsert.size(); i++)
            {
                PricebookEntry pbe = validatedItems[i].pricebookEntryRecord;
                pbe.Pricebook2Id = Constants.STANDARD_PRICEBOOK_ID;
                pbe.Product2Id = prodsToInsert[i].Id;
                pbeToInsert.add(pbe);
            }
            insert pbeToInsert;
            //If successful clear the list and display an informational message
            apexPages.addMessage(new ApexPages.message(ApexPages.Severity.INFO,prodsToInsert.size()+' Inserted'));
            productsToInsert.clear();   //Do not remove
            addRows();  //Do not remove
        } catch (Exception e){
            Database.rollback(sp);
            apexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR,Constants.ERROR_MESSAGE));
        }
        return Apexpages.currentPage();
    }
    
    public class ProductWrapper
    {
        public Product2 productRecord{get;set;}
        public PricebookEntry pricebookEntryRecord{get;set;}
        
        public ProductWrapper()
        {
            productRecord = new Product2();
            pricebookEntryRecord = new PricebookEntry();
            pricebookEntryRecord.UnitPrice = 0;
            
        }
    }
}