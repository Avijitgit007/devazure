({
	doInit : function(component, event, helper) {
		helper.onSearch(component);
	},
    
    doSearch : function(component, event, helper) {
        var params = event.getParam('arguments');
        if (params) {
            var boatTypeId = params.boatTypeId;
            component.set('v.boatTypeId', boatTypeId);
            helper.onSearch(component);
        }
    },
    onBoatSelect : function(component, event, helper)
    {
        var boatId = event.getParam('boatId');
        component.set('v.selectedBoatId', boatId);
    }
})