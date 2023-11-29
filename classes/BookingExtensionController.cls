public class BookingExtensionController {

    Booking__c booking;
    Event__c event;
    
    public BookingExtensionController (ApexPages.StandardController controller){
        booking= (Booking__c )controller.getRecord();
    }
    
    Public string myoutput{get;set;}
    
     Public static void MyMethode(){
        //myoutput = booking.Event_Name__c;
    }
    
    public PageReference mysave(){
        insert booking;
        PageReference pr = new PageReference ('/'+booking.id);
        return pr;
    }

}