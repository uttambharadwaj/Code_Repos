({
	getLogo: function (component) {
		var action = component.get("c.getLogoServ");
		action.setCallback(this, function (response) {
			var state = response.getState();
			if (component.isValid() && state === "SUCCESS") {
				var logo = response.getReturnValue();
				if (logo) {
					component.set("v.logo", logo);
				}
			} else if (state === "ERROR") {
				cosole.error(response.getError());
			}
		});
		$A.enqueueAction(action);
	}
})