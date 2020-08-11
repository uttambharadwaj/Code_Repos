@isTest
global class CustomerDetailsWSUtilv2_Mock implements WebServiceMock {
    global void doInvoke(
            Object stub,
            Object request,
            Map<String, Object> response,
            String endpoint,
            String soapAction,
            String requestName,
            String responseNS,
            String responseName,
            String responseType) {

        System.debug('### ' + request);

        if (request instanceof CustomerDetailsWSUtilv2.getAgingHistory) {

            CustomerDetailsWSUtilv2.getAgingHistory getAgingHistoryObject = (CustomerDetailsWSUtilv2.getAgingHistory) request;

            CustomerDetailsWSUtilv2.customerDetailsRequest customerDetailsRequest = (CustomerDetailsWSUtilv2.customerDetailsRequest) getAgingHistoryObject.arg0;

            if ((customerDetailsRequest.accountID).equalsIgnoreCase('9100000000000')) {

                CustomerDetailsWSUtilv2.getAgingHistoryResponse responseElement = new CustomerDetailsWSUtilv2.getAgingHistoryResponse();

                responseElement.return_x = new CustomerDetailsWSUtilv2.agingHistory();

                responseElement.return_x.accountId = '9100003325428';
                responseElement.return_x.accountNm = 'Hub Cap Annie &amp; Wheel of Idaho Inc';
                responseElement.return_x.cycleCd = 2;
                responseElement.return_x.cyclePeriod = 'd';
                responseElement.return_x.cycleAnchorDt = (Datetime) JSON.deserialize('"2017-03-31T00:00:00-05:00"', Datetime.class);
                responseElement.return_x.daysLatePastDueCnt = Integer.valueOf(Math.floor(Math.random() * ((120 - 0) + 1) + 0));
                responseElement.return_x.daysPastDueCnt00 = Integer.valueOf(Math.floor(Math.random() * ((120 - 0) + 1) + 0));
                responseElement.return_x.daysPastDueCnt01 = Integer.valueOf(Math.floor(Math.random() * ((120 - 0) + 1) + 0));
                responseElement.return_x.daysPastDueCnt02 = Integer.valueOf(Math.floor(Math.random() * ((120 - 0) + 1) + 0));
                responseElement.return_x.daysPastDueCnt03 = Integer.valueOf(Math.floor(Math.random() * ((120 - 0) + 1) + 0));
                responseElement.return_x.daysPastDueCnt04 = Integer.valueOf(Math.floor(Math.random() * ((120 - 0) + 1) + 0));
                responseElement.return_x.daysPastDueCnt05 = Integer.valueOf(Math.floor(Math.random() * ((120 - 0) + 1) + 0));
                responseElement.return_x.daysPastDueCnt06 = Integer.valueOf(Math.floor(Math.random() * ((120 - 0) + 1) + 0));
                responseElement.return_x.daysPastDueCnt07 = Integer.valueOf(Math.floor(Math.random() * ((120 - 0) + 1) + 0));
                responseElement.return_x.daysPastDueCnt08 = Integer.valueOf(Math.floor(Math.random() * ((120 - 0) + 1) + 0));
                responseElement.return_x.daysPastDueCnt09 = Integer.valueOf(Math.floor(Math.random() * ((120 - 0) + 1) + 0));
                responseElement.return_x.daysPastDueCnt10 = Integer.valueOf(Math.floor(Math.random() * ((120 - 0) + 1) + 0));
                responseElement.return_x.daysPastDueCnt11 = Integer.valueOf(Math.floor(Math.random() * ((120 - 0) + 1) + 0));
                responseElement.return_x.daysPastDueCnt12 = Integer.valueOf(Math.floor(Math.random() * ((120 - 0) + 1) + 0));
                responseElement.return_x.daysPastDueCnt13 = Integer.valueOf(Math.floor(Math.random() * ((120 - 0) + 1) + 0));
                responseElement.return_x.daysPastDueCnt14 = Integer.valueOf(Math.floor(Math.random() * ((120 - 0) + 1) + 0));
                responseElement.return_x.daysPastDueCnt15 = Integer.valueOf(Math.floor(Math.random() * ((120 - 0) + 1) + 0));
                responseElement.return_x.daysPastDueCnt16 = Integer.valueOf(Math.floor(Math.random() * ((120 - 0) + 1) + 0));
                responseElement.return_x.daysPastDueCnt17 = Integer.valueOf(Math.floor(Math.random() * ((120 - 0) + 1) + 0));
                responseElement.return_x.daysPastDueCnt18 = Integer.valueOf(Math.floor(Math.random() * ((120 - 0) + 1) + 0));
                responseElement.return_x.daysPastDueCnt19 = Integer.valueOf(Math.floor(Math.random() * ((120 - 0) + 1) + 0));
                responseElement.return_x.daysPastDueCnt20 = Integer.valueOf(Math.floor(Math.random() * ((120 - 0) + 1) + 0));
                responseElement.return_x.daysPastDueCnt21 = Integer.valueOf(Math.floor(Math.random() * ((120 - 0) + 1) + 0));
                responseElement.return_x.daysPastDueCnt22 = Integer.valueOf(Math.floor(Math.random() * ((120 - 0) + 1) + 0));
                responseElement.return_x.daysPastDueCnt23 = Integer.valueOf(Math.floor(Math.random() * ((120 - 0) + 1) + 0));
                responseElement.return_x.daysPastDueCnt24 = Integer.valueOf(Math.floor(Math.random() * ((120 - 0) + 1) + 0));
                responseElement.return_x.daysPastDueCnt25 = Integer.valueOf(Math.floor(Math.random() * ((120 - 0) + 1) + 0));
                responseElement.return_x.cycleCloseDt00 = (Datetime) JSON.deserialize('"2017-03-31T00:00:00-05:00"', Datetime.class);
                responseElement.return_x.cycleCloseDt01 = (Datetime) JSON.deserialize('"2017-03-30T00:00:00-05:00"', Datetime.class);
                responseElement.return_x.cycleCloseDt02 = (Datetime) JSON.deserialize('"2017-03-29T00:00:00-05:00"', Datetime.class);
                responseElement.return_x.cycleCloseDt03 = (Datetime) JSON.deserialize('"2017-03-28T00:00:00-05:00"', Datetime.class);
                responseElement.return_x.cycleCloseDt04 = (Datetime) JSON.deserialize('"2017-03-27T00:00:00-05:00"', Datetime.class);
                responseElement.return_x.cycleCloseDt05 = (Datetime) JSON.deserialize('"2017-03-24T00:00:00-05:00"', Datetime.class);
                responseElement.return_x.cycleCloseDt06 = (Datetime) JSON.deserialize('"2017-03-23T00:00:00-05:00"', Datetime.class);
                responseElement.return_x.cycleCloseDt07 = (Datetime) JSON.deserialize('"2017-03-22T00:00:00-05:00"', Datetime.class);
                responseElement.return_x.cycleCloseDt08 = (Datetime) JSON.deserialize('"2017-03-21T00:00:00-05:00"', Datetime.class);
                responseElement.return_x.cycleCloseDt09 = (Datetime) JSON.deserialize('"2017-03-20T00:00:00-05:00"', Datetime.class);
                responseElement.return_x.cycleCloseDt10 = (Datetime) JSON.deserialize('"2017-03-17T00:00:00-05:00"', Datetime.class);
                responseElement.return_x.cycleCloseDt11 = (Datetime) JSON.deserialize('"2017-03-16T00:00:00-05:00"', Datetime.class);
                responseElement.return_x.cycleCloseDt12 = (Datetime) JSON.deserialize('"2017-03-15T00:00:00-05:00"', Datetime.class);
                responseElement.return_x.cycleCloseDt13 = (Datetime) JSON.deserialize('"2017-03-14T00:00:00-05:00"', Datetime.class);
                responseElement.return_x.cycleCloseDt14 = (Datetime) JSON.deserialize('"2017-03-13T00:00:00-05:00"', Datetime.class);
                responseElement.return_x.cycleCloseDt15 = (Datetime) JSON.deserialize('"2017-03-10T00:00:00-05:00"', Datetime.class);
                responseElement.return_x.cycleCloseDt16 = (Datetime) JSON.deserialize('"2017-03-09T00:00:00-05:00"', Datetime.class);
                responseElement.return_x.cycleCloseDt17 = (Datetime) JSON.deserialize('"2017-03-08T00:00:00-05:00"', Datetime.class);
                responseElement.return_x.cycleCloseDt18 = (Datetime) JSON.deserialize('"2017-03-07T00:00:00-05:00"', Datetime.class);
                responseElement.return_x.cycleCloseDt19 = (Datetime) JSON.deserialize('"2017-03-06T00:00:00-05:00"', Datetime.class);
                responseElement.return_x.cycleCloseDt20 = (Datetime) JSON.deserialize('"2017-03-03T00:00:00-05:00"', Datetime.class);
                responseElement.return_x.cycleCloseDt21 = (Datetime) JSON.deserialize('"2017-03-02T00:00:00-05:00"', Datetime.class);
                responseElement.return_x.cycleCloseDt22 = (Datetime) JSON.deserialize('"2017-03-01T00:00:00-05:00"', Datetime.class);
                responseElement.return_x.cycleCloseDt23 = null;
                responseElement.return_x.cycleCloseDt24 = null;
                responseElement.return_x.cycleCloseDt25 = null;
                responseElement.return_x.dnbViabilityRate = Integer.valueOf(Math.floor(Math.random() * ((120 - 0) + 1) + 0));
                responseElement.return_x.hrcFeeAmt = 0.00;
                responseElement.return_x.hrcFeeEffDt = (Datetime) JSON.deserialize('"1970-01-01T00:00:00-05:00"', Datetime.class);
                responseElement.return_x.hrcFeeExpnDt = (Datetime) JSON.deserialize('"9999-12-31T00:00:00-05:00"', Datetime.class);
                responseElement.return_x.hrcFeeWaiveEndDt = (Datetime) JSON.deserialize('"9999-12-31T00:00:00-05:00"', Datetime.class);
                responseElement.return_x.lastWaiveDt = (Datetime) JSON.deserialize('"1970-01-01T00:00:00-05:00"', Datetime.class);
                responseElement.return_x.lateFeeCnt00 = Integer.valueOf(Math.floor(Math.random() * ((23 - 0) + 1) + 0));
                responseElement.return_x.lateFeeCnt01 = Integer.valueOf(Math.floor(Math.random() * ((23 - 0) + 1) + 0));
                responseElement.return_x.lateFeeCnt02 = Integer.valueOf(Math.floor(Math.random() * ((23 - 0) + 1) + 0));
                responseElement.return_x.lateFeeCnt03 = Integer.valueOf(Math.floor(Math.random() * ((23 - 0) + 1) + 0));
                responseElement.return_x.lateFeeCnt04 = Integer.valueOf(Math.floor(Math.random() * ((23 - 0) + 1) + 0));
                responseElement.return_x.lateFeeCnt05 = Integer.valueOf(Math.floor(Math.random() * ((23 - 0) + 1) + 0));
                responseElement.return_x.lateFeeCnt06 = Integer.valueOf(Math.floor(Math.random() * ((23 - 0) + 1) + 0));
                responseElement.return_x.lateFeeCnt07 = Integer.valueOf(Math.floor(Math.random() * ((23 - 0) + 1) + 0));
                responseElement.return_x.lateFeeCnt08 = Integer.valueOf(Math.floor(Math.random() * ((23 - 0) + 1) + 0));
                responseElement.return_x.lateFeeCnt09 = Integer.valueOf(Math.floor(Math.random() * ((23 - 0) + 1) + 0));
                responseElement.return_x.lateFeeCnt10 = Integer.valueOf(Math.floor(Math.random() * ((23 - 0) + 1) + 0));
                responseElement.return_x.lateFeeCnt11 = Integer.valueOf(Math.floor(Math.random() * ((23 - 0) + 1) + 0));
                responseElement.return_x.nsfCnt00 = Integer.valueOf(Math.floor(Math.random() * ((23 - 0) + 1) + 0));
                responseElement.return_x.nsfCnt01 = Integer.valueOf(Math.floor(Math.random() * ((23 - 0) + 1) + 0));
                responseElement.return_x.nsfCnt02 = Integer.valueOf(Math.floor(Math.random() * ((23 - 0) + 1) + 0));
                responseElement.return_x.nsfCnt03 = Integer.valueOf(Math.floor(Math.random() * ((23 - 0) + 1) + 0));
                responseElement.return_x.nsfCnt04 = Integer.valueOf(Math.floor(Math.random() * ((23 - 0) + 1) + 0));
                responseElement.return_x.nsfCnt05 = Integer.valueOf(Math.floor(Math.random() * ((23 - 0) + 1) + 0));
                responseElement.return_x.nsfCnt06 = Integer.valueOf(Math.floor(Math.random() * ((23 - 0) + 1) + 0));
                responseElement.return_x.nsfCnt07 = Integer.valueOf(Math.floor(Math.random() * ((23 - 0) + 1) + 0));
                responseElement.return_x.nsfCnt08 = Integer.valueOf(Math.floor(Math.random() * ((23 - 0) + 1) + 0));
                responseElement.return_x.nsfCnt09 = Integer.valueOf(Math.floor(Math.random() * ((23 - 0) + 1) + 0));
                responseElement.return_x.nsfCnt10 = Integer.valueOf(Math.floor(Math.random() * ((23 - 0) + 1) + 0));
                responseElement.return_x.nsfCnt11 = Integer.valueOf(Math.floor(Math.random() * ((23 - 0) + 1) + 0));
                responseElement.return_x.riskCode = '9';

                response.put('response_x', responseElement);

            } else {

                CustomerDetailsWSUtilv2.getAgingHistoryResponse responseElement = new CustomerDetailsWSUtilv2.getAgingHistoryResponse();

                responseElement.return_x = new CustomerDetailsWSUtilv2.agingHistory();

                responseElement.return_x.errorMsg = 'Could not find specified account!';

                response.put('response_x', responseElement);

            }

        } else if (request instanceof CustomerDetailsWSUtilv2.getCustomerDetails) {

            CustomerDetailsWSUtilv2.getCustomerDetails getCustomerDetailsObject = (CustomerDetailsWSUtilv2.getCustomerDetails) request;

            CustomerDetailsWSUtilv2.customerDetailsRequest customerDetailsRequest = (CustomerDetailsWSUtilv2.customerDetailsRequest) getCustomerDetailsObject.arg0;

            if ((customerDetailsRequest.accountID).equalsIgnoreCase('9100000000000')) {

                CustomerDetailsWSUtilv2.getCustomerDetailsResponse responseElement = new CustomerDetailsWSUtilv2.getCustomerDetailsResponse();

                responseElement.return_x = new CustomerDetailsWSUtilv2.customerDetails();

                responseElement.return_x.accountNbrType = 'Internal';
                responseElement.return_x.accountNm = 'Hub Cap Annie &amp; Wheel of Idaho Inc';
                responseElement.return_x.accountSinceDt = (Datetime) JSON.deserialize('"2015-04-15T00:00:00-04:00"', Datetime.class);
                responseElement.return_x.accountSts = 'A';
                responseElement.return_x.accountStsDt = (Datetime) JSON.deserialize('"2015-04-15T00:00:00-04:00"', Datetime.class);
                responseElement.return_x.accountingFee = 10.00;
                responseElement.return_x.accountingFeeDescription = 'Accounting Fee';
                responseElement.return_x.acctRowId = '2-ZZZZZ-011';
                responseElement.return_x.availableCreditLmt = 7179.69;
                responseElement.return_x.billingAccountId = '9100000000000';
                responseElement.return_x.billtoAccountNm = 'Hub Cap Annie &amp; Wheel of Idaho Inc';
                responseElement.return_x.cashEnabledIndicator = false;
                responseElement.return_x.clearViewCustomer = true;
                responseElement.return_x.contractEndDt = (Datetime) JSON.deserialize('"9999-12-31T00:00:00-05:00"', Datetime.class);
                responseElement.return_x.contractName = 'Dummy Customer Contract Name: 9100003325428';
                responseElement.return_x.contractNm = 'Dummy Contract Name: 9100003325428';
                responseElement.return_x.contractStartDt = (Datetime) JSON.deserialize('"1970-01-01T00:00:00-05:00"', Datetime.class);
                responseElement.return_x.costPlusIndicator = true;
                responseElement.return_x.creditScore = 85;
                responseElement.return_x.currentBillingCycle = 2;
                responseElement.return_x.currentInvoiceClosingDt = (Datetime) JSON.deserialize('"9999-12-31T00:00:00-05:00"', Datetime.class);
                responseElement.return_x.currentInvoiceDueDt = (Datetime) JSON.deserialize('"9999-12-31T00:00:00-05:00"', Datetime.class);
                responseElement.return_x.customerId = '4715696';
                responseElement.return_x.customerIdentifier = '4715696';
                responseElement.return_x.customerNm = 'Hub Cap Annie &amp; Wheel of Idaho Inc';
                responseElement.return_x.customerSegmentation = '3';
                responseElement.return_x.customerSinceDt = (Datetime) JSON.deserialize('"2015-04-15T00:00:00-04:00"', Datetime.class);
                responseElement.return_x.daysToPay = 26;
                responseElement.return_x.discountIndicator = true;
                responseElement.return_x.evergreenIndicator = false;
                responseElement.return_x.financeChargeRteType = 'Negotiated, Waived Finance Chg';
                responseElement.return_x.fleetOneCustomer = false;
                responseElement.return_x.flexCardCustomer = false;
                responseElement.return_x.flexCardPenaltyPricingIndicator = 'N';
                responseElement.return_x.funder = 'FSC';
                responseElement.return_x.highCreditRiskFeeIndicator = false;
                responseElement.return_x.highRiskCureDt = (Datetime) JSON.deserialize('"9999-12-31T00:00:00-05:00"', Datetime.class);
                responseElement.return_x.lastPaymentDt = (Datetime) JSON.deserialize('"9999-12-31T00:00:00-05:00"', Datetime.class);
                responseElement.return_x.masterCardCustomer = false;
                responseElement.return_x.memberSinceDt = (Datetime) JSON.deserialize('"2000-12-31T00:00:00-05:00"', Datetime.class);
                responseElement.return_x.monthlyCardFee = 4;
                responseElement.return_x.outOfNetworkPerTxnFee = 1.0;
                responseElement.return_x.outOfNetworkProgramOrAccountRte = '0.25';
                responseElement.return_x.paperWithFeeWaived = 'N';
                responseElement.return_x.paperless = 'Y';
                responseElement.return_x.partnerFleetCustomer = false;
                responseElement.return_x.partnerRebateIndicator = false;
                responseElement.return_x.pendingTxns = 0.0;
                responseElement.return_x.pfsRepNm = '000 - Tom';
                responseElement.return_x.programId = '1-12N3P99';
                responseElement.return_x.programMaintenanceCharge = '.02 Descriptor';
                responseElement.return_x.programNm = 'WEX DIRECT UNIVERSAL';
                responseElement.return_x.sourceSys = 'SIEBEL';
                responseElement.return_x.spnrAccountNbr = '0496000000000';
                responseElement.return_x.telematicsCustomer = true;
                responseElement.return_x.truckStopFee = 0.0;
                responseElement.return_x.WEXFleetCustomer = true;
                responseElement.return_x.wexAccountNbr = '9100000000000';
                responseElement.return_x.wexRebateIndicator = false;
                responseElement.return_x.wrightRewardsCustomer = false;
                responseElement.return_x.paperDeliveryFee = 10.00;
                responseElement.return_x.creditLmt = 8000.00;
                responseElement.return_x.lastInvoiceBilledAmt = 4000.00;
                responseElement.return_x.unbilledAmt = 1000.00;
                responseElement.return_x.contractNbr = 'WEX-000001';
                responseElement.return_x.periodicFinanceChargeRte = 18.25;
                responseElement.return_x.flexCardApplicableRte = 18.25;
                responseElement.return_x.highRiskPercentageRte = 18.25;
                responseElement.return_x.onlineApplication = 'WOL NP';
                responseElement.return_x.description = 'Only accept calls from Mark!';
                responseElement.return_x.monthlyCardFeeDescription = 'TFS';
                responseElement.return_x.truckStopFeeDescription = 'Waived';
                responseElement.return_x.servicingRules = 'Proceed with caution.';
                responseElement.return_x.collectionRiskScore = 999;
                responseElement.return_x.pastDueAmount = 1000.00;
                responseElement.return_x.reactivationFee = 50.00;
                responseElement.return_x.reactivationFeeDescription = 'Reactivation Fee';
                responseElement.return_x.overLimitFee = 75.00;
                responseElement.return_x.overLimitFeeDescription = 'OCL Fee';
                responseElement.return_x.nsfFee = 50.00;
                responseElement.return_x.nsfFeeDescription = 'NSF Fee';


                CustomerDetailsWSUtilv2.address AlternateAddress = new CustomerDetailsWSUtilv2.address();
                AlternateAddress.addr1 = '123 Darling Ave';
                AlternateAddress.addr2 = 'Filler';
                AlternateAddress.addr3 = 'Filler';
                AlternateAddress.addr4 = 'Filler';
                AlternateAddress.city = 'South Portland';
                AlternateAddress.state = 'ME';
                AlternateAddress.country = 'US';
                AlternateAddress.orgName = 'WEX';
                AlternateAddress.postalCode = '04106';

                responseElement.return_x.alternateAddress = AlternateAddress;

                CustomerDetailsWSUtilv2.address BillingAddress = new CustomerDetailsWSUtilv2.address();
                BillingAddress.addr1 = '123 Darling Ave';
                BillingAddress.addr2 = 'Filler';
                BillingAddress.addr3 = 'Filler';
                BillingAddress.addr4 = 'Filler';
                BillingAddress.city = 'South Portland';
                BillingAddress.state = 'ME';
                BillingAddress.country = 'US';
                BillingAddress.orgName = 'WEX';
                BillingAddress.postalCode = '04106';

                responseElement.return_x.billingAddress = BillingAddress;

                CustomerDetailsWSUtilv2.address MailingAddress = new CustomerDetailsWSUtilv2.address();
                MailingAddress.addr1 = '123 Darling Ave';
                MailingAddress.addr2 = 'Filler';
                MailingAddress.addr3 = 'Filler';
                MailingAddress.addr4 = 'Filler';
                MailingAddress.city = 'South Portland';
                MailingAddress.state = 'ME';
                MailingAddress.country = 'US';
                MailingAddress.orgName = 'WEX';
                MailingAddress.postalCode = '04106';

                responseElement.return_x.mailingAddress = MailingAddress;

                CustomerDetailsWSUtilv2.address PrimaryAddress = new CustomerDetailsWSUtilv2.address();
                PrimaryAddress.addr1 = '123 Darling Ave';
                PrimaryAddress.addr2 = 'Filler';
                PrimaryAddress.addr3 = 'Filler';
                PrimaryAddress.addr4 = 'Filler';
                PrimaryAddress.city = 'South Portland';
                PrimaryAddress.state = 'ME';
                PrimaryAddress.country = 'US';
                PrimaryAddress.orgName = 'WEX';
                PrimaryAddress.postalCode = '04106';

                responseElement.return_x.primaryAddress = PrimaryAddress;

                CustomerDetailsWSUtilv2.address ShippingAddress = new CustomerDetailsWSUtilv2.address();
                ShippingAddress.addr1 = '123 Darling Ave';
                ShippingAddress.addr2 = 'Filler';
                ShippingAddress.addr3 = 'Filler';
                ShippingAddress.addr4 = 'Filler';
                ShippingAddress.city = 'South Portland';
                ShippingAddress.state = 'ME';
                ShippingAddress.country = 'US';
                ShippingAddress.orgName = 'WEX';
                ShippingAddress.postalCode = '04106';

                responseElement.return_x.shippingAddress = ShippingAddress;

                responseElement.return_x.contacts = generateContacts().return_x;

                if (customerDetailsRequest.pdRowId != null && !(String.isEmpty(customerDetailsRequest.pdRowId))) {
                    CustomerDetailsWSUtilv2.pdAsset asset = new CustomerDetailsWSUtilv2.pdAsset();
                    asset.pdRowId = customerDetailsRequest.pdRowId;
                    asset.wexAcctNbr = responseElement.return_x.wexAccountNbr;
                    asset.vin = 'AA12B3CH1B1234567';
                    asset.cardNbr = '1234-1';
                    asset.gsaRegion = 'REG XX';
                    asset.custAssetNbr = 'G99 9995Z';
                    asset.assetMake = 'Plymouth';
                    asset.assetModel = 'Barracuda';
                    asset.assetYear = '1999';
                    asset.cardRestr = 'Unrestricted';
                    asset.odometer = 99999;
                    asset.odometerDate = Datetime.newInstance(2099, 12, 31, 23, 59, 59);
                    asset.pdStatus = 'Active';
                    asset.pdStatusdate = '2018-12-31';

                    responseElement.return_x.pdAsset = asset;
                }

                response.put('response_x', responseElement);

            } else if ((customerDetailsRequest.accountID).equalsIgnoreCase('123456') && (customerDetailsRequest.accountIdType.equalsIgnoreCase('EFSLLC'))) {

                CustomerDetailsWSUtilv2.getCustomerDetailsResponse responseElement = new CustomerDetailsWSUtilv2.getCustomerDetailsResponse();

                responseElement.return_x = new CustomerDetailsWSUtilv2.customerDetails();

                responseElement.return_x.accountNbrType = 'EFSLLC';
                responseElement.return_x.accountNm = 'Hub Cap Annie &amp; Wheel of Idaho Inc';
                responseElement.return_x.accountSinceDt = (Datetime) JSON.deserialize('"2015-04-15T00:00:00-04:00"', Datetime.class);
                responseElement.return_x.accountSts = 'A';
                responseElement.return_x.accountStsDt = (Datetime) JSON.deserialize('"2015-04-15T00:00:00-04:00"', Datetime.class);
                responseElement.return_x.accountingFee = 10.00;
                responseElement.return_x.accountingFeeDescription = 'Accounting Fee';
                responseElement.return_x.acctRowId = 'EFSLLC-123456-CO';
                responseElement.return_x.arNumber = '9100000000000';
                responseElement.return_x.availableCreditLmt = 7179.69;
                responseElement.return_x.billingAccountId = '9100000000000';
                responseElement.return_x.billtoAccountNm = 'Hub Cap Annie &amp; Wheel of Idaho Inc';
                responseElement.return_x.cashEnabledIndicator = false;
                responseElement.return_x.clearViewCustomer = true;
                responseElement.return_x.contractEndDt = (Datetime) JSON.deserialize('"9999-12-31T00:00:00-05:00"', Datetime.class);
                responseElement.return_x.contractName = 'Dummy Customer Contract Name: 9100003325428';
                responseElement.return_x.contractNm = 'Dummy Contract Name: 9100003325428';
                responseElement.return_x.contractStartDt = (Datetime) JSON.deserialize('"1970-01-01T00:00:00-05:00"', Datetime.class);
                responseElement.return_x.costPlusIndicator = true;
                responseElement.return_x.creditScore = 85;
                responseElement.return_x.currentBillingCycle = 2;
                responseElement.return_x.currentInvoiceClosingDt = (Datetime) JSON.deserialize('"9999-12-31T00:00:00-05:00"', Datetime.class);
                responseElement.return_x.currentInvoiceDueDt = (Datetime) JSON.deserialize('"9999-12-31T00:00:00-05:00"', Datetime.class);
                responseElement.return_x.customerId = '4715696';
                responseElement.return_x.customerIdentifier = '4715696';
                responseElement.return_x.customerNm = 'Hub Cap Annie &amp; Wheel of Idaho Inc';
                responseElement.return_x.customerSegmentation = '3';
                responseElement.return_x.customerSinceDt = (Datetime) JSON.deserialize('"2015-04-15T00:00:00-04:00"', Datetime.class);
                responseElement.return_x.daysToPay = 26;
                responseElement.return_x.discountIndicator = true;
                responseElement.return_x.evergreenIndicator = false;
                responseElement.return_x.financeChargeRteType = 'Negotiated, Waived Finance Chg';
                responseElement.return_x.fleetOneCustomer = false;
                responseElement.return_x.flexCardCustomer = false;
                responseElement.return_x.flexCardPenaltyPricingIndicator = 'N';
                responseElement.return_x.funder = 'FSC';
                responseElement.return_x.highCreditRiskFeeIndicator = false;
                responseElement.return_x.highRiskCureDt = (Datetime) JSON.deserialize('"9999-12-31T00:00:00-05:00"', Datetime.class);
                responseElement.return_x.lastPaymentDt = (Datetime) JSON.deserialize('"9999-12-31T00:00:00-05:00"', Datetime.class);
                responseElement.return_x.masterCardCustomer = false;
                responseElement.return_x.memberSinceDt = (Datetime) JSON.deserialize('"2000-12-31T00:00:00-05:00"', Datetime.class);
                responseElement.return_x.monthlyCardFee = 4;
                responseElement.return_x.outOfNetworkPerTxnFee = 1.0;
                responseElement.return_x.outOfNetworkProgramOrAccountRte = '0.25';
                responseElement.return_x.paperWithFeeWaived = 'N';
                responseElement.return_x.paperless = 'Y';
                responseElement.return_x.partnerFleetCustomer = false;
                responseElement.return_x.partnerRebateIndicator = false;
                responseElement.return_x.pendingTxns = 0.0;
                responseElement.return_x.pfsRepNm = '000 - Tom';
                responseElement.return_x.programId = '1-12N3P99';
                responseElement.return_x.programMaintenanceCharge = '.02 Descriptor';
                responseElement.return_x.programNm = 'WEX DIRECT UNIVERSAL';
                responseElement.return_x.sourceSys = 'SIEBEL';
                responseElement.return_x.spnrAccountNbr = '0496000000000';
                responseElement.return_x.telematicsCustomer = true;
                responseElement.return_x.truckStopFee = 0.0;
                responseElement.return_x.WEXFleetCustomer = true;
                responseElement.return_x.wexAccountNbr = '9100000000000';
                responseElement.return_x.wexRebateIndicator = false;
                responseElement.return_x.wrightRewardsCustomer = false;
                responseElement.return_x.paperDeliveryFee = 10.00;
                responseElement.return_x.creditLmt = 8000.00;
                responseElement.return_x.lastInvoiceBilledAmt = 4000.00;
                responseElement.return_x.unbilledAmt = 1000.00;
                responseElement.return_x.contractNbr = 'WEX-000001';
                responseElement.return_x.periodicFinanceChargeRte = 18.25;
                responseElement.return_x.flexCardApplicableRte = 18.25;
                responseElement.return_x.highRiskPercentageRte = 18.25;
                responseElement.return_x.onlineApplication = 'WOL NP';
                responseElement.return_x.description = 'Only accept calls from Mark!';
                responseElement.return_x.monthlyCardFeeDescription = 'TFS';
                responseElement.return_x.truckStopFeeDescription = 'Waived';
                responseElement.return_x.servicingRules = 'Proceed with caution.';
                responseElement.return_x.collectionRiskScore = 999;
                responseElement.return_x.pastDueAmount = 1000.00;
                responseElement.return_x.reactivationFee = 50.00;
                responseElement.return_x.reactivationFeeDescription = 'Reactivation Fee';
                responseElement.return_x.overLimitFee = 75.00;
                responseElement.return_x.overLimitFeeDescription = 'OCL Fee';
                responseElement.return_x.nsfFee = 50.00;
                responseElement.return_x.nsfFeeDescription = 'NSF Fee';


                CustomerDetailsWSUtilv2.address BillingAddress = new CustomerDetailsWSUtilv2.address();
                BillingAddress.addr1 = '123 Darling Ave';
                BillingAddress.addr2 = 'Filler';
                BillingAddress.addr3 = 'Filler';
                BillingAddress.addr4 = 'Filler';
                BillingAddress.city = 'South Portland';
                BillingAddress.state = 'ME';
                BillingAddress.country = 'US';
                BillingAddress.orgName = 'WEX';
                BillingAddress.postalCode = '04106';

                responseElement.return_x.billingAddress = BillingAddress;

                CustomerDetailsWSUtilv2.address MailingAddress = new CustomerDetailsWSUtilv2.address();
                MailingAddress.addr1 = '123 Darling Ave';
                MailingAddress.addr2 = 'Filler';
                MailingAddress.addr3 = 'Filler';
                MailingAddress.addr4 = 'Filler';
                MailingAddress.city = 'South Portland';
                MailingAddress.state = 'ME';
                MailingAddress.country = 'US';
                MailingAddress.orgName = 'WEX';
                MailingAddress.postalCode = '04106';

                responseElement.return_x.mailingAddress = MailingAddress;

                CustomerDetailsWSUtilv2.address ShippingAddress = new CustomerDetailsWSUtilv2.address();
                ShippingAddress.addr1 = '123 Darling Ave';
                ShippingAddress.addr2 = 'Filler';
                ShippingAddress.addr3 = 'Filler';
                ShippingAddress.addr4 = 'Filler';
                ShippingAddress.city = 'South Portland';
                ShippingAddress.state = 'ME';
                ShippingAddress.country = 'US';
                ShippingAddress.orgName = 'WEX';
                ShippingAddress.postalCode = '04106';

                responseElement.return_x.shippingAddress = ShippingAddress;

                responseElement.return_x.contacts = generateContacts().return_x;

                response.put('response_x', responseElement);

            } else {

                CustomerDetailsWSUtilv2.getCustomerDetailsResponse responseElement = new CustomerDetailsWSUtilv2.getCustomerDetailsResponse();

                responseElement.return_x = new CustomerDetailsWSUtilv2.customerDetails();

                responseElement.return_x.errorMsg = 'Could not find specified account!';

                response.put('response_x', responseElement);

            }

        } else if (request instanceof CustomerDetailsWSUtilv2.getContacts) {

            CustomerDetailsWSUtilv2.getContacts getContactsObject = (CustomerDetailsWSUtilv2.getContacts) request;

            CustomerDetailsWSUtilv2.customerDetailsRequest customerDetailsRequest = (CustomerDetailsWSUtilv2.customerDetailsRequest) getContactsObject.arg0;

            if ((customerDetailsRequest.accountID).equalsIgnoreCase('9100000000000')) {

                CustomerDetailsWSUtilv2.getContactsResponse responseElement = generateContacts();

                response.put('response_x', responseElement);

            } else {

                CustomerDetailsWSUtilv2.getContactsResponse responseElement = new CustomerDetailsWSUtilv2.getContactsResponse();

                responseElement.return_x = new CustomerDetailsWSUtilv2.contacts();

                responseElement.return_x.errorMsg = 'Could not find specified account!';

                response.put('response_x', responseElement);

            }

        } else if (request instanceof CustomerDetailsWSUtilv2.getRecentDeclinedAuths) {

            CustomerDetailsWSUtilv2.getRecentDeclinedAuths getRecentDeclinedAuthsObject = (CustomerDetailsWSUtilv2.getRecentDeclinedAuths) request;

            if (!(getRecentDeclinedAuthsObject.wexAcctNbr).equalsIgnoreCase('9100000000000')) {

                CustomerDetailsWSUtilv2.getRecentDeclinedAuthsResponse responseElement = new CustomerDetailsWSUtilv2.getRecentDeclinedAuthsResponse();

                responseElement.return_x = new CustomerDetailsWSUtilv2.authSearchResult();

                responseElement.return_x.authLog = new CustomerDetailsWSUtilv2.authLogRecord[]{
                };

                CustomerDetailsWSUtilv2.authLogRecord authLog1 = new CustomerDetailsWSUtilv2.authLogRecord();

                authLog1.actionCode = '180';
                authLog1.actionCodeDescription = 'Invalid Driver ID';
                authLog1.cardNumber = '*******************12341';
                authLog1.driverId = '123456';
                authLog1.merchantSite = 'WX222333';
                authLog1.txnDt = (Datetime) JSON.deserialize('"2018-03-07T00:00:00-05:00"', Datetime.class);

                CustomerDetailsWSUtilv2.address MerchantAddress = new CustomerDetailsWSUtilv2.address();
                MerchantAddress.addr1 = '123 DARLING AVE';
                MerchantAddress.addr2 = 'Filler';
                MerchantAddress.addr3 = 'Filler';
                MerchantAddress.addr4 = 'Filler';
                MerchantAddress.city = 'SO PORTLAND';
                MerchantAddress.state = 'ME';
                MerchantAddress.country = 'US';
                MerchantAddress.orgName = 'WRIGHT EXPRESS CARDLOCKS INC';
                MerchantAddress.postalCode = '041061111';

                authLog1.merchantAddress = MerchantAddress;

                responseElement.return_x.authLog.add(authLog1);

                CustomerDetailsWSUtilv2.authLogRecord authLog2 = new CustomerDetailsWSUtilv2.authLogRecord();

                authLog2.actionCode = '109';
                authLog2.actionCodeDescription = 'Invalid Site';
                authLog2.cardNumber = '*******************12341';
                authLog2.driverId = '123456';
                authLog2.merchantSite = 'WX222333';
                authLog2.txnDt = (Datetime) JSON.deserialize('"2018-03-08T00:00:00-05:00"', Datetime.class);
                authLog2.merchantAddress = MerchantAddress;
                responseElement.return_x.authLog.add(authLog2);

                response.put('response_x', responseElement);

            } else {

                CustomerDetailsWSUtilv2.getRecentDeclinedAuthsResponse responseElement = new CustomerDetailsWSUtilv2.getRecentDeclinedAuthsResponse();

                responseElement.return_x = new CustomerDetailsWSUtilv2.authSearchResult();

                responseElement.return_x.errorMsg = 'Could not find specified account!';

                response.put('response_x', responseElement);

            }

        }

        else if (request instanceof CustomerDetailsWSUtilv2.getPayments) {

            CustomerDetailsWSUtilv2.getPayments getPaymentsObject = (CustomerDetailsWSUtilv2.getPayments) request;

            if ((getPaymentsObject.wexAcctNbr).equalsIgnoreCase('9100000000000')) {

                CustomerDetailsWSUtilv2.getPaymentsResponse responseElement = new CustomerDetailsWSUtilv2.getPaymentsResponse();

                responseElement.return_x = new CustomerDetailsWSUtilv2.payments();

                //This is the dummy version
                CustomerDetailsWSUtilv2.paymentDetailEntry[] paymentDetails = new CustomerDetailsWSUtilv2.paymentDetailEntry[]{
                };
                CustomerDetailsWSUtilv2.paymentHistoryEntry[] paymentHistory = new CustomerDetailsWSUtilv2.paymentHistoryEntry[]{
                };
                CustomerDetailsWSUtilv2.pendingPaymentEntry[] pendingPayments = new CustomerDetailsWSUtilv2.pendingPaymentEntry[]{
                };
                Double oldBalance = 1200.00;
                Integer minusI;
                for (Integer i = 1; i <= 12; i++) {
                    CustomerDetailsWSUtilv2.paymentDetailEntry entry = new CustomerDetailsWSUtilv2.paymentDetailEntry();
                    minusI = 13 - i;
                    entry.id = '' + i;
                    entry.depositId = 'DEPOSIT_' + i;
                    entry.paymentId = 'PAYMENT_' + i;
                    entry.accountingDt = Datetime.newInstance(2017, minusI, minusI);
                    entry.postingDt = Datetime.newInstance(2017, minusI, minusI);
                    entry.paymentAmt = 1111.11 * minusI;
                    entry.currencyCd = 'USD';
                    paymentDetails.add(entry);

                    CustomerDetailsWSUtilv2.paymentHistoryEntry history = new CustomerDetailsWSUtilv2.paymentHistoryEntry();
                    history.id = '' + minusI;
                    history.cls = '00';
                    history.cycleEndDt = Datetime.newInstance(2017, i, 15);
                    history.dueDt = history.cycleEndDt.addDays(21);
                    history.salesAmt = 1111.11 * i;
                    history.lateFeeAmt = 75.00;
                    history.paymentAmt = oldBalance * -1;
                    history.adjustmentAmt = Math.mod(Math.roundToLong(Math.random() * 10000), 2) * 10.00;
                    history.epiBasisAmt = 0.00;
                    history.balanceAmt = oldBalance + history.salesAmt + history.lateFeeAmt + history.adjustmentAmt + history.paymentAmt;
                    history.ocl = 'N';
                    paymentHistory.add(history);
                    oldBalance = history.balanceAmt;
                }
                CustomerDetailsWSUtilv2.pendingPaymentEntry pendingPayment = new CustomerDetailsWSUtilv2.pendingPaymentEntry();
                pendingPayment.amount = 199.99;
                pendingPayment.payId = 'WOL12320190101';
                pendingPayment.postingDate = Datetime.now().addDays(3);
                pendingPayment.scheduledDate = Datetime.now().addDays(-7);
                pendingpayment.updateDate = Datetime.now().addDays(-3);
                pendingPayment.source = 'Classic';
                pendingPayment.status = 'Scheduled';
                pendingPayments.add(pendingPayment);

                pendingPayment = new CustomerDetailsWSUtilv2.pendingPaymentEntry();
                pendingPayment.amount = 299.99;
                pendingPayment.payId = 'IVR12320190105';
                pendingPayment.postingDate = Datetime.now().addDays(1);
                pendingPayment.scheduledDate = Datetime.now().addDays(-7);
                pendingpayment.updateDate = Datetime.now().addDays(-3);
                pendingPayment.source = 'IVR';
                pendingPayment.status = 'Pending';
                pendingPayments.add(pendingPayment);


                responseElement.return_x.paymentDetails = paymentDetails;
                responseElement.return_x.paymentHistory = paymentHistory;
                responseElement.return_x.pendingPayments = pendingPayments;
                responseElement.return_x.errorMsg = 'Generated demo data';
                response.put('response_x', responseElement);
            } else {

                CustomerDetailsWSUtilv2.getPaymentsResponse responseElement = new CustomerDetailsWSUtilv2.getPaymentsResponse();

                responseElement.return_x = new CustomerDetailsWSUtilv2.payments();

                responseElement.return_x.errorMsg = 'Unable to retrieve specified account!';

                response.put('response_x', responseElement);

            }


        }

        else if (request instanceof CustomerDetailsWSUtilv2.getInvoices) {

            CustomerDetailsWSUtilv2.getInvoices getInvoicesObject = (CustomerDetailsWSUtilv2.getInvoices) request;

            if ((getInvoicesObject.wexAcctNbr).equalsIgnoreCase('9100000000000')) {

                CustomerDetailsWSUtilv2.getInvoicesResponse responseElement = new CustomerDetailsWSUtilv2.getInvoicesResponse();

                responseElement.return_x = new CustomerDetailsWSUtilv2.invoices();

                //This is the dummy version
                CustomerDetailsWSUtilv2.invoiceEntry[] invoiceArray = new CustomerDetailsWSUtilv2.invoiceEntry[]{
                };

                Datetime startDate = Datetime.now();
                Datetime invoiceDate;
                String NA = 'N/A';

                for (Integer i = 1; i <= 3; i++) {
                    invoiceDate = startDate.addMonths(i * -1);
                    CustomerDetailsWSUtilv2.invoiceEntry entry = new CustomerDetailsWSUtilv2.invoiceEntry();
                    entry.closingDt = invoiceDate;
                    entry.invoiceUrl = NA;
                    invoiceArray.add(entry);
                }

                responseElement.return_x.invoices = invoiceArray;
                responseElement.return_x.errorMsg = 'Generated demo data';
                response.put('response_x', responseElement);
            } else {

                CustomerDetailsWSUtilv2.getInvoicesResponse responseElement = new CustomerDetailsWSUtilv2.getInvoicesResponse();

                responseElement.return_x = new CustomerDetailsWSUtilv2.invoices();

                responseElement.return_x.errorMsg = 'Unable to retrieve specified invoices!';

                response.put('response_x', responseElement);

            }

        } else if (request instanceof CustomerDetailsWSUtilv2.accountSearch) {
            CustomerDetailsWSUtilv2.accountSearchRequest newRequest =(CustomerDetailsWSUtilv2.accountSearchRequest) request;
            CustomerDetailsWSUtilv2.accountSearchResponse accountSearchResponse = new CustomerDetailsWSUtilv2.accountSearchResponse();

            List<CustomerDetailsWSUtilv2.accountSearchDTO> testAccounts = new List<CustomerDetailsWSUtilv2.accountSearchDTO>();

            CustomerDetailsWSUtilv2.accountSearchDTO testAccount = new CustomerDetailsWSUtilv2.accountSearchDTO();

            if (newRequest.searchField.equals('CARDNUMBEROTR')) {
                testAccount.spnrAcctNbr = '123456';
                testAccount.acctRowId  = 'EFSLLC-123456-CO';

                testAccounts.add(testAccount);
            }   else {
                testAccount.acctNm = 'Test';
                testAccount.wexAcctNbr = '9100000000000';
                testAccount.spnrAcctNbr = '9100000000000';
                testAccount.acctSts = 'Active';
                testAccount.acctRowId = '1-ZZZZZZ';
                testAccount.dwSourceSys = 'SIEBEL';

                testAccounts.add(testAccount);
            }

            accountSearchResponse.return_x = new CustomerDetailsWSUtilv2.accountSearchResult();

            accountSearchResponse.return_x.accountList = testAccounts;

            response.put('response_x', accountSearchResponse);

        }

        else if (request instanceof CustomerDetailsWSUtilv2.getRefunds) {

            CustomerDetailsWSUtilv2.getRefunds getRefundsObject = (CustomerDetailsWSUtilv2.getRefunds) request;

            if ((getRefundsObject.wexAcctNbr).equalsIgnoreCase('9100000000000')) {

                CustomerDetailsWSUtilv2.getRefundsResponse responseElement = new CustomerDetailsWSUtilv2.getRefundsResponse();

                responseElement.return_x = new CustomerDetailsWSUtilv2.RefundAdjustmentDTO();

                //This is the dummy version
                CustomerDetailsWSUtilv2.refundAdjustment[] refundArray = new CustomerDetailsWSUtilv2.refundAdjustment[]{
                };

                Datetime startDate = Datetime.now();
                Datetime decisionDate;
                Datetime requestDate;
                String NA = 'N/A';

                for (Integer i = 1; i <= 3; i++) {
                    decisionDate = startDate.addMonths(i * -1);
                    requestDate = decisionDate;
                    CustomerDetailsWSUtilv2.refundAdjustment entry = new CustomerDetailsWSUtilv2.refundAdjustment();
                    entry.accountNumber = getRefundsObject.wexAcctNbr;
                    entry.acctPlatform = 'SIEBEL';
                    entry.decisionDt = decisionDate;
                    entry.requestDt = requestDate;
                    entry.acctStatusCd = 'Active';
                    entry.amountRequested = 200.00;
                    entry.amountWaived = 100.00;
                    entry.approvalComment = 'Approved without comment';
                    entry.approvalStatus = 'Approved';
                    entry.approver = 'Derek Curtis';
                    entry.department = 'DEPT';
                    entry.description = 'Description goes here';
                    entry.id = 100000 + i;
                    entry.reasonComment = 'Unreasonable';
                    entry.recordType = 'Refund';
                    entry.type_x = 'ONDR';
                    refundArray.add(entry);
                }

                responseElement.return_x.refundAdjustments = refundArray;
                responseElement.return_x.errorMsg = 'Generated demo data';
                response.put('response_x', responseElement);
            } else {

                CustomerDetailsWSUtilv2.getRefundsResponse responseElement = new CustomerDetailsWSUtilv2.getRefundsResponse();

                responseElement.return_x = new CustomerDetailsWSUtilv2.RefundAdjustmentDTO();

                responseElement.return_x.errorMsg = 'Unable to retrieve specified Refunds!';

                response.put('response_x', responseElement);

            }

        } else if (request instanceof CustomerDetailsWSUtilv2.getAdjustments) {

            CustomerDetailsWSUtilv2.getAdjustments getAdjustmentsObject = (CustomerDetailsWSUtilv2.getAdjustments) request;
            System.debug(getAdjustmentsObject);
            if ((getAdjustmentsObject.wexAcctNbr).equalsIgnoreCase('9100000000000')) {

                CustomerDetailsWSUtilv2.getAdjustmentsResponse responseElement = new CustomerDetailsWSUtilv2.getAdjustmentsResponse();

                responseElement.return_x = new CustomerDetailsWSUtilv2.RefundAdjustmentDTO();

                //This is the dummy version
                CustomerDetailsWSUtilv2.refundAdjustment[] adjustmentsArray = new CustomerDetailsWSUtilv2.refundAdjustment[]{
                };

                Datetime startDate = Datetime.now();
                Datetime decisionDate;
                String NA = 'N/A';

                for (Integer i = 1; i <= 3; i++) {
                    decisionDate = startDate.addMonths(i * -1);
                    CustomerDetailsWSUtilv2.refundAdjustment entry = new CustomerDetailsWSUtilv2.refundAdjustment();
                    entry.accountNumber = getAdjustmentsObject.wexAcctNbr;
                    entry.acctPlatform = 'SIEBEL';
                    entry.decisionDt = decisionDate;
                    entry.acctStatusCd = 'Active';
                    entry.amountWaived = -100.00;
                    entry.approvalComment = 'Approved without comment';
                    entry.approvalStatus = 'Approved';
                    entry.approver = 'Derek Curtis';
                    entry.department = 'DEPT';
                    entry.description = 'Description goes here';
                    entry.id = 100000 + i;
                    entry.reasonComment = 'Unreasonable';
                    entry.recordType = 'Adjustment';
                    entry.type_x = 'ONDR';
                    adjustmentsArray.add(entry);
                }

                responseElement.return_x.refundAdjustments = adjustmentsArray;
                responseElement.return_x.errorMsg = 'Generated demo data';
                response.put('response_x', responseElement);
            } else {

                CustomerDetailsWSUtilv2.getAdjustmentsResponse responseElement = new CustomerDetailsWSUtilv2.getAdjustmentsResponse();

                responseElement.return_x = new CustomerDetailsWSUtilv2.RefundAdjustmentDTO();

                responseElement.return_x.errorMsg = 'Unable to retrieve specified Refunds!';

                response.put('response_x', responseElement);

            }

        } else if (request instanceof CustomerDetailsWSUtilv2.getRefundAdjustmentTotals) {

            CustomerDetailsWSUtilv2.getRefundAdjustmentTotals totals = (CustomerDetailsWSUtilv2.getRefundAdjustmentTotals) request;
            System.debug(totals);
            if ((totals.wexAcctNbr).equalsIgnoreCase('9100000000000')) {

                CustomerDetailsWSUtilv2.getRefundAdjustmentTotalsResponse responseElement = new CustomerDetailsWSUtilv2.getRefundAdjustmentTotalsResponse();

                CustomerDetailsWSUtilv2.RefundAdjustmentAggregateDTO result = new CustomerDetailsWSUtilv2.RefundAdjustmentAggregateDTO();
                Datetime startDate = Datetime.now();
                Datetime decisionDate = startDate.addDays(-10);
                String NA = 'N/A';


                result.errorMsg = 'Generated demo data';
                result.mostRecentAmount = 100.00 ;
                result.mostRecentApprovalStatus = 'Approved';
                result.mostRecentCodeDescription = 'Bad Juju';
                result.mostRecentCreatedDate = decisionDate.format();
                result.mostRecentDepartment = 'CS';
                result.mostRecentReason = 'Just Because';
                result.mostRecentSubmitter = 'JOE DOE';
                result.totalFeesRefunded = 200.00;
                result.totalFeesRequested = 200.00;
                result.totalRequests = 2;
                result.totalRequestsApproved = 2;
                result.totalRequestsPending = 0.00;


                responseElement.return_x = result;
                response.put('response_x', responseElement);
            } else {

                CustomerDetailsWSUtilv2.getRefundAdjustmentTotalsResponse responseElement = new CustomerDetailsWSUtilv2.getRefundAdjustmentTotalsResponse();

                responseElement.return_x = new CustomerDetailsWSUtilv2.RefundAdjustmentAggregateDTO();

                responseElement.return_x.errorMsg = 'Unable to retrieve specified data!';

                response.put('response_x', responseElement);

            }

        } else if (request instanceof CustomerDetailsWSUtilv2.getOtrContracts || request instanceof CustomerDetailsWSUtilv2.getOtrContract) {
            CustomerDetailsWSUtilv2.otrContractsResponse responseElement = new CustomerDetailsWSUtilv2.otrContractsResponse();
            CustomerDetailsWSUtilv2.getOtrContractsResponse finalResponse = new CustomerDetailsWSUtilv2.getOtrContractsResponse();

            CustomerDetailsWSUtilv2.getOtrContracts contractReq = (CustomerDetailsWSUtilv2.getOtrContracts) request;
            System.debug(contractReq);
            if ((contractReq.otrAcctNbr).equalsIgnoreCase('9100000000000')) {

                CustomerDetailsWSUtilv2.contracts_element result = new CustomerDetailsWSUtilv2.contracts_element();
                result.entry = new CustomerDetailsWSUtilv2.entry_element[1];
                Datetime startDate = Datetime.now();
                Datetime decisionDate = startDate.addDays(-10);
                String NA = 'N/A';

                CustomerDetailsWSUtilv2.otrContract contract = new CustomerDetailsWSUtilv2.otrContract();
                contract.arNumber = '9100000000000';
                contract.availableCreditLmt = 1000.00;
                contract.billingAcctNbr = '9100000000000';
                contract.billingCycleDesc = 'DLY';
                contract.canadianFee = 10.00;
                contract.canadianFeeDescription = 'canadian fee description';
                contract.cashEnabledIndicator = true;
                contract.cashLimit = 1000.00;
                contract.codeExpiredFee = 10.00;
                contract.codeExpiredFeeDescription = 'code expired';
                contract.contractCurrency = 'USD';
                contract.contractIssuerId = '123456';
                contract.contractIssuerName = 'Bank of Malta';
                contract.contractNbr = '012345';
                contract.contractNm = 'Contract Name';
                contract.contractStartDt = Datetime.now();
                contract.contractStatus = 'Active';
                contract.creditLmt = 1000.00;
                contract.currentBillingCycle = 1;
                contract.currentInvoiceClosingDt = Datetime.now().addDays(-5);
                contract.currentInvoiceDueDt = Datetime.now().addDays(10);
                contract.daysToPay = 15;
                contract.debitCycle = 'Debit Cycle';
                contract.depositAmt = 1000.00;
                contract.faxFee = 10.00;
                contract.faxFeeDescription = 'fax fee';
                contract.financeChargeRteType = 'Finance Chrg';
                contract.lastInvoiceBilledAmt = 1000.00;
                contract.lastPaymentAmount = 1000.00;
                contract.lastPaymentComment = 'Last Pymt';
                contract.lastPaymentDt = Datetime.now();
                contract.lastPaymentMethod = 'Cash';
                contract.lastPaymentStatus = 'APP';
                contract.moneyCodeLimit = 1000.00;
                contract.moneyIncrementalFee = 10.00;
                contract.moneyIncrementalFeeDescription = 'Money Incremental Fee';
                contract.monthlyCardFee = 10.00;
                contract.monthlyCardFeeDescription = 'Card Fee';
                contract.nsfFee = 10.00;
                contract.nsfFeeDescription = 'NSF Fee';
                contract.onlinePayAllowed = true;
                contract.outOfNetworkPerTxnFee = 10.00;
                contract.outOfNetworkProgramOrAccountRte = 'Out Of network';
                contract.overLimitFee = 10.00;
                contract.overLimitFeeDescription = 'OCL Fee';
                contract.pastDueAmount = 1000.00;
                contract.payByAgentFee = 10.00;
                contract.payByAgentFeeDescription = 'PBA Fee';
                contract.pendingTxns = 1000.00;
                contract.periodicFinanceChargeRte = 1000.00;
                contract.programMaintenanceCharge = 'PMC 8%';
                contract.programMaintenanceChargeDescription = 'PMC Description';
                contract.recourseAmt = 1000.00;
                contract.recourseCode = 'Recourse';
                contract.salesforceId = '00000000123sdfs4fd';
                contract.thirdPartyCheckFee = 10.00;
                contract.thirdPartyCheckFeeDescription = 'Third Party Check';
                contract.totalOwed = 1000.00;
                contract.txnLimit = 1000.00;
                contract.unbilledAmt = 1000.00;
                contract.usualMethodOfPayment = 'CHK';
                contract.velocity = 1;
                contract.westernUnionFee = 10.00;
                contract.westernUnionFeeDescription = 'Telegraph Fee';
                contract.wireFee = 10.00;
                contract.wireFeeDescription = 'Wire Fee';

                CustomerDetailsWSUtilv2.entry_element entryElement = new CustomerDetailsWSUtilv2.entry_element();
                entryElement.key = '9100000000000';
                entryElement.value = contract;

                result.entry[0]=entryElement;

                responseElement.contracts = result;
                finalResponse.return_x = responseElement;
                response.put('response_x',finalResponse);
            } else {

                responseElement = new CustomerDetailsWSUtilv2.otrContractsResponse();

                responseElement.contracts = new CustomerDetailsWSUtilv2.contracts_element();
                responseElement.errorMsg = 'Unable to retrieve specified data!';

                response.put('return_x', responseElement);

            }

        } else if (request instanceof CustomerDetailsWSUtilv2.getOtrInvoicePdf) {

            CustomerDetailsWSUtilv2.getOtrInvoicePdf invoicePdfRequest = (CustomerDetailsWSUtilv2.getOtrInvoicePdf) request;

            if ((invoicePdfRequest.arNumber).equalsIgnoreCase('123456789') && (invoicePdfRequest.pdfFilename).equalsIgnoreCase('PDFFILE')) {

                CustomerDetailsWSUtilv2.getOtrInvoicePdfResponse invoiceResponse = new CustomerDetailsWSUtilv2.getOtrInvoicePdfResponse();

                invoiceResponse.return_x = new CustomerDetailsWSUtilv2.otrInvoiceResponse();

                invoiceResponse.return_x.invoices = new CustomerDetailsWSUtilv2.otrInvoices();

                CustomerDetailsWSUtilv2.otrInvoiceEntry[] entries = new CustomerDetailsWSUtilv2.otrInvoiceEntry[]{
                };

                CustomerDetailsWSUtilv2.otrInvoiceEntry entry = new CustomerDetailsWSUtilv2.otrInvoiceEntry();

                entry.pdfBytes = String.valueOf(EncodingUtil.base64Encode(Blob.valueOf('Hello, I am a teapot')));

                entries.add(entry);

                invoiceResponse.return_x.invoices.invoices = entries;

                response.put('response_x', invoiceResponse);

            } else {

                CustomerDetailsWSUtilv2.getOtrInvoicePdfResponse responseElement = new CustomerDetailsWSUtilv2.getOtrInvoicePdfResponse();

                responseElement.return_x = new CustomerDetailsWSUtilv2.otrInvoiceResponse();

                responseElement.return_x.errorMsg = 'Unable to retrieve specified data!';

                response.put('response_x', responseElement);

            }

        } else if (request instanceof CustomerDetailsWSUtilv2.getOtrInvoiceList) {

            CustomerDetailsWSUtilv2.getOtrInvoiceList invoiceListRequest = (CustomerDetailsWSUtilv2.getOtrInvoiceList) request;

            if ((invoiceListRequest.otrArNumber).equalsIgnoreCase('123456789')) {

                CustomerDetailsWSUtilv2.getOtrInvoiceListResponse invoiceResponse = new CustomerDetailsWSUtilv2.getOtrInvoiceListResponse();

                invoiceResponse.return_x = new CustomerDetailsWSUtilv2.otrInvoiceResponse();

                invoiceResponse.return_x.invoices = new CustomerDetailsWSUtilv2.otrInvoices();

                CustomerDetailsWSUtilv2.otrInvoiceEntry[] entries = new CustomerDetailsWSUtilv2.otrInvoiceEntry[]{
                };

                CustomerDetailsWSUtilv2.otrInvoiceEntry entry = new CustomerDetailsWSUtilv2.otrInvoiceEntry();

                entry.arNumber = '123456789';
                entry.invoiceNumber = '123456789';
                entry.fileName = 'PDFFILE';

                entries.add(entry);

                invoiceResponse.return_x.invoices.invoices = entries;

                response.put('response_x', invoiceResponse);

            } else {

                CustomerDetailsWSUtilv2.getOtrInvoiceListResponse responseElement = new CustomerDetailsWSUtilv2.getOtrInvoiceListResponse();

                responseElement.return_x = new CustomerDetailsWSUtilv2.otrInvoiceResponse();

                responseElement.return_x.errorMsg = 'Unable to retrieve specified data!';

                response.put('response_x', responseElement);

            }

        }

    }


    private CustomerDetailsWSUtilv2.getContactsResponse generateContacts() {
        CustomerDetailsWSUtilv2.getContactsResponse responseElement = new CustomerDetailsWSUtilv2.getContactsResponse();

        responseElement.return_x = new CustomerDetailsWSUtilv2.contacts();

        CustomerDetailsWSUtilv2.contact contact = new CustomerDetailsWSUtilv2.contact();

        contact.role = 'ADMIN';
        contact.contactType = 'Contact';
        contact.emailAddr = 'test@wexinc.com';
        contact.faxNbr = '207-555-5555';
        contact.firstNm = 'Test';
        contact.middleNm = 'E';
        contact.lastNm = 'McTesterson';
        contact.phoneNbr = '207-555-5555';
        contact.rowId = '1-1ZZZZZ';

        CustomerDetailsWSUtilv2.address MailingAddress = new CustomerDetailsWSUtilv2.address();
        MailingAddress.addr1 = '123 Darling Ave';
        MailingAddress.addr2 = 'Filler';
        MailingAddress.addr3 = 'Filler';
        MailingAddress.addr4 = 'Filler';
        MailingAddress.city = 'South Portland';
        MailingAddress.state = 'ME';
        MailingAddress.country = 'US';
        MailingAddress.orgName = 'WEX';
        MailingAddress.postalCode = '04106';

        contact.address = MailingAddress;

        CustomerDetailsWSUtilv2.contact contact2 = new CustomerDetailsWSUtilv2.contact();

        contact2.role = 'ADMIN';
        contact2.contactType = 'Contact';
        contact2.emailAddr = 'test@wexinc.com';
        contact2.faxNbr = '207-555-5555';
        contact2.firstNm = 'Test';
        contact2.middleNm = 'E';
        contact2.lastNm = 'McTesterson';
        contact2.phoneNbr = '207-555-5555';
        contact2.rowId = '1-1ZZZZX';

        CustomerDetailsWSUtilv2.address primaryAddress = new CustomerDetailsWSUtilv2.address();
        primaryAddress.addr1 = '123 Darling Ave';
        primaryAddress.addr2 = 'Filler';
        primaryAddress.addr3 = 'Filler';
        primaryAddress.addr4 = 'Filler';
        primaryAddress.city = 'South Portland';
        primaryAddress.state = 'ME';
        primaryAddress.country = 'US';
        primaryAddress.orgName = 'WEX';
        primaryAddress.postalCode = '04106';

        contact2.address = primaryAddress;

        responseElement.return_x.contacts = new CustomerDetailsWSUtilv2.contact[]{
        };

        responseElement.return_x.contacts.add(contact);
        responseElement.return_x.contacts.add(contact2);
        return responseElement;
    }

}