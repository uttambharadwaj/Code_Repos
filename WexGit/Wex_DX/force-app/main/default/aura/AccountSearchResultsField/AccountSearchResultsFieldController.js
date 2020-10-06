({
    doInit: function(component, event, helper) {
        var result = component.get('v.result');
        var fieldName = component.get('v.fieldName');
        if (fieldName === "Action") {
            var params = result[fieldName].split('|');
            component.set("v.accountNumber", params[0]);
            component.set("v.accountRowId", encodeURIComponent(params[1]));
            component.set("v.contactRowId", encodeURIComponent(params[2]));
            component.set("v.pdRowId", encodeURIComponent(params[3]));
            component.set("v.isOtrSearch",encodeURIComponent(params[4]));
        } else {
            var outputText = component.find("outputTextId");
            outputText.set("v.value", result[fieldName]);
        }

    },

    openTab: function(component, event, helper) {
        //open CustomerDetails tab
        helper.openCustomerDetailsTab(component);

    },
})