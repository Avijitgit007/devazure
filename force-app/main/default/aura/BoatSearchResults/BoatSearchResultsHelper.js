({
    onSearch : function(component) {
        var action = component.get("c.getBoats");
        var boatTypeId = component.get('v.boatTypeId');
        action.setParams({
            boatTypeId : boatTypeId
        });   
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                var boatList = response.getReturnValue();
                console.log('boatlist'+JSON.stringify(boatList));
                component.set("v.boats", boatList);
            }
        });
        $A.enqueueAction(action);
    }
})