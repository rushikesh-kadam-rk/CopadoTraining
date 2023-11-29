global Class CreateContactUsingSOAP{

    Webservice static string createCon(String name, String emailVar, String mobile){
       
       if(emailVar != null && mobile != null){
           list<contact> existingContactList = new list<contact>();
           existingContactList = [SELECT id FROM Contact WHERE Email =:emailVar AND MobilePhone=:mobile];
           
           if(existingContactList.size() == 0){
               
               Contact con = new Contact();
                con.LastName = name;
                con.Email = emailVar;
                con.MobilePhone = mobile;
              insert con; 
               return 'Contact Created Successfully with ID: '+con.id;
           } else{
               
               return 'Duplicate Contact';
           }          
       } 
       
       return NULL;
    }
}