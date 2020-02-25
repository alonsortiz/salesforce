({
	onBoatSelected : function(component, event, helper) {  
		var boat = event.getParam("boat");
        component.set("v.id", boat.Id);

        component.find('service').reloadRecord();
	},
    
    onRecordUpdated : function(component, event, helper) {
        var boatReviews = component.find("reviewsCmp");
        
        if(boatReviews) {
            boatReviews.refresh();
        }
    },
    
    onBoatReviewAdded : function(component, event, helper) { 
        component.find("tabs").set("v.selectedTabId", "boatreviewtab");

        var boatReviews = component.find("reviewsCmp");
        
        if(boatReviews) {
            boatReviews.refresh();
        }
    }
})