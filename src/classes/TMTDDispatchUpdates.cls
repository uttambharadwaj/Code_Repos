public with sharing class TMTDDispatchUpdates 
{
	private static Integer numBatchesSent = 0;
	private static Integer currentFutureCount = 0;

	public static void mainEntry(Map<Id, WeFormObject__c> oldMap, List<WeFormObject__c> newList)
	{
        if(!TestUtils.isRunningTest()){
		List<Id> idsToUpdate = new List<Id>();
		for(WeFormObject__c w : newList)
		{	
			WeFormObject__c old;
			if(oldMap != null) 
				old = oldMap.get(w.Id);
			
			if(includeInUpdate(old, w)) 
				idsToUpdate.add(w.Id);
		}
				
		Integer recordsProcessed = 0;
		Integer recordsToProcess = 100 > idsToUpdate.size() ? idsToUpdate.size() : 100;
		if(idsToUpdate.size() > 0)
		{
			while(recordsProcessed < recordsToProcess)
			{
				List<Id> batchIds = new List<Id>();
				Integer batchSize = 10 > idsToUpdate.size() ? idsToUpdate.size() : 10;
				
				for(Integer j = 0; j < batchSize; j++)
				{
					if(idsToUpdate.size() > 0)
					{
						batchIds.add(idsToUpdate[0]);
						idsToUpdate.remove(0);
						recordsProcessed += 1;
					}
				}

				if(batchIds.size() > 0)
				{
					// Send batch of <= 10 to @Future method
					futureUpdateBatch(batchIds);
					//updateBatch(batchIds); // Switch back to future after testing
				}
				else
				{
					break;
				}
			}
		}
        }
	}
	
	private static Boolean includeInUpdate(WeFormObject__c oldW, WeFormObject__c newW)
	{
		Boolean retVal = false;
		
		if(newW != null && newW.Opportunity__c != null && newW.status__c != null && !(newW.status__c).equalsIgnoreCase('partial'))
			retVal = true;
		
        System.debug('### WeFormObject ID: ' + newW.Id + ', Status__c: ' + newW.status__c + ', Include in TM Update: ' + retVal);
        
		return retVal;
	}
	
	@future(callout=true)
	public static void futureUpdateBatch(List<Id> objIds)
	{
		system.debug('[MCS] objIds: ' + objIds);
		
		updateBatch(objIds);
	}
	
	public static void updateBatch(List<Id> objIds)
	{
		if(objIds == null || objIds.size() == 0) return;
		
		List<WeFormObject__c> weObjs = [SELECT Id, Zip_code__c, Taxpayer_ID__c, State__c, Signer_s_Last_Name__c, Signer_s_First_Name__c, 
			Signer_s_Email__c, IPAddress__c, Doing_Business_As__c, Company_Name__c, City__c, Business_fax__c, Business_Street_Address__c, Business_Phone__c, 
			Billing_Zip_Code__c, Billing_Street_Address__c, Billing_Email__c, Billing_Contact_Last_Name__c, Billing_Contact_First_Name__c, Billing_City__c, 
			Billing_Address_Line_2__c, Address_Line_2__c, TM_Event_Type__c, TM_Session_Id__c, Opportunity__c, Online_Application__c, Program__c, Program__r.BOCA_Type__c
			FROM WeFormObject__c 
			WHERE Id IN :objIds];
			
		system.debug('[MCS] updateBatch weObjs: ' + weObjs);
		system.debug('[MCS] objIds.size(): ' + objIds.size());
		
		for(WeFormObject__c w : weObjs)
		{

			if(w.Program__c != null && w.Program__r.BOCA_Type__c != null && !(w.Program__r.BOCA_Type__c).equalsIgnoreCase('OTR') && !TestUtils.isRunningTest()) {
				continue;
			}

			UpdateResponse ur = updateRecord(w);
			
			// Diagnostics
			system.debug('[MCS] UpdateResponse.success: ' + ur.success);
			system.debug('[MCS] UpdateResponse.endpoint: ' + ur.endpoint);
			system.debug('[MCS] UpdateResponse.response: ' + ur.response);
			
			/*
			String str = 'Callout details:' + '\n\n';
			str += 'Success: ' + ur.success + '\n';
			str += 'Endpoint: '+ ur.endpoint + '\n';
			str += 'Response: '+ ur.response + '\n';
			
			sendEmail(str);
			*/
		}
	}
	
	public class UpdateResponse
	{
		public String endpoint {get; set;}
		public Boolean success {get; set;}
		public String response {get; set;}
		
		public UpdateResponse(String endpoint, Boolean success, String response)
		{
			this.endpoint = endpoint;
			this.success = success;
			this.response = response;
		}
	}

	public static UpdateResponse updateRecord(WeFormObject__c w)
	{
		UpdateResponse retVal = new UpdateResponse('', false, '');
		if(Limits.getLimitCallouts() - Limits.getCallouts() <= 0) return retVal;
		
		String baseURL = 'https://h-api.online-metrix.net/api/session-query';

		//try
		//{
	        Http h = new Http();
	        HttpRequest req = new HttpRequest();
			req.setTimeout(120000);
	        req.setMethod('GET');

			List<KeyValue> kv = new List<KeyValue>();
			kv.add(new KeyValue('org_id', EncodingUtil.urlEncode('bkwau9ws', 'UTF-8')));
			kv.add(new KeyValue('api_key', EncodingUtil.urlEncode('6wwgbf2gdnx6wy2z', 'UTF-8')));
			if(w.TM_Session_ID__c != null) kv.add(new KeyValue('session_id', w.TM_Session_ID__c));
			kv.add(new KeyValue('service_type', EncodingUtil.urlEncode('device', 'UTF-8')));
			//if(w.Id != null) kv.add(new KeyValue('transaction_id', EncodingUtil.urlEncode(w.Id, 'UTF-8')));
			if(w.Opportunity__c != null) kv.add(new KeyValue('transaction_id', EncodingUtil.urlEncode(w.Opportunity__c, 'UTF-8')));
			if(w.TM_Event_Type__c != null) kv.add(new KeyValue('event_type', EncodingUtil.urlEncode(w.TM_Event_Type__c, 'UTF-8')));
			if(w.Company_Name__c != null) kv.add(new KeyValue('account_name', EncodingUtil.urlEncode(w.Company_Name__c, 'UTF-8')));
			if(w.Doing_Business_As__c != null) kv.add(new KeyValue('local_attrib_1', EncodingUtil.urlEncode(w.Doing_Business_As__c, 'UTF-8')));
			if(w.Taxpayer_ID__c != null) kv.add(new KeyValue('ssn_hash', EncodingUtil.convertToHex(Crypto.generateDigest('SHA1', Blob.valueOf(w.Taxpayer_ID__c)))));
			if(w.Business_Street_Address__c != null) kv.add(new KeyValue('account_address_street1', EncodingUtil.urlEncode(w.Business_Street_Address__c, 'UTF-8')));
			if(w.Address_Line_2__c != null) kv.add(new KeyValue('account_address_street2', EncodingUtil.urlEncode(w.Address_Line_2__c, 'UTF-8')));
			if(w.City__c != null) kv.add(new KeyValue('account_address_city', EncodingUtil.urlEncode(w.City__c, 'UTF-8')));
			if(w.State__c != null) kv.add(new KeyValue('account_address_state', EncodingUtil.urlEncode(w.State__c, 'UTF-8')));
			if(w.Zip_Code__c != null) kv.add(new KeyValue('account_address_zip', EncodingUtil.urlEncode(w.Zip_Code__c, 'UTF-8')));
			if(w.Business_Phone__c != null) kv.add(new KeyValue('account_telephone', EncodingUtil.urlEncode(w.Business_Phone__c, 'UTF-8')));
			if(w.Business_Fax__c != null) kv.add(new KeyValue('local_attrib_2', EncodingUtil.urlEncode(w.Business_Fax__c, 'UTF-8')));
			
			// Safe name concat
			//kv.add(new KeyValue('local_attrib_3', EncodingUtil.urlEncode((w.Signer_s_Last_Name__c == null ? '' : w.Signer_s_Last_Name__c) + ', ' + (w.Signer_s_First_Name__c == null ? '' : w.Signer_s_First_Name__c), 'UTF-8')));
			kv.add(new KeyValue('local_attrib_3', EncodingUtil.urlEncode(safeConcat(w.Signer_s_First_Name__c, w.Signer_s_Last_Name__c), 'UTF-8')));
			
			if(w.Signer_s_Email__c != null) kv.add(new KeyValue('account_email', EncodingUtil.urlEncode(w.Signer_s_Email__c, 'UTF-8')));
			if(w.Billing_Street_Address__c != null) kv.add(new KeyValue('shipping_address_street1', EncodingUtil.urlEncode(w.Billing_Street_Address__c, 'UTF-8')));
			if(w.Billing_Address_Line_2__c != null) kv.add(new KeyValue('shipping_address_street2', EncodingUtil.urlEncode(w.Billing_Address_Line_2__c, 'UTF-8')));
			if(w.Billing_City__c != null) kv.add(new KeyValue('shipping_address_city', EncodingUtil.urlEncode(w.Billing_City__c, 'UTF-8')));
			if(w.State__c != null) kv.add(new KeyValue('shipping_address_state', EncodingUtil.urlEncode(w.State__c, 'UTF-8')));
			if(w.Billing_Zip_Code__c != null) kv.add(new KeyValue('shipping_address_zip', EncodingUtil.urlEncode(w.Billing_Zip_Code__c, 'UTF-8')));

			// Safe name concat
			//kv.add(new KeyValue('local_attrib_4', EncodingUtil.urlEncode((w.Billing_Contact_Last_Name__c == null ? '' : w.Billing_Contact_Last_Name__c) + ', ' + (w.Billing_Contact_First_Name__c == null ? '' : w.Billing_Contact_First_Name__c), 'UTF-8')));
			kv.add(new KeyValue('local_attrib_4', EncodingUtil.urlEncode(safeConcat(w.Billing_Contact_First_Name__c, w.Billing_Contact_Last_Name__c), 'UTF-8')));

			if(w.Billing_Email__c != null) kv.add(new KeyValue('local_attrib_5', EncodingUtil.urlEncode(w.Billing_Email__c, 'UTF-8')));
			if(w.IPAddress__c != null) kv.add(new KeyValue('input_ip_address', EncodingUtil.urlEncode(w.IPAddress__c, 'UTF-8')));

	        String endpoint = baseURL + '?' + paramStringFromList(kv);
	        req.setEndpoint(endpoint);
	        HttpResponse res = h.send(req);
	        
	        // Assuming the return values are good...
	        retVal.endpoint = endpoint;
	        retVal.response = res.getBody();
	        retVal.success = true;
		//}
		//catch(Exception e)
		//{
			// Nothing to do since retVal defaults to fail
		//}
		//
		System.debug(res.getBody());
        
        if(w.Online_Application__c != null) {
            
            Map<String, String> results = new Map<String, String>();

            for(String pair : (EncodingUtil.urlDecode(retval.response, 'UTF-8')).split('&')) {
                
                try {
               		results.put(pair.split('=')[0], pair.split('=')[1]);
                } catch (ListException lex) {
                    System.debug('No variable value returned.');
                }
                
            }
            
	        OnlineApplication__c onlineApplication = new OnlineApplication__c();
            
    	    onlineApplication.Id = w.Online_Application__c;
        	onlineApplication.ThreatMetrix_Request_ID__c = results.get('request_id');
        
        	upsert onlineApplication;
            
        }
		
		return retVal;
	}
	
	private static String safeConcat(String firstName, String lastName)
	{
		String retVal = '';
		
		if(firstName != null && lastName != null)
			retVal = lastName + ', ' + firstName;
		else if(firstName != null)
			retVal = firstName;
		else if(lastName != null) // Just in case logic changes later, default retVal to ''
			retVal = lastName;
		
		return retVal;
	}

	// Support for endpoint parameters
	public class KeyValue
	{
		public String key {get; set;}
		public String value {get; set;}
		
		public KeyValue(String k, String v)
		{
			this.key = k;
			this.value = v;
		}
	} 

	private static String paramStringFromList(List<KeyValue> kVals)
	{
		String retVal = '';

		for(KeyValue kv : kVals)
		{
			retVal += kv.key + '=' + kv.value + '&';
		}
		
		// Trim last ampersand
		if(retVal != '') retVal = retVal.subString(0, retVal.length() - 1);

		return retVal;
	}
	


    public static void sendEmail(String body)
    {
    	sendEmail('debug', body);
    }
    public static void sendEmail(String subject, String body)
    {
    	sendEmail(subject, body, 'apurkiss@mondaycall.com');
    }
    public static void sendEmail(String subject, String body, String toAddress)
    {
    	if(subject != null && body != null && toAddress != null)
    	{
	        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
	        String[] toAddresses = new String[] {toAddress};
	        mail.setToAddresses(toAddresses);
	        mail.setSubject(subject);
	        mail.setPlainTextBody(body);
	        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    	}
    }
}