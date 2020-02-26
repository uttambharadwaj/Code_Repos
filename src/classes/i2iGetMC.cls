/*
* Description: Make call to Marketing Cloud and pass data to i2iSearchController
* Author: Lev
* Date: October 2019
*/
public class i2iGetMC {
    public static String authEndpoint = 'callout:Marketing_Cloud_Authorization';
    public static String servicesEndpoint = 'callout:Marketing_Cloud_Services';
    public static String soapBody = '{"grant_type": "client_credentials", "client_id": "{!$Credential.UserName}","client_secret": "{!$Credential.Password}"}';
    public static List<i2iGet.returnData> rd;
    public static List<Search_Tool_Mapping__mdt> mapping = [SELECT Id, Marketing_Cloud_Field__c, Quick_Pivot_Field__c FROM Search_Tool_Mapping__mdt];
    
   /*
	* Description: Create filter based on search parameters for envelope sent
	* Parameters: Values entered into search tool
	* Return: String of parameters to add 
	*/
    public static String compileFilterCriteria(String couponCode, String leadNumber, String programSelected, String phonepass, String company, String zipcode, String email) {
        String filters;
        String endingFilter = '</Filter>';
        Map<String,String> filterMap = new Map<String,String>();
        
        if (String.isNotBlank(couponCode)) {
            filterMap.put('CouponCode', couponCode);
        }   
        if (String.isNotBlank(leadNumber)) {
            filterMap.put('LeadNumber', leadNumber);
        }
        if(programSelected != '' && programSelected != null){
            filterMap.put('ProgramName', programSelected);            
        } if(phonePass != '' && phonePass != null){
            filterMap.put('Phone', phonePass);            
        } if(company != '' && company != null){
            filterMap.put('Company', company);            
        } if(zipCode != '' && zipCode != null){
            filterMap.put('PostalCode', zipCode);            
        } if(email != '' && email != null) {
            filterMap.put('EmailAddress', email);
        }
      
        //Return nothing is all search Criterias are null        
        if(filterMap.isEmpty()){
            return '';    
        } else if(filterMap.size() == 1) {
            filters = '<Filter xsi:type="SimpleFilterPart">';
            Set<String> keys = new Set<String>();
            keys =filterMap.keySet();
            String key = new List<String> (keys).get(0);
            String value = filterMap.get(key);
            String addedFilter = '<Property>' + key + '</Property>';
            String operator = '<SimpleOperator>';
            if(value.contains('*')){
                String updatedVal = value.substringBefore('*');
                operator += 'like</SimpleOperator><Value>' + updatedVal + '</Value>';
            } else {
                operator += 'equals</SimpleOperator><Value>' + value + '</Value>';
            }
            addedFilter += operator;
            filters += addedFilter;
        } else if(filterMap.size() == 2){
            filters = compile2Filters(filterMap);
        } else if(filterMap.size() == 3) {
        	filters = compile3Filters(filterMap);    
        } else if(filterMap.size() == 4) {
            filters = compile4Filters(filterMap);    
        } else if(filterMap.size() == 5) {
            filters = compile5Filters(filterMap);    
        } else if(filterMap.size() == 6) {
            filters = compile6Filters(filterMap);    
        } else if (filterMap.size() == 7) {
            filters = compile7Filters(filterMap);
        }
        
        filters += endingFilter;
        return filters;
    }
    
