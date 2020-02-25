({
    onBoatClick : function(component, event, helper) {
        //After passing the challenge, code refactored using the helper
        let boat = component.get("v.boat");
        
        let params = {
            "boatId" : boat.Id
        };

        helper.fireCmpEvent(component, event, helper, "boatSelect", params);
        
        params = {
            "boat" : boat
        };

		helper.fireAppEvent(component, event, helper, "e.c:BoatSelected", params);

		params = {
            "sObjectId" : boat.Id,
            "lat" : boat.Geolocation__Latitude__s.toString(),
            "long" : boat.Geolocation__Longitude__s.toString(),
            "label": boat.Name
        };
        
		helper.fireAppEvent(component, event, helper, "e.c:PlotMapMarker", params);
     
    }
})