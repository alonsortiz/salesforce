/*
 * By: Alonso Ortiz - 22/Jan/2020
 * From: https://trailhead.salesforce.com/en/content/learn/superbadges/superbadge_integration
 *
 * Helper class with data, for all test classes coded for the challenge
 */

public class TestDataFactory {
    public Account createAccount() {
        Account acc = new Account();
        acc.Name = 'Acc Test';
        
        insert acc;
        
        return acc;
    }
    
    public List<Opportunity> createOpportunity() {
        List<Opportunity> opportunities = new List<Opportunity>();
        Account acc = createAccount();
        
        Opportunity opp = new Opportunity();
        opp.Name = 'Opp Test';
        opp.Type = 'New Project';
        opp.StageName = 'Prospecting';
        opp.AccountId = acc.Id;
        opp.CloseDate = Date.today();
        opp.Amount = 150000;

        opportunities.add(opp);
        
        insert opportunities;
        
        return opportunities;
    }
    
    public Project__c createProject() {
        List<Opportunity> opportunities = createOpportunity();
        Project__c project = new Project__c();
        
        project.ProjectRef__c = 'project-01';
        project.Name = 'Test Project Name';
        project.Opportunity__c = opportunities[0].Id;
        project.Start_Date__c = Date.today();
        project.End_Date__c = Date.today().addDays(1);
        project.Billable_Amount__c = 0;
        project.Status__c = 'Running';
        
        insert project;
        
        return project;
    }
    
    public List<Project__c> createProjects() {
        List<Opportunity> opportunities = createOpportunity();
        List<Project__c> projects = new List<Project__c>();
        Integer numOfProjects = 50;
        
        for(Integer i = 0; i < numOfProjects; i++) {
            Project__c project = new Project__c();
            
            project.ProjectRef__c = 'project-0'+(i+1);
            project.Name = 'Test Project Name '+(i+1);
            project.Opportunity__c = opportunities[0].Id;
            project.Start_Date__c = Date.today();
            project.End_Date__c = Date.today().addDays(1);
            project.Billable_Amount__c = 150000;
            project.Status__c = 'Running';
            
            projects.add(project);
        }

        insert projects;
        
        return projects;
    }
    
    public void createToken() {
        ServiceTokens__c token = new ServiceTokens__c();
        token.Name = 'ProjectServiceToken';
        token.Token__c = 'token-01';
        
        insert token;
    }
    
    public void createServiceCredentials() {
        ServiceCredentials__c credentials = new ServiceCredentials__c();
        credentials.Name = 'BillingServiceCredential';
        credentials.Username__c = 'user1';
        credentials.Password__c = 'pass1';

        insert credentials;
    }
}