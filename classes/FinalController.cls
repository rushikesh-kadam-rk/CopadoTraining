public class FinalController {
    
    @TestVisible 
    private static boolean siteAsContainerEnabled(String communityUrl) {
        Auth.AuthConfiguration authConfig = new Auth.AuthConfiguration(communityUrl,'');
        return authConfig.isCommunityUsingSiteAsContainer();
    }
    
    public static void CreateSiteUser(){}
    
    public Map< String, String> getPickListValuesIntoList(){ 
        //should return map
        Schema.DescribeFieldResult fieldResult = Lead.Rating.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        Map<String, String > pickListValuesMap = new Map<String, String >();
        
        for( Schema.PicklistEntry pickListVal : ple){
            pickListValuesMap.put(pickListVal.getLabel(), pickListVal.getValue());        
        }
        System.debug('pickListValuesMap---->'+pickListValuesMap);
        return pickListValuesMap;
        
    }

    public static LeadStatus getLeadStatus(){
        LeadStatus convertStatus = new LeadStatus();
       	convertStatus = [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted=true LIMIT 1];
        return convertStatus;    
    }
    public static void updateER(Database.LeadConvertResult[] lcra, List<Employee_Review__c> er){
        //Linking Contact to Employee Review
        for(Employee_Review__c erc: er){
            System.debug('lcr.getContactId()------->'+lcra[0].getContactId());
            erc.Contact__c = lcra[0].getContactId();
        }
        update er;
        
    }
    public static void convertLeads(List<Lead> lead, List<Contact> contact, 
                                    	List<Account> account, List<Employee_Review__c> er){
    	list<Database.LeadConvert> leadConverts = new list<Database.LeadConvert>();
        LeadStatus convertStatus = new LeadStatus();
        convertStatus = getLeadStatus();
        for(Lead myLead : lead){
            System.debug('myLead----->'+myLead);
            Database.LeadConvert lc = new Database.LeadConvert();
            lc.setLeadId(myLead.id);
            lc.setAccountId(account[0].ID);
            //for contact already present
            if(contact!=null && !contact.isEMpty()){
                lc.setContactId(contact[0].ID);
                lc.setAccountId(contact[0].AccountId);
            }
            lc.setDoNotCreateOpportunity(true);
            lc.setConvertedStatus(convertStatus.MasterLabel);
            leadConverts.add(lc);
        }
        if(leadConverts!=null && !leadConverts.isEmpty()){
            //converting leads
            Database.LeadConvertResult[] lcrList = Database.convertLead(leadConverts, true);
            if(lcrList!=null && !lcrList.isEmpty()){
                updateER(lcrList, er);
            }
            
        }
        
    }
    public static void leadConversion(){
        //String emailp = ApexPages.currentPage().getParameters().get('email');
        //ID leadid = ApexPages.currentPage().getParameters().get('id');
        String emailp = 'fry1@test.com';
        ID leadid = '00Q2v00001buPgXEAU';
        
        //Retrieve leads and contacts
        List<Lead> lead = [Select ID, Rating, Email from Lead where ID=:leadid LIMIT 1];
        List<Contact> contact = [Select ID, Email, AccountId from Contact where Email=:emailp LIMIT 1];
        List<Account> account = [Select ID, Name from Account where Name='Candidate Pool' LIMIT 1];
        System.debug('Lead-------->'+lead);
        System.debug('Account-------->'+account);
        List<Employee_Review__c> er = new List <Employee_Review__c>();
        
        /*set<ID> leadIds = new set<ID>();
        for(Lead newLead : lead){
            leadIds.add(newLead.Id);
        }*/
        //Retrive all related employee reviews
        //-->check lead is empty and not null(first), lead[0]
        er = [Select ID, Lead__c, Contact__c from Employee_Review__c 
                                 		where Lead__c=:lead[0].ID LIMIT 50000];
        
        System.debug('Lead---->'+lead);
        System.debug('Contact-------->'+contact);
        System.debug('Employee_Review-------->'+er);
        
        try{
            if(lead!=null && !lead.isEmpty()){
                convertLeads(lead, contact, account, er);             
            }
        }catch(Exception e){
            System.debug( 'Exception------->'+e.getMessage());
        }
    }
	
}