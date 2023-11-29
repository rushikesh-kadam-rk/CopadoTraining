/*
* @Class		: FyrAppEvent
* @Author		: DLee@Merkle Rushikesh@Merkle
* @Description	: Parse and convert JSON from FYR mobile app into Apex class
*/

public class FyrAppEvent {
	public cls_event event;
	public String api_version;	//1.0
	public class cls_event {
        public String environment;	//PRODUCTION
		public String type;	//FYR_SIGN_IN
        public String original_app_user_id;	//$RCAnonymousID:12345678-1234-1234-1234-123456789123
        public String firstname; //John
        public String lastname; //Doe
        public String email; //john.doe@merkle.com
        public String optin; //yes
	}
	public static FyrAppEvent parse(String json){
		return (FyrAppEvent) System.JSON.deserialize(json, FyrAppEvent.class);
	}
}