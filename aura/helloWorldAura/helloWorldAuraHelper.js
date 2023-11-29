({
    helperMethod : function(component, event, helper) {
        helper.fireToast(component, event, helper, 'Oops!  Looks like something went wrong.', 'error','Test Error Message Test Error MessageTest Error Message Test Error MessageTest Error MessageTest Error MessageTest Error Message Test Error Message Test Error Message');
    },
    fireToast : function(component, event, helper, toastTitle, toastType, toastMessage){
        var resultsToast = $A.get("e.force:showToast");
        resultsToast.setParams({
            "title": toastTitle,
            "message": toastMessage,
            "type": toastType,
            "mode":"sticky"
        });
        resultsToast.fire();
    },
    updateAccountWithStripeCustomer : function(component, event, helper, custId){
        var action = component.get("c.updateAccountWithStripeCustomer");
        action.setParams({
            caseRecordId : '5002w00000loUvYAAU',
            custId : custId
        });
        console.log("Update Account: " + custId);
        action.setCallback(this, function(response) {
        	var state = response.getState();
            if (state === "SUCCESS") {
            } else if(state === "INCOMPLETE") {
            } else if(state === "ERROR"){
            } else {
                console.log("CaseProducts: Unknown error");
            }
        });
        $A.enqueueAction(action);
    }
})