@RestResource(urlMapping='/FleetEnrollmentWS/Attachments/*')
global with sharing class FleetEnrollmentWS_Attachments {
//
    //@HttpPost
    //global static void updateQueueCase() {
//
    //try {
//
    //RestRequest request = RestContext.request;
//
    //String parentId = request.params.get('id');
    //String attachmentName = request.params.get('attachmentName');
//
    //if(parentId != null && attachmentName != null) {
//
    //Blob attachmentBody = request.requestBody;
//
    //Attachment attachment = new Attachment();
    //attachment.ParentId = parentId;
    //attachment.Name = attachmentName;
    //attachment.Body = attachmentBody;
    //attachment.ContentType = 'image/png';
//
    //insert attachment;
//
    //RestContext.response.addHeader('Content-Type', 'application/json');
    //RestContext.response.responseBody = Blob.valueOf(JSON.serialize(new POSTResponse(parentId, true, 'Attachment added!')));
//
    //}
    //else {
    //throw new fleetEnrollmentuWSAttachmentException('Please ensure your parameters include \'id\' and \'attachmentName\'.');
    //}
//
    //}
    //catch(Exception e) {
    //WEXDEVErrorReporting.reportInternalError('FleetEnrollmentWS - Attachments', '', UserInfo.getUserId(), e);
//
    //RestContext.response.addHeader('Content-Type', 'application/json');
    //RestContext.response.responseBody = Blob.valueOf(JSON.serialize(new POSTResponse(RestContext.request.params.get('id'), false, e.getMessage())));
    //}
//
    //}
//
    //public class fleetEnrollmentuWSAttachmentException extends Exception {}
//
    //public class POSTResponse {
//
    //public String id { get; set; }
    //public Boolean result { get; set; }
    //public String message { get; set; }
//
    //public POSTResponse(String caseId, Boolean result, String message) {
//
    //this.id = caseId;
    //this.result = result;
    //this.message = message;
//
    //}
//
    //}
//
}