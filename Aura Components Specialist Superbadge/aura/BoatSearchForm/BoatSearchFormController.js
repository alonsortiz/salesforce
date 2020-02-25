({  
    doInit: function(component, event, helper) {
        var isSupported = $A.get("e.force:createRecord"); 

        if(isSupported) {
            component.set("v.showNewButton", true);
        }
        
        helper.getBoatTypes(component, event, helper); 
    },
    
	createBoat : function(component, event, helper) {
        let boatTypeId = component.find('typeSelect').get('v.value');

        let recordInfo = {
            'entityApiName' : 'Boat__c'
        }
        
        if(boatTypeId) {
            recordInfo.defaultFieldValues = {
                "BoatType__c" : boatTypeId
            };
        }
        
        helper.createRecord(component, event, helper, recordInfo);
    },
    
    onFormSubmit : function(component, event, helper) {
        let boatTypeId = component.find('typeSelect').get('v.value');
        
        let formData = {
            "boatTypeId" : boatTypeId
        };

        var formEvt = component.getEvent("formsubmit");
        formEvt.setParams({
            "formData": formData
        });
        formEvt.fire();
    }
})