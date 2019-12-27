({
    cloneOTRAccountIfNeeded: function (component) {
        console.log('*** Entering helper.cloneOTRAccountIfNeeded');
        console.log('*** v.accountNumber: ' + component.get("v.accountNumber"));
        console.log('*** v.accountRowId: ' + component.get("v.accountRowID"));

        var action = component.get("c.cloneOTRAccountIfNeeded");

        if (component.get("v.accountNumber") === 'null'){
            action.setParams({
                accountNumber : '',
                accountRecordId : component.get("v.accountRowID")
            });

        } else {
            action.setParams({
                accountNumber : component.get("v.accountNumber"),
                accountRecordId : component.get("v.accountRowID")
            });

        }

        action.setCallback(this, function (response) {
            component.set("v.spinner", false);

            var state = response.getState();

            if (component.isValid() && state === "SUCCESS") {
                //get the accountRowId out of the response
                component.set("v.accountRowID", response.getReturnValue());
            } else if (state === "ERROR") {
                //this.handleErrors(component, response.getError());
            }

            console.log('*** callback response: ' + state);
            console.log('*** v.accountRowId: ' + component.get("v.accountRowID"));

        });

        $A.enqueueAction(action);
        component.set("v.spinner", true);
    }
})