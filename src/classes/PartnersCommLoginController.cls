/**
 * An apex page controller that exposes the site login functionality
 */
global class PartnersCommLoginController extends APartnersComm 
{		
	private final string formSubmitPage;		
	
	global String ServerName 					{get; private set;}
	global String CommunityName 				{get; private set;}
	global String EndPoint 						{get; private set;}	
	global String StartURL 						{get; private set;}	
	global String StartUrlParam			 		{get; private set;}
	global String ComponentWidth 				{get; private set;}	
	global String ForgotPasswordURL 			{get; private set;}	   
    global String Username  			 		{get; set;}
    global String Password  			 		{get; set;}
    
    global Boolean HasLoginError 				{get; private set;}
    global String LoginErrorMessage				{get; private set;}
    global Boolean MissingUsername 				{get; private set;}
    global Boolean MissingPassword 				{get; private set;}
    
    global PartnersCommLoginController() 
    {    	
    	this.formSubmitPage = '/login';
    	
    	String tempStartUrlParam = ApexPages.currentPage().getParameters().get('startURL');
    	
    	if(tempStartUrlParam != null && tempStartUrlParam.trim().length() > 0)
    	{ 
    		this.StartUrlParam = tempStartUrlParam;
    	}
    	
		loadSettings();
    }
    
    private void loadSettings()
    {
    	String prefix = Deployment_PartnersCommunity.SiteCategoryName;
    	
    	try
    	{
    		this.ServerName = Setting__c.getInstance(prefix + ' Server Name').Value__c;
    		this.CommunityName = Setting__c.getInstance(prefix + ' Community Name').Value__c;    		
    		this.StartURL = Setting__c.getInstance(prefix + ' Start URL').Value__c;    		
    		this.ComponentWidth = Setting__c.getInstance(prefix + ' Component Width').Value__c;    		    		
    		this.ForgotPasswordURL = Setting__c.getInstance(prefix + ' Forgot Password URL').Value__c;     		   		    	
    	}
    	catch(Exception e)
    	{
    		System.debug('EXCEPTION: ' + e);
    	}
    }  

    //This ensures we have a protocol and the trailing slash at the end of the hostname
    private String getCleanedHostname(String hostname)
    {
    	if(hostname == null || hostname.trim().length() == 0)
    	{
    		return null;
    	}
    	
    	if(hostname.trim().endsWith('/') == false)
    	{
    		hostname = hostname + '/';
    	}
    	
    	return hostname;
    }   

    public PageReference login()
    {    	    	
    	UGears.UDebug.printDebug('1');
    	
    	this.LoginErrorMessage = '';
    	this.HasLoginError = false;
    	this.MissingUsername = false;
    	this.MissingPassword = false;
    	
    	if(username == null || 
    	   username.trim().length() == 0 || 
    	   password == null || 
    	   password.trim().length() == 0)
    	{
    		String missingUsernameMessage = '';
    		String missingPasswordMessage = '';
    		
    		if(username == null || username.trim().length() == 0)
    		{
    			this.MissingUsername = true;
    			
    			missingUsernameMessage = 'A username is required';
    		}

    		if(password == null || password.trim().length() == 0)
    		{
    			this.MissingPassword = true;
    			
    			missingPasswordMessage= 'A password is required';
    		}
    		
    		if(MissingUsername && MissingPassword)
    		{
    			LoginErrorMessage = missingUsernameMessage + '<br />' + missingPasswordMessage;
    		}
    		else if(MissingUsername)
    		{
    			LoginErrorMessage = missingUsernameMessage;
    		}
    		else if(MissingPassword)
    		{
    			LoginErrorMessage = missingPasswordMessage;
    		}
    		
    		UGears.UMessage.addErrorPageMessage(LoginErrorMessage);
    		
    		return null;
    		//return new PageReference('/' + CommunityName + '/PartnersCommLogin');
    	}
    	
        Map<String, String> formValuesMap = new Map<String, String>();

		String firstURL = '';

		if(StartURLParam != null && StartURLParam.trim().length() > 0)
		{
			firstURL = StartURLParam;
		} 		
		else if(StartURL != null && StartURL.trim().length() > 0)
		{
			firstURL = StartURL;
		}
		
		UGears.UDebug.printDebug('2');
		
        //These all came out of the source for the portal login pages
        formValuesMap.put('startURL', firstURL);
        formValuesMap.put('loginURL', '');
        formValuesMap.put('useSecure', 'true');
        formValuesMap.put('un', username);
        formValuesMap.put('pw', password);               
        formValuesMap.put('width', '');
		formValuesMap.put('height', '');
		formValuesMap.put('hasRememberUn', 'false');
        formValuesMap.put('loginType',''); 
        formValuesMap.put('local', '');
    	formValuesMap.put('lt','standard'); 
        formValuesMap.put('qs', '');
        formValuesMap.put('locale', '');
		formValuesMap.put('oauth_token', '');
		formValuesMap.put('oauth_callback', '');
		formValuesMap.put('login', '');
		formValuesMap.put('serverId', '');
		formValuesMap.put('display', 'page');				
		formValuesMap.put('rememberUn', '0');        
    	
    	Boolean firstValue = true;
    	String formValuesString = '';
    	
    	UGears.UDebug.printDebug('3');
    	
    	for(String key : formValuesMap.keySet())
    	{
    		if(firstValue == true)
    		{
    			formValuesString += key + '=' + formValuesMap.get(key);
    			
    			firstValue = false;
    		}
    		else
    		{
    			formValuesString += '&' + key + '=' + formValuesMap.get(key);
    		} 
    	}
    	
    	UGears.UDebug.printDebug('FORM VALUES STRING = ' + formValuesString);
    	  	
    	String encodedValues = EncodingUtil.urlEncode(formValuesString, 'UTF-8');
    	
    	UGears.UDebug.printDebug('ENCODED VALUES = ' + encodedValues);
    	
    	this.EndPoint = ServerName + '/' + CommunityName + formSubmitPage;
    	
    	UGears.UDebug.printDebug('ENDPOINT: ' + EndPoint);
    	
    	HttpRequest request = new HttpRequest();
    	
    	request.setHeader('Content-Length', String.valueOf(encodedValues.length()));
    	request.setHeader('Content-Type', 'application/x-www-form-urlencoded');

        request.setEndpoint(EndPoint);
        request.setMethod('POST');        
        request.setBody(formValuesString);
    	
    	return getPage(request);
    }

    private PageReference getPage(HttpRequest request)
    {
    	Http http = new Http();
        
        HTTPResponse response = http.send(request);
        
        Set<String> invalidLoginResponses = new Set<String>();
        
        invalidLoginResponses.add('Your login attempt has failed');
        invalidLoginResponses.add('Please enter your Password');
     
        debugResponse(response);        
        
        if(response.getStatusCode() == 200)
        {      
        	Boolean redirectToLoginPage = false;
        	
        	for(String invalidLoginResponse : invalidLoginResponses)
        	{
	        	if(response.getBody().contains(invalidLoginResponse))
	        	{
	        		UGears.UDebug.printDebug('INVALID RESPONSE MATCH = ' + invalidLoginResponse);
	        		
	        		redirectToLoginPage = true;
	        	}
        	}
        	
        	if(redirectToLoginPage == true)
        	{        		
	        	UGears.UMessage.addErrorPageMessage('Login attempt failed.<br />Please check your username and password.');

        		return null;
        		//return new PageReference('/' + CommunityName + '/PartnersCommLogin');
        	}
        	else
        	{
	        	if(StartURL != null && StartURL.trim().length() > 0)
	        	{
	        		return new PageReference(StartURL);
	        	}
	        	else
	        	{
	            	return new PageReference(ServerName + 'home/home.jsp');
	        	}
        	}
        }
        else if(response.getStatusCode() == 302)
        {                
            return new PageReference(response.getHeader('Location'));
        }
        else
        {
            return new PageReference('/' + CommunityName + '/PartnersCommLogin');
        }
    }
    
    private void debugResponse(HttpResponse response)
    {
    	if(response != null)
    	{
	    	UGears.UDebug.printDebug('BODY = ' + response.getBody());    	
	    	UGears.UDebug.printDebug('STATUS = ' + response.getStatus());
	    	UGears.UDebug.printDebug('STATUS CODE = ' + response.getStatusCode());
    	
	    	for(String key : response.getHeaderKeys())
	    	{    		    	
	    		if(key != null && key.trim().length() > 0)
	    		{
		    		String header = response.getHeader(key);
	    		
		    		UGears.UDebug.printDebug(key + ' = ' + header);
	    		}
	    	}
    	}
    } 

    public class CustomException extends Exception {}
}