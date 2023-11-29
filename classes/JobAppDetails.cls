public class JobAppDetails {
    public List<Job_Application__c> getJobApps(){
        return [Select ID, Name
               	from Job_Application__c];
    }
    public void updateJobApp(ID jobid, ID pid){
        Job_Application__c jid = [Select Name, Position__c, Candidate__c
                                 	from Job_Application__c
                                 	where ID=:jobid];
        jid.Position__c = pid;
    }
}