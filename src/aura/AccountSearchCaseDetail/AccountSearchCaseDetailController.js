({
    openSearchTab: function(component, event, helper) {
        var recordId = component.get("v.recordId");

        var evt = $A.get("e.force:navigateToComponent");
        evt.setParams({
            componentDef: "c:AccountSearch",
            componentAttributes: {
                caseId: recordId
            }
        });
        evt.fire();
    },
})