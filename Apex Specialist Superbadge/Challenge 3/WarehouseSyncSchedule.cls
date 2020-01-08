/*
 * By: Alonso Ortiz - 07/Jan/2020
 * From: https://trailhead.salesforce.com/en/content/learn/superbadges/superbadge_apex
 *
 * Challenge 3: Schedule Synchronization
 */

global with sharing class WarehouseSyncSchedule implements Schedulable {
    // implement scheduled code here
    global void execute(SchedulableContext sc) {
        WarehouseCalloutService.runWarehouseEquipmentSync();
    }
}