/*
 * By: Alonso Ortiz - 30/Jan/2020
 * From: https://trailhead.salesforce.com/en/content/learn/superbadges/superbadge_integration
 *
 * Challenge 5: Synchronize external PMS system project data with Salesforce
 */

@RestResource(urlMapping='/project/*')
global with sharing class ProjectRESTService {
    //Implement service logic here
    
    @HttpPost
    global static String postProjectData(String ProjectRef, String ProjectName, String OpportunityId, Date StartDate, 
                                         Date EndDate, Double Amount, String Status) {
        
        String serviceMsg = 'OK';
        Savepoint sp = Database.setSavepoint();
 
        try {
            List<Opportunity> opportunities = [Select Id, DeliveryInstallationStatus__c, 
                                               (Select Id 
                                                From Projects__r 
                                                Where ProjectRef__c =: ProjectRef
                                                And Name =: ProjectName
                                                Limit 1) 
                                               From Opportunity 
                                               Where Id =: OpportunityId
                                               Limit 1];
            
            if(!opportunities.isEmpty()) {
                Project__c project = new Project__c();

                if(!opportunities[0].Projects__r.isEmpty())
                    project.Id = opportunities[0].Projects__r[0].Id;
 
                project.ProjectRef__c = ProjectRef;
                project.Name = ProjectName;
                project.Opportunity__c = OpportunityId;
                project.Start_Date__c = StartDate;
                project.End_Date__c = EndDate;
                project.Billable_Amount__c = Amount;
                project.Status__c = Status;
                
                upsert project;
                
                opportunities[0].DeliveryInstallationStatus__c = 'In Progress';
                
                update opportunities;
            }
            
        } catch(DMLException e) {
            Database.rollback(sp);
            serviceMsg = e.getMessage();
        }
        
        return serviceMsg;
   
    }
}