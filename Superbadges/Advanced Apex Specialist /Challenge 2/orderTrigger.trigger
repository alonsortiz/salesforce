/*
 * By: Alonso Ortiz - 26/Feb/2020
 * From: https://trailhead.salesforce.com/en/content/learn/superbadges/superbadge_aap
 *
 * Challenge 2: Update the order trigger
 */

trigger orderTrigger on Order (before insert, after insert, before update, after update, before delete, after delete, after undelete) {
	if(trigger.isAfter && trigger.isUpdate) {    
        OrderHelper.AfterUpdate(Trigger.new, Trigger.old);
    }
}