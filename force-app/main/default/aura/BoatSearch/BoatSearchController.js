({
	onFormSubmit : function(component, event, helper) {
        var formData = event.getParam('formData');
        var BSRcmp = component.find("BSRcmp");
        var auraMethodResult = BSRcmp.search(formData.boatTypeId);
	}
})