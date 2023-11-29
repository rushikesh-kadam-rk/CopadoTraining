public class EB_CaseReplacementProductUtility {
	@AuraEnabled
    public static Profile getProfileInfo(){
        try{
            String profileId = UserInfo.getProfileId();
            Profile profile = [SELECT Id, Name FROM Profile WHERE Id =:profileId];
            return profile;
        }catch(Exception e){
            throw new AuraHandledException(e.getMessage());
        }
    }
    @AuraEnabled
    public static User getUserInfo(){
        try{
            String userId = UserInfo.getUserId();
            User myUser = [SELECT Id, Title from user where Id = :userId];
            return myUser;
        }catch(Exception e){
            throw new AuraHandledException(e.getMessage());
        }
    }
    
    @AuraEnabled
    public static void chargeCCApxc() {
        Boolean ccErrTrans = false;
        Boolean ccSuccess = false;
        String ccErrMsg  = '';
        Case caseMR = new Case();
        List<String> result =  StripeProcessor.StripeProcessor(caseMR);
        if(result[0] == '200') {
        } else {
            ccErrTrans = true;
            ccErrMsg = result[0];
            /**STRIPE API UPDATE START */
            Savepoint sp = Database.setSavepoint();
            try {
                 if(result.size()>=4 && result[3] != NULL){
                    ccErrMsg = result[3];
                    throw new AuraHandledException(ccErrMsg);
                }else{
                    if(result.size()==3 && result[2] != NULL){
                    	ccErrMsg = ccErrMsg + result[1] + '::CUST_ID::' + result[2];
                	}
                    throw new AuraHandledException('Credit Card Charge Error: ' + ccErrMsg);
                }
            } finally {
             	Database.rollback(sp);
            }
            /**STRIPE API UPDATE END */
        }
    
    }
    
    @AuraEnabled
    public static void updateAccountWithStripeCustomer(Id caseRecordId, String custId){
        Case caseMR = [SELECT Id, Contact.AccountId
                         FROM Case
                        WHERE Id = :caseRecordId LIMIT 1];
        if(caseMR.Contact.AccountId != NULL){
            Account acc = new Account();
            acc.Id = caseMR.Contact.AccountId;
            acc.Rating = 'Warm';
            //acc.CC_Customer_Id__c = custId;
            Database.update(acc);
        }
    }
}