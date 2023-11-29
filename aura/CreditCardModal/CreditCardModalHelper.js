({	
    getProfile : function(component, event, helper){
    var action = component.get('c.getProfileInfo');
    action.setCallback(this, function(response) {
    var state = response.getState();
    if (state === 'SUCCESS') {
        component.set('v.profile', response.getReturnValue());
    }
    else if (state === 'ERROR') {
    var errors = response.getError();
    if (errors) {
    if (errors[0] && errors[0].message) {
    var errorMessage = 'Tax Error: ' +  errors[0].message;
    helper.fireToast(component, event, helper, 'Oops!  Looks like something went wrong.', 'error', errorMessage);
    }
    }
    }
    });
        $A.enqueueAction(action);
    },
    
    getUser : function(component, event, helper){
        var action = component.get('c.getUserInfo');
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === 'SUCCESS') {
                component.set('v.user', response.getReturnValue());
            }
            else if (state === 'ERROR') {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        var errorMessage = 'Tax Error: ' +  errors[0].message;
                        helper.fireToast(component, event, helper, 'Oops!  Looks like something went wrong.', 'error', errorMessage);
                    }
                }
            }
        });
    
        $A.enqueueAction(action);
    },
    
    setupCCForm : function(component, event, helper) {
        var caseMR = {};
        var caseRecord = component.get('v.caseRecord');
        caseMR.Id = caseRecord.Id;
        caseMR.CurrencyIsoCode = caseRecord.CurrencyIsoCode;
        caseMR.sobjectType = 'Case';
        //Moving all the address fields from the contact to the case
        caseMR.ChargentCases__Billing_Phone__c = '';
        caseMR.ChargentCases__Billing_Address__c = '';
        caseMR.ChargentCases__Billing_City__c = '';
        caseMR.ChargentCases__Billing_State__c = '';
        caseMR.ChargentCases__Billing_Postcode__c = '';
        caseMR.ChargentCases__Billing_Country__c = '';
        if(caseRecord.Contact){
            if(caseRecord.Contact.Name) caseMR.ChargentCases__Card_Name__c = caseRecord.Contact.Name;
            if(caseRecord.ContactPhone) caseMR.ChargentCases__Billing_Phone__c = caseRecord.ContactPhone;
       }
        // Card Info
        caseMR.ChargentCases__Manual_Charge__c = true;
        caseMR.ChargentCases__Card_Type__c = '';
        caseMR.ChargentCases__Card_Number__c = '';
        caseMR.ChargentCases__Card_Month__c = '';
        caseMR.ChargentCases__Card_Year__c = '';
        caseMR.ChargentCases__Payment_Method__c = 'Credit Card';
        component.set('v.caseMR', caseMR);
    },
    
    setupCCAddressForm : function(component, event, helper) {
        var caseMR = component.get('v.caseMR');
        var caseRecord = component.get('v.caseRecord');
        caseMR.Id = caseRecord.Id;
        caseMR.CurrencyIsoCode = caseRecord.CurrencyIsoCode;
        caseMR.sobjectType = 'Case';
        if(caseRecord.Contact){
            if(caseRecord.Contact.MailingStreet) caseMR.ChargentCases__Billing_Address__c = caseRecord.Contact.MailingStreet;
            if(caseRecord.Contact.MailingCity) caseMR.ChargentCases__Billing_City__c = caseRecord.Contact.MailingCity;
            if(caseRecord.Contact.MailingState) caseMR.ChargentCases__Billing_State__c = caseRecord.Contact.MailingState;
            if(caseRecord.Contact.MailingPostalCode) caseMR.ChargentCases__Billing_Postcode__c = caseRecord.Contact.MailingPostalCode;
            if(caseRecord.Contact.MailingCountry) caseMR.ChargentCases__Billing_Country__c = caseRecord.Contact.MailingCountry;
        }
        component.set('v.caseMR', caseMR);
    },
    
    clearCCAddressForm : function(component, event, helper) {
        var caseMR = component.get('v.caseMR');
        //Moving all the address fields from the contact to the case
        caseMR.ChargentCases__Billing_Address__c = '';
        caseMR.ChargentCases__Billing_City__c = '';
        caseMR.ChargentCases__Billing_State__c = '';
        caseMR.ChargentCases__Billing_Postcode__c = '';
        caseMR.ChargentCases__Billing_Country__c = '';
        component.set('v.caseMR', caseMR);
    },
    
    validateCaseInfo : function(component, event, helper) {
        let profile = component.get('v.profile');
        let user = component.get('v.user');
        var caseMR = {};
        var caseRecord = component.get('v.caseRecord');
        caseMR.Id = caseRecord.Id;
        caseMR.sobjectType = 'Case';
        //
        // Need to validate data - if error, then don't allow user to proceed
        //
        var validData = true;
        var toastTitle = 'Sales Case Validation Rule Errors';
        var msg1 = '';
        if (caseRecord.RecordType.DeveloperName != 'Sales') {
            validData = false;
            msg1 += '\n\n*Record Type must be Sales';
        }
        if (caseRecord.Origin == '--None--') {
            validData = false;
            msg1 += '\n\n*Origin Must be set';
        }
        if (caseRecord.Account.Name != 'Service Retail' && caseRecord.Account.Name != 'Service Retail Canada') {
            validData = false;
            msg1 += '\n\n*Account Name is not Service Retail';
        }
        if (caseRecord.Status == 'Closed' || caseRecord.Status == 'Submit to Epicor' || caseRecord.Status == 'Charge Approved') {
            validData = false;
            msg1 += '\n\n*Status cannot be Closed, Charge Approved or Submit to Epicor';
        }
        if (caseRecord.ContactId == null) {
            validData = false;
            msg1 += '\n\n*Contact is missing';
        }
        if (caseRecord.ContactPhone == null) {
            validData = false;
            msg1 += '\n\n*Phone Number is missing';
        }
        if(caseRecord.Contact){
            if (caseRecord.Contact.MailingStreet == null){
                validData = false;
                msg1 += '\n\n*No Mailing Address on Case Contact';
            }
            if (caseRecord.Contact.MailingCity == null){
                validData = false;
                msg1 += '\n\n*No Mailing City on Case Contact';
            }
            if (caseRecord.Contact.MailingPostalCode == null) {
                validData = false;
                msg1 += '\n\n*No Mailing PostalCode on Case Contact';
            }
            if (caseRecord.Contact.MailingState == null) {
                validData = false;
                msg1 += '\n\n*No Mailing State on Case Contact';
            }
        }
        if (caseRecord.Case_Replacement_Products__r == null) {
            validData = false;
            msg1 += '\n\n*No Product(s) have been added to Case';
        }
        if (caseRecord.RecordType.DeveloperName != 'Sales' && caseRecord.Case_Replacement_Products__r != null && profile.Name != 'System Administrator' && profile.Name != 'Sales Administrator'
                                                            && user.Title != 'Team Lead') {
            var containGrills = false;
            for (var x in caseRecord.Case_Replacement_Products__r) {
                if (caseRecord.Case_Replacement_Products__r[x].Product__r.Family == 'Grills') {
                    validData = false;
                    msg1 += '\n\n*Grill Product(s) not allowed on Sales Case';
                    break;
                }
            }
        }
        if (caseRecord.Product_Total__c <= 0) {
            validData = false;
            msg1 += '\n\n*Shipping amount is blank';
        }
        if (validData) {
            caseMR.Validation_Error_Message__c = null;
            component.set('v.stage', 'card');
        } else {
            caseMR.Validation_Error_Message__c = msg1;
            component.set('v.stage', 'validation');
            component.set('v.isLoading', false);
    
        }
        component.set('v.caseMR', caseMR);
    },
    
    createCardTypeOptions : function(component, event, helper){
        var cardTypeOptions = [
            {'label':'Visa', 'value':'Visa'},
            {'label':'Mastercard', 'value':'Mastercard'},
            {'label':'Discover', 'value':'Discover'},
            {'label':'AMEX', 'value':'AMEX'},
            {'label':'MC Eurocard', 'value':'MC Eurocard'},
            {'label':'UK Maestro', 'value':'UK Maestro'},
            {'label':'JCB Card', 'value':'JCB Card'},
            {'label':'Solo', 'value':'Solo'},
            {'label':'Electron', 'value':'Electron'}
        ];
    
        component.set('v.cardTypeOptions', cardTypeOptions);
    },
    
    createStateOptions : function(component, event, helper){
        var caseRecord = component.get('v.caseRecord');
        var USstatesList = [
            'Alabama',
            'Alaska',
            'Arizona',
            'Arkansas',
            'California',
            'Colorado',
            'Connecticut',
            'Delaware',
            'District of Columbia',
            'Florida',
            'Georgia',
            'Hawaii',
            'Idaho',
            'Illinois',
            'Indiana',
            'Iowa',
            'Kansas',
            'Kentucky',
            'Louisiana',
            'Maine',
            'Maryland',
            'Massachusetts',
            'Michigan',
            'Minnesota',
            'Mississippi',
            'Missouri',
            'Montana',
            'Nebraska',
            'Nevada',
            'New Hampshire',
            'New Jersey',
            'New Mexico',
            'New York',
            'North Carolina',
            'North Dakota',
            'Ohio',
            'Oklahoma',
            'Oregon',
            'Pennsylvania',
            'Rhode Island',
            'South Carolina',
            'South Dakota',
            'Tennessee',
            'Texas',
            'Utah',
            'Vermont',
            'Virginia',
            'Washington',
            'West Virginia',
            'Wisconsin',
            'Wyoming'
        ];
    
        var CAprovincesList = [
            'Alberta',
            'British Columbia',
            'Manitoba',
            'New Brunswick',
            'Newfoundland and Labrador',
            'Northwest Territories',
            'Nova Scotia',
            'Nunavut',
            'Ontario',
            'Prince Edward Island',
            'Quebec',
            'Saskatchewan',
            'Yukon'
        ];
        var statesListFormatted = [];
        if(caseRecord.CurrencyIsoCode == 'CAD'){
            for(var i = 0; i<CAprovincesList.length; i++){
                var option = {
                    'label' : CAprovincesList[i],
                    'value' : CAprovincesList[i]
                }
    
                statesListFormatted.push(option);
            }
        } else {
            for(var i = 0; i<USstatesList.length; i++){
                var option = {
                    'label' : USstatesList[i],
                    'value' : USstatesList[i]
                }
    
                statesListFormatted.push(option);
            }
        }
    
        component.set('v.stateOptions', statesListFormatted);
    },
    
    createMonthOptions : function(component, event, helper){
        var monthsList = [
            '01',
            '02',
            '03',
            '04',
            '05',
            '06',
            '07',
            '08',
            '09',
            '10',
            '11',
            '12'
        ];
        var monthsListFormatted = [];
        for(var i = 0; i<monthsList.length; i++){
            var option = {
                'label' : monthsList[i],
                'value' : monthsList[i]
            }
    
            monthsListFormatted.push(option);
        }
    
        component.set('v.monthOptions', monthsListFormatted);
    },
    
    createYearOptions : function(component, event, helper){
        var yearsList = [
            '2021',
            '2022',
            '2023',
            '2024',
            '2025',
            '2026',
            '2027',
            '2028',
            '2029',
            '2030',
            '2031'
        ];
        var yearsListFormatted = [];
        for(var i = 0; i<yearsList.length; i++){
            var option = {
                'label' : yearsList[i],
                'value' : yearsList[i]
            }
    
            yearsListFormatted.push(option);
        }
    
        component.set('v.yearOptions', yearsListFormatted);
    },
    
    saveAndCharge : function(component, event, helper){
        component.set('v.showSpinner', true);
        //
        // set isLoading to true thus disabling buttons on Credit Card modal
        //
        component.set('v.isLoading', true);
        var action = component.get("c.saveCreditCardInfoApxc");
        var caseMR = component.get('v.caseMR');
        caseMR = JSON.stringify(caseMR);
        caseMR = JSON.parse(caseMR);
        action.setParams({ caseRecord :  caseMR});
    
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                helper.chargeCreditCard(component, event, helper);
            }
            else if (state === "INCOMPLETE") {
                // do something
           }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("CaseProducts: Error message: " +   errors[0].message);
                        var toastTitle = 'Oops! Looks like something went wrong.';
                        var toastType = 'Error';
                        var toastMessage = 'Charge Error: ' + errors[0].message;
                        component.set('v.showSpinner', false);
                        component.set('v.disableChargeCardButton', false);
                        helper.fireToast(component, event, helper, toastTitle, toastType, toastMessage);
                    }
                } else {
                    console.log("CaseProducts: Unknown error");
                }
            }
    
        });
    
        $A.enqueueAction(action);
    },
    
    chargeCreditCard : function(component, event, helper){
            //
            // set isLoading to true thus disabling buttons on Credit Card modal
            // 
            component.set('v.isLoading', true);
            var action = component.get("c.chargeCCApxc");
            var caseMR = component.get('v.caseMR');
            action.setParams({ caseRecordId :  caseMR.Id});
    
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    
                    helper.fireToast(component, event, helper, 'Success!', 'success', 'Looks like everything went through just fine.');
                    //show the toast for a few seconds and then refresh the page
                    window.setTimeout(
                        $A.getCallback(function() {
                            $A.get('e.force:refreshView').fire();
                            component.set('v.disableChargeCardButton', true);
                            component.set('v.showModal', false);
                        }), 1500
                    );
                }
                else if (state === "INCOMPLETE") {
                    // do something
                    //
                    // if an error - set isLoading to false so that buttons are enabled
                    //
                    //component.set('v.isLoading', false);
                    //
                    
                    helper.noServerResponse(component, event, helper);
                    var toastTitle = 'Paypal Timeout Error.';
                    var toastType = 'Error';
                    var toastMessage = 'The response from Paypal was delayed, or a remote server error occurred. Please do not resubmit payment until Paypal can be checked. The System Adminstrator has been notified.';
                    helper.fireToast(component, event, helper, toastTitle, toastType, toastMessage);
                    
                }
                else if (state === "ERROR") {
                    //
                    // if an error - set isLoading to false so that buttons are enabled
                    //
                    component.set('v.isLoading', false);
                       var errors = response.getError();
                    var errorMsg = errors[0].message;
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            var toastTitle = 'Oops! Looks like something went wrong.';
                            var toastType = 'Error';
                            var toastMessage = 'Charge Error: ' + errors[0].message;
                            helper.fireToast(component, event, helper, toastTitle, toastType, toastMessage);
                            helper.createResponseRecord(component, event, helper, errorMsg, caseMR);
    
    
                        }
                    } else {
                        console.log("CaseProducts: Unknown error");
                    }
                }
                component.set('v.showSpinner', false);
            });
    
            $A.enqueueAction(action);
        },
        
    noServerResponse : function(component, event, helper){
        var action = component.get("c.noPayPalServerResponse");
        var caseMR = component.get('v.caseMR');
        action.setParams({ caseRecordId :  caseMR.Id});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var toastTitle = 'Paypal Timeout Error.';
                var toastType = 'Error';
                var toastMessage = 'The response from Paypal was delayed, or a remote server error occurred. Please do not resubmit payment until Paypal can be checked. The System Adminstrator has been notified.';
                helper.fireToast(component, event, helper, toastTitle, toastType, toastMessage);
                
                window.setTimeout(
                    $A.getCallback(function() {
                        $A.get('e.force:refreshView').fire();
                        component.set('v.disableChargeCardButton', true);
                        component.set('v.showModal', false);
                    }), 1500
                );
            } else if (state === "INCOMPLETE") {
                // do something
            } else if (state === "ERROR") {
                //
                // if an error - set isLoading to false so that buttons are enabled
                //
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("CaseProducts: Error message: " +   errors[0].message);
                        var toastTitle = 'Oops! Looks like something went wrong.';
                        var toastType = 'Error';
                        var toastMessage = 'Charge Error: ' + errors[0].message;
                        helper.fireToast(component, event, helper, toastTitle, toastType, toastMessage);
                    }
                } else {
                    console.log("CaseProducts: Unknown error");
                }
            }
            component.set('v.showSpinner', false);
        });
        $A.enqueueAction(action);
    },
        
    createResponseRecord : function(component, event, helper, errorMsg, caseMR){
        var action = component.get("c.createMessageRecord");
        action.setParams({
            caseRecordId : caseMR.Id,
            errorMsg : errorMsg
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log("Response Record Created");
            } else if(state === "INCOMPLETE") {
                console.log("Response Record Incomplete");
            } else if(state === "ERROR"){
                console.log("Create Response Record: Unknown error");
            } else {
                console.log("CaseProducts: Unknown error");
            }
        });
        $A.enqueueAction(action);
    },
        
    refresh : function(component, event, helper) {
        var action = component.get('c.CreditCardModalController');
        action.setCallback(component,
                           function(response) {
                               var state = response.getState();
                               if (state === 'SUCCESS'){
                                   $A.get('e.force:refreshView').fire();
                               } else {
                                   //do something
                               }
                           }
                          );
        $A.enqueueAction(action);
    },
        
    fireToast : function(component, event, helper, toastTitle, toastType, toastMessage){
        var resultsToast = $A.get("e.force:showToast");
        resultsToast.setParams({
            "title": toastTitle,
            "message": toastMessage,
            "type": toastType
        });
        resultsToast.fire();
    }
    
})