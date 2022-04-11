({
	onBoatSelected : function(component, event, helper) {
		var boat = event.getParam('boat');
        component.set('v.id', boat.Id);
        var service = component.find("service");
		service.reloadRecord();
	},
    
    onRecordUpdated : function(component, event, helper)
    {
        var BoatReviews = component.find("BoatReviews");
        var auraMethodResult = BoatReviews.refresh();
    },
    onBoatReviewAdded : function(component, event, helper)
    {
        component.find("tabs").set("v.selectedTabId", "boatreviewtab");
        var BoatReviews = component.find("BoatReviews");
        var auraMethodResult = BoatReviews.refresh();
    }
})