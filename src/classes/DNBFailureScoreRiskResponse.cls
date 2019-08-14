public class DNBFailureScoreRiskResponse {

    public OrderProductResponse OrderProductResponse;

    public class Organization {
        public Assessment Assessment;
    }

    public class Assessment {
        public List<FinancialStressScore> FinancialStressScore;
        public DNBCreditLimitRecommendation DNBCreditLimitRecommendation;
    }

    public class Product {
        public String DNBProductID;
        public Organization Organization;
    }

    public class OrderProductResponseDetail {
        public Product Product;
    }

    public class OrderProductResponse {
        public OrderProductResponseDetail OrderProductResponseDetail;
    }

    public class MaximumRecommendedLimitAmount {
        public String CurrencyISOAlpha3Code;
        public String UnitOfSize;
        public Integer Dollar;
    }

    public class DNBCreditLimitRecommendation {
        public MaximumRecommendedLimitAmount MaximumRecommendedLimitAmount;
    }

    public class FinancialStressScore {
        public Integer RawScore;
        public String ClassScore;
        public Integer NationalPercentile;
        public Double RiskIncidencePercentage;
    }

    public static DNBFailureScoreRiskResponse parse(String json) {
        return (DNBFailureScoreRiskResponse) System.JSON.deserialize(json, DNBFailureScoreRiskResponse.class);
    }
}