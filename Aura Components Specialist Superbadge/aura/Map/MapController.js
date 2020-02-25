({
    jsLoaded : function(component) {
        component.set("v.jsLoaded", true);
    },
    
    onPlotMapMarker : function(component, event, helper) {
        component.set('v.location', {
            lat : event.getParam("lat"),
            long : event.getParam("long")
        });
    }
    
})