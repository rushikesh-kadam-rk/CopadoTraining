global class Batch_JunkLeadCleaner_Scheduler implements schedulable{
    global void execute(SchedulableContext sc){
        Batch_JunkLeadCleaner bc = new Batch_JunkLeadCleaner();
        Database.executeBatch(bc, 1);
    }

}