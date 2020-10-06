public class ReCaptchaController {

    private Ctrl_MotorpassForm objController;
    
    public Ctrl_MotorpassForm getobjController(){
        return objController;
    }
    
    public void setobjController(Ctrl_MotorpassForm tempController) {  
        this.objController =  tempController;       
        this.objController.setobjRecaptchaController(this);
    }

    // Production Key
    private static string secret = '6LelCeUSAAAAAJ7tk6F0IseR7TjYUwHhNALIfIx0';
    
    
    // Production Key
    public string publicKey { get { return '6LelCeUSAAAAAN-pLi6m36kYlLmwF9BgMAumnQEZ' ; }}
    
    
    
    private static string baseUrl = 'http://api-verify.recaptcha.net/verify';

    public string challenge{get;set;}
 
    public string response {get; set; }  

    public Boolean correctResponse { get; private set; } { correctResponse = false; } 
    
    public Boolean verify() {
        system.debug( 'verify called ----->');
        // first time thru, this parameter is null, so no request to make yet
        if ( challenge == null || response == null ) { 
            system.debug( 'verify called null ');
            return correctResponse; 
        }
        System.debug('------Making Request------>');
        system.debug(challenge);        
        HttpResponse r = makeRequest(  baseUrl ,
            'privatekey='+ secret + 
            '&remoteip=' + remoteHost + 
            '&challenge=' + challenge +
            '&response=' + response +
            '&error=incorrect-captcha-sol'
        );
        
        if ( r != null ) {  // is null when test methods run
            correctResponse = ( r.getBody().contains('true') );
        }
         
        return correctResponse;  
    }

    public PageReference reset() {
        challenge = NULL;
        response = NULL;
         
        return NULL; 
    }   

    public static HttpResponse makeRequest(string url, string body)  {
        HttpRequest req = new HttpRequest();   
        HttpResponse response = null;
        req.setEndpoint( url );
        req.setMethod('POST');
        req.setBody ( body);
        try {
            if(!Test.isRunningTest())
            {
                Http http = new Http();
                response = http.send(req);
                System.debug('response: '+ response);
                System.debug('body: '+ response.getBody());
            }
           
        } catch( System.Exception e) {
            System.debug('ERROR: '+ e);
        }
        return response;
    }   
        
    public string remoteHost { 
        get { string ret = '127.0.0.1';
            // also could use x-original-remote-host 
            map<string , string> hdrs = ApexPages.currentPage().getHeaders();
            if ( hdrs.get('x-original-remote-addr') != NULL)
                ret =  hdrs.get('x-original-remote-addr');
            else if ( hdrs.get('X-Salesforce-SIP') != NULL)
                ret =  hdrs.get('X-Salesforce-SIP');
            return ret;
        }
    }
        
    public static testmethod void test_1() {
        System.debug('---conming in to test_1---');
        ReCaptchaController re = new ReCaptchaController();
        string href = baseUrl ;
        re.challenge = re.response = 'foo';
        string publick = re.publicKey; 
        string host = re.remoteHost; 
        re.verify();
    }
    
    public static  testmethod void test_2() {
        System.debug('---conming in to test_2---');     
        ReCaptchaController re = new ReCaptchaController();
        Ctrl_MotorpassForm objController;
        Ctrl_MotorpassForm tempObj;
        re.verify();
        re.reset();
    }
    
}