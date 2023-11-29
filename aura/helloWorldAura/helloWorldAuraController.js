({
  myAction : function(component, event, helper) {

  },
  onButtonClick : function(component, event, helper) {
    //helper.helperMethod(component, event, helper);
    component.set("v.showModal", true);
    var childCmp = component.find("cComp");
    //childCmp.showCreditCardModal();
    var action = component.get("c.chargeCCApxc");

    action.setCallback(this, function(response) {
      var state = response.getState();
      if (state === "SUCCESS") {
        console.log('return value: ', response.getReturnValue() );
      }
      else if (state === "INCOMPLETE") {
          // do something
     } else if (state === "ERROR") {
          var errors = response.getError();
          if (errors) {
              if (errors[0] && errors[0].message) {
                console.log("CaseProducts: Error message: " +   errors[0].message);
                var toastMessage = 'Charge Error: ' + errors[0].message;
                let errorMessage;
                if(toastMessage.includes('::CUST_ID::')){
                    errorMessage = errors[0].message.split('::CUST_ID::');
                    toastMessage = 'Charge Error From Stripe: '+ errorMessage[0];
                }
                helper.updateAccountWithStripeCustomer(component, event, helper, errorMessage[1]);
              }
          } else {
              console.log("CaseProducts: Unknown error");
          }
      }
    });

    $A.enqueueAction(action);
  },
  closeModal : function(component, event, helper){
    console.log('RK close modal parent');
    component.set("v.showModal", false);
      
  }
})