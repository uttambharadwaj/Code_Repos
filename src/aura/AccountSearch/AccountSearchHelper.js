({
    getSearchTypes: function (component) {
        var action = component.get("c.getSearchTypesServ");
        action.setCallback(this, function (response) {
            component.set("v.spinner", false);
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {
                var searchTypes = response.getReturnValue();
                var searchTypeField = component.find("searchType");
                var upperTypes = [];
                var opts = [];
                opts.push({ "label": "", "value": "" });
                searchTypes.forEach(function (item) {
                    opts.push({ "label": item.Selection_Label__c, "value": item.DeveloperName });
                    if (item.Search_Case__c === "Upper") {
                        upperTypes.push(item.DeveloperName);
                    }
                });
                searchTypeField.set("v.options", opts);
                component.set("v.upperTypes", upperTypes);
            } else {
                handleErrors(component, response.getError());
            }
        });
        $A.enqueueAction(action);
        component.set("v.spinner", true);
    },

    validateForm: function (component) {
        component.set("v.fields", []);
        component.set("v.results", []);
        component.set("v.errorMessage", "");

        var canSubmit = true;

        var searchTypeField = component.find("searchType");
        var searchType = searchTypeField.get("v.value");
        if (!searchType) {
            searchTypeField.set("v.errors", [{ message: "Please select a Search Type." }]);
            canSubmit = false;
        } else {
            searchTypeField.set("v.errors", null);
        }

        var searchKeywordField = component.find("searchKeyword");
        var searchKeyword = searchKeywordField.get("v.value");
        if (searchKeywordField.elements) { // IE11 bug when pressed Enter key
            searchKeyword = searchKeywordField.elements[0].value;
        }
        if (!searchKeyword) {
            searchKeywordField.set("v.errors", [{ message: "Please enter a Search Keyword." }]);
            canSubmit = false;
        } else {
            var numRegex = /^\d+$/;
            var phoneRegex = /^[\d()-\s\+]+$/;
            if ((searchType === "CUSTOMERACCTNBR" || searchType === "INTERNALACCTNBR") &
                !numRegex.test(searchKeyword)) {
                searchKeywordField.set("v.errors", [{ message: "Please enter a valid input." }]);
                canSubmit = false;
            } else if ((searchType === "MAINPHONE" || searchType === "PRIMARYCONTACTPHONE") &
                !phoneRegex.test(searchKeyword)) {
                searchKeywordField.set("v.errors", [{ message: "Please enter a valid input." }]);
                canSubmit = false;
            } else {
                searchKeywordField.set("v.errors", null);
            }
        }

        if (canSubmit) {
            searchKeyword = searchKeyword.trim();
            this.search(component, searchType, searchKeyword);
        }
    },

    search: function (component, searchType, searchKeyword) {
        var action = component.get("c.searchServ");
        action.setParams({
            "searchType": searchType,
            "searchKeyword": searchKeyword
        });

        action.setCallback(this, function (response) {
            component.set("v.spinner", false);
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {
                var searchResults = response.getReturnValue();
                component.set("v.fields", searchResults.fields);
                component.set("v.results", searchResults.results);
                component.set("v.errorMessage", searchResults.errorMessage);
            } else {
                handleErrors(component, response.getError());
            }
        });
        $A.enqueueAction(action);
        component.set("v.spinner", true);
    },

    setTabLabel: function (component) {
        var workspaceAPI = component.find("workspace");
        workspaceAPI.getEnclosingTabId().then(function (tabId) {
            console.log(tabId);
            workspaceAPI.setTabLabel({
                tabId: tabId,
                label: "Account Search"
            });
            workspaceAPI.setTabIcon({
                tabId: tabId,
                icon: "standard:account"
            });
        })
            .catch(function (error) {
                console.log(error);
            });
    },

    openNewTab: function (component) {
        var workspaceAPI = component.find("workspace");
        workspaceAPI.openTab({
            pageReference: {
                "type": "standard__component",
                "attributes": {
                    "componentName": "c__AccountSearch"
                }
            },
            focus: true
        }).catch(function (error) {
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