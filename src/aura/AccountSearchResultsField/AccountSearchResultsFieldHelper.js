({
    helloWorld: function (component) {
        var action = component.get("c.helloWorld");
        action.setCallback(this, function (response) {
            component.set("v.spinner", false);
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {

            } else if (state === "ERROR") {
                //this.handleErrors(component, response.getError());
            }
        });
        $A.enqueueAction(action);
        component.set("v.spinner", true);
    }
})