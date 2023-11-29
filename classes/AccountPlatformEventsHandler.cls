public class AccountPlatformEventsHandler {

    public static void afterUpdate(List<Account> newList){
        List<Account_Platform_Event__e> accPlatformEventList = new List<Account_Platform_Event__e>();
        for(Account acc : newList){
            Account_Platform_Event__e accEvent = new Account_Platform_Event__e();
            accEvent.Account_Name__c = acc.Name;
            accEvent.Phone__c = acc.Phone;
            accEvent.Salary__c = acc.AnnualRevenue;
            accPlatformEventList.add(accEvent);
        }

        if(!accPlatformEventList.isEmpty()){
            EventBus.publish(accPlatformEventList);
        }
    }
}