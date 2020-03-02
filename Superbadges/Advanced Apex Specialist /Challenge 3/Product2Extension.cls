/*
 * By: Alonso Ortiz - 02/Mar/2020
 * From: https://trailhead.salesforce.com/en/content/learn/superbadges/superbadge_aap
 *
 * Challenge 3: Update the new product Visualforce page
 */

public class Product2Extension {
    public List<ProductWrapper> productsToInsert {get;set;}
    
    ApexPages.StandardController standardProduct;
    
    public Product2Extension(ApexPages.StandardController controller ) {
        standardProduct = controller;
        
        productsToInsert = new List<ProductWrapper>();
        addRows();
    }

    public void AddRows(){
        for ( Integer i=0; i<Constants.DEFAULT_ROWS; i++ ){
            productsToInsert.add(new ProductWrapper());
        }
    }

    public List<ChartHelper.ChartData> GetInventory(){
        return ChartHelper.GetInventory();
    }
    
    public List<SelectOption> GetFamilyOptions() {
        List<SelectOption> family = new List<SelectOption>();
        
        family.add(new SelectOption(Constants.SELECT_ONE, Constants.SELECT_ONE));
        
        for(Schema.PicklistEntry entry : Constants.PRODUCT_FAMILY) {
            family.add(new SelectOption(entry.getValue(), entry.getLabel()));
        }

        return family;
    }

    public PageReference Save(){
        
        Savepoint sp = Database.setSavepoint();
        
        try {
            //insert productsToInsert;
            
            Map<Integer, Product2> products = new Map<Integer, Product2>();
            Map<Integer, PriceBookEntry> entries = new Map<Integer, PriceBookEntry>();
            Integer i = 0;
            
            for(ProductWrapper productWrapper : productsToInsert) {
                //Only entries on the page that have all fields populated should be saved; other entries shouldn’t be saved
                if(productBypass(productWrapper)) { 
                    products.put(i, productWrapper.productRecord);
                    
                    if(productWrapper.productRecord.isActive == false) {
                        productWrapper.pricebookEntryRecord.isActive = false;
                    } 
                    
                    entries.put(i, productWrapper.pricebookEntryRecord);
                }
                
                i++;
            }
            
            if(!products.isEmpty()) {
                insert products.values();
                
                for(Integer key : entries.keySet()) {
                    entries.get(key).Product2Id = products.get(key).Id;
                }
                
                insert entries.values();
                
                //If successful clear the list and display an informational message
                apexPages.addMessage(new ApexPages.message(ApexPages.Severity.INFO,products.size()+' Inserted'));
                productsToInsert.clear();   //Do not remove
                products.clear();
                entries.clear();
                addRows();  //Do not remove
    
            } else {
                apexPages.addMessage(new ApexPages.message(ApexPages.Severity.INFO, Constants.ERROR_INCOMPLETE_MESSAGE));
            }
            
            
        } catch(DMLException e) {
            Database.rollback(sp);
            apexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, Constants.ERROR_MESSAGE));
        }
        
        return null;
    }
    
    public Boolean productBypass(ProductWrapper productWrapper) {
        if( !String.isBlank(productWrapper.productRecord.Name) && 
           (!String.isBlank(productWrapper.productRecord.Family) && 
            productWrapper.productRecord.Family != Constants.SELECT_ONE) && 
           (productWrapper.pricebookEntryRecord.UnitPrice != null && productWrapper.pricebookEntryRecord.UnitPrice > 0) &&
           (productWrapper.productRecord.Initial_Inventory__c != null && productWrapper.productRecord.Initial_Inventory__c > 0) ) 
        {
            return true;
        } else {
            return false;
        }
    }
    
    public class ProductWrapper {
        public Product2 productRecord { get; set; }
        public PriceBookEntry pricebookEntryRecord { get; set; }
        
        public ProductWrapper() {
            productRecord = new Product2();
            pricebookEntryRecord = new PricebookEntry(UnitPrice = 0.0, Pricebook2Id = Constants.STANDARD_PRICEBOOK_ID, isActive = true);
        }
    }

}