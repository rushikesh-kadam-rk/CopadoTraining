global class ApexScheduledClass implements Schedulable{
	global void execute(SchedulableContext sc){
		SendEmailBatch aeb = new SendEmailBatch();
		Database.executeBatch(aeb, 200);
	}		
}