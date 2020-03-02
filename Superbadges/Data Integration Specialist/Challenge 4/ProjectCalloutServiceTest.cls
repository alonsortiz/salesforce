/*
 * By: Alonso Ortiz - 22/Jan/2020
 * From: https://trailhead.salesforce.com/en/content/learn/superbadges/superbadge_integration
 *
 * Challenge 4: Test outbound Apex REST callout logic
 */

@isTest
private class ProjectCalloutServiceTest {
    //Implement mock callout tests here
    
    public static List<Opportunity> setTest() { 
        TestDataFactory data = new TestDataFactory();
        
        data.createToken();
        List<Opportunity> opportunities = data.createOpportunity();
        
        for(Opportunity record : opportunities)
            record.StageName = 'Closed Won';
        
        return opportunities;
    }
    
    @isTest static void testProjectCalloutServiceSuccess() {
        
        List<Opportunity> opportunities = setTest();
        
        Test.startTest(); 
        
        Test.setMock(HttpCalloutMock.class, new ProjectCalloutServiceMock()); 
        update opportunities;
        
        Test.stopTest();
        
        List<Opportunity> updatedOpp = [Select Id, StageName
                                       From Opportunity];
        
        System.assertEquals('Submitted Project', updatedOpp[0].StageName);
        
    }
    
    @isTest static void testProjectCalloutServiceFailure() {
        
        List<Opportunity> opportunities = setTest();
        
        Test.startTest(); 
        
        Test.setMock(HttpCalloutMock.class, new ProjectCalloutServiceMockFailure()); 
        update opportunities;
        
        Test.stopTest();
        
        List<Opportunity> updatedOpp = [Select Id, StageName
                                       From Opportunity];
        
        System.assertEquals('Resubmit Project', updatedOpp[0].StageName);
        
    }
}