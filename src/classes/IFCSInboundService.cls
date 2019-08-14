@RestResource(urlMapping='/customer/*')
global without sharing class IFCSInboundService {
    @HttpPost
    global static Boolean doPost() {
        RestRequest req = RestContext.request;
        Blob body = req.requestBody;
        String requestString = body.toString();
        CustomerDetails cust = (CustomerDetails) JSON.deserialize(requestString, CustomerDetails.class);
        Decimal requestId;
        try {
            requestId = Decimal.valueOf(cust.orderId);
        } catch(Exception ex) {
            return false;
        }
        List<WES_Application_Request__c> appReqList = [SELECT
                Account__c
                FROM
                WES_Application_Request__c
                WHERE
                requestID__c = :requestId
                               AND
                               Account__c != null
                               LIMIT 1];
        if (!appReqList.isEmpty()) {
            Account acc = new Account(Id = appReqList[0].Account__c);
            acc.IFCS__c = cust.customerNumber;
            update acc;
            return true;
        } else {
            return false;
        }
    }

    public class CustomerDetails {
        public String orderId;
        public String customerNumber;
        public String accessCode;
    }
}