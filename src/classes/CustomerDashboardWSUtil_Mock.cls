global class CustomerDashboardWSUtil_Mock implements WebServiceMock {
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
            
        	if (request instanceOf CustomerDashboardWSUtil.getAgingHistory) {
                
            	CustomerDashboardWSUtil.getAgingHistoryResponse responseElement = new CustomerDashboardWSUtil.getAgingHistoryResponse();
				
                responseElement.return_x = new CustomerDashboardWSUtil.AgingHistory();
                
                responseElement.return_x.accountId = '9100003325428';
				responseElement.return_x.accountNm = 'Hub Cap Annie &amp; Wheel of Idaho Inc';
				responseElement.return_x.cycleCd = 2;
                responseElement.return_x.cyclePeriod = 'd';
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
				responseElement.return_x.riskCode = '9';

                response.put('response_x', responseElement);
           	}
            else if(request instanceOf CustomerDashboardWSUtil.getCustomerDetails) {
                CustomerDashboardWSUtil.getCustomerDetailsResponse responseElement = new CustomerDashboardWSUtil.getCustomerDetailsResponse();
                
                responseElement.return_x = new CustomerDashboardWSUtil.customerDetails();
                
                responseElement.return_x.accountNbrType = 'Internal';
				responseElement.return_x.accountNm = 'Hub Cap Annie &amp; Wheel of Idaho Inc';
				responseElement.return_x.accountSinceDt = (DateTime)json.deserialize('"2015-04-15T00:00:00-04:00"', DateTime.class);
				responseElement.return_x.accountSts = 'A';
				responseElement.return_x.accountStsDt = (DateTime)json.deserialize('"2015-04-15T00:00:00-04:00"', DateTime.class);
				responseElement.return_x.availableCreditLmt = 7179.69;
				responseElement.return_x.billingAccountId = '9100003325428';
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
				responseElement.return_x.customerSegmentation = 3;
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
				responseElement.return_x.spnrAccountNbr = '0496002452282';
				responseElement.return_x.telematicsCustomer = true;
				responseElement.return_x.truckStopFee = 0.0;
				responseElement.return_x.WEXFleetCustomer = true;
				responseElement.return_x.wexAccountNbr = '9100003325428';
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
				responseElement.return_x.NnlineApplication = 'WOL NP';
				responseElement.return_x.description = 'Only accept calls from Mark!';
				responseElement.return_x.monthlyCardFeeDescription = 'TFS';
				responseElement.return_x.truckStopFeeDescription = 'Waived';
				responseElement.return_x.servicingRules = 'Proceed with caution.';
                
                response.put('response_x', responseElement);
            }
        
   		}

}