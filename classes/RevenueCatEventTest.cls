/*
* @Class		: RevenueCatEventTest
* @Author		: DLee@Merkle
* @Description	: Test class for RevenueCatEvent
*/

@isTest private class RevenueCatEventTest {
    @isTest static void testParse() {
		String json = '{'+
		'  "event" : {'+
		'    "event_timestamp_ms" : 1601337615995,'+
		'    "product_id" : "com.revenuecat.myapp.monthly",'+
		'    "period_type" : "NORMAL",'+
		'    "purchased_at_ms" : 1601258901000,'+
		'    "expiration_at_ms" : 1601336705000,'+
		'    "environment" : "PRODUCTION",'+
		'    "entitlement_id" : "pro",'+
		'    "presented_offering_id" : "defaultoffering",'+
		'    "transaction_id" : "100000000000000",'+
		'    "original_transaction_id" : "100000000000000",'+
		'    "offer_code": "free_month",'+
		'    "app_user_id" : "$RCAnonymousID:12345678-1234-ABCD-1234-123456789123",'+
		'    "original_app_user_id" : "$RCAnonymousID:12345678-1234-1234-1234-123456789123",'+
		'    "cancel_reason" : "CUSTOMER_SUPPORT",'+
		'    "price" : -9.99,'+
		'    "price_in_purchased_currency" : -9.99,'+
		'    "store" : "APP_STORE",'+
		'    "takehome_percentage" : 0.7,'+
		'    "tax_percentage": 0.1109,'+
		'    "commission_percentage": 0.15,'+
		'    "type" : "CANCELLATION",'+
		'    "id" : "12345678-1234-1234-1234-12345678912"'+
		'  },'+
		'  "api_version" : "1.0"'+
		'}';
        Test.startTest();
		RevenueCatEvent obj = RevenueCatEvent.parse(json);
        Test.stopTest();
		Assert.areNotEqual(null, obj);
    }
}