/*
 * By: Alonso Ortiz - 31/Jan/2020
 * From: https://trailhead.salesforce.com/en/content/learn/superbadges/superbadge_integration
 *
 * Challenge 7: Synchronize Salesforce project data with Square Peg's external billing system
 */
 
trigger ProjectTrigger on Project__c (after update) {
    //Call the Billing Service callout logic here
    if(trigger.isAfter && trigger.isUpdate) {    
        BillingCalloutService.callBillingService(Trigger.oldMap, Trigger.new);
    }
}