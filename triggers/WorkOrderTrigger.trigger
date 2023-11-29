trigger WorkOrderTrigger on Account (after update) {
    
    Set<Account> accSet = new Set<Account>();
    if (Trigger.isAfter && Trigger.isUpdate) {
        for(Account acc: Trigger.New){
            //checking if status is equal to Assigned
            Account oldAccount = Trigger.oldMap.get(acc.ID);
            System.debug('line 8'+oldAccount.Status__c);
            System.debug('line 8'+acc.Status__c);
            if(acc.Status__c=='Assigned' && oldAccount.Status__c!='Assigned'){
                System.debug('line 9');
                accSet.add(acc);
            }
        }
        //gettig current user Id
        Id userId = UserInfo.getUserId();
        List<Event> eventList = new List<event>();
        System.debug('line 16'+accSet);
        if(!accSet.isEmpty() && accSet.size()>0){
            //iterating over work orders with status is Assigned
            //and create event for each work order
            for(Account accAssigned: accSet){
                Event e = new Event();
                e.Subject = accAssigned.Name;
                //e.StartDateTime = accAssigned.PreferredStartTime;
                //e.EndDateTime = accAssigned.PreferredEndTime;
                e.DurationInMinutes = 90;
                e.ActivityDateTime = System.now();
                e.OwnerId = userId;
                eventList.add(e);
            }
        }
        
        if(!eventList.isEmpty()){
            Database.insert(eventList);
        }
    }

}