/*
 * By: Alonso Ortiz - 31/Jan/2020
 * From: https://trailhead.salesforce.com/en/content/learn/superbadges/superbadge_integration
 *
 * Challenge 8: Test outbound Apex SOAP callout logic
 */

@isTest
private class BillingCalloutServiceTest {

    //Implement mock callout tests here
    public static List<Project__c> setCalloutTest() { 
        TestDataFactory data = new TestDataFactory();
        data.createServiceCredentials();
        List<Project__c> projects = data.createProjects();
        
        System.debug(projects);
        Integer i = 0;
        
        System.assert(projects.size() == 50); 
        
        for(Project__c record : projects) {
            if(math.mod(i, 2) == 0) //Half of the records will execute asynchronus code for the callout
               record.Status__c = 'Billable'; 

            i++;
        }
        
        return projects;
    }
    
    @isTest static void testCalloutSuccess() { 
        
        List<Project__c> projects = setCalloutTest();
            
        Test.startTest();
        // This causes a fake response to be generated
        Test.setMock(WebServiceMock.class, new BillingCalloutServiceMock());
        update projects;
        
        Test.stopTest();
        
        List<Project__c> updatedProjects = [Select Id 
                                            From Project__c 
                                            Where Status__c = 'Billed'];
        
        System.assert(updatedProjects.size() == 25); 
        
    }
    
    @isTest static void testCalloutFailure() { 
        List<Project__c> projects = setCalloutTest();
            
        Test.startTest();
        // This causes a fake response to be generated
        Test.setMock(WebServiceMock.class, new BillingCalloutServiceMockFailure());
        update projects;
        
        Test.stopTest();
        
        List<Project__c> updatedProjects = [Select Id 
                                            From Project__c 
                                            Where Status__c = 'Billed'];
        
        System.assert(updatedProjects.size() == 0);
        
    }
}