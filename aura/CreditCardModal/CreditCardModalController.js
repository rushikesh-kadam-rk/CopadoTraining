({
	doInit : function(component, event, helper) {
		helper.getProfile(component, event, helper);
		helper.getUser(component, event, helper);
        helper.createYearOptions(component, event, helper);
        helper.createMonthOptions(component, event, helper);
        
	},
    
    sendData: function(component, event, helper) {
		helper.sendData(component);
	},
    
    onCheckBoxCheck: function(component, event, helper) {
        var checkbox = event.getSource();
        var myResult = checkbox.get("v.value");
     	console.log(checkbox.get("v.value"));
        if (myResult) {
        	helper.setupCCAddressForm(component, event, helper);
        } else {
        	helper.clearCCAddressForm(component, event, helper);
        }
	},

	showModal : function(component, event, helper) {
        //
        // refresh the view first to make sure working with latest changes
        // 
        $A.get('e.force:refreshView').fire();           
        helper.validateCaseInfo(component, event, helper);
        if (component.get('v.stage') =='card') {
            // split setupCCForm into two parts - the card part which is still done here
            // and the address part which is done based on checkbox
            //helper.setupCCForm(component, event, helper);
            //helper.createCardTypeOptions(component, event, helper);
            //helper.createStateOptions(component, event, helper);
            helper.createYearOptions(component, event, helper);
            helper.createMonthOptions(component, event, helper);
            console.log('RKLLLL');
        }
		component.set('v.showModal', true);
        $A.get('e.force:refreshView').fire();           
	},
    
	hideModal : function(component, event, helper) {
		component.set('v.stage', 'validation');
		component.set('v.showModal', false);
        helper.sendData(component);
	},

	nextStage : function(component, event, helper){
        var BillingAddr = component.find("myBillAddr");
        var isValid = BillingAddr.reportValidity();
        var BillCity = component.find("myBillCity");
        isValid = isValid && BillCity.reportValidity();
        var BillingState = component.find("myBillState");
        isValid = isValid && BillingState.reportValidity();
        var PostalCode = component.find("myPostCode");
        isValid = isValid && PostalCode.reportValidity();
        var Country = component.find("myCountry");
        isValid = isValid && Country.reportValidity();
        if (isValid) {
            component.set('v.stage', 'card');
        } else {
            alert('Please update the invalid entries and try again.');
        }
	},

	saveAndCharge : function(component, event, helper){
        var BillingAddr = component.find("myBillAddr");
        var isValid = BillingAddr.reportValidity();
        var BillCity = component.find("myBillCity");
        isValid = isValid && BillCity.reportValidity();
        var BillingState = component.find("myBillState");
        isValid = isValid && BillingState.reportValidity();
        var PostalCode = component.find("myPostCode");
        isValid = isValid && PostalCode.reportValidity();
        var Country = component.find("myCountry");
        isValid = isValid && Country.reportValidity();
        if (isValid) {
            component.set('v.isloading', true);
			helper.saveAndCharge(component, event, helper);
        } else {
            alert('Please update the invalid entries and try again.');
        }
	},
    
    checkCaseRecord : function(component, event, helper){
        var caseMR = component.get('v.caseMR');
        console.log('caseMR Updated: ', caseMR);
	},
    
    checkValidity : function(component, event, helper) {
        var validity = event.getSource().get("v.validity");
        console.log(validity)
    }
})