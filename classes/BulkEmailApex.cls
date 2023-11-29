public class BulkEmailApex {
    public static void sendBulkEmails(String oppId){
        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        // Set recipients to two contact IDs.
        // Replace IDs with valid record IDs in your org.
        message.toAddresses = new String[] { 'rushikeshkadamsfdc@gmail.com', 'rushikeshkadamsfdc@gmail.com' };
        message.optOutPolicy = 'FILTER';
        message.subject = 'Opt Out Test Message';
        message.plainTextBody = 'This is the message body.';
        Messaging.SingleEmailMessage[] messages = 
            new List<Messaging.SingleEmailMessage> {message};
                 Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
        if (results[0].success) {
            System.debug('The email was sent successfully.');
        } else {
            System.debug('The email failed to send: '
                  + results[0].errors[0].message);
        }
    }
    
    @InvocableMethod(label='Send Opp Email' description='Sends OLI Info' category='Opp')
    public static void sendNotification(List<Id> recordId){
        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        message.setTargetObjectId('0052w000000bPEtAAM');
        message.setSenderDisplayName('Company Support');
        message.setReplyTo('no-reply@company.com');
        //message.setUseSignature(false);
        message.setBccSender(false);
        message.setSaveAsActivity(false);
   		EmailTemplate emailTemplate =[Select Id, Subject, Description, HtmlValue, DeveloperName, Body
                                      FROM EmailTemplate 
                                      WHERE name ='EmailFL'];
   		//Get templete id for set the templete.

       message.setTemplateID(emailTemplate.Id);
       message.setWhatId(recordId[0]); //This is important for the merge fields in template to work
       message.toAddresses = new String[] { 'rushikeshkadamsfdc@gmail.com', 'rishiikeshkadam.rk@gmail.com' };
    
       Messaging.SingleEmailMessage[] messages = new List<Messaging.SingleEmailMessage> {message};
    
       Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
 
        if (results[0].success){
            System.debug('The email was sent successfully.');
        }else{
            System.debug('The email failed to send: ' + results[0].errors[0].message);
        }
	}
}