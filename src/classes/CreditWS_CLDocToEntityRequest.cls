/**
 * Created by lhowland on 1/14/2020.
 * After uploading a document to Credit Lens, you then must associate the given document ID to the Entity record in Credit Lens
 */

public with sharing class CreditWS_CLDocToEntityRequest {

    public class Context {
        public String wfId = '00000000-0000-0000-0000-000000000000';
        public String taskId = '00000000-0000-0000-0000-000000000000';
    }

    public class SpreadStatement {
        public Integer StatementPeriod;
        public String StatementType;
        public String StatementDate;
        public String OperationType;
    }

    public Context context;
    public PayLoad_Y payLoad;  //Payload in real request

    public class PayLoad_Y {  // Dear Moodys, why do you call EVERYTHING in your request Paylaod?
        public List<Multi> multi;
    }

    public class PayLoad_Z {       //Payload in real request
        public String DocumentId;
        public Object Description;
        public String Title;
        public String Category;
        public String OperationType;
    }

    public class Multi {
        public String viewModelId;
        public String behavior;
        public PayLoad payLoad;
    }

    public class PayLoad {
        public String SpreadDocumentId;
        public Integer EntityId;
        public String DocumentId;
        public String FinancialTemplateId;
        public String DocumentStatus;
        public String StatementDate;
        public String SpreadStatementCount;
        public String SpreadDocumentType;
        public Boolean FilterOutForUI;
        public List<SpreadStatement> SpreadStatement;
        public String OperationType;
        public Integer Status;
        public String t_x;  //t_ in real request
    }


    public static CreditWS_CLDocToEntityRequest parse(String json) {
        return (CreditWS_CLDocToEntityRequest) System.JSON.deserialize(json, CreditWS_CLDocToEntityRequest.class);
    }

}