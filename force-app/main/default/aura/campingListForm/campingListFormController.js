({
	clickCreateItem : function(component, event, helper) {
		var validInputs = true;
        var name = component.find('name');
        var qty = component.find('quantity');
        var price = component.find('price');
        var packed = component.find('packed');
        
        if($A.util.isEmpty(name))
        {
            validInputs = false;
        }
        
        if(validInputs)
        {
            var newItem = component.get('newItem');
            helper.createItem(component, newItem)
        }
	}
})