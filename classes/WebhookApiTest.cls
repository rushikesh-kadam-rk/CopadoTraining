/*
* @Class		: WebhookApiTest
* @Author		: DLee@Merkle
* @Description	: Test class for WebhookApi
*/

@isTest public class WebhookApiTest {
    @TestVisible private static String rcHeader = 'X-RevenueCat-Token';
    @TestVisible private static String rcToken = 'rushikesh1234';
    @TestVisible private static String jsonMetadata = '{'+
        '  "Header__c" : "'+rcHeader+'",'+
        '  "Token__c" : "'+rcToken+'",'+
        '  "Use_Hashing__c": false'+
    '}';
    @TestVisible private static String testRequestUri = '/services/apexrest/WebhookApi/';
    @TestVisible private static String testAppUserId1 = '$RCAnonymousID:12345678-1234-1234-1234-123456789121';
    @TestVisible private static String testFirstName1 = 'JohnTest';
    @TestVisible private static String testLastName1 = 'DoeTest';
    @TestVisible private static String testEmail1 = 'john.doe@merkle.com.invalid';
    @TestVisible private static String testJson1 = '{'+
        '  "event" : {'+
		'    "environment" : "PRODUCTION",'+
        '    "product_id" : "com.revenuecat.myapp.monthly",'+
        '    "original_app_user_id" : "'+testAppUserId1+'",'+
        '    "type" : "INITIAL_PURCHASE"'+
        '  },'+
        '  "api_version" : "1.0"'+
        '}';
    @TestVisible private static String testAppUserId2 = '$RCAnonymousID:12345678-1234-1234-1234-123456789122';
    @TestVisible private static String testFirstName2 = 'JaneTest';
    @TestVisible private static String testLastName2 = 'DoeTest';
    @TestVisible private static String testEmail2 = 'jane.doe@merkle.com.invalid';
    @TestVisible private static String testJson2 = '{'+
        '  "event" : {'+
		'    "environment" : "PRODUCTION",'+
        '    "product_id" : "com.revenuecat.myapp.monthly",'+
        '    "original_app_user_id" : "'+testAppUserId2+'",'+
        '    "type" : "INITIAL_PURCHASE",'+
        '    "aliases" : ["'+testAppUserId2+'"]'+
        '  },'+
        '  "api_version" : "1.0"'+
        '}';
    @TestVisible private static String testJson3 = '{'+
        '  "event" : {'+
		'    "environment" : "PRODUCTION",'+
        '    "product_id" : "com.revenuecat.myapp.monthly",'+
        '    "original_app_user_id" : "$RCAnonymousID:12345678-1234-1234-1234-123456789123",'+
        '    "type" : "CANCELLATION"'+
        '  },'+
        '  "api_version" : "1.0"'+
        '}';
    @TestVisible private static String testJson4 = '{'+
        '  "event" : {'+
		'    "environment" : "PRODUCTION",'+
        '    "product_id" : "com.revenuecat.myapp.monthly",'+
        '    "original_app_user_id" : "$RCAnonymousID:12345678-1234-1234-1234-123456789124",'+
        '    "type" : "TEST"'+
        '  },'+
        '  "api_version" : "1.0"'+
        '}';

    @testSetup static void setup() {
        Lead testLead = new Lead(
            original_app_user_id__c = testAppUserId1,
            FirstName = testFirstName1,
        	LastName = testLastName1,
        	Email = testEmail1,
            HasOptedOutOfEmail = false
        );
        insert testLead;
        Id prsnAccountRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('PersonAccount').getRecordTypeId();
        Account testAcct = new Account(
            RecordTypeId= prsnAccountRecTypeId,
            original_app_user_id__c = testAppUserId2,
            FirstName = testFirstName2,
        	LastName = testLastName2,
        	PersonEmail = testEmail2,
            PersonHasOptedOutOfEmail = false
        );
        insert testAcct;
    }
    
