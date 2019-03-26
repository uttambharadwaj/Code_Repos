/**
 * Created by dgilbert on 8/15/2018.
 */
//TODO DELETE ME - now implemented in CreditDecisionEngineCP
public class CreditUtilQueueable_ThreatMetrix implements Queueable, Database.AllowsCallouts {

//    private ID applicationId;

    public CreditUtilQueueable_ThreatMetrix(Id applicationId) {

//        this.applicationId = applicationId;

    }

    public void execute(QueueableContext context) {

//        String objectType = (Id.valueOf(applicationId)).getSobjectType().getDescribe().getName();  //is this the right id?
//
//        if (objectType != null && (objectType).equalsIgnoreCase('CP_Application_Request__c')) {
//
//            List<CP_Application_Request__c> cpApplicationRequests = [SELECT Id, Company_Legal_Name__c, Doing_Business_As__c, Taxpayer_ID__c,
//                                                                     Physical_Address_Line_1__c, Physical_City__c, Physical_State__c, Physical_Postal_Code__c,
//                                                                     Mailing_Address_Line_1__c, Mailing_City__c, Mailing_State__c, Mailing_Postal_Code__c,
//                                                                     Email__c, Business_Phone__c, Guarantor_First_Name__c, Guarantor_Last_Name__c, Application_Signer_IP_Address__c,
//                                                                     ThreatMetrix_Session_ID__c
//                                                                     FROM CP_Application_Request__c WHERE Id =: applicationId];
//
//            if(cpApplicationRequests.size() == 1) {
//
//                CreditWS_ThreatMetrix.ThreatMetrixSessionQueryRequest request = new CreditWS_ThreatMetrix.ThreatMetrixSessionQueryRequest();
//
//                request.sessionId = cpApplicationRequests[0].ThreatMetrix_Session_ID__c;
//                request.transactionId = cpApplicationRequests[0].Id;
//                request.accountName = cpApplicationRequests[0].Company_Legal_Name__c;
//                request.dbaName = cpApplicationRequests[0].Doing_Business_As__c;
//                request.federalTaxId = cpApplicationRequests[0].Taxpayer_ID__c;
//
//                request.physicalAddressLine1 = cpApplicationRequests[0].Physical_Address_Line_1__c;
//                request.physicalCity = cpApplicationRequests[0].Physical_City__c;
//                request.physicalState = cpApplicationRequests[0].Physical_State__c;
//                request.physicalPostalCode = cpApplicationRequests[0].Physical_Postal_Code__c;
//
//                request.mailingAddressLine1 = cpApplicationRequests[0].Mailing_Address_Line_1__c;
//                request.mailingCity = cpApplicationRequests[0].Mailing_City__c;
//                request.mailingState = cpApplicationRequests[0].Mailing_State__c;
//                request.mailingPostalCode = cpApplicationRequests[0].Mailing_Postal_Code__c;
//
//                request.guarantorName = cpApplicationRequests[0].Guarantor_First_Name__c + ' ' + cpApplicationRequests[0].Guarantor_Last_Name__c;
//                request.guarantorEmail = cpApplicationRequests[0].Email__c;
//
//                request.emailAddress = cpApplicationRequests[0].Email__c;
//                request.phoneNumber = cpApplicationRequests[0].Business_Phone__c;
//
//                request.ipAddress = cpApplicationRequests[0].Application_Signer_IP_Address__c;
//
//                CreditWS_ThreatMetrix.ThreatMetrixSessionQueryResponse response = CreditWS_ThreatMetrix.integrateCreditApp(request);
//
//                cpApplicationRequests[0].ThreatMetrix_Request_ID__c = response.threatMetrixRequestId;
//                cpApplicationRequests[0].ThreatMetrix_Result__c = response.threatMetrixReviewStatus;
//
//                upsert cpApplicationRequests[0];
//
//            }
//
//        }
//
    }

}