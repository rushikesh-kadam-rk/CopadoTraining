public with sharing class ContactController {
    public ContactController() {

    }
    
    @AuraEnabled(cacheable=true)
    public static List<Contact> getContacts(String searchKey){
        try {
            String key = '%'+searchKey+'%';
            return [SELECT Id, Name FROM Contact WHERE Name LIKE:key];
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    @AuraEnabled(cacheable=true)
    // public static List<LLC_BI__Legal_Entities__c> getEntityInvolvment(String loanId){
    public static void getEntityInvolvment(String loanId){
        try {
            //return [SELECT Id, LLC_BI__Account__c, LLC_BI__Account__r.Name, LLC_BI__Borrower_Type__c, LLC_BI__Contingent_Type__c, LLC_BI__Contingent_Amount__c, LLC_BI__Ownership__c, LLC_BI__Loan__c FROM LLC_BI__Legal_Entities__c WHERE LLC_BI__Loan__c =: loanId];
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static List<Account> createAccounts(List<Contact> conList){
        try {
            System.debug(conList);
            List<Account> accList = new List<Account>();
            if(conList!=NULL){
                for(Contact c: conList){
                    Account a = new Account();
                    a.Name = c.Name;
                    a.Type = 'Individual';
                    accList.add(a);
                    //yaha pe conact link karana h us account se
                }
                insert accList;
                return accList;
            }
            return null;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    @AuraEnabled
    public static void createEI(List<Account> accList, String loanId){
    
    }
    /*@AuraEnabled
    public static List<LLC_BI__Legal_Entities__c> createEI(List<Account> accList, String loanId){
        try {
            if(accList!= NULL){
                List<LLC_BI__Loan__c> loanList = [SELECT Id, LLC_BI__Product_Package__c FROM LLC_BI__Loan__c WHERE Id =: loanId];
                List<LLC_BI__Legal_Entities__c> eiList = new List<LLC_BI__Legal_Entities__c>();
            
                for(Account acc: accList){
                    LLC_BI__Legal_Entities__c ei = new 	LLC_BI__Legal_Entities__c();
                    ei.LLC_BI__Loan__c = loanList[0].Id;
                    ei.LLC_BI__Account__c = acc.Id;
                    ei.LLC_BI__Product_Package__c = loanList[0].LLC_BI__Product_Package__c;
                    eiList.add(ei);
                }
                if(!eiList.isEmpty()){
                    Database.insert(eiList);
                    return eiList;
                }
            }
            return null;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }*/
}