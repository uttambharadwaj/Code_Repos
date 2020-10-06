({
    checkCaseStatus: function(component, recordId) {
        var action = component.get("c.checkCaseStatusServ");
        action.setParams({
            "recordId": recordId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {
                var success = response.getReturnValue();
                if (success === true) {
                    $A.get('e.force:refreshView').fire();
                }
            } else if (state === "ERROR") {}
        });
        $A.enqueueAction(action);
    },
})