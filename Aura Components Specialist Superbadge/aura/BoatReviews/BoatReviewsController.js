({
	doInit : function(component, event, helper) {
		helper.onInit(component, event, helper);
	},
    
    onUserInfoClick : function(component, event, helper) {
        let userId = document.getElementById("user").getAttribute("data-userid");

        var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
            "recordId": userId
        });
        navEvt.fire();

    }
})