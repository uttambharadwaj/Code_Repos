({
	changeOwner : function(component, event, helper) {
		var recordId = component.get("v.recordId")
		helper.changeOwner(component, recordId);
	},
})