@isTest
public class MockCalloutGenerator implements HttpCalloutMock {

    private static final String EXPERIAN_REQUEST_ENDPOINT = 'experian_endpoint_returned_from_login_verification';
    private static final String CREDITLENS_REQUEST_AUTH = 'creditlens_authorization_returned_from_variation';
    private static final String CREDITLENS_REQUEST_CREATE = 'creditlens_entity_creation_returned';
    private static final String CREDITLENS_REQUEST_UPLOADDOC = 'creditlens_upload_document_returned';
    private static final String NO_ENDPOINT_FOUND_FAILURE = 'the_requested_endpoint_was_not_found_so_this_fails';

    public Map<String, HttpCalloutMock> requests;

    public MockCalloutGenerator(String myRequest){
        makeRequests(new Set<String>{myRequest});
    }

    public MockCalloutGenerator(Set<String> myRequests){
        makeRequests(myRequests);
    }

    private void makeRequests(Set<String> myRequests){
        MockRequest myNull = new MockRequest(555,'Failure',Blob.valueOf('Man, you are one pathetic loser. No offense.'),null);
        this.requests = new Map<String, HttpCalloutMock>{NO_ENDPOINT_FOUND_FAILURE=>myNull};
        for(String s : myRequests){
            switch on s{
                when 'expGood'{
                    this.requests.put(EXPERIAN_REQUEST_ENDPOINT, new MockRequest(200,'Success',getExpGoodBody(),null));
                }
                when 'expLogin'{
                    String myEndpoint = [SELECT Endpoint_URL__c FROM Credit_Decision_Engine_Endpoints__mdt WHERE DeveloperName = 'Experian_Toolkit' LIMIT 1].Endpoint_URL__c;
                    this.requests.put(myEndpoint, new MockRequest(200,'Success',EXPERIAN_REQUEST_ENDPOINT,null));   
                }
                when 'creditLensAuthGood' {
                    this.requests.put(CREDITLENS_REQUEST_AUTH, new MockRequest(200,'Success',getCreditLensAuthGoodBody(),null));
                }
                when 'creditLensAuthLogin' {
                    String myEndpoint = [SELECT Endpoint_URL__c FROM Credit_Decision_Engine_Endpoints__mdt WHERE DeveloperName = 'Credit_Lens_Auth' LIMIT 1].Endpoint_URL__c;
                    Map<String, String> headers = new Map<String, String>();
                    headers.put('Content-Type', 'application/json');
                    this.requests.put(myEndpoint, new MockRequest(200,'Success',CREDITLENS_REQUEST_AUTH,headers));
                }
                when 'creditLensCreateGood' {
                    this.requests.put(CREDITLENS_REQUEST_CREATE, new MockRequest(200,'Success',getCreditLensCreateGoodBody(),null));
                }
                when 'creditLensCreateLogin' {
                    String myEndpoint = [SELECT Endpoint_URL__c FROM Credit_Decision_Engine_Endpoints__mdt WHERE DeveloperName = 'Credit_Lens_Create_Entity' LIMIT 1].Endpoint_URL__c;
                    Map<String, String> headers = new Map<String, String>();
                    headers.put('Content-Type', 'application/json');
                    headers.put('Authorization', 'Bearer 123456');
                    this.requests.put(myEndpoint, new MockRequest(200,'Success',CREDITLENS_REQUEST_CREATE,headers));
                }
                when 'creditLensUploadDoc' {
                    String myEndpoint = [SELECT Endpoint_URL__c FROM Credit_Decision_Engine_Endpoints__mdt WHERE DeveloperName = 'Credit_Lens_Doc_Upload' LIMIT 1].Endpoint_URL__c;
                    Map<String, String> headers = new Map<String, String>();
                    headers.put('Content-Type', 'multipart/form-data');
                    headers.put('Authorization', 'Bearer 123456');
                    this.requests.put(myEndpoint, new MockRequest(200,'Success',getCreditLensUploadDocGoodBody(),headers));
                }
                when 'creditLensLinkDocToEntity' {
                    String myEndpoint = [SELECT Endpoint_URL__c FROM Credit_Decision_Engine_Endpoints__mdt WHERE DeveloperName = 'Credit_Lens_Doc_to_Entity' LIMIT 1].Endpoint_URL__c;
                    Map<String, String> headers = new Map<String, String>();
                    headers.put('Authorization', 'Bearer 123456');
                    headers.put('Content-Type', 'application/json');
                    this.requests.put(myEndpoint, new MockRequest(200,'Success',getCreditLensLinkDocToEntityGoodBody(),headers));
                }
                when 'WebDAMAuthLogin' {
                    String myEndpoint = 'https://apiv2.webdamdb.com/oauth2/token';
                    Map<String, String> headers = new Map<String, String>();
                    headers.put('Content-Type', 'application/json');
                    this.requests.put(myEndpoint, new MockRequest(200,'Success',getWebDAMSuccessfulAuthBody(),headers));
                }
                when 'WebDAMSearch' {
                    String myEndpoint = 'https://apiv2.webdamdb.com/search?query=infopack';
                    Map<String, String> headers = new Map<String, String>();
                    headers.put('Content-Type', 'application/json');
                    this.requests.put(myEndpoint, new MockRequest(200,'Success',getWebDAMSearchBody(),headers));
                }
                when 'WebDAMDownload' {
                    String myEndpoint = 'https://apiv2.webdamdb.com/assets/100240231/download';
                    Map<String, String> headers = new Map<String, String>();
                    headers.put('Content-Type', 'application/json');
                    this.requests.put(myEndpoint, new MockRequest(200,'Success',Blob.valueOf('test string'),headers));
                }
                when 'MCConnector' {
                    String myEndpoint = 'callout:Marketing_Cloud_Authorization';
                    Map<String, String> headers = new Map<String, String>();
                    headers.put('Content-Type', 'application/json');
                    this.requests.put(myEndpoint, new MockRequest(200,'Success',getMarketingCloudAuthBody(),headers));
                }
                when 'MarketingCloudTriggeredEmail' {
                    String myEndpoint = 'callout:Marketing_Cloud_Triggered_Email/key:'+ MCConnectorTest.TRIGGERED_EMAIL_KEY+'/send';
                    Map<String, String> headers = new Map<String, String>();
                    headers.put('Content-Type', 'application/json');
                    this.requests.put(myEndpoint, new MockRequest(200,'Success',getMarketingCloudTriggeredSendBody(),headers));
                }
            }
        }
    }

