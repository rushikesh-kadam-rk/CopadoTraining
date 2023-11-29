({
	getjobpoststatus : function(component,event) {
        var recId = component.get("v.recordId");
        console.log('RK---->'+recId)
        var action = component.get("c.getRedirectToProspectURL");
        action.setParams({
            'accId': recId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            //var URLLink = response.getReturnValue();
            var URLLINK = 'https://www.google.com';
            if (state === "SUCCESS") {
                console.log('RK in SUCCESS---->'+recId)
              	window.open(URLLINK, '_self'); 
            }
        });
        $A.enqueueAction(action);
              
    }
    
})