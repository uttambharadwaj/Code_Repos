@isTest
public class BOCAtestDataUtility {

//for stagefull
   
   public static Campaign_Program__c testcp{get{
        if(testcp == null)
            testcp = getcp();
        
        return testcp;
    }
     set;
    }
    public static campaign_Pricing__c pric{get{
        if(pric == null)
            pric = getpricing();
        
        return pric;
    }
     set;
    }
    public static  Campaign testCamp{get{
        if(testCamp == null)
            testCamp = getCampaign();
        
        return testCamp;
    }
     set;
    }
   public static  Program__c testProg2{get{
        if(testProg2  == null)
            testProg2  = getProgram();
        
        return testProg2 ;
    }
     set;
    }

    //stagefull
    /*
   public static BOCA_IDS__C getBOCAids(){
        
        BOCA_IDS__c bi = new BOCA_IDS__c();
        bi.Name = 'BOCA IDS';
        bi.BOCA_Sell_Sheet__c = '00XM0000000IjRY';
        bi.Email_Address__c = 'salesforce@wrightexpress.com.stagefull';
        bi.Email_Address_Noreply__c = 'noreply@wexinc.com.stagefull';
        bi.Instance_Prefix__c = 'https:www.cs7.stagefull.salesforce.com';
        
        return bi;
        
        
        
    }

//Prod
*/
       public static BOCA_IDS__C getBOCAids(){
        
        BOCA_IDS__c bi = new BOCA_IDS__c();
        bi.Name = 'BOCA IDS';
        bi.BOCA_Sell_Sheet__c = '00X70000001zGLp';
        bi.Email_Address__c = 'salesforce@wrightexpress.com';
        bi.Email_Address_Noreply__c = 'noreply@wexinc.com';
        bi.Instance_Prefix__c = 'https://onlineservices.secure.force.com/';
        
        return bi;
        
        
        
    }
    
    public static Campaign getCampaign(){
        
        testCamp = new Campaign();
        
        testCamp.Coupon_Code__c = 'A001';
        testCamp.Name = 'testBOCA123';
        testCamp.Type = 'Online Form';
        testCamp.Status = 'In Progress';
        testCamp.Drop_Date__c = date.today();
        testCamp.EndDate = date.today();
        testCamp.CurrencyIsoCode = 'USD';
        testCamp.IsActive = true;
        
        upsert testCamp;
        
        return testCamp;
        
        
    }
    
    public static Campaign_Pricing__c getPricing(){

        pric = new Campaign_Pricing__c();
        
        pric.Name = 'test';
        pric.contract_margin__c = 'Y';
        pric.penalty_margin__c = 'Y';
        pric.days_to_pay__c = 21;
        pric.prime_rate__c = 3.25;
        pric.prime_rate_effective_date__c = date.today();
        pric.late_fee_type__c = 'P';
        pric.return_payment_fee__c = 49.99;
        pric.over_limit_fee__c = 39.99;
        pric.paper_delivery_fee__c = 5.00;
        pric.penalty_rate_ceiling__c = 999.99;
        pric.minimum_payment_percentage__c = 29.99;
        pric.Peoplesoft_rel_code__c = '012011';
        pric.coup_code__c = 'A001';
        pric.is_Active__c = true;
        pric.Coupon_Status__c = 'valid';
        pric.risk_code__c = 'No';
        pric.nbr_billing_cyles__c = '1';
        pric.contract_rate_pct__c = 10.15;
        pric.fixed_late_fee__c = 0.00;
        pric.pct_late_fee__c = 2.49;
        pric.pen_rate_pct__c = 27.34;
        pric.promo_periods__c = 1.0;
        pric.promotional_rate__c = 8.17;
        pric.CurrencyIsoCode = 'USD';
        
        upsert pric;
        return pric;
    }
    
