({
    doInit : function(component, event, helper) {
        helper.onSearch(component, event, helper, component.get('v.boatTypeId'));
    },
    
    doSearch : function(component, event, helper) {
        var params = event.getParam('arguments');
        component.set("v.boatTypeId", params.boatTypeId);
		helper.onSearch(component, event, helper, component.get('v.boatTypeId'));
	},
    
    onBoatSelect : function(component, event, helper) {
        var boatId = event.getParam('boatId');
        component.set("v.selectedBoatId", boatId);
	}
})