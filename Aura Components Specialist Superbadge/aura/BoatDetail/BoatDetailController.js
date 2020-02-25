({
    doInit : function(component, event, helper) {
		var redirectToSObjectPageEvent = $A.get("e.force:navigateToSObject");
        
        if (redirectToSObjectPageEvent) {
            component.set("v.showDetailsButton", true);
        }
	},
    
    onFullDetails : function(component, event, helper) {
        let recordId = component.get('v.boat').Id;
        
        var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
            "recordId": recordId
        });
        navEvt.fire();
    }
})