    public HTTPResponse respond(HTTPRequest req){
        HttpCalloutMock myMock = requests.get(req.getEndpoint());
        if(myMock == null) myMock = requests.get(NO_ENDPOINT_FOUND_FAILURE);
        return myMock.respond(req);
    }

    public class MockRequest implements HttpCalloutMock{
        protected Integer code;
        protected String status;
        protected String stringBody;
        protected Blob blobBody;
        protected Map<String, String> headers;

        public MockRequest(Integer code, String status, String sBody, Map<String, String> headers){
            this.code = code;
            this.status = status;
            this.stringBody = sBody;
            this.blobBody = null;
            this.headers = headers;
        }

        public MockRequest(Integer code, String status, Blob bBody, Map<String, String> headers){
            this.code = code;
            this.status = status;
            this.stringBody = null;
            this.blobBody = bBody;
            this.headers = headers;
        }

        public HTTPResponse respond(HTTPRequest req){
            HTTPResponse myResponse = new HTTPResponse();
            myResponse.setStatusCode(code);
            myResponse.setStatus(status);
            if(blobBody != null) myResponse.setBodyAsBlob(blobBody);
            else myResponse.setBody(stringBody);
            if(headers != null){
                for(String key : headers.keySet())
                    myResponse.setHeader(key, headers.get(key));
            }
            return myResponse;
        }
    }

