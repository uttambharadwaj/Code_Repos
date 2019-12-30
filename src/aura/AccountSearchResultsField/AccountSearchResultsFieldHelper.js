({
    cloneOTRAccountIfNeeded: function (component) {
        console.log('*** Entering helper.cloneOTRAccountIfNeeded');

        var accountNumber = component.get("v.accountNumber");
        var accountRowID = component.get("v.accountRowID");
        if (accountNumber === 'null') {accountNumber = '';}

        console.log('*** accountNumber: ' + accountNumber);
        console.log('*** accountRowId: ' + accountRowID);

        var action = component.get("c.cloneOTRAccountIfNeeded");

        action.setParams({
            accountNumber : accountNumber,
            accountRecordId : accountRowID
        });

        action.setCallback(this, function (response) {
            component.set("v.spinner", false);

            var state = response.getState();

            if (component.isValid() && state === "SUCCESS") {
                component.set("v.accountRowID", response.getReturnValue());
            } else {
                this.handleErrors(component, response);
            }

            console.log('*** callback response: ' + state);
            console.log('*** v.accountRowId: ' + component.get("v.accountRowID"));

            this.openCustomerDetailsTab(component);

        });

        $A.enqueueAction(action);
        component.set("v.spinner", true);
    },

    openCustomerDetailsTab: function(component) {
        var workspaceAPI = component.find("workspace");

        workspaceAPI.openTab({
            pageReference: {
                "type": "standard__component",
                "attributes": {
                    "componentName": "c__CustomerDetails"
                },
                "state": {
                    "c__accountNumber": component.get("v.accountNumber"),
                    "c__accountRowID": component.get("v.accountRowID"),
                    "c__contactRowId": component.get("v.contactRowId"),
                    "c__pdRowId": component.get("v.pdRowId"),
                    "c__caseId": component.get("v.caseId")
                }
            },
            focus: true
        }).catch(function(error) {
            console.log(error);
        });
    },

    handleErrors: function(component, response) {
        var errorMessage = "Unknown Fault";

        var errors = response.getError();

        if (errors && Array.isArray(errors) && errors.length > 0) {
            errorMessage = errors[0].message;
        }

        var toastEvent = $A.get("e.force:showToast");

        toastEvent.setParams({ "mode": "sticky", "type": "error", "title": "Error", "message": errorMessage });

        toastEvent.fire();
    }
})