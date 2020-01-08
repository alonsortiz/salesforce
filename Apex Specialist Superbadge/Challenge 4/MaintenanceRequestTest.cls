/*
 * By: Alonso Ortiz - 08/Jan/2020
 * From: https://trailhead.salesforce.com/en/content/learn/superbadges/superbadge_apex
 *
 * Challenge 4: Test automation logic
 */

@isTest
private class MaintenanceRequestTest {
    
    @isTest static void testRequest_PositiveWithoutWorkParts() { 
        Case newRequest = updateRequest(false);
    }
    
    @isTest static void testRequest_PositiveWithWorkParts() { 
        Case newRequest = updateRequest(true);
        
        //This test has exisitng Work Parts, so more Asserts are needed.

        //Assert - Work Parts have been reparented.
        List<Work_Part__c> updatedWorkParts = [Select Id, Maintenance_Request__c, Equipment__r.Maintenance_Cycle__c
                                               From Work_Part__c
                                               Order By Equipment__r.Maintenance_Cycle__c];

        for(Work_Part__c record : updatedWorkParts) 
            System.assertEquals(record.Maintenance_Request__c, newRequest.Id);
        
        //Assert - Due Date is based on the smallest Maintenance Cycle.
        Integer numberDaysDue = (Date.today()).daysBetween(newRequest.Date_Due__c);
        System.assertEquals(numberDaysDue, updatedWorkParts[0].Equipment__r.Maintenance_Cycle__c);
        
    }
    
    public static Case updateRequest(Boolean hasWorkParts) {
        //Get Data
        Test.startTest();
        
        TestDataFactory data = new TestDataFactory();
        Case request = data.createRequest();
        
        if(hasWorkParts)
            List<Work_Part__c> workParts = data.createWorkParts();
        
        Integer numOfRequests = [Select COUNT() From Case];
        
       	System.assertEquals(1, numOfRequests);
        
        //Trigger Request creation.
        request.Status = 'Closed';
        update request;
        
        Test.stopTest();
        
        numOfRequests = [Select COUNT() From Case];
        
        //Assert - new Request has been created.
       	System.assertEquals(2, numOfRequests);
        
        Case newRequest = [Select Id, Vehicle__c, Equipment__c, Date_Due__c  From Case Where Status = 'New' Limit 1];
        
        System.assert(newRequest.Vehicle__c != null);
        
        return newRequest;
    }
    
    @isTest static void testRequest_Negative() {
        //Get Data
        Test.startTest();
        
        TestDataFactory data = new TestDataFactory();
        Case request = data.createRequest();

        Integer numOfRequests = [Select COUNT() From Case];
        
       	System.assertEquals(1, numOfRequests);
        
        //Trigger Request creation.
        request.Status = 'Working';
        update request;
        
        Test.stopTest();
        
        numOfRequests = [Select COUNT() From Case];
        
        //Assert - A new Request is not needed.
       	System.assertEquals(1, numOfRequests);
      
    }
    
    @isTest static void testRequest_Bulk() {
        //Get Data
        TestDataFactory data = new TestDataFactory();
        
        Test.startTest();
        
        List<Case> requests = data.createRequests();

        for(Case record : requests)
            record.Status = 'Closed';
        
        update requests;
        
        Test.stopTest();
 
        //Asserts - As only 150 Case records were created with Repair or Routine Maintenance Type, 
        //         only 150 new records will be created
        
        Integer numOfRequests = [Select COUNT() From Case];
        
        Integer newRequests = [Select COUNT() From Case Where Status='New'];
        
        System.assertEquals(450, numOfRequests);
        System.assertEquals(150, newRequests);
        
    }
}