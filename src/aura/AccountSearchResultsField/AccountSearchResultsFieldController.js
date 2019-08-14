({
    doInit: function(component, event, helper) {
        var result = component.get('v.result');
        var fieldName = component.get('v.fieldName');
        if (fieldName === "Action") {
            var params = result[fieldName].split('|');
            component.set("v.accountNumber", params[0]);
            component.set("v.accountRowID", encodeURIComponent(params[1]));
            component.set("v.contactRowId", encodeURIComponent(params[2]));
            component.set("v.pdRowId", encodeURIComponent(params[3]));
        } else {
            var outputText = component.find("outputTextId");
            outputText.set("v.value", result[fieldName]);
        }
    },

    openTab: function(component, event, helper) {
        var workspaceAPI = component.find("workspace");
        workspaceAPI.openTab({
            pageReference: {
                "type": "standard__component",
                "attributes": {
                    "componentName": "c__CustomerDetails"
                },
                "state": {
                    "accountNumber": component.get("v.accountNumber"),
                    "accountRowID": component.get("v.accountRowID"),
                    "contactRowId": component.get("v.contactRowId"),
                    "pdRowId": component.get("v.pdRowId"),
                    "caseId": component.get("v.caseId")
                }
            },
            focus: true
        }).catch(function(error) {
            console.log(error);
        });
    },
})