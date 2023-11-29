public class CON_TH {
    public static Boolean recursionBoolean = false;
    
    public static void beforeInsert(List<Contact> conNewList){
        recursionBoolean = true;
        //preventDuplicateContacts(conNewList);
    }
    
    public static void afterInsert(List<Contact> conNewList, Map<Id, Contact> oldConMap){
        recursionBoolean = true;
        //handleIntegrationUsingSOAP(conNewList);
    }
    
    public static void afterUpdate(List<Contact> conNewList, Map<Id, Contact> oldConMap){
        //handleIntegrationUsingSOAP(conNewList);
    }
    
    public static void preventDuplicateContacts(List<Contact> newConList){
    	Map<String, Contact> existingContacts = new Map<String, Contact>();
        Set<String> nameSet = new Set<String>();
        Set<String> emailSet = new Set<String>();
        for(Contact newCon : newConList) {
            nameSet.add(newCon.Name);
            if(newCon.Email != NULL){
                emailSet.add(newCon.Email);
            }
        }
    
        // Create a map of existing Contacts based on email and name combination
        for(Contact con : [SELECT Id, Email, Name, FirstName, LastName
                           			FROM Contact 
                           			WHERE (Email IN: emailSet OR Name IN: nameSet)]) {
            String key = con.Email.toLowerCase() + con.FirstName.toLowerCase() + con.LastName.toLowerCase();
            existingContacts.put(key, con);
        }
    
        // Check each new Contact to see if it matches an existing Contact
        for(Contact newCon : newConList) {
            String key = newCon.Email.toLowerCase() + newCon.FirstName.toLowerCase() + newCon.LastName.toLowerCase();
            if(existingContacts.containsKey(key)) {
                Contact existingCon = existingContacts.get(key);
                //newCon.addError('A Contact with this email and name combination already exists (ID: ' + existingCon.Id + ')');
            }
        }
	}
    
    
    public static void handleIntegrationUsingSOAP(List<Contact> newContactList){
        for(Contact con : newContactList){
            if(con.LastName != '' && con.LastName != NULL){
                String firstName = con.FirstName;
                String lastName = con.LastName;
                String title = con.Title;
                String email = con.Email;
                Id conId = con.Id;
                
                sendContactToExternalSystemUsingSOAP(firstName, lastName, title, email);
            }
        }
    }
    
    @future(callout=true)
    public static void sendContactToExternalSystemUsingSOAP(String firstName, String lastName, String title, String email){
        
        partnerSoapSforceComUdemy.Soap myPartnerSoap = new partnerSoapSforceComUdemy.Soap();
        //Authenticate and generate sessionId
        partnerSoapSforceComUdemy.LoginResult partnerLoginResult = myPartnerSoap.login('rushikeshkadamsfdc+crmanalytics@gmail.com', 'Rk@123123mbPY5LGl7YZuuoahNZoNLH2DF');
    	
        String sessionIdOfChild = partnerLoginResult.sessionId;
        
        soapSforceComSchemasClassReceivepar.SessionHeader_element webServiceSessionHeader = new soapSforceComSchemasClassReceivepar.SessionHeader_element();
        webServiceSessionHeader.sessionId = sessionIdOfChild;
        
        soapSforceComSchemasClassReceivepar.ReceiveParametersFromParent objOfChild = new soapSforceComSchemasClassReceivepar.ReceiveParametersFromParent();
        objOfChild.SessionHeader = webServiceSessionHeader;
        //call child method
        String status = objOfChild.createContactRecord(firstName, lastName, title, email);
        
    }

}