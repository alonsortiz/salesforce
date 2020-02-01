/*
 * By: Alonso Ortiz - 30/Jan/2020
 * From: https://trailhead.salesforce.com/en/content/learn/superbadges/superbadge_integration
 *
 * Challenge 6: Test inbound Apex REST service logic
 */

@isTest
private class ProjectRESTServiceTest {
    //Implement Apex REST service tests here
    @isTest static void testInsertProject() {
        TestDataFactory data = new TestDataFactory();
        List<Opportunity> opportunities = data.createOpportunity();
        
        System.assert(!opportunities.isEmpty());
        
        Test.startTest();
        
        String post = ProjectRESTService.postProjectData('project-01', 'Test Project Name', (String)opportunities[0].Id, 
                                                         Date.today(), Date.today().addDays(1), 150000, 'Running');
        
        Test.stopTest();
        
        List<Opportunity> updatedOpps = [Select Id, DeliveryInstallationStatus__c
                                         From Opportunity];
        
        List<Project__c> projects = [Select Id, Opportunity__c
                                     From Project__c];
        
        System.assert(!projects.isEmpty());
        System.assertEquals(projects[0].Opportunity__c, updatedOpps[0].Id);
        System.assertEquals(updatedOpps[0].DeliveryInstallationStatus__c, 'In Progress');
        System.assertEquals(post, 'OK');
        
    }  

    @isTest static void testUpdateProject() {
        TestDataFactory data = new TestDataFactory();
        Project__c project = data.createProject();
        
        System.assert(project.ProjectRef__c == 'project-01');
        System.assert(project.Billable_Amount__c == 0);
        
        Test.startTest();
        
        String post = ProjectRESTService.postProjectData('project-01', 'Test Project Name', (String)project.Opportunity__c, 
                                                         Date.today(), Date.today().addDays(1), 150000, 'Running');
        
        Test.stopTest();
        
        List<Opportunity> updatedOpps = [Select Id, DeliveryInstallationStatus__c
                                         From Opportunity];
        
        List<Project__c> projects = [Select Id, Opportunity__c, Billable_Amount__c
                                     From Project__c];
        
        System.assert(!projects.isEmpty());
        System.assertEquals(projects[0].Opportunity__c, updatedOpps[0].Id);
        System.assert(projects[0].Billable_Amount__c == 150000);
        System.assertEquals(updatedOpps[0].DeliveryInstallationStatus__c, 'In Progress');
        System.assertEquals(post, 'OK');
        
    }
    
    @isTest static void testErrorProject() {
        TestDataFactory data = new TestDataFactory();
             
        Project__c project = data.createProject();
        
        project.Name = null;
        
        update project;
        
        Test.startTest();
        
        String post = ProjectRESTService.postProjectData('project-01', 'Test Project Name', (String)project.Opportunity__c, 
                                                         Date.today(), Date.today().addDays(1), 150000, 'Running');
        
        Test.stopTest();

        String expectedErrorMsg = 'Upsert failed. First exception on row 0; first error: DUPLICATE_VALUE,'
                                + ' duplicate value found: <unknown> duplicates value on record with id: <unknown>: []';

        System.assertEquals(post, expectedErrorMsg);
        
    }
}