    //todo: move this to a static resource? or new apex class? 
    public static String getExpGoodBody(){
        String s = '<?xml version=\"1.0\" standalone=\"no\"?>'+
                    '<NetConnectResponse xmlns=\"http://www.experian.com/NetConnectResponse\">'+
                    '<CompletionCode>0000</CompletionCode>'+
                    '<TransactionId>12345678</TransactionId>'+
                    '<Products xmlns=\"http://www.experian.com/ARFResponse\">'+
                    '<CustomSolution>'+
                    '<Header>'+
                    '<ReportDate>09242019</ReportDate>'+
                    '<ReportTime>120851</ReportTime>'+
                    '<Preamble>TNH1</Preamble>'+
                    '<ARFVersion>07</ARFVersion>'+
                    '<ReferenceNumber>WEXPE/07444352</ReferenceNumber>'+
                    '</Header>'+
                    '<RiskModel>'+
                    '<ModelIndicator code=\"F \">Experian/Fair, Isaac Risk Model V2</ModelIndicator>'+
                    '<Score>0610</Score>'+
                    '<ScoreFactorCodeOne>39</ScoreFactorCodeOne>'+
                    '<ScoreFactorCodeTwo>13</ScoreFactorCodeTwo>'+
                    '<ScoreFactorCodeThree>18</ScoreFactorCodeThree>'+
                    '<ScoreFactorCodeFour>10</ScoreFactorCodeFour>'+
                    '<Evaluation code=\"P\">Positive number</Evaluation>'+
                    '</RiskModel>'+
                    '<RiskModel>'+
                    '<ModelIndicator code=\"2 \">Fraud Shield Score</ModelIndicator>'+
                    '<Score>0603</Score>'+
                    '<ScoreFactorCodeOne>K0</ScoreFactorCodeOne>'+
                    '<ScoreFactorCodeTwo>J6</ScoreFactorCodeTwo>'+
                    '<ScoreFactorCodeThree>B6</ScoreFactorCodeThree>'+
                    '<ScoreFactorCodeFour>C4</ScoreFactorCodeFour>'+
                    '<Evaluation code=\"P\">Positive number</Evaluation>'+
                    '</RiskModel>'+
                    '<RiskModel>'+
                    '<ModelIndicator code=\"Q \">VantageScore</ModelIndicator>'+
                    '<Score>0669</Score>'+
                    '<ScoreFactorCodeOne>BP</ScoreFactorCodeOne>'+
                    '<ScoreFactorCodeTwo>TV</ScoreFactorCodeTwo>'+
                    '<ScoreFactorCodeThree>50</ScoreFactorCodeThree>'+
                    '<ScoreFactorCodeFour>RT</ScoreFactorCodeFour>'+
                    '<Evaluation code=\"P\">Positive number</Evaluation>'+
                    '</RiskModel>'+
                    '<RiskModel>'+
                    '<ModelIndicator code=\"BP\">Bankruptcy PLUS</ModelIndicator>'+
                    '<Score>0504</Score>'+
                    '<ScoreFactorCodeOne>84</ScoreFactorCodeOne>'+
                    '<ScoreFactorCodeTwo>60</ScoreFactorCodeTwo>'+
                    '<ScoreFactorCodeThree>25</ScoreFactorCodeThree>'+
                    '<ScoreFactorCodeFour>55</ScoreFactorCodeFour>'+
                    '<Evaluation code=\"P\">Positive number</Evaluation>'+
                    '</RiskModel>'+
                    '<SSN>'+
                    '<VariationIndicator code=\" \">Same</VariationIndicator>'+
                    '<Number>111111111</Number>'+
                    '</SSN>'+
                    '<ConsumerIdentity>'+
                    '<Name>'+
                    '<Surname>Lar</Surname>'+
                    '<First>Ham</First>'+
                    '<Middle>Burg</Middle>'+
                    '</Name>'+
                    '<YOB>1964</YOB>'+
                    '</ConsumerIdentity>'+
                    '<AddressInformation>'+
                    '<FirstReportedDate>07242018</FirstReportedDate>'+
                    '<LastUpdatedDate>12032018</LastUpdatedDate>'+
                    '<Origination code=\"2\">Reported via A/R Tape</Origination>'+
                    '<TimesReported>05</TimesReported>'+
                    '<LastReportingSubcode>1607340</LastReportingSubcode>'+
                    '<DwellingType code=\"A\">Apartment complex</DwellingType>'+
                    '<HomeOwnership code=\" \">Unknown</HomeOwnership>'+
                    '<StreetPrefix>11</StreetPrefix>'+
                    '<StreetName>MAIN</StreetName>'+
                    '<StreetSuffix>ST</StreetSuffix>'+
                    '<UnitType>APT</UnitType>'+
                    '<UnitID>123</UnitID>'+
                    '<City>KING</City>'+
                    '<State>NC</State>'+
                    '<Zip>272011234</Zip>'+
                    '<CensusGeoCode></CensusGeoCode>'+
                    '</AddressInformation>'+
                    '<EmploymentInformation>'+
                    '<FirstReportedDate>02122007</FirstReportedDate>'+
                    '<LastUpdatedDate>02122007</LastUpdatedDate>'+
                    '<Origination code=\"2\">Inquiry</Origination>'+
                    '<Name>ARMY E6 ETS 3 97</Name>'+
                    '<AddressFirstLine> </AddressFirstLine>'+
                    '<AddressSecondLine> </AddressSecondLine>'+
                    '<AddressExtraLine> </AddressExtraLine>'+
                    '<Zip></Zip>'+
                    '</EmploymentInformation>'+
                    '<TradeLine>'+
                    '<SpecialComment code=\"18\">ACCOUNT CLOSED AT CREDIT GRANTORS REQUEST</SpecialComment>'+
                    '<Evaluation code=\"N\">Closer review is required</Evaluation>'+
                    '<OpenDate>04012014</OpenDate>'+
                    '<StatusDate>03012019</StatusDate>'+
                    '<MaxDelinquencyDate>01012017</MaxDelinquencyDate>'+
                    '<AccountType code=\"18\">Credit Card, Terms REV</AccountType>'+
                    '<TermsDuration code=\"REV\">Revolving</TermsDuration>'+
                    '<ECOA code=\"1\">Individual</ECOA>'+
                    '<Amount>'+
                    '<Qualifier code=\"L\">Limit</Qualifier>'+
                    '<Value>00001200</Value>'+
                    '</Amount>'+
                    '<Amount>'+
                    '<Qualifier code=\" \">Unknown</Qualifier>'+
                    '<Value>   </Value>'+
                    '</Amount>'+
                    '<BalanceDate>03282019</BalanceDate>'+
                    '<BalanceAmount>00000079</BalanceAmount>'+
                    '<Status code=\"38\">Current account/was delinquent 90 days past due date</Status>'+
                    '<AmountPastDue></AmountPastDue>'+
                    '<OpenOrClosed code=\"C\">Closed</OpenOrClosed>'+
                    '<RevolvingOrInstallment code=\"R\">Revolving</RevolvingOrInstallment>'+
                    '<ConsumerComment> </ConsumerComment>'+
                    '<AccountNumber>123456789012</AccountNumber>'+
                    '<MonthsHistory>57</MonthsHistory>'+
                    '<DelinquenciesOver30Days>00</DelinquenciesOver30Days>'+
                    '<DelinquenciesOver60Days>02</DelinquenciesOver60Days>'+
                    '<DelinquenciesOver90Days>01</DelinquenciesOver90Days>'+
                    '<DerogCounter>00</DerogCounter>'+
                    '<PaymentProfile>BCCCCCCCCCCCCCCCCC2CCCCCC</PaymentProfile>'+
                    '<MonthlyPaymentAmount>00000020</MonthlyPaymentAmount>'+
                    '<MonthlyPaymentType code=\"S\">Scheduled Term</MonthlyPaymentType>'+
                    '<LastPaymentDate>02062019</LastPaymentDate>'+
                    '<Subcode>1240000</Subcode>'+
                    '<KOB code=\"BC\">Bank Credit Cards</KOB>'+
                    '<SubscriberDisplayName>CITICARDS CBNA</SubscriberDisplayName>'+
                    '<MaxPayment  code=\"3\"/>'+
                    '<FirstDelinquencyDate>09012017</FirstDelinquencyDate>'+
                    '<SecondDelinquencyDate>01012017</SecondDelinquencyDate>'+
                    '<EnhancedPaymentData>'+
                    '<InitialPaymentLevelDate>03012019</InitialPaymentLevelDate>'+
                    '<AccountCondition code=\"A3\">Closed</AccountCondition>'+
                    '<PaymentStatus code=\"38\">Current, was delinquent 90 days past due</PaymentStatus>'+
                    '<AccountType code=\"18\">Credit Card, Terms REV</AccountType>'+
                    '<SpecialComment code=\"18\">Account closed at credit grantors request</SpecialComment>'+
                    '</EnhancedPaymentData>'+
                    '</TradeLine>'+
                    '<Inquiry>'+
                    '<Date>06102017</Date>'+
                    '<Amount> UNKNOWN</Amount>'+
                    '<Type code=\"31\">Unknown - Credit Extension, Review, Or Collection</Type>'+
                    '<Terms code=\"UNK\"/>'+
                    '<Subcode>2160178</Subcode>'+
                    '<KOB code=\"BB\">All Banks -- Non-Specific</KOB>'+
                    '<SubscriberDisplayName>BANK</SubscriberDisplayName>'+
                    '</Inquiry>'+
                    '<InformationalMessage>'+
                    '<MessageNumber>63</MessageNumber>'+
                    '<MessageText>N00    0000</MessageText>'+
                    '</InformationalMessage>'+
                    '<Statement>'+
                    '<Type code=\"01\">Consumer disputes related to a subscriber transaction(exception data)</Type>'+
                    '<DateReported>03152015</DateReported>'+
                    '<StatementText>'+
                    '<MessageText>01 03-15-15 2322480 CONSUMER COMMENT TEXT PRESENT</MessageText>'+
                    '</StatementText>'+
                    '</Statement>'+
                    '<FraudServices>'+
                    '<Type code=\"04\">Onfile address message</Type>'+
                    '<SIC code=\"M0000000\"/>'+
                    '<Text>CKPT: COMMERCIAL BUSINESS ADDRESS ON FACS FILE/COMMERCIAL BUSINESS ADDRESS/RR 1/LA PORTE CITY IA 50651</Text>'+
                    '<SocialDate>02012019</SocialDate>'+
                    '<SocialCount>0000</SocialCount>'+
                    '<SocialErrorCode code=\"0\">No error conditions occur</SocialErrorCode>'+
                    '<AddressDate>02012019</AddressDate>'+
                    '<AddressCount>0000</AddressCount>'+
                    '<AddressErrorCode code=\"0\">No error conditions occur</AddressErrorCode>'+
                    '<SSNFirstPossibleIssuanceYear>1999</SSNFirstPossibleIssuanceYear>'+
                    '<SSNLastPossibleIssuanceYear>2000</SSNLastPossibleIssuanceYear>'+
                    '<Indicator>10</Indicator>'+
                    '<Indicator>12</Indicator>'+
                    '<Indicator>16</Indicator>'+
                    '<Indicator>  </Indicator>'+
                    '</FraudServices>'+
                    '<PremierAttributes>'+
                    '<Message code=\"01\"/>'+
                    '<Attributes>'+
                    '<Attribute>'+
                    '<Name>ALL0400</Name>'+
                    '<Value>000000010</Value>'+
                    '</Attribute>'+
                    '<Attribute>'+
                    '<Name>RTR5420</Name>'+
                    '<Value>000003569</Value>'+
                    '</Attribute>'+
                    '<Attribute>'+
                    '<Name>ILN5420</Name>'+
                    '<Value>999903569</Value>'+
                    '</Attribute>'+
                    '<Attribute>'+
                    '<Name>REH5420</Name>'+
                    '<Value>000003569</Value>'+
                    '</Attribute>'+
                    '</Attributes>'+
                    '</PremierAttributes>'+
                    '</CustomSolution>'+
                    '</Products>'+
                    '</NetConnectResponse>';
        return s;
    }

