@isTest
public class MockCalloutGenerator {

    private static final String EXPERIAN_REQUEST_ENDPOINT = 'experian_endpoint_returned_from_login_verification';
    private static final String NO_ENDPOINT_FOUND_FAILURE = 'the_requested_endpoint_was_not_found_so_this_fails';

    public static MockRequest makeRequest(String myRequest){
        switch on myRequest{
            when 'basic'{
                return new MockRequest(200,'Success','GoodBody',null); //code,status,body,headers
            }
            when 'expGood'{
                return new MockRequest(200,'Success',getExpGoodBody(),null);
            }
            when 'expLogin'{
                return new MockRequest(200,'Success',EXPERIAN_REQUEST_ENDPOINT,null);
            }
            when else {
                return new MockRequest(555,'Failure',Blob.valueOf('Man, you are one pathetic loser. No offense.'),null);
            }
        }

    }

    public static MockMultiRequest makeRequest(Set<String> myRequests){
        Map<String, String> myMap = new Map<String, String>();
        for(String s : myRequests){
            switch on s{
                when 'expGood'{
                    myMap.put(EXPERIAN_REQUEST_ENDPOINT, s);
                }
                when 'expLogin'{
                    Credit_Decision_Engine_Endpoints__mdt myEndpoint = [SELECT Endpoint_URL__c FROM Credit_Decision_Engine_Endpoints__mdt WHERE DeveloperName = 'Experian_Toolkit'];
                    myMap.put(myEndpoint.Endpoint_URL__c, s);
                }
            }
        }
        return new MockMultiRequest(myMap);
    }

    public class MockMultiRequest implements HttpCalloutMock{
        Map<String, HttpCalloutMock> requests;

        public MockMultiRequest(Map<String, HttpCalloutMock> requests){
            this.requests = requests;
        }

        public MockMultiRequest(Map<String, String> requests){
            this.requests = new Map<String, HttpCalloutMock>{NO_ENDPOINT_FOUND_FAILURE=>null};
            for(String s : requests.keySet())
                this.requests.put(s, makeRequest(requests.get(s)));
        }

        public HTTPResponse respond(HTTPRequest req){
            HttpCalloutMock myMock = requests.get(req.getEndpoint());
            if(myMock == null) myMock = requests.get(NO_ENDPOINT_FOUND_FAILURE);
            return myMock.respond(req);
        }
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
}