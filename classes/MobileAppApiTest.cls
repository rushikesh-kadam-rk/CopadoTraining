/*
* @Class		: MobileAppApiTest
* @Author		: DLee@Merkle
* @Description	: Test class for MobileAppApi
*/

@isTest public class MobileAppApiTest {
    @TestVisible private static String testAppUserId1 = '$RCAnonymousID:12345678-1234-1234-1234-123456789121';
    @TestVisible private static String testFirstName1 = 'JohnTest';
    @TestVisible private static String testLastName1 = 'DoeTest';
    @TestVisible private static String testEmail1 = 'john.doe@merkle.com.invalid';
    @TestVisible private static String testJson1 = '{'+
		'  "event" : {'+
		'    "environment" : "PRODUCTION",'+
		'    "type" : "FYR_SIGN_IN",'+
		'    "original_app_user_id" : "'+testAppUserId1+'",'+
		'    "firstname" : "'+testFirstName1+'",'+
        '    "lastname" : "'+testLastName1+'",'+
		'    "email" : "'+testEmail1+'",'+
		'    "optin" : "yes"'+
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
		'    "type" : "FYR_SIGN_IN",'+
		'    "original_app_user_id" : "'+testAppUserId2+'",'+
		'    "firstname" : "'+testFirstName2+'",'+
        '    "lastname" : "'+testLastName2+'",'+
		'    "email" : "'+testEmail2+'",'+
		'    "optin" : "yes"'+
		'  },'+
		'  "api_version" : "1.0"'+
		'}';
        @TestVisible private static String testJson3 = '{'+
		'  "event" : {'+
		'    "environment" : "PRODUCTION",'+
		'    "type" : "FYR_SIGN_IN",'+
		'    "original_app_user_id" : "",'+
		'    "firstname" : "",'+
        '    "lastname" : "",'+
		'    "email" : "",'+
		'    "optin" : "yes"'+
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
    }
    
    @isTest static void testDoGet(){
        Lead testLead = [SELECT Id FROM Lead WHERE original_app_user_id__c=:testAppUserId1 LIMIT 1];
        // Set up a test request
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestUri = '/services/apexrest/MobileAppApi/' + testLead.Id;
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = res;
        // Call the method to test
        Test.startTest();
        Lead responseLead = MobileAppApi.doGet();
        Test.stopTest();
        // Verify results
        Assert.areEqual(testLead.Id, responseLead.Id);
    }
    
    @isTest static void testDoPost(){
        // Set up a test request
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestUri = '/services/apexrest/MobileAppApi/';
        req.httpMethod = 'POST';
        req.addHeader('Content-Type', 'application/json');
        req.requestBody = Blob.valueof(testJson2);
        RestContext.request = req;
        RestContext.response = res;
        // Call the method to test
        Test.startTest();
        MobileAppApi.doPost();
        Test.stopTest();
        // Verify results
        Assert.areEqual(201, res.statusCode);
    }
    
    @isTest static void testDoPostDuplicate(){
        // Set up a test request
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestUri = '/services/apexrest/MobileAppApi/';
        req.httpMethod = 'POST';
        req.addHeader('Content-Type', 'application/json');
        req.requestBody = Blob.valueof(testJson1);
        RestContext.request = req;
        RestContext.response = res;
        // Call the method to test
        Test.startTest();
        MobileAppApi.doPost();
        Test.stopTest();
        // Verify results
        Assert.areEqual(409, res.statusCode);
    }

    @isTest static void testDoPostRequiredFieldMissing(){
        // Set up a test request
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestUri = '/services/apexrest/MobileAppApi/';
        req.httpMethod = 'POST';
        req.addHeader('Content-Type', 'application/json');
        req.requestBody = Blob.valueof(testJson3);
        RestContext.request = req;
        RestContext.response = res;
        // Call the method to test
        Test.startTest();
        MobileAppApi.doPost();
        Test.stopTest();
        // Verify results
        Assert.areEqual(400, res.statusCode);
    }
}