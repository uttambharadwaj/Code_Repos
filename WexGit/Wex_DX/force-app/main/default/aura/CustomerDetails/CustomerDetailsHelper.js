({

    getParameterByName : function(component, event, name, tabURL) {

        name = name.replace(/[\[\]]/g, "\\$&");
        var url;
        if(tabURL != null) {
            url = tabURL;
        }
        else {
            url = window.location.href;
        }

        var regex = new RegExp("[?&]" + name + "(=([^&#]*)|&|#|$)");

        var results = regex.exec(url);

        if (!results) return null;

        if (!results[2]) return '';

        return decodeURIComponent(results[2].replace(/\+/g, " "));

    },
    getIdToUse : function(component,target) {
        console.log("Entering getIdToUse...")
        let isOtrAccount = component.get("v.isOtrAccount");
        let accountRowId = component.get("v.accountRowId");
        let accountNumber = component.get("v.accountNumber");
        let tempRecordId = component.get("v.recordId");
        let acctRecordId = component.get("v.acctRecordId");

        console.log("isOtrAccount = " + isOtrAccount);
        console.log("accountRowId = " + accountRowId);
        console.log("accountNumber = " + accountNumber);
        console.log("tempRecordId = " + tempRecordId);
        console.log("acctRecordId = " + acctRecordId);


        let useSalesforce = false;
        let idToUse = "" ;

        if (isOtrAccount === "false" && typeof accountNumber === "string" && !(Number.isNaN(parseInt(accountNumber)))) {
            useSalesforce = false;
            console.log("Returning useSalesforce = false");
        } else if (typeof accountRowId === "string" && this.isSalesforceId(accountRowId)) {
            useSalesforce = true;
            idToUse = accountRowId;
            console.log("Returning useSalesforce = true & accountRowId");
        } else if (typeof acctRecordId === "string" && this.isSalesforceId(acctRecordId)) {
            useSalesforce = true;
            idToUse = acctRecordId;
            console.log("Returning useSalesforce = true & acctRecordId");
        } else if (typeof tempRecordId === "string" && this.isSalesforceId(tempRecordId)) {
            useSalesforce = true;
            idToUse = tempRecordId;
            console.log("Returning useSalesforce = true & tempRecordId");
        }
        console.log("getIdToUse returns "+useSalesforce + " , "+idToUse);
        return {useSalesforce, idToUse};
    },

    loadCustomerDetails : function(component, target) {
        var action = component.get("c.getCustomerDetails");

        var pdRowId = component.get("v.pdRowId");
        var acctNbr = component.get("v.accountNumber");
        var isOtrAccount = component.get("v.isOtrAccount");


        console.log("loadCustomerDetails acctNbr="+acctNbr);

        // if (searchRecordId === 'null')
        //     searchRecordId = component.get("v.acctRecordId");

        if(pdRowId === undefined || pdRowId == null){
            pdRowId = 'null';
        }

        if(isOtrAccount === undefined){
            isOtrAccount = 'false';
        }

        console.log('isOtrAccount='+isOtrAccount);

        let checkSalesforce = this.getIdToUse(component, target);


        let idToUse = checkSalesforce.idToUse;
        let useSalesforce = checkSalesforce.useSalesforce;

        if (!(pdRowId === 'null')) {  //Right now, always not Salesforce
            console.log('Assuming NA Fleet based on pdRowId being provided');
            action.setParams({
                accountNumber : acctNbr,
                accountRecordId : idToUse,
                pdRowIdString : pdRowId,
                isOtrAccount : false
            });
            //} else if (acctNbr === 'null') { //OTR path
        } else if (useSalesforce) { //OTR path
            action.setParams({
                accountNumber : '',
                accountRecordId : idToUse,
                pdRowIdString : pdRowId,
                isOtrAccount : isOtrAccount
            });
        } else {
            action.setParams({
                accountNumber : acctNbr,
                accountRecordId : idToUse,
                pdRowIdString : '',
                isOtrAccount : isOtrAccount
            });
        }

        action.setCallback(this, function(response) {
            var state = response.getState();

            if(component.isValid() && state === "SUCCESS") {
                component.set("v.customerDetails", response.getReturnValue());

                let platform = component.get("v.customerDetails.sourceSys");
                platform = platform.toUpperCase();
                console.log("platform="+platform);
                let newIsOtrAccount = !('SIEBEL' === platform || 'TANDEM' === platform || 'CLASSIC' === platform);
                component.set("v.isOtrAccount", newIsOtrAccount.toString());
                console.log("setting component isOtrAccount to "+newIsOtrAccount);


                // if (component.get("v.isOtrAccount") === true && component.get("v.customerDetails.sfdcAcctId") !== 'null') {
                //     //component.set("v.acctRecordId", component.get("v.customerDetails.sfdcAcctId")); // todo: causes an error in the browser. is a valid component variable.
                // }
                var primaryContact = null;

                if (!(typeof _ === 'undefined')) {
                    _.forEach(component.get("v.customerDetails.contacts"), function(customerDetailsContact) {
                        _.forEach(customerDetailsContact, function(contact) {
                            if((contact.contactType) !== undefined && (contact.contactType).toUpperCase() === 'PRIMARY') {
                                primaryContact = contact;
                            }
                        });
                    });
                }

                component.set("v.customerPrimaryContact", primaryContact);

                if(component.get("v.accountNumber") == null) {
                    component.set("v.accountNumber", component.get("v.customerDetails.wexAccountNbr"));
                }

                $A.util.removeClass(target, 'fa-spin fa-1x fa-fw');

                var spinner = component.find("loadingSpinner");
                $A.util.addClass(spinner, "slds-hide");

                var appMode = component.get("v.appMode");

                var workspaceAPI = component.find("workspace");

                if(appMode === "subtab") {

                    workspaceAPI.getEnclosingTabId().then(function(tabId) {
                        workspaceAPI.setTabLabel({
                            tabId: tabId,
                            label: "Customer Details"
                        });

                        workspaceAPI.setTabIcon({
                            tabId: tabId,
                            icon: "standard:account"
                        });
                    })
                        .catch(function(error) {
                            console.log(error);
                        });

                } else {

                    var customerName = component.get("v.customerDetails.accountNm");

                    if(customerName === "" || customerName === undefined) { customerName = "Customer Details" };

                    workspaceAPI.getFocusedTabInfo().then(function(response) {
                        var focusedTabId = response.tabId;
                        workspaceAPI.setTabLabel({
                            tabId: focusedTabId,
                            label: customerName
                        });

                        workspaceAPI.setTabIcon({
                            tabId: focusedTabId,
                            icon: "standard:account"
                        });
                    })
                        .catch(function(error) {
                            console.log(error);
                        });

                }

                if(target != null) {

                    var toastEvent = $A.get("e.force:showToast");

                    toastEvent.setParams({ "type": "success", "title": "Success", "message": "Tab data refreshed!" });

                    toastEvent.fire();

                }

                var contactRowId = component.get("v.contactRowId");

                if(contactRowId != null && contactRowId !== "undefined") {
                    //component.set("v.selectedTabId", "customerContactsTab");
                }

                this.getPriorityLevelServicingRule(component,target);
                this.loadInvoices(component,target);
            }
            else {
                this.handleErrors(component, response);

            }

        });

        $A.enqueueAction(action);

    },

    loadGenericContacts : function(component, target) {
        var action = component.get("c.getSupportOperationsSettings");
        action.setCallback(this, function(response){
            if(component.isValid() && response != null && response.getState() == 'SUCCESS'){
                //saving custom setting to attribute
                component.set("v.dummyDriverContactId", response.getReturnValue().ContactDriverRecordID__c);
                component.set("v.dummyMerchantContactId", response.getReturnValue().ContactMerchantRecordID__c);
                component.set("v.dummyAltBillingContactId", response.getReturnValue().ContactAlternateBillingRecordID__c);
                component.set("v.dummyOnlineUserContactId", response.getReturnValue().ContactOnlineUserRecordID__c);
                component.set("v.dummySalesRepContactId", response.getReturnValue().ContactSalesRepRecordId__c);
                component.set("v.dummyFinanancialInstitutionContactId", response.getReturnValue().Financial_Institution_Record_Id__c);
                component.set("v.dummyWexInternalContactId", response.getReturnValue().Wex_Internal_Record_Id__c);
            }
        });

        $A.enqueueAction(action);
    },

    loadCustomerContacts : function(component, target) {
        this.loadGenericContacts(component, target);
        var action;
        let accountNumber = component.get("v.accountNumber");

        let checkSalesforce = this.getIdToUse(component,target);

        var useSalesforce = checkSalesforce.useSalesforce;
        var idToUse = checkSalesforce.idToUse;



        if (useSalesforce === true) { //Still may not really be true; do final check in Apex
            action = component.get("c.getCustomerContactsFromAnywhere");
            action.setParams({
                accountNumber : accountNumber,
                accountId : idToUse,
                primaryContactRowId: component.get("v.customerPrimaryContact.rowId")
            });
        } else {
            action = component.get("c.getCustomerContacts");
            action.setParams({
                accountNumber : accountNumber
            });
        }

        action.setCallback(this, function(response) {
            var state = response.getState();

            if(component.isValid() && state === "SUCCESS") {
                component.set("v.customerContacts", response.getReturnValue());
                component.set("v.filteredCustomerContacts", response.getReturnValue());

                if(target != null) {
                    $A.util.removeClass(target, 'fa-spin fa-1x fa-fw');
                }

                var spinner = component.find("customerContactsLoadingSpinner");
                $A.util.addClass(spinner, "slds-hide");

                if(target != null) {

                    var toastEvent = $A.get("e.force:showToast");

                    toastEvent.setParams({ "type": "success", "title": "Success", "message": "Tab data refreshed!" });

                    toastEvent.fire();

                }

            }
            else {
                this.handleErrors(component, response);
            }
        });

        $A.enqueueAction(action);

    },

    loadCustomerPaymentHistory : function(component, target) {

        var action = component.get("c.getAgingHistory");

        action.setParams({
            accountNumber : component.get("v.accountNumber")
        });

        action.setCallback(this, function(response) {
            var state = response.getState();

            if(component.isValid() && state === "SUCCESS") {
                console.log(JSON.stringify(response.getReturnValue()));
                component.set("v.customerPaymentHistory", response.getReturnValue());

                if(target != null) {
                    $A.util.removeClass(target, 'fa-spin fa-1x fa-fw');
                }

                var spinner = component.find("customerPaymentHistoryLoadingSpinner");
                $A.util.addClass(spinner, "slds-hide");

                if(target != null) {

                    var toastEvent = $A.get("e.force:showToast");

                    toastEvent.setParams({ "type": "success", "title": "Success", "message": "Tab data refreshed!" });

                    toastEvent.fire();

                }

                var cycleAgingData = (function() {

                    var retrievedCycleAgingData = [
                        component.get("v.customerPaymentHistory.daysPastDueCnt00"),
                        component.get("v.customerPaymentHistory.daysPastDueCnt01"),
                        component.get("v.customerPaymentHistory.daysPastDueCnt02"),
                        component.get("v.customerPaymentHistory.daysPastDueCnt03"),
                        component.get("v.customerPaymentHistory.daysPastDueCnt04"),
                        component.get("v.customerPaymentHistory.daysPastDueCnt05"),
                        component.get("v.customerPaymentHistory.daysPastDueCnt06"),
                        component.get("v.customerPaymentHistory.daysPastDueCnt07"),
                        component.get("v.customerPaymentHistory.daysPastDueCnt08"),
                        component.get("v.customerPaymentHistory.daysPastDueCnt09"),
                        component.get("v.customerPaymentHistory.daysPastDueCnt10"),
                        component.get("v.customerPaymentHistory.daysPastDueCnt11"),
                        component.get("v.customerPaymentHistory.daysPastDueCnt12"),
                        component.get("v.customerPaymentHistory.daysPastDueCnt13"),
                        component.get("v.customerPaymentHistory.daysPastDueCnt14"),
                        component.get("v.customerPaymentHistory.daysPastDueCnt15"),
                        component.get("v.customerPaymentHistory.daysPastDueCnt16"),
                        component.get("v.customerPaymentHistory.daysPastDueCnt17"),
                        component.get("v.customerPaymentHistory.daysPastDueCnt18"),
                        component.get("v.customerPaymentHistory.daysPastDueCnt19"),
                        component.get("v.customerPaymentHistory.daysPastDueCnt20"),
                        component.get("v.customerPaymentHistory.daysPastDueCnt21"),
                        component.get("v.customerPaymentHistory.daysPastDueCnt22"),
                        component.get("v.customerPaymentHistory.daysPastDueCnt23"),
                        component.get("v.customerPaymentHistory.daysPastDueCnt24"),
                        component.get("v.customerPaymentHistory.daysPastDueCnt25"),
                        component.get("v.customerPaymentHistory.daysPastDueCnt26")
                    ];

                    var cycleAgingData = new Array();

                    for(var i = 0; i <= retrievedCycleAgingData.length; i++) {
                        if(retrievedCycleAgingData[i] != null) {
                            cycleAgingData.push(retrievedCycleAgingData[i]);
                        }
                    }

                    return cycleAgingData;

                })();

                var lateNSFLabels = (function() {
                    var labels = new Array();

                    for(var i = 0; i < 12; i++) {
                        var currentMonth = moment().subtract(i, 'month');
                        labels.push(currentMonth.format('MMM YYYY'));
                    }

                    return labels;
                })();

                var cycleAgingDates = (function() {

                    var retrievedCycleAgingLabels = [
                        component.get("v.customerPaymentHistory.cycleCloseDt00"),
                        component.get("v.customerPaymentHistory.cycleCloseDt01"),
                        component.get("v.customerPaymentHistory.cycleCloseDt02"),
                        component.get("v.customerPaymentHistory.cycleCloseDt03"),
                        component.get("v.customerPaymentHistory.cycleCloseDt04"),
                        component.get("v.customerPaymentHistory.cycleCloseDt05"),
                        component.get("v.customerPaymentHistory.cycleCloseDt06"),
                        component.get("v.customerPaymentHistory.cycleCloseDt07"),
                        component.get("v.customerPaymentHistory.cycleCloseDt08"),
                        component.get("v.customerPaymentHistory.cycleCloseDt09"),
                        component.get("v.customerPaymentHistory.cycleCloseDt10"),
                        component.get("v.customerPaymentHistory.cycleCloseDt11"),
                        component.get("v.customerPaymentHistory.cycleCloseDt12"),
                        component.get("v.customerPaymentHistory.cycleCloseDt13"),
                        component.get("v.customerPaymentHistory.cycleCloseDt14"),
                        component.get("v.customerPaymentHistory.cycleCloseDt15"),
                        component.get("v.customerPaymentHistory.cycleCloseDt16"),
                        component.get("v.customerPaymentHistory.cycleCloseDt17"),
                        component.get("v.customerPaymentHistory.cycleCloseDt18"),
                        component.get("v.customerPaymentHistory.cycleCloseDt19"),
                        component.get("v.customerPaymentHistory.cycleCloseDt20"),
                        component.get("v.customerPaymentHistory.cycleCloseDt21"),
                        component.get("v.customerPaymentHistory.cycleCloseDt22"),
                        component.get("v.customerPaymentHistory.cycleCloseDt23"),
                        component.get("v.customerPaymentHistory.cycleCloseDt24"),
                        component.get("v.customerPaymentHistory.cycleCloseDt25"),
                        component.get("v.customerPaymentHistory.cycleCloseDt26")
                    ];

                    var cycleAgingDates = new Array();

                    for(var i = 0; i <= retrievedCycleAgingLabels.length; i++) {
                        if(retrievedCycleAgingLabels[i] != null) {
                            var date = moment(retrievedCycleAgingLabels[i]).add(1, 'day');
                            if(cycleAgingData.length === 12) {
                                cycleAgingDates.push(date.format('MMM YYYY'));
                            }
                            else {
                                cycleAgingDates.push(date.format('MMM DD, YYYY'));
                            }
                        }
                    }

                    return cycleAgingDates;

                })();

                var cycleAgingTitle = (function() {

                    var cyclePeriod = component.get("v.customerPaymentHistory.cyclePeriod");

                    if(cyclePeriod === undefined) {
                        cyclePeriod = 'm';
                    } else {
                        cyclePeriod = cyclePeriod.toLowerCase();
                    }

                    if(cyclePeriod === 'm') {
                        return "Monthly Billing Cycle (Cycle " + component.get("v.customerPaymentHistory.cycleCd") + ")";
                    }

                    if(cyclePeriod=== 'd') {
                        return "Weekly Billing Cycle (Cycle " + component.get("v.customerPaymentHistory.cycleCd") + ")";
                    }

                    if(cyclePeriod === 'b') {
                        return "Bi-Weekly Billing Cycle (Cycle " + component.get("v.customerPaymentHistory.cycleCd") + ")";
                    }

                    if(cyclePeriod === 'd') {
                        return "Daily Billing Cycle (Cycle " + component.get("v.customerPaymentHistory.cycleCd") + ")";
                    }

                })();

                var ticks = [120, 90, 60, 30, 15, 10, 0];
                var ctx = component.find("monthlyCycleAging").getElement();
                var cycleAging = new Chart(ctx, {
                    type: 'bar',
                    data: {
                        labels: cycleAgingDates,
                        datasets: [{
                            label: '# Days Past Due Date',
                            data: cycleAgingData,
                            backgroundColor: 'rgba(255, 99, 132, 0.2)',
                            borderColor: 'rgba(255,99,132,1)',
                            borderWidth: 1
                        }]
                    },
                    options: {
                        scales: {
                            yAxes: [{
                                ticks: {
                                    beginAtZero:true,
                                    autoSkip: false,
                                    min: 0,
                                    max: 120
                                },
                                afterBuildTicks: function(scale) {
                                    scale.ticks = ticks;
                                    return;
                                },
                                beforeUpdate: function(oScale) {
                                    return;
                                },
                                scaleLabel: {
                                    display: true,
                                    labelString: 'Days Past Due Date',
                                    fontSize: 14,
                                    fontStyle: "bold"
                                }
                            }],
                            xAxes: [{
                                scaleLabel: {
                                    display: true,
                                    labelString: cycleAgingTitle,
                                    fontSize: 14,
                                    fontStyle: "bold"
                                }
                            }],
                        },
                        maintainAspectRatio: false,
                        responsive: true,
                        legend: {
                            display: false
                        }
                    }
                });

                var ctx = component.find("lateNSFPayments").getElement();
                var paymentHistory = new Chart(ctx, {
                    type: 'bar',
                    data: {
                        labels: lateNSFLabels,
                        datasets: [
                            {
                                label: '# Late Payments',
                                data: [
                                    component.get("v.customerPaymentHistory.lateFeeCnt00"),
                                    component.get("v.customerPaymentHistory.lateFeeCnt01"),
                                    component.get("v.customerPaymentHistory.lateFeeCnt02"),
                                    component.get("v.customerPaymentHistory.lateFeeCnt03"),
                                    component.get("v.customerPaymentHistory.lateFeeCnt04"),
                                    component.get("v.customerPaymentHistory.lateFeeCnt05"),
                                    component.get("v.customerPaymentHistory.lateFeeCnt06"),
                                    component.get("v.customerPaymentHistory.lateFeeCnt07"),
                                    component.get("v.customerPaymentHistory.lateFeeCnt08"),
                                    component.get("v.customerPaymentHistory.lateFeeCnt09"),
                                    component.get("v.customerPaymentHistory.lateFeeCnt10"),
                                    component.get("v.customerPaymentHistory.lateFeeCnt11")
                                ],
                                backgroundColor: 'rgba(255, 159, 64, 0.2)',
                                borderColor: 'rgba(255, 159, 64, 1)',
                                borderWidth: 1
                            },
                            {
                                label: '# NSF Payments',
                                data: [
                                    component.get("v.customerPaymentHistory.nsfCnt00"),
                                    component.get("v.customerPaymentHistory.nsfCnt01"),
                                    component.get("v.customerPaymentHistory.nsfCnt02"),
                                    component.get("v.customerPaymentHistory.nsfCnt03"),
                                    component.get("v.customerPaymentHistory.nsfCnt04"),
                                    component.get("v.customerPaymentHistory.nsfCnt05"),
                                    component.get("v.customerPaymentHistory.nsfCnt06"),
                                    component.get("v.customerPaymentHistory.nsfCnt07"),
                                    component.get("v.customerPaymentHistory.nsfCnt08"),
                                    component.get("v.customerPaymentHistory.nsfCnt09"),
                                    component.get("v.customerPaymentHistory.nsfCnt10"),
                                    component.get("v.customerPaymentHistory.nsfCnt11")
                                ],
                                backgroundColor: 'rgba(255, 99, 132, 0.2)',
                                borderColor: 'rgba(255, 99, 132, 1)',
                                borderWidth: 1
                            }
                        ]
                    },
                    options: {
                        scales: {
                            yAxes: [{
                                ticks: {
                                    beginAtZero:true,
                                    stepSize: 1,
                                },
                                scaleLabel: {
                                    display: true,
                                    labelString: 'Number of Late / NSF Payments',
                                    fontSize: 14,
                                    fontStyle: "bold"
                                }
                            }],
                        },
                        maintainAspectRatio: false,
                        responsive: true,
                        legend: {
                            position: "right"
                        }
                    }
                });

            }
            else {
                this.handleErrors(component, response);
            }
        });

        $A.enqueueAction(action);

    },

    getIsoActionDescription : function(actionCode, odsDescription) {
        var iso;
        switch(actionCode)  {
            case "101": iso="Expired Card"; break;
            case "103": iso="Card acceptor contact acquirer"; break;
            case "104": iso="Safer Payments Decline. Refer to Fleet Manager"; break;
            case "107": iso="Refer to card issuer"; break;
            case "108": iso="Refer to card issuer; special conditions"; break;
            case "109": iso="Invalid Merchant"; break;
            case "110": iso="Invalid Amount"; break;
            case "111": iso="Invalid Card Number"; break;
            case "114": iso="No account of type requested"; break;
            case "116": iso="Not sufficient funds"; break;
            case "119": iso="Transaction not permitted"; break;
            case "120": iso="Transaction not permitted to this terminal"; break;
            case "121": iso="Exceeds withdrawal amount limit"; break;
            case "123": iso="Exceeds withdrawal frequency limit"; break;
            case "125": iso="Card not effective"; break;
            case "129": iso="Suspect counterfeit card"; break;
            case "180": iso="Invalid Driver ID"; break;
            case "181": iso="Invalid Vehicle Number"; break;
            case "182": iso="Reserved for private use"; break;
            case "183": iso="Reserved for private use"; break;
            case "184": iso="Reserved for private use"; break;
            case "185": iso="Reserved for private use"; break;
            case "186": iso="Reserved for private use"; break;
            case "187": iso="Reserved for private use"; break;
            case "188": iso="Reserved for private use"; break;
            case "189": iso="Reserved for private use"; break;
            case "190": iso="Reserved for private use"; break;
            case "191": iso="Reserved for private use"; break;
            case "192": iso="Exceeds $ limit-single transaction for product class"; break;
            case "193": iso="Exceeds number of Daily Transactions allowed for Product Class"; break;
            case "194": iso="Exceeds total Daily Dollar Limit for Product class"; break;
            case "195": iso="Reserved for private use"; break;
            case "196": iso="Reserved for private use"; break;
            case "197": iso="Reserved for private use"; break;
            case "198": iso="Reserved for private use"; break;
            case "199": iso="Invalid Prompt Entry"; break;
            case "200": iso="Do not honor"; break;
            case "208": iso="Lost card"; break;
            case "209": iso="Stolen card"; break;
            case "800": iso="Accepted"; break;
            case "902": iso="Invalid Transaction"; break;
            case "909": iso="System malfunction"; break;
            case "914": iso="Not able to trace back to original transaction"; break;
            default   : iso=odsDescription;
        }
        return iso;
    },

    getWexActionDescription : function(actionCode, odsDescription) {
        var wex;
        switch(actionCode)  {
            case "101": wex="Expired Card"; break;
            case "103": wex="Referral"; break;
            case "104": wex="See Immediate Notification 11/29/17"; break;
            case "107": wex="Refer to card issuer"; break;
            case "108": wex="Site not allowed / Site Selection"; break;
            case "109": wex="Invalid Site"; break;
            case "110": wex="Invalid Amount"; break;
            case "111": wex="Invalid Account"; break;
            case "114": wex="Invalid ISO"; break;
            case "116": wex="Not sufficient funds"; break;
            case "119": wex="Invalid Industry"; break;
            case "120": wex="Terminal restriction"; break;
            case "121": wex="Exceeds total Daily Dollar Limit"; break;
            case "123": wex="Exceeds number of Daily Transactions allowed"; break;
            case "125": wex="Invalid Day of Week and time of day"; break;
            case "129": wex="CAV"; break;
            case "180": wex="Invalid Driver ID"; break;
            case "181": wex="Invalid Vehicle Number"; break;
            case "182": wex="Invalid Local Date/Time"; break;
            case "183": wex="Exceeds $ limit-single transaction"; break;
            case "184": wex="Bad Option"; break;
            case "185": wex="User exceeded number of transactions allowed"; break;
            case "186": wex="Attempted use of card, out of network"; break;
            case "187": wex="Invalid Status - Account"; break;
            case "188": wex="Invalid Status - Card"; break;
            case "189": wex="Invalid Status - User"; break;
            case "190": wex="Invalid Status - Terminal"; break;
            case "191": wex="Invalid Product Code"; break;
            case "192": wex="Exceeds total limit per transaction, per product class"; break;
            case "193": wex="Exceeds total number of Daily Transactions per Product Class"; break;
            case "194": wex="Exceeds total Daily Dollar Limit per Product Class"; break;
            case "195": wex="Product Restricted"; break;
            case "196": wex="Unrecognized area code"; break;
            case "197": wex="Quantity Allowed is 0 for All Products"; break;
            case "198": wex="Exceeds transaction quantity limit"; break;
            case "199": wex="Invalid Prompt Entry"; break;
            case "200": wex="Pick up Card"; break;
            case "208": wex="Card reported as lost"; break;
            case "209": wex="Card reported as stolen"; break;
            case "800": wex="Keep alive accepted"; break;
            case "902": wex="Bad Transaction (external message prob)"; break;
            case "909": wex="System Malfunction"; break;
            case "914": wex="Not able to trace back to original transaction"; break;
            default   : wex=odsDescription;
        }
        return wex;
    },

    createDataTableTransactions : function(transactionMap) {
        //Create the data table data
        var i = 1;
        var dataTableTxns = transactionMap.map(authlog => {
            console.log("### authlog="+JSON.stringify(authlog));
            var siteInfo = authlog.merchantSite + String.fromCharCode(10);
            if (authlog.merchantAddress != null) {
                if (authlog.merchantAddress.orgName != null) siteInfo = siteInfo + authlog.merchantAddress.orgName + String.fromCharCode(10);
                if (authlog.merchantAddress.addr1 != null) siteInfo = siteInfo + authlog.merchantAddress.addr1 + String.fromCharCode(10);
                if (authlog.merchantAddress.addr2 != null) siteInfo = siteInfo + authlog.merchantAddress.addr2 + String.fromCharCode(10);
                if (authlog.merchantAddress.addr3 != null) siteInfo = siteInfo + authlog.merchantAddress.addr3 + String.fromCharCode(10);
                if (authlog.merchantAddress.addr4 != null) siteInfo = siteInfo + authlog.merchantAddress.addr4 + String.fromCharCode(10);
                if (authlog.merchantAddress.city != null) siteInfo = siteInfo + authlog.merchantAddress.city;
                if (authlog.merchantAddress.state != null) siteInfo = siteInfo + ", "+authlog.merchantAddress.state;
                if (authlog.merchantAddress.postalCode != null) siteInfo = siteInfo + " " +authlog.merchantAddress.postalCode;
                siteInfo = siteInfo + String.fromCharCode(10);
                if (authlog.merchantAddress.country != null) siteInfo = siteInfo + authlog.merchantAddress.country + String.fromCharCode(10);
            }
            var iso = this.getIsoActionDescription(authlog.actionCode,authlog.actionCodeDescription);
            var wexDesc = this.getWexActionDescription(authlog.actionCode,authlog.actionCodeDescription);
            var filterString = authlog.cardNumber + "\\" + $A.localizationService.formatDate(authlog.txnDt, "MMM d, yyyy, h:mm:ss a");
            var dtRecord = {Id: i, actionCode:authlog.actionCode, cardNumber:authlog.cardNumber, driverId:authlog.driverId, merchantSite:siteInfo, isoActionCodeDescription:iso, txnDt:authlog.txnDt, wexActionCodeDescription:wexDesc, filterString:filterString.toUpperCase()};
            console.log(dtRecord);
            i++;
            return dtRecord;
        });
        return dataTableTxns;
    },

    loadDeclinedTransactions : function(component, target) {

        var action = component.get("c.getRecentDeclinedAuths");

        action.setParams({
            wexAcctNbr : component.get("v.accountNumber"),
            sourceSys  : component.get("v.customerDetails.sourceSys")
        });

        action.setCallback(this, function(response) {
            var state = response.getState();

            if(component.isValid() && state === "SUCCESS") {
                component.set("v.declinedTransactions", response.getReturnValue());
                component.set("v.filteredDeclinedTransactions", response.getReturnValue());
                if (response.getReturnValue() != null) {
                    component.set("v.dataTableTransactions", this.createDataTableTransactions(component.get("v.filteredDeclinedTransactions")));
                    component.set("v.filteredDataTableTransactions",component.get("v.dataTableTransactions"));
                } else
                    component.set("v.declinedTransactionsErrorMessage","No results found");

                if(target != null) {
                    $A.util.removeClass(target, 'fa-spin fa-1x fa-fw');
                }


                var spinner = component.find("declinedTransactionsLoadingSpinner");
                $A.util.addClass(spinner, "slds-hide");

                if(target != null) {

                    var toastEvent = $A.get("e.force:showToast");

                    toastEvent.setParams({ "type": "success", "title": "Success", "message": "Tab data refreshed!" });

                    toastEvent.fire();

                }

            }
            else {
                component.set("v.declinedTransactionsErrorMessage","");
                this.handleErrors(component, response);
            }
        });

        $A.enqueueAction(action);

    },

    filterTransactions : function(component) {
        component.set("v.declinedTransactionsErrorMessage","");
        var txnFilter = component.find("transactionTableFilter").get("v.value");
        console.log(txnFilter);
        if(txnFilter == null || txnFilter === "") {
            null;
        }
        else {
            var filteredtxns = _.filter(component.get("v.dataTableTransactions"), function(txn) {
                var containstxn = false;
                console.log("###: Filtering Transactions");
                console.log((JSON.stringify(txn)).toUpperCase());
                containstxn = _.includes(txn.filterString, txnFilter.toUpperCase());
                return containstxn;
            });
            console.log(filteredtxns);
            component.set("v.filteredDeclinedTransactions", filteredtxns);
            component.set("v.filteredDataTableTransactions", this.createDataTableTransactions(filteredtxns));
            if (filteredtxns.length == 0)
                component.set("v.declinedTransactionsErrorMessage","No results found");
        }

    },

    loadPayments : function(component, target) {

        var action = component.get("c.getPayments");

        var numberToUse;
        var sourceSysToUse;

        let isOtrAccount = component.get("v.isOtrAccount");
        if (isOtrAccount === "false") {
            numberToUse = component.get("v.accountNumber");
            sourceSysToUse = component.get("v.customerDetails.sourceSys");
        } else {
            numberToUse = component.get("v.customerDetails.arNumber");
            sourceSysToUse = component.get("v.customerDetails.sourceSys");
            if (sourceSysToUse == null || sourceSysToUse === "")
                sourceSysToUse = "EFS";
        }

        action.setParams({
            accountNumber : numberToUse,
            sourceSys     : sourceSysToUse
        });

        action.setCallback(this, function(response) {
            console.log("### loadPayments RESPONSE " +response);
            var state = response.getState();
            //var state = "SUCCESS";
            if(component.isValid() && state === "SUCCESS") {
                component.set("v.paymentsBulk", response.getReturnValue());
                component.set("v.paymentDetails", component.get("v.paymentsBulk").paymentDetails);
                component.set("v.paymentHistory", component.get("v.paymentsBulk").paymentHistory);
                component.set("v.pendingPayments", component.get("v.paymentsBulk").pendingPayments);
                //Dummy part
                //component.set("v.paymentsBulk", response);
                //component.set("v.paymentDetails", response.paymentDetails);
                //component.set("v.paymentHistory", response.paymentHistory);
                console.log("### got payments");
                console.log(response);
                //End dummy part

                if(target != null) {
                    $A.util.removeClass(target, 'fa-spin fa-1x fa-fw');
                }

                var spinner = component.find("paymentsLoadingSpinner");
                $A.util.addClass(spinner, "slds-hide");

                var message;
                var messageType;
                var messageTitle = "";
                var messageMode;


                if(target != null) {
                    message = "Tab data refreshed!";
                    messageType = "success";
                    messageTitle = "Success";
                    messageMode = "dismissible";
                }


                var errors = response.getReturnValue().errorMsg;
                console.log("### errors="+errors);
                if (errors && errors.length > 0) {
                    console.log("### errors.length="+errors.length);
                    message = errors;
                    messageType = "warning";
                    messageTitle = "Warning!";
                    messageMode = "sticky";
                }
                console.log("### messageTitle = "+messageTitle);
                if (messageTitle != "") {
                    var toastEvent = $A.get("e.force:showToast");

                    toastEvent.setParams({ "mode": messageMode, "type": messageType, "title": messageTitle, "message": message });

                    toastEvent.fire();
                }
            }
            else {
                var errorMessage = "Unknown Fault";

                var errors = response.errorMsg;

                if (errors && Array.isArray(errors) && errors.length > 0) {
                    errorMessage = errors[0].message;
                }

                var toastEvent = $A.get("e.force:showToast");

                toastEvent.setParams({ "mode": "sticky", "type": "error", "title": "Error", "message": errorMessage });

                toastEvent.fire();
            }
        });

        $A.enqueueAction(action);

    },

    loadInvoices : function(component, target) {
        let accountNumber = component.get("v.accountNumber");
        let sourceSys = component.get("v.customerDetails.sourceSys");
        var action;
        console.log('accountNumber--------->',accountNumber);
        console.log('sourceSys--------->',sourceSys);
        console.log('****ISOTR--------->',component.get("v.isOtrAccount"));
        if (component.get("v.isOtrAccount") && component.get("v.isOtrAccount").toUpperCase()==="TRUE") {
            if(sourceSys == null || sourceSys == undefined){
                sourceSys = 'OTR';
            }
            accountNumber = component.get("v.customerDetails.arNumber");
            console.log("OTR account--accountNumber---->",accountNumber);
            action = component.get("c.getOTRInvoices");
            action.setParams({
                arNumber : accountNumber,
                sourceSys     : sourceSys
            });

        } else {
            action = component.get("c.getInvoices");
            action.setParams({
                accountNumber : accountNumber,
                sourceSys     : sourceSys
            });
        }

        action.setCallback(this, function(response) {
            console.log("### loadInvoices RESPONSE " +response);
            var state = response.getState();

            if(component.isValid() && state === "SUCCESS") {
                let respVal = response.getReturnValue();
                console.log("### loadInvoices RESPONSE-----> " +response.getReturnValue());


                //for (let[key, value] of respVal) {
                //    console.log('Invoice response: '+key + ' = ' + value);
                //}
                component.set("v.invoices", respVal);
                console.dir(component.get("v.invoices"));


                if(target != null) {
                    $A.util.removeClass(target, 'fa-spin fa-1x fa-fw');
                }

                var spinner = component.find("invoicesLoadingSpinner");
                $A.util.addClass(spinner, "slds-hide");

                var message;
                var messageType;
                var messageTitle = "";
                var messageMode;


                if(target != null) {
                    message = "Tab data refreshed!";
                    messageType = "success";
                    messageTitle = "Success";
                    messageMode = "dismissible";
                }


                var errors = response.getReturnValue().errorMsg;
                if (errors && errors.length > 0) {
                    console.log("### errors="+errors);
                    console.log("### errors.length="+errors.length);
                    message = errors;
                    messageType = "warning";
                    messageTitle = "Warning!";
                    messageMode = "sticky";
                }
                console.log("### messageTitle = "+messageTitle);
                if (messageTitle != "") {
                    var toastEvent = $A.get("e.force:showToast");

                    toastEvent.setParams({ "mode": messageMode, "type": messageType, "title": messageTitle, "message": message });

                    toastEvent.fire();
                }
            }
            else {
                var errorMessage = "Unknown Fault";

                var errors = response.errorMsg;

                if (errors && Array.isArray(errors) && errors.length > 0) {
                    errorMessage = errors[0].message;
                }

                var toastEvent = $A.get("e.force:showToast");

                toastEvent.setParams({ "mode": "sticky", "type": "error", "title": "Error", "message": errorMessage });

                toastEvent.fire();
            }
        });
        var spinner = component.find("invoicesLoadingSpinner");
        $A.util.addClass(spinner, "slds-hide");
        $A.enqueueAction(action);
    },

    getPriorityLevelServicingRule : function(component, target) {
        console.log("Enter getPriorityLevelServicingRule");
        var priorityLevel = component.get("v.customerDetails.priorityLevel");
        var pgmRowId = component.get("v.customerDetails.programId");
        console.log("getPriorityLevelServicingRule: found pgmRowId "+pgmRowId + " and priorityLevel "+priorityLevel);
        if (priorityLevel != null && pgmRowId != null) {

            var action = component.get("c.getPriorityLevelServicingRule");

            action.setParams({
                pgmRowId: pgmRowId,
                priorityLevel: priorityLevel
            })
            console.log("getPriorityLevelServicingRule: calling controller for pgmRowId "+pgmRowId + " and priorityLevel "+priorityLevel);
            action.setCallback(this, function (response) {
                console.log("### getPriorityLevelServicingRule RESPONSE " + response);
                var state = response.getState();

                if (component.isValid() && state === "SUCCESS") {
                    component.set("v.priorityLevelServicingRule", response.getReturnValue());

                } else {
                    var errorMessage = "Unknown Fault";
                }

            });
            $A.enqueueAction(action);
        }
    },

    fetchNumberOfCasesToday : function(component, target) {
        console.log("### Enter fetchNumberOfCasesToday");

        var acctNbr = component.get("v.accountNumber");

        var action;

        let checkSalesforce = this.getIdToUse(component,target);

        var useSalesforce = checkSalesforce.useSalesforce;
        var idToUse = checkSalesforce.idToUse;

        if (useSalesforce === true) {
            action = component.get("c.getNumberOfCasesTodayByAccountRecordId");

            action.setParams({
                accountId : idToUse
            });

        } else {
            action = component.get("c.getNumberOfCasesToday");

            action.setParams({
                accountNumber : acctNbr
            });

        }

        action.setCallback(this, function(response) {
            var state = response.getState();

            if(component.isValid() && state === "SUCCESS") {
                component.set("v.numberOfCasesToday", response.getReturnValue());
            }
            else {
                this.handleErrors(component, response);
            }

        });

        $A.enqueueAction(action);

    },



    getLanguageIndicator : function(component, target) {
        console.log("### Enter getLanguageIndicator");
        var action = component.get("c.getLanguageIndicator");
        action.setParams({
            accountId : component.get("v.recordId"),
            accountNumber : component.get("v.accountNumber")
        });

        action.setCallback(this, function(response) {
            var state = response.getState();
            console.log('getLanguageIndicator.response----->'+response.getReturnValue());
            if(component.isValid() && state === "SUCCESS") {
                component.set("v.languageIndicator", response.getReturnValue());
            }
            else {
                this.handleErrors(component, response);
            }

        });

        $A.enqueueAction(action);

    },

    fetchExistingCases : function(component, target) {

        var acctNbr = component.get("v.accountNumber");

        var action;

        let checkSalesforce = this.getIdToUse(component,target);

        var useSalesforce = checkSalesforce.useSalesforce;
        var idToUse = checkSalesforce.idToUse;

        if (useSalesforce === true)  {
            action = component.get("c.getExistingCasesByAccountRecordId");

            action.setParams({
                accountRowId : idToUse
            });

        } else {
            action = component.get("c.getExistingCases");

            action.setParams({
                accountNumber : acctNbr
            });

        }

        action.setCallback(this, function(response) {
            var state = response.getState();

            if(component.isValid() && state === "SUCCESS") {
                component.set("v.existingCases", response.getReturnValue());
                component.set("v.filteredExistingCases", response.getReturnValue());

                var target = component.find('caseModalBox');
                var page = component.find('modalBackdrop');
                $A.util.addClass(target, 'slds-fade-in-open');
                $A.util.addClass(page, 'slds-backdrop--open');
            }
            else {
                this.handleErrors(component, response);
            }

        });

        $A.enqueueAction(action);

    },

    fetchCaseHistory : function(component, name) {

        console.log("### Helper: Fetching case history");

        const __ret = this.getIdToUse(component,name);
        let accountNumber = component.get("v.accountNumber");
        var action ;
        var useSalesforce = __ret.useSalesforce;
        var idToUse = __ret.idToUse;


        if (useSalesforce === true) {
            action = component.get("c.getExistingCasesByAccountRecordId");

            action.setParams({
                accountId : idToUse
            });

        } else {
            action = component.get("c.getExistingCases");

            action.setParams({
                accountNumber : accountNumber
            });

        }

        action.setCallback(this, function(response) {
            var state = response.getState();
            var spinner = component.find("casesLoadingSpinner");
            var caseTable = component.find("casesTable");
            var noCaseLabel = component.find("noCasesFoundLabel");
            $A.util.addClass(spinner, "slds-hide");

            if(component.isValid() && state === "SUCCESS") {
                console.log("### Helper: Fetched case history");
                console.log("### Helper: response length="+response.getReturnValue().length);
                console.log("### Helper: response ="+JSON.stringify(response.getReturnValue()));
                if (response.getReturnValue().length >0) {
                    var flattenedObject = this.flattenQueryResult(response.getReturnValue());

                    console.log("### Helper: flattened response ="+JSON.stringify(flattenedObject));
                    component.set("v.caseHistory", flattenedObject);
                    $A.util.addClass(noCaseLabel, "slds-hide");
                    $A.util.removeClass(caseTable, "slds-hide");
                } else {
                    $A.util.removeClass(noCaseLabel, "slds-hide");
                    $A.util.addClass(caseTable, "slds-hide");
                }
            }
            else {
                this.handleErrors(component, response);
            }

        });

        $A.enqueueAction(action);

    },

    fetchExistingOpenCases : function(component) {
        console.log("### Enter fetchExistingOpenCases");

        var acctNbr = component.get("v.accountNumber");

        var action;

        let checkSalesforce = this.getIdToUse(component);

        var useSalesforce = checkSalesforce.useSalesforce;
        var idToUse = checkSalesforce.idToUse;


        if (useSalesforce === true) {
            action = component.get("c.getExistingOpenCasesByAccountId");

            action.setParams({
                accountId : idToUse
            });

        } else {
            action = component.get("c.getExistingOpenCases");

            action.setParams({
                accountNumber : acctNbr
            });

        }
        //Get the open cases
        console.log("### Helper: Fetching existing cases");

        action.setCallback(this, function(response) {
            var state = response.getState();
            console.log("### Helper:fetchExistingOpenCases response state="+state);

            if(component.isValid() && state === "SUCCESS") {
                component.set("v.frontPageExistingCases", response.getReturnValue());
            }
            else {
                this.handleErrors(component, response);
            }

        });

        $A.enqueueAction(action);

    },

    popToCase : function(component, target) {

        var spinner = component.find("loadingSpinner");
        $A.util.removeClass(spinner, "slds-hide");

        var isDummyContact = component.get("v.isDummyContact");
        console.log("popToCase: isDummyContact = "+isDummyContact);

        var actionMethod;

        if (isDummyContact === "true") {
            actionMethod = "c.attachDummyContactToCase";
        } else {
            actionMethod = "c.attachToCase";
        }

        var action = component.get(actionMethod);
        console.log("popToCase: calling action "+actionMethod);

        action.setParams({
            caseId : component.get("v.caseId"),
            contactRowId : component.get("v.contactRowId"),
            customerDetailsJSON : JSON.stringify(component.get("v.customerDetails")),
            contactsJSON: JSON.stringify(component.get("v.customerContacts"))
        });

        action.setCallback(this, function(response) {

            var state = response.getState();

            var spinner = component.find("loadingSpinner");
            $A.util.addClass(spinner, "slds-hide");

            var target = component.find('caseModalBox');
            var page = component.find('modalBackdrop');
            $A.util.removeClass(page,'slds-backdrop--open');
            $A.util.removeClass(target, 'slds-fade-in-open');

            if(component.isValid() && state === "SUCCESS") {

                var returnedCaseId = response.getReturnValue();

                var workspaceAPI = component.find("workspace");
                workspaceAPI.openTab({
                    recordId: returnedCaseId,
                    focus: true
                }).then(function(response) {
                    workspaceAPI.focusTab({
                        tabId: response
                    });

                    $A.util.addClass(spinner, "slds-hide");
                    workspaceAPI.openSubtab({
                        parentTabId: response,
                        url: '#/n/Customer_Details?c__accountNumber=' + component.get("v.accountNumber") + '&c__accountRowId=' + component.get("v.accountRowId") + '&c__isOtrSearch=' + component.get("v.isOtrAccount"),
                        focus: false
                    });

                    workspaceAPI.getEnclosingTabId().then(function(originalTabId) {
                        workspaceAPI.closeTab({tabId: originalTabId});
                    })
                        .catch(function(error) {
                            console.log(error);
                        });
                })
                    .catch(function(error) {
                        console.log(error);
                    });

            }
            else {
                this.handleErrors(component, response);
            }

        });

        $A.enqueueAction(action);

    },

    popToFrontPageCase : function(component, target) {
        console.log("### Helper popToFrontPageCase for Case ID "+component.get("v.caseId"));

        var spinner = component.find("loadingSpinner");
        $A.util.removeClass(spinner, "slds-hide");

        var target = component.find('caseModalBox');
        var page = component.find('modalBackdrop');
        $A.util.removeClass(page,'slds-backdrop--open');
        $A.util.removeClass(target, 'slds-fade-in-open');

        if(component.isValid()) {
            console.log("### Helper popToFrontPageCase :component is valid");
            var returnedCaseId =component.get("v.caseId");
            console.log("### Helper popToFrontPageCase :returnedCaseId="+returnedCaseId);
            var workspaceAPI = component.find("workspace");
            workspaceAPI.openTab({
                recordId: returnedCaseId,
                focus: true
            });

        }

        else {

            var errorMessage = "Unable to open case";

            var toastEvent = $A.get("e.force:showToast");

            toastEvent.setParams({ "mode": "sticky", "type": "error", "title": "Error", "message": errorMessage });

            toastEvent.fire();
        }
        $A.util.addClass(spinner, "slds-hide");

    },

    filterContacts : function(component) {

        var contactFilter = component.find("contactTableFilter").get("v.value");

        console.log(contactFilter);

        if(contactFilter == null || contactFilter === "") {
            component.find("contactTableFilter").set("v.errors", "Enter a filter!");
        }
        else {
            component.find("contactTableFilter").set("v.errors", "");
            var filteredContacts = _.filter(component.get("v.customerContacts"), function(contact) {
                var containsContact = false;
                _.forEach(contact, function(value) {
                    console.log((JSON.stringify(value)).toUpperCase());
                    containsContact = containsContact || _.includes(_.toString((JSON.stringify(value)).toUpperCase()), contactFilter.toUpperCase());
                });

                return containsContact;
            });

            console.log(filteredContacts);

            component.set("v.filteredCustomerContacts", filteredContacts);
        }

    },

    filterCases : function(component) {

        var caseFilter = component.find("caseTableFilter").get("v.value");

        if(caseFilter == null || caseFilter === "") {
            component.find("caseTableFilter").set("v.errors", "Enter a filter!");
        }
        else {
            component.find("caseTableFilter").set("v.errors", "");
            var filteredCases = _.filter(component.get("v.existingCases"), function(existingCase) {
                var containsCase = false;
                _.forEach(existingCase, function(value) {
                    containsCase = containsCase || _.includes(_.toString((JSON.stringify(value)).toUpperCase()), caseFilter.toUpperCase());
                });

                return containsCase;
            });


            component.set("v.filteredExistingCases", filteredCases);
        }

    },

    sortCaseData:  function (component, fieldName, sortDirection) {
        var data = component.find("casesTable").get("v.data");
        var reverse = sortDirection !== 'asc';
        //sorts the rows based on the column header that's clicked
        data.sort(this.sortBy(fieldName, reverse))
        component.find("casesTable").set("v.data", data);
    },

    //These functions are used in the Declined Transactions tab
    sortTxnData: function (component, fieldName, sortDirection) {
        var data = component.find("declinedTransactionsTable").get("v.data");
        var reverse = sortDirection !== 'asc';
        //sorts the rows based on the column header that's clicked
        data.sort(this.sortBy(fieldName, reverse))
        component.find("declinedTransactionsTable").set("v.data", data);
    },

    sortOTRInvoicesData: function (component, fieldName, sortDirection) {
        var data = component.find("otrInvoicesTable").get("v.data");
        var reverse = sortDirection !== 'asc';
        //sorts the rows based on the column header that's clicked
        data.sort(this.sortBy(fieldName, reverse))
        component.find("otrInvoicesTable").set("v.data", data);
    },

    sortBy: function (field, reverse, primer) {
        var key = primer ?
            function(x) {return primer(x[field])} :
            function(x) {return x[field]};
        //checks if the two rows should switch places
        reverse = !reverse ? 1 : -1;
        return function (a, b) {
            return a = key(a)?key(a):'', b = key(b)?key(b):'', reverse * ((a > b) - (b > a));
        }
    },

    // These are object flatteners used to make child object fields available to DataTables
    // Taken from https://iwritecrappycode.wordpress.com/2017/11/22/salesforce-lightning-datatable-query-flattener/
    flattenObject : function(propName, obj) {
        var flatObject = [];

        for(var prop in obj)
        {
            console.log("### flattenObject: propName="+propName+", prop="+prop);
            //if this property is an object, we need to flatten again
            var propIsNumber = isNaN(propName);
            var preAppend = propIsNumber ? propName+'_' : '';
            if(typeof obj[prop] == 'object')
            {
                flatObject[preAppend+prop] = Object.assign(flatObject, this.flattenObject(preAppend+prop,obj[prop]) );

            }
            else
            {
                flatObject[preAppend+prop] = obj[prop];
            }
        }
        console.log("### Flattened object="+JSON.stringify(flatObject));
        return flatObject;
    },

    //This returns an array so the calling function will need to reduce it to a map.
    flattenQueryResult : function(listOfObjects) {
        var newListOfObjects;
        if(!Array.isArray(listOfObjects))
        {
            newListOfObjects = [listOfObjects];
        } else {
            newListOfObjects = listOfObjects;
        }

        console.log('List of Objects is now....');
        console.log(newListOfObjects);
        for(var i = 0; i < newListOfObjects.length; i++)
        {
            var obj = newListOfObjects[i];
            for(var prop in obj)
            {
                if(!obj.hasOwnProperty(prop)) continue;
                if(typeof obj[prop] == 'object' && !Array.isArray(obj[prop]))
                {
                    obj = Object.assign(obj, this.flattenObject(prop,obj[prop]));
                }
                else if(Array.isArray(obj[prop]))
                {
                    for(var j = 0; j < obj[prop].length; j++)
                    {
                        obj[prop+'_'+j] = Object.assign(obj,this.flattenObject(prop,obj[prop]));
                    }
                }
            }
            if (!(obj.hasOwnProperty('Anchor')) && obj.hasOwnProperty('Id')) {
                obj['Anchor'] = '/'+obj['Id'];
            }
            newListOfObjects[i]=obj;
            console.log("flattenQueryResult: ["+i+"] = "+JSON.stringify(obj));
        }
        return newListOfObjects;
    },

    isSalesforceId : function(testId) {
        console.log('Entering isSalesforceId for testId '+testId);
        if (testId === null)  {
            return false;
        }
        if (testId.length < 1)  {
            return false;
        }
        if (testId.length !== 15 && testId.length !== 18) {
            return false;
        }
        let matchResult = testId.match('[A-Za-z0-9]+');
        console.log('matchResult is '+matchResult);
        let result = matchResult && (testId === matchResult[0]);
        console.log('isSalesforceId returns '+result);
        return result;

    },
    reloadContract: function (component, event, helper) {
        //let otrContractList = component.get('v.customerDetails.otrContracts.entry');
        //if(otrContractList != undefined && otrContractList.length > 0){
        //    component.set("v.otrContractObj",otrContractList[0].value);
        //}
        if (component.get("v.otrContractObj")) {
            let currentContract = component.get("v.otrContractObj");
            console.log('Current Contract = '+currentContract.arNumber);

            let oldArNumber = component.get("v.customerDetails.arNumber");
            console.log("*** billingCycleDesc='"+currentContract.billingCycleDesc+"'");

            component.set("v.customerDetails.arNumber",currentContract.arNumber);
            component.set("v.customerDetails.availableCreditLmt",currentContract.availableCreditLmt);
            component.set("v.customerDetails.billingCycleDesc",currentContract.billingCycleDesc);
            component.set("v.customerDetails.billingAccountId",currentContract.billingAcctNbr);
            component.set("v.customerDetails.canadianFee",currentContract.canadianFee);
            component.set("v.customerDetails.canadianFeeDescription",currentContract.canadianFeeDescription);
            component.set("v.customerDetails.cashEnabledIndicator",currentContract.cashEnabledIndicator);
            component.set("v.customerDetails.codeExpiredFee",currentContract.codeExpiredFee);
            component.set("v.customerDetails.codeExpiredFeeDescription",currentContract.codeExpiredFeeDescription);
            component.set("v.customerDetails.contractNbr",currentContract.contractNbr);
            component.set("v.customerDetails.contractNm",currentContract.contractNm);
            component.set("v.customerDetails.contractStartDt",currentContract.contractStartDt);
            component.set("v.customerDetails.creditLmt",currentContract.creditLmt);
            component.set("v.customerDetails.currentBillingCycle",currentContract.currentBillingCycle);
            component.set("v.customerDetails.currentInvoiceClosingDt",currentContract.currentInvoiceClosingDt);
            component.set("v.customerDetails.currentInvoiceDueDt",currentContract.currentInvoiceDueDt);
            component.set("v.customerDetails.daysToPay",currentContract.daysToPay);
            component.set("v.customerDetails.debitCycle",currentContract.debitCycle);
            component.set("v.customerDetails.faxFee",currentContract.faxFee);
            component.set("v.customerDetails.faxFeeDescription",currentContract.faxFeeDescription);
            component.set("v.customerDetails.financeChargeRteType",currentContract.financeChargeRteType);
            component.set("v.customerDetails.lastInvoiceBilledAmt",currentContract.lastInvoiceBilledAmt);
            component.set("v.customerDetails.lastPaymentAmount",currentContract.lastPaymentAmount);
            component.set("v.customerDetails.lastPaymentDt",currentContract.lastPaymentDt);
            component.set("v.customerDetails.lastPaymentMethod",currentContract.lastPaymentMethod);
            component.set("v.customerDetails.moneyIncrementalFee",currentContract.moneyIncrementalFee);
            component.set("v.customerDetails.moneyIncrementalFeeDescription",currentContract.moneyIncrementalFeeDescription);
            component.set("v.customerDetails.monthlyCardFee",currentContract.monthlyCardFee);
            component.set("v.customerDetails.monthlyCardFeeDescription",currentContract.monthlyCardFeeDescription);
            component.set("v.customerDetails.nsfFee",currentContract.nsfFee);
            component.set("v.customerDetails.nsfFeeDescription",currentContract.nsfFeeDescription);
            component.set("v.customerDetails.outOfNetworkPerTxnFee",currentContract.outOfNetworkPerTxnFee);
            component.set("v.customerDetails.outOfNetworkProgramOrAccountRte",currentContract.outOfNetworkProgramOrAccountRte);
            component.set("v.customerDetails.overLimitFee",currentContract.overLimitFee);
            component.set("v.customerDetails.overLimitFeeDescription",currentContract.overLimitFeeDescription);
            component.set("v.customerDetails.pastDueAmount",currentContract.pastDueAmount);
            component.set("v.customerDetails.payByAgentFee",currentContract.payByAgentFee);
            component.set("v.customerDetails.payByAgentFeeDescription",currentContract.payByAgentFeeDescription);
            component.set("v.customerDetails.pendingTxns",currentContract.pendingTxns);
            component.set("v.customerDetails.periodicFinanceChargeRte",currentContract.periodicFinanceChargeRte);
            component.set("v.customerDetails.programMaintenanceCharge",currentContract.programMaintenanceCharge);
            component.set("v.customerDetails.programMaintenanceChargeDescription",currentContract.programMaintenanceChargeDescription);
            component.set("v.customerDetails.thirdPartyCheckFee",currentContract.thirdPartyCheckFee);
            component.set("v.customerDetails.thirdPartyCheckFeeDescription",currentContract.thirdPartyCheckFeeDescription);
            component.set("v.customerDetails.totalOwed",currentContract.totalOwed);
            component.set("v.customerDetails.onlinePayAllowed",currentContract.onlinePayAllowed);
            component.set("v.customerDetails.onlinePayVelocity",currentContract.velocity);
            component.set("v.customerDetails.moneyCodeLimit",currentContract.moneyCodeLimit);
            component.set("v.customerDetails.transactionLimit",currentContract.txnLimit);
            component.set("v.customerDetails.recourceAmt",currentContract.recourseAmt);
            component.set("v.customerDetails.cashLimit",currentContract.cashLimit);
            component.set("v.customerDetails.depositAmt",currentContract.depositAmt);
            component.set("v.customerDetails.unbilledAmt",currentContract.unbilledAmt);
            component.set("v.customerDetails.usualMethodOfPayment",currentContract.usualMethodOfPayment);
            component.set("v.customerDetails.westernUnionFee",currentContract.westernUnionFee);
            component.set("v.customerDetails.westernUnionFeeDescription",currentContract.westernUnionFeeDescription);
            component.set("v.customerDetails.wireFee",currentContract.wireFee);
            component.set("v.customerDetails.wireFeeDescription",currentContract.wireFeeDescription);
            component.set("v.customerDetails.territoryCode",currentContract.salesTerritory);
            //This forces the payments tolazy-reload properly when we switch contracts
            let currencyCode = currentContract.currencyCode != null ? currentContract.currencyCode : 'USD';
            if (currentContract.arNumber !== oldArNumber) {
                component.set("v.contractCurrency",currencyCode);
                component.set("v.paymentsBulk",null);
                component.set("v.invoices",null);
                this.loadInvoices(component, event.target);
            }
        }
    },

    handleErrors : function(component, response){
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