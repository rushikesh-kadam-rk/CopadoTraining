public class PositionExtensionController {
    Position__c position;
    
    public PositionExtensionController(ApexPages.StandardController controller){
        position = (Position__c )controller.getRecord();
    }
    
    public PageReference mysave(){
        insert position;
        PageReference pr = new PageReference ('/'+position.id);
        return pr;
    }
    public PageReference myedit(){
        update position;
        PageReference pr = new PageReference ('/'+position.id);
        return pr;
    }
    public PageReference mydelete(){
        delete position;
        //PageReference pr = new PageReference ('/'+position.id);
        return null;
    }
}