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
        //check if otr account, then handle cloning if needed, finally open CustomerDetails tab
        helper.cloneOTRAccountIfNeeded(component);

    },
})