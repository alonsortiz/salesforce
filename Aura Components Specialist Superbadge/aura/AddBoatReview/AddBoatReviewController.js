({
	doInit : function(component, event, helper) {
		helper.onInit(component, event, helper);
	}, 
    
    onSave : function(component, event, helper) {
        //let reviewToSave = component.get('v.boatReview');
        //let commentWithHtml = reviewToSave.Comment__c;
        //component.get('v.boatReview').Comment__c = commentWithHtml.replace(/<[^>]*>/g,'');
        var boatId = component.get("v.boat").Id;
        component.set("v.boatReview.Boat__c", boatId);
        
        component.find("service").saveRecord(function(saveResult) {
            if (saveResult.state === "SUCCESS" || saveResult.state === "DRAFT") {
                // record is saved successfully
                var toastEvent = $A.get("e.force:showToast");
                
                if (toastEvent) {
                    toastEvent.setParams({
                        "title": "Success",
                        "message": "The record was saved.",
                        "type" : "success"
                    });
                    
                    toastEvent.fire();
                } else {
                    alert("The record was saved.");
                }
                
                var boatReviewAddedEvt = component.getEvent("boatReviewAdded");
                boatReviewAddedEvt.fire();
                
                helper.onInit(component, event, helper);
                
                //let message = "The record was saved."
                //this.successToast(component, event, helper, message);
            } else if (saveResult.state === "INCOMPLETE") {
                // handle the incomplete state
                console.log("User is offline, device doesn't support drafts.");
            } else if (saveResult.state === "ERROR") {
                // handle the error state
                console.log('Problem saving contact, error: ' + 
                            JSON.stringify(saveResult.error));
            } else {
                console.log('Unknown problem, state: ' + saveResult.state +
                            ', error: ' + JSON.stringify(saveResult.error));
            }
		});
    },
    
    onRecordUpdated : function(component, event, helper) {
        //component.find("service").reloadRecord();
        var toastEvent = $A.get("e.force:showToast");
        
        if (toastEvent) {
            toastEvent.setParams({
                "title": "Success",
                "message": "Record updated.",
                "type" : "success"
            });
            
            toastEvent.fire();
        } else {
            alert("Record updated.");
        }
	}	
})