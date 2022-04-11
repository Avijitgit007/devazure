public with sharing class WarehouseCalloutService {

    private static final String WAREHOUSE_URL = 'https://th-superbadge-apex.herokuapp.com/equipment';
    
    @future(callout=true)
    public static void runWarehouseEquipmentSync(){
        Http httpService = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint(WAREHOUSE_URL);
        req.setMethod('GET');
        HttpResponse res = httpService.send(req);
        System.debug(res.getBody());
        List<EquipmentWrap> wrapList = (List<EquipmentWrap>)JSON.deserialize(res.getBody(), List<EquipmentWrap>.class);
        if(wrapList != null && !wrapList.isEmpty())
        {
            List<Product2> prodListToUpsert = new List<Product2>();
            for(EquipmentWrap wrap : wrapList)
            {
                Product2 prod = new Product2();
                if(wrap.Id != null)
                {
                    prod.Id = wrap.Id;
                }
                prod.Replacement_Part__c = wrap.replacement;
                prod.Current_Inventory__c = wrap.quantity;
                prod.Name = wrap.Name;
                prod.Lifespan_Months__c = wrap.lifespan;
                prod.Maintenance_Cycle__c = wrap.maintenanceperiod;
                prod.Cost__c = wrap.cost;
                prod.Warehouse_SKU__c = wrap.sku;
                prodListToUpsert.add(prod);
            }
            upsert prodListToUpsert Warehouse_SKU__c;
        }
    }
    
    
    public class EquipmentWrap
    {
        Id id;
        Boolean replacement;
        Integer quantity;
        String name;
        Integer maintenanceperiod;
        Integer lifespan;
        Decimal cost;
        String sku;
    }

}