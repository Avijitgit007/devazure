({
    clickCreateItem : function(component, event, helper) {
    var validCamping = component.find('campingform').reduce(function (validSoFar, inputCmp) {
            // Displays error messages for invalid fields
            inputCmp.showHelpMessageIfInvalid();
            return validSoFar && inputCmp.get('v.validity').valid;
        }, true);
            
        if(validCamping){
            var newCampingItem = component.get("v.newItem");
            helper.createItem(component,newCampingItem);
            var campings = component.get("v.items");
            var item = JSON.parse(JSON.stringify(newCampingItem));
            
            campings.push(item);
            
            component.set("v.items",campings);
            component.set("v.newItem",{ 'sobjectType': 'Camping_Item__c','Name': '','Quantity__c': 0,
                                       'Price__c': 0,'Packed__c': false });
        }
    },
    doInit : function(component, event, helper)
    {
        var serverCall = component.get('c.getItems');
        serverCall.setCallback(this, function(response){
            if(response.getState() === 'SUCCESS')
            {
                var returnedData = response.getReturnValue();
                component.set('v.items', returnedData);
            }
        });
        $A.enqueueAction(serverCall);
    },
    handleAddItem : function(component, event, helper)
    {
        var newItem = event.getParam('item');
        helper.createItem(component, newItem);
        var serverCall = component.get('c.saveItem');
        serverCall.setParams({
            'item' : newItem 
        });
        serverCall.setCallback(this, function(response){
            if(response.getState() === 'SUCCESS')
            {
                var items = component.get('v.items');
                var copyItem = JSON.parse(JSON.stringify(newItem));
                items.push(copyItem);
                component.set('v.items', items);
            }
        });
        $A.enqueueAction(serverCall);
        
    }
})