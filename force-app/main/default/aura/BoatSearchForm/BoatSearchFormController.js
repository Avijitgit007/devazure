({
    doInit : function(component, event, helper) {
        var isEnabled = $A.get("e.force:createRecord");
        if(isEnabled)
        {
            component.set('v.showNewButton', true);
        }
        var action = component.get("c.getAllBoatTypes");
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                var boatTypeList = response.getReturnValue();
                var opts = [
                    { "class": "optionClass", label: "All Types", value: "", selected: "true"
                    }
                ];
                if(boatTypeList != undefined && boatTypeList.length>0)
                {
                    for(var i=0; i<boatTypeList.length; i++)
                    {
                        opts.push({ "class": "optionClass", label: boatTypeList[i].Name, value: boatTypeList[i].Id
                                  });
                    }
                }
                component.set("v.options", opts);
            }
        });
        $A.enqueueAction(action);
    },
    openNewBoatType : function(component, event, helper)
    {
        var createRecAction = $A.get("e.force:createRecord");
        createRecAction.setParams({
            "entityApiName": "Boat__c",
            "defaultFieldValues": {
                'Boat_Type__c' : component.get('v.selectedValue')
            }
        });
        createRecAction.fire();
    },
    onFormSubmit : function(component, event, helper)
    {
        var action = component.getEvent("formsubmit");
        var formDataObj = {};
        formDataObj.boatTypeId = component.get('v.selectedValue');
        action.setParams({
            formData : formDataObj
        });
        action.fire();
    }
})