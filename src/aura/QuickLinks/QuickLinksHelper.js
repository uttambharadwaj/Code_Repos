({
    getQuickLinks: function(component, recordId) {
        var action = component.get("c.getQuickLinksServ");
        action.setParams({
            "recordId": recordId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {
                var links = response.getReturnValue();
                component.set("v.quickLinks", links);
            } else if (state === "ERROR") {
                console.error(response.getError());
            }
        });
        $A.enqueueAction(action);
    },
})