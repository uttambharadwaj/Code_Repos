({

    doInit : function(component, event, helper) {

        var workspaceAPI = component.find("workspace");

        component.set("v.declinedTransactionsColumnList", [
            {label: "Merchant Site Number", fieldName: "merchantSite", type: "text", sortable: true},
            {label: "Date/Time", fieldName: "txnDt", type: "date",typeAttributes: {year: "numeric", month: "short", day: "2-digit", hour: "2-digit", minute: "2-digit", second: "2-digit", hour12: "false"}, sortable: true},
            {label: "Card Number", fieldName: "cardNumber", type: "text", sortable: true},
            {label: "Driver ID", fieldName: "driverId", type: "text", sortable: true},
            {label: "Action Code", fieldName: "actionCode", type: "text", sortable: true},
            {label: "ISO Description", fieldName: "isoActionCodeDescription", type: "text"},
            {label: "WEX Description", fieldName: "wexActionCodeDescription", type: "text"}
        ]);

        component.set("v.frontPageExistingCasesColumnList", [
            {label: "Case Number", fieldName: "CaseNumber", type: "text"},
            {label: "Subject", fieldName: "Subject", type: "text"},
            {label: "Contact", fieldName: "Contact.Name", type: "text"},
            {label: "Status", fieldName: "Status", type: "text"},
            {label: "Case Type", fieldName: "RecordType.Name", type: "text"},
            {label: "Last Modified", fieldName: "LastModifiedDate", type: "date",typeAttributes: {year: "numeric", month: "short", day: "2-digit", hour: "2-digit", minute: "2-digit", second: "2-digit", hour12: "false"}},
            {label: "Owner", fieldName: "Owner.Name", type: "text"}
        ]);

        component.set("v.caseHistoryColumnList", [
            {label: "Create Date", fieldName: "CreatedDate", type: "date",typeAttributes: {year: "numeric", month: "short", day: "2-digit", hour: "2-digit", minute: "2-digit", second: "2-digit", hour12: "false"}, sortable: true},
            {label: "Last Modified", fieldName: "LastModifiedDate", type: "date",typeAttributes: {year: "numeric", month: "short", day: "2-digit", hour: "2-digit", minute: "2-digit", second: "2-digit", hour12: "false"}, sortable: true},
            {label: "Case Number", fieldName: "Anchor", type: "url", typeAttributes: {label:{fieldName: "CaseNumber"}, target:"_self"}, sortable: true},
            {label: "Status", fieldName: "Status", type: "text", sortable: true},
            {label: "Origin", fieldName: "Origin", type: "text", sortable: true},
            {label: "Contact", fieldName: "Contact_Name", type: "text", sortable: true},
            {label: "Subject", fieldName: "Subject", type: "text", sortable: true},
            {label: "Owner", fieldName: "Owner_Name", type: "text", sortable: true},
            {label: "Dept.", fieldName: "Department__c", type: "text", sortable: true}
        ]);

        component.set("v.paymentDetailsColumnList", [
            {label: "Deposit ID", fieldName: "depositId", type: "text", sortable: false, initialWidth: 150 },
            {label: "Payment ID", fieldName: "paymentId", type: "text", sortable: false, initialWidth: 150 },
            {label: "Accounting Date", fieldName: "accountingDt", type: "date-local",typeAttributes: {year: "numeric", month: "short", day: "2-digit"}, sortable: false, initialWidth: 160},
            {label: "Posting Date", fieldName: "postingDt", type: "date-local",typeAttributes: {year: "numeric", month: "short", day: "2-digit"}, sortable: false, initialWidth: 150},
            {label: "Payment Amt", fieldName: "paymentAmt", type: 'currency', typeAttributes: { currencyCode: 'USD'}, sortable: false, initialWidth: 130, cellAttributes: { alignment: 'right' }},
            {label: "Currency", fieldName: "currencyCd", type: "text", sortable: false, initialWidth: 120, cellAttributes: { alignment: 'center' }}
        ]);

        component.set("v.otrInvoiceColumnList", [
            {label: "Invoice Number", fieldName: "invoiceNumber", type: "text", sortable: true, initialWidth: 180 },
            {label: "Invoice Date", fieldName: "invoiceDate", type: "date-local", sortable: true, initialWidth: 180 },
            {label: "Due Date", fieldName: "dueDate", type: "date-local", sortable: false, initialWidth: 190},
            {label: "Amount", fieldName: "amount", type: 'currency', typeAttributes: { currencyCode: 'USD'}, sortable: true, initialWidth: 160, cellAttributes: { alignment: 'right' }},
            {label: "View Invoice", fieldName: "viewInvoice", type: "text", sortable: true, initialWidth: 150, cellAttributes: { alignment: 'center' }}
        ]);

        component.set("v.paymentHistoryColumnList", [
            {label: "Cycle End", fieldName: "cycleEndDt", type: "date-local",typeAttributes: {year: "numeric", month: "short", day: "2-digit"}, sortable: false, initialWidth: 130},
            {label: "Due Date",  fieldName: "dueDt", type: "date-local",typeAttributes: {year: "numeric", month: "short", day: "2-digit"}, sortable: false, initialWidth: 100},
            {label: "Class", fieldName: "cls", type: "text", sortable: false, initialWidth: 80, cellAttributes: { alignment: 'center' }},
            {label: "Sales", fieldName: "salesAmt", type: 'currency', typeAttributes: { currencyCode: 'USD'}, sortable: false, initialWidth: 90, cellAttributes: { alignment: 'right' }},
            {label: "Late Fee", fieldName: "lateFeeAmt", type: 'currency', typeAttributes: { currencyCode: 'USD'}, sortable: false, initialWidth: 100, cellAttributes: { alignment: 'right' }},
            {label: "Payments", fieldName: "paymentAmt", type: 'currency', typeAttributes: { currencyCode: 'USD'}, sortable: false, initialWidth: 120, cellAttributes: { alignment: 'right' }},
            {label: "Adjustments", fieldName: "adjustmentAmt", type: 'currency', typeAttributes: { currencyCode: 'USD'}, sortable: false, initialWidth: 130, cellAttributes: { alignment: 'right' }},
            {label: "EPI Basis Amt", fieldName: "epiBasisAmt", type: 'currency', typeAttributes: { currencyCode: 'USD'}, sortable: false, initialWidth: 130, cellAttributes: { alignment: 'right' }},
            {label: "Balance", fieldName: "balanceAmt", type: 'currency', typeAttributes: { currencyCode: 'USD'}, sortable: false, initialWidth: 120, cellAttributes: { alignment: 'right' }},
            {label: "OCL", fieldName: "ocl", type: "text", sortable: false, initialWidth: 80, cellAttributes: { alignment: 'center' }}
        ]);

        component.set("v.pendingPaymentsColumnList", [
            {label: "Status", fieldName: "status", type: "text", sortable: false, initialWidth: 120 },
            {label: "Source", fieldName: "source", type: "text", sortable: false, initialWidth: 100 },
            {label: "Payment ID", fieldName: "payId", type: "text", sortable: false, initialWidth: 150 },
            {label: "Scheduled Date", fieldName: "scheduledDate", type: "date-local",typeAttributes: {year: "numeric", month: "short", day: "2-digit"}, sortable: false, initialWidth: 160},
            {label: "Posting Date", fieldName: "postingDate", type: "date-local",typeAttributes: {year: "numeric", month: "short", day: "2-digit"}, sortable: false, initialWidth: 150},
            {label: "Payment Amt", fieldName: "amount", type: 'currency', typeAttributes: { currencyCode: 'USD'}, sortable: false, initialWidth: 130, cellAttributes: { alignment: 'right' }},
            {label: "Updated Date", fieldName: "updateDate", type: "date-local",typeAttributes: {year: "numeric", month: "short", day: "2-digit"}, sortable: false, initialWidth: 150},
            {label: "Status of Hold", fieldName: "holdStatus", type: "text", sortable: false, initialWidth: 120 },
            {label: "Currency Label", fieldName: "currency_x", type: "text", sortable: false, initialWidth: 120 },
        ]);

        component.set("v.past3InvoicesColumnList", [
            {label: "Invoice Date", fieldName: "closingDt", type: "text", sortable: false},
            {label: "View Invoice", fieldName: "invoiceUrl", type: "url",typeAttributes: {label: "View Invoice", target: { fieldName: 'invoiceUrl' }}, sortable: false}
        ]);

        workspaceAPI.getEnclosingTabId().then(function(tabId) {
            workspaceAPI.getTabInfo({
                tabId: tabId
            }).then(function(response) {

                if(response.isSubtab) {
                    // Removes the header since it will be a static display anyways
                    component.set("v.appMode", "subtab");
                }

                // Grab the account number off the enclosing tab URL

                // Gears additions commented out until we find out what else is missing - MHB 28 Jun 2018
                var pageRef = component.get("v.pageReference");
                var accountNumber = (pageRef && pageRef.state) ? pageRef.state.c__accountNumber : null;
                var accountRowId = (pageRef && pageRef.state) ? pageRef.state.c__accountRowId : null;
                var isOtrAccount = (pageRef && pageRef.state) ? pageRef.state.c__isOtrSearch : false;
                console.log("isOtrAccount="+isOtrAccount);
                console.log("accountRowId="+accountRowId);
                console.log("accountNumber="+accountNumber);
                console.log("tabId="+tabId);
                console.log("recordId="+component.get("v.recordId"));


                //var accountNumber = helper.getParameterByName(component, event, 'c__accountNumber', response.url);
                //var accountRowId = helper.getParameterByName(component, event, 'c__accountRowId', response.url);

                //throw error and return if not enough data to continue
                if(accountNumber === 'null' && accountRowId === 'null' && component.get("v.recordId") === 'null') {

                    var toastEvent = $A.get("e.force:showToast");

                    toastEvent.setParams({ "type": "error", "title": "Error", "message": "Account number or Account record ID missing!" });

                    toastEvent.fire();

                    return;

                }

                component.set("v.accountNumber", accountNumber);
                component.set("v.accountRowId", accountRowId);
                if (helper.isSalesforceId(accountRowId)== true) {
                    component.set("v.acctRecordId", accountRowId);
                }

                component.set("v.isOtrAccount", isOtrAccount);

                // Grab the case ID off the enclosing tab URL
                var caseId = (pageRef && pageRef.state) ? pageRef.state.c__caseId : null;
                // var caseId = helper.getParameterByName(component, event, 'caseId', response.url);
                component.set("v.caseId", caseId);

                // Grab the contactRowID off the enclosing tab URL
                var contactRowId = (pageRef && pageRef.state) ? pageRef.state.c__contactRowId : null;
                // var contactRowId = helper.getParameterByName(component, event, 'contactRowId', response.url);
                component.set("v.contactRowId", contactRowId);

                // Grab the pdRowId off the enclosing tab URL
                var pdRowid = (pageRef && pageRef.state) ? pageRef.state.c__pdRowId : null;
                component.set("v.pdRowId", pdRowid);

                // Display the spinner
                var spinner = component.find("loadingSpinner");
                $A.util.removeClass(spinner, "slds-hide");

                // Grab the customer details
                helper.loadCustomerDetails(component);

                //Get the open cases
                console.log("### Fetching existing cases");
                helper.fetchExistingOpenCases(component);

                // Grab the number of cases today
                helper.fetchNumberOfCasesToday(component);

                //component.set("v.selectedTabId","customerContactsTab");

            });
        })

    },

    refreshCustomerDetails : function(component, event, helper) {

        $A.util.addClass(event.target, 'fa-spin fa-1x fa-fw');

        helper.loadCustomerDetails(component, event.target);
        helper.fetchNumberOfCasesToday(component);
        helper.fetchExistingOpenCases(component);
    },

    lazyLoadCustomerContacts : function(component, event, helper) {

        if(component.get("v.customerContacts") == null) {
            var spinner = component.find("customerContactsLoadingSpinner");
            $A.util.removeClass(spinner, "slds-hide");

            helper.loadCustomerContacts(component, null);
        }

    },

    refreshCustomerContacts : function(component, event, helper) {

        $A.util.addClass(event.target, 'fa-spin fa-1x fa-fw');

        helper.loadCustomerContacts(component, event.target);

    },

    lazyLoadCustomerPaymentHistory : function(component, event, helper) {

        if(component.get("v.customerPaymentHistory") == null) {

            var spinner = component.find("customerPaymentHistoryLoadingSpinner");
            $A.util.removeClass(spinner, "slds-hide");

            helper.loadCustomerPaymentHistory(component, null);

        }

    },

    refreshCustomerPaymentHistory : function(component, event, helper) {

        $A.util.addClass(event.target, 'fa-spin fa-1x fa-fw');

        helper.loadCustomerDetails(component, null);

        helper.loadCustomerPaymentHistory(component, event.target);

    },

    closeCaseModal : function(component, event, helper){
        var target = component.find('caseModalBox');
        var page = component.find('modalBackdrop');
        $A.util.removeClass(page,'slds-backdrop--open');
        $A.util.removeClass(target, 'slds-fade-in-open');
    },

    openCaseModal : function(component, event, helper) {

        var focusedContactRowId =  event.currentTarget.getAttribute("data-contactRowId");

        var contactRowId = component.get("v.contactRowId");

        if(contactRowId != focusedContactRowId) {
            component.set("v.contactRowId", focusedContactRowId);
        }

        helper.fetchExistingCases(component);

    },

    popToCase : function(component, event, helper) {

        var focusedContactRowId =  event.currentTarget.getAttribute("data-contactRowId");

        var focusedIsDummyContact =  event.currentTarget.getAttribute("data-isDummyContact");

        var contactRowId = component.get("v.contactRowId");

        var isDummyContact = component.get("v.isDummyContact");

        if(contactRowId != focusedContactRowId) {
            component.set("v.contactRowId", focusedContactRowId);
        }

        if(isDummyContact != focusedIsDummyContact) {
            component.set("v.isDummyContact", focusedIsDummyContact);
        }

        helper.popToCase(component, event.this);

    },

    popToExistingCase : function(component, event, helper) {

        var focusedCaseId =  event.currentTarget.getAttribute("data-caseId");

        var caseId = component.get("v.caseId");

        if(caseId != focusedCaseId) {
            component.set("v.caseId", focusedCaseId);
        }

        helper.popToCase(component, event.this);

    },

    popToFrontPageCase : function(component, event, helper) {
        //console.log('###: Component popToFrontPageCase'+event.currentTarget.getAttribute("data-caseId"));

        var focusedCaseId =  event.currentTarget.getAttribute("data-caseId");

        var caseId = component.get("v.caseId");

        if(caseId != focusedCaseId) {
            component.set("v.caseId", focusedCaseId);
        }

        helper.popToFrontPageCase(component, event.this);

    },

    filterContacts : function(component, event, helper) {

        helper.filterContacts(component); 

    },

    resetContactsFilter : function(component, event, helper) {

        component.find("contactTableFilter").set("v.errors", "");

        component.find("contactTableFilter").set("v.value", "");

        component.set("v.filteredCustomerContacts", component.get("v.customerContacts"));

    },

    filterCases : function(component, event, helper) {

        helper.filterCases(component);

    },

    resetCasesFilter : function(component, event, helper) {

        component.find("caseTableFilter").set("v.errors", "");

        component.find("caseTableFilter").set("v.value", "");

        component.set("v.filteredExistingCases", component.get("v.existingCases"));

    },

    lazyLoadDeclinedTransactions : function(component, event, helper) {
        if(component.get("v.declinedTransactions") == null) {
            var spinner = component.find("declinedTransactionsLoadingSpinner");
            $A.util.removeClass(spinner, "slds-hide");
            helper.loadDeclinedTransactions(component, null);
        }
    },

    lazyLoadInvoices : function(component, event, helper) {
        if(component.get("v.invoices") == null) {
            var spinner = component.find("invoicesLoadingSpinner");
            $A.util.removeClass(spinner, "slds-hide");
            helper.loadInvoices(component, null);
        }
    },

    refreshInvoices : function(component, event, helper) {
        $A.util.addClass(event.target, 'fa-spin fa-1x fa-fw');
        helper.loadInvoices(component, event.target);
        //console.log("### refreshedInvoices");
        //console.log(component.get("v.invoices"));
    },

    refreshDeclinedTransactions : function(component, event, helper) {

        $A.util.addClass(event.target, 'fa-spin fa-1x fa-fw');

        helper.loadDeclinedTransactions(component, event.target);

    },

    lazyLoadCases : function(component, event, helper) {
        var spinner = component.find("casesLoadingSpinner");
        $A.util.removeClass(spinner, "slds-hide");
        //console.log("LazyLoadCases: event source= "+event.getSource());
        helper.fetchCaseHistory(component, component.find("casesTab"));
    },

    refreshCases : function(component, event, helper) {
        $A.util.addClass(event.target, 'fa-spin fa-1x fa-fw');
        helper.fetchCaseHistory(component, event.target);
    },

    // Client-side controller called by the DeclinedTransactions onsort event handler
    handleTxnSort: function (component, event, helper) {
        var fieldName = event.getParam('fieldName');
        var sortDirection = event.getParam('sortDirection');
        // assign the latest attribute with the sorted column fieldName and sorted direction
        component.find("declinedTransactionsTable").set("v.sortedBy", fieldName);
        component.find("declinedTransactionsTable").set("v.sortedDirection", sortDirection);
        helper.sortTxnData(component, fieldName, sortDirection);

    },

    // Client-side controller called by the Case History onsort event handler
    handleCaseSort: function (component, event, helper) {
        var fieldName = event.getParam('fieldName');
        var sortDirection = event.getParam('sortDirection');
        // assign the latest attribute with the sorted column fieldName and sorted direction
        component.find("casesTable").set("v.sortedBy", fieldName);
        component.find("casesTable").set("v.sortedDirection", sortDirection);
        helper.sortCaseData(component, fieldName, sortDirection);

    },

    filterTransactions : function(component, event, helper) {
        var inputCmp = component.find("transactionTableFilter");
        var allValid = inputCmp.get("v.validity").valid;
        //console.log("### Filter validity="+allValid);
        inputCmp.showHelpMessageIfInvalid();
        if (allValid) {
            helper.filterTransactions(component);
        }
    },

    resetTransactionsFilter : function(component, event, helper) {

        component.find("transactionTableFilter").set("v.value", "");

        component.set("v.filteredDeclinedTransactions", component.get("v.declinedTransactions"));

        component.set("v.dataTableTransactions", helper.createDataTableTransactions(component.get("v.declinedTransactions")));

        component.set("v.filteredDataTableTransactions", helper.createDataTableTransactions(component.get("v.declinedTransactions")));

    },

    lazyLoadPayments : function(component, event, helper) {
        if(component.get("v.paymentsBulk") == null) {
            var spinner = component.find("paymentsLoadingSpinner");
            $A.util.removeClass(spinner, "slds-hide");
            helper.loadPayments(component, null);
        }
    },

    refreshPayments : function(component, event, helper) {

        $A.util.addClass(event.target, 'fa-spin fa-1x fa-fw');

        helper.loadPayments(component, event.target);

    },

    // Client-side controller called by the Payment Details onsort event handler
    handlePaymentDetailsSort: function (component, event, helper) {
        var fieldName = event.getParam('fieldName');
        var sortDirection = event.getParam('sortDirection');
        // assign the latest attribute with the sorted column fieldName and sorted direction
        component.find("paymentDetailsTable").set("v.sortedBy", fieldName);
        component.find("paymentDetailsTable").set("v.sortedDirection", sortDirection);
        helper.sortTxnData(component, fieldName, sortDirection);

    },

    handleOTRInvoiceSort: function (component, event, helper) {
        var fieldName = event.getParam('fieldName');
        var sortDirection = event.getParam('sortDirection');
        // assign the latest attribute with the sorted column fieldName and sorted direction
        component.find("otrInvoicesTable").set("v.sortedBy", fieldName);
        component.find("otrInvoicesTable").set("v.sortedDirection", sortDirection);
        helper.sortTxnData(component, fieldName, sortDirection);

    },

    // Client-side controller called by the Payment History onsort event handler
    handlePaymentHistorySort: function (component, event, helper) {
        var fieldName = event.getParam('fieldName');
        var sortDirection = event.getParam('sortDirection');
        // assign the latest attribute with the sorted column fieldName and sorted direction
        component.find("paymentHistoryTable").set("v.sortedBy", fieldName);
        component.find("paymentHistoryTable").set("v.sortedDirection", sortDirection);
        helper.sortTxnData(component, fieldName, sortDirection);

    },

    // Client-side controller called by the Payment History onsort event handler
    handlePendingPaymentsSort: function (component, event, helper) {
        var fieldName = event.getParam('fieldName');
        var sortDirection = event.getParam('sortDirection');
        // assign the latest attribute with the sorted column fieldName and sorted direction
        component.find("pendingPaymentsTable").set("v.sortedBy", fieldName);
        component.find("pendingPaymentsTable").set("v.sortedDirection", sortDirection);
        helper.sortTxnData(component, fieldName, sortDirection);

    },
    toogleSplitView: function (component, event, helper) {
        console.log('toogleSplitView--------->',JSON.stringify(event.target.getAttribute('id')));
        let expandSplitView = false;
        if(event.target.getAttribute('id') == "left"){
            event.target.setAttribute('aria-expanded','false');
            event.target.parentNode.setAttribute('class','slds-split-view_container slds-is-closed');
            event.target.setAttribute('class','slds-button slds-button_icon slds-button_icon slds-split-view__toggle-button slds-is-closed');
            event.target.setAttribute('id','right');
            component.set('v.showOtrCOntractDetails',true);

        } else {
            event.target.setAttribute('aria-expanded','true');
            event.target.parentNode.setAttribute('class','slds-split-view_container slds-is-open');
            event.target.setAttribute('class','slds-button slds-button_icon slds-button_icon slds-split-view__toggle-button slds-is-open');
            event.target.setAttribute('id','left');
            component.set('v.showOtrCOntractDetails',false);
        }
    },


    reloadContract: function(component, event, helper) {
        helper.reloadContract(component, event, helper);
    },

    showContract: function (component, event, helper) {
        console.log('Show Contract--------->',event.target.getAttribute('id'));
        let index = event.target.getAttribute('id');
        let otrContractList = component.get('v.customerDetails.otrContracts.entry');
        component.set('v.showOtrCOntractDetails',true);
        component.set("v.otrContractObj",otrContractList[index].value);
		helper.reloadContract(component, event, helper);
	}
})