/*
 * By: Alonso Ortiz - 08/Jan/2020
 * From: https://trailhead.salesforce.com/en/content/learn/superbadges/superbadge_apex
 *
 * Challenge 5: Test callout logic
 */

@IsTest
private class WarehouseCalloutServiceTest {
    // implement your mock callout test here
    @isTest static void testWarehouseCalloutService() { 
        Test.setMock(HttpCalloutMock.class, new WarehouseCalloutServiceMock()); 
        
        Integer allProducts = [Select COUNT() From Product2];
        
        System.assertEquals(0, allProducts);
        
        Test.startTest();
        
        WarehouseCalloutService.runWarehouseEquipmentSync();
        
        Test.stopTest();
        
        //Assert - Based on the list of equipment, now we should have 22 products. 
        allProducts = [Select COUNT() From Product2];
        System.assertEquals(22, allProducts);
    }

}