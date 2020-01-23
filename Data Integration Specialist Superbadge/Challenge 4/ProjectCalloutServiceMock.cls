/*
 * By: Alonso Ortiz - 22/Jan/2020
 * From: https://trailhead.salesforce.com/en/content/learn/superbadges/superbadge_integration
 *
 * Challenge 4: Test outbound Apex REST callout logic
 */

public class ProjectCalloutServiceMock implements HttpCalloutMock {
    //Implement http mock callout here
    
    public HTTPResponse respond(HTTPRequest request) {
        // Create a fake response
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        response.setStatusCode(201);
        response.setStatus('OK');
        
        return response; 
    }
}