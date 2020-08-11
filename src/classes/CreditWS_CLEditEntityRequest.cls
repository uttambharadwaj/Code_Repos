/**
 * Created by lhowland on 7/23/2020.
 */

public with sharing class CreditWS_CLEditEntityRequest {

    public class Context {
        public String wfId;         // default value: 00000000-0000-0000-0000-000000000000
        public String taskId;       // default value: 00000000-0000-0000-0000-000000000000
    }

    public Context context;
    public PayLoad payLoad;

    public class PayLoad {
        public String OperationType;
        public String EntityType;
        public String BillingCycle;
        public String Division;
        public String LongName;
        public String ShortName;
        public Integer EntityId;
        public String BusinessPortfolio;
        public String CreditPortfolio;
        public String FirmType;
        public String CountryOfRisk;
        public String CountryOfInc;
        public String CountryOfListing;
        public String Currency_x;
        public String StockCode;
        public String StockExchange;
        public Integer OnList;                        // 1, 3, 4, 5
        public String WexDateAdded;                   // maps to On List Date in SF
        public String WexBusinessUnit;
        public String WexCreditAnalyst;
        public String WexOriginationModelRecommendat;
        public String WexPrimaryRiskGrade;
        public String WexRecommendedCreditLine;
        public String WexRelationshipManager;
        public String WexRequestCreditLineAmount;
//        public Object UpdatedBy_;
    }


    public static CreditWS_CLEditEntityRequest parse(String json) {
        return (CreditWS_CLEditEntityRequest) System.JSON.deserialize(json, CreditWS_CLEditEntityRequest.class);
    }
}