global class CustomerDetailsWSUtil_Mock implements WebServiceMock {
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
            
            if (request instanceOf CustomerDetailsWSUtil.getAgingHistory) {
                
                CustomerDetailsWSUtil.getAgingHistory getAgingHistoryObject = (CustomerDetailsWSUtil.getAgingHistory)request;
                
                CustomerDetailsWSUtil.customerDetailsRequest customerDetailsRequest = (CustomerDetailsWSUtil.customerDetailsRequest)getAgingHistoryObject.AgingHistory;
                
                if((customerDetailsRequest.AccountId).equalsIgnoreCase('9100000000000')) {
                    
                    CustomerDetailsWSUtil.getAgingHistoryResponse responseElement = new CustomerDetailsWSUtil.getAgingHistoryResponse();
                    
                    responseElement.return_x = new CustomerDetailsWSUtil.agingHistory();
                    
                    responseElement.return_x.accountId = '9100003325428';
                    responseElement.return_x.accountNm = 'Hub Cap Annie &amp; Wheel of Idaho Inc';
                    responseElement.return_x.cycleCd = 2;
                    responseElement.return_x.CyclePeriod = 'd';
                    responseElement.return_x.CycleAnchorDt = (DateTime)json.deserialize('"2017-03-31T00:00:00-05:00"', DateTime.class);
                    responseElement.return_x.daysLatePastDueCnt = Integer.valueOf(Math.floor(Math.random() * ((120-0)+1) + 0));
                    responseElement.return_x.daysPastDueCnt00 = Integer.valueOf(Math.floor(Math.random() * ((120-0)+1) + 0));
                    responseElement.return_x.daysPastDueCnt01 = Integer.valueOf(Math.floor(Math.random() * ((120-0)+1) + 0));
                    responseElement.return_x.daysPastDueCnt02 = Integer.valueOf(Math.floor(Math.random() * ((120-0)+1) + 0));
                    responseElement.return_x.daysPastDueCnt03 = Integer.valueOf(Math.floor(Math.random() * ((120-0)+1) + 0));
                    responseElement.return_x.daysPastDueCnt04 = Integer.valueOf(Math.floor(Math.random() * ((120-0)+1) + 0));
                    responseElement.return_x.daysPastDueCnt05 = Integer.valueOf(Math.floor(Math.random() * ((120-0)+1) + 0));
                    responseElement.return_x.daysPastDueCnt06 = Integer.valueOf(Math.floor(Math.random() * ((120-0)+1) + 0));
                    responseElement.return_x.daysPastDueCnt07 = Integer.valueOf(Math.floor(Math.random() * ((120-0)+1) + 0));
                    responseElement.return_x.daysPastDueCnt08 = Integer.valueOf(Math.floor(Math.random() * ((120-0)+1) + 0));
                    responseElement.return_x.daysPastDueCnt09 = Integer.valueOf(Math.floor(Math.random() * ((120-0)+1) + 0));
                    responseElement.return_x.daysPastDueCnt10 = Integer.valueOf(Math.floor(Math.random() * ((120-0)+1) + 0));
                    responseElement.return_x.daysPastDueCnt11 = Integer.valueOf(Math.floor(Math.random() * ((120-0)+1) + 0));
                    responseElement.return_x.daysPastDueCnt12 = Integer.valueOf(Math.floor(Math.random() * ((120-0)+1) + 0));
                    responseElement.return_x.daysPastDueCnt13 = Integer.valueOf(Math.floor(Math.random() * ((120-0)+1) + 0));
                    responseElement.return_x.daysPastDueCnt14 = Integer.valueOf(Math.floor(Math.random() * ((120-0)+1) + 0));
                    responseElement.return_x.daysPastDueCnt15 = Integer.valueOf(Math.floor(Math.random() * ((120-0)+1) + 0));
                    responseElement.return_x.daysPastDueCnt16 = Integer.valueOf(Math.floor(Math.random() * ((120-0)+1) + 0));
                    responseElement.return_x.daysPastDueCnt17 = Integer.valueOf(Math.floor(Math.random() * ((120-0)+1) + 0));
                    responseElement.return_x.daysPastDueCnt18 = Integer.valueOf(Math.floor(Math.random() * ((120-0)+1) + 0));
                    responseElement.return_x.daysPastDueCnt19 = Integer.valueOf(Math.floor(Math.random() * ((120-0)+1) + 0));
                    responseElement.return_x.daysPastDueCnt20 = Integer.valueOf(Math.floor(Math.random() * ((120-0)+1) + 0));
                    responseElement.return_x.daysPastDueCnt21 = Integer.valueOf(Math.floor(Math.random() * ((120-0)+1) + 0));
                    responseElement.return_x.daysPastDueCnt22 = Integer.valueOf(Math.floor(Math.random() * ((120-0)+1) + 0));
                    responseElement.return_x.daysPastDueCnt23 = Integer.valueOf(Math.floor(Math.random() * ((120-0)+1) + 0));
                    responseElement.return_x.daysPastDueCnt24 = Integer.valueOf(Math.floor(Math.random() * ((120-0)+1) + 0));
                    responseElement.return_x.daysPastDueCnt25 = Integer.valueOf(Math.floor(Math.random() * ((120-0)+1) + 0));
                    responseElement.return_x.CycleCloseDt00 = (DateTime)json.deserialize('"2017-03-31T00:00:00-05:00"', DateTime.class);
                    responseElement.return_x.CycleCloseDt01 = (DateTime)json.deserialize('"2017-03-30T00:00:00-05:00"', DateTime.class);
                    responseElement.return_x.CycleCloseDt02 = (DateTime)json.deserialize('"2017-03-29T00:00:00-05:00"', DateTime.class);
                    responseElement.return_x.CycleCloseDt03 = (DateTime)json.deserialize('"2017-03-28T00:00:00-05:00"', DateTime.class);
                    responseElement.return_x.CycleCloseDt04 = (DateTime)json.deserialize('"2017-03-27T00:00:00-05:00"', DateTime.class);
                    responseElement.return_x.CycleCloseDt05 = (DateTime)json.deserialize('"2017-03-24T00:00:00-05:00"', DateTime.class);
                    responseElement.return_x.CycleCloseDt06 = (DateTime)json.deserialize('"2017-03-23T00:00:00-05:00"', DateTime.class);
                    responseElement.return_x.CycleCloseDt07 = (DateTime)json.deserialize('"2017-03-22T00:00:00-05:00"', DateTime.class);
                    responseElement.return_x.CycleCloseDt08 = (DateTime)json.deserialize('"2017-03-21T00:00:00-05:00"', DateTime.class);
                    responseElement.return_x.CycleCloseDt09 = (DateTime)json.deserialize('"2017-03-20T00:00:00-05:00"', DateTime.class);
                    responseElement.return_x.CycleCloseDt10 = (DateTime)json.deserialize('"2017-03-17T00:00:00-05:00"', DateTime.class);
                    responseElement.return_x.CycleCloseDt11 = (DateTime)json.deserialize('"2017-03-16T00:00:00-05:00"', DateTime.class);
                    responseElement.return_x.CycleCloseDt12 = (DateTime)json.deserialize('"2017-03-15T00:00:00-05:00"', DateTime.class);
                    responseElement.return_x.CycleCloseDt13 = (DateTime)json.deserialize('"2017-03-14T00:00:00-05:00"', DateTime.class);
                    responseElement.return_x.CycleCloseDt14 = (DateTime)json.deserialize('"2017-03-13T00:00:00-05:00"', DateTime.class);
                    responseElement.return_x.CycleCloseDt15 = (DateTime)json.deserialize('"2017-03-10T00:00:00-05:00"', DateTime.class);
                    responseElement.return_x.CycleCloseDt16 = (DateTime)json.deserialize('"2017-03-09T00:00:00-05:00"', DateTime.class);
                    responseElement.return_x.CycleCloseDt17 = (DateTime)json.deserialize('"2017-03-08T00:00:00-05:00"', DateTime.class);
                    responseElement.return_x.CycleCloseDt18 = (DateTime)json.deserialize('"2017-03-07T00:00:00-05:00"', DateTime.class);
                    responseElement.return_x.CycleCloseDt19 = (DateTime)json.deserialize('"2017-03-06T00:00:00-05:00"', DateTime.class);
                    responseElement.return_x.CycleCloseDt20 = (DateTime)json.deserialize('"2017-03-03T00:00:00-05:00"', DateTime.class);
                    responseElement.return_x.CycleCloseDt21 = (DateTime)json.deserialize('"2017-03-02T00:00:00-05:00"', DateTime.class);
                    responseElement.return_x.CycleCloseDt22 = (DateTime)json.deserialize('"2017-03-01T00:00:00-05:00"', DateTime.class);
                    responseElement.return_x.CycleCloseDt23 = null;
                    responseElement.return_x.CycleCloseDt24 = null;
                    responseElement.return_x.CycleCloseDt25 = null;
                    responseElement.return_x.dnbViabilityRate = Integer.valueOf(Math.floor(Math.random() * ((120-0)+1) + 0));
                    responseElement.return_x.hrcFeeAmt = 0.00;
                    responseElement.return_x.hrcFeeEffDt = (DateTime)json.deserialize('"1970-01-01T00:00:00-05:00"', DateTime.class);
                    responseElement.return_x.hrcFeeExpnDt = (DateTime)json.deserialize('"9999-12-31T00:00:00-05:00"', DateTime.class);
                    responseElement.return_x.hrcFeeWaiveEndDt = (DateTime)json.deserialize('"9999-12-31T00:00:00-05:00"', DateTime.class);
                    responseElement.return_x.lastWaiveDt = (DateTime)json.deserialize('"1970-01-01T00:00:00-05:00"', DateTime.class);
                    responseElement.return_x.lateFeeCnt00 = Integer.valueOf(Math.floor(Math.random() * ((23-0)+1) + 0));
                    responseElement.return_x.lateFeeCnt01 = Integer.valueOf(Math.floor(Math.random() * ((23-0)+1) + 0));
                    responseElement.return_x.lateFeeCnt02 = Integer.valueOf(Math.floor(Math.random() * ((23-0)+1) + 0));
                    responseElement.return_x.lateFeeCnt03 = Integer.valueOf(Math.floor(Math.random() * ((23-0)+1) + 0));
                    responseElement.return_x.lateFeeCnt04 = Integer.valueOf(Math.floor(Math.random() * ((23-0)+1) + 0));
                    responseElement.return_x.lateFeeCnt05 = Integer.valueOf(Math.floor(Math.random() * ((23-0)+1) + 0));
                    responseElement.return_x.lateFeeCnt06 = Integer.valueOf(Math.floor(Math.random() * ((23-0)+1) + 0));
                    responseElement.return_x.lateFeeCnt07 = Integer.valueOf(Math.floor(Math.random() * ((23-0)+1) + 0));
                    responseElement.return_x.lateFeeCnt08 = Integer.valueOf(Math.floor(Math.random() * ((23-0)+1) + 0));
                    responseElement.return_x.lateFeeCnt09 = Integer.valueOf(Math.floor(Math.random() * ((23-0)+1) + 0));
                    responseElement.return_x.lateFeeCnt10 = Integer.valueOf(Math.floor(Math.random() * ((23-0)+1) + 0));
                    responseElement.return_x.lateFeeCnt11 = Integer.valueOf(Math.floor(Math.random() * ((23-0)+1) + 0));
                    responseElement.return_x.nsfCnt00 = Integer.valueOf(Math.floor(Math.random() * ((23-0)+1) + 0));
                    responseElement.return_x.nsfCnt01 = Integer.valueOf(Math.floor(Math.random() * ((23-0)+1) + 0));
                    responseElement.return_x.nsfCnt02 = Integer.valueOf(Math.floor(Math.random() * ((23-0)+1) + 0));
                    responseElement.return_x.nsfCnt03 = Integer.valueOf(Math.floor(Math.random() * ((23-0)+1) + 0));
                    responseElement.return_x.nsfCnt04 = Integer.valueOf(Math.floor(Math.random() * ((23-0)+1) + 0));
                    responseElement.return_x.nsfCnt05 = Integer.valueOf(Math.floor(Math.random() * ((23-0)+1) + 0));
                    responseElement.return_x.nsfCnt06 = Integer.valueOf(Math.floor(Math.random() * ((23-0)+1) + 0));
                    responseElement.return_x.nsfCnt07 = Integer.valueOf(Math.floor(Math.random() * ((23-0)+1) + 0));
                    responseElement.return_x.nsfCnt08 = Integer.valueOf(Math.floor(Math.random() * ((23-0)+1) + 0));
                    responseElement.return_x.nsfCnt09 = Integer.valueOf(Math.floor(Math.random() * ((23-0)+1) + 0));
                    responseElement.return_x.nsfCnt10 = Integer.valueOf(Math.floor(Math.random() * ((23-0)+1) + 0));
                    responseElement.return_x.nsfCnt11 = Integer.valueOf(Math.floor(Math.random() * ((23-0)+1) + 0));
                    responseElement.return_x.RiskCode = '9';
                    
                    response.put('response_x', responseElement);
                    
                }
                else {
                    
                    CustomerDetailsWSUtil.getAgingHistoryResponse responseElement = new CustomerDetailsWSUtil.getAgingHistoryResponse();
                    
                    responseElement.return_x = new CustomerDetailsWSUtil.agingHistory();
                    
                    responseElement.return_x.ErrorMsg = 'Could not find specified account!';
                    
                    response.put('response_x', responseElement);
                    
                }
                
            }
            else if(request instanceOf CustomerDetailsWSUtil.getCustomerDetails) {
                
                CustomerDetailsWSUtil.getCustomerDetails getCustomerDetailsObject = (CustomerDetailsWSUtil.getCustomerDetails)request;
                
                CustomerDetailsWSUtil.customerDetailsRequest customerDetailsRequest = (CustomerDetailsWSUtil.customerDetailsRequest)getCustomerDetailsObject.CustomerDetails;
                
                if((customerDetailsRequest.AccountId).equalsIgnoreCase('9100000000000')) {
                    
                    CustomerDetailsWSUtil.getCustomerDetailsResponse responseElement = new CustomerDetailsWSUtil.getCustomerDetailsResponse();
                    
                    responseElement.return_x = new CustomerDetailsWSUtil.customerDetails();
                    
                    responseElement.return_x.accountNbrType = 'Internal';
                    responseElement.return_x.accountNm = 'Hub Cap Annie &amp; Wheel of Idaho Inc';
                    responseElement.return_x.accountSinceDt = (DateTime)json.deserialize('"2015-04-15T00:00:00-04:00"', DateTime.class);
                    responseElement.return_x.accountSts = 'A';
                    responseElement.return_x.accountStsDt = (DateTime)json.deserialize('"2015-04-15T00:00:00-04:00"', DateTime.class);
                    responseElement.return_x.availableCreditLmt = 7179.69;
                    responseElement.return_x.billingAccountId = '9100000000000';
                    responseElement.return_x.billtoAccountNm = 'Hub Cap Annie &amp; Wheel of Idaho Inc';
                    responseElement.return_x.cashEnabledIndicator = false;
                    responseElement.return_x.clearViewCustomer = true;
                    responseElement.return_x.contractEndDt = (DateTime)json.deserialize('"9999-12-31T00:00:00-05:00"', DateTime.class);
                    responseElement.return_x.contractName = 'Dummy Customer Contract Name: 9100003325428';
                    responseElement.return_x.contractNm = 'Dummy Contract Name: 9100003325428';
                    responseElement.return_x.contractStartDt = (DateTime)json.deserialize('"1970-01-01T00:00:00-05:00"', DateTime.class);
                    responseElement.return_x.costPlusIndicator = true;
                    responseElement.return_x.creditScore = 85;
                    responseElement.return_x.currentBillingCycle = 2;
                    responseElement.return_x.currentInvoiceClosingDt = (DateTime)json.deserialize('"9999-12-31T00:00:00-05:00"', DateTime.class);
                    responseElement.return_x.currentInvoiceDueDt = (DateTime)json.deserialize('"9999-12-31T00:00:00-05:00"', DateTime.class);
                    responseElement.return_x.customerId = '4715696';
                    responseElement.return_x.customerIdentifier = '4715696';
                    responseElement.return_x.customerNm = 'Hub Cap Annie &amp; Wheel of Idaho Inc';
                    responseElement.return_x.customerSegmentation = '3';
                    responseElement.return_x.customerSinceDt = (DateTime)json.deserialize('"2015-04-15T00:00:00-04:00"', DateTime.class);
                    responseElement.return_x.daysToPay = 26;
                    responseElement.return_x.discountIndicator = true;
                    responseElement.return_x.evergreenIndicator = false;
                    responseElement.return_x.financeChargeRteType = 'Negotiated, Waived Finance Chg';
                    responseElement.return_x.fleetOneCustomer = false;
                    responseElement.return_x.flexCardCustomer = false;
                    responseElement.return_x.flexCardPenaltyPricingIndicator = 'N';
                    responseElement.return_x.highCreditRiskFeeIndicator = false;
                    responseElement.return_x.highRiskCureDt = (DateTime)json.deserialize('"9999-12-31T00:00:00-05:00"', DateTime.class);
                    responseElement.return_x.lastPaymentDt = (DateTime)json.deserialize('"9999-12-31T00:00:00-05:00"', DateTime.class);
                    responseElement.return_x.masterCardCustomer = false;
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
                    
                    CustomerDetailsWSUtil.Address AlternateAddress = new CustomerDetailsWSUtil.Address();
                    AlternateAddress.Addr1 = '123 Darling Ave';
                    AlternateAddress.Addr2 = 'Filler';
                    AlternateAddress.Addr3 = 'Filler';
                    AlternateAddress.Addr4 = 'Filler';
                    AlternateAddress.City = 'South Portland';
                    AlternateAddress.State = 'ME';
                    AlternateAddress.Country = 'US';
                    AlternateAddress.OrgName = 'WEX';
                    AlternateAddress.PostalCode = '04106';
                    
                    responseElement.return_x.AlternateAddress = AlternateAddress;
                      
                    CustomerDetailsWSUtil.Address BillingAddress = new CustomerDetailsWSUtil.Address();
                    BillingAddress.Addr1 = '123 Darling Ave';
                    BillingAddress.Addr2 = 'Filler';
                    BillingAddress.Addr3 = 'Filler';
                    BillingAddress.Addr4 = 'Filler';
                    BillingAddress.City = 'South Portland';
                    BillingAddress.State = 'ME';
                    BillingAddress.Country = 'US';
                    BillingAddress.OrgName = 'WEX';
                    BillingAddress.PostalCode = '04106';
                    
                    responseElement.return_x.BillingAddress = BillingAddress;
                    
                    CustomerDetailsWSUtil.Address MailingAddress = new CustomerDetailsWSUtil.Address();
                    MailingAddress.Addr1 = '123 Darling Ave';
                    MailingAddress.Addr2 = 'Filler';
                    MailingAddress.Addr3 = 'Filler';
                    MailingAddress.Addr4 = 'Filler';
                    MailingAddress.City = 'South Portland';
                    MailingAddress.State = 'ME';
                    MailingAddress.Country = 'US';
                    MailingAddress.OrgName = 'WEX';
                    MailingAddress.PostalCode = '04106';
                    
                    responseElement.return_x.MailingAddress = MailingAddress;
                    
                    CustomerDetailsWSUtil.Address PrimaryAddress = new CustomerDetailsWSUtil.Address();
                    PrimaryAddress.Addr1 = '123 Darling Ave';
                    PrimaryAddress.Addr2 = 'Filler';
                    PrimaryAddress.Addr3 = 'Filler';
                    PrimaryAddress.Addr4 = 'Filler';
                    PrimaryAddress.City = 'South Portland';
                    PrimaryAddress.State = 'ME';
                    PrimaryAddress.Country = 'US';
                    PrimaryAddress.OrgName = 'WEX';
                    PrimaryAddress.PostalCode = '04106';
                    
                    responseElement.return_x.PrimaryAddress = PrimaryAddress;
                    
                    CustomerDetailsWSUtil.Address ShippingAddress = new CustomerDetailsWSUtil.Address();
                    ShippingAddress.Addr1 = '123 Darling Ave';
                    ShippingAddress.Addr2 = 'Filler';
                    ShippingAddress.Addr3 = 'Filler';
                    ShippingAddress.Addr4 = 'Filler';
                    ShippingAddress.City = 'South Portland';
                    ShippingAddress.State = 'ME';
                    ShippingAddress.Country = 'US';
                    ShippingAddress.OrgName = 'WEX';
                    ShippingAddress.PostalCode = '04106';
                    
                    responseElement.return_x.ShippingAddress = ShippingAddress;
                    
                    response.put('response_x', responseElement);
                    
                }
                else {
                    
                    CustomerDetailsWSUtil.getCustomerDetailsResponse responseElement = new CustomerDetailsWSUtil.getCustomerDetailsResponse();
                    
                    responseElement.return_x = new CustomerDetailsWSUtil.customerDetails();
                    
                    responseElement.return_x.ErrorMsg = 'Could not find specified account!';
                    
                    response.put('response_x', responseElement);
                    
                }
                
            }
            else if(request instanceOf CustomerDetailsWSUtil.getContacts) {
                
                CustomerDetailsWSUtil.getContacts getContactsObject = (CustomerDetailsWSUtil.getContacts)request;
                
                CustomerDetailsWSUtil.customerDetailsRequest customerDetailsRequest = (CustomerDetailsWSUtil.customerDetailsRequest)getContactsObject.Contacts;
                
                if((customerDetailsRequest.AccountId).equalsIgnoreCase('9100000000000')) {
                    
                    CustomerDetailsWSUtil.getContactsResponse responseElement = new CustomerDetailsWSUtil.getContactsResponse();
                    
                    responseElement.return_x = new CustomerDetailsWSUtil.Contacts();
                    
                    CustomerDetailsWSUtil.Contact contact = new CustomerDetailsWSUtil.Contact();
                    
                    contact.role = 'Contact';
                    contact.contactType = 'Contact';
                    contact.emailAddr = 'test@wexinc.com';
                    contact.faxNbr = '207-555-5555';
                    contact.firstNm = 'Test';
                    contact.middleNm = 'E';
                    contact.lastNm = 'McTesterson';
                    contact.phoneNbr = '207-555-5555';
                    contact.rowId = '1-1ZZZZZ';
                    
                    CustomerDetailsWSUtil.Address MailingAddress = new CustomerDetailsWSUtil.Address();
                    MailingAddress.Addr1 = '123 Darling Ave';
                    MailingAddress.Addr2 = 'Filler';
                    MailingAddress.Addr3 = 'Filler';
                    MailingAddress.Addr4 = 'Filler';
                    MailingAddress.City = 'South Portland';
                    MailingAddress.State = 'ME';
                    MailingAddress.Country = 'US';
                    MailingAddress.OrgName = 'WEX';
                    MailingAddress.PostalCode = '04106';
                    
                    contact.Address = MailingAddress;
                    
                    responseElement.return_x.contacts = new CustomerDetailsWSUtil.Contact[]{};
                        
                        responseElement.return_x.contacts.add(contact);
                    
                    response.put('response_x', responseElement);
                    
                }
                else {
                    
                    CustomerDetailsWSUtil.getContactsResponse responseElement = new CustomerDetailsWSUtil.getContactsResponse();
                    
                    responseElement.return_x = new CustomerDetailsWSUtil.contacts();
                    
                    responseElement.return_x.ErrorMsg = 'Could not find specified account!';
                    
                    response.put('response_x', responseElement);
                    
                }
                
            }
            else if(request instanceOf CustomerDetailsWSUtil.getRecentDeclinedAuthsRequest) {
                
                CustomerDetailsWSUtil.getRecentDeclinedAuthsRequest getRecentDeclinedAuthsObject = (CustomerDetailsWSUtil.getRecentDeclinedAuthsRequest)request;
                
				if(!(getRecentDeclinedAuthsObject.wexAcctNbr).equalsIgnoreCase('9100000000000')) {
                    
                    CustomerDetailsWSUtil.getRecentDeclinedAuthsResponse responseElement = new CustomerDetailsWSUtil.getRecentDeclinedAuthsResponse();
                    
                    responseElement.return_x = new CustomerDetailsWSUtil.authSearchResult();
                    
                    responseElement.return_x.authLog = new CustomerDetailsWSUtil.authLogRecord[]{};
                    
                    CustomerDetailsWSUtil.authLogRecord authLog1 = new CustomerDetailsWSUtil.authLogRecord();
                    
                    authLog1.actionCode = '180';
        			authLog1.actionCodeDescription = 'Invalid Driver ID';
        			authLog1.cardNumber = '*******************12341';
        			authLog1.driverId = '123456';
        			authLog1.merchantSite = 'WX222333';
        			authLog1.txnDt = (DateTime)json.deserialize('"2018-03-07T00:00:00-05:00"', DateTime.class);
                    
                    CustomerDetailsWSUtil.Address MerchantAddress = new CustomerDetailsWSUtil.Address();
                    MerchantAddress.Addr1 = '123 DARLING AVE';
                    MerchantAddress.Addr2 = 'Filler';
                    MerchantAddress.Addr3 = 'Filler';
                    MerchantAddress.Addr4 = 'Filler';
                    MerchantAddress.City = 'SO PORTLAND';
                    MerchantAddress.State = 'ME';
                    MerchantAddress.Country = 'US';
                    MerchantAddress.OrgName = 'WRIGHT EXPRESS CARDLOCKS INC';
                    MerchantAddress.PostalCode = '041061111';
                    
                    authLog1.MerchantAddress = MerchantAddress;
                    
                    responseElement.return_x.authLog.add(authLog1);
                    
                    CustomerDetailsWSUtil.authLogRecord authLog2 = new CustomerDetailsWSUtil.authLogRecord();
                    
                    authLog2.actionCode = '109';
        			authLog2.actionCodeDescription = 'Invalid Site';
        			authLog2.cardNumber = '*******************12341';
        			authLog2.driverId = '123456';
        			authLog2.merchantSite = 'WX222333';
        			authLog2.txnDt = (DateTime)json.deserialize('"2018-03-08T00:00:00-05:00"', DateTime.class);
                    authLog2.MerchantAddress = MerchantAddress;
                    responseElement.return_x.authLog.add(authLog2);
                    
                    response.put('response_x', responseElement);
                    
                }
                else {
                    
                    CustomerDetailsWSUtil.getRecentDeclinedAuthsResponse responseElement = new CustomerDetailsWSUtil.getRecentDeclinedAuthsResponse();
                    
                    responseElement.return_x = new CustomerDetailsWSUtil.authSearchResult();
                    
                    responseElement.return_x.ErrorMsg = 'Could not find specified account!';
                    
                    response.put('response_x', responseElement);
                    
                }
                
            }
            
        }
    
}