public with sharing class ContractorApex {
    
    public static void checkStatus(){
        List<Account> accList = [SELECT Id FROM Account];
    }
    
    public static void checkStatus2(){
        List<Account> accList = [SELECT Id FROM Account];
    }
}