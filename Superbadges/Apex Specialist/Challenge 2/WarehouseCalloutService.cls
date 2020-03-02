/*
 * By: Alonso Ortiz - 03/Jan/2020
 * From: https://trailhead.salesforce.com/en/content/learn/superbadges/superbadge_apex
 *
 * Challenge 2: Synchronize Salesforce data with an external system 
 */

public with sharing class WarehouseCalloutService {

    private static final String WAREHOUSE_URL = 'https://th-superbadge-apex.herokuapp.com/equipment';
    
    public static Product2 updateEquipment(Map<String, Object> externalRecords) { 
        Product2 productToUpdate = new Product2();
        
        productToUpdate.Warehouse_SKU__c = String.valueOf(externalRecords.get('sku'));
        productToUpdate.Cost__c = Decimal.valueOf(String.valueOf(externalRecords.get('cost')));
        productToUpdate.Lifespan_Months__c = Double.valueOf(String.valueOf(externalRecords.get('lifespan')));
        productToUpdate.Maintenance_Cycle__c = Double.valueOf(String.valueOf(externalRecords.get('maintenanceperiod')));
        productToUpdate.Name = String.valueOf(externalRecords.get('name'));
        productToUpdate.Current_Inventory__c = Double.valueOf(String.valueOf(externalRecords.get('quantity')));
        productToUpdate.Replacement_Part__c = true;
        
        return productToUpdate;
    }
    
    @future(callout=true)
    public static void runWarehouseEquipmentSync() {
        //ToDo: complete this method to make the callout (using @future) to the
        //      REST endpoint and update equipment on hand.

        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(WAREHOUSE_URL);
        request.setMethod('GET');
        HttpResponse response = http.send(request);
        
        if(response.getStatusCode() == 200) {
            List<Object> externalRecords = (List<Object>)JSON.deserializeUntyped(response.getBody());

            List<Product2> allProducts = new List<Product2>();

            for(Object record : externalRecords) {
                Map<String, Object> values = (Map<String, Object>)record;
                
		Product2 productToUpdate = updateEquipment(values);  
                allProducts.add(productToUpdate);
            }
            
            if(!allProducts.isEmpty())
                upsert allProducts;
        }
    }
}
