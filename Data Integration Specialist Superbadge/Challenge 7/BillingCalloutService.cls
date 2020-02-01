/*
 * By: Alonso Ortiz - 31/Jan/2020
 * From: https://trailhead.salesforce.com/en/content/learn/superbadges/superbadge_integration
 *
 * Challenge 7: Synchronize Salesforce project data with Square Peg's external billing system
 */

public with sharing class BillingCalloutService {
    //Implement business and callout logic methods here
    
    public static final ServiceCredentials__c billingServiceCredential = ServiceCredentials__c.getInstance('BillingServiceCredential');
     
    public static void callBillingService(Map<Id, Project__c> oldMap, List<Project__c> projects) {
        Map<String, Double> projectsInfo = new Map<String, Double>();
            
        for(Project__c record : projects) {
            if((record.Status__c == 'Billable') && (record.Status__c != oldMap.get(record.Id).Status__c)) {
                projectsInfo.put(record.ProjectRef__c, (Double)record.Billable_Amount__c);
            }
        }
   
        if(!projectsInfo.isEmpty()) {
            //Execute asynchronus code for the callout
            calloutToSquarePeg(projectsInfo);
        }
    }
  
    @future(callout=true)
    public static void calloutToSquarePeg(Map<String, Double> projectsInfo) {
        List<String> okProjects = new List<String>();
        
        for(String record : projectsInfo.keySet()) {
            String res = invokeCallout(record, projectsInfo.get(record));
            
            if(res == 'OK')
                okProjects.add(record);
        }
        
        if(!okProjects.isEmpty()) {
            List<Project__c> projectsToUpdate = [Select Id, Status__c 
                                                 From Project__c 
                                                 Where ProjectRef__c IN: okProjects];
            
            for(Project__c record : projectsToUpdate)
                record.Status__c = 'Billed';
            
            update projectsToUpdate;
        }

    }
    
    public static String invokeCallout(String ProjectRef, Double BillingAmount) {
        BillingServiceProxy.project project = new BillingServiceProxy.project();
        
        project.projectid = ProjectRef;
        project.billAmount = BillingAmount;
        project.username = billingServiceCredential.Username__c;
        project.password = billingServiceCredential.Password__c;
        
        BillingServiceProxy.InvoicesPortSoap11 invoices = new BillingServiceProxy.InvoicesPortSoap11();
        
        String res = invoices.billProject(project);
        
        return res;
    }
}