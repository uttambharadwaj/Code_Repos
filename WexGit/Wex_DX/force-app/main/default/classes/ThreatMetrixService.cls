/**
* Copyright 2014 Forseva, LLC.  All rights reserved.
*/
public with sharing class ThreatMetrixService {

    @future(callout=true)
    public static void processApplication(Id onlineApplicationId) {
    	    	
        ThreatMetrixService tms = new ThreatMetrixService();
        String response = tms.process(onlineApplicationId);
        System.debug('THREATMETRIX RESPONSE: ' + response);
        
        try {
        
        	Map<String, String> results = new Map<String, String>();

       		for(String pair : (EncodingUtil.urlDecode(response, 'UTF-8')).split('&')) {
                
        		results.put(pair.split('=')[0], pair.split('=')[1]);
                
       		}
        
        	List<OnlineApplication__c> onlineApplications = [SELECT Id, ThreatMetrix_Request_ID__c FROM OnlineApplication__c WHERE Id =: onlineApplicationId LIMIT 1];
        
        	if(onlineApplications.size() > 0) {
        
        		onlineApplications[0].ThreatMetrix_Request_ID__c = results.get('request_id');
        
        		upsert onlineApplications[0];
            
        	}
            
        }
        catch(Exception e) {
            System.debug('THREATMETRIX EXCEPTION: Unable to get request_id');
        }
        
    }

    public ThreatMetrixService() {}

    public String process(Id onlineApplicationId) {

        Map<String,String> parms = new Map<String,String>();

        try {

            OnlineApplication__c oaso = (OnlineApplication__c)SOUtility.getCompleteSObject(OnlineApplication__c.SOBjectType, onlineApplicationId);
            String baseUrl = OnlineApplicationParameters.getThreatMetrixURL();

            Http h = new Http();
            HttpRequest request = new HttpRequest();
            request.setTimeout(60000);
            request.setMethod('GET');

            parms.put('org_id', OnlineApplicationParameters.getThreatMetrixOrgId());
            parms.put('api_key', OnlineApplicationParameters.getThreatMetrixAPIKey());
            parms.put('session_id', '' + onlineApplicationId);                        
            parms.put('service_type', 'device');
            parms.put('event_type', 'ACCOUNT_CREATION');
            parms.put('transaction_id', oaso.Id);
            parms.put('account_name', oaso.Legal_Business_Name__c);
            parms.put('local_attrib_1', oaso.Trade_Name__c); 
            if(oaso.Federal_Tax_ID__c != null) {
                parms.put('ssn_hash', EncodingUtil.convertToHex(Crypto.generateDigest('SHA1', Blob.valueOf(oaso.Federal_Tax_ID__c))));
            }
            parms.put('account_address_street1', oaso.Business_Street_Address__c);
            parms.put('account_address_city', oaso.City__c);
            parms.put('account_address_state', oaso.State__c);
            parms.put('account_address_zip', oaso.Zip_Code__c);
            parms.put('account_telephone', oaso.Phone_Number__c);
            parms.put('local_attrib_2', oaso.Phone_Number__c);
            parms.put('local_attrib_3', oaso.AO_Name__c);
            parms.put('account_email', oaso.AO_Work_Email__c);
            parms.put('shipping_address_street1', oaso.Business_Street_Address__c);
            parms.put('shipping_address_city', oaso.City__c);
            parms.put('shipping_address_state', oaso.State__c);
            parms.put('shipping_address_zip', oaso.Zip_Code__c);
            parms.put('local_attrib_4', oaso.AO_Name__c);
            parms.put('local_attrib_5', oaso.AO_Work_Email__c);            
            parms.put('input_ip_address', oaso.IP_Address__c);

            String endpoint = baseUrl + '?' + mapToString(parms);
            request.setEndpoint(endpoint);
            if(!Test.isRunningTest()) {
                HttpResponse response = h.send(request);
        	    return response.getBody();
            }
            else {
                return 'test response';
            }
        }
        catch(Exception e) {
        	String msg = 'ERROR CALLING THREATMETRIX:' + e.getMessage() + ' -- ' + parms;
            System.debug(msg);
            return msg;
        }        
    }

    //------------------------
    // private
    //------------------------

    private String mapToString(Map<String,String> parms) {
    
        String parmString = '';
        List<String> keyList = new List<String>();
        keyList.addAll(parms.keySet());
                
        for(String key : keyList) {
        	String value = parms.get(key);
        	if(value != null) {
                if(parmString.length() > 0) {
                    parmString += '&';
                }
                parmString += (key + '=' + EncodingUtil.urlEncode(value, 'UTF-8'));
        	}
        }
        
        return parmString;
    }

}

// EOF