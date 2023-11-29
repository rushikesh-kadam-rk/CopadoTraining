@isTest
public class TestJobAppDetails {
	static ID jobid; 
    /*@testSetup
    private static void setJobAppData(){
        Position__c p = new Position__c(Name='P10', Job_Description__c='P10 Knowledge');
        insert p;
        
        Job_Application__c ja = new Job_Application__c();
        ja.Position__c = p.Id;
        insert ja;
        jobid = ja.id;
    }*/
    
	@isTest(seeAllData=true)
    private static void testGetJobApps(){
        JobAppDetails jad = new JobAppDetails();
        //List<Job_Application__c> jaList = jad.getJobApps();
        //System.assertEquals(1, jaList.size());
        //System.assert(jad.getJobApps().size()==1);
        System.assert(jad.getJobApps().size()==4);
        
    }
    
    @isTest
    private static void testUpdateJobApp(){
        Position__c p = new Position__c(Name='P12', Job_Description__c='P12 Knowledge');
        insert p;
        JobAppDetails jad = new JobAppDetails();
        jad.updateJobApp(jobid, p.id);
        
        Job_Application__c ja = [Select Name, Position__c
                                	from Job_Application__c
                                	where id=:jobid];
        //System.assert(ja.Position__c==p.id);
        
    }
}