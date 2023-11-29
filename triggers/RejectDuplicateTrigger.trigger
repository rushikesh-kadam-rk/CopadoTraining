trigger RejectDuplicateTrigger on Session_Speaker__c (before insert, before update) {
    for(Session_Speaker__c sSpeaker: Trigger.New) {
        Session__c sess = [SELECT ID, Session_Date__c FROM Session__c WHERE Id=:sSpeaker.Session__c];
        System.debug(sess.ID);
        System.debug(sSpeaker.Session__c);
        List<Session_Speaker__c> duplicateList = [SELECT ID FROM Session_Speaker__c
                                                    WHERE Speaker_Details__c=:sSpeaker.Speaker_Details__c
                                                    AND Session__r.Session_Date__c=:sess.Session_Date__c];
        if(duplicateList.size()>0){
            sSpeaker.addError('Sorry. This speaker has already booked for same timing');
        }
    }
}