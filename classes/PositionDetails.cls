public class PositionDetails {
    public List<Position__c> fetchAllPositions(){
        return [Select Id, Name, Job_Description__c
        			from Position__c];
    }
    
    public Position__c fetchPosition(ID pid){
        return [Select Name, Job_Description__c
        			from Position__c
               		where ID=:pid];
    }
}