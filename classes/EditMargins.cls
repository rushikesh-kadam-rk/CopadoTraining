public with sharing class EditMargins {
    
    @AuraEnabled(cacheable=true)
    public static List<Product_Quote__c> getProductQuotes(String oppId){
        try {
            return [SELECT Id, Product_Cost__c, Selling_Price__c, Gp__c, Product_GP__c FROM Product_Quote__c WHERE Opportunity__c =: oppId];
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled(cacheable=true)
    public static List<Service_Quote__c> getSerivceQuotes(String oppId){
        try {
            return [SELECT Id, Service_Cost__c, Selling_Price__c, Gp__c, Service_GP__c FROM Service_Quote__c WHERE Opportunity__c =: oppId];
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}