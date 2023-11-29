public class Demo {
    public static void sendLeadOverlapCompleteNotification(){
        ID leadID = '00Q2w000001hqwqEAA';
        EmailTemplate et = [SELECT Id, Body FROM EmailTemplate WHERE Name = 'Test Account Alert Email' limit 1];
        List<string> toAddress = new List<string>();
        toAddress.add('fry5@yopmail.com');
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setTemplateId(et.Id);
        //mail.setToAddresses(toAddress);
        mail.setHTMLBody(et.Body);
       // mail.setSubject('test subject');
        mail.setTargetObjectId(leadId);
        //mail.setWhatId(primaryAccount);
        mail.setSaveAsActivity(false);
        mail.setUseSignature(false);
        List<Messaging.SingleEmailMessage> allmsg = new List<Messaging.SingleEmailMessage>();
        allmsg.add(mail);
        
        try {
            Messaging.sendEmail(allmsg,false);
            return;
        } catch (Exception e) {
            System.debug(e.getMessage());
        }
    }
}