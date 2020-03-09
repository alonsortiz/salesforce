/*
 * By: Alonso Ortiz - 08/Mar/2020
 * From: https://trailhead.salesforce.com/en/content/learn/superbadges/superbadge_aap
 *
 * Challenge 6: Automate internal announcements when inventory is low
 */
 
/**
 * @name product2Trigger
 * @description Trigger to notify staff of low levels of inventory
**/
trigger product2Trigger on Product2 (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
    if(trigger.isAfter && trigger.isUpdate) {    
        Product2Helper.AfterUpdate(Trigger.new);
    }  
}