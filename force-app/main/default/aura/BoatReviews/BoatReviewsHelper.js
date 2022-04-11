({
	onInit : function(component, event, helper) {
		var action = component.get("c.getAll");
        action.setParams({
            boatId : component.get('boat').Id
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                var boatReviewList = response.getReturnValue();
                component.set("v.boatReviews", boatReviewList);
            }
            else if (state === "INCOMPLETE") {
                console.log("Unknown error");
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                 errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
	}
})