@isTest
private with sharing class StripeHandlerTest {
    
    @isTest
    static void test_createCustomerPositive(){
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
        Test.startTest();
        String mockResponse = '{"id": "cus_OqEW5dBqiB72nw","object": "customer"}';
        HttpMockFactory mockHttpResponse = new HttpMockFactory(200, 
                                                           '200 OK',
                                                           mockResponse,
                                                           'https://api.stripe.com/v1/customers',
                                                           'POST'
                                                          );
        Test.setMock(HttpCalloutMock.class, mockHttpResponse);
        String createCustomerResponse = StripeHandler.CreateCustomer(caseMR, 'https://api.stripe.com/', 'testauthkey');
        Assert.areEqual('cus_OqEW5dBqiB72nw', createCustomerResponse);
        Test.stopTest();
    }
    
    @isTest
    static void test_createPaymentMethodPositive(){
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
        caseMR.CC_Card_Number__c = '4000000360000006';
        caseMR.CC_Card_Month__c = '12';
        caseMR.CC_Card_Year__c = '2043';
        caseMR.CC_Card_CVC__c = '123';
        Test.startTest();
        String mockResponse = '{"id": "pm_1O2Z5eSGDjDbcNLaYIufHRvF","object": "payment_method"}';
        HttpMockFactory mockHttpResponse = new HttpMockFactory(200, 
                                                           '200 OK',
                                                           mockResponse,
                                                           'https://api.stripe.com/v1/payment_methods',
                                                           'POST'
                                                          );
        Test.setMock(HttpCalloutMock.class, mockHttpResponse);
        String createPaymentMethodResponse = StripeHandler.CreatePaymentMethod(caseMR,
                                                                               'https://api.stripe.com/',
                                                                               'testauthkey');
        Assert.areEqual('pm_1O2Z5eSGDjDbcNLaYIufHRvF', createPaymentMethodResponse);
        Test.stopTest();
    }
    
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
        Test.startTest();
        String mockResponse = '{"error":{"code": "incorrect_number", "message": "Your card number is incorrect.", "type": "card_error"}}';
        HttpMockFactory mockHttpResponse = new HttpMockFactory(402, 
                                                           '402Payment Required',
                                                           mockResponse,
                                                           'https://api.stripe.com/v1/payment_methods',
                                                           'POST'
                                                          );
        Test.setMock(HttpCalloutMock.class, mockHttpResponse);
        String createPaymentMethodResponse = StripeHandler.CreatePaymentMethod(caseMR,
                                                                               'https://api.stripe.com/',
                                                                               'testauthkey');
        Assert.areEqual('Invalid Card Error::402::Your card number is incorrect.', createPaymentMethodResponse);
        Test.stopTest();
    }
    
    @isTest
    static void test_UpdateCustomerWithPaymentMethodPositive(){
        Test.startTest();
        String mockResponse = '{"id": "pm_1O2Z5eSGDjDbcNLaYIufHRvF","object": "payment_method"}';
        HttpMockFactory mockHttpResponse = new HttpMockFactory(200, 
                                                           '200 OK',
                                                           mockResponse,
                                                           'https://api.stripe.com/v1/payment_methods/pm_1O2Z5eSGDjDbcNLaYIufHRvF/attach',
                                                           'POST'
                                                          );
        Test.setMock(HttpCalloutMock.class, mockHttpResponse);
        String updateCustomerWithPaymentMethodResponse = StripeHandler.UpdateCustomerWithPaymentMethod('cus_OqEW5dBqiB72nw',
                                                                               'pm_1O2Z5eSGDjDbcNLaYIufHRvF',
                                                                               'https://api.stripe.com/',
                                                                               'testauthkey');
        Assert.areEqual(NULL, updateCustomerWithPaymentMethodResponse);
        Test.stopTest();
    }
    
    @isTest
    static void test_UpdateCustomerWithPaymentMethodNegative(){
        Test.startTest();
        String mockResponse = '{"error":{"code": "incorrect_cvc", "message": "Your card\'s security code is incorrect.", "type": "card_error"}}';
        HttpMockFactory mockHttpResponse = new HttpMockFactory(402, 
                                                           '402 Payment Required',
                                                           mockResponse,
                                                           'https://api.stripe.com/v1/payment_methods/pm_1O288aSGDjDbcNLaCRKPEojy /attach',
                                                           'POST'
                                                          );
        Test.setMock(HttpCalloutMock.class, mockHttpResponse);
        String updateCustomerWithPaymentMethodResponse = StripeHandler.UpdateCustomerWithPaymentMethod('cus_OqEW5dBqiB72nw',
                                                                               'pm_1O288aSGDjDbcNLaCRKPEojy',
                                                                               'https://api.stripe.com/',
                                                                               'testauthkey');
        Assert.areEqual('Invalid Card Error::402::Your card\'s security code is incorrect.', updateCustomerWithPaymentMethodResponse);
        Test.stopTest();
    }
    
    @isTest
    static void test_CreatePaymentIntentPositive(){
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
        caseMR.CC_Charge_Amount__c = 440;
        caseMR.CurrencyIsoCode = 'USD';
        Test.startTest();
        String mockResponse = '{"id": "pi_3O2rqkSGDjDbcNLa0ucBANc4","object": "payment_intent"}';
        HttpMockFactory mockHttpResponse = new HttpMockFactory(200, 
                                                           '200 OK',
                                                           mockResponse,
                                                           'https://api.stripe.com/v1/payment_intents',
                                                           'POST'
                                                          );
        Test.setMock(HttpCalloutMock.class, mockHttpResponse);
        List<String> createPaymentIntentResponse = StripeHandler.CreatePaymentIntent('cus_OqEW5dBqiB72nw',
                                                                               'pm_1O2Z5eSGDjDbcNLaYIufHRvF',
                                                                               'https://api.stripe.com/',
                                                                               'testauthkey', caseMR);
        String currentResponse = createPaymentIntentResponse[0]+
            							'::'+createPaymentIntentResponse[1]+
            							'::'+createPaymentIntentResponse[2];
        Assert.areEqual('200::200 OK::pi_3O2rqkSGDjDbcNLa0ucBANc4', currentResponse);
        Test.stopTest();
    }
    
    @isTest
    static void test_CreatePaymentIntentNegative(){
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
        caseMR.CC_Charge_Amount__c = 440;
        caseMR.CurrencyIsoCode = 'USD';
        Test.startTest();
        String mockResponse = '{"error":{"code": "resource_missing", "message": "No such PaymentMethod: \'null\'", "type": "invalid_request_error"}}';
        HttpMockFactory mockHttpResponse = new HttpMockFactory(400, 
                                                           '400 Bad Request',
                                                           mockResponse,
                                                           'https://api.stripe.com/v1/payment_intents',
                                                           'POST'
                                                          );
        Test.setMock(HttpCalloutMock.class, mockHttpResponse);
        List<String> createPaymentIntentResponse = StripeHandler.CreatePaymentIntent('cus_OqEW5dBqiB72nw',
                                                                               'pm_1O2Z5eSGDjDbcNLaYIufHRvF',
                                                                               'https://api.stripe.com/',
                                                                               'testauthkey', caseMR);
        String currentResponse = createPaymentIntentResponse[0]+
            							'::'+createPaymentIntentResponse[1]+
            							'::'+createPaymentIntentResponse[3];
            Assert.areEqual('400::400 Bad Request::No such PaymentMethod: \'null\'', currentResponse);
        Test.stopTest();
    }
    
    @isTest
    static void test_ConfirmPaymentIntentPositive(){
        Test.startTest();
        String mockResponse = '{"id": "pi_3O2rqkSGDjDbcNLa0ucBANc4","object": "payment_intent"}';
        HttpMockFactory mockHttpResponse = new HttpMockFactory(200, 
                                                           '200 OK',
                                                           mockResponse,
                                                           'https://api.stripe.com/v1/payment_intents',
                                                           'POST'
                                                          );
        Test.setMock(HttpCalloutMock.class, mockHttpResponse);
        List<String> confirmPaymentIntentResponse = StripeHandler.ConfirmPaymentIntent('pi_3O2sLqSGDjDbcNLa1oyQ026X',
                                                                               'https://api.stripe.com/',
                                                                               'testauthkey');
        String currentResponse = confirmPaymentIntentResponse[0]+
            							'::'+confirmPaymentIntentResponse[1]+
            							'::'+confirmPaymentIntentResponse[2];
        Assert.areEqual('200::200 OK::pi_3O2sLqSGDjDbcNLa1oyQ026X', currentResponse);
        Test.stopTest();
    }
    
    @isTest
    static void test_ConfirmPaymentIntentNegative(){
        Test.startTest();
        String mockResponse = '{"error":{"code": "card_declined", "message": "Your card was declined.", "decline_code": "expired_card", "type": "card_error"}}';
        HttpMockFactory mockHttpResponse = new HttpMockFactory(402, 
                                                           '402 Payment Required',
                                                           mockResponse,
                                                           'https://api.stripe.com/v1/payment_intents/pi_3O2sLqSGDjDbcNLa1oyQ026X/confirm',
                                                           'POST'
                                                          );
        Test.setMock(HttpCalloutMock.class, mockHttpResponse);
        List<String> confirmPaymentIntentResponse = StripeHandler.ConfirmPaymentIntent('pi_3O2sLqSGDjDbcNLa1oyQ026X',
                                                                               'https://api.stripe.com/',
                                                                               'testauthkey');
        String currentResponse = confirmPaymentIntentResponse[0]+
            							'::'+confirmPaymentIntentResponse[1]+
            							'::'+confirmPaymentIntentResponse[3];
        Assert.areEqual('402::402 Payment Required::The card has expired.', currentResponse);
        Test.stopTest();
    }
    
    @isTest
    static void test_ConfirmPaymentIntentUnknownNegative(){
        Test.startTest();
        String mockResponse = '{"error":{"code": "card_declined", "message": "Your card was declined.", "decline_code": "service_not_allowed", "type": "card_error"}}';
        HttpMockFactory mockHttpResponse = new HttpMockFactory(402, 
                                                           '402 Payment Required',
                                                           mockResponse,
                                                           'https://api.stripe.com/v1/payment_intents/pi_3O2sLqSGDjDbcNLa1oyQ026X/confirm',
                                                           'POST'
                                                          );
        Test.setMock(HttpCalloutMock.class, mockHttpResponse);
        List<String> confirmPaymentIntentResponse = StripeHandler.ConfirmPaymentIntent('pi_3O2sLqSGDjDbcNLa1oyQ026X',
                                                                               'https://api.stripe.com/',
                                                                               'testauthkey');
        String currentResponse = confirmPaymentIntentResponse[0]+
            							'::'+confirmPaymentIntentResponse[1]+
            							'::'+confirmPaymentIntentResponse[3];
        Assert.areEqual('402::402 Payment Required::The card was declined for an unknown reason.', currentResponse);
        Test.stopTest();
    }
}