({
	onInit : function(component, event, helper) {
        component.find("service").getNewRecord(
            "BoatReview__c", // sObject type (entityAPIName)
            null,      // recordTypeId
            false,     // skip cache?
            $A.getCallback(function() {
                //alert(JSON.stringify(component.get("v.boatReview")))
                var boatReview = component.get("v.boatReview");
                var error = component.get("v.recordError");
                if(error || (boatReview === null)) {
                    console.log("Error initializing record: " + error);
                } else {
                    if(boatReview != undefined) {
                        boatReview.Boat__c = component.get("v.boat").Id;
                        component.set("v.boatReview", boatReview);
                    }
                    
                }
            })
        );
	}
})