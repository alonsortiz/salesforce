/*
 * By: Alonso Ortiz - 16/Mar/2020
 * From: https://trailhead.salesforce.com/en/content/learn/superbadges/superbadge_aap
 *
 * Challenge 5: Create Unit Tests for orderTrigger and product2Extension
 * Challenge 8: Create Unit Tests
 */
 
@isTest
private class OrderTests {
    
    private static final Integer TOTAL = 10;
    
    @testSetup static void SetupTestData() {
        TestDataFactory.InsertTestData(TOTAL);
    }

    @isTest 
    private static void OrderUpdate_UnitTest() { 
        List<Order> orders = [Select Name, Status From Order Limit 1];

        List<Product2> originalProduct = [Select Id, Name, Quantity_Ordered__c
                                          From Product2 
                                          Limit 1];
                                           
        orders[0].Status = Constants.ACTIVATED_ORDER_STATUS;       
        update(orders);

        List<Product2> updatedProduct = [Select Id, Name, Quantity_Ordered__c
                                         From Product2 
                                         Limit 1];

        TestDataFactory.VerifyQuantityOrdered(originalProduct[0], updatedProduct[0], Constants.DEFAULT_ROWS);
        
    }
    
    @isTest
    private static void OrderExtension_UnitTest() {

        Order order = [Select Id From Order Limit 1];
        String errorMsg = 'ApexPages.Message["' + Constants.ERROR_MESSAGE + '"]';

        PageReference pageRef = page.Product2New;
        ApexPages.StandardController sc = new ApexPages.StandardController(order);
        
        Test.startTest();
        
        OrderExtension ext = new OrderExtension(sc);
		
        //Constructor
        System.assertEquals(Constants.DEFAULT_ROWS, ext.orderItemList.size());
        
        Integer existingOrderItems = ext.orderRecord.OrderItems.size();
        
        //Pie Data
	System.assertEquals(existingOrderItems, ext.pieData.size());
    
        //Family picklist
        System.assertEquals(ext.GetFamilyOptions().size(), Constants.PRODUCT_FAMILY.size()+1);
        
        //SelectFamily
        ext.selectedFamily = Constants.PRODUCT_FAMILY[0].getValue();
        ext.SelectFamily();
        
        Integer filteredProducts = [Select COUNT() From Product2 Where Family=:Constants.PRODUCT_FAMILY[0].getValue()];
        System.assertEquals(filteredProducts, ext.orderItemList.size());

        //Filtered Pagination
        System.assertEquals(Math.ceil(Decimal.valueOf(ext.orderItemList.size())/Constants.DEFAULT_ROWS), ext.GetTotalPages());
        
        //Go back to unfiltered list
        ext.selectedFamily = Constants.SELECT_ONE;
        ext.SelectFamily();
        
        //Unfiltered Pagination
        ext.First();
 		
        System.assertEquals(true, ext.GetHasNext());
        System.assertEquals(false, ext.GetHasPrevious());
        System.assertEquals(1, ext.GetPageNumber());
        
        ext.Next();

        System.assertEquals(true, ext.GetHasPrevious());
        System.assertEquals(2, ext.GetPageNumber());

        ext.Previous();
        
        System.assertEquals(true, ext.GetHasNext());
        
        ext.Last();
        
        System.assertEquals(2, ext.GetPageNumber());
        System.assertEquals(true, ext.GetHasPrevious());
        System.assertEquals(false, ext.GetHasNext());
       
        System.assertEquals(TOTAL/Constants.DEFAULT_ROWS, ext.GetTotalPages());

        //Save - Deleting existing order item
        String orderItemToDelete;
        
        for(OrderItem orderItem : ext.orderItemMap.values()){ 
            if(orderItem.Id != null) {
                orderItem.Quantity = 0;
                orderItemToDelete = orderItem.Id;
                break;
            }
        }
        
        ext.OnFieldChange();
        
        //Existing record is rendered in the Pie Chart
        System.assertEquals(0, ext.pieData.size());
        
        List<OrderItem> deletedOrderItem = [Select Id From OrderItem Where Id=:orderItemToDelete];
        System.assert(!deletedOrderItem.isEmpty());

        //Save - Inserting order item
        ext.orderItemList[0].Quantity = 10;
        ext.OnFieldChange();

        Integer relatedOrderItems = [Select COUNT() From OrderItem Where OrderId =: ext.orderRecord.Id];
        
        //One order item exisiting related to the Order
        System.assertEquals(1, relatedOrderItems);
        
        ext.Save();
  		
        //Order Item has been deleted
        deletedOrderItem = [Select Id From OrderItem Where Id=:orderItemToDelete];
        System.assert(deletedOrderItem.isEmpty());

        //A new record is rendered in the Pie Chart
        System.assertEquals(1, ext.pieData.size());
		
        relatedOrderItems = [Select COUNT() From OrderItem Where OrderId =: ext.orderRecord.Id];
        
        //Original order item was deleted, and a new one was inserted
        System.assertEquals(1, relatedOrderItems);
        
        //Save - REQUIRED_FIELD_MISSING Error 
        ext.orderRecord.AccountId = null;
        ext.Save();
        
        System.assertEquals(errorMsg, String.valueOf(ApexPages.getMessages().get(0)));
        
        Test.stopTest();
    }
}
