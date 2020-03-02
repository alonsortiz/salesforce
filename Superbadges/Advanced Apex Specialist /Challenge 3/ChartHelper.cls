/*
 * By: Alonso Ortiz - 02/Mar/2020
 * From: https://trailhead.salesforce.com/en/content/learn/superbadges/superbadge_aap
 *
 * Challenge 3: Update the new product Visualforce page
 */

public without sharing class ChartHelper {

    @AuraEnabled
    public static List<chartData> GetInventory(){
        List<chartData> cht = new List<chartData>();
        //ToDo: Perform a calculation that aggregates active Products that have a positive Quantity_Remaining__c

        AggregateResult[] aggregateResult = [SELECT Family, SUM(Quantity_Remaining__c) quantityRemaining
                                             FROM Product2
                                             WHERE isActive = true
                                             AND Quantity_Remaining__c > 0
                                             GROUP BY Family];
        
        //ChartData c = new ChartData('','');
        //  And return a list of chartData
        //  Where the name is the Product Family and the Qty is the sum of the Quantity_Remaining__c
        
        for(AggregateResult aggregate : aggregateResult) {
            cht.add(new ChartData((String)aggregate.get('Family'), Integer.valueOf(aggregate.get('quantityRemaining'))));
        }
        
        return cht;
    }

    public class ChartData {
        public String name {get;set;}
        public Decimal val {get;set;}

        public ChartData(String name, Decimal val){
            this.name = name;
            this.val = val;
        }
    }

}