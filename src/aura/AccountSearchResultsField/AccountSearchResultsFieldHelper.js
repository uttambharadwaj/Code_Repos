({
    //This method is deprecated - MHB 4/17/2020 OTR Data Project
    cloneOTRAccountIfNeeded: function (component) {
        var accountNumber = component.get("v.accountNumber");
        var accountRowId = component.get("v.accountRowId");
        if (accountNumber === 'null') {accountNumber = '';}

        var action = component.get("c.cloneOTRAccountIfNeeded");

        action.setParams({
            accountNumber : accountNumber,
            accountRecordId : accountRowId
        });

        var parent = component.get("v.parent");
        if (parent) {
            parent.showSpinner(true);
        }

        action.setCallback(this, function (response) {
            var state = response.getState();

            var parent = component.get("v.parent");
            if (parent) {
                parent.showSpinner(false);
            }

            if (component.isValid() && state === "SUCCESS") {
                component.set("v.accountRowId", response.getReturnValue());
            } else {
                this.handleErrors(component, response);
            }

            this.openCustomerDetailsTab(component);

        });

        $A.enqueueAction(action);
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
                    "c__accountRowId": component.get("v.accountRowId"),
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