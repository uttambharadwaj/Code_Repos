/**
 * Created by lhowland on 7/23/2020.
 */

public with sharing class CreditWS_CLEditEntityResponse {

  public class IsBvdOsirisEntity {
        public Boolean success;
        public Data_Z data;
        public String ruleName;
    }

    public List<PayLoad> payLoad;
    public DisableCreate status;

    public class IndustryCode {
        public String Code;
        public String Description;
        public List<String> Keys;
    }

    public class DisableCreate {
    }

    public class EntityContactCreateAndEdit {
        public String Name;
        public String Salutation;
        public String Email;
        public String MobileNo;
        public String OfficeNo;
        public String FaxNo;
        public Integer EntityId;
        public Integer Id;
        public String SystemId;
        public String ExternalDataSource;
//        public String t_;
//        public Boolean IsValid_;
//        public Boolean IsDeleted_;
//        public Integer Access_;
//        public Integer BaseVersionId_;
//        public Integer VersionId_;
//        public List<DisableCreate> Inapplicable_;
    }

    public class Data {
        public String IsBvdEntity;
    }

    public class PayLoad {
        public DisableCreate disableCreate;
        public String EntityType;
        public Integer EntityId;
        public String SystemId;
        public String LongName;
        public String ShortName;
        public String WexCreditInformationOn;
        public String TaxId;
        public String LegalEntity;
        public String WexAccountNumber;
        public String WexDunsNumber;
        public String CustomerSince;
        public String CountryOfInc;
        public String ProvinceStateOfIncorporation;
        public String RegistrationNumber;
        public String WexYearEst;
        public String WexYearIncorporated;
        public String OnList;
        public String LockedDate;
        public String WexYearEstablished;
        public String LockedBy;
        public String WexYearControl;
        public String Descriptions;
        public Object Gc23;
        public Object Gc22;
        public Object ExternalDataSources;
        public String EstablishmentDate;
        public String BusinessPortfolio;
        public String Division;
        public String CreditPortfolio;
        public String WexBusinessUnit;
        public String WexProgram;
        public String WexProgramString;
        public String WexAccountType;
        public String WexRelationshipManager;
        public String PrimaryBankingOfficer;
        public String WexCreditAnalyst;
        public String PrimaryCreditOfficer;
        public Rules Rules;
//        public String t_;
//        public Boolean IsValid_;
//        public Boolean IsDeleted_;
//        public Integer Access_;
//        public Integer BaseVersionId_;
//        public Integer VersionId_;
//        public List<DisableCreate> Inapplicable_;
//        public List<String> Associations_;
        public String FirmType;
        public String WexOwnershipType;
        public String CountryOfRisk;
        public String Currency_x;
        public String ListingDate;
        public String CountryOfListing;
        public String StockExchange;
        public String StockCode;
        public String IndClassification;
        public String LastReviewDate;
        public String WexReviewDate;
        public String WexRequestCurrency;
        public String WexReviewType;
        public Double WexExistingCreditLineAmt;
        public Double WexRequestCreditLineAmount;
        public String WexPrimaryRiskGrade;
        public String WexPrimaryRiskGradeSource;
        public String WexSecondaryRiskGrade;
        public String WexSecondaryRiskGradeSource;
        public Double WexCreditExtended;
        public Integer WexNumberOfCreditExperiences;
        public Double WexOriginationModelRecommendat;
        public Integer WexPaydexScore;
        public Double WexProjectedMonthlySpend;
        public Double WexHighCycleSpend;
        public String WexPaymentType;
        public String WexPaymentHistory;
        public String BillingCycle;
        public String DaysToPay;
        public Object WexBillingCycle1;
        public Object WexDaysToPay1;
        public Object WexBillingCycle2;
        public Object WexDaysToPay2;
        public Object WexBillingCycle3;
        public Object WexDaysToPay3;
        public String CollateralSecurity;
        public Double WexCollateralAmt;
        public String CollateralSecuringEntity;
        public String WexExpirationSecurityDate;
        public String WexSecurityType1;
        public Double WexSecurityAmount1;
        public Object WexSecuringEntity1;
        public Object WexExpirationDateSecurity1;
        public String WexSecurityType2;
        public Double WexSecurityAmount2;
        public Object WexSecuringEntity2;
        public Object WexExpirationDateSecurity2;
        public String WexSecurityType3;
        public Double WexSecurityAmount3;
        public Object WexSecuringEntity3;
        public String WexExpirationDateSecurity3;
        public Double WexRecommendedCreditLine;
        public Double WexApprovedCreditLine;
        public String WexCreditLineCurrency;
        public String WexApprovedExceptions;
        public String WexEffectiveDateAppvdCl;
        public String WexComments;
        public String WexDateAdded;
        public String WexDateRemoved;
        public String NextReviewDate;
        public String WexFsAvlblDate;
        public String WexFinancialsRequestedDate;
        public String WexFinancialsRequestedDate2;
        public String WexFinancialsReceivedDate;
        public String WexCommentsMonitoring;
        public List<DisableCreate> RestrictedEntityUser;
        public List<DisableCreate> EntityOfficers;
        public List<EntityContactCreateAndEdit> EntityContactCreateAndEdit;
        public List<EntityAddress> EntityAddress;
        public List<DisableCreate> EntityGroupGrid;
        public List<IndustrySelection> IndustrySelection;
        public List<DisableCreate> DirectorAndCompanyOfficer;
        public List<DisableCreate> EntityHierarchy;
        public List<DisableCreate> EntityReOrgHistory;
        public List<DisableCreate> EntityDocumentLinkVm;
//        public String UpdatedBy_;
    }

    public class Rules {
        public ValidateOfficerTitleCSharp ValidateOfficerTitleCSharp;
        public ValidateOfficerTitleCSharp ValidateIndustryCodes;
        public ValidateOfficerTitleCSharp ValidateEntityHierarchyRatios;
        public ValidateOfficerTitleCSharp ValidateEntityReorgHistory;
        public ValidateOfficerTitleCSharp ValidateEntityCreditHierarchyRatios;
        public ValidateOfficerTitleCSharp ValidateEntityHierarchyUniqueness;
        public ValidateOfficerTitleCSharp ValidateCircularRelationship;
        public ValidateOfficerTitleCSharp ValidateRestrictedEntityUser;
        public ValidateOfficerTitleCSharp ValidateRestrictedUserModelAccess;
        public ValidateOfficerTitleCSharp RemoveBvdFromExternalDataSource;
        public ValidateOfficerTitleCSharp RemoveMarqFromExternalDataSource;
        public ValidateOfficerTitleCSharp ClearGlobalConstantCache;
        public IsBvdEntity IsBvdEntity;
        public IsBvdOsirisEntity IsBvdOsirisEntity;
        public IsMarqEntity IsMarqEntity;
    }

    public class IndustrySelection {
        public Integer IndustryId;
        public IndustryCode IndustryCode;
        public Double Percentage;
        public Boolean IsPrimary;
        public Integer EntityId;
        public String Classification;
        public String ExternalDataSource;
        public Boolean UpdatePeerSelection;
//        public String t_;
//        public Boolean IsValid_;
//        public Boolean IsDeleted_;
//        public Integer Access_;
//        public Integer BaseVersionId_;
//        public Integer VersionId_;
//        public List<DisableCreate> Inapplicable_;
    }

    public class Data_Y {
        public String IsMarqEntity;
    }

    public class IsMarqEntity {
        public Boolean success;
        public Data_Y data;
        public String ruleName;
    }

    public class Data_Z {
        public String IsBvdOsirisEntity;
    }

    public class ValidateOfficerTitleCSharp {
        public Boolean success;
        public DisableCreate data;
        public String ruleName;
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
//        public String t_;
//        public Boolean IsValid_;
//        public Boolean IsDeleted_;
//        public Integer Access_;
//        public Integer BaseVersionId_;
//        public Integer VersionId_;
//        public List<DisableCreate> Inapplicable_;
    }

    public class IsBvdEntity {
        public Boolean success;
        public Data data;
        public String ruleName;
    }


    public static CreditWS_CLEditEntityResponse parse(String json) {
        return (CreditWS_CLEditEntityResponse) System.JSON.deserialize(json, CreditWS_CLEditEntityResponse.class);
    }
}