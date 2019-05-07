/**
 * Created by W083158 on 5/3/2019.
 */
({ loadPriorRefunds : function(component, target) {

        var action = component.get("c.getPriorRefundAdjustments");

        var accountId = component.get("v.accountId");
        console.log('### accountId = ' + accountId);
            action.setParams({
                accountId : component.get("v.accountId")
            });

        action.setCallback(this, function(response) {
            var state = response.getState();

            if (component.isValid() && state === "SUCCESS") {
                component.set("v.refundsAdjustmentsData", response.getReturnValue());

                var spinner = component.find("loadingSpinner");
                $A.util.addClass(spinner, "slds-hide");
            }
        });

        $A.enqueueAction(action);

    }
});