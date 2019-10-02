@isTest
global class UOnlineApplicationTest implements HttpCalloutMock {

	@isTest static void testForteIntegrationCallout() {
        
        UtilityTestLoader.setAutomation(false);

		OnlineApplicationOffer__c oao = createCompleteSavedOffer(OnlineApplication.LOCAL);
		OnlineApplication__c oa = getOnlineApplication(oao.Id);

		Test.startTest();
		// Set mock callout class
		Test.setMock(HttpCalloutMock.class, new UOnlineApplicationTest());

		insert oa;
		Test.stopTest();

	}


	public static OnlineApplication__c getOnlineApplication(Id offerId) {

		OnlineApplication__c oa = new OnlineApplication__c();
		oa.Legal_Business_Name__c = 'The Division';
		oa.Business_Street_Address__c = '100 Fifth Avenue';
		oa.City__c = 'New York';
		oa.State__c = 'NY';
		oa.Zip_Code__c = '12345';
		oa.Type_of_Business__c = 'Government';
		oa.Federal_Tax_ID__c = '123456789';
		oa.Number_of_Vehicles__c = 2;
		oa.Number_of_Drivers__c = 2;
		oa.Type_of_Business_Other__c = 'We Provide';
		oa.Lead_Source_Subtype__c = 'American Trucker';
		oa.Contact_Name__c = 'Max Born';
		oa.Credit_Line_Requested__c = 20000;
		oa.Invoice_Delivery_Method_Email__c = 'dcraigmile@forseva.com';
		oa.Financial_Institution__c = 'Bank One';
		oa.Branch_Phone_Number__c = '2178889999';
		oa.Branch_City__c = 'New York';
		oa.Branch_State__c = 'NY';
		oa.Checking_Account_Number__c = '123456789';
		oa.Confirm_Checking_Account_Number__c = '123456789';
		oa.ABA_Routing_Number__c = '123456789';
		oa.Confirm_ABA_Routing_Number__c = '123456789';
		oa.AO_Name__c = 'Chris Zell';
		oa.AO_Title__c = 'Partner';
		oa.AO_Address__c = '105 Fifth Avenue';
		oa.AO_City__c = 'New York';
		oa.AO_State__c = 'NY';
		oa.AO_Zip_Code__c = '12345';
		oa.AO_Date_of_Birth__c = Date.today().addYears(- 20);
		oa.AO_Social_Security_Number__c = '123456789';
		oa.AO_Confirm_Social_Security_Number__c = '123456789';
		oa.AO_Work_Email__c = 'dcraigmile@forseva.com';
		oa.AO_Home_Phone_Number__c = '2176669999';
		oa.Application_Stage__c = 'Adjudication';
		oa.Offer__c = offerId;
		return oa;

	}

	public static OnlineApplicationOffer__c createCompleteSavedOffer(String productType) {

		OnlineApplicationOffer__c offer = new OnlineApplicationOffer__c();
		offer.Name = 'Test Offer ' + Math.random();
		offer.Application_Title__c = productType + ' Test Application Title';
		offer.Large_Fleet_Completion_Message__c = 'Large Fleet completion message';
		offer.Product_Type__c = productType;
		offer.Promotional_Code__c = '1234ABCD';
		offer.Small_Fleet_Completion_Message__c = 'Small Fleet completion message';
		offer.Terms_and_Conditions_Version__c = 'Test Terms and Conditions';
		offer.Disclosure__c = 'Test Disclosure';
		offer.Complete_Later_Text__c = 'Complete later text';
		offer.Complete_Later_Url__c = 'www.fleetone.com';
		offer.Complete_Later_Url_Label__c = 'Go to Fleet One';
		offer.EchoSign_Header_Image__c = 'http://www.poobah.com/image.png';
		offer.EchoSign_User_Email__c = 'mlattin@fleetone.com';
		offer.Faxed_Check_Fee_Disclosure__c = 'Faxed Disclosure';
		offer.Mailed_Check_Fee_Disclosure__c = 'Mailed Disclosure';
		offer.Mailed_Statement_Disclosure__c = 'Mailed Statement Disclosure';
		offer.Wire_Fee_Disclosure__c = 'Wire Disclosure';
		insert offer;

		Attachment att = new Attachment();
		att.Name = 'Test Terms and Conditions.html';
		att.Body = Blob.valueOf('test terms and conditions body');
		att.ParentId = offer.Id;
		insert att;

		return offer;
	}

	global HTTPResponse respond(HTTPRequest req) {

		HttpResponse res = new HttpResponse();

		if (req.getEndpoint().contains('forte')) {
			if (req.getHeader('Content-Type') == 'text/xml')
			res.setHeader('Content-Type', 'application/json');
			ForteAuthRequest authReq = ForteAuthRequest.deserialize(req.getBody());
			ForteAuthResponse authRes = new ForteAuthResponse();
			authRes.authorization_amount = authReq.authorization_amount;
			ForteAuthResponse.response response = new ForteAuthResponse.response();
			response.response_type = 'A';
			response.response_code = 'A01';
			response.response_desc = 'APPROVED';
			authRes.response = response;
			res.setBody(ForteAuthResponse.serialize(authRes));
			res.setStatusCode(201);
		}
		else {
			res.setHeader('Content-Type', 'text/xml');
			res.setHeader('Accept', 'text/xml');
			res.setBody('<?xml version="1.0" standalone="no"?>'
			            + '<NetConnectResponse>'
			            + '<CompletionCode>0000</CompletionCode>'
			            + '<ReferenceId>testing service pt-wex</ReferenceId>'
			            + '<TransactionId>26595478</TransactionId>'
			            + '<Products><BizID>'
			            + '<Header>'
			            + '<ReportDate>06012016</ReportDate>'
			            + '<ReportTime>051943</ReportTime>'
			            + '<TransactionID>BZD0617927740756515797893</TransactionID>'
			            + '</Header>'
			            + '<Decision>ACC</Decision>'
			            + '<OFACCode code="1"/>'
			            + '</BizID></Products></NetConnectResponse>'
			);
			res.setStatus('OK');
			res.setStatusCode(200);
		}

		return res;
	}

}