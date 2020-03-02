public with sharing class BoatReviews { 
    
    @AuraEnabled
    public static List<BoatReview__c> getAll(Id boatId) {
        
        //Set fields to check
        String[] fieldsToCheck = new String[] {
            'Name', 'Comment__c', 'Rating__c', 'LastModifiedDate', 'CreatedDate', 'CreatedBy'
        };
            
        //Check to make sure all fields are accessible to this user         
        //accessibleFields(fieldsToCheck, 'BoatType__c');
        //System.debug('');
        
        return [SELECT Id, Name, Comment__c, Rating__c, LastModifiedDate, CreatedDate, 
                		CreatedBy.Name, CreatedBy.SmallPhotoUrl, CreatedBy.CompanyName
                FROM BoatReview__c
                WHERE Boat__c =: boatId
                ORDER BY CreatedDate DESC];
    }
    

}