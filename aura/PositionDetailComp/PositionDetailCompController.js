({
	getPositions : function(component, event, helper) {
		var action = component.get("c.getAllPositions");
        action.setCallback(this, function(response){
            	var poslist = response.getReturnValue();
            	component.set("v.plist", poslist);
        	}
        	
        );
        $A.enqueueAction(action);
	}
})