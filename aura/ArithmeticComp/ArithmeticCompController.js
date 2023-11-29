({
	add : function(component, event, helper) {
        var n1 = component.get("v.num1");
        var n2 = component.get("v.num2");
        var r = n1+n2;
        component.set("v.result", r);
	},
    sub : function(component, event, helper) {
        var n1 = component.get("v.num1");
        var n2 = component.get("v.num2");
        var r = n1-n2;
        component.set("v.subresult", r);
	}
})