    public static Program__c getProgram(){

        testProg2 = new Program__c();
        
        testProg2.Name = 'testFlex2' ; 
        System.debug('program name ' + testProg2.Name);
        
        testProg2.Form_Template__c = 'WexBOCA';
        testProg2.Brand_Short_Name__c = 'flex2';
        testProg2.Preferred_Language_Indicator__c = 'ENU';
        testProg2.Peoplesoft_rel_code__c = '0001207';
        testProg2.Custom_Email_Header_URL__c = 'http://www.wexhosted.com/email/revolver/header_wexRevolver.jpg';
        testProg2.Brand_Heading__c = 'Time is money. Use WEX and save both.';
        testProg2.Brand_Long_Name__c = 'flex test card';
        testProg2.Section_Titles__c = 'Tell Us About Your Business; Billing Contact Information; Promotional Information; Statement & Report Delivery; Tell Us About Yourself; Authorization; Terms & Conditions';	
        testProg2.Upload_Pricing_Data_Flag__c = false;
        testProg2.Auto_Send_BOCA_to_Siebel__c = true;
        testProg2.T_C__c = 'WEX_BOCA_TNC';
        testProg2.Analytics_Body_Block__c = '';
        testProg2.Analytics_Head_Block__c = '';
        testProg2.Brand_Color_1__c = '#ccc';
        testProg2.Brand_Color_2__c = '#fff';
        
        
        upsert testProg2;
     
        //attachments
        Attachment attach3 = new Attachment();
        attach3.Name = 'ui-credit-card.png';
        Blob bodyBlob3=Blob.valueOf('Unit Test Attachment Body');
        attach3.body=bodyBlob3;
        attach3.parentId=testProg2.id;
        upsert attach3;
        
        Attachment attach4 = new Attachment();
        attach4.Name = 'ui-logo.png';
        Blob bodyBlob4=Blob.valueOf('Unit Test Attachment Body');
        attach4.body=bodyBlob4;
        attach4.parentId=testProg2.id;
        upsert attach4;
        
        SYSTEM.debug('Here is program ' + testProg2.id);
        Boca_Res__c bocaRes = new Boca_Res__c();
        bocaRes.Email_Template_ID__c = '00X70000001EfPG';
        bocaRes.Brand_Heading__c = 'Test Heading';
        bocaRes.Brand_Tagline__c = 'Test Tagline';
        bocaRes.ISO_code__c = 'en_us';
        bocaRes.Program__c = testProg2.id;
        bocaRes.Side_Panel_Title__c = 'Test Sidebar Title';
        bocaRes.SideBar__c = 'Test Sidebar';
        bocaRes.Program_Name__c = testProg2.Name;
        bocaRes.Name = 'test';
        bocaRes.Program_Sell_Sheets__c = 'www.sellsheet.com';
        
        upsert bocaRes;
        SYSTEM.debug('Here is bocaRes ' + bocaRes.id);
      
        Boca_Res__c bocaRes2 = new Boca_Res__c();
        bocaRes2.Email_Template_ID__c = '00X70000001EfPG';
        bocaRes2.Brand_Heading__c = 'Test Heading';
        bocaRes2.Brand_Tagline__c = 'Test Tagline';
        bocaRes2.ISO_code__c = 'fr';
        bocaRes2.Program__c = testProg2.id;
        bocaRes2.Side_Panel_Title__c = 'Test Sidebar Title';
        bocaRes2.SideBar__c = 'Test Sidebar';
        bocaRes2.Program_Name__c = testProg2.Name;
        bocaRes2.Name = 'test2';
        
        upsert bocaRes2;
		Campaign_Program__c cp = new Campaign_Program__c();

        cp = getCP();
        
        
        testProg2.Publish_BOCA__c = true;
        upsert testProg2;
        
        return testProg2;
    }
        
        
        public static Campaign_Program__c getCP(){

            
        testCP = new Campaign_Program__c();
        //create campaign program test data
        testCP.Name = 'Flex Test';
        testCP.Campaign__c = testCamp.Id;
        testCP.Program__c = testProg2.Id;
        testCP.Terms_and_Conditions__c = 'Test T&C';
        testCP.Default__c = true;
        
        upsert testCP;

        testCamp.Coupon_Code__c = pric.coup_code__c;
        upsert testCamp;
        

       return testCP;
        
        
    }

}