    public static String compile2Filters(Map<String, String> filterMap) {
        String filters = '<Filter xsi:type="ComplexFilterPart">';
            Integer i = 0;
            for(String key : filterMap.keySet()) { 
                String value = filterMap.get(key);
                if(i == 0) {
                    //Enable Wildcard searching in MC
                    if(value.contains('*')) {
                        String updatedVal = value.substringBefore('*');
                        String operator = handleWildCard('<LeftOperand xsi:type="SimpleFilterPart">', key, updatedVal, '</LeftOperand>');
                        filters += operator;
                        i++;
                    } else {
                        String operator = handleNonWildCard('<LeftOperand xsi:type="SimpleFilterPart">', key, value, '</LeftOperand>');
                        filters += operator;
                        i++;
                    }
                } else {
                    //Enable Wildcard searching in MC
                    if(value.contains('*')) {
                        String updatedVal = value.substringBefore('*');
                        String operator = handleWildCard('<LogicalOperator>AND</LogicalOperator><RightOperand xsi:type="SimpleFilterPart">', key, updatedVal, '</RightOperand>');
                        filters += operator;
                        i++;
                    } else {
                        String operator = handleNonWildCard('<LogicalOperator>AND</LogicalOperator><RightOperand xsi:type="SimpleFilterPart">', key, value,'</RightOperand>');
                        filters += operator;
                        i++;
                    }
                }
            }
        return filters;
    }
    public static String compile3Filters(Map<String, String> filterMap) {
        String filters = '<Filter xsi:type="ComplexFilterPart"><LeftOperand xsi:type="ComplexFilterPart">';
            Integer i = 0;
            for(String key : filterMap.keySet()) { 
                String value = filterMap.get(key);
                if(i == 0) {
                    //Enable Wildcard searching in MC
                    if(value.contains('*')) {
                        String updatedVal = value.substringBefore('*');
                        String operator = handleWildCard('<LeftOperand xsi:type="SimpleFilterPart">', key, updatedVal, '</LeftOperand>');
                        filters += operator;
                        i++;
                    } else {
                        String operator = handleNonWildCard('<LeftOperand xsi:type="SimpleFilterPart">', key, value, '</LeftOperand>');
                        filters += operator;
                        i++;
                    }
                } else if(i == 1) {
                    //Enable Wildcard searching in MC
                    if(value.contains('*')) {
                        String updatedVal = value.substringBefore('*');
                        String operator = handleWildCard('<LogicalOperator>AND</LogicalOperator><RightOperand xsi:type="SimpleFilterPart">', key, updatedVal, '</RightOperand></LeftOperand>');
                        filters += operator;
                        i++;
                    } else {
                        String operator = handleNonWildCard('<LogicalOperator>AND</LogicalOperator><RightOperand xsi:type="SimpleFilterPart">', key, value, '</RightOperand></LeftOperand>');
                        filters += operator;
                        i++;
                    }
                } else {
                    //Enable Wildcard searching in MC
                    if(value.contains('*')) {
                        String updatedVal = value.substringBefore('*');
                        String operator = handleWildCard('<LogicalOperator>AND</LogicalOperator><RightOperand xsi:type="SimpleFilterPart">' , key, updatedVal, '</RightOperand>');
                        filters += operator;
                        i++;
                    } else {
                        String operator = handleNonWildCard('<LogicalOperator>AND</LogicalOperator><RightOperand xsi:type="SimpleFilterPart">', key, value, '</RightOperand>');
                        filters += operator;
                        i++;
                    }
                }
            }
        return filters;
    }
    public static String compile4Filters(Map<String, String> filterMap) {
        String filters = '<Filter xsi:type="ComplexFilterPart"><LeftOperand xsi:type="ComplexFilterPart">';
        Integer i = 0;
        for(String key : filterMap.keySet()) { 
            String value = filterMap.get(key);
            System.debug('compile4Filters i ' + i);
            if(i == 0) {
                //Enable Wildcard searching in MC
                if(value.contains('*')) {
                    String updatedVal = value.substringBefore('*');
                    String operator = handleWildCard('<LeftOperand xsi:type="SimpleFilterPart">', key, updatedVal, '</LeftOperand>');
                    filters += operator;
                    i++;
                } else {
                    String operator = handleNonWildCard('<LeftOperand xsi:type="SimpleFilterPart">', key, value, '</LeftOperand>');
                    filters += operator;
                    i++;
                }
            } else if(i == 1) {
                //Enable Wildcard searching in MC
                if(value.contains('*')) {
                    String updatedVal = value.substringBefore('*');
                    String operator = handleWildCard('<LogicalOperator>AND</LogicalOperator><RightOperand xsi:type="SimpleFilterPart">', key, updatedVal, '</RightOperand></LeftOperand>');
                    filters += operator;
                    i++;
                } else {
                    String operator = handleNonWildCard('<LogicalOperator>AND</LogicalOperator><RightOperand xsi:type="SimpleFilterPart">', key, value, '</RightOperand></LeftOperand>');
                    filters += operator;
                    i++;
                }
            } else if(i==2){
                //Enable Wildcard searching in MC
                if(value.contains('*')) {
                    String updatedVal = value.substringBefore('*');
                    String operator = handleWildCard('<LogicalOperator>AND</LogicalOperator><RightOperand xsi:type="ComplexFilterPart"><LeftOperand xsi:type="SimpleFilterPart">', key, updatedVal, '</LeftOperand>');
                    filters += operator;
                    i++;
                } else {
                    String operator = handleNonWildCard('<LogicalOperator>AND</LogicalOperator><RightOperand xsi:type="ComplexFilterPart"><LeftOperand xsi:type="SimpleFilterPart">', key, value, '</LeftOperand>');
                    filters += operator;
                    i++;
                }
            }  else {
                //Enable Wildcard searching in MC
                if(value.contains('*')) {
                    String updatedVal = value.substringBefore('*');
                    String operator = handleWildCard('<LogicalOperator>AND</LogicalOperator><RightOperand xsi:type="SimpleFilterPart">', key, updatedVal,'</RightOperand></RightOperand>');
                    filters += operator;
                    i++;
                } else {
                    String operator = handleNonWildCard('<LogicalOperator>AND</LogicalOperator><RightOperand xsi:type="SimpleFilterPart">', key, value, '</RightOperand></RightOperand>');
                    filters += operator;
                    i++;
                }
            }
        }
        return filters;
    }
    public static String compile5Filters(Map<String, String> filterMap) {
        String filters = '<Filter xsi:type="ComplexFilterPart"><LeftOperand xsi:type="ComplexFilterPart">';
        Integer i = 0;
        for(String key : filterMap.keySet()) { 
            String value = filterMap.get(key);
            if(i == 0) {
                //Enable Wildcard searching in MC
                if(value.contains('*')) {
                    String updatedVal = value.substringBefore('*');
                    String operator = handleWildCard('<LeftOperand xsi:type="SimpleFilterPart">', key, updatedVal, '</LeftOperand>');
                    filters += operator;
                    i++;
                } else {
                    String operator = handleNonWildCard('<LeftOperand xsi:type="SimpleFilterPart">', key, value, '</LeftOperand>');
                    filters += operator;
                    i++;
                }
            } else if(i == 1) {
                //Enable Wildcard searching in MC
                if(value.contains('*')) {
                    String updatedVal = value.substringBefore('*');
                    String operator = handleWildCard('<LogicalOperator>AND</LogicalOperator><RightOperand xsi:type="SimpleFilterPart">', key, updatedVal, '</RightOperand></LeftOperand>');
                    filters += operator;
                    i++;
                } else {
                    String operator = handleNonWildCard('<LogicalOperator>AND</LogicalOperator><RightOperand xsi:type="SimpleFilterPart">', key, value, '</RightOperand></LeftOperand>');
                    filters += operator;
                    i++;
                }
            } else if(i == 2){
                //Enable Wildcard searching in MC
                if(value.contains('*')) {
                    String updatedVal = value.substringBefore('*');
                    String operator = handleWildCard('<LogicalOperator>AND</LogicalOperator><RightOperand xsi:type="ComplexFilterPart"><LeftOperand xsi:type="SimpleFilterPart">', key, updatedVal, '</LeftOperand>');
                    filters += operator;
                    i++;
                } else {
                    String operator = handleNonWildCard('<LogicalOperator>AND</LogicalOperator><RightOperand xsi:type="ComplexFilterPart"><LeftOperand xsi:type="SimpleFilterPart">', key, value, '</LeftOperand>');
                    filters += operator;
                    i++;
                }
            }  else if(i == 3) {
                //Enable Wildcard searching in MC
                if(value.contains('*')) {
                    String updatedVal = value.substringBefore('*');
                    String operator = handleWildCard('<LogicalOperator>AND</LogicalOperator><RightOperand xsi:type="SimpleFilterPart">', key, updatedVal,'</RightOperand></RightOperand>');
                    filters += operator;
                    i++;
                } else {
                    String operator = handleNonWildCard('<LogicalOperator>AND</LogicalOperator><RightOperand xsi:type="SimpleFilterPart">', key, value, '</RightOperand></RightOperand>');
                    filters += operator;
                    i++;
                }
            } else {
                //Enable Wildcard searching in MC
                if(value.contains('*')) {
                    String updatedVal = value.substringBefore('*');
                    String operator = handleWildCard('<LogicalOperator>AND</LogicalOperator><RightOperand xsi:type="SimpleFilterPart">', key, updatedVal, '</RightOperand>');
                    filters += operator;
                    i++;
                } else {
                    String operator = handleNonWildCard('<LogicalOperator>AND</LogicalOperator><RightOperand xsi:type="SimpleFilterPart">', key, value, '</RightOperand>');
                    filters += operator;
                    i++;
                }
            }
        }
        return filters;
    }
    public static String compile6Filters(Map<String, String> filterMap) {
        String filters = '<Filter xsi:type="ComplexFilterPart"><LeftOperand xsi:type="ComplexFilterPart">';
        Integer i = 0;
        for(String key : filterMap.keySet()) { 
            System.debug('i ' + i);
            String value = filterMap.get(key);
            if(i == 0) {
                //Enable Wildcard searching in MC
                if(value.contains('*')) {
                    String updatedVal = value.substringBefore('*');
                    String operator = handleWildCard('<LeftOperand xsi:type="SimpleFilterPart">', key, updatedVal, '</LeftOperand>');
                    filters += operator;
                    i++;
                } else {
                    String operator = handleNonWildCard('<LeftOperand xsi:type="SimpleFilterPart">', key, value, '</LeftOperand>');
                    filters += operator;
                    i++;
                }
            } else if(i == 2) {
                //Enable Wildcard searching in MC
                if(value.contains('*')) {
                    String updatedVal = value.substringBefore('*');
                    String operator = handleWildCard('<LogicalOperator>AND</LogicalOperator><RightOperand xsi:type="SimpleFilterPart">', updatedVal, key, '</RightOperand></LeftOperand>');
                    filters += operator;
                    i++;
                } else {
                    String operator = handleNonWildCard('<LogicalOperator>AND</LogicalOperator><RightOperand xsi:type="SimpleFilterPart">', value, key, '</RightOperand></LeftOperand>');
                    filters += operator;
                    i++;
                }
            } else if(i==3){
                //Enable Wildcard searching in MC
                if(value.contains('*')) {
                    String updatedVal = value.substringBefore('*');
					String operator = handleWildCard('<LogicalOperator>AND</LogicalOperator><RightOperand xsi:type="ComplexFilterPart"><LeftOperand xsi:type="SimpleFilterPart">', key, updatedVal, '</LeftOperand>');
                    filters += operator;
                    i++;
                } else {
                    String operator = handleNonWildCard('<LogicalOperator>AND</LogicalOperator><RightOperand xsi:type="ComplexFilterPart"><LeftOperand xsi:type="SimpleFilterPart">', key, value, '</LeftOperand>');
                    filters += operator;
                    i++;
                }
            } else if(i==4){
                //Enable Wildcard searching in MC
                if(value.contains('*')) {
                    String updatedVal = value.substringBefore('*');
                    String operator = handleWildCard('<LogicalOperator>AND</LogicalOperator><RightOperand xsi:type="SimpleFilterPart">', key, updatedVal, '</RightOperand></RightOperand>');
                    filters += operator;
                    i++;
                } else {
                    String operator = handleNonWildCard('<LogicalOperator>AND</LogicalOperator><RightOperand xsi:type="SimpleFilterPart">', key, value, '</RightOperand></RightOperand>');
                    filters += operator;
                    i++;
                }
            } else {
                //Enable Wildcard searching in MC
                if(value.contains('*')) {
                    String updatedVal = value.substringBefore('*');
                    String operator = handleWildCard('<LogicalOperator>AND</LogicalOperator><RightOperand xsi:type="SimpleFilterPart">',key, updatedVal, '</RightOperand>');
                    filters += operator;
                    i++;
                } else {
                    String operator = handleNonWildCard('<LogicalOperator>AND</LogicalOperator><RightOperand xsi:type="SimpleFilterPart">', key, value, '</RightOperand>');
                    filters += operator;
                    i++;
                }
            }
        }
        return filters;
    }
    public static String compile7Filters(Map<String, String> filterMap) {
        String filters = '<Filter xsi:type="ComplexFilterPart"><LeftOperand xsi:type="ComplexFilterPart">';
        Integer i = 0;
        for(String key : filterMap.keySet()) { 
            System.debug('i ' + i);
            String value = filterMap.get(key);
            if(i == 0) {
                //Enable Wildcard searching in MC
                if(value.contains('*')) {
                    String updatedVal = value.substringBefore('*');
                    String operator = handleWildCard('<LeftOperand xsi:type="SimpleFilterPart">', key, updatedVal, '</LeftOperand>');
                    filters += operator;
                    i++;
                } else {
                    String operator = handleNonWildCard('<LeftOperand xsi:type="SimpleFilterPart">', key, value, '</LeftOperand>');
                    filters += operator;
                    i++;
                }
            } else if(i == 1) {
                //Enable Wildcard searching in MC
                if(value.contains('*')) {
                    String updatedVal = value.substringBefore('*');
                    String operator = handleWildCard('<LogicalOperator>AND</LogicalOperator><RightOperand xsi:type="SimpleFilterPart">', key, updatedVal, '</RightOperand></LeftOperand>');
                    filters += operator;
                    i++;
                } else {
                    String operator = handleNonWildCard('<LogicalOperator>AND</LogicalOperator><RightOperand xsi:type="SimpleFilterPart">', key, value, '</RightOperand></LeftOperand>');
                    filters += operator;
                    i++;
                }
            } else if(i==2){
                //Enable Wildcard searching in MC
                if(value.contains('*')) {
                    String updatedVal = value.substringBefore('*');
					String operator = handleWildCard('<LogicalOperator>AND</LogicalOperator><RightOperand xsi:type="ComplexFilterPart"><LeftOperand xsi:type="SimpleFilterPart">', key, updatedVal, '</LeftOperand>');
                    filters += operator;
                    i++;
                } else {
                    String operator = handleNonWildCard('<LogicalOperator>AND</LogicalOperator><RightOperand xsi:type="ComplexFilterPart"><LeftOperand xsi:type="SimpleFilterPart">', key, value, '</LeftOperand>');
                    filters += operator;
                    i++;
                }
            } else if(i==3){
                //Enable Wildcard searching in MC
                if(value.contains('*')) {
                    String updatedVal = value.substringBefore('*');
                    String operator = handleWildCard('<LogicalOperator>AND</LogicalOperator><RightOperand xsi:type="SimpleFilterPart">', key, updatedVal, '</RightOperand></RightOperand>');
                    filters += operator;
                    i++;
                } else {
                    String operator = handleNonWildCard('<LogicalOperator>AND</LogicalOperator><RightOperand xsi:type="SimpleFilterPart">', key, value, '</RightOperand></RightOperand>');
                    filters += operator;
                    i++;
                }
            } else if(i==4){
                if(value.contains('*')) {
                    String updatedVal = value.substringBefore('*');
					String operator = handleWildCard('<LogicalOperator>AND</LogicalOperator><RightOperand xsi:type="ComplexFilterPart"><LeftOperand xsi:type="SimpleFilterPart">', key, updatedVal, '</LeftOperand>');
                    filters += operator;
                    i++;
                } else {
					String operator = handleNonWildCard('<LogicalOperator>AND</LogicalOperator><RightOperand xsi:type="ComplexFilterPart"><LeftOperand xsi:type="SimpleFilterPart">', key, value, '</LeftOperand>');
                    filters += operator;
                    i++;
                }
            } else if( i == 5){
                if(value.contains('*')) {
                    String updatedVal = value.substringBefore('*');
                    String operator = handleWildCard('<LogicalOperator>AND</LogicalOperator><RightOperand xsi:type="SimpleFilterPart">',key, updatedVal, '</RightOperand></RightOperand>');
                    filters += operator;
                    i++;
                } else {
                    String operator = handleNonWildCard('<LogicalOperator>AND</LogicalOperator><RightOperand xsi:type="SimpleFilterPart">', key, value, '</RightOperand></RightOperand>');
                    filters += operator;
                    i++;
                }
            } else {
                if(value.contains('*')) {
                    String updatedVal = value.substringBefore('*');
                    String operator = handleWildCard('<LogicalOperator>AND</LogicalOperator><RightOperand xsi:type="SimpleFilterPart">',key, updatedVal, '</RightOperand>');
                    filters += operator;
                    i++;
                } else {
                    String operator = handleNonWildCard('<LogicalOperator>AND</LogicalOperator><RightOperand xsi:type="SimpleFilterPart">', key, value, '</RightOperand>');
                    filters += operator;
                    i++;
                }               
            }
        }
        return filters;
    }
    
