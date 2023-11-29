/*
* @Class		: RevenueCatEventHandler
* @Author		: 
* @Description	: Handle RevenueCat events received from WebhookApi
*
* @ RevenueCat event types:
* 	Subscribed - INITIAL_PURCHASE, RENEWAL, UNCANCELLATION, NON_RENEWING_PURCHASE, PRODUCT_CHANGE
* 	Cancelled - CANCELLATION, EXPIRATION
* 	Not handled - SUBSCRIPTION_PAUSED, BILLING_ISSUE, TRANSFER, TEST
*/

public without sharing class RevenueCatEventHandler {
    
    public static String onEvent(String appUserId, String eventType, String productId, List<String> aliases) {
        List<String> subscribedEvents = new List<String>{'INITIAL_PURCHASE', 'RENEWAL', 'UNCANCELLATION', 'NON_RENEWING_PURCHASE', 'PRODUCT_CHANGE'};
        List<String> cancelledEvents = new List<String>{'CANCELLATION', 'EXPIRATION'};
        if (subscribedEvents.contains(eventType)) {
            return onEventStatus('Subscribed', appUserId, productId, aliases);
        } else if (cancelledEvents.contains(eventType)) {
            return onEventStatus('Cancelled', appUserId, productId, aliases);
        } else {
            return 'EVENT_TYPE_NOT_HANDLED';
        }
    }
    
    public static String onEventStatus(String status, String appUserId, String productId, List<String> aliases) {
        // Check if PersonAccount exists
        List<Account> accounts = new List<Account>([SELECT Id, Membership_Status__c, Membership_Type__c FROM Account WHERE original_app_user_id__c IN: aliases]);
        if (accounts.size()>0) {
            for (Account a : accounts) {
                a.Membership_Status__c = status;
                a.Membership_Type__c = (productId=='com.subscription.monthly') ? 'Monthly' : 'Yearly';
            }
            try {
                update accounts;
                return 'ACCOUNT_UPDATED';
            } catch (DmlException e) {
                return e.getDmlStatusCode(0);
            }
            
        // PersonAccount does not exist
        } else {
            return 'APP_USER_ID_DOES_NOT_EXIST';
            // Check if Lead exists
            /*List<Lead> leads = new List<Lead>([SELECT Id, Account_Membership_Status__c, Account_Membership_Type__c FROM Lead WHERE original_app_user_id__c=:appUserId]);
            if (leads.size()>0) {
                for (Lead l : leads) {
                    l.Account_Membership_Status__c = status;
                    l.Account_Membership_Type__c = (productId=='com.subscription.monthly') ? 'Monthly' : 'Yearly';
                }
                try {
                    update leads;
                    return LeadUtils.convert(appUserId);
                } catch (DmlException e) {
                    return e.getDmlStatusCode(0);
                }
                
            // Lead does not exist
            } else {
                return 'APP_USER_ID_DOES_NOT_EXIST';
            }*/
        }
    }


}