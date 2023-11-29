/*
* @Class		: FyrAppEventTest
* @Author		: DLee@Merkle
* @Description	: Test class for FyrAppEvent
*/

@isTest private class FyrAppEventTest {
    @isTest static void testParse() {
		String json = '{'+
		'  "event" : {'+
		'    "environment" : "PRODUCTION",'+
		'    "type" : "FYR_SIGN_IN",'+
		'    "original_app_user_id" : "$RCAnonymousID:12345678-1234-1234-1234-123456789123",'+
		'    "firstname" : "JohnTest",'+
		'    "lastname" : "DoeTest",'+
		'    "email" : "john.doe@merkle.com.invalid",'+
		'    "optin" : "yes"'+
		'  },'+
		'  "api_version" : "1.0"'+
		'}';
        Test.startTest();
		FyrAppEvent obj = FyrAppEvent.parse(json);
        Test.stopTest();
        Assert.areNotEqual(null, obj);
    }
}