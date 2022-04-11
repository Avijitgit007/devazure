({
	 onFullDetails: function(component, event, helper) {
        var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
            "recordId": component.get("v.boat.Id")
        });
        navEvt.fire();
    },
    doInit : function(component, event, helper) {
        var isEnabled = $A.get("e.force:navigateToSObject");
        if(isEnabled)
        {
            component.set('v.showButton', true);
        }
    }
})