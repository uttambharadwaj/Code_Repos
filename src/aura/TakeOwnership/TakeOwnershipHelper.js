({
	changeOwner: function (component, recordId) {
		var action = component.get("c.changeOwnerServ");
		action.setParams({
			"recordId": recordId
		});
		action.setCallback(this, function (response) {
			component.set("v.spinner", false);
			var state = response.getState();
			if (component.isValid() && state === "SUCCESS") {
				var valid = response.getReturnValue();
				if (valid) {
					$A.get("e.force:refreshView").fire();
				}
			} else if (state === "ERROR") {
				console.error(response.getError());
			}
		});
		$A.enqueueAction(action);
		component.set("v.spinner", true);
	},
})