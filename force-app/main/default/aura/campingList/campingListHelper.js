({
    createItem : function(component, newItem) {
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