({
    createItem : function(component, newItem) {
        
        var evtAction = component.get('c:addItem');
        evtAction.setParams({
            'item' : newItem
        });
        evtAction.fire();
        var blankObj = JSON.parse("{'sobjecttype' : 'Camping_Item__c','Name':'', 'Price__c':0, 'Quantity__c':0, 'Packed__c':'false'}");
        component.set('v.newItem', blankObj);
    }
})