    public static String getCreditLensAuthGoodBody() {
        String json = '{'+
                '    \"payLoad\": {'+
                '        \"user\": {'+
                '            \"UserId\": \"SFintegration\",'+
                '            \"UserName\": \"Salesforce Integration\",'+
                '            \"TenantId\": \"Tenant\",'+
                '            \"IsSuperAdministrator\": true,'+
                '            \"ConfigID\": 1,'+
                '            \"UserAuthorization\": ['+
                '                {'+
                '                    \"Id\": 37,'+
                '                    \"BusinessPortfolio\": ['+
                '                        \"AMER\"'+
                '                    ],'+
                '                    \"CreditPortfolio\": \"WexBank\",'+
                '                    \"Role\": \"CA\",'+
                '                    \"UserId\": \"SFintegration\",'+
                '                    \"Inapplicable_\": [],'+
                '                    \"WFId_\": \"00000000-0000-0000-0000-000000000000\",'+
                '                    \"TaskId_\": \"00000000-0000-0000-0000-000000000000\",'+
                '                    \"VersionId_\": 1,'+
                '                    \"BaseVersionId_\": 0,'+
                '                    \"IsLatestVersion_\": true,'+
                '                    \"IsDeleted_\": false,'+
                '                    \"StatusId_\": 1,'+
                '                    \"CreatedBy_\": \"lhowland\",'+
                '                    \"CreatedDate_\": \"2019-11-25T17:44:56.108652Z\",'+
                '                    \"t_\": \"UserAuthorization\",'+
                '                    \"ContextUserId_\": \"lhowland\",'+
                '                    \"IsValid_\": true,'+
                '                    \"IsVisible_\": true,'+
                '                    \"SnapshotId_\": 0'+
                '                },'+
                '                {'+
                '                    \"Id\": 38,'+
                '                    \"BusinessPortfolio\": null,'+
                '                    \"CreditPortfolio\": null,'+
                '                    \"Role\": \"BA\",'+
                '                    \"UserId\": \"SFintegration\",'+
                '                    \"Inapplicable_\": [],'+
                '                    \"WFId_\": \"00000000-0000-0000-0000-000000000000\",'+
                '                    \"TaskId_\": \"00000000-0000-0000-0000-000000000000\",'+
                '                    \"VersionId_\": 1,'+
                '                    \"BaseVersionId_\": 0,'+
                '                    \"IsLatestVersion_\": true,'+
                '                    \"IsDeleted_\": false,'+
                '                    \"StatusId_\": 1,'+
                '                    \"CreatedBy_\": \"lhowland\",'+
                '                    \"CreatedDate_\": \"2019-11-25T19:49:58.826337Z\",'+
                '                    \"t_\": \"UserAuthorization\",'+
                '                    \"ContextUserId_\": \"lhowland\",'+
                '                    \"IsValid_\": true,'+
                '                    \"IsVisible_\": true,'+
                '                    \"SnapshotId_\": 0'+
                '                }'+
                '            ]'+
                '        },'+
                '        \"token\": \"0a3dfbe5-7947-47e0-8460-cf508c348d91\",'+
                '        \"devMode\": false'+
                '    },'+
                '    \"status\": null'+
                '}';

        return json;
    }

