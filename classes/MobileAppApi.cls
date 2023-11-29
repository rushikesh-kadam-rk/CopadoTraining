/*
* @Class		: MobileAppApi
* @Author		: DLee@Merkle Rushikesh@Merkle
* @Description	: API listener for FYR mobile app events
*/

@RestResource(urlMapping='/MobileAppApi/*')
global without sharing class MobileAppApi {
    /* GET method - read Lead for testing if API is accessible */
    @HttpGet global static Lead doGet() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        String strLeadId = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
        Lead result = [SELECT Id, FirstName, LastName, Email, HasOptedOutOfEmail FROM Lead WHERE Id=:strLeadId LIMIT 1];
        return result;
    }
    
    /* POST method - create Lead */
    @HttpPost global static void doPost() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        FyrAppEvent fyrEvent = FyrAppEvent.parse(req.requestBody.toString());
        String result = LeadUtils.create(fyrEvent.event.firstname, fyrEvent.event.lastname, fyrEvent.event.email, fyrEvent.event.optin);
        res.addHeader('Content-Type', 'application/json');
        switch on result {
            when 'LEAD_UPDATED' {
                res.statusCode = 200;
                res.responseBody = Blob.valueOf(JSON.serialize(new Response('Lead Updated.', null)));
            }
            when 'SUCCESS' {
                res.statusCode = 201;
                res.responseBody = Blob.valueOf(JSON.serialize(new Response('Lead created.', null)));
            }
            when 'LEAD_ALREADY_CONVERTED' {
                res.statusCode = 409;
                res.responseBody = Blob.valueOf(JSON.serialize(new Response('Insert failed.', result)));
            }
            when else {
                res.statusCode = 400;
                res.responseBody = Blob.valueOf(JSON.serialize(new Response('Insert failed.', result)));
            }
        }
    }

    /* PUT method - update Lead */
    @HttpPut global static void doPut() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        FyrAppEvent fyrEvent = FyrAppEvent.parse(req.requestBody.toString());
        String result = LeadUtils.updateLead(fyrEvent.event.original_app_user_id, fyrEvent.event.email);
        res.addHeader('Content-Type', 'application/json');
        switch on result {
            when 'LEAD_CONVERTED' {
                res.statusCode = 200;
                res.responseBody = Blob.valueOf(JSON.serialize(new Response('Lead Converted', null)));
            }
            when 'LEAD_DOES_NOT_EXIST' {
                res.statusCode = 404;
                res.responseBody = Blob.valueOf(JSON.serialize(new Response('Update Failed', 'EXISTING_LEAD_NOT_FOUND')));
            }
            when 'LEAD_ALREADY_QUALIFIED', 'DUPLICATES_DETECTED' {
                res.statusCode = 409;
                res.responseBody = Blob.valueOf(JSON.serialize(new Response('Update failed.', 'LEAD_ALREADY_QUALIFIED')));
            }
            when else {
                res.statusCode = 400;
                res.responseBody = Blob.valueOf(JSON.serialize(new Response('Update failed.', result)));
            }
        }
    }
    
    public class Response {
        public String message;
        public String error;
        public Response(String message, string error) {
            this.message = message;
            this.error = error;
        }
    }
}