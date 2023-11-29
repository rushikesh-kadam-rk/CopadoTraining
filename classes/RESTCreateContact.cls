@RestResource(urlMapping='/CreateContactURL/*')
global class RESTCreateContact {
    
    @HttpPost
	global static string createContact(String name, String email, String phone){
       	list<contact> conList = new list<contact>();
       	String message;
       	conList = [SELECT id, name, Email, MobilePhone FROM Contact WHERE Email =:email];
        
        if(conList.size()>0){
            message = 'Duplicate Contact';
        }else{
            Contact con = new Contact();
            con.LastName = name;
            con.Email = email;
            con.MobilePhone = phone;
            insert con; 
            message = 'Record Created Successfully of'+con.LastName;
        }
       return message;
    }
}