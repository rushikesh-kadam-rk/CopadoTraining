public class PCJController {
    public Position__c position;
    public Candidate__c candidate;
    Job_Application__c ja;
    
    public PCJController(){
        position = new Position__c();
        candidate = new Candidate__c();
    }
    
    public Position__c getPosition(){
        return position;
    }
    public Candidate__c getCandidate(){
        return candidate;
    }

    public PageReference save() {
        insert position;
        insert candidate;
        ja = new Job_Application__c();
        ja.position__c = position.id;
        ja.candidate__c = candidate.id;
        insert ja;
        return new PageReference('/'+ja.id);
    }


    public PageReference positioncandidatepage() {
        PageReference pr = Page.PositionCandidateDataPage;
        return pr;
    }

    public PageReference positionpage() {
        PageReference pr = Page.PositionDataPage;
        return pr;
    }

    public PageReference candidatepage() {
        PageReference pr = Page.CandidateDataPage;
        return pr;
    }

    
}