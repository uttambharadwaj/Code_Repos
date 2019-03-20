/**
* Forseva consumer credit check code.
*/
trigger EquifaxConsumerAfterInsert on forseva1__EquifaxConsumer__c (after insert) {

    Map<ID,Account> accountMap = new Map<ID,Account>();

    for (forseva1__EquifaxConsumer__c report : Trigger.new) {
        
        Account a = new Account(ID = report.forseva1__Account__c);        
        accountMap.put(a.ID, a);                   

        if(report.forseva1__F_Credit_Quality_Rating__c != null) {
            a.Credit_Quality_Rating_Equifax__c = report.forseva1__F_Credit_Quality_Rating__c;
        }
        if(report.forseva1__F_CQR_Description__c != null) {
            a.CQR_Description_Equifax__c = report.forseva1__F_CQR_Description__c;
        }
        if(report.forseva1__F_Credit_Review_Status__c != null) {
            a.Credit_Review_Status_Equifax__c = report.forseva1__F_Credit_Review_Status__c;
        }
        if(report.forseva1__F_Credit_Review_Status__c != null) {
            a.Credit_Review_Date_Equifax__c = Date.today();
        }
        if(report.forseva1__F_Credit_Review_Comments__c != null) {
            a.Credit_Review_Comments_Equifax__c = report.forseva1__F_Credit_Review_Comments__c;
        }
        if(report.forseva1__F_Next_Credit_Review_Date__c != null) {
            a.Next_Credit_Review_Date_Equifax__c = report.forseva1__F_Next_Credit_Review_Date__c;
        }
        if(report.forseva1__F_Credit_Limit_Approved__c != null) {
            a.Credit_Limit_Approved_Equifax__c = report.forseva1__F_Credit_Limit_Approved__c;
        }
        if(report.forseva1__F_Credit_Limit_Approver__c != null) {
            a.Credit_Limit_Approver_Equifax__c = report.forseva1__F_Credit_Limit_Approver__c;
        }
        if(report.forseva1__F_Credit_Limit_Comments__c != null) {
            a.Credit_Limit_Comments_Equifax__c = report.forseva1__F_Credit_Limit_Comments__c;
        }
        if(report.forseva1__F_Credit_Limit_Effective_Date__c != null) {
            a.Credit_Limit_Effective_Date_Equifax__c = report.forseva1__F_Credit_Limit_Effective_Date__c;
        }
        if(report.forseva1__F_Credit_Limit_Expiration_Date__c != null) {
            a.Credit_Limit_Expiration_Date_Equifax__c = report.forseva1__F_Credit_Limit_Expiration_Date__c;
        }
        if(report.Beacon_Score__c != null) {
            a.Score_Equifax__c = Integer.valueOf(report.Beacon_Score__c); 
        }
    }
    
    update accountMap.values();
    
}

// EOF