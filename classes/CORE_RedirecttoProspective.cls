public class CORE_RedirecttoProspective {
    @AuraEnabled
    public static String getRedirectToProspectURL(String accId) {
        /*String URL = 'https://jobcenter.prospective.ch/NJCWeb/services/fastinterface?';
        Account acc = [SELECT Id, Job_Number__c, Functional_Flag__c FROM Account WHERE Id=:accId LIMIT 1];
        Contact con = [SELECT Id,TECH_TechNode__c FROM Contact WHERE AccountId =:acc.Id LIMIT 1];
        
        if(acc.Functional_Flag__c && (con.TECH_TechNode__c!=NULL)){
            URL = URL + '&loginUrl='+con.TECH_TechNode__c+'&function=getAuftrag&kundeStelleId='+acc.Job_Number__c;
            return URL;
        }else if(!acc.Functional_Flag__c && (con.TECH_TechNode__c!=NULL)){
            URL = URL + '&loginUrl='+con.TECH_TechNode__c+'&function=getStellen';
            return URL;
        }else{
            return NULL;
        }*/
        return NULL;
    }
}