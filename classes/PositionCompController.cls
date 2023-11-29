public class PositionCompController {
    @AuraEnabled
    public static List<Position__c> getAllPositions(){
        return [Select Name from Position__c];
    }
}