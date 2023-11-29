public class PositionController {
       Position__c position;
       public PositionController(){
           position = [Select Name, Job_Description__c, Status__c from Position__c
                           where ID=:ApexPages.currentPage().getParameters().get('id')];
       }
       public Position__c getPosition(){
           return position;
       }
}