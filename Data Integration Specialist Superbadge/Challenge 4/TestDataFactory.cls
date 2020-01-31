/*
 * By: Alonso Ortiz - 22/Jan/2020
 * From: https://trailhead.salesforce.com/en/content/learn/superbadges/superbadge_integration
 *
 * Challenge 4: Test outbound Apex REST callout logic
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
        
        project.ProjectRef__c = 'Test Project Ref';
        project.Name = 'Test Project Name';
        project.Opportunity__c = opportunities[0].Id;
        project.Start_Date__c = Date.today();
        project.End_Date__c = Date.today().addDays(1);
        project.Billable_Amount__c = 0;
        project.Status__c = 'Running';
        
        insert project;
        
        return project;
    }
    
    public void createToken() {
        ServiceTokens__c token = new ServiceTokens__c();
        token.Name = ProjectCalloutService.PROJECT_SERVICE_TOKEN;
        token.Token__c = 'token-01';
        
        insert token;
    }
}