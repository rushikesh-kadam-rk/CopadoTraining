/*
* @Class		: WebhookApi
* @Author		: 
* @Description	: API listener for RevenueCat webhooks
*/

@RestResource(urlMapping='/WebhookApi/*')
global without sharing class WebhookApi {
    /* GET method - for testing if API works */
    @HttpGet global static void doGet() {
        // Retrieve Revenue Cat Settings from Custom Metadata
        String rcHeader = rcSettings.Header__c;
        String rcToken = rcSettings.Token__c;
        Boolean rcHashed = rcSettings.Use_Hashing__c;

        // Parse RevenueCat event
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        String strToken = req.headers.get(rcHeader);

        // Check if hashing is used in Revenue Cat Settings
        Boolean tokenMatch = false;
        if (rcHashed) {
            Blob blobHash = Crypto.generateDigest('SHA3-512', Blob.valueOf(strToken));
            String strHash = EncodingUtil.convertToHex(blobHash);
            tokenMatch = (strHash == rcToken);
        } else {
            tokenMatch = (strToken == rcToken);
        }

        // Check if token matches
        if (tokenMatch) {
            res.statusCode = 200;
            res.responseBody = Blob.valueOf(JSON.serialize(new Response('Webhook API GET success.', null)));
        } else {
            res.statusCode = 400;
            res.responseBody = Blob.valueOf(JSON.serialize(new Response('Error', 'UNAUTHORIZED')));
        }
    }
    
    /* POST method - convert Lead */
    @HttpPost global static void doPost() {
        // Retrieve Revenue Cat Settings from Custom Metadata
        String rcHeader = rcSettings.Header__c;
        String rcToken = rcSettings.Token__c;
        Boolean rcHashed = rcSettings.Use_Hashing__c;

        // Parse RevenueCat event
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        String strToken = req.headers.get(rcHeader);

        // Check if hashing is used in Revenue Cat Settings
        Boolean tokenMatch = false;
        if (rcHashed) {
            Blob blobHash = Crypto.generateDigest('SHA3-512', Blob.valueOf(strToken));
            String strHash = EncodingUtil.convertToHex(blobHash);
            tokenMatch = (strHash == rcToken);
        } else {
            tokenMatch = (strToken == rcToken);
        }

        // Check if token matches
        if (tokenMatch) {
            RevenueCatEvent revCatEvent = RevenueCatEvent.parse(req.requestBody.toString());
            String appUserId = revCatEvent.event.original_app_user_id;
            String eventType = revCatEvent.event.type;
            String productId = revCatEvent.event.product_id;
            List<String> aliases = new List<String>();
            if(revCatEvent.event.aliases != NULL){
                aliases = revCatEvent.event.aliases;
            }
            aliases.add(appUserId);
            Logs__c log = new Logs__c();
            log.Error_Message__c = String.join(aliases, '::');
            insert log;
            // Handle RevenueCat event
            String result = 'INVALID_PAYLOAD';
            if (revCatEvent.event.environment=='PRODUCTION') {
                result = RevenueCatEventHandler.onEvent(appUserId, eventType, productId, aliases);
            }
            
            // Set response according to result
            res.addHeader('Content-Type', 'application/json');
            switch on result {
                when 'ACCOUNT_UPDATED' {
                    res.statusCode = 201;
                    res.responseBody = Blob.valueOf(JSON.serialize(new Response('Account updated.', null)));    
                }
                when else {
                    res.statusCode = 400;
                    res.responseBody = Blob.valueOf(JSON.serialize(new Response('Failed to update account.', result)));
                }
            }
        // Error - no token is passed
        } else {
            res.statusCode = 400;
            res.responseBody = Blob.valueOf(JSON.serialize(new Response('Error', 'UNAUTHORIZEDRK')));
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
    // Retrieve custom metadata to rcSettings property
    // Settable by unit tests so that we can set test custom metadata (it is not possible to insert test custom metadata)
    @TestVisible public static RevenueCat_Setting__mdt rcSettings{
        get{
            if(rcSettings == null){
                rcSettings = [SELECT Id, Header__c, Token__c, Use_Hashing__c FROM RevenueCat_Setting__mdt LIMIT 1];
            }
            return rcSettings;
        }
        private set;
    }
}