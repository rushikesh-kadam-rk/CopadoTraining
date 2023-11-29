public class PositionEditor {
    Position__c position;
    public PositionEditor (){
        position = [Select Name, Job_Description__c, Status__c from Position__c
                        where ID=:ApexPages.currentPage().getParameters().get('id')];
    }
    public Position__c getPosition(){
        return position;
    }
    
    public PageReference edit() {
        update position;
        PageReference pr = new PageReference ('/'+position.id);
        return pr;
    }
    public PageReference mydelete() {
        delete position;
        //PageReference pr = new PageReference ('/'+position.id);
        return null;
    }

}