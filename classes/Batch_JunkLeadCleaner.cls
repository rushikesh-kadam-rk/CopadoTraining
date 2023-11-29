global class Batch_JunkLeadCleaner implements Database.Batchable<sObject>{

    //start method
    //collect all leads which rating are junk
    global Database.QueryLocator start(Database.BatchableContext bc){
       
        //string myQury = 'Select id,name,LeadSource,Description From Lead WHERE Rating =Junk';
        //return Database.getQueryLocator(myQury);
        return Database.getQueryLocator([Select id,name,LeadSource,Description From Lead WHERE Rating = 'Junk']);
    }
   
     //execute method
      global void execute(Database.BatchableContext bc, list<Lead> leadList){
          list<Lead> leadlistToDelete = new list<Lead>();
          system.debug('===leadList==='+leadList);
          if(leadList != null && leadList.size() > 0){
              for(Lead ld: leadList){
                 
                 leadlistToDelete.add(ld);
              }
             
              //update leadlistToUpdate;
              delete leadlistToDelete;
          }
      }
     
      //finish method
      global void finish(Database.BatchableContext bc){
           
      }
}