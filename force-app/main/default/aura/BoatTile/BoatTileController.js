({
	onBoatClick : function(component, event, helper) {       
        var boat = component.get("v.boat");
        var selected = component.get("v.selected");
        
        // Fire Component event for Boat tile selection
        console.log("Select button pressed " + boat);
        var boatSelectEvent = component.getEvent("boatselect");
        boatSelectEvent.setParams({"boatId" : boat.Id});
        boatSelectEvent.fire();
        
        // Fire Additional Apllication event step #6 BoatSelected
        var appEvent = $A.get("e.c:BoatSelected");
          
        appEvent.setParams({
            "boat": boat
        });
        appEvent.fire();
		var appEvent2 = $A.get("e.c:PlotMapMarker");
          
        appEvent2.setParams({
            "lat": boat.Latitude__c,
            "long": boat.Longitude__c
        });
        appEvent2.fire();        
    }
})