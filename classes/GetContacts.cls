public with sharing class GetContacts {
    public GetContacts() {

    }
    @AuraEnabled(cacheable=true)
    public static List<Contact> getContactsList(){
        return [SELECT Id, LastModifiedDate FROM Contact LIMIT 2];
    }
}