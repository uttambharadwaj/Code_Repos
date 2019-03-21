({
    doInit: function(component, event, helper) {
        var recordId = component.get("v.recordId");
        helper.getQuickLinks(component, recordId);
    },

    openLink: function(component, event, helper) {
        var workspaceAPI = component.find("workspace");
        if (event && event.target) {
            var url = event.target.dataset.url;
            var urlEvent = $A.get("e.force:navigateToURL");
            urlEvent.setParams({
                "url": url
            });
            urlEvent.fire();
        }
    },

    toggleExpand: function(component, event, helper) {
        var expandSection = component.get("v.expandSection");
        component.set("v.expandSection", !expandSection);
    },
})