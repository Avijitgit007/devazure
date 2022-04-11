({
	packItem : function(component, event, helper) {
		var itemVar = component.get('v.item');
        itemVar.Packed__c = true;
        component.set('v.item', itemVar);
        component.find('buttonId').set('disabled', true);
	}
})