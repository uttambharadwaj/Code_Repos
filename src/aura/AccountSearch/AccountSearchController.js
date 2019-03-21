({
    doInit: function (component, event, helper) {
        component.set("v.fields", []);
        component.set("v.results", []);

        helper.setTabLabel(component);
        helper.getSearchTypes(component);
    },

    checkKey: function (component, event, helper) {
        var key = event.keyCode || event.which || event.charCode;
        if (key == 13) {
            helper.validateForm(component);
        }
    },

    search: function (component, event, helper) {
        helper.validateForm(component);
    },

    openNewTab: function (component, event, helper) {
        helper.openNewTab(component);
    },

    checkUpper: function (component, event, helper) {
        var searchType = component.find("searchType").get("v.value");
        var upperTypes = component.get("v.upperTypes");
        if (upperTypes && upperTypes.indexOf(searchType) > -1) {
            var keyword = component.get("v.keyword");
            if (keyword) {
                component.set("v.keyword", keyword.toUpperCase());
            }
        }
    },
})