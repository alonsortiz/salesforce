/*
 * By: Alonso Ortiz - 16/Mar/2020
 * From: https://trailhead.salesforce.com/en/content/learn/superbadges/superbadge_aap
 *
 * Challenge 5: Create Unit Tests for orderTrigger and product2Extension
 * Challenge 8: Create Unit Tests
 */

@isTest
private class Product2Tests {

    /**
     * @name product2Extension_UnitTest
     * @description UnitTest for product2Extension
    **/
    static TestMethod void Product2Extension_UnitTest() {

        //Initializing exisitng data for the Inventory Chart
        List<Product2> existingProducts = TestDataFactory.ConstructProducts(2);
        insert existingProducts;
        
        //Initializing user data to be inserted with the VF Page
        List<Product2> newProducts = TestDataFactory.ConstructProducts(Constants.DEFAULT_ROWS);
        List<PriceBookEntry> newEntries = TestDataFactory.ConstructPricebookEntries(newProducts);
        
        //Modifying user data to test all paths 
        newProducts[0].isActive = false;
        newEntries[0].isActive = false;
		    
        newProducts[1].Initial_Inventory__c = 0;
        newEntries[1].UnitPrice = 0;
        Integer validRows = Constants.DEFAULT_ROWS-1; 
        
        //Initializing bad data to handle errors
        List<PriceBookEntry> badEntries = TestDataFactory.ConstructPricebookEntries(newProducts);
        badEntries[0].Pricebook2Id = null;
        
        //Apex Messages
        String successMsg = 'ApexPages.Message["' + validRows + ' Inserted"]';
        String warningMsg = 'ApexPages.Message["' + Constants.ERROR_INCOMPLETE_MESSAGE + '"]';
        String errorMsg = 'ApexPages.Message["' + Constants.ERROR_MESSAGE + '"]';
        
        PageReference pageRef = page.Product2New;
        ApexPages.StandardController sc = new ApexPages.StandardController(new Product2());
        
        Test.startTest();
        
        //Load page
        Product2Extension ext = new Product2Extension(sc);
        System.assertEquals(Constants.DEFAULT_ROWS, ext.productsToInsert.size());
        
        //Add button
        ext.addRows();
        System.assertEquals(Constants.DEFAULT_ROWS*2, ext.productsToInsert.size());

        //Inventory Chart 
        List<ChartHelper.ChartData> chartData = ext.GetInventory();
        
        AggregateResult[] aggregateResult = [SELECT Family, SUM(Quantity_Remaining__c) quantityRemaining
                                             FROM Product2
                                             WHERE isActive = true
                                             AND Quantity_Remaining__c > 0
                                             GROUP BY Family];
 		    
        Integer chartIndex = 0;
        for(ChartHelper.ChartData chart : chartData) {
            System.assertEquals(chart.name, aggregateResult[chartIndex].get('Family'));
            System.assertEquals(chart.val, aggregateResult[chartIndex].get('quantityRemaining'));

            chartIndex++;
        }
        
        //Family picklist
        List<SelectOption> family = ext.GetFamilyOptions();
        System.assertEquals(family.size(), Constants.PRODUCT_FAMILY.size()+1);
        
        List<Product2Extension.ProductWrapper> productWrapper = ext.productsToInsert;        

        //Save - Success
        for(Integer i = 0; i < Constants.DEFAULT_ROWS; i++) {
            productWrapper[i].productRecord = newProducts[i];
            productWrapper[i].pricebookEntryRecord = newEntries[i];
        }

        ext.save();

        System.assertEquals(successMsg, String.valueOf(ApexPages.getMessages().get(0)));
        
        //Save - Invalid info
        for(Integer i = 0; i < Constants.DEFAULT_ROWS; i++) {
            productWrapper[i].productRecord = null;
            productWrapper[i].pricebookEntryRecord = null;
        }

        ext.save();
        
        System.assertEquals(warningMsg, String.valueOf(ApexPages.getMessages().get(1)));
        
        //Save - Error
        for(Integer i = 0; i < Constants.DEFAULT_ROWS; i++) {
            productWrapper[i].productRecord = newProducts[i];
            productWrapper[i].pricebookEntryRecord = badEntries[i];
        }

        ext.save();
        
        System.assertEquals(errorMsg, String.valueOf(ApexPages.getMessages().get(3)));
      
        Test.stopTest();

    }
    
    @isTest 
    private static void Product2Trigger_UnitTest() { 
        
        CollaborationGroup collabGroup = TestDataFactory.ConstructCollaborationGroup();
        insert collabGroup;
        
        Product2 product = TestDataFactory.ConstructProducts(1).get(0);
        insert product;
        
        Test.startTest();
        
        product.Quantity_Ordered__c = 5;
        update product;
        
        Test.stopTest();
    }

}