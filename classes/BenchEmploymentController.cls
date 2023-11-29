public with sharing class BenchEmploymentController {
    
    @AuraEnabled
    public static String publishBenchEmployment(String conID){
        List<Contact> conList = [SELECT Id, BenchEmployment__c 
                                FROM Contact
                                WHERE Id =: conID];
        if(conList!=NULL && !conList.isEmpty()){
            for(Contact con: conList){
                con.BenchEmployment__c = 'Sent';
            }
            Database.update(conList);
        }
        return 'Success';
        //Call TH_CTC_PlatformEvents class
        //Map<String, String> GDSPToSFMap = AP98_PlatformEventUtils.getGDSPToSFMap('FunctionalyName', GDSPToSFMap);
        //create and publish event
        //AP98_PlatformEventUtils.createAndSendEventsCreate(conList, Bench_Employment__e, )
        //get event status
        //if success
        //update contact's BenchEmployment__c to Draft
    }

    public static void createAndSendEventsCreate(List<sObject> objects, String eventObjectName, Map<String, String> fieldMap){
        if(!fieldMap.isEmpty() || fieldMap!=NULL){
            //eventsToSend.clear();
            //get event type
            //Schema.SObject eventType = Utils_Methods_Founda
            
        }
    }
    
    @AuraEnabled(cacheable=true)
    public static List<Contact> getContactList(){
        //get all contact list
        List<Contact> conList = [SELECT Id, Name, Account.Name, Phone, Email FROM Contact LIMIT 10];
        return conList;
    }
}