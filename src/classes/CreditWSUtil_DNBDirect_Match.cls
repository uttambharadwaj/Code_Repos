public class CreditWSUtil_DNBDirect_Match {

    public class TradeStyleNames {
        public String name;
        public Integer priority;
    }

    public class PrimaryAddress {
        public AddressCountry addressCountry;
        public AddressLocality addressLocality;
        public AddressRegion addressRegion;
        public String postalCode;
        public String postalCodeExtension;
        public StreetAddress streetAddress;
    }

    public class Organization {
        public String duns;
        public String subjectID;
        public List<WebsiteAddress> websiteAddress;
        public DunsControlStatus dunsControlStatus;
        public String primaryName;
        public List<WebsiteAddress> tradeStyleNames;
        public Telephone telephone;
        public PrimaryAddress primaryAddress;
        public MailingAddress mailingAddress;
        public List<WebsiteAddress> registrationNumbers;
        public List<MostSeniorPrincipals> mostSeniorPrincipals;
        public Boolean isStandalone;
    }

    public TransactionDetail transactionDetail;
    public InquiryDetail inquiryDetail;
    public Error error;
    public Integer candidatesMatchedQuantity;
    public String matchDataCriteria;
    public List<MatchCandidates> matchCandidates;
    public WebsiteAddress cleanseAndStandardizeInformation;

    public class Address {
        public String countryISOAlpha2Code;
        public String addressLocality;
        public String addressRegion;
        public String postalCode;
        public StreetAddressLine streetAddressLine;
    }

    public class Telephone {
        public String telephoneNumber;
        public Boolean isUnreachable;
    }

    public class StreetAddressLine {
        public String line1;
    }

    public class AddressCountry {
        public String isoAlpha2Code;
        public String name;
    }

    public class MatchQualityInformation {
        public Integer confidenceCode;
        public String matchGrade;
        public Integer matchGradeComponentsCount;
        public List<MatchGradeComponents> matchGradeComponents;
        public String matchDataProfile;
        public Integer matchDataProfileComponentsCount;
        public List<MatchDataProfileComponents> matchDataProfileComponents;
        public Double nameMatchScore;
    }

    public class OperatingStatus {
        public String description;
        public Integer dnbCode;
    }

    public class TransactionDetail {
        public String transactionID;
        public String transactionTimestamp;
        public String inLanguage;
        public String serviceVersion;
    }

    public class AddressRegion {
        public String name;
        public String abbreviatedName;
    }

    public class MatchDataProfileComponents {
        public String componentType;
        public String componentValue;
    }

    public class MatchCandidates {
        public Integer displaySequence;
        public Organization organization;
        public MatchQualityInformation matchQualityInformation;
    }

    public class DunsControlStatus {
        public OperatingStatus operatingStatus;
        public Boolean isMailUndeliverable;
    }

    public class AddressLocality {
        public String name;
    }

    public class MailingAddress {
        public AddressCountry addressCountry;
        public WebsiteAddress addressLocality;
        public WebsiteAddress addressRegion;
        public String postalCode;
        public String postalCodeExtension;
        public WebsiteAddress streetAddress;
    }

    public class MostSeniorPrincipals {
        public String fullName;
    }

    public class WebsiteAddress {
    }

    public class StreetAddress {
        public String line1;
        public String line2;
    }

    public class InquiryDetail {
        public String name;
        public Address address;
    }

    public class Error {
        public String errorCode;
        public String errorMessage;
    }

    public class MatchGradeComponents {
        public String componentType;
        public String componentRating;
    }


    public static CreditWSUtil_DNBDirect_Match parse(String json) {
        return (CreditWSUtil_DNBDirect_Match) System.JSON.deserialize(json, CreditWSUtil_DNBDirect_Match.class);
    }
}