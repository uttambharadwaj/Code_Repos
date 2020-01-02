/**
 * Created by lhowland on 12/5/2019.
 */

public class CreditWS_CLAuthResponse {

    public class User {
        public String UserId;
        public String UserName;
        public String TenantId;
        public Boolean IsSuperAdministrator;
        public Integer ConfigID;
        public List<UserAuthorization> UserAuthorization;
    }

    public PayLoad payLoad;
    public String status;

    public class UserAuthorization {
        public Integer Id;
        public List<String> BusinessPortfolio;
        public String CreditPortfolio;
        public String Role;
        public String UserId;
//        public List<Inapplicable_> Inapplicable_;
//        public String WFId_;
//        public String TaskId_;
//        public Integer VersionId_;
//        public Integer BaseVersionId_;
//        public Boolean IsLatestVersion_;
//        public Boolean IsDeleted_;
//        public Integer StatusId_;
//        public String CreatedBy_;
//        public String CreatedDate_;
//        public String t_;
//        public String ContextUserId_;
//        public Boolean IsValid_;
//        public Boolean IsVisible_;
//        public Integer SnapshotId_;
    }

//    public class Inapplicable_ {
//    }

    public class PayLoad {
        public User user;
        public String token;
        public Boolean devMode;
    }


    public static CreditWS_CLAuthResponse parse(String json){
        return (CreditWS_CLAuthResponse) System.JSON.deserialize(json, CreditWS_CLAuthResponse.class);
    }

}