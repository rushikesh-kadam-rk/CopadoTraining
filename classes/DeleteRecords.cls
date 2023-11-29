global class DeleteRecords implements Database.Batchable<string>, Database.Stateful{
    global boolean bReRun = false;
    global Iterable<string> start(Database.BatchableContext BC) { // change start to querylocator
        System.debug('in start');
        return new List<String> {'Booking__c', 'Interviewer__c'};
	}
    global void execute(Database.BatchableContext BC, list<string> lstsObjectName){
        System.debug('in execute');
        System.debug('0-->'+lstsObjectName);
        list<sObject> lstDeleteRecords = new list<sObject>();
        for(string strObjectName : lstsObjectName) {
            List<sObject> sObjectList = Database.query('Select Id from ' + strObjectName + ' LIMIT 2' );
            System.debug('1-->'+sObjectList.size());
            if(!sObjectList.isEmpty()){
                System.debug('2-->'+Limits.getDMLRows());
                Integer count = Limits.getDMLRows() + sObjectList.size();
                if(count<=Limits.getLimitDMLRows()){
                    Database.delete(sObjectList, true);
                    bReRun = false;
                    System.debug('3-->'+sObjectList.size());
                	System.debug('4-->'+Limits.getDMLRows());
                }else{
                    bReRun = true;
                    break;
                }
            }
        }
    }
    
    
    
    global void finish(Database.BatchableContext BC) {
        if(bReRun) {
            //Database.executebatch(new DeleteRecords());
        }
    }
}