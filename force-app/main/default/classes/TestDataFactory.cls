/**
 * @name TestDataFactory
 * @description Contains methods to construct and/or validate commonly used records
**/
public class TestDataFactory {

    private static final Id STANDARD_PRICEBOOK_ID = (Test.isRunningTest())
            ? Test.getStandardPricebookId()
            : [SELECT id FROM PriceBook2 WHERE isStandard = true LIMIT 1].id;

    /**
     * @name constructCollaborationGroup
     * @description
    **/
    public static CollaborationGroup ConstructCollaborationGroup(){ 
        return new CollaborationGroup(
            Name = 'TEST' + Constants.INVENTORY_ANNOUNCEMENTS,
            CanHaveGuests = false,
            CollaborationType = 'Public',
            IsArchived = false,
            IsAutoArchiveDisabled = false
        );
    }

    /**
     * @name CreateProducts
     * @description constructs a List of Product2 records for unit tests
    **/
    public static List<Product2> constructProducts(Integer cnt){
        List<Schema.PickListEntry> familyValueList = Product2.Family.getDescribe().getPickListValues();
        Integer possibleFamilyValues = familyValueList.size();
        
        List<Product2> productList = new List<Product2>();
        for (Integer i = 0; i < cnt; i++) {
            productList.add(new Product2(
                Name = 'Product ' + (i + 1),
                Family = familyValueList[Math.mod(i, possibleFamilyValues)].getValue(),
                Initial_Inventory__c = 10,
                IsActive = true
            ));
        }
        return productList;
    }

    /**
     * @name CreatePricebookEntries
     * @description constructs a List of PricebookEntry records for unit tests
    **/
    public static List<PricebookEntry> constructPricebookEntries(List<Product2> productList){
        List<PricebookEntry> pbes = new List<PricebookEntry>();
        for (Product2 product: productList) { 
            pbes.add(new PricebookEntry(
                Pricebook2Id = STANDARD_PRICEBOOK_ID,
                Product2Id = product.id,
                IsActive = true,
                UnitPrice = 1
            ));
        } 
        return pbes;
    }

    /**
     * @name CreateAccounts
     * @description constructs a List of Account records for unit tests
    **/
    public static List<Account> constructAccounts(Integer cnt){
        List<Account> accts = new List<Account>();
        for (Integer i = 0; i < cnt; i++) {
            accts.add(new Account(
                Name = 'Account ' + (i + 1)
            ));
        }
        return accts;
    }

    /**
     * @name CreateContacts
     * @description constructs a List of Contacxt records for unit tests
    **/
    public static List<Contact> constructContacts(Integer cnt, List<Account> accts){
        Integer possibleAccountValues = accts.size();
        
        List<Contact> contactList = new List<Contact>();
        for (Integer i = 0; i < cnt; i++) {
            contactList.add(new Contact(
                LastName = 'Contact ' + (i + 1),
                AccountId = accts[Math.mod(i, possibleAccountValues)].id
            ));
        }
        return contactList;
    }

    /**
     * @name CreateOrders
     * @description constructs a List of Order records for unit tests
    **/
    public static List<Order> constructOrders(Integer cnt, List<Account> accts){
        Integer possibleAccountValues = accts.size();
        
        List<Order> ords = new List<Order>();
        for (Integer i = 0; i < cnt; i++) {
            ords.add(new Order(
                Name = 'Order ' + (i + 1),
                AccountId = accts[Math.mod(i, possibleAccountValues)].id,
                EffectiveDate = Date.today(),
                Pricebook2Id = STANDARD_PRICEBOOK_ID,
                Status = 'Draft'
            ));
        }
        return ords;
    }

    /**
     * @name CreateOrderItems
     * @description constructs a List of OrderItem records for unit tests
    **/
    public static List<OrderItem> constructOrderItems(Integer cnt, List<Pricebookentry> pbes, List<Order> ords){
        Integer possiblePricebookEntryValues = pbes.size();
        Integer possibleOrderValues = ords.size();

        List<OrderItem> orderItemList = new List<OrderItem>();
        for (Integer i = 0; i < cnt; i++) {
            orderItemList.add(new OrderItem(
                OrderId = ords[Math.mod(i, possibleOrderValues)].id,
                PriceBookEntryId = pbes[Math.mod(i, possiblePricebookEntryValues)].id,
                Quantity = Constants.DEFAULT_ROWS,
                UnitPrice = 1
            ));
        }
        
        return orderItemList;
    }

    /**
     * @name SetupTestData
     * @description Inserts accounts, contacts, Products, PricebookEntries, Orders, and OrderItems.
    **/
    public static void InsertTestData(Integer cnt){
        
        CollaborationGroup cg = constructCollaborationGroup();
        if([SELECT Id from CollaborationGroup where Name = :cg.Name] != null)
        {
            
        }
        else
        {
            insert cg;
        }
        List<Product2> productList = constructProducts(cnt); 
        insert productList;
        
        List<PricebookEntry> pbes = constructPricebookEntries(productList);
        insert pbes;
        
        List<Account> accts = constructAccounts(cnt);
        insert accts;
        insert constructContacts(cnt, accts);
        
        List<Order> ords = constructOrders(cnt, accts);
        insert ords;
        insert constructOrderItems(cnt, pbes, ords);
    }
    public static void VerifyQuantityOrdered(Product2 originalProduct, Product2 updatedProduct, Integer qtyOrdered)
    {
        System.assertEquals(
            originalProduct.Quantity_Ordered__c + qtyOrdered,
            updatedProduct.Quantity_Ordered__c,
            'error on Quantity_Ordered__c update'
            );
    }
}