public with sharing class ForteIntegration {

//	public static final Integer BATCH_SIZE = 4;
//	public static Set<Id> processedIds = new Set<Id> ();
//
//	public static void verifyAcctRtNos(List<Id> records, Boolean callFromButton) {
//
//		Forte_Integration__mdt mdt = [SELECT API_Access_Key__c, API_Secure_Key__c, Endpoint__c, Location_Id__c, Organization_Id__c FROM Forte_Integration__mdt WHERE MasterLabel = 'Authentication'];
//		String endpoint = mdt.Endpoint__c + '/organizations/org_' + mdt.Organization_Id__c + '/locations/loc_' + mdt.Location_Id__c + '/transactions';
//
//		Blob headerValue = Blob.valueOf(mdt.API_Access_Key__c + ':' + mdt.API_Secure_Key__c);
//		String authHeader = 'Basic ' + EncodingUtil.base64Encode(headerValue);
//		String orgHeader = 'org_' + mdt.Organization_Id__c;
//
//		for (Integer i = 0; i<(records.size() / BATCH_SIZE) + 1; i++) {
//			List<Id> appIds = new List<Id> ();
//			for (Integer j = i * BATCH_SIZE; (j<(i * BATCH_SIZE) + BATCH_SIZE) && (j<records.size()); j++) {
//				appIds.add(records.get(j));
//			}
//
//			if (!appIds.isEmpty()) {
//				if (callFromButton == true) {
//					doCallouts(endpoint, authHeader, orgHeader, appIds);
//				} else {
//					doCalloutsAsync(endpoint, authHeader, orgHeader, appIds);
//				}
//			}
//		}
//	}
//
//	@future(callout = true)
//	public static void doCalloutsAsync(String endpoint, String authHeader, String orgHeader, List<Id> appIds) {
//		doCallouts(endpoint, authHeader, orgHeader, appIds);
//	}
//
//	public static void doCallouts(String endpoint, String authHeader, String orgHeader, List<Id> appIds) {
//
//		List<OnlineApplication__c> appList = new List<OnlineApplication__c> ();
//
//		Map<Id, OnlineApplication__c> appMap = new Map<Id, OnlineApplication__c> ([SELECT ABA_Routing_Number__c, Checking_Account_Number__c, Forte_Response_Type__c, Forte_Response_Code__c, Forte_Response_Message__c, Date_Sent_To_Forte__c FROM OnlineApplication__c WHERE Id IN :appIds]);
//
//		for (OnlineApplication__c app : appMap.values()) {
//
//			System.debug('endpoint = ' + endpoint);
//			System.debug('authHeader = ' + authHeader);
//			System.debug('orgHeader = ' + orgHeader);
//
//			HttpRequest req = new HttpRequest();
//			req.setEndpoint(endpoint);
//
//			req.setHeader('Authorization', authHeader);
//			req.setHeader('X-Forte-Auth-Organization-Id', orgHeader);
//			req.setHeader('Content-Type', 'application/json');
//
//			req.setMethod('POST');
//
//			ForteAuthRequest payload = new ForteAuthRequest();
//			payload.authorization_amount = 1.0;
//			payload.action = 'verify';
//			ForteAuthRequest.echeck ec = new ForteAuthRequest.echeck();
//			ec.routing_number = app.ABA_Routing_Number__c;
//			ec.account_number = app.Checking_Account_Number__c;
//			payload.echeck = ec;
//
//			System.debug(ForteAuthRequest.serialize(payload));
//
//			req.setBody(ForteAuthRequest.serialize(payload));
//
//			Http http = new Http();
//			try {
//				HTTPResponse res = http.send(req);
//
//				System.debug(res.getBody());
//
//				ForteAuthResponse authRes = ForteAuthResponse.deserialize(res.getBody());
//
//				app.Forte_Response_Type__c = authRes.response.response_type;
//				app.Forte_Response_Code__c = authRes.response.response_code;
//				app.Forte_Response_Message__c = authRes.response.response_desc;
//			}
//			catch(CalloutException e) {
//				app.Forte_Response_Message__c = e.getMessage();
//			}
//
//			app.Date_Sent_To_Forte__c = Datetime.now();
//			appList.add(app);
//		}
//
//		//perform DML after callouts
//		if (!appList.isEmpty()) {
//			update appList;
//		}
//	}
}