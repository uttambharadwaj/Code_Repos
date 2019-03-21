({
    checkForAlert: function(component) {
        var action = component.get("c.checkForAlertServ");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {
                var serviceAlert = response.getReturnValue();
                if (serviceAlert && serviceAlert.Id) {
                    //var alreadyDisplayed = window.sessionStorage.getItem("alertId");
                    //if (alreadyDisplayed !== serviceAlert.Id) {
                    if (document.cookie.indexOf(serviceAlert.Id + "_alert") === -1) { //IE 11 support
                        //window.sessionStorage.setItem("alertId", serviceAlert.Id);
                        document.cookie = "alertId=" + serviceAlert.Id + "_alert;path=/";
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            mode: "sticky",
                            type: ((serviceAlert.Color__c === "ban") ? "error" : ((serviceAlert.Color__c === "warning") ? "warning" : ((serviceAlert.Color__c === "offline") ? "info" : "error"))),
                            message: serviceAlert.Subject__c,
                            messageTemplate: serviceAlert.Subject__c + " {0}",
                            messageTemplateData: [{
                                label: "More Information",
                                url: "More Information",
                                executionComponent: {
                                    descriptor: "markup://force:navigateToSObject",
                                    attributes: { recordId: serviceAlert.Id },
                                    isEvent: true,
                                    isClientSideCreatable: true,
                                    componentName: "navigateToSObject"
                                }
                            }]
                        });
                        toastEvent.fire();
                    }
                }
            } else if (state === "ERROR") {
                console.error(response.getError());
            }
        });

        $A.enqueueAction(action);
    },
})