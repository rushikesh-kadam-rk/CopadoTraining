/*
* @Class		: LeadUtils
* @Author		: DLee@Merkle Rushikesh@Merkle
* @Description	: - Create new lead
                  - Convert lead into Person Account
*/

public without sharing class LeadUtils {

    /* Create lead */
    public static String create(String firstname, String lastname, String email, String optin) {
        if(String.isNotBlank(email) && String.isNotBlank(lastname)){
            Lead existingLead = checkExistingLead(email);
            if(existingLead != NULL){
                if(!existingLead.IsConverted){
                     //Existing Lead Present and Not Converted
                    existingLead.HasOptedOutOfEmail = (optin=='yes') ? false : true;
                    try {
                        update existingLead;
                        return 'LEAD_UPDATED';
                    } catch (DmlException e) {
                        return e.getDmlStatusCode(0);
                    }
                }else{
                    ////Existing Lead Present and Converted
                    return 'LEAD_ALREADY_CONVERTED';
                }
            }else{
                //Existing Lead Not Present
                Lead newLead = new Lead();
                newLead.FirstName = firstname;
                newLead.LastName = lastname;
                newLead.Email = email;
                newLead.HasOptedOutOfEmail = (optin=='yes') ? false : true;
                try {
                    insert newLead;
                    return 'SUCCESS';
                } catch (DmlException e) {
                    return e.getDmlStatusCode(0);
                }
            }
        }else{
            return 'REQUIRED_FIELD_MISSING';
        }
    }
    
    public static Lead checkExistingLead(String email){
        List<Lead> existingLeadList = [SELECT Id, IsConverted  FROM Lead WHERE Email=:email LIMIT 1];
        if(existingLeadList.isEmpty()){
            return NULL;
        }else{
            return existingLeadList[0];
        }
    }
        
    /* Update Lead with Subscription ID*/
    public static String updateLead(String original_app_user_id, String email) {
        if (String.isNotBlank(original_app_user_id) &&  String.isNotBlank(email)){
            Lead existingLead = checkExistingLead(email);
            if(existingLead != NULL){
                if(!existingLead.IsConverted ){
                    //Existing Lead Present and Not Converted
                    existingLead.original_app_user_id__c = original_app_user_id;
                    //existingLead.HasOptedOutOfEmail = (optin=='yes') ? false : true;
                    existingLead.Account_Membership_Status__c = 'Subscribed';
                    try {
                        update existingLead;
                        return convert(original_app_user_id);
                    } catch (DmlException e) {
                        return e.getDmlStatusCode(0);
                    }
                }else{
                    //Existing Lead Present and Converted
                    return 'LEAD_ALREADY_CONVERTED';
                }
            }else{
                //Existing Lead Not Present
                return 'LEAD_DOES_NOT_EXIST';
            }
        }else{
            return 'REQUIRED_FIELDS_MISSING';
        }
    }
    
    /* Convert lead */
    public static String convert(String original_app_user_id) {
        // Retrieve LeadStatus 'Closed - Converted'
        LeadStatus convertStatus = [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted=true LIMIT 1];
        
        // Retrieve leads with original_app_user_id
		Lead userLead = [SELECT Id FROM Lead WHERE original_app_user_id__c=:original_app_user_id LIMIT 1];
        
        // Set status for retrieved lead
        Database.LeadConvert lc = new Database.LeadConvert();
        lc.setLeadId(userLead.Id);
        lc.setConvertedStatus(convertStatus.MasterLabel);
        lc.setDoNotCreateOpportunity(true);
        Database.LeadConvertResult lcr;
        
        // Convert lead
        try {
            lcr = Database.convertLead(lc);
            if (lcr.isSuccess()) {
                return 'LEAD_CONVERTED';
            } else {
                System.debug('Lead conversion database error:');
                System.debug(lcr.getErrors()[0].getMessage());
                return lcr.getErrors()[0].getMessage();
            }            
        } catch (Exception e) {
            System.debug('Exception:');
            System.debug(e.getMessage());
            return e.getMessage();
        }
    }
    
}