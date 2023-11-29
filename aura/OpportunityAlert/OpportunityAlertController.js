({
    getOpps: function(component,event,helper){
		var action = component.get("c.getOpportunities");
        action.setParams({
            daysSinceLastModified: component.get("v.daysSinceLastModified"),
            oppStage: component.get("v.oppStage"),
            hasTasks: component.get("v.hasTasks")
        });
        action.setCallback(this, function(response){
            console.debug(response);
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.opportunities", response.getReturnValue());
            } else {
                console.debug(response.error[0].message);
            }
        });
	 $A.enqueueAction(action);
    },

    gotoRecord : function(component,event,helper) {
        var id;
        var element = event.srcElement;
        while(element.parentNode) {
            if(element.id != "") {
                id = element.id;
                break;
            }
            element = element.parentNode;
        }
        if(id == null) { return; }
        var sObjectEvent = $A.get("e.force:navigateToSObject");
        sObjectEvent.setParams({
            "recordId": id,
            "slideDevName": 'detail'
        });
        sObjectEvent.fire();
    }
})