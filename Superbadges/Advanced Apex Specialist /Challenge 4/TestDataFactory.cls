/*
 * By: Alonso Ortiz - 02/Mar/2020
 * From: https://trailhead.salesforce.com/en/content/learn/superbadges/superbadge_aap
 *
 * Challenge 4: Create the Test Data Factory
 */

public with sharing class TestDataFactory {

    /**
     * @name ConstructCollaborationGroup
     * @description
    **/
    public static CollaborationGroup ConstructCollaborationGroup(){
        //ToDo: Ensure this method returns a single Chatter CollaborationGroup
        //    whose Name starts with 'TEST' followed by the INVENTORY_ANNOUNCEMENTS constant
        //    and configured so anyone can join, see and post updates.
        
        CollaborationGroup chatterGroup = new CollaborationGroup();
        chatterGroup.Name = 'TEST'+Constants.INVENTORY_ANNOUNCEMENTS;
        chatterGroup.CollaborationType = 'Public'; 
        
        return chatterGroup;
    }

    /**
     * @name CreateProducts
     * @description Constructs a list of Product2 records for unit tests
    **/
    public static List<Product2> ConstructProducts(Integer cnt){
        //ToDo: Ensure this method returns a list, of size cnt, of uniquely named Product2 records
        //  with all the required fields populated
        //  and IsActive = true
        //  an Initial Inventory set to 10
        //  and iterating through the product family picklist values throughout the list.
        
        List<Product2> products = new List<Product2>();
        List<Schema.PicklistEntry> family = Constants.PRODUCT_FAMILY;
        
        Integer famIndex = 0;
        
        for(Integer i = 0; i < cnt; i++) {
            if(famIndex == family.size()) famIndex = 0;
            
            Product2 product = new Product2();
            
            product.Name = 'PROD TEST '+(i+1);
            product.IsActive = true;
            product.Initial_Inventory__c = 10;
            product.Family = family[famIndex].getValue();
  
            products.add(product);
            
            famIndex++;
        }
        
        return products;
    }

    /**
     * @name CreatePricebookEntries
     * @description Constructs a list of PricebookEntry records for unit tests
    **/
    public static List<PriceBookEntry> ConstructPricebookEntries(List<Product2> prods){
        //ToDo: Ensure this method returns a corresponding list of PricebookEntries records
        //  related to the provided Products
        //  with all the required fields populated
        //  and IsActive = true
        //  and belonging to the standard Pricebook
        
        List<PriceBookEntry> entries = new List<PriceBookEntry>();

        for(Product2 product : prods) {
            PriceBookEntry entry = new PriceBookEntry();
            
            entry.UnitPrice = 10;
            entry.IsActive = true;
            entry.Pricebook2Id = Constants.STANDARD_PRICEBOOK_ID;
            entry.Product2Id = product.Id;
            
            entries.add(entry);
        }
        
        return entries;
 
    }

    /**
     * @name CreateAccounts
     * @description Constructs a list of Account records for unit tests
    **/
    public static List<Account> ConstructAccounts(Integer cnt){
        //ToDo: Ensure this method returns a list of size cnt of uniquely named Account records
        //  with all of the required fields populated.
        
        List<Account> accounts = new List<Account>();
        
        for(Integer i = 0; i < cnt; i++) { 
            Account account = new Account();
            
            account.Name = 'ACC TEST '+(i+1);
            
            accounts.add(account);
        }
        
        return accounts;
    }

    /**
     * @name CreateContacts
     * @description Constructs a list of Contacxt records for unit tests
    **/
    public static List<Contact> ConstructContacts(Integer cnt, List<Account> accts){
        //ToDo: Ensure this method returns a list, of size cnt, of uniquely named Contact records
        //  related to the provided Accounts
        //  with all of the required fields populated.
        
        List<Contact> contacts = new List<Contact>();
		Integer accsIndex = 0;
        
        for(Integer i = 0; i < cnt; i++) { 
            if(accsIndex == accts.size()) accsIndex = 0;
            
            Contact contact = new Contact();
            
            contact.FirstName = 'FN TEST '+(i+1);
            contact.LastName = 'LN TEST '+(i+1);
            contact.AccountId = accts[accsIndex].Id;
            
            contacts.add(contact);
            
            accsIndex++;
        }
        
        return contacts;
    }

    /**
     * @name CreateOrders
     * @description Constructs a list of Order records for unit tests
    **/
    public static List<Order> ConstructOrders(Integer cnt, List<Account> accts){
        //ToDo: Ensure this method returns a list of size cnt of uniquely named Order records
        //  related to the provided Accounts
        //  with all of the required fields populated.
        
        List<Order> orders = new List<Order>();
        Integer accsIndex = 0;
        
        for(Integer i = 0; i < cnt; i++) { 
            if(accsIndex == accts.size()) accsIndex = 0;
            
            Order order = new Order();
            
            order.Name = 'ORD TEST '+(i+1);
            order.AccountId = accts[accsIndex].Id;
            order.Status = 'Draft';
            order.EffectiveDate = System.today();
            order.Pricebook2Id = Constants.STANDARD_PRICEBOOK_ID;
            
            orders.add(order);
            
            accsIndex++;
        }

        return orders;
    }

    /**
     * @name CreateOrderItems
     * @description Constructs a list of OrderItem records for unit tests
    **/
    public static List<OrderItem> ConstructOrderItems(integer cnt, list<pricebookentry> pbes, list<order> ords){
        //ToDo: Ensure this method returns a list of size cnt of OrderItem records
        //  related to the provided Pricebook Entries
        //  and related to the provided Orders
        //  with all of the required fields populated.
        //  Hint: Use the DEFAULT_ROWS constant for Quantity as it will be used in the next challenge
        
        List<OrderItem> orderItems = new List<OrderItem>();
        Integer pbesIndex = 0;
        Integer ordsIndex = 0;
  
        for(Integer i = 0; i < cnt; i++) {
            if(pbesIndex == pbes.size()) pbesIndex = 0;
            if(ordsIndex == ords.size()) ordsIndex = 0;
            
            OrderItem orderItem = new OrderItem();
            
            orderItem.UnitPrice = 10*(i+1);
            orderItem.PricebookEntryId = pbes[pbesIndex].Id;
            orderItem.OrderId = ords[ordsIndex].Id;
            orderItem.Quantity = Constants.DEFAULT_ROWS;
            
            orderItems.add(orderItem);
            
            pbesIndex++;
            ordsIndex++;
        }
        
        return orderItems;
               
    }

    /**
     * @name SetupTestData
     * @description Inserts accounts, contacts, Products, PricebookEntries, Orders, and OrderItems.
    **/
    public static void InsertTestData(Integer cnt){
        //ToDo: Ensure this method calls each of the construct methods
        //  and inserts the results for use as test data.
        
        //Inserting Chatter Group
        CollaborationGroup chatterGroup = ConstructCollaborationGroup();
        insert chatterGroup;
        
        //Inserting Products
        List<Product2> products = ConstructProducts(cnt);
        insert products;
        
        //Inserting Pricebook Entries
        List<PriceBookEntry> pricebookEntries = ConstructPricebookEntries(products);
        insert pricebookEntries;
        
        //Inserting Accounts
        List<Account> accounts = ConstructAccounts(cnt);
        insert accounts;
        
        //Inserting Contacts
        List<Contact> contacts = ConstructContacts(cnt, accounts);
        insert contacts;
        
        //Inserting Orders
        List<Order> orders = ConstructOrders(cnt, accounts);
        insert orders;
        
        //Inserting Order Items
        List<OrderItem> orderItems = ConstructOrderItems(cnt, pricebookEntries, orders);
        insert orderItems;

    }

}