    @isTest static void testDoGet(){
        // Set up a test request
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestUri = testRequestUri;
        req.httpMethod = 'GET';
        req.addHeader(rcHeader, rcToken);
        RestContext.request = req;
        RestContext.response = res;
        // Call the method to test
        Test.startTest();
        WebhookApi.rcSettings = (RevenueCat_Setting__mdt) JSON.deserialize(jsonMetadata, RevenueCat_Setting__mdt.class);
        WebhookApi.doGet();
        Test.stopTest();
        // Verify results
        Assert.areEqual(200, res.statusCode);
    }

    @isTest static void testDoGetWithoutToken(){
        // Set up a test request
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestUri = testRequestUri;
        req.httpMethod = 'GET';
        req.addHeader(rcHeader, '');
        RestContext.request = req;
        RestContext.response = res;
        // Call the method to test
        Test.startTest();
        WebhookApi.doGet();
        Test.stopTest();
        // Verify results
        Assert.areEqual(400, res.statusCode);
    }
    
    /*@isTest static void testDoPostLeadConversion(){
        // Set up a test request
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestUri = testRequestUri;
        req.httpMethod = 'POST';
        req.addHeader('Content-Type', 'application/json');
        req.addHeader(rcHeader, rcToken);
        req.requestBody = Blob.valueof(testJson1);
        RestContext.request = req;
        RestContext.response = res;
        // Call the method to test
        Test.startTest();
        WebhookApi.rcSettings = (RevenueCat_Setting__mdt) JSON.deserialize(jsonMetadata, RevenueCat_Setting__mdt.class);
        WebhookApi.doPost();
        Test.stopTest();
        // Verify results
        Assert.areEqual(201, res.statusCode);
    }*/
    
    @isTest static void testDoPostAccountUpdate(){
        // Set up a test request
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestUri = testRequestUri;
        req.httpMethod = 'POST';
        req.addHeader('Content-Type', 'application/json');
        req.addHeader(rcHeader, rcToken);
        req.requestBody = Blob.valueof(testJson2);
        RestContext.request = req;
        RestContext.response = res;
        // Call the method to test
        Test.startTest();
        WebhookApi.rcSettings = (RevenueCat_Setting__mdt) JSON.deserialize(jsonMetadata, RevenueCat_Setting__mdt.class);
        WebhookApi.doPost();
        Test.stopTest();
        // Verify results
        Assert.areEqual(201, res.statusCode);
    }
    
    @isTest static void testDoPostUserNotFound(){
        // Set up a test request
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestUri = testRequestUri;
        req.httpMethod = 'POST';
        req.addHeader('Content-Type', 'application/json');
        req.addHeader(rcHeader, rcToken);
        req.requestBody = Blob.valueof(testJson3);
        RestContext.request = req;
        RestContext.response = res;
        // Call the method to test
        Test.startTest();
        WebhookApi.rcSettings = (RevenueCat_Setting__mdt) JSON.deserialize(jsonMetadata, RevenueCat_Setting__mdt.class);
        WebhookApi.doPost();
        Test.stopTest();
        // Verify results
        Assert.areEqual(400, res.statusCode);
    }
    
    @isTest static void testDoPostEventTypeNotHandled(){
        // Set up a test request
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestUri = testRequestUri;
        req.httpMethod = 'POST';
        req.addHeader('Content-Type', 'application/json');
        req.addHeader(rcHeader, rcToken);
        req.requestBody = Blob.valueof(testJson4);
        RestContext.request = req;
        RestContext.response = res;
        // Call the method to test
        Test.startTest();
        WebhookApi.rcSettings = (RevenueCat_Setting__mdt) JSON.deserialize(jsonMetadata, RevenueCat_Setting__mdt.class);
        WebhookApi.doPost();
        Test.stopTest();
        // Verify results
        Assert.areEqual(400, res.statusCode);
    }

    @isTest static void testDoPostWithoutToken(){
        // Set up a test request
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestUri = testRequestUri;
        req.httpMethod = 'POST';
        req.addHeader('Content-Type', 'application/json');
        req.addHeader(rcHeader, '');
        req.requestBody = Blob.valueof(testJson1);
        RestContext.request = req;
        RestContext.response = res;
        // Call the method to test
        Test.startTest();
        WebhookApi.doPost();
        Test.stopTest();
        // Verify results
        Assert.areEqual(400, res.statusCode);
    }
}