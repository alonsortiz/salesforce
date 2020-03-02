/*
 * By: Alonso Ortiz - 22/Jan/2020
 * From: https://trailhead.salesforce.com/en/content/learn/superbadges/superbadge_integration
 *
 * Challenge 4: Test outbound Apex REST callout logic
 */

public class ProjectCalloutServiceMockFailure implements HttpCalloutMock {
    //Implement http mock callout failure here 
    
    public HTTPResponse respond(HTTPRequest request) {
        // Create a fake response
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        response.setStatusCode(500);
        response.setStatus('Internal Server Error');
        
        return response; 
    }
}