    public static String handleWildCard(String beginning, String key, String value, String ending) {
        String operator = beginning + '<Property>' + key + '</Property><SimpleOperator>like</SimpleOperator>' 
            +'<Value>' + value + '</Value>' + ending;
        return operator;
    } 
    public static String handleNonWildCard(String beginning, String key, String value, String ending) {
        String operator = beginning + '<Property>' + key + 
            '</Property><SimpleOperator>equals</SimpleOperator><Value>' + value + '</Value>' + ending;
        return operator;
    }
    /*
	* Description: Set up authorization call to retrieve oAuth Token from MC
	* Return: the access token for authorization
	*/
    public static String authAccessToken() {
        try {
            Http h = new Http();
            HttpRequest r = new HttpRequest();
            r.setTimeout(60000);
            r.setEndpoint(authEndpoint);
            r.setMethod('POST');
            r.setHeader('Content-type', 'application/json');
            r.setBody(soapBody);
            HttpResponse res = h.send(r);
            Map<String, Object> incidentMap = (Map<String, Object>)JSON.deserializeUntyped(res.getBody());
            String returnedBody = JSON.serialize(incidentMap);
            JSONParser parser = JSON.createParser(returnedBody);
            while(parser.nextToken() != null) {
                if(parser.getCurrentToken() == JSONToken.FIELD_NAME) {
                    String fieldName = parser.getText();
                    parser.nextToken();
                    if(fieldName == 'access_token') {
                        return parser.getText();    
                    }
                }
            }
            
            return res.getBody();            
        } catch (Exception e) {
            External_Application_Error__c error = new External_Application_Error__c();
            error.Error_Location__c = 'Line Number: ' + e.getLineNumber() + ' , Trace: ' + e.getStackTraceString();
            error.Error_Message__c = e.getMessage();
            error.Application__c = 'i2iGetMC.authAccessToken';
            insert error;
            
            String empty = '';
            return empty;
        }
        
    }
    
