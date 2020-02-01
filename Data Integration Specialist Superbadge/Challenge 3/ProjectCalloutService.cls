/*
 * By: Alonso Ortiz - 21/Jan/2020
 * From: https://trailhead.salesforce.com/en/content/learn/superbadges/superbadge_integration
 *
 * Challenge 3: Synchronize Salesforce opportunity data with Square Peg's PMS external system
 */

public class ProjectCalloutService {
    //Complete the implementation for business and callout logic

    @InvocableMethod 
    public static void postOpportunityToPMS(List<Id> opportunityIds){
        if(!opportunityIds.isEmpty())
            System.enqueueJob(new QueueablePMSCall(opportunityIds[0]));
    }
    
    //Execute the callout logic.
    public class QueueablePMSCall implements Queueable, Database.AllowsCallouts { 

        private Id opportunityId;
        
        public QueueablePMSCall(Id opportunityId) { 
            this.opportunityId = opportunityId;
        }
        
        public void execute(QueueableContext context) {
            
            List<Opportunity> opportunities = getOpportunityInfo(opportunityId);
            
            if(!opportunities.isEmpty()) {
                HttpRequest request = createRequest(opportunities[0]);
                
                HttpResponse response = new Http().send(request);
                
                if(response.getStatusCode() != 201) {
                    opportunities[0].StageName = 'Resubmit Project';
                } else {
                    opportunities[0].StageName = 'Submitted Project';
                }
                
                update opportunities[0];
            }
            
        }
        
        private List<Opportunity> getOpportunityInfo(Id opportunityId) {
            List<Opportunity> opportunityInfo = [Select Id, Name, Account.Name, CloseDate, Amount
                                                 From Opportunity
                                                 Where Id =: opportunityId];
            
            return opportunityInfo;
        }
        
        private HttpRequest createRequest(Opportunity opp) {
            String projectServiceToken = ServiceTokens__c.getInstance('ProjectServiceToken').Token__c;
            
            Http http = new Http();
            HttpRequest request = new HttpRequest();
            
            request.setHeader('token', projectServiceToken);
            request.setEndpoint('callout:ProjectService');
            request.setMethod('POST');
            request.setHeader('Content-Type', 'application/json;charset=UTF-8');
            request.setBody(serializeBody(opp));

            return request;
        }
        
        private String serializeBody(Opportunity opp) {
            String body = opp.Id + opp.Name + opp.Account.Name + opp.CloseDate + opp.Amount;

            return JSON.serialize(body);
        }
    }
}