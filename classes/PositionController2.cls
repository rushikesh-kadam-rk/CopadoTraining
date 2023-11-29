public class PositionController2 {
    public Position__c position;
    public PositionController2(){
        position = new Position__c ();
    }
    public Position__c getPosition(){
        return position;
    }
    public PageReference save(){
        insert position;
        PageReference pr = new PageReference ('/'+position.id);
        return pr;
    }
}