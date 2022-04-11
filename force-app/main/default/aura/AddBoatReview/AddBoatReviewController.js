({
    onSave : function(component, event, helper) {
        component.find("service").saveRecord(function(saveResult) {
            if (saveResult.state === "SUCCESS" || saveResult.state === "DRAFT") {
                
                var resultsToast = $A.get("e.force:showToast");
                if(resultsToast)
                {
                    resultsToast.setParams({
                        "title": "Saved",
                        "message": "The record was saved."
                    });
                    resultsToast.fire();
                    helper.onInit();
                    
                }
                else
                {
                    alert('The record was saved.');
                    helper.onInit();
                }
                
                
            } else if (saveResult.state === "INCOMPLETE") {
                // handle the incomplete state
                console.log("User is offline, device doesn't support drafts.");
            } else if (saveResult.state === "ERROR") {
                // handle the error state
                console.log('Problem saving contact, error: ' + JSON.stringify(saveResult.error));
            } else {
                console.log('Unknown problem, state: ' + saveResult.state + ', error: ' + JSON.stringify(saveResult.error));
            }
        var action = component.getEvent('BoatReviewAdded');
        action.fire();
        });
        
    },
    onRecordUpdated : function(component, event, helper)
    {
        var resultsToast = $A.get("e.force:showToast");
        if(resultsToast)
        {
            resultsToast.setParams({
                "title": "Updated",
                "message": "the record has been updated."
            });
            resultsToast.fire();
        }
        else
        {
            alert('the record has been updated.');
        }
    },
    doInit : function(component, event, helper)
    {
        helper.onInit(component, event, helper);
    }
})