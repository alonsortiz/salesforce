/*
 * By: Alonso Ortiz - 03/Jan/2020
 * From: https://trailhead.salesforce.com/en/content/learn/superbadges/superbadge_apex
 *
 * Challenge 1: Automate record creation 
 */

trigger MaintenanceRequest on Case (before update, after update) {
    // ToDo: Call MaintenanceRequestHelper.updateWorkOrders

    if(trigger.isAfter && trigger.isUpdate) {    
        MaintenanceRequestHelper.updateWorkOrders(Trigger.oldMap, Trigger.newMap); 
    }

}