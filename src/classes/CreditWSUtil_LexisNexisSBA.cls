public class CreditWSUtil_LexisNexisSBA {
    public class SmallBusinessAnalyticsRequest_element {
        public CreditWSUtil_LexisNexisSBA.User_x User_x;
        public CreditWSUtil_LexisNexisSBA.SBAOptions Options;
        public CreditWSUtil_LexisNexisSBA.SBASearchBy SearchBy;
        private String[] User_x_type_info = new String[]{'User','http://webservices.seisint.com/WsAnalytics',null,'0','1','false'};
        private String[] Options_type_info = new String[]{'Options','http://webservices.seisint.com/WsAnalytics',null,'0','1','false'};
        private String[] SearchBy_type_info = new String[]{'SearchBy','http://webservices.seisint.com/WsAnalytics',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://webservices.seisint.com/WsAnalytics','true','false'};
        private String[] field_order_type_info = new String[]{'User_x','Options','SearchBy'};
    }
    public class SBAScoreHRI {
        public String Type_x;
        public Integer Value;
        public CreditWSUtil_LexisNexisSBA.ScoreReasons_element ScoreReasons;
        private String[] Type_x_type_info = new String[]{'Type','http://webservices.seisint.com/WsAnalytics',null,'0','1','false'};
        private String[] Value_type_info = new String[]{'Value','http://webservices.seisint.com/WsAnalytics',null,'0','1','false'};
        private String[] ScoreReasons_type_info = new String[]{'ScoreReasons','http://webservices.seisint.com/WsAnalytics',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://webservices.seisint.com/WsAnalytics','true','false'};
        private String[] field_order_type_info = new String[]{'Type_x','Value','ScoreReasons'};
    }
    public class SBAModelHRI {
        public String Name;
        public CreditWSUtil_LexisNexisSBA.Scores_element Scores;
        private String[] Name_type_info = new String[]{'Name','http://webservices.seisint.com/WsAnalytics',null,'0','1','false'};
        private String[] Scores_type_info = new String[]{'Scores','http://webservices.seisint.com/WsAnalytics',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://webservices.seisint.com/WsAnalytics','true','false'};
        private String[] field_order_type_info = new String[]{'Name','Scores'};
    }
    public class ArrayOfEspException extends Exception {
        public String Source;
        public CreditWSUtil_LexisNexisSBA.EspException[] Exception_x;
        private String[] Source_type_info = new String[]{'Source','http://webservices.seisint.com/WsAnalytics',null,'0','1','false'};
        private String[] Exception_x_type_info = new String[]{'Exception','http://webservices.seisint.com/WsAnalytics',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'http://webservices.seisint.com/WsAnalytics','true','false'};
        private String[] field_order_type_info = new String[]{'Source','Exception_x'};
    }
    public class User_x {
        public String ReferenceCode;
        public String BillingCode;
        public String QueryId;
        public String GLBPurpose;
        public String DLPurpose;
        public CreditWSUtil_LexisNexisSBA.EndUserInfo EndUser;
        public Integer MaxWaitSeconds;
        public String AccountNumber;
        public String OutputType;
        private String[] ReferenceCode_type_info = new String[]{'ReferenceCode','http://webservices.seisint.com/WsAnalytics',null,'0','1','false'};
        private String[] BillingCode_type_info = new String[]{'BillingCode','http://webservices.seisint.com/WsAnalytics',null,'0','1','false'};
        private String[] QueryId_type_info = new String[]{'QueryId','http://webservices.seisint.com/WsAnalytics',null,'0','1','false'};
        private String[] GLBPurpose_type_info = new String[]{'GLBPurpose','http://webservices.seisint.com/WsAnalytics',null,'0','1','false'};
        private String[] DLPurpose_type_info = new String[]{'DLPurpose','http://webservices.seisint.com/WsAnalytics',null,'0','1','false'};
        private String[] EndUser_type_info = new String[]{'EndUser','http://webservices.seisint.com/WsAnalytics',null,'0','1','false'};
        private String[] MaxWaitSeconds_type_info = new String[]{'MaxWaitSeconds','http://webservices.seisint.com/WsAnalytics',null,'0','1','false'};
        private String[] AccountNumber_type_info = new String[]{'AccountNumber','http://webservices.seisint.com/WsAnalytics',null,'0','1','false'};
        private String[] OutputType_type_info = new String[]{'OutputType','http://webservices.seisint.com/WsAnalytics',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://webservices.seisint.com/WsAnalytics','true','false'};
        private String[] field_order_type_info = new String[]{'ReferenceCode','BillingCode','QueryId','GLBPurpose','DLPurpose','EndUser','MaxWaitSeconds','AccountNumber','OutputType'};
    }
    public class SBAModelOption {
        public String OptionName;
        public String OptionValue;
        private String[] OptionName_type_info = new String[]{'OptionName','http://webservices.seisint.com/WsAnalytics',null,'0','1','false'};
        private String[] OptionValue_type_info = new String[]{'OptionValue','http://webservices.seisint.com/WsAnalytics',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://webservices.seisint.com/WsAnalytics','true','false'};
        private String[] field_order_type_info = new String[]{'OptionName','OptionValue'};
    }
    public class Address {
        public String StreetNumber;
        public String StreetPreDirection;
        public String StreetName;
        public String StreetSuffix;
        public String StreetPostDirection;
        public String UnitDesignation;
        public String UnitNumber;
        public String StreetAddress1;
        public String StreetAddress2;
        public String City;
        public String State;
        public String Zip5;
        public String Zip4;
        public String County;
        public String PostalCode;
        public String StateCityZip;
        public String Latitude;
        public String Longitude;
        private String[] StreetNumber_type_info = new String[]{'StreetNumber','http://webservices.seisint.com/WsAnalytics',null,'0','1','false'};
        private String[] StreetPreDirection_type_info = new String[]{'StreetPreDirection','http://webservices.seisint.com/WsAnalytics',null,'0','1','false'};
        private String[] StreetName_type_info = new String[]{'StreetName','http://webservices.seisint.com/WsAnalytics',null,'0','1','false'};
        private String[] StreetSuffix_type_info = new String[]{'StreetSuffix','http://webservices.seisint.com/WsAnalytics',null,'0','1','false'};
        private String[] StreetPostDirection_type_info = new String[]{'StreetPostDirection','http://webservices.seisint.com/WsAnalytics',null,'0','1','false'};
        private String[] UnitDesignation_type_info = new String[]{'UnitDesignation','http://webservices.seisint.com/WsAnalytics',null,'0','1','false'};
        private String[] UnitNumber_type_info = new String[]{'UnitNumber','http://webservices.seisint.com/WsAnalytics',null,'0','1','false'};
        private String[] StreetAddress1_type_info = new String[]{'StreetAddress1','http://webservices.seisint.com/WsAnalytics',null,'0','1','false'};
        private String[] StreetAddress2_type_info = new String[]{'StreetAddress2','http://webservices.seisint.com/WsAnalytics',null,'0','1','false'};
        private String[] City_type_info = new String[]{'City','http://webservices.seisint.com/WsAnalytics',null,'0','1','false'};
        private String[] State_type_info = new String[]{'State','http://webservices.seisint.com/WsAnalytics',null,'0','1','false'};
        private String[] Zip5_type_info = new String[]{'Zip5','http://webservices.seisint.com/WsAnalytics',null,'0','1','false'};
        private String[] Zip4_type_info = new String[]{'Zip4','http://webservices.seisint.com/WsAnalytics',null,'0','1','false'};
        private String[] County_type_info = new String[]{'County','http://webservices.seisint.com/WsAnalytics',null,'0','1','false'};
        private String[] PostalCode_type_info = new String[]{'PostalCode','http://webservices.seisint.com/WsAnalytics',null,'0','1','false'};
        private String[] StateCityZip_type_info = new String[]{'StateCityZip','http://webservices.seisint.com/WsAnalytics',null,'0','1','false'};
        private String[] Latitude_type_info = new String[]{'Latitude','http://webservices.seisint.com/WsAnalytics',null,'0','1','false'};
        private String[] Longitude_type_info = new String[]{'Longitude','http://webservices.seisint.com/WsAnalytics',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://webservices.seisint.com/WsAnalytics','true','false'};
        private String[] field_order_type_info = new String[]{'StreetNumber','StreetPreDirection','StreetName','StreetSuffix','StreetPostDirection','UnitDesignation','UnitNumber','StreetAddress1','StreetAddress2','City','State','Zip5','Zip4','County','PostalCode','StateCityZip','Latitude','Longitude'};
    }
    public class SBACompany {
        public String CompanyName;
        public String AlternateCompanyName;
        public CreditWSUtil_LexisNexisSBA.BusinessIdentity BusinessIds;
        public CreditWSUtil_LexisNexisSBA.Address Address;
        public String Phone;
        public String FaxNumber;
        public String FEIN;
        public String SICCode;
        public String NAICCode;
        public String BusinessStructure;
        public String YearsInBusiness;
        public CreditWSUtil_LexisNexisSBA.Date_x BusinessStartDate;
        public String YearlyRevenue;
        private String[] CompanyName_type_info = new String[]{'CompanyName','http://webservices.seisint.com/WsAnalytics',null,'0','1','false'};
        private String[] AlternateCompanyName_type_info = new String[]{'AlternateCompanyName','http://webservices.seisint.com/WsAnalytics',null,'0','1','false'};
        private String[] BusinessIds_type_info = new String[]{'BusinessIds','http://webservices.seisint.com/WsAnalytics',null,'0','1','false'};
        private String[] Address_type_info = new String[]{'Address','http://webservices.seisint.com/WsAnalytics',null,'0','1','false'};
        private String[] Phone_type_info = new String[]{'Phone','http://webservices.seisint.com/WsAnalytics',null,'0','1','false'};
        private String[] FaxNumber_type_info = new String[]{'FaxNumber','http://webservices.seisint.com/WsAnalytics',null,'0','1','false'};
        private String[] FEIN_type_info = new String[]{'FEIN','http://webservices.seisint.com/WsAnalytics',null,'0','1','false'};
        private String[] SICCode_type_info = new String[]{'SICCode','http://webservices.seisint.com/WsAnalytics',null,'0','1','false'};
        private String[] NAICCode_type_info = new String[]{'NAICCode','http://webservices.seisint.com/WsAnalytics',null,'0','1','false'};
        private String[] BusinessStructure_type_info = new String[]{'BusinessStructure','http://webservices.seisint.com/WsAnalytics',null,'0','1','false'};
        private String[] YearsInBusiness_type_info = new String[]{'YearsInBusiness','http://webservices.seisint.com/WsAnalytics',null,'0','1','false'};
        private String[] BusinessStartDate_type_info = new String[]{'BusinessStartDate','http://webservices.seisint.com/WsAnalytics',null,'0','1','false'};
        private String[] YearlyRevenue_type_info = new String[]{'YearlyRevenue','http://webservices.seisint.com/WsAnalytics',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://webservices.seisint.com/WsAnalytics','true','false'};
        private String[] field_order_type_info = new String[]{'CompanyName','AlternateCompanyName','BusinessIds','Address','Phone','FaxNumber','FEIN','SICCode','NAICCode','BusinessStructure','YearsInBusiness','BusinessStartDate','YearlyRevenue'};
    }
    public class WsException extends Exception {
        public String Source;
        public Integer Code;
        public String Location;
        public String Message;
        private String[] Source_type_info = new String[]{'Source','http://webservices.seisint.com/WsAnalytics',null,'0','1','false'};
        private String[] Code_type_info = new String[]{'Code','http://webservices.seisint.com/WsAnalytics',null,'0','1','false'};
        private String[] Location_type_info = new String[]{'Location','http://webservices.seisint.com/WsAnalytics',null,'0','1','false'};
        private String[] Message_type_info = new String[]{'Message','http://webservices.seisint.com/WsAnalytics',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://webservices.seisint.com/WsAnalytics','true','false'};
        private String[] field_order_type_info = new String[]{'Source','Code','Location','Message'};
    }
    public class EspException extends Exception {
        public String Code;
        public String Audience;
        public String Source;
        public String Message;
        private String[] Code_type_info = new String[]{'Code','http://webservices.seisint.com/WsAnalytics',null,'0','1','false'};
        private String[] Audience_type_info = new String[]{'Audience','http://webservices.seisint.com/WsAnalytics',null,'0','1','false'};
        private String[] Source_type_info = new String[]{'Source','http://webservices.seisint.com/WsAnalytics',null,'0','1','false'};
        private String[] Message_type_info = new String[]{'Message','http://webservices.seisint.com/WsAnalytics',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://webservices.seisint.com/WsAnalytics','true','false'};
        private String[] field_order_type_info = new String[]{'Code','Audience','Source','Message'};
    }
    public class SmallBusinessAnalyticsRequestType {
        public CreditWSUtil_LexisNexisSBA.User_x User_x;
        public CreditWSUtil_LexisNexisSBA.SBAOptions Options;
        public CreditWSUtil_LexisNexisSBA.SBASearchBy SearchBy;
        private String[] User_x_type_info = new String[]{'User','http://webservices.seisint.com/WsAnalytics',null,'0','1','false'};
        private String[] Options_type_info = new String[]{'Options','http://webservices.seisint.com/WsAnalytics',null,'0','1','false'};
        private String[] SearchBy_type_info = new String[]{'SearchBy','http://webservices.seisint.com/WsAnalytics',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://webservices.seisint.com/WsAnalytics','true','false'};
        private String[] field_order_type_info = new String[]{'User_x','Options','SearchBy'};
    }
    public class SBAAttributesGroup {
        public String Name;
        public CreditWSUtil_LexisNexisSBA.Attributes_element Attributes;
        private String[] Name_type_info = new String[]{'Name','http://webservices.seisint.com/WsAnalytics',null,'0','1','false'};
        private String[] Attributes_type_info = new String[]{'Attributes','http://webservices.seisint.com/WsAnalytics',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://webservices.seisint.com/WsAnalytics','true','false'};
        private String[] field_order_type_info = new String[]{'Name','Attributes'};
    }
    public class Name {
        public String Full;
        public String First;
        public String Middle;
        public String Last;
        public String Suffix;
        public String Prefix;
        private String[] Full_type_info = new String[]{'Full','http://webservices.seisint.com/WsAnalytics',null,'0','1','false'};
        private String[] First_type_info = new String[]{'First','http://webservices.seisint.com/WsAnalytics',null,'0','1','false'};
        private String[] Middle_type_info = new String[]{'Middle','http://webservices.seisint.com/WsAnalytics',null,'0','1','false'};
        private String[] Last_type_info = new String[]{'Last','http://webservices.seisint.com/WsAnalytics',null,'0','1','false'};
        private String[] Suffix_type_info = new String[]{'Suffix','http://webservices.seisint.com/WsAnalytics',null,'0','1','false'};
        private String[] Prefix_type_info = new String[]{'Prefix','http://webservices.seisint.com/WsAnalytics',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://webservices.seisint.com/WsAnalytics','true','false'};
        private String[] field_order_type_info = new String[]{'Full','First','Middle','Last','Suffix','Prefix'};
    }
    public class SmallBusinessAnalyticsResponseExType {
        public CreditWSUtil_LexisNexisSBA.SmallBusinessAnalyticsResponse response;
        private String[] response_type_info = new String[]{'response','http://webservices.seisint.com/WsAnalytics',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://webservices.seisint.com/WsAnalytics','true','false'};
        private String[] field_order_type_info = new String[]{'response'};
    }
    public class EndUserInfo {
        public String CompanyName;
        public String StreetAddress1;
        public String City;
        public String State;
        public String Zip5;
        public String Phone;
        private String[] CompanyName_type_info = new String[]{'CompanyName','http://webservices.seisint.com/WsAnalytics',null,'0','1','false'};
        private String[] StreetAddress1_type_info = new String[]{'StreetAddress1','http://webservices.seisint.com/WsAnalytics',null,'0','1','false'};
        private String[] City_type_info = new String[]{'City','http://webservices.seisint.com/WsAnalytics',null,'0','1','false'};
        private String[] State_type_info = new String[]{'State','http://webservices.seisint.com/WsAnalytics',null,'0','1','false'};
        private String[] Zip5_type_info = new String[]{'Zip5','http://webservices.seisint.com/WsAnalytics',null,'0','1','false'};
        private String[] Phone_type_info = new String[]{'Phone','http://webservices.seisint.com/WsAnalytics',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://webservices.seisint.com/WsAnalytics','true','false'};
        private String[] field_order_type_info = new String[]{'CompanyName','StreetAddress1','City','State','Zip5','Phone'};
    }
    public class SBASearchBy {
        public CreditWSUtil_LexisNexisSBA.SBACompany Company;
        public CreditWSUtil_LexisNexisSBA.SBAAuthRep AuthorizedRep1;
        public CreditWSUtil_LexisNexisSBA.SBAAuthRep AuthorizedRep2;
        public CreditWSUtil_LexisNexisSBA.SBAAuthRep AuthorizedRep3;
        private String[] Company_type_info = new String[]{'Company','http://webservices.seisint.com/WsAnalytics',null,'0','1','false'};
        private String[] AuthorizedRep1_type_info = new String[]{'AuthorizedRep1','http://webservices.seisint.com/WsAnalytics',null,'0','1','false'};
        private String[] AuthorizedRep2_type_info = new String[]{'AuthorizedRep2','http://webservices.seisint.com/WsAnalytics',null,'0','1','false'};
        private String[] AuthorizedRep3_type_info = new String[]{'AuthorizedRep3','http://webservices.seisint.com/WsAnalytics',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://webservices.seisint.com/WsAnalytics','true','false'};
        private String[] field_order_type_info = new String[]{'Company','AuthorizedRep1','AuthorizedRep2','AuthorizedRep3'};
    }
    public class Models_element {
        public CreditWSUtil_LexisNexisSBA.SBAModelHRI[] Model;
        private String[] Model_type_info = new String[]{'Model','http://webservices.seisint.com/WsAnalytics',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'http://webservices.seisint.com/WsAnalytics','true','false'};
        private String[] field_order_type_info = new String[]{'Model'};
    }
    public class AttributesVersionRequest_element {
        public String[] Name;
        private String[] Name_type_info = new String[]{'Name','http://webservices.seisint.com/WsAnalytics',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'http://webservices.seisint.com/WsAnalytics','true','false'};
        private String[] field_order_type_info = new String[]{'Name'};
    }
    public class Attributes_element {
        public CreditWSUtil_LexisNexisSBA.NameValuePair[] Attribute;
        private String[] Attribute_type_info = new String[]{'Attribute','http://webservices.seisint.com/WsAnalytics',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'http://webservices.seisint.com/WsAnalytics','true','false'};
        private String[] field_order_type_info = new String[]{'Attribute'};
    }
    public class SmallBusinessAnalyticsResponse {
        public CreditWSUtil_LexisNexisSBA.ResponseHeader Header;
        public CreditWSUtil_LexisNexisSBA.SmallBusinessAnalyticsResult Result;
        private String[] Header_type_info = new String[]{'Header','http://webservices.seisint.com/WsAnalytics',null,'0','1','false'};
        private String[] Result_type_info = new String[]{'Result','http://webservices.seisint.com/WsAnalytics',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://webservices.seisint.com/WsAnalytics','true','false'};
        private String[] field_order_type_info = new String[]{'Header','Result'};
    }
    public class NameValuePair {
        public String Name;
        public String Value;
        private String[] Name_type_info = new String[]{'Name','http://webservices.seisint.com/WsAnalytics',null,'0','1','false'};
        private String[] Value_type_info = new String[]{'Value','http://webservices.seisint.com/WsAnalytics',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://webservices.seisint.com/WsAnalytics','true','false'};
        private String[] field_order_type_info = new String[]{'Name','Value'};
    }
    public class Scores_element {
        public CreditWSUtil_LexisNexisSBA.SBAScoreHRI[] Score;
        private String[] Score_type_info = new String[]{'Score','http://webservices.seisint.com/WsAnalytics',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'http://webservices.seisint.com/WsAnalytics','true','false'};
        private String[] field_order_type_info = new String[]{'Score'};
    }
    public class Names_element {
        public String[] Name;
        private String[] Name_type_info = new String[]{'Name','http://webservices.seisint.com/WsAnalytics',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'http://webservices.seisint.com/WsAnalytics','true','false'};
        private String[] field_order_type_info = new String[]{'Name'};
    }
    public class ResponseHeader {
        public Integer Status;
        public String Message;
        public String QueryId;
        public String TransactionId;
        public CreditWSUtil_LexisNexisSBA.Exceptions_element Exceptions;
        private String[] Status_type_info = new String[]{'Status','http://webservices.seisint.com/WsAnalytics',null,'0','1','false'};
        private String[] Message_type_info = new String[]{'Message','http://webservices.seisint.com/WsAnalytics',null,'0','1','false'};
        private String[] QueryId_type_info = new String[]{'QueryId','http://webservices.seisint.com/WsAnalytics',null,'0','1','false'};
        private String[] TransactionId_type_info = new String[]{'TransactionId','http://webservices.seisint.com/WsAnalytics',null,'0','1','false'};
        private String[] Exceptions_type_info = new String[]{'Exceptions','http://webservices.seisint.com/WsAnalytics',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://webservices.seisint.com/WsAnalytics','true','false'};
        private String[] field_order_type_info = new String[]{'Status','Message','QueryId','TransactionId','Exceptions'};
    }
    public class SmallBusinessAnalyticsResponseEx_element {
        public CreditWSUtil_LexisNexisSBA.SmallBusinessAnalyticsResponse response;
        private String[] response_type_info = new String[]{'response','http://webservices.seisint.com/WsAnalytics',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://webservices.seisint.com/WsAnalytics','true','false'};
        private String[] field_order_type_info = new String[]{'response'};
    }
    public class ModelOptions_element {
        public CreditWSUtil_LexisNexisSBA.SBAModelOption[] ModelOption;
        private String[] ModelOption_type_info = new String[]{'ModelOption','http://webservices.seisint.com/WsAnalytics',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'http://webservices.seisint.com/WsAnalytics','true','false'};
        private String[] field_order_type_info = new String[]{'ModelOption'};
    }
    public class ScoreReasons_element {
        public CreditWSUtil_LexisNexisSBA.SBARiskIndicator[] ScoreReason;
        private String[] ScoreReason_type_info = new String[]{'ScoreReason','http://webservices.seisint.com/WsAnalytics',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'http://webservices.seisint.com/WsAnalytics','true','false'};
        private String[] field_order_type_info = new String[]{'ScoreReason'};
    }
    public class SBAAuthRep {
        public CreditWSUtil_LexisNexisSBA.Name Name;
        public String FormerLastName;
        public String UniqueId;
        public CreditWSUtil_LexisNexisSBA.Address Address;
        public CreditWSUtil_LexisNexisSBA.Date_x DOB;
        public String Age;
        public String SSN;
        public String Phone;
        public String DriverLicenseNumber;
        public String DriverLicenseState;
        public String BusinessTitle;
        private String[] Name_type_info = new String[]{'Name','http://webservices.seisint.com/WsAnalytics',null,'0','1','false'};
        private String[] FormerLastName_type_info = new String[]{'FormerLastName','http://webservices.seisint.com/WsAnalytics',null,'0','1','false'};
        private String[] UniqueId_type_info = new String[]{'UniqueId','http://webservices.seisint.com/WsAnalytics',null,'0','1','false'};
        private String[] Address_type_info = new String[]{'Address','http://webservices.seisint.com/WsAnalytics',null,'0','1','false'};
        private String[] DOB_type_info = new String[]{'DOB','http://webservices.seisint.com/WsAnalytics',null,'0','1','false'};
        private String[] Age_type_info = new String[]{'Age','http://webservices.seisint.com/WsAnalytics',null,'0','1','false'};
        private String[] SSN_type_info = new String[]{'SSN','http://webservices.seisint.com/WsAnalytics',null,'0','1','false'};
        private String[] Phone_type_info = new String[]{'Phone','http://webservices.seisint.com/WsAnalytics',null,'0','1','false'};
        private String[] DriverLicenseNumber_type_info = new String[]{'DriverLicenseNumber','http://webservices.seisint.com/WsAnalytics',null,'0','1','false'};
        private String[] DriverLicenseState_type_info = new String[]{'DriverLicenseState','http://webservices.seisint.com/WsAnalytics',null,'0','1','false'};
        private String[] BusinessTitle_type_info = new String[]{'BusinessTitle','http://webservices.seisint.com/WsAnalytics',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://webservices.seisint.com/WsAnalytics','true','false'};
        private String[] field_order_type_info = new String[]{'Name','FormerLastName','UniqueId','Address','DOB','Age','SSN','Phone','DriverLicenseNumber','DriverLicenseState','BusinessTitle'};
    }
    public class BusinessIdentity {
        public Long DotID;
        public Long EmpID;
        public Long POWID;
        public Long ProxID;
        public Long SeleID;
        public Long OrgID;
        public Long UltID;
        private String[] DotID_type_info = new String[]{'DotID','http://webservices.seisint.com/WsAnalytics',null,'0','1','false'};
        private String[] EmpID_type_info = new String[]{'EmpID','http://webservices.seisint.com/WsAnalytics',null,'0','1','false'};
        private String[] POWID_type_info = new String[]{'POWID','http://webservices.seisint.com/WsAnalytics',null,'0','1','false'};
        private String[] ProxID_type_info = new String[]{'ProxID','http://webservices.seisint.com/WsAnalytics',null,'0','1','false'};
        private String[] SeleID_type_info = new String[]{'SeleID','http://webservices.seisint.com/WsAnalytics',null,'0','1','false'};
        private String[] OrgID_type_info = new String[]{'OrgID','http://webservices.seisint.com/WsAnalytics',null,'0','1','false'};
        private String[] UltID_type_info = new String[]{'UltID','http://webservices.seisint.com/WsAnalytics',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://webservices.seisint.com/WsAnalytics','true','false'};
        private String[] field_order_type_info = new String[]{'DotID','EmpID','POWID','ProxID','SeleID','OrgID','UltID'};
    }
    public class Date_x {
        public Integer Year;
        public Integer Month;
        public Integer Day;
        private String[] Year_type_info = new String[]{'Year','http://webservices.seisint.com/WsAnalytics',null,'0','1','false'};
        private String[] Month_type_info = new String[]{'Month','http://webservices.seisint.com/WsAnalytics',null,'0','1','false'};
        private String[] Day_type_info = new String[]{'Day','http://webservices.seisint.com/WsAnalytics',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://webservices.seisint.com/WsAnalytics','true','false'};
        private String[] field_order_type_info = new String[]{'Year','Month','Day'};
    }
    public class SBAOptions {
        public CreditWSUtil_LexisNexisSBA.AttributesVersionRequest_element AttributesVersionRequest;
        public CreditWSUtil_LexisNexisSBA.SBAModels IncludeModels;
        private String[] AttributesVersionRequest_type_info = new String[]{'AttributesVersionRequest','http://webservices.seisint.com/WsAnalytics',null,'0','1','false'};
        private String[] IncludeModels_type_info = new String[]{'IncludeModels','http://webservices.seisint.com/WsAnalytics',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://webservices.seisint.com/WsAnalytics','true','false'};
        private String[] field_order_type_info = new String[]{'AttributesVersionRequest','IncludeModels'};
    }
    public class Exceptions_element {
        public CreditWSUtil_LexisNexisSBA.WsException[] Item;
        private String[] Item_type_info = new String[]{'Item','http://webservices.seisint.com/WsAnalytics',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'http://webservices.seisint.com/WsAnalytics','true','false'};
        private String[] field_order_type_info = new String[]{'Item'};
    }
    public class SBAModels {
        public CreditWSUtil_LexisNexisSBA.Names_element Names;
        public CreditWSUtil_LexisNexisSBA.ModelOptions_element ModelOptions;
        private String[] Names_type_info = new String[]{'Names','http://webservices.seisint.com/WsAnalytics',null,'0','1','false'};
        private String[] ModelOptions_type_info = new String[]{'ModelOptions','http://webservices.seisint.com/WsAnalytics',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://webservices.seisint.com/WsAnalytics','true','false'};
        private String[] field_order_type_info = new String[]{'Names','ModelOptions'};
    }
    public class SmallBusinessAnalyticsResult {
        public CreditWSUtil_LexisNexisSBA.SBASearchBy InputEcho;
        public CreditWSUtil_LexisNexisSBA.Models_element Models;
        public CreditWSUtil_LexisNexisSBA.AttributeGroups_element AttributeGroups;
        private String[] InputEcho_type_info = new String[]{'InputEcho','http://webservices.seisint.com/WsAnalytics',null,'0','1','false'};
        private String[] Models_type_info = new String[]{'Models','http://webservices.seisint.com/WsAnalytics',null,'0','1','false'};
        private String[] AttributeGroups_type_info = new String[]{'AttributeGroups','http://webservices.seisint.com/WsAnalytics',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://webservices.seisint.com/WsAnalytics','true','false'};
        private String[] field_order_type_info = new String[]{'InputEcho','Models','AttributeGroups'};
    }
    public class AttributeGroups_element {
        public CreditWSUtil_LexisNexisSBA.SBAAttributesGroup[] AttributesGroup;
        private String[] AttributesGroup_type_info = new String[]{'AttributesGroup','http://webservices.seisint.com/WsAnalytics',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'http://webservices.seisint.com/WsAnalytics','true','false'};
        private String[] field_order_type_info = new String[]{'AttributesGroup'};
    }
    public class SBARiskIndicator {
        public Integer Sequence;
        public String ReasonCode;
        public String Description;
        private String[] Sequence_type_info = new String[]{'Sequence','http://webservices.seisint.com/WsAnalytics',null,'0','1','false'};
        private String[] ReasonCode_type_info = new String[]{'ReasonCode','http://webservices.seisint.com/WsAnalytics',null,'0','1','false'};
        private String[] Description_type_info = new String[]{'Description','http://webservices.seisint.com/WsAnalytics',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://webservices.seisint.com/WsAnalytics','true','false'};
        private String[] field_order_type_info = new String[]{'Sequence','ReasonCode','Description'};
    }
    public class WsAnalyticsServiceSoap {
        public String endpoint_x = 'https://wsonline.seisint.com/WsAnalytics?ver_=2.20';
        public Map<String,String> inputHttpHeaders_x;
        public Map<String,String> outputHttpHeaders_x;
        public String clientCertName_x;
        public String clientCert_x;
        public String clientCertPasswd_x;
        public Integer timeout_x;
        private String[] ns_map_type_info = new String[]{'http://webservices.seisint.com/WsAnalytics', 'webservicesSeisintComWsanalytics'};
        public CreditWSUtil_LexisNexisSBA.SmallBusinessAnalyticsResponse SmallBusinessAnalytics(CreditWSUtil_LexisNexisSBA.User_x User_x, CreditWSUtil_LexisNexisSBA.SBAOptions Options, CreditWSUtil_LexisNexisSBA.SBASearchBy SearchBy) {
            CreditWSUtil_LexisNexisSBA.SmallBusinessAnalyticsRequest_element request_x = new CreditWSUtil_LexisNexisSBA.SmallBusinessAnalyticsRequest_element();
            request_x.User_x = User_x;
            request_x.Options = Options;
            request_x.SearchBy = SearchBy;
            CreditWSUtil_LexisNexisSBA.SmallBusinessAnalyticsResponseEx_element response_x;
            Map<String, CreditWSUtil_LexisNexisSBA.SmallBusinessAnalyticsResponseEx_element> response_map_x = new Map<String, CreditWSUtil_LexisNexisSBA.SmallBusinessAnalyticsResponseEx_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
                    this,
                    request_x,
                    response_map_x,
                    new String[]{endpoint_x,
                            'WsAnalytics/SmallBusinessAnalytics?ver_=2.20',
                            'http://webservices.seisint.com/WsAnalytics',
                            'SmallBusinessAnalyticsRequest',
                            'http://webservices.seisint.com/WsAnalytics',
                            'SmallBusinessAnalyticsResponseEx',
                            'CreditWSUtil_LexisNexisSBA.SmallBusinessAnalyticsResponseEx_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.response;
        }
    }
}
