/*
 * By: Alonso Ortiz - 31/Jan/2020
 * From: https://trailhead.salesforce.com/en/content/learn/superbadges/superbadge_integration
 *
 * Challenge 8: Test outbound Apex SOAP callout logic
 */

@isTest
global class BillingCalloutServiceMock implements WebServiceMock {
    //Implement http mock callout here
    global void doInvoke(
        Object stub,
        Object request,
        Map<String, Object> response,
        String endpoint,
        String soapAction,
        String requestName,
        String responseNS,
        String responseName,
        String responseType) {
            
            BillingServiceProxy.billProjectResponse_element respElement = new BillingServiceProxy.billProjectResponse_element();
            respElement.status = 'OK';
            response.put('response_x', respElement);
	}
    
}