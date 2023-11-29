public with sharing class StripeSimpleIntegration {
    public StripeSimpleIntegration() {

    }

    public static String PAYMENT_URL = 'https://api.stripe.com/v1/payment_intents';

    public static void createCustomerInStripe(){
        String accessToken = 'sk_test_51Nvh9vSGDjDbcNLaHp7zqBx6kbXuXlKsbJbcQsO799G8V1TE1pFfbzK87uaAcA2f0EnU9hKuwa86nRbkBYoSrnOe000OuwTIAZ';
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setMethod('POST'); 
        request.setEndpoint('https://api.stripe.com/v1/customers');

        request.setHeader('Content-Type','application/x-www-form-urlencoded');
        request.setHeader('Authorization','Bearer '+accessToken );

        String body = 'name=Customer&email=abc@gmail.com&description=customer'+'&source=tok_visa';

        HttpResponse response = new HttpResponse();
        request.setBody(body);
        response = http.send(request);
        String responseBody = response.getBody();
        Logs__c aa = new Logs__c();
        aa.Error_Message__c = 'createCustomerInStripe::::'+responseBody;
        insert aa;
    }

    public static void createPaymentMethodInStripe(){
        String accessToken = 'sk_test_51Nvh9vSGDjDbcNLaHp7zqBx6kbXuXlKsbJbcQsO799G8V1TE1pFfbzK87uaAcA2f0EnU9hKuwa86nRbkBYoSrnOe000OuwTIAZ';
        Http http = new Http();

        HttpRequest request = new HttpRequest();
        request.setMethod('POST');
        request.setEndpoint('https://api.stripe.com/v1/payment_methods');
        request.setHeader('Content-Type', 'application/x-www-form-urlencoded');
        request.setHeader('Authorization','Bearer '+accessToken);

        String bodyRequest = 'type=card'+'&card[number]=4242424242424242&card[exp_month]=12&card[exp_year]=2024&card[cvc]=123';
        request.setBody(bodyRequest);

        HttpResponse response = http.send(request);
        String responseBody = response.getBody();

        Logs__c aa = new Logs__c();
        aa.Error_Message__c = 'createPaymentMethodInStripe::::'+responseBody;
        insert aa;
    }

    public static void createPaymentInitiationRequest() {

        HttpRequest request = new HttpRequest();
        String customerId = 'cus_OkCUOZYakFz3bE';
        String paymentMethodId = 'card_1Nwi5ZSGDjDbcNLa683OyGN5';
        Integer amount = Integer.valueOf(23);
        String currencyForPayment = 'inr';
        String description = 'TEST Payment';
        String accessToken = 'sk_test_51Nvh9vSGDjDbcNLaHp7zqBx6kbXuXlKsbJbcQsO799G8V1TE1pFfbzK87uaAcA2f0EnU9hKuwa86nRbkBYoSrnOe000OuwTIAZ';
        String params;
        request.setEndpoint(PAYMENT_URL);
        request.setMethod('POST');
        request.setHeader('Authorization', 'Bearer '+accessToken);
        request.setHeader('Content-Type', 'application/x-www-form-urlencoded');
        
        params = 'amount='+amount+'&description=description' +'&currency='+currencyForPayment+'&customer='+customerID+'&payment_method='+paymentMethodId+'&confirm=true&'+'return_url=https://www.google.com';
        
        request.setBody(params);

        Http http = new Http();
        HttpResponse response = http.send(request);
        String responseBody = response.getBody();
        System.debug(responseBody);
        Logs__c aa = new Logs__c();
        aa.Error_Message__c = 'createPaymentInitiationRequest::::'+responseBody;
        insert aa;
    }
}