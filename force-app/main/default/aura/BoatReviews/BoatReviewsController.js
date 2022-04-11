({
	doInit : function(component, event, helper) {
		helper.onInit(component, event, helper);
	},
    onUserInfoClick :  function(component, event, helper) {
        var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
            "recordId": event.currentTarget.getAttribute("data-userid")
        });
        navEvt.fire();
	}
})