({
    onFormSubmit : function(component, event, helper) {
        var params = event.getParam("formData");

        var boatSearchResultsCmp = component.find("boatSearchResults");
        
        if(boatSearchResultsCmp) {
            boatSearchResultsCmp.search(params.boatTypeId);
        }
    }
})