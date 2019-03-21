({
	doInit: function (component, event, helper) {
		var recordId = component.get("v.recordId");
		helper.openArticles(component, recordId);
	},
})