    // create entity record
    public static String getCreditLensCreateGoodBody() {
        String json = '{'+
                '    \"payLoad\": ['+
                '        {'+
                '            \"disableCreate\": {},'+
                '            \"EntityType\": \"CORP\",'+
                '            \"LongName\": \"Test Company\",'+
                '            \"ShortName\": \"Test\",'+
                '            \"EntityId\": 245,'+
                '            \"SystemId\": \"Application-123\",'+
                '            \"LegalEntity\": \"Text\",'+
                '            \"WexAccountNumber\": \"1234435\",'+
                '            \"TaxId\": \"12344556\",'+
                '            \"WexDunsNumber\": \"1233343\",'+
                '            \"CustomerSince\": null,'+
                '            \"CountryOfInc\": \"USA\",'+
                '            \"ProvinceStateOfIncorporation\": \"USME\",'+
                '            \"WexYearIncorporated\": \"2000\",'+
                '            \"EstablishmentDate\": \"2000\",'+
                '            \"RegistrationNumber\": \"TEST\",'+
                '            \"OnList\": null,'+
                '            \"WexYearEst\": null,'+
                '            \"WexYearControl\": null,'+
                '            \"Descriptions\": null,'+
                '            \"Gc23\": null,'+
                '            \"Gc22\": null,'+
                '            \"ExternalDataSources\": null,'+
                '            \"WexFsAvlblDate\": null,'+
                '            \"WexYearEstablished\": \"2000\",'+
                '            \"BusinessPortfolio\": \"CAN\",'+
                '            \"Division\": \"SingleSelect\",'+
                '            \"CreditPortfolio\": \"WexBank\",'+
                '            \"WexBusinessUnit\": \"CorpPay\",'+
                '            \"WexProgram\": \"Divvy\",'+
                '            \"PrimaryBankingOfficer\": \"Salesforce Integration\",'+
                '            \"PrimaryCreditOfficer\": \"Leela Howland\",'+
                '            \"t_\": \"Entity\",'+
                '            \"IsValid_\": true,'+
                '            \"IsDeleted_\": false,'+
                '            \"Access_\": 5,'+
                '            \"BaseVersionId_\": 0,'+
                '            \"VersionId_\": 1,'+
                '            \"Inapplicable_\": [],'+
                '            \"Associations_\": ['+
                '                \"EntityHierarchy\",'+
                '                \"EntityReOrgHistory\",'+
                '                \"EntityIndustry\",'+
                '                \"EntityOfficers\",'+
                '                \"Contact\",'+
                '                \"Address\",'+
                '                \"DirectorAndCompanyOfficer\",'+
                '                \"Document\",'+
                '                \"EntityGroup\",'+
                '                \"BusinessProposal\",'+
                '                \"EntityGroupEntityLink\",'+
                '                \"EntityDocumentLink\",'+
                '                \"MapInstance\",'+
                '                \"Financial\",'+
                '                \"EntityRating\",'+
                '                \"RatingScenario\",'+
                '                \"RiskGradingSettings\",'+
                '                \"RiskGradingCeSettings\",'+
                '                \"ProductBorrower\",'+
                '                \"Collateral\",'+
                '                \"EntityDealInfo\",'+
                '                \"AssetBorrower\",'+
                '                \"AssetOwner\",'+
                '                \"AuthorizedEntity\",'+
                '                \"CollateralProvider\",'+
                '                \"AssetEntityLink\",'+
                '                \"CovenantAdvanced\",'+
                '                \"CovenantTrackingProposal\",'+
                '                \"CovenantTrackingTask\",'+
                '                \"EntityCovenantStatistic\",'+
                '                \"ActiveTesting\",'+
                '                \"HistoryTesting\",'+
                '                \"StatementSelection\",'+
                '                \"Covenant\",'+
                '                \"CovenantAdvancedEntityLink\",'+
                '                \"EntityCreditMemo\",'+
                '                \"SpreadDocument\",'+
                '                \"SpreadProposal\",'+
                '                \"MarqAttribute\",'+
                '                \"Product\",'+
                '                \"Asset\",'+
                '                \"BvdAttribute\"'+
                '            ],'+
                '            \"FirmType\": \"PUB\",'+
                '            \"CountryOfRisk\": \"USA\",'+
                '            \"Currency\": \"USD\",'+
                '            \"ListingDate\": null,'+
                '            \"CountryOfListing\": \"CAN\",'+
                '            \"StockExchange\": \"TSE\",'+
                '            \"StockCode\": \"TSE\",'+
                '            \"IndClassification\": \"SIC\",'+
                '            \"WexLastReviewDate\": null,'+
                '            \"WexReviewDate\": null,'+
                '            \"WexReviewType\": \"Test\",'+
                '            \"WexRequestCurrency\": \"USD\",'+
                '            \"WexExistingCreditLineAmt\": \"200000\",'+
                '            \"WexRequestCreditLineAmount\": \"200000\",'+
                '            \"WexCreditInformationOn\": null,'+
                '            \"WexPaymentHistory\": null,'+
                '            \"WexProejctedMonthlySpend\": \"20000\",'+
                '            \"WexHighCycleSpend\": null,'+
                '            \"BillingCycle\": null,'+
                '            \"DaysToPay\": null,'+
                '            \"WexBillingCycle1\": null,'+
                '            \"WexDaysToPay1\": null,'+
                '            \"WexBillingCycle2\": null,'+
                '            \"WexDaysToPay2\": null,'+
                '            \"WexBillingCycle3\": null,'+
                '            \"WexDaysToPay3\": null,'+
                '            \"WexPaymentType\": null,'+
                '            \"CollateralSecurity\": null,'+
                '            \"CollateralSecuringEntity\": \"Text\",'+
                '            \"WexCollateralAmt\": null,'+
                '            \"WexPrimaryRiskGrade\": null,'+
                '            \"WexPrimaryRiskGradeSource\": null,'+
                '            \"WexSecondaryRiskGrade\": null,'+
                '            \"WexSecondaryRiskGradeSource\": null,'+
                '            \"WexCreditExtended\": null,'+
                '            \"WexNumberOfCreditExperiences\": null,'+
                '            \"WexPaydexScore\": \"Test\",'+
                '            \"WexOriginationModelRecommendat\": null,'+
                '            \"RequestedCreditLineDl\": null,'+
                '            \"CollateralExpirationDate\": null,'+
                '            \"CollateralAmt\": null,'+
                '            \"ExisitingCreditLineDl\": null,'+
                '            \"WexApprovedCreditLine\": \"test\",'+
                '            \"WexCreditLineCurrency\": \"Test\",'+
                '            \"NextReviewDate\": null,'+
                '            \"WexFinancialsRequestedDate\": null,'+
                '            \"WexFinancialsRequestedDate2\": null,'+
                '            \"WexFinancialsReceivedDate\": null,'+
                '            \"EntityOfficers\": [],'+
                '            \"EntityContactCreateAndEdit\": [],'+
                '            \"EntityAddress\": ['+
                '                {'+
                '                    \"AddressId\": 14,'+
                '                    \"AddressType\": \"MAILING\",'+
                '                    \"Address1\": \"700 Main St\",'+
                '                    \"Address2\": null,'+
                '                    \"Country\": \"USA\",'+
                '                    \"State\": \"USNE\",'+
                '                    \"City\": \"Omaha\",'+
                '                    \"Zip\": \"68114\",'+
                '                    \"ExternalDataSource\": null,'+
                '                    \"t_\": \"Address\",'+
                '                    \"IsValid_\": true,'+
                '                    \"IsDeleted_\": false,'+
                '                    \"Access_\": 5,'+
                '                    \"BaseVersionId_\": 0,'+
                '                    \"VersionId_\": 1,'+
                '                    \"Inapplicable_\": []'+
                '                }'+
                '            ],'+
                '            \"EntityGroupGrid\": [],'+
                '            \"IndustrySelection\": ['+
                '                {'+
                '                    \"IndustryId\": 8,'+
                '                    \"IndustryCode\": {'+
                '                        \"Code\": \"1311\",'+
                '                        \"Description\": \"Crude petroleum and natural gas\",'+
                '                        \"Keys\": ['+
                '                            \"B\",'+
                '                            \"13\",'+
                '                            \"1311\"'+
                '                        ]'+
                '                    },'+
                '                    \"Percentage\": 1.0,'+
                '                    \"IsPrimary\": true,'+
                '                    \"EntityId\": 245,'+
                '                    \"Classification\": \"SIC\",'+
                '                    \"ExternalDataSource\": null,'+
                '                    \"t_\": \"EntityIndustry\",'+
                '                    \"IsValid_\": true,'+
                '                    \"IsDeleted_\": false,'+
                '                    \"Access_\": 5,'+
                '                    \"BaseVersionId_\": 0,'+
                '                    \"VersionId_\": 1,'+
                '                    \"Inapplicable_\": []'+
                '                }'+
                '            ],'+
                '            \"DirectorAndCompanyOfficer\": [],'+
                '            \"EntityHierarchy\": [],'+
                '            \"EntityReOrgHistory\": [],'+
                '            \"EntityDocumentLinkVm\": [],'+
                '            \"UpdatedBy_\": null'+
                '        }'+
                '    ],'+
                '    \"status\": {}'+
                '}';

        return json;
    }

