({    
    fireCmpEvent : function(component, event, helper, eventName, params) {
        var evt = component.getEvent(eventName);
        
        if(params != null)
        	evt.setParams(params);
        
        evt.fire();
    },
    
    fireAppEvent : function(component, event, helper, eventName, params) {
        var evt = $A.get(eventName);
        
        if(params != null)
        	evt.setParams(params);
        
        evt.fire();
    } 
})