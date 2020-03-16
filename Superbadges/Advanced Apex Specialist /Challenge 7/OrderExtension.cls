/*
 * By: Alonso Ortiz - 11/Mar/2020
 * From: https://trailhead.salesforce.com/en/content/learn/superbadges/superbadge_aap
 *
 * Challenge 7: Complete the controller extension for a Visualforce page to enable rapid order entry
 */

/**
 * @name OrderExtension
 * @description This class is provided for you to facilitate the Super Badge
**/
public class OrderExtension {

    public Order orderRecord {get;set;}
    public List<OrderItem> orderItemList {get;set;}
    public String selectedFamily {get;set;}
    public List<chartHelper.chartData> pieData {get;set;}
    public Decimal total {get;set;}

    public Map<Id,OrderItem> orderItemMap;
    ApexPages.StandardSetController standardSetController;

    public OrderExtension(ApexPages.StandardController standardController){
        orderRecord = (Order)standardController.getRecord();
        orderItemMap = new Map<id,OrderItem>();
            
        if ( orderRecord.Id != null ){
            orderRecord = queryOrderRecord(orderRecord.Id);
        }
        
        getExistingOrderItems();
        getProducts();
        loadChart();
    }

    //ToDo: Implement your own method to populate orderItemList
    //  that you will call after pagination and/or family selection
    public void getExistingOrderItems() {
        for(OrderItem orderItem : orderRecord.OrderItems) {
            orderItemMap.put(orderItem.Product2Id, orderItem);
        }
    }
    
    public void getProducts() {
        String query = 'SELECT Name, Id, Pricebook2Id, Product2Id, UnitPrice, Product2.Name, Product2.Family, Product2.Quantity_Remaining__c FROM PricebookEntry WHERE isActive= true';
        
        if (String.isNotBlank(selectedFamily) && selectedFamily != Constants.SELECT_ONE ) {
            query += ' AND Product2.Family = \''+ selectedFamily + '\'';
        }
        
        standardSetController = new ApexPages.StandardSetController(Database.getQueryLocator(query));
        standardSetController.setPageSize(Constants.DEFAULT_ROWS);
 
        if(!standardSetController.getRecords().isEmpty()) { 
            setOrderItemList();
        }
    }
    
    public void setOrderItemList() {
        
        //Construct orderItemList
        orderItemList = new List<OrderItem>();
        
        for(PricebookEntry record : (List<PricebookEntry>)standardSetController.getRecords()) {
            
            if(!orderItemMap.containsKey(record.product2Id)) {
                OrderItem orderItem = new OrderItem();
                
                orderItem.Quantity = 0;
                orderItem.Product2 = record.Product2;
                orderItem.Product2Id = record.Product2Id;
                orderItem.PricebookEntryId = record.Id;
                orderItem.UnitPrice = record.UnitPrice;
                
                orderItemList.add(orderItem);
                
                orderItemMap.put(orderItem.Product2Id, orderItem);
            } else {
                orderItemList.add(orderItemMap.get(record.product2Id));
            }
            
        }
    }


    /**
     * @name OnFieldChange
     * @description
    **/
    public void OnFieldChange(){
        //ToDo: Implement logic to store the values changed on the page
        for(OrderItem orderItem : orderItemList){
            orderItemMap.put(orderItem.Product2Id, orderItem);
        }
        
        //      and populate pieData
        //      and populate total
        loadChart();
    }
    
    public void loadChart() {
        pieData = new List<chartHelper.chartData>();
        total = 0;
        
        for(OrderItem orderItem : orderItemMap.values()) {
            if(orderItem.Quantity > 0) {
                pieData.add(new chartHelper.ChartData(orderItem.Product2.Name, (orderItem.Quantity*orderItem.UnitPrice)));
                total += (orderItem.Quantity*orderItem.UnitPrice);
            }
        }
    }

    /**
     * @name SelectFamily
     * @description
    **/
    public void SelectFamily(){
        //ToDo: Implement logic to filter based on the selected product family
        getProducts();
        loadChart();
    }

    /**
     * @name Save
     * @description
    **/
    public void Save(){
        //ToDo: Implement logic to save the Order and populated OrderItems
        Savepoint sp = Database.setSavepoint();
        
        try {
            if(orderRecord != null) {
                if(orderRecord.Pricebook2Id == null) {
                    orderRecord.Pricebook2Id = Constants.STANDARD_PRICEBOOK_ID;
                }
                
                upsert orderRecord;
            }
            
            List<OrderItem> orderItemsToUpsert = new List<OrderItem>();
            List<OrderItem> orderItemsToDelete = new List<OrderItem>();
            
            for(OrderItem orderItem : orderItemMap.values()){
                if(orderItem.Quantity > 0) {
                    if(orderItem.OrderId == null) {
                        orderItem.OrderId = orderRecord.Id;
                    }
                    orderItemsToUpsert.add(orderItem);
                } else {
                    if(orderItem.Id != null) {
                        //Existing record to delete
                        orderItemsToDelete.add(orderItem);

                        //Remove record from the Map
                        orderItemMap.remove(orderItem.Product2Id);
                    }
                }
            }
            
            if(!orderItemsToUpsert.isEmpty()) {
               upsert orderItemsToUpsert; 
            }
            
            if(!orderItemsToDelete.isEmpty()) {
                delete orderItemsToDelete;
            }
   
        } catch(DMLException e) {
            Database.rollback(sp);
            apexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, Constants.ERROR_MESSAGE));
        }
    }
    /**
     * @name First
     * @description
    **/
    public void First(){
	standardSetController.first();
        setOrderItemList();
    }


    /**
     * @name Next
     * @description
    **/
    public void Next(){
	standardSetController.next();
        setOrderItemList();
    }


    /**
     * @name Previous
     * @description
    **/
    public void Previous(){
	standardSetController.previous();
        setOrderItemList();
    }

    /**
     * @name Last
     * @description
    **/
    public void Last(){
	standardSetController.last();
        setOrderItemList();
    }

    /**
     * @name GetHasPrevious
     * @description
    **/
    public Boolean GetHasPrevious(){
        return standardSetController.getHasPrevious();
    }

    /**
     * @name GetHasNext
     * @description
    **/
    public Boolean GetHasNext(){
        return standardSetController.getHasNext();
    }

    /**
     * @name GetTotalPages
     * @description
    **/
    public Integer GetTotalPages(){
        return (Integer)math.ceil(standardSetController.getResultSize() / (Decimal)standardSetController.getPageSize());
    }

    /**
     * @name GetPageNumber
     * @description
    **/
    public Integer GetPageNumber(){
        return standardSetController.getPageNumber();
    }

    /**
     * @name GetFamilyOptions
     * @description
    **/
    public List<SelectOption> GetFamilyOptions() {
        List<SelectOption> family = new List<SelectOption>();
        
        family.add(new SelectOption(Constants.SELECT_ONE, Constants.SELECT_ONE));
        
        for(Schema.PicklistEntry entry : Constants.PRODUCT_FAMILY) {
            family.add(new SelectOption(entry.getValue(), entry.getLabel()));
        }

        return family;
    }

    /**
     * @name QueryOrderRecord
     * @description
    **/
    public static Order QueryOrderRecord(Id orderId){
        return [
            SELECT Id, AccountId, EffectiveDate, Name, Status, Pricebook2Id,
                (
                    SELECT Id, OrderId, Quantity, UnitPrice, PricebookEntryId, Product2Id,
                         Product2.Name, Product2.Family, Product2.Quantity_Remaining__c
                    FROM OrderItems
                )
            FROM Order
            WHERE Id = :orderId
        ];
    }

}
