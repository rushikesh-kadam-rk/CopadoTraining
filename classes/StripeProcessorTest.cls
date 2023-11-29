@isTest
private without sharing class StripeProcessorTest {
    
    @isTest
    static void test_createPaymentMethodNegative(){
        Account testAccount = new Account(Name = 'Apex Test');
        insert testAccount;
        Contact testContact = new Contact(FirstName = 'Test FN',
                                  LastName = 'Test LN',
                                  AccountId = testAccount.Id,
                                  MailingStreet = '1 Market St',
							      MailingState = 'California',
							      MailingPostalCode = '94105',
							      Phone = '2085551212',
                                  Email = 'testcontact@test.com'
                                  
        );
        insert testContact;
        Case caseMR = new Case();
        caseMR.AccountId=testAccount.Id;
        caseMR.ContactId=testContact.Id;
        caseMR.CC_Card_Number__c = '4242424242424241';
        caseMR.CC_Card_Month__c = '12';
        caseMR.CC_Card_Year__c = '2043';
        caseMR.CC_Card_CVC__c = '123';
        caseMR.CC_Charge_Amount__c = 300;
        caseMR.CurrencyIsoCode = 'CAD';
        Database.insert(caseMR);
        Test.startTest();
        String mockResponse = '{"error":{"code": "incorrect_number", "message": "Your card number is incorrect.", "type": "card_error"}}';
        HttpMockFactory mockHttpResponse = new HttpMockFactory(402, 
                                                           '402Payment Required',
                                                           mockResponse,
                                                           'https://api.stripe.com//v1/payment_methods',
                                                           'POST'
                                                          );
        Test.setMock(HttpCalloutMock.class, mockHttpResponse);
        List<String> createCustomerResponse = StripeProcessor.StripeProcessor(caseMR);
        Assert.areEqual('402', createCustomerResponse[0]);
        Test.stopTest();
    }
    
     @isTest
    static void test_StripeProcessorPositive(){
        Account testAccount = new Account(Name = 'Apex Test');
        insert testAccount;
        Contact testContact = new Contact(FirstName = 'Test FN',
                                  LastName = 'Test LN',
                                  AccountId = testAccount.Id,
                                  MailingStreet = '1 Market St',
							      MailingState = 'California',
							      MailingPostalCode = '94105',
							      Phone = '2085551212',
                                  Email = 'testcontact@test.com'
                                  
        );
        insert testContact;
        Case caseMR = new Case();
        caseMR.AccountId=testAccount.Id;
        caseMR.ContactId=testContact.Id;
        caseMR.CC_Card_Number__c = '4242424242424241';
        caseMR.CC_Card_Month__c = '12';
        caseMR.CC_Card_Year__c = '2043';
        caseMR.CC_Card_CVC__c = '123';
        caseMR.CC_Charge_Amount__c = 300;
        caseMR.CurrencyIsoCode = 'CAD';
        Database.insert(caseMR);
        Test.startTest();
        String mockCreateCustomer = '{"id": "cus_OqEW5dBqiB72nw","object": "customer"}';
        HttpMockFactory mockCreateCustomerResp = new HttpMockFactory(200, 
                                                           '200 OK',
                                                           mockCreateCustomer,
                                                           'https://api.stripe.comv1/customers',
                                                           'POST'
                                                          );
        
        String mockPaymentMethod = '{"id": "pm_1O2Z5eSGDjDbcNLaYIufHRvF","object": "payment_method"}';
        HttpMockFactory mockPaymentMethodResp = new HttpMockFactory(200, 
                                                           '200 OK',
                                                           mockPaymentMethod,
                                                           'https://api.stripe.com//v1/payment_methods',
                                                           'POST'
                                                          );
        String mockUpdatePaymentMethod = '{"id": "pm_1O2Z5eSGDjDbcNLaYIufHRvF","object": "payment_method"}';
        HttpMockFactory mockUpdatePaymentMethodResp = new HttpMockFactory(200, 
                                                           '200 OK',
                                                           mockUpdatePaymentMethod, 
                                                           'https://api.stripe.com//v1/payment_methods/pm_1O2Z5eSGDjDbcNLaYIufHRvF/attach',
                                                           'POST'
                                                          );
        String mockPaymentIntent = '{"id": "pi_3O2rqkSGDjDbcNLa0ucBANc4","object": "payment_intent"}';
        HttpMockFactory mockPaymentIntentResp = new HttpMockFactory(200, 
                                                           '200 OK',
                                                           mockPaymentIntent,
                                                           'https://api.stripe.com//v1/payment_intents',
                                                           'POST'
                                                          );
        String mockConfirmPaymentIntent = '{"id": "pi_3O2rqkSGDjDbcNLa0ucBANc4","object": "payment_intent"}';
        HttpMockFactory mockConfirmPaymentIntentResp = new HttpMockFactory(200, 
                                                           '200 OK',
                                                           mockConfirmPaymentIntent,
                                                           'https://api.stripe.com//v1/payment_intents/pi_3O2rqkSGDjDbcNLa0ucBANc4/confirm',
                                                           'POST'
                                                          );
        Map<String, HttpCalloutMock> endpoint2TestResp =
                                   new Map<String,HttpCalloutMock>();
        endpoint2TestResp.put('https://api.stripe.com/v1/customers',mockCreateCustomerResp);
        endpoint2TestResp.put('https://api.stripe.com//v1/payment_methods',mockPaymentMethodResp);
        endpoint2TestResp.put('https://api.stripe.com//v1/payment_methods/pm_1O2Z5eSGDjDbcNLaYIufHRvF/attach',mockUpdatePaymentMethodResp);
        endpoint2TestResp.put('https://api.stripe.com//v1/payment_intents',mockPaymentIntentResp);
        endpoint2TestResp.put('https://api.stripe.com//v1/payment_intents/pi_3O2rqkSGDjDbcNLa0ucBANc4/confirm',mockConfirmPaymentIntentResp);
        HttpCalloutMock multiCalloutMock =
            	                   new MultiRequestMock(endpoint2TestResp);

        Test.setMock(HttpCalloutMock.class, multiCalloutMock);
        List<String> createCustomerResponse = StripeProcessor.StripeProcessor(caseMR);
        Assert.areEqual('200', createCustomerResponse[0]);
        Test.stopTest();
    }
    
    @isTest
    static void test_StripeProcessorNegative(){
        Account testAccount = new Account(Name = 'Apex Test');
        insert testAccount;
        Contact testContact = new Contact(FirstName = 'Test FN',
                                  LastName = 'Test LN',
                                  AccountId = testAccount.Id,
                                  MailingStreet = '1 Market St',
							      MailingState = 'California',
							      MailingPostalCode = '94105',
							      Phone = '2085551212',
                                  Email = 'testcontact@test.com'
                                  
        );
        insert testContact;
        Case caseMR = new Case();
        caseMR.AccountId=testAccount.Id;
        caseMR.ContactId=testContact.Id;
        caseMR.CC_Card_Number__c = '4242424242424241';
        caseMR.CC_Card_Month__c = '12';
        caseMR.CC_Card_Year__c = '2043';
        caseMR.CC_Card_CVC__c = '123';
        caseMR.CC_Charge_Amount__c = 300;
        caseMR.CurrencyIsoCode = 'USD';
        Database.insert(caseMR);
        Test.startTest();
        String mockCreateCustomer = '{"id": "cus_OqEW5dBqiB72nw","object": "customer"}';
        HttpMockFactory mockCreateCustomerResp = new HttpMockFactory(200, 
                                                           '200 OK',
                                                           mockCreateCustomer,
                                                           'https://api.stripe.comv1/customers',
                                                           'POST'
                                                          );
        
        String mockPaymentMethod = '{"id": "pm_1O2Z5eSGDjDbcNLaYIufHRvF","object": "payment_method"}';
        HttpMockFactory mockPaymentMethodResp = new HttpMockFactory(200, 
                                                           '200 OK',
                                                           mockPaymentMethod,
                                                           'https://api.stripe.com//v1/payment_methods',
                                                           'POST'
                                                          );
        String mockUpdatePaymentMethod = '{"id": "pm_1O2Z5eSGDjDbcNLaYIufHRvF","object": "payment_method"}';
        HttpMockFactory mockUpdatePaymentMethodResp = new HttpMockFactory(200, 
                                                           '200 OK',
                                                           mockUpdatePaymentMethod, 
                                                           'https://api.stripe.com//v1/payment_methods/pm_1O2Z5eSGDjDbcNLaYIufHRvF/attach',
                                                           'POST'
                                                          );
        String mockPaymentIntent = '{"error":{"code": "resource_missing", "message": "No such PaymentMethod: \'null\'", "type": "invalid_request_error"}}';
        HttpMockFactory mockPaymentIntentResp = new HttpMockFactory(400, 
                                                           '400 Bad Request',
                                                           mockPaymentIntent,
                                                           'https://api.stripe.com//v1/payment_intents',
                                                           'POST'
                                                          );
        String mockConfirmPaymentIntent = '{"error":{"code": "resource_missing", "message": "No such PaymentMethod: \'null\'", "type": "invalid_request_error"}}';
        HttpMockFactory mockConfirmPaymentIntentResp = new HttpMockFactory(400, 
                                                           '400 Bad Request',
                                                           mockConfirmPaymentIntent,
                                                           'https://api.stripe.com//v1/payment_intents/null/confirm',
                                                           'POST'
                                                          );
        Map<String, HttpCalloutMock> endpoint2TestResp =
                                   new Map<String,HttpCalloutMock>();
        endpoint2TestResp.put('https://api.stripe.com/v1/customers',mockCreateCustomerResp);
        endpoint2TestResp.put('https://api.stripe.com//v1/payment_methods',mockPaymentMethodResp);
        endpoint2TestResp.put('https://api.stripe.com//v1/payment_methods/pm_1O2Z5eSGDjDbcNLaYIufHRvF/attach',mockUpdatePaymentMethodResp);
        endpoint2TestResp.put('https://api.stripe.com//v1/payment_intents',mockPaymentIntentResp);
        endpoint2TestResp.put('https://api.stripe.com//v1/payment_intents/null/confirm',mockConfirmPaymentIntentResp);
        HttpCalloutMock multiCalloutMock =
            	                   new MultiRequestMock(endpoint2TestResp);

        Test.setMock(HttpCalloutMock.class, multiCalloutMock);
        List<String> createCustomerResponse = StripeProcessor.StripeProcessor(caseMR);
        Assert.areEqual('400', createCustomerResponse[0]);
        Test.stopTest();
    }
    
    @isTest
    static void test_StripeProcessorNegativeTwo(){
        Account testAccount = new Account(Name = 'Apex Test');
        insert testAccount;
        Contact testContact = new Contact(FirstName = 'Test FN',
                                  LastName = 'Test LN',
                                  AccountId = testAccount.Id,
                                  MailingStreet = '1 Market St',
							      MailingState = 'California',
							      MailingPostalCode = '94105',
							      Phone = '2085551212',
                                  Email = 'testcontact@test.com'
                                  
        );
        insert testContact;
        Case caseMR = new Case();
        caseMR.AccountId=testAccount.Id;
        caseMR.ContactId=testContact.Id;
        caseMR.CC_Card_Number__c = '4242424242424241';
        caseMR.CC_Card_Month__c = '12';
        caseMR.CC_Card_Year__c = '2043';
        caseMR.CC_Card_CVC__c = '123';
        caseMR.CC_Charge_Amount__c = 300;
        caseMR.CurrencyIsoCode = 'USD';
        Database.insert(caseMR);
        Test.startTest();
        String mockCreateCustomer = '{"id": "cus_OqEW5dBqiB72nw","object": "customer"}';
        HttpMockFactory mockCreateCustomerResp = new HttpMockFactory(200, 
                                                           '200 OK',
                                                           mockCreateCustomer,
                                                           'https://api.stripe.comv1/customers',
                                                           'POST'
                                                          );
        
        String mockPaymentMethod = '{"id": "pm_1O2Z5eSGDjDbcNLaYIufHRvF","object": "payment_method"}';
        HttpMockFactory mockPaymentMethodResp = new HttpMockFactory(200, 
                                                           '200 OK',
                                                           mockPaymentMethod,
                                                           'https://api.stripe.com//v1/payment_methods',
                                                           'POST'
                                                          );
        String mockUpdatePaymentMethod = '{"error":{"code": "incorrect_cvc", "message": "Your card\'s security code is incorrect.", "type": "card_error"}}';
        HttpMockFactory mockUpdatePaymentMethodResp = new HttpMockFactory(402, 
                                                           '402 Payment Required',
                                                           mockUpdatePaymentMethod, 
                                                           'https://api.stripe.com//v1/payment_methods/pm_1O2Z5eSGDjDbcNLaYIufHRvF/attach',
                                                           'POST'
                                                          );
        Map<String, HttpCalloutMock> endpoint2TestResp =
                                   new Map<String,HttpCalloutMock>();
        endpoint2TestResp.put('https://api.stripe.com/v1/customers',mockCreateCustomerResp);
        endpoint2TestResp.put('https://api.stripe.com//v1/payment_methods',mockPaymentMethodResp);
        endpoint2TestResp.put('https://api.stripe.com//v1/payment_methods/pm_1O2Z5eSGDjDbcNLaYIufHRvF/attach',mockUpdatePaymentMethodResp);
        HttpCalloutMock multiCalloutMock =
            	                   new MultiRequestMock(endpoint2TestResp);

        Test.setMock(HttpCalloutMock.class, multiCalloutMock);
        List<String> createCustomerResponse = StripeProcessor.StripeProcessor(caseMR);
        Assert.areEqual('402', createCustomerResponse[0]);
        Test.stopTest();
    }
    
}