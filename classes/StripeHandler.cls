public with sharing class StripeHandler {

    public static final Map<String, String> cardErrorCodeDescriptionMap = new Map<String, String> {
                                        'authentication_required' => 'The card was declined because the transaction requires authentication.',
                                        'approve_with_id' => 'The payment cannot be authorized.',
                                        'card_not_supported' => 'The card does not support this type of purchase.',
                                        'card_velocity_exceeded' => 'The customer has exceeded the balance, credit limit, or transaction amount limit available on their card.',
                                        'currency_not_supported' => 'The card does not support the specified currency.',
                                        'duplicate_transaction' => 'A transaction with identical amount and credit card information was submitted very recently.',
                                        'expired_card' => 'The card has expired.',
                                        'fraudulent' => 'The payment was declined because Stripe suspects that it is fraudulent.',
                                        'generic_decline' => 'The card was declined for an unknown reason or Stripe Radar blocked the payment.',
                                        'incorrect_number' => 'The card number is incorrect.',
                                        'incorrect_cvc' => 'The CVC number is incorrect.',
                                        'incorrect_pin' => 'The PIN entered is incorrect.',
                                        'incorrect_zip' => 'The postal code is incorrect.',
                                        'insufficient_funds' => 'The card has insufficient funds to complete the purchase.',
                                        'invalid_account' => 'The card, or account the card is connected to, is invalid.',
                                        'invalid_amount' => '   The payment amount is invalid, or exceeds the amount that is allowed.',
                                        'invalid_cvc' => 'The CVC number is incorrect.',
                                        'invalid_expiry_month' => 'The expiration month is invalid.',
                                        'invalid_expiry_year' => 'The expiration year is invalid.',
                                        'invalid_number' => 'The card number is incorrect.',
                                        'invalid_pin' => 'The PIN entered is incorrect.',
                                        'issuer_not_available' => 'The card issuer could not be reached, so the payment could not be authorized.',
                                        'lost_card' => 'The payment was declined because the card is reported lost.',
                                        'merchant_blacklist' => 'The payment was declined because it matches a value on the Stripe user block list.',
                                        'new_account_information_available' => 'The card, or account the card is connected to, is invalid.',
                                        'not_permitted' => 'The payment is not permitted.',
                                        'offline_pin_required' => 'The card was declined because it requires a PIN.',
                                        'online_or_offline_pin_required' => '   The card was declined as it requires a PIN.',
                                        'pickup_card' => 'The customer cannot use this card to make this payment (it is possible it was reported lost or stolen).',
                                        'pin_try_exceeded' => 'The allowable number of PIN tries was exceeded.',
                                        'processing_error' => ' An error occurred while processing the card.',
                                        'reenter_transaction' => 'The payment could not be processed by the issuer for an unknown reason.',
                                        'restricted_card' => 'The customer cannot use this card to make this payment (it is possible it was reported lost or stolen).',
                                        'stolen_card' => 'The payment was declined because the card is reported stolen.',
                                        'testmode_decline' => 'A Stripe test card number was used.',
                                        'withdrawal_count_limit_exceeded' => 'The customer has exceeded the balance or credit limit available on their card.'
                                    };
    public static final Set<String> unknownReasonCardDeclined = new Set<String>{
        'call_issuer',
        'do_not_honor',
        'do_not_try_again',
        'no_action_taken',
        'revocation_of_all_authorizations',
        'revocation_of_authorization',
        'security_violation',
        'service_not_allowed',
        'stop_payment_order',
        'transaction_not_allowed',
        'try_again_later'
    };
               
    public static String CreateCustomer(Case salesCase, String endpoint, String key) {
        String custId;
        Http http = new Http();
        HttpRequest request = new HttpRequest();
    
        request.setMethod('POST');
        request.setEndpoint(endpoint + 'v1/customers');
        request.setHeader('Content-Type','application/x-www-form-urlencoded');
        request.setHeader('Authorization','Bearer ' + key);
    
        String body = 'name=' + salesCase.Contact_Full_Name__c + '&email=' + salescase.ContactEmail + '&description=customer';
    
        HttpResponse response = new HttpResponse();
        request.setBody(body);
        response = http.send(request);
    
        String responseBody = response.getBody();
    
        if (response.getStatusCode() == 200) {
            Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
    
            custId = String.valueOf(results.get('id'));
        }
        return custId;
    }
    
    public static String CreatePaymentMethod(Case salesCase, String endpoint, String key){
        String payMethod;
        Http http = new Http();
        HttpRequest request = new HttpRequest();
    
        request.setMethod('POST');
        request.setEndpoint(endpoint + '/v1/payment_methods');
        request.setHeader('Content-Type','application/x-www-form-urlencoded');
        request.setHeader('Authorization','Bearer ' + key);
    
        String body = 'type=card&card[number]=' + salesCase.CC_Card_Number__c
            + '&card[exp_month]=' + salesCase.CC_Card_Month__c
            + '&card[exp_year]=' + salesCase.CC_Card_Year__c
            + '&card[cvc]=' + salesCase.CC_Card_CVC__c;
    
        HttpResponse response = new HttpResponse();
        request.setBody(body);
        response = http.send(request);
    
        String responseBody = response.getBody();
    
        if (response.getStatusCode() == 200) {
            Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
            payMethod = String.valueOf(results.get('id'));
        }else{
            /**This block will handle error scenario when incorrect card number has been provided:incorrect_number*/
            Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
            Map<String, Object> paymentMethodError = (Map<String, Object>)results.get('error');
            payMethod = 'Invalid Card Error::'+String.valueOf(response.getStatusCode())+'::'+String.valueOf(paymentMethodError.get('message'));
        }
        system.debug('Payment Method: ' + responseBody);
    
        return payMethod;
    }
    
    public static String UpdateCustomerWithPaymentMethod(String custId, String paymentMethod, String endpoint, String key){
    
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setMethod('POST');
        request.setEndpoint(endpoint + '/v1/payment_methods/' + paymentMethod + '/attach');
        request.setHeader('Content-Type','application/x-www-form-urlencoded');
        request.setHeader('Authorization','Bearer ' + key);
        request.setBody('customer=' + custId);
    
        HttpResponse response = http.send(request);
        String responseBody = response.getBody();

        String payMethodWithCustomer;
        if (response.getStatusCode() != 200) {
            Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
            Map<String, Object> paymentMethodError = (Map<String, Object>)results.get('error');
            payMethodWithCustomer = 'Invalid Card Error::'+String.valueOf(response.getStatusCode())+'::'+String.valueOf(paymentMethodError.get('message'));
        }
    
        return payMethodWithCustomer;
    }
    
    public static List<String> CreatePaymentIntent(String custId, String paymentMethod, String endpoint, 
                                                   String key, Case salesCase){
        List<String> paymentIntent = new List<String>();
        String paymentIntentId;
        Decimal chargeAmount = (salesCase.CC_Charge_Amount__c * 100).longValue();
    
        Http http = new Http();
        HttpRequest request = new HttpRequest();
    
        request.setMethod('POST');
        request.setEndpoint(endpoint + '/v1/payment_intents');
        request.setHeader('Content-Type','application/x-www-form-urlencoded');
        request.setHeader('Authorization','Bearer ' + key);
        request.setBody('customer=' + custId + '&payment_method=' + paymentMethod + '&amount=' + chargeAmount + '&currency=' + salesCase.CurrencyIsoCode + '&capture_method=manual');
    
        HttpResponse response = http.send(request);
    
        String responseBody = response.getBody();
        String statusCode = String.valueOf(response.getStatusCode());
        String statusText = response.getStatus();
        String errorMessage;
        
        if (response.getStatusCode() == 200) {
            Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
            paymentIntentId = String.valueOf(results.get('id'));
        }else{
            /**This block will handle error scenario when Payment Intent Creation is not Successfull */
            Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
            Map<String, Object> paymentError = (Map<String, Object>)results.get('error');
            errorMessage = String.valueOf(paymentError.get('message'));
        }
    
        paymentIntent.add(statusCode);
        paymentIntent.add(statusText);
        paymentIntent.add(paymentIntentId);
        if(response.getStatusCode() != 200){
            paymentIntent.add(errorMessage);
        }
        return paymentIntent;
    }
    
    public static List<String> ConfirmPaymentIntent(String paymentIntentId, String endpoint, String key){
    
        Http http = new Http();
        HttpRequest request = new HttpRequest();
    
        request.setMethod('POST');
        request.setEndpoint(endpoint + '/v1/payment_intents/' + paymentIntentId + '/confirm');
        request.setHeader('Content-Type','application/x-www-form-urlencoded');
        request.setHeader('Authorization','Bearer ' + key);
    
        HttpResponse response = http.send(request);
        /**Stripe API Update START */
        List<String> paymentIntent = new List<String>();

        String responseBody = response.getBody();
        String statusCode = String.valueOf(response.getStatusCode());
        String statusText = response.getStatus();
        String errorMessage;

        if (response.getStatusCode() != 200) {
            Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
            Map<String, Object> paymentError = (Map<String, Object>)results.get('error');
            String errorCode = String.valueOf(paymentError.get('code'));
            /**This will store general error message */
            errorMessage = String.valueOf(paymentError.get('message'));

            String declineCode = String.valueOf(paymentError.get('decline_code'));
            String declineCardMessage;
            if(String.isNotBlank(declineCode)){
                /**Updating error message based on decline code */
                if(cardErrorCodeDescriptionMap.containsKey(declineCode)){
                    declineCardMessage = cardErrorCodeDescriptionMap.get(declineCode);
                }else if(unknownReasonCardDeclined.contains(declineCode)){
                    declineCardMessage = 'The card was declined for an unknown reason.';
                }
                if(String.isNotBlank(declineCardMessage)){
                    errorMessage = declineCardMessage;
                }
            }
        }

        paymentIntent.add(statusCode);
        paymentIntent.add(statusText);
        paymentIntent.add(paymentIntentId);
        if(response.getStatusCode() != 200){
            paymentIntent.add(errorMessage);
        }
        return paymentIntent;
        /**Stripe API Update END */
    }
}