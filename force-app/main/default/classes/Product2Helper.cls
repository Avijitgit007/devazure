public class Product2Helper {

    /**
     * @name COLLABORATION_GROUP
     * @description List of CollaborationGroup used in both business and test logic
    **/
    static List<CollaborationGroup> COLLABORATION_GROUP = [
        SELECT Id
        FROM CollaborationGroup
        WHERE Name = :Constants.INVENTORY_ANNOUNCEMENTS
        OR Name = :('TEST'+Constants.INVENTORY_ANNOUNCEMENTS)
        LIMIT 1
    ];

    /**
     * @name afterUpdate
     * @description called by product2 Trigger on After Update
     * @param List<Product2> newList
     * @param List<Product2> oldList
    **/
    public static void AfterUpdate(List<Product2> newList){
        //ToDo: Declare a List of Product2 records named needsAnnouncement
        List<Product2> needsAnnouncement = new List<Product2>();
        //ToDo: Declare a Map of Strings to Inventory_Setting__mdt records
        Map<String, Inventory_Setting__mdt> invSetMap = new Map<String, Inventory_Setting__mdt>();
        //ToDo: Loop through a query of Inventory_Setting__mdt records and populate the Map with Name as the key
        for(Inventory_Setting__mdt obj :[SELECT QualifiedApiName, Low_Quantity_Alert__c FROM Inventory_Setting__mdt])
        {
            invSetMap.put(obj.QualifiedApiName, obj);
        }
        //ToDo: Loop through the Products in newList
        for(Product2 prod : newList)
        {
            if(prod.Quantity_Remaining__c < invSetMap.get(prod.Family).Low_Quantity_Alert__c)
            {
                needsAnnouncement.add(prod);
            }
        }
        // Use the corresponding Inventory Setting record to determine the correct Low Quantity Alert
        // If the Product's Quantity Remaining has been changed to less than the Low Quantity Alert
        //      add it to the needsAnnouncement list

        //ToDo: Pass records to the postAlerts method
        Product2Helper.PostAlerts(needsAnnouncement);
    }

    /**
     * @name postAlerts
     * @description called by product2 Trigger on After Update
     * @param List<Product2> productList
    **/
    public static void PostAlerts(List<Product2> productList){
        List<ConnectApi.AnnouncementInput> toPost = new List<ConnectApi.AnnouncementInput>();
        for ( Product2 p : productList ){
            ConnectApi.AnnouncementInput obj = new ConnectApi.AnnouncementInput();
            obj.expirationDate = System.now().addDays(1);
            obj.sendEmails = false;
            obj.body = new ConnectApi.MessageBodyInput();
            ConnectApi.TextSegmentInput x = new ConnectApi.TextSegmentInput();
            x.text = p.Name + Constants.INVENTORY_LEVEL_LOW;
            
            obj.body.messageSegments = new List<ConnectApi.TextSegmentInput>{x};
            toPost.add(obj);
            // ToDo: Construct a new AnnouncementInput for the Chatter Group so that it:
            // expires in a day
            // does not notify users via email.
            // and has a text body that includes the name of the product followed by the INVENTORY_LEVEL_LOW constant
        }
        AnnouncementQueueable queueObj = new AnnouncementQueueable();
        queueObj.toPost = toPost;
        System.enqueueJob(queueObj);
        // ToDo: Create and enqueue an instance of the announcementQueuable class with the list of Products
    }
}