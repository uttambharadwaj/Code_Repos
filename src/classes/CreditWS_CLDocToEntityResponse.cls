/**
 * Created by lhowland on 1/14/2020.
 */

public with sharing class CreditWS_CLDocToEntityResponse {

    public class LinkAutoSpreadDocumentToEntity {
        public Boolean success;
        public Data data;
        public String ruleName;
    }

    public class SpreadStatement {
        public String SpreadDocumentId;
        public String SpreadStatementId;
        public String StatementDate;
        public Integer StatementPeriod;
        public String StatementType;
        public Object StatementStatus;
        public Object HistoricalStatementId;
        public String t_x; //t_ in real response
//        public Boolean IsValid_;
//        public Boolean IsDeleted_;
//        public Integer BaseVersionId_;
//        public Integer VersionId_;
//        public List<DisableCreate> Inapplicable_;
    }

    public List<List<PayLoad>> payLoad;
    public DisableCreate status;

    public class DisableCreate {
    }

    public class Data {
        public Integer LinkId;
    }

    public class PayLoad {
        public DisableCreate disableCreate;
        public String StatementDate;
        public String SpreadStatementCount;
        public String SpreadDocumentId;
        public String DocumentStatus;
        public String FinancialTemplateId;
        public Object ExternalId;
        public Object ExternalActionDate;
        public Object ExternalSubmittedDate;
        public Integer EntityId;
        public String DocumentId;
        public String SpreadDocumentType;
        public Rules Rules;
        public String t_x;  //t_ in real response
//        public Boolean IsValid_;
//        public Boolean IsDeleted_;
//        public Integer BaseVersionId_;
//        public Integer VersionId_;
//        public List<DisableCreate> Inapplicable_;
//        public List<String> Associations_;
        public List<SpreadStatement> SpreadStatement;
        public Object UpdatedBy_x;  //UpdatedBy_ in real response
    }

    public class Rules {
        public LinkAutoSpreadDocumentToEntity LinkAutoSpreadDocumentToEntity;
    }


    public static CreditWS_CLDocToEntityResponse parse(String json) {
        return (CreditWS_CLDocToEntityResponse) System.JSON.deserialize(json, CreditWS_CLDocToEntityResponse.class);
    }

}