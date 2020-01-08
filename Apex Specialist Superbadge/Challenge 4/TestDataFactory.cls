/*
 * By: Alonso Ortiz - 08/Jan/2020
 * From: https://trailhead.salesforce.com/en/content/learn/superbadges/superbadge_apex
 *
 * Challenge 4: Test automation logic
 */

public class TestDataFactory {
    
    public Vehicle__c createVehicle() { 
        Vehicle__c vehicle = new Vehicle__c();
        vehicle.Name = '500';
        
        insert vehicle;
        
        return vehicle;
    }
    
    public Case createRequest() { 
        Vehicle__c vehicle = createVehicle();
        Case request = new Case();
        request.Status = 'New';
        request.Origin = 'Phone';
        request.Type = 'Repair';
        request.Vehicle__c = vehicle.Id;
        
        insert request;
        
        return request;
    }
    
    public List<Case> createRequests() { 
        Vehicle__c vehicle = createVehicle();
        List<Case> requests = new List<Case>();
        
        for(Integer i=0; i<300; i++) {
            Case request = new Case();
            request.Status = 'New';
            request.Origin = 'Phone';
            request.Vehicle__c = vehicle.Id;
            
            if(i < 75) {
                request.Type = 'Repair';
            } else if(i >= 75 && i < 150) {
                request.Type = 'Routine Maintenance';
            } else if(i >= 150 && i < 225) {
                request.Type = 'Mechanical';
            } else {
                request.Type = 'Other';
            }
            
            requests.add(request);
        }
        
        if(!requests.isEmpty())
            insert requests;

        return requests;
    }
    
    public List<Product2> createEquipments() { 
        List<Product2> equipments = new List<Product2>();
        
        for(Integer i = 0; i <= 3; i++) {
            Integer randomNumber = Integer.valueof((Math.random() * 10));
            
            Product2 equipment = new Product2();
            equipment.Name = 'Equipment ' + i+1;
            equipment.Maintenance_Cycle__c = randomNumber;
            equipment.Replacement_Part__c = true;  
            
            equipments.add(equipment);
        }

        if(!equipments.isEmpty())
        	insert equipments;
        
        return equipments;    
    }
    
    public List<Work_Part__c> createWorkParts() {
        List<Product2> equipments = createEquipments();
        Case request = [Select Id From Case Limit 1];
    
        List<Work_Part__c> workParts = new List<Work_Part__c>();
        
        for(Integer i = 0; i <= 3; i++) {
            Integer randomNumber = Integer.valueof((Math.random() * 10));
            
            Work_Part__c workPart = new Work_Part__c();
            workPart.Quantity__c = i+1;
            workPart.Equipment__c = equipments[i].Id;
            workPart.Maintenance_Request__c = request.Id;
            
            workParts.add(workPart);
        }

        if(!workParts.isEmpty())
        	insert workParts;
        
        return workParts;
    }

}