    /*
	* Description: Called from sendTokenMC, gets endpoint of MarketingCloud and the body to send
	* Parameters: Marketing Cloud endpoind and soapBody to send to Marketing Cloud
	* Return: XML body from Marketing Cloud
	*/
    public static String makeHttpXMLPost(String endPoint, String soapBody) {
        try {
            http h = new Http();
            HttpRequest r = new HttpRequest();
            r.setTimeout(60000);
            r.setEndpoint(endPoint);  
            r.setMethod('POST');
            r.setHeader('SOAPAction','Retrieve'); 
            r.setHeader('Accept','text/xml');  
            r.setHeader('Content-type','text/xml');    
            r.setHeader('charset','UTF-8'); 
            r.setBody(soapBody);   
            System.debug('body sent ' + r.getBody());
            HttpResponse s = h.send(r);
            return s.getBody();
        } catch (Exception e) {
            External_Application_Error__c error = new External_Application_Error__c();
            error.Error_Location__c = 'Line Number: ' + e.getLineNumber() + ' , Trace: ' + e.getStackTraceString();
            error.Error_Message__c = e.getMessage();
            error.Application__c = 'i2iGetMC.makeHttpXMLPost';
            insert error;
            
            String empty = '';
            return empty;
        }
    }
    
    /*
	* Description: Called from i2iSearchController, gets access token, compiles the filters from search tool and 
	* 				makes callout to Marketing Cloud.
	* Parameters: All search criteria filled out in Search table
	* Return: Records from Marketing Cloud in proper format
	*/
    // public static List<i2iGet.returnData> sendTokenMC (String couponCode, String subscriberKey, String programSelected, String phonepass, String company, String zipcode, String email) {
    public static List<i2iGet.returnData> sendTokenMC (String couponCode, String leadNumber, String programSelected, String phonepass, String company, String zipcode, String email) {
        String accessToken = authAccessToken();
        String filters = compileFilterCriteria(couponCode, leadNumber, programSelected, phonepass, company, zipcode, email);
        
        String soapEnvelope = '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"> '  + 
            '<soapenv:Header> <fueloauth>' + accessToken + '</fueloauth></soapenv:Header><soapenv:Body><RetrieveRequestMsg xmlns="http://exacttarget.com/wsdl/partnerAPI">' +
            '<RetrieveRequest><ObjectType>DataExtensionObject[SendLog_SearchTool]</ObjectType>' +
            '<Properties>EmailAddress</Properties>' +
            '<Properties>FirstName</Properties>' +
            '<Properties>LastName</Properties>' +
            '<Properties>CouponCode</Properties>' +
            '<Properties>SendType</Properties>' +
            '<Properties>ContactType</Properties>' +
            '<Properties>MobileNumber</Properties>' +
            '<Properties>EmailName</Properties>'+
            '<Properties>MessageName</Properties>' +
            '<Properties>SendDate</Properties>' +
            '<Properties>ProgramName</Properties>' +
            '<Properties>ProgramID</Properties>'+
            '<Properties>i2i_id__c</Properties>' +
            '<Properties>Company</Properties>' +
            '<Properties>City</Properties>' +
            '<Properties>State</Properties>' +
            '<Properties>Street</Properties>'+
            '<Properties>PostalCode</Properties>' +
            '<Properties>Phone</Properties>' +
            '<Properties>Country</Properties>' +
            '<Properties>i2i_Contact_ID__c</Properties>' +
            '<Properties>LeadNumber</Properties>' +
            filters + '</RetrieveRequest></RetrieveRequestMsg></soapenv:Body></soapenv:Envelope>';
        System.debug('SOAP ENVELOPE: ' + soapEnvelope);
        String response = makeHttpXMLPost(servicesEndpoint, soapEnvelope);
        
        //Send back test response for test coverage
        if(Test.isRunningTest()) {
            response = '<?xml version="1.0" encoding="utf-8"?><soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" ' + 
                'xmlns:wsa="http://schemas.xmlsoap.org/ws/2004/08/addressing" xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd" xmlns:wsu="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd">' +
                '<soap:Header><wsa:Action>RetrieveResponse</wsa:Action><wsa:MessageID>urn:uuid:370f4030-22e6-4706-a5a2-a7190e906678</wsa:MessageID><wsa:RelatesTo>urn:uuid:531a2812-26cf-4fa6-ade9-8b71dd74a927</wsa:RelatesTo>' +
                '<wsa:To>http://schemas.xmlsoap.org/ws/2004/08/addressing/role/anonymous</wsa:To><wsse:Security><wsu:Timestamp wsu:Id="Timestamp-e1086372-6ef8-43d4-a826-80aa60df4c3b">' +
                '<wsu:Created>2019-10-24T15:58:59Z</wsu:Created><wsu:Expires>2019-10-24T16:03:59Z</wsu:Expires></wsu:Timestamp></wsse:Security></soap:Header><soap:Body>' +
                '<RetrieveResponseMsg xmlns="http://exacttarget.com/wsdl/partnerAPI"><OverallStatus>MoreDataAvailable</OverallStatus><RequestID>67dd72b4-399e-4d33-8134-5fcad03f3761</RequestID>' +
                '<Results xsi:type="DataExtensionObject"><PartnerKey xsi:nil="true" /><ObjectID xsi:nil="true" /><Type>DataExtensionObject</Type><Properties>' +
                '<Property><Name>EmailAddress</Name><Value></Value></Property>' +
                '<Property><Name>FirstName</Name><Value /></Property>' +
                '<Property><Name>LastName</Name><Value>Last</Value></Property>' + 
                '<Property><Name>CouponCode</Name><Value>test1</Value></Property>' + 
                '<Property><Name>SendType</Name><Value>Email</Value></Property>' +
                '<Property><Name>ContactType</Name><Value>Unknown</Value></Property>' +
                '<Property><Name>MobileNumber</Name><Value /></Property>' +
                '<Property><Name>EmailName</Name><Value></Value></Property>' +
                '<Property><Name>MessageName</Name><Value /></Property>' +
                '<Property><Name>SendDate</Name><Value>9/17/2019 7:58:40 AM</Value></Property>' +
                '<Property><Name>ProgramName</Name><Value /></Property>' +
                '<Property><Name>ProgramID</Name><Value /></Property>' +
                '<Property><Name>i2i_id__c</Name><Value>1</Value></Property>' +
                '<Property><Name>Company</Name><Value>THE TEST COMPANY</Value></Property>' +
                '<Property><Name>City</Name><Value /></Property>' +
                '<Property><Name>State</Name><Value /></Property>' +
                '<Property><Name>Street</Name><Value /></Property>' + 
                '<Property><Name>PostalCode</Name><Value /></Property>' +
                '<Property><Name>Phone</Name><Value>1111111111</Value></Property>' +
                '<Property><Name>Country</Name><Value /></Property>' +
                '<Property><Name>i2i_Contact_ID__c</Name><Value /></Property>' +
                '<Property><Name>LeadNumber</Name><Value>' + leadNumber + '</Value></Property>' +
                '</Properties></Results></RetrieveResponseMsg></soap:Body></soap:Envelope>';
        }
        
        List<i2iGet.returnData> rd = i2iGetMC.xmlToMap(response);
        System.debug('rd ' + rd);
        return rd;
    }
    
