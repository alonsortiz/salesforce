({
    afterScriptsLoaded : function(component, event, helper) {
        //let userId = document.getElementById("ratingarea").getAttribute("data-userid");
        
        var domEl = component.find("ratingarea").getElement()
        var currentRating = component.get('v.value');
        var readOnly = component.get('v.readonly');
        var maxRating = 5;
        var callback = function(rating) {
            component.set('v.value',rating);
        }
        component.ratingObj = rating(domEl,currentRating,maxRating,callback,readOnly); 
    },
    
    onValueChange : function(component,event,helper) {
        if (component.ratingObj) {
            var value = component.get('v.value');
            component.ratingObj.setRating(value,false);
        }
    }
    
})