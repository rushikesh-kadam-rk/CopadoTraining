global class SendEmailBatch implements Database.Batchable<sObject>, Database.Stateful {
    global FINAL String strQuery;
    global List<String> errorMessages = new List<String>();
    
    global SendEmailBatch() { 
        this.strQuery = getBatchQuery();
    }
    
    private String getBatchQuery() {
        String strQuery = 'SELECT Id, Name, Email FROM User'; 
        return strQuery;
    }
	
	global Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator(strQuery);
    }
	
    global void execute(Database.BatchableContext BC, List<sObject> scopeList) {
		 List<User> userList = (List<User>) scopeList;
        if(!userList.isEmpty()) {
			List<Messaging.SingleEmailMessage> mailList = new List<Messaging.SingleEmailMessage>();
			 for (User u : userList){               
                Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage(); 
                String[] toAddresses = new String[] {u.Email};
                Message.setToAddresses(toAddresses); 
                mailList.add(Message);
            }
			
			if(!mailList.isEmpty()) {
                try{
                    Messaging.sendEmail(mailList);
                }catch (Exception ex) {
                    errorMessages.add('Unable to send email: '+ ex.getStackTraceString());
                }
            }
		}
	}
	
	global void finish(Database.BatchableContext BC) { 
		AsyncApexJob aaj = [Select Id, Status, NumberOfErrors, JobItemsProcessed, MethodName, TotalJobItems from AsyncApexJob where Id =:BC.getJobId()];
	}
	
}