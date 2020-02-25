({
	onInit : function(component, event, helper) {
        var boatId = component.get('v.boat').Id;
        var action = component.get('c.getAll');
        
        action.setParams({
            "boatId": boatId
        });

        action.setCallback(this, function(response){
            var state = response.getState();
            let message = 'Unknown error';
            
            if (state === "SUCCESS") {
                component.set("v.boatReviews", response.getReturnValue());
            } else if (state === "ERROR") {
                // Process error returned by server
                let errors = response.getError();
                
                if (errors && Array.isArray(errors) && errors.length > 0) {
                    message = errors[0].message;
                }
                
                this.errorToast(component, event, helper, message);
            } else {
                // Handle other reponse states
                this.errorToast(component, event, helper, message);
            }
        });
        
        $A.enqueueAction(action);
	},
    
    errorToast : function(component, event, helper, message) {
        var toastEvent = $A.get("e.force:showToast");
        
        if(toastEvent) {
            toastEvent.setParams({
                "title": "Error",
                "message": message,
                "mode" : 'sticky'
            });
            
            toastEvent.fire();
        } else {
            alert(message)
        }
    }
})