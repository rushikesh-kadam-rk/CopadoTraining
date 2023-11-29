public without sharing class DatatableContactsRemote {
    
    @AuraEnabled(cacheable=true)
    public static List<Contact> getContactsList(){
        try {
            List<Contact> conList = [SELECT Id, Name, Phone FROM Contact
            WHERE Phone != NULL];
            System.debug('RK');
            return conList;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static void updateContacts(List<Contact> contactList){
        try {
            update contactList;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}