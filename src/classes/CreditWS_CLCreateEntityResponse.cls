/**
 * Created by lhowland on 12/13/2019.
 */

public class CreditWS_CLCreateEntityResponse {

    public List<PayLoad> payLoad;
    public DisableCreate status;

    public class IndustryCode {
        public String Code;
        public String Description;
        public List<String> Keys;
    }

    public class EntityAddress {
        public Integer AddressId;
        public String AddressType;
        public String Address1;
        public String Address2;
        public String Country;
        public String State;
        public String City;
        public String Zip;
//        public Object ExternalDataSource;
        public String t_x;
//        public Boolean IsValid_;
//        public Boolean IsDeleted_;
//        public Integer Access_;
//        public Integer BaseVersionId_;
//        public Integer VersionId_;
        public List<DisableCreate> Inapplicable_x;
    }

    public class DisableCreate {
    }

    public class PayLoad {
        public DisableCreate disableCreate;
        public String EntityType;
        public String LongName;
        public String ShortName;
        public Integer EntityId;
        public String SystemId;
        public String LegalEntity;
        public String WexAccountNumber;
        public String TaxId;
        public String WexDunsNumber;
        public String CustomerSince;
        public String CountryOfInc;
        public String ProvinceStateOfIncorporation;
        public String WexYearIncorporated;
        public String EstablishmentDate;
        public String RegistrationNumber;
//        public Object OnList;
        public String WexYearEst;
        public String WexYearControl;
//        public Object Descriptions;
//        public Object Gc23;
//        public Object Gc22;
//        public Object ExternalDataSources;
//        public Object WexFsAvlblDate;
        public String WexYearEstablished;
        public String BusinessPortfolio;
        public String Division;
        public String CreditPortfolio;
        public String WexBusinessUnit;
        public String WexProgram;
        public String PrimaryBankingOfficer;
        public String PrimaryCreditOfficer;
        public String t_x;
//        public Boolean IsValid_;
//        public Boolean IsDeleted_;
//        public Integer Access_;
//        public Integer BaseVersionId_;
//        public Integer VersionId_;
//        public List<DisableCreate> Inapplicable_;
//        public List<String> Associations_;
        public String FirmType;
        public String CountryOfRisk;
        public String Currency_x;
//        public Object ListingDate;
        public String CountryOfListing;
        public String StockExchange;
        public String StockCode;
        public String IndClassification;
//        public Object WexLastReviewDate;
//        public Object WexReviewDate;
        public String WexReviewType;
        public String WexRequestCurrency;
        public String WexExistingCreditLineAmt;
        public String WexRequestCreditLineAmount;
        public String WexCreditInformationOn;
        public String WexPaymentHistory;
        public String WexProejctedMonthlySpend;
//        public Object WexHighCycleSpend;
//        public Object BillingCycle;
//        public Object DaysToPay;
//        public Object WexBillingCycle1;
//        public Object WexDaysToPay1;
//        public Object WexBillingCycle2;
//        public Object WexDaysToPay2;
//        public Object WexBillingCycle3;
//        public Object WexDaysToPay3;
//        public Object WexPaymentType;
        public String CollateralSecurity;
        public String CollateralSecuringEntity;
//        public Object WexCollateralAmt;
//        public Object WexPrimaryRiskGrade;
//        public Object WexPrimaryRiskGradeSource;
//        public Object WexSecondaryRiskGrade;
//        public Object WexSecondaryRiskGradeSource;
//        public Object WexCreditExtended;
//        public Object WexNumberOfCreditExperiences;
        public String WexPaydexScore;
        public String WexOriginationModelRecommendat;
//        public Object RequestedCreditLineDl;
//        public Object CollateralExpirationDate;
//        public Object CollateralAmt;
//        public Object ExisitingCreditLineDl;
        public String WexApprovedCreditLine;
        public String WexCreditLineCurrency;
//        public Object NextReviewDate;
        public String WexExpirationSecurityDate;
//        public Object WexFinancialsRequestedDate;
//        public Object WexFinancialsRequestedDate2;
//        public Object WexFinancialsReceivedDate;
        public List<DisableCreate> EntityOfficers;
        public List<DisableCreate> EntityContactCreateAndEdit;
        public List<EntityAddress> EntityAddress;
        public List<DisableCreate> EntityGroupGrid;
        public List<IndustrySelection> IndustrySelection;
        public List<DisableCreate> DirectorAndCompanyOfficer;
        public List<DisableCreate> EntityHierarchy;
        public List<DisableCreate> EntityReOrgHistory;
        public List<DisableCreate> EntityDocumentLinkVm;
//        public Object UpdatedBy_;
    }

    public class IndustrySelection {
        public Integer IndustryId;
        public IndustryCode IndustryCode;
        public Double Percentage;
        public Boolean IsPrimary;
        public Integer EntityId;
        public String Classification;
//        public Object ExternalDataSource;
        public String t_x;
//        public Boolean IsValid_;
//        public Boolean IsDeleted_;
//        public Integer Access_;
//        public Integer BaseVersionId_;
//        public Integer VersionId_;
//        public List<DisableCreate> Inapplicable_;
    }


    public static CreditWS_CLCreateEntityResponse parse(String json) {
        return (CreditWS_CLCreateEntityResponse) System.JSON.deserialize(json, CreditWS_CLCreateEntityResponse.class);
    }
}