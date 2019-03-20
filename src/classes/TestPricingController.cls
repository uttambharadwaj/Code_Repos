@isTest(SeeAllData = true)
global class TestPricingController {
    
    public static testmethod void testMyCallout() {  
        //TODO make a mock callout to the webservice 
        //following are mockResponses 
        String testXml =
            '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/">'
            +'<soap-env:Body xmlns:soap-env="http://schemas.xmlsoap.org/soap/envelope/">'
            +' <pric:GetPricingRateByCouponOutputMsg xmlns:pric="http://xmlns.wexinc.com/Internal/BOD/Price">'
            +'<pric:CouponPricing>'
            +'<pric:RelationCode>001207</pric:RelationCode>'
            +'<pric:Channel>WEXU</pric:Channel>'
            +'<pric:CouponCode>A01</pric:CouponCode>'
            +'<pric:RiskCode>1</pric:RiskCode>'
            +'<pric:PrimeRate>3.25</pric:PrimeRate>'
            +'<pric:PromoPeriods>1</pric:PromoPeriods>'
            +'<pric:PromoRate>8.17</pric:PromoRate>'
            +'<pric:PromoAddPrime>N</pric:PromoAddPrime>'
            +'<pric:ContractRate>10.15</pric:ContractRate>'
            +'<pric:ContractAddPrime>Y</pric:ContractAddPrime>'
            +'<pric:PenaltyRate>27.34</pric:PenaltyRate>'
            +'<pric:PenaltyAddPrime>Y</pric:PenaltyAddPrime>'
            +'<pric:DaysToPay>21</pric:DaysToPay>'
            +'<pric:LateFeeType>P</pric:LateFeeType>'
            +'<pric:LatePctFee>2.49</pric:LatePctFee>'
            +'<pric:FixedLateFee>0</pric:FixedLateFee>'
            +'<pric:RepaymentFee>49.99</pric:RepaymentFee>'
            +'<pric:OverLimitFee>39.99</pric:OverLimitFee>'
            +'<pric:PaperDeliveryFee>5</pric:PaperDeliveryFee>'
            +'<pric:PenaltyRateCeiling>999.99</pric:PenaltyRateCeiling>'
            +'<pric:PrimeRateDate>1970-01-01 00:00:01</pric:PrimeRateDate>'
            +'<pric:MinPayPct>29.99</pric:MinPayPct>'
            +  '<pric:AuditTrail>'
            +'<com:CreatedBySource xmlns:com="http://xmlns.wexinc.com/Internal/BOD/Common">PeopleSoft</com:CreatedBySource>'
            + '<com:LastUpdatedBySource xmlns:com="http://xmlns.wexinc.com/Internal/BOD/Common">PeopleSoft</com:LastUpdatedBySource>'
            + '</pric:AuditTrail>'
            +'</pric:CouponPricing>'
            + '</pric:GetPricingRateByCouponOutputMsg>'
            +'</soap-env:Body>'
            +'</soapenv:Envelope>';
        
        
        //alternate test case
        String testXml2 =
            '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/">'
            +'<soap-env:Body xmlns:soap-env="http://schemas.xmlsoap.org/soap/envelope/">'
            +' <pric:GetPricingRateByCouponOutputMsg xmlns:pric="http://xmlns.wexinc.com/Internal/BOD/Price">'
            +'<pric:CouponPricing>'
            +'<pric:RelationCode>Test</pric:RelationCode>'
            +'<pric:Channel>Test</pric:Channel>'
            +'<pric:CouponCode>A01</pric:CouponCode>'
            +'<pric:RiskCode>2</pric:RiskCode>'
            +'<pric:PrimeRate>3.25</pric:PrimeRate>'
            +'<pric:PromoPeriods>1</pric:PromoPeriods>'
            +'<pric:PromoRate>8.17</pric:PromoRate>'
            +'<pric:PromoAddPrime>N</pric:PromoAddPrime>'
            +'<pric:ContractRate>10.15</pric:ContractRate>'
            +'<pric:ContractAddPrime>Y</pric:ContractAddPrime>'
            +'<pric:PenaltyRate>27.34</pric:PenaltyRate>'
            +'<pric:PenaltyAddPrime>Y</pric:PenaltyAddPrime>'
            +'<pric:DaysToPay>21</pric:DaysToPay>'
            +'<pric:LateFeeType>P</pric:LateFeeType>'
            +'<pric:LatePctFee>2.49</pric:LatePctFee>'
            +'<pric:FixedLateFee>0</pric:FixedLateFee>'
            +'<pric:RepaymentFee>49.99</pric:RepaymentFee>'
            +'<pric:OverLimitFee>0</pric:OverLimitFee>'
            +'<pric:PaperDeliveryFee>5</pric:PaperDeliveryFee>'
            +'<pric:PenaltyRateCeiling>999.99</pric:PenaltyRateCeiling>'
            +'<pric:MinPayPct>29.99</pric:MinPayPct>'
            +'<pric:PrimeRateDate>1970-01-01 00:00:01</pric:PrimeRateDate>'
            +'<pric:AuditTrail>'
            +'<com:CreatedBySource xmlns:com="http://xmlns.wexinc.com/Internal/BOD/Common">PeopleSoft</com:CreatedBySource>'
            + '<com:LastUpdatedBySource xmlns:com="http://xmlns.wexinc.com/Internal/BOD/Common">PeopleSoft</com:LastUpdatedBySource>'
            + '</pric:AuditTrail>'
            + '</pric:CouponPricing>'
            + '</pric:GetPricingRateByCouponOutputMsg>'
            +'</soap-env:Body>'
            +'</soapenv:Envelope>';
        
        
        UnitTestUtil oUtil = UnitTestUtil.getInstance();
        oUtil.IsUnitTesting = true;
        TG_XmlDom dom = new TG_XmlDom(testXml);
        TG_XmlNode root = dom.root;
        TG_XmlNode testNodes = root.getElementByTagName('pric:CouponPricing');
        
        
        oUtil.MockResponse = testNodes;
        
        Test.startTest();
        
        Campaign_Pricing__c testP = new Campaign_Pricing__c();
        testP = PricingController.elementToResult(oUtil.MockResponse);
        //list to store return camp_pricing
        Set<Campaign_Pricing__c> camps = new Set<Campaign_Pricing__c>();
        Campaign_Pricing__c sResponse = new Campaign_Pricing__c();
        Map<String, String> codes = new Map<String, String>{'001207'=>'A01'};
            try{
        		//Call the webservice    
        		camps = PricingController.pricingController(codes);
        		//try the insert
            }
        catch(DMLException e){
            System.debug('error message: '+ e.getMessage() + 'cause: '+ e.getCause());
        }
        
        
        String ProgramID = sResponse.Peoplesoft_rel_code__c;
        String CouponCD = 'A01';
        //Get a record to use as a test case
        List <Campaign_Pricing__c> campTest = new List<Campaign_Pricing__c>([SELECT Id FROM Campaign_Pricing__c WHERE coup_code__c =:CouponCD AND 
                                                                            Peoplesoft_rel_code__c =:ProgramID]);
        //Test RefreshCampaignPricingDateForCampaignProgram() 1
        List <Id> ids = new List <Id>();
        for (Integer i = 0; i < campTest.size(); i++){
            Id id = campTest.get(i).Id;
            ids.add(id);
        }
        CampaignPricingController.RefreshCampaignPricingDataForCampaignProgram(ids);
        
        System.debug('respose: '+sResponse.getSObjectType());
        TG_XmlDom dom2 = new TG_XmlDom(testXml2);
        TG_XmlNode root2 = dom2.root;
        
        oUtil.MockResponse = root2;
        try{
        	campTest.addAll(PricingController.pricingController(codes));
            insert campTest;
        }
        catch(DMLException e){
             System.debug('insert error:' + e.getMessage() + 'insert cause'+ e.getCause());
            
        }
                
        //Test the returning method of Pricing Controller
        testP = PricingController.elementToResult(root2);
        SYSTEM.debug('campaign result ' + camps);
        
        //Test the create Http request method
        httpRequest req = PricingController.createRequest(ProgramID, CouponCD);
        
        
        //test the scheduled job
        String CRON_EXP = '0 0 0 15 3 ? 2022';
        
        
        String jobId = System.schedule('PricingJob',
                                       CRON_EXP, 
                                       new PricingUpdateScheduler());
        
        // Get the information from the CronTrigger API object
        CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, 
                          NextFireTime
                          FROM CronTrigger WHERE id = :jobId];
        //test CampaignPricing Alone
        CampaignPricingController.RefreshCampaignPricingDataForProgram();
        
        // Verify the expressions are the same
        System.assertEquals(CRON_EXP, 
                            ct.CronExpression);
        
        // Verify the scheduled job hasn't run yet.
        Campaign_Pricing__c[] ml = [SELECT Id FROM Campaign_Pricing__c 
                                    WHERE Name = 'PricingJob'];
        System.assertEquals(ml.size(),0);
        Test.stopTest();
        
        // Now that the scheduled job has executed after Test.stopTest(),
        //   fetch the new campaign that got added.
        ml = [SELECT Id FROM Campaign_Pricing__c 
              WHERE Name = 'PricingJob'];
        System.assertEquals(ml.size(), 0);
        

    }
    
    
}