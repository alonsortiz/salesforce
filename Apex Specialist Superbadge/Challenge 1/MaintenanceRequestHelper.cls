/*
 * By: Alonso Ortiz - 03/Jan/2020
 * From: https://trailhead.salesforce.com/en/content/learn/superbadges/superbadge_apex
 *
 * Challenge 1: Automate record creation 
 */
 
public with sharing class MaintenanceRequestHelper {
    
    public static Case generateCase(Map<Id, Case> caseMap, Id record) {
        Case checkup = new Case();
        checkup.Type = 'Routine Maintenance';
        checkup.Subject = 'Routine Checkup';
        checkup.Date_Reported__c = Date.today();
        checkup.Vehicle__c = caseMap.get(record).Vehicle__c;
        checkup.Equipment__c  = caseMap.get(record).Equipment__c;
      
        Integer min = !(caseMap.get(record).Work_Parts__r).isEmpty() 
            ? Integer.valueOf(caseMap.get(record).Work_Parts__r[0].Equipment__r.Maintenance_Cycle__c) 
            : 0;
        
        checkup.Date_Due__c = Date.today().addDays(min);
        
        return checkup;
    }
    
    public static void updateWorkOrders(Map<Id, Case> oldMap, Map<Id, Case> newMap) {
        // TODO: Complete the method to update workorders
        
        List<Case> newCheckups = new List<Case>();
        List<Work_Part__c> reassignParts = new List<Work_Part__c>();
        Map<Id, Case> caseMap = new Map<Id, Case>([Select Id, Type, Status, Vehicle__c, Equipment__c, 
                                                   (Select Id, Equipment__r.Maintenance_Cycle__c 
                                                    From Work_Parts__r 
                                                    Order By Equipment__r.Maintenance_Cycle__c) 
                                                   From Case 
                                                   Where Id IN: newMap.keySet()
                                                   And Status =: 'Closed'
                                                   And (Type =: 'Repair' Or Type =: 'Routine Maintenance')
                                                   Limit 300]);
        
        Case checkup = new Case();

        for(Id record : caseMap.keySet()) {
            if(oldMap.get(record).Status != caseMap.get(record).Status) {
                reassignParts = caseMap.get(record).Work_Parts__r;
                checkup = generateCase(caseMap, record);
                newCheckups.add(checkup);              
            }           
        }
           
        if(!newCheckups.isEmpty()) {
            insert newCheckups;
   			
            //Reparenting Work Parts
            for(Work_Part__c record : reassignParts)
                record.Maintenance_Request__c = checkup.Id;
     
            if(!reassignParts.isEmpty())
            	update reassignParts;
        }
  
    }           
}