public with sharing class CarController {

    /**Wrapper */
    public class Filters{
        @AuraEnabled
        public String searchKey {get; set;}
        @AuraEnabled
        public Decimal maxPrice {get; set;}
        @AuraEnabled
        public String[] categories {get; set;}
        @AuraEnabled
        public String[] makeType {get; set;}
    }

    @AuraEnabled(cacheable=true)
    public static List<Car__c> getCars(Filters filters){
        try {
            String key, whereClause = '';
            Decimal maxPrice;
            String[] categories, makeType, criteria = new List<string>{};
            
            if(filters!=NULL){
                maxPrice = filters.maxPrice;
                categories = filters.categories;
                makeType = filters.makeType;
                if(!String.isEmpty(filters.searchKey)){
                    key = '%' + filters.searchKey + '%';
                    criteria.add('Name LIKE: key');
                }
                if(filters.maxPrice >= 0){
                    criteria.add('MSRP__c <= :maxPrice');
                }
                if(filters.categories != NULL){
                    criteria.add('Category__c IN :categories');
                }
                if(filters.makeType != NULL){
                    criteria.add('Make__c IN :makeType');
                }
                if(criteria.size()>0){
                    whereClause = 'WHERE ' + String.join(criteria, ' AND ');
                }
            }
            String query = 'SELECT Id, Name, MSRP__c, Description__c, Category__c, Make__c, Picture_URL__c FROM Car__c '+whereClause + ' WITH SECURITY_ENFORCED' + ' ORDER BY Name';
            return Database.query(query);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled(cacheable=true)
    public static List<Car__c> getSimilarCars(Id carId, String[] makeType){
        try {
            return [SELECT Id, Name, MSRP__c, Category__c, 
                    Description__c, Picture_URL__c, Make__c FROM Car__c
                    WHERE Make__c IN : makeType AND Id != :carId];
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}