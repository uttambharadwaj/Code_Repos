public class CreditApplicationController {
    private String BASE_URL{get;set;}
    
    //Document related variables
    public Id logoURL {get;set;}     
    public Id cardURL {get;set;}    
    
    //attachment image for the ui-contact details
    public Id attImage{get;set;}
    
    
    //A param for google to track the page
    public String errors{get{if(errors == null)errors = '';return errors;}set;}
    
    //terms and conditions code
    public String terms {get;set;}
    
    //Branding Colors
    public String brand1{get;set;}
    public String brand2{get;set;}
    
    
    //program name
    public String name{get;set;}
    
    //sidebar 
    public String sidebar{get;set;}
    
    //pricing string
    public Campaign_Pricing__c  pricingObj{get;set;}
    
    //google analytics code
    public String googleAnalyticsHeadBlock{get;set;}
    public String googleAnalyticsBodyBlock{get;set;}
    
    //live person code
    public String livePerson{get;set;}
    
    //inside sales
    public String inSales{get;set;}
    
    //confirmation page content
    public String confirmation{get; set;}
    //confirmation page oppNum
    public String oppNum{get; set;}
    //application status info
    public String statusInfo{get; set;}
    //application status
    public String appStatus{get; set;}
    //error page
    public String errorMsg {get;set;}   
    
    //Brand Determining related variables    
    private Program__c pgm {get;set;}
    private Campaign_Program__c cp {get;set;}
    public String LocationCode{get;set;}
    public List<Campaign_Pricing__c> pricing {get;set;}
    private String couponCode {get;set;}
    
    //Email header URL
    public String emailURL{get;set;}
    
    //Map the fields of the pricing object so we can iterate through them dynamically
    public Map<String, String> fieldList{get; set;}  
    
    
    //For the email component
    public Program__c prog{get; set;}
    
    public String BrandLongName  {get;set;}
    
    //branded title and tagline
    public String PanelTitle{get;set;}
    public String BrandTitle {get;set;}
    public String BrandTagline{get;set;}
    
    public WeFormObject__c creditApp 
    {get{
        if(creditApp == null)
            creditApp = new WeFormObject__c();
        return creditApp;
    }
     set;
    }
    //Terms And Conditions
    public String termAndCond {
        get{
            StaticResource sr = [
                select Body
                from StaticResource
                where Name = 'BOCA_TC'
            ];
            return sr.Body.toString();
        }
    }
    //Disclosure
    //Terms And Conditions
    public String disclosure {
        get{
            StaticResource sr = [
                select Body
                from StaticResource
                where Name = 'Disclosure'
            ];
            return sr.Body.toString();
        }
    }
    
    //This initBrandCheck() method is used to redirect the form to the error page if there
    //is insufficient information to put together a branded BOCA (pgm/campaign_program)
    public PageReference initBrandCheck(){
        system.debug('inside initBrandCheck');
        
        //check to see if this is a preview
        String isPreview = ApexPages.CurrentPage().getParameters().get('preview');  
        SYSTEM.debug('preview is: '+ isPreview);
        
        //Get the Name of the page 
        String strurl = ApexPages.currentPage().getUrl();
        strurl = strurl.replaceFirst('/apex/',''); 
        strurl = EncodingUtil.urlEncode(strurl, 'UTF-8');  
        string[] strurlExtra = strurl.split('%3F',0);   
        strurl = strurlExtra[0]; 
        SYSTEM.debug('conf= '+strurl);
        pagereference redirect = null;
        String errorCode = '';
        
        if(isPreview != 'true' && strurl != 'CreditApplicationConfirmation' && strurl != 'CreditApplicationStatus' ){
            //If the program is null - meaning we dont have a program branded for what was in the url/urlparam, then error out.
            if (pgm == null){
                errorCode = WEXErrorUtility.INVALID_PROGRAM;
                redirect = new PageReference('/apex/NoProgramBOCAerror?errorCode=' + errorCode);          
                redirect.setRedirect(true);
                return redirect;
            }
            
            WEXBrandUtility util = new WEXBrandUtility();
            if (pgm.Publish_BOCA__c == false){
                errorCode = WEXErrorUtility.UNPUBLISHED;
                redirect = new PageReference('/apex/CreditApplicationError?errorCode=' + errorCode);       
                redirect.getParameters().put('pgm', pgm.Brand_Short_Name__c);
                redirect.setRedirect(true);
                return redirect;
            }           
            
            if (!util.isValidTemplateForProgram(ApexPages.CurrentPage().getUrl(), pgm)){
                errorCode = WEXErrorUtility.INVALID_TEMPLATE;
                redirect = new PageReference('/apex/CreditApplicationError?errorCode=' + errorCode);            
                redirect.setRedirect(true);
                return redirect;
            }
        }
        //If the page is the confirmation page, get the oppnum param
        if(strurl == 'CreditApplicationConfirmation'){
            //get the oppNum
            oppNum = ApexPages.CurrentPage().getParameters().get('oppNum');  
            SYSTEM.debug('oppNum on Confirmation' + oppNum);
            return null;
        }
        //if we come in on a check status with no pgm
        if(strurl ==  'CreditApplicationStatus' ){
            String prog = ApexPages.CurrentPage().getParameters().get('pgm'); 
            if(prog == NULL){	
                errorCode = WEXErrorUtility.INVALID_PROGRAM;
                redirect = new PageReference('/apex/NoProgramBOCAerror?errorCode=' + errorCode);          
                redirect.setRedirect(true);
                return redirect;
            }
        }
        
        return redirect;
    } 
    
    public PageReference CreditApplicationError(){
        String errorCode = ApexPages.CurrentPage().getParameters().get('errorCode');    
        
        if (errorCode != null){
            errorMsg = WEXErrorUtility.getErrorMessage(errorCode);
        }
        if(pgm != null){
            //for the branded error pages
            setupBranding();
            
        }
        
        
        return null;
    }
    
    public void setupBranding(){
        
        WEXBrandUtility util = new WEXBrandUtility();
        
        //**************************************************************
        //Initial Setup of program and campaign program  ***************
        
        //Variables used to determine brand
        String couponCodeUrlParam = ApexPages.CurrentPage().getParameters().get('cc');
        String brandUrlParam = ApexPages.CurrentPage().getParameters().get('pgm');  
        //the WE_ID is for the app status page when returning via the email link
        String weId = ApexPages.currentPage().getParameters().get('weId');
        String locCode = ApexPages.currentPage().getParameters().get('lc');
        String url = ApexPages.CurrentPage().getUrl();
        
        if(locCode != null){ LocationCode = locCode; }
        
        if(weId != null){
            //get the opp off of the weform
            WeFormObject__c stat = [SELECT  Opportunity__c, Id FROM WeFormObject__c WHERE Id =: weId];
            //query the opp for the app request
            Opportunity weOpp = [SELECT ID, Application_Request__c, Application_Status__c FROM Opportunity WHERE ID =: stat.Opportunity__c];
            //query the app request for the status
            Application_Request__c wef = [SELECT Application_Status__c, ID, Opportunity__c FROM Application_Request__c WHERE Opportunity__c =: weOpp.Id];
            //give that status back to the page
            appStatus = wef.Application_Status__c;
            
            SYSTEM.debug('status '+appStatus);
        }
        //Need to get the program
        pgm = util.setProgramFromURL(brandUrlParam, url);
        //Then need to get the campaign program for the t&c's
        if (pgm != null){
            //Now get the campaign based on the coupon code
            List<Campaign> campaigns = [select id from campaign where coupon_code__c = :couponCodeUrlParam];
            if (campaigns.size() == 0){                
                //Need to get the default campaign program for the program
                cp = util.getDefaultCampaignProgram(pgm);
            }else{
                cp = util.getCampaignProgram(pgm, campaigns[0]);
            }
            
        }
        if (pgm != null && cp != null){
            
            //**************************************************************
            //**************************************************************
            
            BrandLongName = pgm.Brand_Long_Name__c;
            //branded title and tagline
            BrandTitle = pgm.Brand_Heading__c;
            BrandTagline = pgm.Brand_Tagline__c;
            PanelTitle = pgm.Side_Panel_Title__c;
            //sidebar html
            sidebar = pgm.SideBar__c;
            //google
            googleAnalyticsBodyBlock = pgm.Analytics_Body_Block__c;
            googleAnalyticsHeadBlock = pgm.Analytics_Head_Block__c;
            
            //confirmation page 
            confirmation = pgm.Confirmation_Info__c;
            
            //livePerson code
            livePerson = pgm.Live_Person_Code__c;
            
            //inside sales
            inSales = ' '+ pgm.Inside_Sales_Phone_Number__c;
            
            //Email header
            emailURL = pgm.Custom_Email_Header_URL__c;
            
            //header name
            name = pgm.Name;
            
            //branded colors
            brand1 = pgm.Brand_Color_1__c;
            brand2 = pgm.Brand_Color_2__c;
            
            //retrieve attachment images
            Attachment card = [SELECT Id, Name, Body FROM Attachment where ParentId = : pgm.Id AND Name=:'ui-credit-card.png'];
            cardURL = card.id;
            
            Attachment logo = [SELECT Id, Name, Body FROM Attachment where ParentId = : pgm.Id AND Name=:'ui-logo.png'];
            logoURL = logo.id;
            
            //this sets the coupon code (for the pricing) to the appropriate one set on the program
            
            //coupon code
            couponCode = util.getCouponCode(cp);   
            creditApp.Promotional_Code__c = couponCode;
            
            //terms and conditions text
            terms= cp.Terms_and_Conditions__c;
            
            //set the campaign program
            creditApp.Campaign_Program_ID__c = cp.Id;
            creditApp.TM_Session_ID__c = UserInfo.getSessionId();
            //get the pricing information if the program's setup says it should be so..
            if (pgm.Upload_Pricing_Data_Flag__c == true){
                pricing = util.getPricing(pgm.Peoplesoft_rel_code__c,couponCode);
                
                WEXPricingHelper wexP = new WEXPricingHelper();
                //check to see if the pricing contains two rows of data
                //send the campaign pricing to the helper class and get the format map
                if(pricing.size() == 2){
                    SYSTEM.debug('pricing: '+pricing);
                    //if there are two rows only return the format map for the risk based pricing
                    Campaign_Pricing__c p1 = pricing.get(0);
                    Campaign_Pricing__c p2 = pricing.get(1);
                    SYSTEM.debug('pric 1: ' + p1.risk_code__c + 'pric 2: ' + p2.risk_code__c);
                    if(p1.risk_Code__c == '7'){
                        
                        fieldList = wexP.getPricing(pricing.get(0));
                        SYSTEM.debug('list: ' + fieldList );
                    }
                    if(p2.risk_code__c == '7'){
                        fieldList = wexP.getPricing(pricing.get(1));
                        SYSTEM.debug('list: ' + fieldList );
                    }
                }
                if(pricing.size() == 1){
                    fieldList = wexP.getPricing(pricing.get(0));
                }
                else if(pricing.size() == 0){ fieldList = null;}
                
                
            }
            
        }
        
    }
    public CreditApplicationController(){
        SYSTEM.debug('inside the controller');
        // SYSTEM.debug('fieldList'+ fieldMap);
        //**************************************************************
        //Initial Setup of program and campaign program  ***************
        setupBranding();
        
        
    }   
    //Turn the below on to deploy to Prod and comment out the dev method below
 
public void SendEmail(){
SYSTEM.debug('inside emailer');
List<RecordType> ctRecordTypes = [select Id from RecordType where sObjectType = 'Contact' and DeveloperName IN ('F1_Contact')];
Messaging.reserveSingleEmailCapacity(1);
Messaging.SingleEmailMessage confirm = new Messaging.SingleEmailMessage();
Contact c = new Contact();
c.FirstName = creditApp.First_Name__c;
c.LastName = creditApp.Last_Name__c;
c.Email = creditApp.Email__c;
c.RecordTypeId = ctRecordTypes[0].Id;
insert c;
confirm.setTemplateId('00X70000001EfPG');
confirm.setWhatId(creditApp.Id);
confirm.setTargetObjectId(c.id);
confirm.setSaveAsActivity(false);
confirm.setReplyTo('noreply@wexinc.com');
for(OrgWideEmailAddress owa : [select id, Address, DisplayName from OrgWideEmailAddress]) 
{
if(owa.Address.contains('noreply@wexinc.com')) 
confirm.setOrgWideEmailAddressId(owa.id); 
}
SYSTEM.debug('email header'+ emailURL);
Messaging.sendEmail(new Messaging.SingleEmailMessage[] {confirm});
//clean up
delete c;

} 

   /*    
    public void SendEmail(){
        SYSTEM.debug('inside emailer');
        List<RecordType> ctRecordTypes = [select Id from RecordType where sObjectType = 'Contact' and DeveloperName IN ('F1_Contact')];
        Messaging.reserveSingleEmailCapacity(1);
        Messaging.SingleEmailMessage confirm = new Messaging.SingleEmailMessage();
        Contact c = new Contact();
        c.FirstName = creditApp.First_Name__c;
        c.LastName = creditApp.Last_Name__c;
        c.Email = creditApp.Email__c;
        c.RecordTypeId = ctRecordTypes[0].Id;
        insert c;
        confirm.setTemplateId('00Xn0000000DdDf');
        confirm.setWhatId(creditApp.Id);
        confirm.setTargetObjectId(c.id);
        confirm.setSaveAsActivity(false);
        confirm.setReplyTo('noreply@wexinc.com.sit');
        for(OrgWideEmailAddress owa : [select id, Address, DisplayName from OrgWideEmailAddress]) 
        {
            if(owa.Address.contains('noreply@wexinc.com.sit')) 
                confirm.setOrgWideEmailAddressId(owa.id); 
        }
        SYSTEM.debug('email header'+ emailURL);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] {confirm});
        //clean up
        delete c;
        
    }
    
*/    
    public Program__c getProg(String pId){
        //query the form for the emailer
        
        prog = [select id,  Custom_Email_Header_URL__c FROM Program__c WHERE id =:pId];
        return prog;
        
    }
    
    public PageReference SubmitCreditApplication(){
        
        system.debug('WITHIN THE SUBMIT.');
        PageReference page = null;
        
        //validate the fields and submit if !errors
        if(!CreditAppValidator.validateFields(CreditApp)){
            //get the 'Revolver' record type
            recordType type = [SELECT Name, Id FROM recordType WHERE sobjecttype = 'weFormObject__c' and name ='Revolver'];
            //set the recordtype to 'Revolver' 
            creditApp.RecordType = type;
            //check for the location code
            if(LocationCode != null){creditApp.Location_Code__c = LocationCode;}
            creditApp.IPAddress__c =  ApexPages.currentPage().getHeaders().get('X-Salesforce-SIP');
            creditApp.Program_Id__c = pgm.Id;
            
            //this one is a lookup for the email
            creditApp.Program__c = pgm.Id;
            creditApp.isPG__c = true;
            Database.SaveResult result = Database.insert(creditApp, false);
            if(result.isSuccess()){
                
                
                Id weId = result.getId();
                SYSTEM.debug('weForm'+ weId);
                WeFormObject__c we = [SELECT ID, Application_Number__c FROM WeFormObject__c WHERE ID =: weId];
                
                oppNum = we.Application_Number__c;
                SYSTEM.debug('opp'+ oppNum);
                sendEmail();
                
                page = new PageReference('/apex/CreditApplicationConfirmation?pgm='+pgm.Brand_Short_Name__c);
                page.getParameters().put('oppNum',oppNum);
                page.setRedirect(true);
                
                return page;
            }
            else{
                SYSTEM.debug('insert errors' + result.getErrors());
                
            }
            
        } 
        errors = 'formErrors';
        PageReference currPage = apexPages.currentPage();
        
        currPage.setRedirect(false);
        
        return currPage;
        
    }
    
    
}