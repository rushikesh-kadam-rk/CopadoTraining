public with sharing class NewBookingController {

    public NewBookingController(ApexPages.StandardController controller) {
        booking= (Booking__c)controller.getRecord();
    }

    public Event__c e{get; set;}
    public Concert__c c{get;set;}
    
    public Decimal updatedPrice{get; set;}
    public Decimal perTicketPrice;
    public Decimal availableTickets;
    
    public Booking__c booking{ get; set; }
    /*Exception Handling*/
        public virtual class BaseException extends Exception {}
        public class OtherException extends BaseException {}
    
    public NewBookingController (){
        booking = new Booking__c(); 
        
    }
    
    public void waitingBooking(){
        if(e.Avail_Tickets__c<=0 || booking.Number_of_Tickets_Booked__c>e.Avail_Tickets__c){
            e.Avail_Tickets__c = 0;
            update e;
        }else{               
            e.Avail_Tickets__c = e.Avail_Tickets__c - booking.Number_of_Tickets_Booked__c;
            update e;            
            
        }
    }

    
    public PageReference checkAvailability(){
       
        if(booking.Number_of_Tickets_Booked__c>e.Avail_Tickets__c && e.Avail_Tickets__c<=0){
            booking.Waiting_Tickets__c = booking.Number_of_Tickets_Booked__c;
            booking.Confirmed_Tickets__c = 0;
            PageReference pr = Page.WaitingPage;
            return pr;
        }else if(booking.Number_of_Tickets_Booked__c>e.Avail_Tickets__c){
            booking.Confirmed_Tickets__c = e.Avail_Tickets__c;
            booking.Waiting_Tickets__c = booking.Number_of_Tickets_Booked__c - e.Avail_Tickets__c;
            PageReference pr = Page.WaitingPage;
            return pr;
        }else{
            booking.Confirmed_Tickets__c = booking.Number_of_Tickets_Booked__c;
            booking.Waiting_Tickets__c = 0;
            PageReference pr = bookTickets();
            return pr;
        }
         
    }

   
    public PageReference  bookTickets(){          
        if(c.Concert_Type__c == 'Premium' && e.Avail_Tickets__c<= e.Total_Tickets__c * 0.10) {   
            //Premium Hike Booking
            PageReference pr = Page.PremiumIncreasedRatePage;
            updatedPrice  = getUpdatedPrice();
            return pr;
        }else if(c.Concert_Type__c == 'Premium' && e.Avail_Tickets__c<= e.Total_Tickets__c) {   
            //Premium Booking
            Decimal premiumTickets = 0;
            Decimal normalTickets = 0;
            //Premium Normal + Hike Booking
            if(e.Avail_Tickets__c-booking.Number_of_Tickets_Booked__c<=e.Total_Tickets__c *0.10){
                normalTickets = e.Avail_Tickets__c-(e.Total_Tickets__c*0.10);
                premiumTickets = booking.Number_of_Tickets_Booked__c-normalTickets ;
                updatedPrice  = (normalTickets *e.Ticket_Price__c)+(premiumTickets*e.Ticket_Price__c*1.1);
                PageReference pr = Page.PremiumIncreasedRatePage;
                return pr;
            }else{
                //Premium Normal
                booking.Total_Price__c = booking.Number_of_Tickets_Booked__c* e.Ticket_Price__c;  
                waitingBooking();
                insert booking;
                return new PageReference('/apex/NewBookingSummaryPage?id='+booking.id);
            }
        }else {
            //Regular Normal
            booking.Total_Price__c = booking.Number_of_Tickets_Booked__c* e.Ticket_Price__c;
            waitingBooking();
            insert booking;
            return new PageReference('/apex/NewBookingSummaryPage?id='+booking.id);
        }          
    }
    
     public PageReference  getBookingDetails(){
        e = [Select Avail_Tickets__c,Concert__c,Total_Tickets__c,Ticket_Price__c
                      from Event__c 
                      where id = :booking.Event_Name__c];
         perTicketPrice = e.Ticket_Price__c;
         availableTickets = e.Avail_Tickets__c;     
        
        c = [Select Concert_Type__c, Concert_Name__c from Concert__c where id = :e.Concert__c];
        PageReference pr = Page.BookingDetailsPage;

        return pr;
        
    }

    public Decimal getUpdatedPrice(){
        return booking.Number_of_Tickets_Booked__c* e.Ticket_Price__c*1.1;
    }
    
    public PageReference confirmBooking(){
        booking.Total_Price__c= updatedPrice;
        waitingBooking();
        insert booking;
        return new PageReference('/apex/NewBookingSummaryPage?id='+booking.id);
    }

    public PageReference cancelBooking(){
        PageReference pr = Page.PremiumCancelPage;
        return pr;
    }
    
    public PageReference goBack(){
        PageReference pr = Page.PremiumIncreasedRatePage;
        return pr;
    }
    
    public PageReference goToBookingList(){
        return new PageReference('/a0C/o');
    }
 
}