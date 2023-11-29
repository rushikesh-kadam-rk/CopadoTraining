public class SendEmail {
    public static void sendTemplateEmail(){
        Contact con = new Contact();
        con.FirstName = 'Test';
        con.LastName = 'Contact';
        con.Email = 'fry5@yopmail.com';
        insert con;
        // Create Email and Send
        Messaging.SingleEmailMessage msg = new Messaging.SingleEmailMessage();
        msg.setTemplateId('00X2w000000YVvrEAG');
        msg.setCcAddresses(new String[] {'email1@yopmail.com', 'email2@yopmail.com'});
        msg.setTargetObjectId(con.Id);
        //msg.setWhatId('Your Record Id if applicable');
        msg.setSaveAsActivity(false);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { msg });
        // Don't Forget!  Clean up!
        delete con;
        
    }
}