    public static String getCreditLensUploadDocGoodBody() {

        String json = '{'+
        '    \"payLoad\": ['+
        '        {'+
        '            \"DocumentId\": \"31a6a6b5-899d-421b-b12d-fcba904e5c5b\",'+
        '            \"VersionId_\": 1,'+
        '            \"BaseVersionId_\": 0,'+
        '            \"OriginalFileName\": \"TestFinancials.txt\"'+
        '        }'+
        '    ],'+
        '    \"Status\": {}'+
        '}';

        return json;
    }

    public static String getCreditLensLinkDocToEntityGoodBody() {

        String json = '{'+
                '    \"payLoad\": ['+
                '        ['+
                '            {'+
                '                \"disableCreate\": {},'+
                '                \"StatementDate\": \"2020-01-14T00:00:00Z\",'+
                '                \"SpreadStatementCount\": \"1\",'+
                '                \"SpreadDocumentId\": \"c373d5e0-e9fb-4a44-b304-fc97c5060bc9\",'+
                '                \"DocumentStatus\": \"SUBMITTED\",'+
                '                \"FinancialTemplateId\": \"6\",'+
                '                \"ExternalId\": null,'+
                '                \"ExternalActionDate\": null,'+
                '                \"ExternalSubmittedDate\": null,'+
                '                \"EntityId\": 258,'+
                '                \"DocumentId\": \"7c81409d-e093-4bfc-9e87-b2aec8d0d2bc\",'+
                '                \"SpreadDocumentType\": \"FINANCIAL_DOCUMENT\",'+
                '                \"Rules\": {'+
                '                    \"LinkAutoSpreadDocumentToEntity\": {'+
                '                        \"success\": true,'+
                '                        \"data\": {'+
                '                            \"LinkId\": 74'+
                '                        },'+
                '                        \"ruleName\": \"LinkAutoSpreadDocumentToEntity\"'+
                '                    }'+
                '                },'+
                '                \"t_\": \"SpreadDocument\",'+
                '                \"IsValid_\": true,'+
                '                \"IsDeleted_\": false,'+
                '                \"BaseVersionId_\": 0,'+
                '                \"VersionId_\": 1,'+
                '                \"Inapplicable_\": [],'+
                '                \"Associations_\": ['+
                '                    \"SpreadStatement\"'+
                '                ],'+
                '                \"SpreadStatement\": ['+
                '                    {'+
                '                        \"SpreadDocumentId\": \"c373d5e0-e9fb-4a44-b304-fc97c5060bc9\",'+
                '                        \"SpreadStatementId\": \"002f115c-f20c-42c7-9a10-5551bdf7afbe\",'+
                '                        \"StatementDate\": \"2020-01-14T00:00:00Z\",'+
                '                        \"StatementPeriod\": 12,'+
                '                        \"StatementType\": \"ANNUAL\",'+
                '                        \"StatementStatus\": null,'+
                '                        \"HistoricalStatementId\": null,'+
                '                        \"t_\": \"SpreadStatement\",'+
                '                        \"IsValid_\": true,'+
                '                        \"IsDeleted_\": false,'+
                '                        \"BaseVersionId_\": 0,'+
                '                        \"VersionId_\": 1,'+
                '                        \"Inapplicable_\": []'+
                '                    }'+
                '                ],'+
                '                \"UpdatedBy_\": null'+
                '            }'+
                '        ]'+
                '    ],'+
                '    \"status\": {}'+
                '}';

        return json;
    }

