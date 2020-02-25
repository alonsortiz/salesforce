({  
    getBoatTypes : function(component, event, helper) {
		var action = component.get('c.getBoatTypes');

        action.setCallback(this, function(response){
            var state = response.getState();
            let message = 'Unknown error'; 
            if (state === "SUCCESS") {
                component.set("v.boatTypes", response.getReturnValue());
                
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
    
    createRecord : function(component, event, helper, recordInfo) {
        var createRecordEvent = $A.get("e.force:createRecord");
        createRecordEvent.setParams(recordInfo);
        createRecordEvent.fire();
    },
    
    errorToast : function(component, event, helper, message) {
        var toastEvent = $A.get("e.force:showToast");
        
        toastEvent.setParams({
            "title": "Error",
            "message": message,
            "mode" : 'sticky'
        });
        
        toastEvent.fire();
    }
})