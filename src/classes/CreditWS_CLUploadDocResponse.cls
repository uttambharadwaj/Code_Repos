/**
 * Created by lhowland on 1/3/2020.
 */

public with sharing class CreditWS_CLUploadDocResponse {

    public class Status {
    }

    public List<PayLoad> payLoad;
    public Status Status;

    public class PayLoad {
        public String DocumentId;
//        public Integer VersionId_x;
//        public Integer BaseVersionId_x;
        public String OriginalFileName;
    }


    public static CreditWS_CLUploadDocResponse parse(String json) {
        return (CreditWS_CLUploadDocResponse) System.JSON.deserialize(json, CreditWS_CLUploadDocResponse.class);
    }
}