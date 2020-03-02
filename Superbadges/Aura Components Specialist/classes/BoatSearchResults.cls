public with sharing class BoatSearchResults {
    
    @AuraEnabled
    public static List<BoatType__c> getBoatTypes() {
        
        //Set fields to check
        String[] fieldsToCheck = new String[] {
            'Name'
        };
            
        //Check to make sure all fields are accessible to this user         
        accessibleFields(fieldsToCheck, 'BoatType__c');
        
        return [SELECT Id, Name
                FROM BoatType__c
                ORDER BY Name];
    }
    
    @AuraEnabled
    public static List<Boat__c> getBoats(String boatTypeId) {
        
        //Set fields to check
        String[] fieldsToCheck = new String[] {
            'Name', 'BoatType__c', 'Contact__c', 'Picture__c', 'Geolocation__latitude__s', 'Geolocation__longitude__s'
        };
            
        //Check to make sure all fields are accessible to this user         
        accessibleFields(fieldsToCheck, 'Boat__c');
        
        List<Boat__c> boats = new List<Boat__c>();
        
        if(boatTypeId == null || boatTypeId == '') {
            boats = [SELECT Id, Name, BoatType__c, Contact__r.Name, Picture__c, Geolocation__latitude__s, Geolocation__longitude__s 
                     FROM Boat__c];
        } else {
            boats = [SELECT Id, Name, BoatType__c, Contact__r.Name, Picture__c, Geolocation__latitude__s, Geolocation__longitude__s
                     FROM Boat__c
                     WHERE BoatType__c =: boatTypeId];
        }
        
        System.debug('BOATS: '+boats);
        
        return boats;
    }

    @AuraEnabled
    public static void accessibleFields(String[] fieldsToCheck, String objName) {

        Schema.DescribesObjectResult objectResult = Schema.getGlobalDescribe().get(objName).getDescribe();    
        Map<String, Schema.SObjectField> fieldDescribeTokens = objectResult.fields.getMap();
        
        for(String field : fieldsToCheck) {
            if(!fieldDescribeTokens.get(field).getDescribe().isAccessible()) {
                throw new System.NoAccessException();
            }
        }
        
    }
    
    @AuraEnabled
    public static void updeatableFields(String[] fieldsToCheck, String objName) {
        
        Schema.DescribesObjectResult objectResult = Schema.getGlobalDescribe().get(objName).getDescribe();    
        Map<String, Schema.SObjectField> fieldDescribeTokens = objectResult.fields.getMap();
        
        for(String field : fieldsToCheck) {
            if(!fieldDescribeTokens.get(field).getDescribe().isUpdateable()) {
                throw new System.NoAccessException();
            }
        }
        
    }

}