public class BookingSummaryController {
    
    public Event__c eventSummary{get; set;}
    public Customer__c custSummary{get; set;}
    public Venue__c venueSummary{get; set;}

    public Concert__c concertSummary{get; set;}
    
    public Booking__c bookSummary{get; set;}

    public Booking__c booking{ get; set; }
    public BookingSummaryController (){
   
        bookSummary = [Select Name, Customer_Name__c, Event_Name__c, Number_of_Tickets_Booked__c, Total_Price__c, Confirmed_Tickets__c, Waiting_Tickets__c
                        from Booking__c where ID=:ApexPages.currentPage().getParameters().get('id')];              
        eventSummary = [Select Avail_Tickets__c,Concert__c,Total_Tickets__c,Ticket_Price__c, Venue__c, Event_Timing__c
                      from Event__c 
                      where id = :bookSummary.Event_Name__c];
        concertSummary = [Select Concert_Type__c, Concert_Name__c from Concert__c where id = :eventSummary.Concert__c];
        custSummary = [Select First_Name__c,Last_Name__c,Email__c,Contact__c
                      from Customer__c 
                      where id = :bookSummary.Customer_Name__c];
        venueSummary = [Select Venue_Address__c, Venue_Name__c from Venue__c where id = :eventSummary.Venue__c];

    }
    
}