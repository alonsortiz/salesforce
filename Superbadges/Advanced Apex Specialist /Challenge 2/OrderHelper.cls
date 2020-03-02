/*
 * By: Alonso Ortiz - 26/Feb/2020
 * From: https://trailhead.salesforce.com/en/content/learn/superbadges/superbadge_aap
 *
 * Challenge 2: Update the order trigger
 */

public without sharing class OrderHelper {

    /**
     * @name AfterUpdate
     * @description 
     * @param List<Order> newList
     * @param List<Order> oldList
     * @return void
    **/
    public static void AfterUpdate(List<Order> newList, List<Order> oldList){
        Set<Id> orderIds = new Set<Id>();
        for ( Integer i=0; i<newList.size(); i++ ){
            if ( newList[i].Status == Constants.ACTIVATED_ORDER_STATUS && oldList[i].Status != Constants.ACTIVATED_ORDER_STATUS ){
                orderIds.add(newList[i].Id);
            }
        }
        
        //Inventory levels
        RollUpOrderItems(orderIds);
    }

    /**
     * @name RollUpOrderItems
     * @description Given a set of Activated Order ids, query the child Order Items and related Products to calculate Inventory levels
     * @param Set<Id> activatedOrderIds
     * @return void
    **/
    public static void RollUpOrderItems(Set<Id> activatedOrderIds){
        //ToDo: Declare a Map named "productMap" of Ids to Product2 records
        Map<Id, Product2> productMap = new Map<Id, Product2>();

        //ToDo: Loop through a query of OrderItems related to the activatedOrderIds
        List<OrderItem> orderItems = [SELECT Id, Product2Id, Product2.Quantity_Ordered__c
                                      FROM OrderItem
                                      WHERE OrderId IN: activatedOrderIds];

        for(OrderItem record : orderItems) {
            //ToDo: Populate the map with the Id of the related Product2 as the key and Product2 record as the value
            productMap.put(record.Product2Id, record.Product2);
        }

        //ToDo: Loop through a query that aggregates the OrderItems related to the Products in the ProductMap keyset
        AggregateResult[] aggregateResult = [SELECT Product2Id, SUM(Quantity) totalQuantity
                                             FROM OrderItem
                                             WHERE Product2Id IN: productMap.keySet()
                                             GROUP BY Product2Id];

        if(!productMap.values().isEmpty()) {
            for(AggregateResult aggregate : aggregateResult) {
                productMap.get((String)aggregate.get('Product2Id')).Quantity_Ordered__c = Integer.valueOf(aggregate.get('totalQuantity'));
            }
            
            //ToDo: Perform an update on the records in the productMap
            update productMap.values();
        }
        	
    }

}