    /*
	* Description: Loop through XML returned from Marketing Cloud
	*			   Get to Properties of each record returned and add it to the Map
	* Parameter: XML returned from callout to Marketing Cloud
	* Returned: List of each record with their attribute to value
	*/
    public static List<i2iGet.returnData> xmlToMap(String xml) {
        List<i2iGet.returnData> returnData = new List<i2iGet.returnData>();
        Map<String, String> mappingFields = new Map<String, String>();
        for(Search_Tool_Mapping__mdt tool : mapping) {
            mappingFields.put(tool.Marketing_Cloud_Field__c, tool.Quick_Pivot_Field__c);
        }
        
        Dom.Document doc = new Dom.Document();
        doc.load(xml);
        Dom.XmlNode root = doc.getRootElement();
        Dom.XmlNode body = root.getChildElement('Body', 'http://schemas.xmlsoap.org/soap/envelope/');
        if(body != null) {           
            Dom.XmlNode retrieveResponse = body.getChildElement('RetrieveResponseMsg', 'http://exacttarget.com/wsdl/partnerAPI');
            if(retrieveResponse != null) {
                List<Dom.XmlNode> results = retrieveResponse.getChildren();
                System.debug('results ' + results);
                //Get Records returned 
                for(Dom.XmlNode ch: results) {
                    if(ch.getName() == 'Results') {
                        Dom.XmlNode properties = ch.getChildElement('Properties', 'http://exacttarget.com/wsdl/partnerAPI');
                        if(properties != null) { 
                            List<Dom.XmlNode> property = properties.getChildren();
                            Map<String, String> mapField = new Map<String, String>(); 
                            for(Dom.XmlNode pro : property) { 
                                //If the Value is not null, add it to the Map
                                String name = pro.getChildElement('Name', 'http://exacttarget.com/wsdl/partnerAPI').getText();
                                String value = pro.getChildElement('Value', 'http://exacttarget.com/wsdl/partnerAPI').getText();
                                if(mappingFields.containsKey(name)) {
                                    mapField.put(mappingFields.get(name), value);
                                }
                            }
                            String jsonFieldMapping = JSON.serialize(mapField);
                            i2iGet.returnData data = (i2iGet.returnData) JSON.deserialize(jsonFieldMapping, i2iGet.returnData.class); 
                            returnData.add(data);
                        }
                    }
                }
            }
        }
        return returnData;
    }
}