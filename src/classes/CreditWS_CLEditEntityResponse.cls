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
        public Object Salutation;
        public String Email;
        public Object MobileNo;
        public String OfficeNo;
        public Object FaxNo;
        public Integer EntityId;
        public Integer Id;
        public Object SystemId;
        public Object ExternalDataSource;
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
        public Object LegalEntity;
        public Object WexAccountNumber;
        public String WexDunsNumber;
        public Object CustomerSince;
        public String CountryOfInc;
        public String ProvinceStateOfIncorporation;
        public Object RegistrationNumber;
        public Object WexYearEst;
        public Object WexYearIncorporated;
        public String OnList;
        public Object LockedDate;
        public Object WexYearEstablished;
        public Object LockedBy;
        public String WexYearControl;
        public Object Descriptions;
        public Object Gc23;
        public Object Gc22;
        public Object ExternalDataSources;
        public Object EstablishmentDate;
        public String BusinessPortfolio;
        public String Division;
        public String CreditPortfolio;
        public String WexBusinessUnit;
        public Object WexProgram;
        public Object WexProgramString;
        public Object WexAccountType;
        public String WexRelationshipManager;
        public Object PrimaryBankingOfficer;
        public String WexCreditAnalyst;
        public Object PrimaryCreditOfficer;
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
        public Object WexOwnershipType;
        public String CountryOfRisk;
        public String Currency_x;
        public Object ListingDate;
        public String CountryOfListing;
        public String StockExchange;
        public String StockCode;
        public String IndClassification;
        public Object LastReviewDate;
        public Object WexReviewDate;
        public Object WexRequestCurrency;
        public Object WexReviewType;
        public Object WexExistingCreditLineAmt;
        public Double WexRequestCreditLineAmount;
        public String WexPrimaryRiskGrade;
        public Object WexPrimaryRiskGradeSource;
        public Object WexSecondaryRiskGrade;
        public Object WexSecondaryRiskGradeSource;
        public Object WexCreditExtended;
        public Object WexNumberOfCreditExperiences;
        public Double WexOriginationModelRecommendat;
        public Object WexPaydexScore;
        public Object WexProjectedMonthlySpend;
        public Object WexHighCycleSpend;
        public Object WexPaymentType;
        public Object WexPaymentHistory;
        public String BillingCycle;
        public Object DaysToPay;
        public Object WexBillingCycle1;
        public Object WexDaysToPay1;
        public Object WexBillingCycle2;
        public Object WexDaysToPay2;
        public Object WexBillingCycle3;
        public Object WexDaysToPay3;
        public String CollateralSecurity;
        public Object WexCollateralAmt;
        public Object CollateralSecuringEntity;
        public Object WexExpirationSecurityDate;
        public Object WexSecurityType1;
        public Object WexSecurityAmount1;
        public Object WexSecuringEntity1;
        public Object WexExpirationDateSecurity1;
        public Object WexSecurityType2;
        public Object WexSecurityAmount2;
        public Object WexSecuringEntity2;
        public Object WexExpirationDateSecurity2;
        public Object WexSecurityType3;
        public Object WexSecurityAmount3;
        public Object WexSecuringEntity3;
        public Object WexExpirationDateSecurity3;
        public Double WexRecommendedCreditLine;
        public Object WexApprovedCreditLine;
        public Object WexCreditLineCurrency;
        public Object WexApprovedExceptions;
        public Object WexEffectiveDateAppvdCl;
        public Object WexComments;
        public String WexDateAdded;
        public Object WexDateRemoved;
        public Object NextReviewDate;
        public Object WexFsAvlblDate;
        public Object WexFinancialsRequestedDate;
        public Object WexFinancialsRequestedDate2;
        public Object WexFinancialsReceivedDate;
        public Object WexCommentsMonitoring;
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
//        public Object UpdatedBy_;
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
        public Object ExternalDataSource;
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
        public Object Address2;
        public String Country;
        public String State;
        public String City;
        public String Zip;
        public Object ExternalDataSource;
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