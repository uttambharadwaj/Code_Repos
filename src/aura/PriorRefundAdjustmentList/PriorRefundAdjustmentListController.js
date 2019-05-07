/**
 * Created by W083158 on 5/3/2019.
 */
({
    doInit : function(component, event, helper) {

        component.set("v.refundsAdjustmentsColumnList", [
            {label: "Id", fieldName: "IdLink", type: "url", sortable: false,
                typeAttributes: {
                    label: {fieldName : "Name"}
                }
            },
            {label: "Ref/Adj", fieldName: "DeveloperName", type: "text", sortable: false},
            {label: "Case Number", fieldName: "CaseIdLink", type: "url", sortable: false,
                typeAttributes: {
                    label: {fieldName : "CaseNumber"}
                }
            },
            {
                label: "Amount",
                fieldName: "Amount_Waived",
                type: 'currency',
                typeAttributes: {currencyCode: 'USD'},
                sortable: false,
                cellAttributes: {alignment: 'right'}
            },
            {label: "Approval Status", fieldName: "Approval_Status", type: "text", sortable: false},
            {label: "Approver", fieldName: "Approver_Name", type: "text"},
            {
                label: "Create Date",
                fieldName: "CreatedDate",
                type: "date",
                typeAttributes: {
                    year: "numeric",
                    month: "short",
                    day: "2-digit",
                    hour: "2-digit",
                    minute: "2-digit",
                    second: "2-digit",
                    hour12: "false"
                },
                sortable: false
            },
            {
                label: "Decision Date",
                fieldName: "Decision_Date",
                type: "date",
                typeAttributes: {
                    year: "numeric",
                    month: "short",
                    day: "2-digit",
                    hour: "2-digit",
                    minute: "2-digit",
                    second: "2-digit",
                    hour12: "false"
                },
                sortable: false
            }
        ]);

        var accountId = component.get("v.accountId");


        if (accountId == null) {

            var toastEvent = $A.get("e.force:showToast");

            toastEvent.setParams({"type": "error", "title": "Error", "message": "Account record ID missing!"});

            toastEvent.fire();

        } else {
            // Display the spinner
            var spinner = component.find("loadingSpinner");
            $A.util.removeClass(spinner, "slds-hide");

            // Grab the refund/adjustment details
            helper.loadPriorRefunds(component);
        }
    }
});