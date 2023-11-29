public with sharing class StripeProcessor {
    public static List<String> StripeProcessor(Case salesCase) {
        API_Creds__mdt creds = new API_Creds__mdt();
        if(salesCase.CurrencyISOCode == 'CAD'){
            creds = [SELECT Endpoint__c, Key__c, Username__c, Password__c FROM API_Creds__mdt WHERE DeveloperName = 'Stripe_Can'];
        }else{
            creds = [SELECT Endpoint__c, Key__c, Username__c, Password__c FROM API_Creds__mdt WHERE DeveloperName = 'Stripe'];
        }

        if(Test.isRunningTest()){
            creds.Endpoint__c = 'https://api.stripe.com/';
        	creds.Key__c = 'testauthkey';
        }
        
        Contact con = [SELECT AccountId FROM Contact WHERE Id = :salesCase.ContactId LIMIT 1];
        String contactAccountId = con.AccountId;
        Account acc = [SELECT CC_Customer_Id__c FROM Account WHERE Id = :contactAccountId LIMIT 1];
        String custId = acc.CC_Customer_Id__c;
        Boolean newCustomerCreated = false;
    
        if(String.isBlank(custId)){
            custId = StripeHandler.CreateCustomer(salesCase, creds.Endpoint__c, creds.Key__c);
            newCustomerCreated = true;
        }
        String paymentMethod = StripeHandler.CreatePaymentMethod(salesCase, creds.Endpoint__c, creds.Key__c);
        List<String> paymentMethodError = new List<String>();
        if(paymentMethod.startsWith('Invalid Card Error::')){
             /**This block will handle error scenario when Payment method Creation is not Successfull*/
             paymentMethodError = updateErrorResponse(paymentMethod, custId);
        }else{
            String customerPaymentMethod = StripeHandler.UpdateCustomerWithPaymentMethod(custId, paymentMethod, creds.Endpoint__c, creds.Key__c);
            if(customerPaymentMethod!= NULL && customerPaymentMethod.startsWith('Invalid Card Error::')){
                /**This block will handle error scenario when Payment method Attachment is not Successfull*/
                paymentMethodError = updateErrorResponse(customerPaymentMethod, custId);
            }else{
                List<String> paymentIntent = StripeHandler.CreatePaymentIntent(custId, paymentMethod, creds.Endpoint__c, creds.Key__c, salesCase);
                List<String> confirmPaymentIntent = StripeHandler.ConfirmPaymentIntent(paymentIntent[2], creds.Endpoint__c, creds.Key__c);
                salesCase.CC_Customer_Id__c = custId;
                salesCase.CC_Authorization_Code__c = paymentIntent[2];
                if(paymentIntent[0] == '200'){
                    salesCase.Payment_Status__c = 'Success';
                    salesCase.Payment_Message__c = 'Customers payment was submitted successfully';
                    salesCase.Status = 'Charge Approved';
                }else{
                    salesCase.Payment_Status__c = 'Failed';
                    salesCase.Payment_Message__c = 'Customers payment was declined by card network or otherwise expired. Please try processing another card';
                    if(paymentIntent.size()>=4 && paymentIntent[3] != NULL){
                        salesCase.Payment_Message__c = paymentIntent[3];
                    }
                }

                /**This block will handle error scenario when payment has been failed due to any reasons*/
                if(confirmPaymentIntent[0] != '200'){
                    salesCase.Payment_Status__c = 'Failed';
                    salesCase.Payment_Message__c = 'Customers payment was declined by card network or otherwise expired. Please try processing another card';
                    if(confirmPaymentIntent.size()>=4 && confirmPaymentIntent[3] != NULL){
                        salesCase.Payment_Message__c = confirmPaymentIntent[3];
                    }
                }

                salesCase.Payment_Processor__c = 'Stripe';
                salesCase.Failed_Integration_Details__c = paymentIntent[1];
                system.debug('Ready to update case');
                update salesCase;
                system.debug('Case updated');
                if(newCustomerCreated){
                    acc.CC_Customer_Id__c = custId;
                    update acc;
                }
                /**If PaymentIntent was not successfull, return paymentIntent response */
                if(paymentIntent[0] != '200'){
                    return paymentIntent;
                }
                return confirmPaymentIntent;
            }
        }
        return paymentMethodError;
    }

    public static List<String> updateErrorResponse(String errorMessage, String custId){
        List<String> paymentError = new List<String>();
        /**This block will handle error scenario when Payment method Creation is not Successfull*/
        paymentError = errorMessage.split('::');
        paymentError.remove(0);
        paymentError.add(custId);
        return paymentError;
    }

}