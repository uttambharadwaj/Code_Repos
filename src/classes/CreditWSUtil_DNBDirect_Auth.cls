/**
 * Created by dgilbert on 10/17/2018.
 */

public with sharing class CreditWSUtil_DNBDirect_Auth {

    public String access_token;
    public Error error;
    public class Error {
        public String errorCode;
        public String errorMessage;
    }
    public class TransactionResult {
        public String SeverityText;
        public String ResultID;
        public String ResultText;
        public ResultMessage ResultMessage;
    }

    public TransactionDetail TransactionDetail;
    public TransactionResult TransactionResult;
    public AuthenticationDetail AuthenticationDetail;

    public class TransactionDetail {
        public String ServiceTransactionID;
        public String TransactionTimestamp;
        public String ApplicationTransactionID;
    }

    public class ResultMessage {
        public String ResultDescription;
    }

    public class AuthenticationDetail {
        public String Token;
    }

    public static CreditWSUtil_DNBDirect_Auth parse(String json) {
        return (CreditWSUtil_DNBDirect_Auth) System.JSON.deserialize(json, CreditWSUtil_DNBDirect_Auth.class);
    }

}