    public static String getWebDAMSuccessfulAuthBody() {

        String json = '{"access_token":"321ea8800752d0de005582560c6d8f7006435cc8","expires_in":3600,"token_type":"bearer","scope":null,"refresh_token":"a7bdfecaeadb842759d35a80bf3c9251531483ea"}';
        return json;
    }

    public static String getWebDAMSearchBody() {
        String json = '{\"success\":1,\"total_count\":22,\"offset\":0,\"limit\":1,\"items\":[{\"id\":\"100240231\",\"type\":\"asset\",\"type_id\":\"4\",\"status\":\"active\",\"filename\":\"WE_Roadside_InfoPack.pdf\",\"name\":\"WE_Roadside_InfoPack.pdf\",\"filesize\":\"1.65\",\"width\":\"612\",\"height\":\"792\",\"description\":\"\",\"filetype\":\"pdf\",\"colorspace\":\"CMYK\",\"version\":\"1\",\"datecreated\":\"2019-12-18 10:57:50\",\"date_created_unix\":\"1576695470\",\"datemodified\":\"2019-12-19 11:52:14\",\"date_modified_unix\":\"1576785134\",\"datecapturedUnix\":\"1530234045\",\"datecaptured\":\"2018-06-28 18:00:45\",\"mediaUrl\":\"<div class=\\\"documentViewerArea\\\" style=\\\"height:100%;\\\">\\n                            <iframe\\n                            src=\\\"\\/js\\/external\\/pdfjs\\/web\\/viewer.html?file=https:\\/\\/cdn2.webdamdb.com\\/md_cradQc3fGX99.jpg.pdf?v=1\\\"                                                         \\n                            style=\\\"width: 100%; height:100%; border: 1px solid black;\\\" \\/> \\n                            <\\/div>\",\"hiResMediaUrl\":\"<div class=\\\"documentViewerArea\\\" style=\\\"height:100%;\\\">\\n                            <iframe\\n                            src=\\\"\\/js\\/external\\/pdfjs\\/web\\/viewer.html?file=https:\\/\\/cdn2.webdamdb.com\\/md_cradQc3fGX99.jpg.pdf?v=1\\\"                                                         \\n                            style=\\\"width: 100%; height:100%; border: 1px solid black;\\\" \\/> \\n                            <\\/div>\",\"hiResURLRaw\":\"https:\\/\\/cdn2.webdamdb.com\\/md_cradQc3fGX99.jpg.pdf?v=1\",\"numComments\":0,\"pagecount\":\"4\",\"hasthumbnail\":\"0\",\"numExif\":0,\"numXmp\":\"1\",\"user\":{\"type\":\"user\",\"id\":\"416958\",\"email\":\"lisa.sposato@wexinc.com\",\"firstname\":\"Lisa\",\"lastname\":\"Sposato\",\"name\":\"Lisa Sposato\",\"username\":\"lisa.sposato\",\"status\":\"active\",\"role\":4},\"folder\":{\"type\":\"folder\",\"id\":\"3345989\",\"name\":\"Inside Sales\",\"permissions\":{\"folders\":[],\"assets\":[\"download\"]},\"properties\":{\"ALBENABLE_REQUESTRECIPIENT\":\"\",\"ALBWATERMARKPHOTOS\":\"0\",\"ALBEMAILHIRESDOWNLOAD\":\"\",\"ALBENABLE_REQUESTDOWNLOAD\":\"\",\"ALBENABLE_DOWNLOADUSAGE\":\"\"}},\"thumbnailurls\":[{\"size\":100,\"url\":\"https:\\/\\/cdn2.webdamdb.com\\/100th_sm_cradQc3fGX99.jpg?1576785134\"},{\"size\":150,\"url\":\"https:\\/\\/cdn2.webdamdb.com\\/150th_sm_cradQc3fGX99.jpg?1576785134\"},{\"size\":220,\"url\":\"https:\\/\\/cdn2.webdamdb.com\\/220th_sm_cradQc3fGX99.jpg?1576785134\"},{\"size\":310,\"url\":\"https:\\/\\/cdn2.webdamdb.com\\/310th_sm_cradQc3fGX99.jpg?1576785134\"},{\"size\":550,\"url\":\"https:\\/\\/cdn2.webdamdb.com\\/md_cradQc3fGX99.jpg?1576785134\",\"previewurls\":[]},{\"size\":1280,\"url\":\"https:\\/\\/cdn2.webdamdb.com\\/1280_cradQc3fGX99.jpg?1576785134\"}],\"numRelated\":0,\"readonly\":0,\"readonlynext\":0,\"onhold\":0,\"metadata\":{\"required\":{}},\"prevAssetId\":null}],\"facets\":{\"type\":{\"image\":0,\"document\":22,\"audiovideo\":0,\"presentation\":0,\"other\":0}}}';
        return json;
    }

