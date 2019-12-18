/**
 * Created by lhowland on 12/6/2019.
 */

public class CreditWS_CLCreateEntityRequest {

    // Request Definitions

    public String EntityType;                    // CORP, Partnership, SolePropietorship, OtherOrganization, IND, BANK, NONBANK
    public Decimal EntityId;
    public String LongName;                      // Legal Business Name
    public String ShortName;                     // Doing Business As
    public String SystemId;                      // Salesforce Application Name such as Application-123456
    public String WexBusinessUnit;               // OTR, NAFleet, CP = Travel or Payables
    public String Division;                      // Corporate, Fleet, Health
    public String BusinessPortfolio;
    public String CreditPortfolio;               // WexBank
    public String WexRelationshipManager;        // Sales person from the Opty
    public String WexCreditAnalyst;
    public String PrimaryCreditOfficer;          // Credit Analyst working the app
    public String CountryOfRisk;                 // USA, CAN, etc
    public String CountryOfInc;
    public String PlaceOfIncorporation;
    public String ProvinceStateOfIncorporation;  // 2 digit country code + 2 digit state code. ex: USME = Maine
    public String Currency_x;                    // USD (currency of risk)
    public String IndClassification;
    public String TaxId;
    public String WexControlYear;
    public String WexDunsNumber;
    public Integer WexNumberOfCreditExperiences; // DNB # of trade lines
    public Decimal WexCreditExtended;
    public String WexPaydexScore;
    public String DaysToPay;
    public String WexBillingCycle;               // Daily, Weekly, Bi-Weekly, Monthly, Multiple, Fortnightly
    public String WexPaymentType;                // ACH, Direct Debit, Bank Transfer
    public String WexAccountNumber;
    public String WexProgramString;
    public String LegalEntity;                   // National ID
    public String StockCode;                     // 3 digit code , ex: VTX
    public String StockExchange;                 // Key is passed in that maps to the Stock description
    public String CountryOfListing;              // Country related to the Stock
    public String FirmType;                      // PBV, PUB, GVT, NP, CO, SUBPublicForeign, SUBPrivate, SUBPublic, SUBPrivateForeignParent
    public String WexPrimaryRiskGrade;
    public String WexPrimaryRiskGradeSource;     //DNB, DNB Custom, RiskCalc, Moody's, The Street, SBRI, FICO, S&P, Fitch
    public String WexRequestCreditLineAmount;
    public String WexOriginationModelRecommendat;
    public String WexCreditInformationOn;
    public List<EntityOfficer> EntityOfficers;
    public List<EntityContactCreateAndEdit> EntityContactCreateAndEdit;
    public List<EntityAddress> EntityAddress;
    public List<IndustrySelection> IndustrySelection;

    public class IndustryCode {
        public String Code;
        public String Description;
        public List<String> Keys;
    }

    public class EntityContactCreateAndEdit {
        public Boolean x_new;                    // true
        public String OperationType;             // Create, Update, Delete
        public Boolean x_initialRulesExecuted;   // true
        public String Email;
        public List<String> ExternalDataSource;
        public String FaxNo;
        public Integer Id;
        public String MobileNo;
        public String Name;
        public String OfficeNo;
        public String Salutation;
        public String SystemId;
    }

    public class EntityAddress {
        public Boolean x_new;                    // true
        public String OperationType;             // Create, Update, Delete
        public Integer AddressId;                // The first address is called -1, the next is 2, then 3, etc
        public Boolean x_initialRulesExecuted;   // true
        public String AddressType;               // REGISTERED, MAILING, BILLING
        public String Address1;
        public String Address2;
        public String Country;
        public String State;
        public String City;
        public String Zip;
        public String t_x;                        // Address
    }

    public class EntityOfficer {
        public Boolean x_new;
        public String OperationType;
        public Integer OfficerId;
        public Boolean IsPrimary;
        public String Title;
        public String UserId;
    }

    public class IndustrySelection {
        public Boolean x_new;                    // true
        public Integer Percentage;               // 1 - honestly, no idea what this is for
        public String OperationType;             // Create, Update, Delete
        public Integer IndustryId;               // The first industry is called -1, the next is 2, then 3, etc
        public String Classification;
        public Boolean IsPrimary;
        public Boolean x_initialRulesExecuted;    // true
        public IndustryCode IndustryCode;
    }

    public static CreditWS_CLCreateEntityRequest parse(String json) {
        return (CreditWS_CLCreateEntityRequest) System.JSON.deserialize(json, CreditWS_CLCreateEntityRequest.class);
    }

}