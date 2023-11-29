/*
* @Class		: RevenueCatEvent
* @Author		: 
* @Description	: Parse and convert JSON from RevenueCat into Apex class
*/

public class RevenueCatEvent{
	public cls_event event;
	public String api_version;	//1.0
	public class cls_event {
		public Long event_timestamp_ms;	//1601337615995
		public String product_id;	//com.revenuecat.myapp.monthly
		public String period_type;	//NORMAL
		public Long purchased_at_ms;	//1601258901000
		public Long expiration_at_ms;	//1601336705000
		public String environment;	//PRODUCTION
		public String entitlement_id;	//pro
		public String presented_offering_id;	//defaultoffering
		public String transaction_id;	//100000000000000
		public String original_transaction_id;	//100000000000000
		public String offer_code;	//free_month
		public String app_user_id;	//$RCAnonymousID:12345678-1234-ABCD-1234-123456789123
		public String original_app_user_id;	//$RCAnonymousID:12345678-1234-1234-1234-123456789123
		public String cancel_reason;	//CUSTOMER_SUPPORT
		//public String currency;	//USD
		public Double price;	//-9.99
		public Double price_in_purchased_currency;	//-9.99
		public String store;	//APP_STORE
		public Double takehome_percentage;	//0.7
		public Double tax_percentage;	//0.1109
		public Double commission_percentage;	//0.15
		public String type;	//CANCELLATION
		public String id;	//12345678-1234-1234-1234-12345678912
        public List<String> aliases; //[ "$RCAnonymousID:8069238d6049ce87cc529853916d624c", $RCAnonymousID:12345678-1234-1234-1234-123456789123]
	}
	public static RevenueCatEvent parse(String json){
		return (RevenueCatEvent) System.JSON.deserialize(json, RevenueCatEvent.class);
	}
}