    private static String getMarketingCloudAuthBody() {
        String json = '{\"access_token\": \"eyJhbGciOiJIUzI1NiIsImtpZCI6IjEiLCJ2ZXIiOiIxIiwidHlwIjoiSldUIn0.eyJhY2Nlc3NfdG9rZW4iOiJacnhvVFg0V0RuNFdVNzI0NjI1aHBMZW8iLCJjbGllbnRfaWQiOiJvMTI1ZGRjN3QwNDNlZmRwdGtidmZpcW8iLCJlaWQiOjEwMDAyNjY0NSwic3RhY2tfa2V5IjoiUzEwIiwicGxhdGZvcm1fdmVyc2lvbiI6MiwiY2xpZW50X3R5cGUiOiJTZXJ2ZXJUb1NlcnZlciJ9.fXyxCJzxA67Yq721_DBAVOahOMMbXE2nkt5huhv9FOM._TeKU_onn315RxwBLqK7Is35Kx38rBgW__23LKl8ueF1EtC56gO6vZydgG4EmV_G9Y_PuPBN3VEfdFP8cHPU_I46jBzRAjfKPm2BXiupEWWe8DcZrADxJzV-mXavvU0pyYPgyQ1D9PJXBXmCzH4ldWLtXn88uk-NSWXmUmjBGoEgV5WnyEd\",    \"token_type\": \"Bearer\",    \"expires_in\": 1079,    \"scope\": \"offline documents_and_images_read documents_and_images_write saved_content_read saved_content_write email_read email_send email_write push_read push_send push_write sms_read sms_send sms_write audiences_read audiences_write list_and_subscribers_read list_and_subscribers_write data_extensions_read data_extensions_write file_locations_read file_locations_write tracking_events_read accounts_read accounts_write marketing_cloud_connect_read marketing_cloud_connect_write marketing_cloud_connect_send tracking_events_write\",    \"soap_instance_url\": \"https://mcb9lg4yfkyxd3c4ctrlcfsdpln4.soap.marketingcloudapis.com",    \"rest_instance_url\": \"https://mcb9lg4yfkyxd3c4ctrlcfsdpln4.rest.marketingcloudapis.com"}';
        return json;
    }

    private static String getMarketingCloudTriggeredSendBody() {
        String json = '{"requestId":"5cddb241-39a8-4916-afaa-c168a71a7bda","responses":[{"recipientSendId":"5cddb241-39a8-4916-afaa-c168a71a7bda","hasErrors":false,"messages":["Queued"]}]}';
        return json;
    }
}