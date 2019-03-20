public class i2iGet {

	/* Tests
	
	
	system.debug('-----Lookup by promo code:');
	i2iGet.executeCall ('1001221',null,null,null,null);
	system.debug('-----Lookup by program and phone:');
	i2iGet.executeCall (null,'XYZ','5085880322',null,null);

	system.debug('-----Lookup by program and business (leave Zip query string blank):');
	i2iGet.executeCall (null,'XYZ',null,'US Cutting Chain Mfg Co  Inc',' ');
	system.debug('-----Lookup by program and business and zip:');
	i2iGet.executeCall (null,'XYZ',null,'US Cutting Chain Mfg Co  Inc','02302');
	system.debug('-----Lookup returns no results:');
	i2iGet.executeCall (null,'XYZ',null,'US Cutting Chain Mfg Co  Inc','11112');
	system.debug('-----Business name wild card search returns too many results:');
	i2iGet.executeCall (null,'XYZ',null,'US*','');

	system.debug('-----multiple test:');
	i2iGet.executeCall (null,'XYZ','2077745816',null,null);
	
	*/


	public class returnData
	{
		public string returnDescription {get;set;}
		public double isiId {get;set;}
		public string firstName {get;set;}
		public string lastName {get;set;}
		public string company {get;set;}
		public string address {get;set;}
		public string city {get;set;}
		public string state {get;set;}
		public string zip {get;set;}
		public string email {get;set;}
		public string title {get;set;}
		public string leadSource {get;set;}
		public string sicCode {get;set;}
		public string SFDCContactId {get;set;}
		public string SFDCParentLeadId {get;set;}
		//public string SFDCChildLeadId {get;set;}
		//added new field -phillip
		public string i2iId {get;set;}

		public string CouponCode{get;set;}
		public string MailDate{get;set;}
		public string Offer{get;set;}

		public string phone{get;set;}
		public string country{get;set;}
		public string i2icontactid{get;set;}
	}
	
	public static boolean inProduction ()
	{
		GlobalSettings__c gs = GlobalSettings__c.getOrgDefaults();
		
		if(gs.productionInstance__c == System.URL.getSalesforceBaseUrl().toExternalForm())
		{
			return true;
		}
		
		return false;
	}
	
	public static List <returnData> executeCall (string promoCode, string program, string phone, string businessName, string postalCode, string email)
	{
		HttpRequest req = new HttpRequest();
		
		string finalEndPoint = 'https://secure.smart-login.net/api/i2iLookup?';
     	      
     	string parameters = '';     
     	
     	parameters += '&PromoCode='; 
     	if(promoCode != null && promoCode != '')
     	{
     		//parameters += '&PromoCode=' + EncodingUtil.urlEncode(promoCode, 'UTF-8');  
     		parameters += EncodingUtil.urlEncode(promoCode, 'UTF-8');
     	}
     	parameters += '&Program=';
     	if(program != null && program != '')
     	{
     		//parameters += '&Program=' + EncodingUtil.urlEncode(program, 'UTF-8');  
     		parameters +=EncodingUtil.urlEncode(program, 'UTF-8');
     	}
     	parameters += '&Phone=';
     	if(phone != null && phone != '')
     	{
     		//parameters += '&Phone=' + EncodingUtil.urlEncode(phone, 'UTF-8');  
     		parameters += EncodingUtil.urlEncode(phone, 'UTF-8');
     	}
     	parameters += '&BusinessName=';
     	if(businessName != null && businessName != '')
     	{
     		//parameters += '&BusinessName=' + EncodingUtil.urlEncode(businessName, 'UTF-8'); 
     		parameters += EncodingUtil.urlEncode(businessName, 'UTF-8'); 
     	}
     	parameters += '&Zip=';
     	if(postalCode != null && postalCode != '')
     	{
     		//parameters += '&Zip=' + EncodingUtil.urlEncode(postalCode, 'UTF-8');
     		parameters += EncodingUtil.urlEncode(postalCode, 'UTF-8');   
     	}
     	parameters += '&Email=';
     	if(email != null && email != '')
     	{
     		parameters += EncodingUtil.urlEncode(email, 'UTF-8');   
     	}
     	      	
     	parameters = parameters.substring(1);
     	finalEndPoint += parameters;  	  
    	
     	system.debug('-----' + finalEndPoint);
     	      			
     	req.setEndpoint(finalEndPoint);
   		req.setMethod('GET');
 
 		DateTime startTime = system.now();
 
     	Http http = new Http();
     	HTTPResponse res = http.send(req);
     	
     	DateTime endTime = system.now();
     	
     	system.debug('-----Milliseconds To Execute: '+ getDifferenceInMilliSeconds(starttime, endtime));
     	
     	System.debug('>>>>>' + res.getBody() + '<<<<<<');  
     	
     	List <returnData> rData = (List <returnData>)JSON.deserialize(res.getBody(), List <returnData>.class);
		
		system.debug('-----records returned: ' + rData.size());
		
     	return rData;
		
	}
	
	public static double getDifferenceInMilliSeconds(datetime firstDT, datetime secondDT)
	{  
   		long dt1 = firstDT.getTime();   
   		long dt2 = secondDT.getTime();
   		double d = dt2 - dt1;
   		return d;
	}

}