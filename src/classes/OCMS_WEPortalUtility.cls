public without sharing class OCMS_WEPortalUtility {
//
    public String JSONResponse {get; set;}
    //public String action {get; set;}
    //private Map<String, String> parameters; 
    //
    //public OCMS_WEPortalUtility() {
    //}
//
    public void loadResponse() {
    //
        //this.parameters =  System.currentPageReference().getParameters();
        //this.action = this.parameters.get('action');        
        //if(this.action == 'createPortalUser'){
            //String sUser = this.parameters.get('username');
            //String sPass = this.parameters.get('password');
            //String sName = this.parameters.get('program');
            //this.createPortalUser(sUser, sPass, sName);
            //this.sendMailToUser(sName, sUser);
            //System.debug('Check1');
        //}
        //else if (this.action == 'loginUser')
        //{
            //String sUser = this.parameters.get('username');
            //String sPass = this.parameters.get('password');
            //String sName = this.parameters.get('program');
            //this.loginUser(sUser, sPass, sName);
        //}
        //else if (this.action == 'getIP')
        //{
            //this.getIPAddress();            
        //}
        //else if (this.action == 'getProgram')
        //{
            //String sProgram = this.parameters.get('program');
            //this.getProgramById(sProgram);          
        //}
        //else if (this.action == 'getAppStatus')
        //{
            //String sId = this.parameters.get('id');
            //this.getApplicationById(sId);
        //}
        //else if (this.action == 'validateCoupon')
        //{
            //String sProgram = this.parameters.get('program');
            //String sCoupon = this.parameters.get('coupon');
            //this.isCouponValid(sProgram, sCoupon);          
        //}
        //else if (this.action == 'getAllPrograms')
        //{
            //this.getAllPrograms();          
        //}
        //else if (this.action == 'sendconfirm')
        //{
            //String sProgram = this.parameters.get('program');
            //String sUser = this.parameters.get('username');
            //sendMailToUser(sProgram, sUser);
        //}
        //else if (this.action == 'sendappsubmitconfirm')
        //{
            //String sProgram = this.parameters.get('program');
            //String sAppId = this.parameters.get('id');
            //sendAppConfirmEmail(sProgram, sAppId);
        //}
        //else if (this.action == 'getSessionId')
        //{
            //getSessionId();
        //}
    }
//
    //private String getBOCAAccount()
    //{
        //try
        //{
            //Account a = [SELECT Id, Name FROM Account WHERE Name = 'BOCA Applicants'];
            //return a.Id;
        //}
        //
        //catch (Exception ex)
        //{
            //return '';
        //}
    //}
//
    //private String getSessionId()
    //{
        //String s = UserInfo.getSessionId();
        //if (s != null)
        //{
            ////  Add a random number onto the end to make unique
            //String r = String.valueOf(Math.random());
            //r = r.substring(0,8);
            //s = s + r;
            //JSONResponse = '{"status":"success", "id":"' + s + '"}';
        //}
        //else
        //{
            //JSONResponse = '{"status":"failed"}';
        //}
        //return s;
    //}
//
    //private void createPortalUser(String sUser, String sPass, String sName)
    //{
        ////  The user must be unique per site, so we add the site name onto the username for registration/login
        //String sUserWithSite = sUser + '.' + sName;
        //
        ////  Check if the user already exists
        //boolean bExists = false;
        //String soql = 'SELECT Id, Username FROM User WHERE Username = \'' + String.escapeSingleQuotes(sUserWithSite.toLowerCase()) + '\' LIMIT 1';
        //SObject[] res = Database.Query(soql);
        //if (res.size() > 0)
        //{
            //bExists = true;
        //}       
        //
        //System.debug('createPortalUser: does the user already exist? ' + bExists);
        //
        //User u = new User();
        //u.LastName = sUser;
        //u.UserName = sUserWithSite;
        //u.Email = sUser;
//
        //String alias = sUser.substring(0, sUser.indexOf('@'));
        //if (alias.length() > 8)
        //{
            //u.Alias = alias.substring(0,8);   //  alias on the User object is up to 8 characters in length
        //}
        //else
        //{
            //u.Alias = alias;
        //}       
//
        //String sNick = alias + String.valueOf(Math.random());
        //if (sNick.length() > 40)
        //{
            //u.CommunityNickname = sNick.substring(0,40);  //  communityNickname has a max length of 40 characters
        //}
        //else
        //{
            //u.CommunityNickname = sNick;
        //}
//
        //if (!bExists)
        //{
            //String sActId = getBOCAAccount();
            //ID userId;
            //try {
                //userId = Site.createPortalUser(u, sActId, sPass, false);
            //}
            //catch (Exception ex)
            //{
                //this.JSONResponse = '{"status":"failed", "error":"EXCEPTION -- ' + getErrorResponse() + '",'+
                                    //'"user": [{"username":"' + u.Email + '"}]}';
                //return;
            //}
//
            //if (userId == null) {
                //this.JSONResponse = '{"status":"failed", "error":"NULL USER -- ' + getErrorResponse() + '",'+
                                    //'"user": [{"username":"' + u.Email + '"}]}';
                //return;
            //}
        //}
        //System.debug('createPortalUser: now ready to hit the loginUser Code');
        ////  now login the user
        //loginUser(sUser, sPass, sName);
    //}
//
    //private void loginUser(String sUser, String sPass, String sName)
    //{
        ////  The user must be unique per site, so we add the site name onto the username for registration/login
        //String sUserWithSite = sUser + '.' + sName;
        //
        ////  now login the user
        //if (sPass != null && sPass.length() > 1)
        //{
            //PageReference pgref = Site.login(sUserWithSite, sPass, 'oca_login');
            //
            //System.debug('pgref is: ' + pgref);
            //
            //if (pgref != null)
            //{
                //this.JSONResponse = '{"status":"success", "user":"' + sUser + '", "returl":"' + pgref.getUrl() + '"}';
                //System.debug('the return url is: ' + pgref.getUrl());
            //}
            //else
            //{
                //this.JSONResponse = '{"status":"failed", "error":"' + getErrorResponse() + '"}';
                //System.debug('error is: ' + getErrorResponse());
            //}
        //}
    //}
//
    //private static String getErrorResponse() {
        //String response = '';
        //for(ApexPages.Message msg : ApexPages.getMessages()){
            //response = response +  msg.getDetail();
        //}
        //return response; 
    //}
//
    //private List<Map<String, String>> getAllPrograms()
    //{
        //String baseUrl = WEXHelper.getSecureSitesURL() + 'boca/';
//
        //List<Map<String, String>> lPrograms = new List<Map<String, String>>(); 
        //String soql = 'SELECT Id, Name, Inside_Sales_Phone_Number__c, Credit_Department_Phone_Number__c, Email_From_Name__c, BOCA_Resume_Application_URL__c, BOCA_Application_Status_URL__c, Personal_Guarantee_URL__c FROM Program__c ORDER BY Name';
//
        //try {
            //SObject[] res = Database.Query(soql);
        //
            //for (SObject o : res)
            //{
                //Map<String, String> pMap = new Map<String, String>();
                //pMap.put('Id', (String)o.get('Id'));
                //pMap.put('Name', (String)o.get('Name'));
                //pMap.put('InsideSalesPhoneNumber', (String)o.get('Inside_Sales_Phone_Number__c'));
                //pMap.put('CreditDepartmentPhoneNumber', (String)o.get('Credit_Department_Phone_Number__c'));
                ////pMap.put('EmailReplyTo', (String)o.get('Email_Reply_To_Address__c'));
                //pMap.put('EmailFromName', (String)o.get('Email_From_Name__c'));
                //pMap.put('ResumeURL', baseURL + (String)o.get('BOCA_Resume_Application_URL__c'));
                //pMap.put('StatusURL', baseURL +(String)o.get('BOCA_Application_Status_URL__c'));
                //pMap.put('PersonalGuranteeURL', (String)o.get('Personal_Guarantee_URL__c'));
                //
                //lPrograms.add(pMap);
            //}
            //JSONResponse = '{"status":"success","programs":' + JSON.serialize(lPrograms) + '}';
            //return lPrograms;
        //}
        //catch (Exception ex) {}
//
        //JSONResponse = '{"status":"failed"}';
        //return null;
    //}
//
    //private Map<String, String> getProgramById(String pId)
    //{
        //String baseUrl = WEXHelper.getSecureSitesURL() + 'boca/';
        //
        //Map<String, String> pMap = new Map<String, String>();
        //String soql = 'SELECT Id, Name, Inside_Sales_Phone_Number__c, Credit_Department_Phone_Number__c, Email_From_Name__c, BOCA_Resume_Application_URL__c, BOCA_Application_Status_URL__c, Personal_Guarantee_URL__c FROM Program__c WHERE Id = \'' + pId + '\'';
//
        //try {
            //SObject[] res = Database.Query(soql);
        //
            //if (res.size() > 0)
            //{
                //pMap.put('Id', pId);
                //pMap.put('Name', (String)res[0].get('Name'));
                //pMap.put('InsideSalesPhoneNumber', (String)res[0].get('Inside_Sales_Phone_Number__c'));
                //pMap.put('CreditDepartmentPhoneNumber', (String)res[0].get('Credit_Department_Phone_Number__c'));
              ////  pMap.put('EmailReplyTo', (String)res[0].get('Email_Reply_To_Address__c'));
                //pMap.put('EmailFromName', (String)res[0].get('Email_From_Name__c'));
                //pMap.put('ResumeURL', baseURL + (String)res[0].get('BOCA_Resume_Application_URL__c'));
                //pMap.put('StatusURL', baseURL +(String)res[0].get('BOCA_Application_Status_URL__c'));
                //pMap.put('PersonalGuranteeURL', (String)res[0].get('Personal_Guarantee_URL__c'));
                //JSONResponse = '{"status":"success","program":' + JSON.serialize(pMap) + ',"tc":' + getDefaultTC(pId) + '}';
//
                //return pMap;
            //}
        //}
        //catch (Exception ex) {}
//
        //JSONResponse = '{"status":"failed"}';
        //return null;
    //}
    //
   //
//
   //private Map<String, String> getApplicationById(String pId)
    //{
        //String baseUrl = WEXHelper.getSecureSitesURL() + 'boca/SinclairFleetTrackAppStatus';
        ////expire date=today-72hrs 
        ////to check against expired apps
       //// CreatedDate > :(System.today()-3)
        //
        //Map<String, String> pMap = new Map<String, String>();
        //String err = '';
        //date d = system.today().addDays(-3);
        //String soql = 'SELECT Id, Application_Number__c, CreatedDate, Online_Application_Status__r.Description__c FROM WeFormObject__c WHERE CreatedDate > :d AND Id = \'' + pId + '\'';
//
        //try {
            //SObject[] res = Database.Query(soql);
            //
            //if (res.size() > 0)
            //{
                //pMap.put('Id', pId);
                //pMap.put('Number', (String)res[0].get('Application_Number__c'));
                ////get the date of the application
                ////pMap.put('Date',(String)res[0].get('CreatedDate'));
                //pMap.put('Date',String.valueOf(res[0].get('CreatedDate')));  
                //pMap.put('Status', (String)res[0].getSObject('Online_Application_Status__r').get('Description__c'));
//
                //JSONResponse = '{"status":"success","appstatus":' + JSON.serialize(pMap) + '}';
//
                //return pMap;
            //}
            //else{
                ////return a blank application if no records
                ////use get ProgramById to populate
                //pMap = getProgramById(pId);
                //JSONResponse = '{"status":"success","appstatus":' + JSON.serialize(pMap) + '}';
                //return pMap;
            //}
        //}
        //catch (Exception ex) {
            //err = ex.getStackTraceString();
        //}
        //JSONResponse = '{"status":"failed","error":"' + err + '"}';
        //return null;
    //} 
    //
    ///*private Map<String, String> getApplicationById(String pId)
    //{
        //Map<String, String> pMap = new Map<String, String>();
        //String err = '';
        //String soql = 'SELECT Id, SF_Opp__c, Sales_Stage__r.Description__c FROM Application_Request__c WHERE Id = \'' + pId + '\'';
//
        //try {
            //SObject[] res = Database.Query(soql);
        //
            //if (res.size() > 0)
            //{
                //pMap.put('Id', pId);
                //pMap.put('Number', (String)res[0].get('SF_Opp__c'));
                //pMap.put('Status', (String)res[0].getSObject('Sales_Stage__r').get('Description__c'));
                //JSONResponse = '{"status":"success","appstatus":' + JSON.serialize(pMap) + '}';
//
                //return pMap;
            //}
        //}
        //catch (Exception ex) {
            //err = ex.getStackTraceString();
        //}
        //JSONResponse = '{"status":"failed","error":"' + err + '"}';
        //return null;
    //} 
    //
   //*/
    //public static Map<String, String> getApplicationStatuses()
    //{
        //Map<String, String> pMap = new Map<String, String>();
        //String err = '';
        //String response = '';
        //String soql = 'SELECT Name, Id FROM Online_Application_Status__c';
//
        //try {
            //SObject[] res = Database.Query(soql);
        //
            //for (SObject oas : res)
            //{
                //pMap.put((String)oas.get('Name'), (String)oas.get('Id'));
                //response = '{"status":"success","status":' + JSON.serialize(pMap) + '}';
//
                //return pMap;
            //}
        //}
        //catch (Exception ex) {
            //err = ex.getStackTraceString();
        //}
        //response = '{"status":"failed","error":"' + err + '"}';
        //return null;
    //}
////Debug Start
//
//private Boolean isCouponValid(String pId, String cCode)
    //{
        //String soql = 'select Id, Campaign__r.Coupon_Code__c, Terms_and_Conditions__c from Campaign_Program__c where Program__c = \'' + pId + '\' and Campaign__r.isActive = true and Campaign__r.Coupon_Code__c = \'' + cCode + '\'';
        //
        //String soqlQ = 'select Id, Campaign__r.Coupon_Code__c, Terms_and_Conditions__c from Campaign_Program__c where Program__c = \'' + pId + '\' and Default__c = true LIMIT 1';
        //String sTC= '';   
        //
        //try {
            //SObject[] res = Database.Query(soql);
            //SObject[] resQ = Database.Query(soqlQ);
            //if (res.size() > 0)
            //{                             
                //String terms = (String)res[0].get('Terms_and_Conditions__c');
                //String terms1 = (String) resQ[0].get('Terms_and_Conditions__c');
                //if (terms == '' || terms == null || terms == '<br>')               
                //{
                    ////sTC = getDefaultTC(pId);
                    //CPTerms cp1 = new CPTerms();
                    //cp1.id = (String) res[0].get('Id');
                    //cp1.terms = terms1;
                    //SObject so = res[0].getSObject('Campaign__r');
                    //
                    //if (so != null)
                    //{
                        //cp1.promo_code = (String)so.get('Coupon_Code__c');
                         //
                    //}
                    //sTC = JSON.serialize(cp1);
                    //
                //}
                //else
                //{
                    //CPTerms cp = new CPTerms();
                    //cp.id = (String)res[0].get('Id');
                    //cp.terms = terms;
                    //SObject so = res[0].getSObject('Campaign__r');
                    //
                    //if (so != null)
                    //{
                        //cp.promo_code = (String)so.get('Coupon_Code__c');
                         //
                    //}
                    //sTC = JSON.serialize(cp);
                //}
                //JSONResponse = '{"status":"success","tc":' + sTC + '}';
                //return true;
            //}
        //}
        //catch (Exception ex) {}
        //JSONResponse = '{"status":"failed"}';
        //return false;
    //}
//
    //
//
////Debug End
//
///*
    ////  Check if the coupon code entered is valid, return the coupons t&c or default t&c if empty
    //private Boolean isCouponValid(String pId, String cCode)
    //{
        //String soql = 'select Id, Campaign__r.Coupon_Code__c, Terms_and_Conditions__c from Campaign_Program__c where Program__c = \'' + pId + '\' and Campaign__r.isActive = true and Campaign__r.Coupon_Code__c = \'' + cCode + '\'';
        //String sTC= '';     
        //try {
            //SObject[] res = Database.Query(soql);
            //
            //if (res.size() > 0)
            //{
               //// String check1 = (String)res[0].get('Campaign__r.Coupon_Code__c');
               //// System.debug('Check Point' +check1);
                //String terms = (String)res[0].get('Terms_and_Conditions__c');
                //if (terms == '' || terms == null)               
                //{
                    //sTC = getDefaultTC(pId);
                //}
                //else
                //{
                    //CPTerms cp = new CPTerms();
                    //cp.id = (String)res[0].get('Id');
                    //System.debug('Check Point - Id' +cp.id);
                    //cp.terms = terms;
                    //SObject so = res[0].getSObject('Campaign__r');
                    //System.debug('Check Point - Campaign' +so);
                    //if (so != null)
                    //{
                        //cp.promo_code = (String)so.get('Coupon_Code__c');
                         //System.debug('Check Point - Coupon' +cp.promo_code);
                    //}
                    //sTC = JSON.serialize(cp);
                //}
                //JSONResponse = '{"status":"success","tc":' + sTC + '}';
                //return true;
            //}
        //}
        //catch (Exception ex) {}
        //JSONResponse = '{"status":"failed"}';
        //return false;
    //}
//*/
    //private class CPTerms {
        //String id {get; set;}
        //String promo_code {get; set;}
        //String terms {get; set;}
    //}   
//
    ////  Get the default terms and conditions for the program.
    //private String getDefaultTC(String pId)
    //{
        //CPTerms def = new CPTerms();
        //String soql = 'select Id, Campaign__r.Coupon_Code__c, Terms_and_Conditions__c from Campaign_Program__c where Program__c = \'' + pId + '\' and Default__c = true LIMIT 1';
        //try {
            //SObject[] res = Database.Query(soql);
            //if (res.size() > 0)
            //{
                //
                //def.id = (String)res[0].get('Id');
                //System.debug('Check3:' +def.id);
                //SObject so = res[0].getSObject('Campaign__r');
                //if (so != null)
                //{
                    //def.promo_code = (String)so.get('Coupon_Code__c');
                //}
                //def.terms = (String)res[0].get('Terms_and_Conditions__c');
            //}
        //}
        //catch (Exception ex) {}
        //return JSON.serialize(def);
    //}
//
    //public String sendMailToUser(String programId, String emailAddr )
    //{
        //try
        //{
            ////Method that will send an e-mail to a user based on a user id
            //String errs = '';
            //Map<String, String> pMap = this.getProgramById(programId);
            //
            //if (pMap != null) {
                //Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                //String pName = pMap.get('Name');
                //String pPhone = pMap.get('InsideSalesPhoneNumber');
                //String pEmailFrom = pMap.get('EmailFromName');
                //String pRetUrl = pMap.get('ResumeURL');
                //String subject = pName + ' Application Saved';
                //
                //String resumeUrl = '<a href="' + pRetURL +'">' + 'Resume Application' + '</a>';
//
                //String[] toEmail = new String[] {emailAddr};
                //
                //mail.setToAddresses(toEmail);
                //mail.setSubject(subject);
                //
                //OrgWideEmailAddress [] addr = [select Id from OrgWideEmailAddress where DisplayName = :pEmailFrom ];
        //
                //if (addr.size() > 0){
                    //mail.setOrgWideEmailAddressId(addr[0].Id);
                //}
                            //
                //String body = '<p>Thank you for your interest in ' + pName +
                              //'. At your request, we have saved your application. ' +
                              //'You may return to complete your application within 72 hours ' +
                              //'by clicking ' + resumeUrl + '</p>' +
                              //'<p>If you have any questions or need additional assistance, ' +
                              //'please contact our Credit Department at ' + pPhone + '.<br />' +
                              //'Please do not reply to this email.</p>' +
                              //'<p>Thank you.</p>'+
                              //'<p>'+pName+'</p>'+
                              //'<a href="http://www.wexinc.com/privacy-policy">Privacy Statement</a>';
//
                //mail.setHtmlBody(body);
                //List<Messaging.SendEmailResult> results = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mail});
                //System.debug('Email results: ' + results);
                //for (Messaging.SendEmailResult e : results)
                //{
                    //for (Messaging.Sendemailerror err : e.getErrors())
                    //{
                        //errs = errs + err.getMessage() + ' - ***';
                    //}
                //}
            //}
            //else
            //{
                //errs = 'Could not find program record for ID ' + programId;
            //}
            //if (errs.length() > 0)
            //{
                //this.JSONResponse = '{"status":"failed","error":"' + errs +'"}';
            //}
            //else
            //{
                //this.JSONResponse = '{"status":"success"}';
            //}
            //return errs;
        //}
        //catch (Exception ex)
        //{
            //this.JSONResponse = '{"status":"failed","error":"' + ex.getMessage() +'"}';
            //return 'Exception sending email';
        //}
    //}
//
    //private String sendAppConfirmEmail(String programId, String appId)
    //{
        //try
        //{
            //WeFormObject__c we = [SELECT Id, Email__c, Signer_s_Email__c, First_Name__c, Last_Name__c, Application_Status__c, Application_Number__c, Promotional_Code__c, Sales_Id__c FROM WeFormObject__c WHERE Id = :appId];
            //
            //String emailAddr = we.Email__c;
            ////Test
            //String emailAddr1;
            //if(we.Signer_s_Email__c != null){
            //emailAddr1 = we.Signer_s_Email__c;
            //}
            //else{
            //emailAddr1 = we.Email__c;
            //}
            //
            ////
            //
            ////String emailAddr1 = we.Signer_s_Email__c;
            //String firstName = we.First_Name__c;
            //String lastName = we.Last_Name__c;
                                //
            ////Method that will send an e-mail to a user based on a submitted app id
            //String errs = '';
            //Map<String, String> pMap = this.getProgramById(programId);
            //
            //if (pMap != null) {             
                //
                //Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                //String pName = pMap.get('Name');
                //String pPhone = pMap.get('InsideSalesPhoneNumber');
             ////   String pEmailAddr = pMap.get('EmailReplyTo');
                //String pEmailFrom = pMap.get('EmailFromName');
                //
                //String pRetUrl = pMap.get('StatusURL');
                //String pPersonalGuranteeURL = pMap.get('PersonalGuranteeURL');
                //String subject = pName + ' Application Received - Thank you';
//
                //String[] toEmail = new String[] {emailAddr};
                //String[] toEmail1 = new String[] {emailAddr1};
                //
              ////  String My_pEmailAddr = 'no-reply@sinclair.com';
              //
                               //
               //if(emailAddr.equals(emailAddr1)){
                    //mail.setToAddresses(toEmail);                               
               //}
               //else{
                    //mail.setToAddresses(toEmail);
                    //mail.setCcAddresses(toEmail1);                  
               //}
                ////mail.setSenderDisplayName(pEmailFrom);
                //mail.setUseSignature(false);
              //
                //OrgWideEmailAddress [] addr = [select Id from OrgWideEmailAddress where DisplayName = :pEmailFrom ];
                //System.debug('addr size is: ' + addr.size());
                //if (addr.size() > 0){
                    //mail.setOrgWideEmailAddressId(addr[0].Id);
                //}
                              //
///*           for(OrgWideEmailAddress owa : [select id, Address, DisplayName from OrgWideEmailAddress]) {
                    //System.debug('*****'+owa);
                    //if(owa.Address.contains('prasad.jagilinki')) { 
                     //
                    //mail.setOrgWideEmailAddressId(owa.id);
                   //
                    //}
           //}               
//*/                
                //
                ////mail.setToAddresses(toEmail);
                //
                //mail.setSubject(subject);
               //// mail.setReplyTo(My_pEmailAddr);
                //
                //String statusURL = '<a href="' + pRetURL + '?id=' + appId +'">' + 'Application Status' + '</a>';
                //
                //String pURL = '<a href="' + pPersonalGuranteeURL +'">' + 'Personal Guaranty Form' + '</a>';
            //
                //String body1 = '<p>Dear ' + firstName + ' ' + lastName + ',</p>' + 
                              //'<p>Thank you, we have received your application. The Personal Guaranty Form below is required for application processing.  Please download, complete the form and fax to ' + pName + '.</p>' +
                              //'<p>' + pURL + '</p>' + 
                              //'<p>For reference, your confirmation number is ' + we.Application_Number__c + '. ' +
                              //'You will receive a response within 5 business days. </p>' +
                              //'<p>You may also check the status of this ' + 
                              //'application at any time by going to ' + statusURL + '.</p>' +                               
                              //
                                                          //
                              //'<p>Please do not reply to this email. </p>' +
                              //
                              //'<p>Thank you.<br/>' + pName + '</p>'+
                              //
                              //'<p>Cpn Cd: ' + we.Promotional_Code__c + '<br/>' + 
                              //'Ext Id: ' + we.Sales_Id__c + '</p>'+
                    //
                             //'<a href="http://www.wexinc.com/privacy-policy">Privacy Statement</a>';
                              //
                //String body2 = '<p>Dear ' + firstName + ' ' + lastName + ',</p>' + 
                              //'<p>We have received your application. For reference, your confirmation number is ' + we.Application_Number__c + '. ' +
                              //'You will receive a response within 5 business days.  You may also check the status of this ' + 
                              //'application at any time by going to ' + statusURL + '.</p>' +                              
                              //'<p>Please do not reply to this email. </p>' +
                              //'<p>Thank you. </p>' +
                              //'<p>Cpn Cd: ' + we.Promotional_Code__c + '<br/>' + 
                              //'Ext Id: ' + we.Sales_Id__c + '</p>'+
                    //
                             //'<a href="http://www.wexinc.com/privacy-policy">Privacy Statement</a>';         
                                //
//
                //if(pPersonalGuranteeURL != null){
                    //mail.setHtmlBody(body1);
                //}
                //else {
                    //mail.setHtmlBody(body2);
                    //
                //}
                //List<Messaging.SendEmailResult> results = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mail});
                //System.debug('Email results: ' + results);
                //for (Messaging.SendEmailResult e : results)
                //{
                    //for (Messaging.Sendemailerror err : e.getErrors())
                    //{
                        //errs = errs + err.getMessage() + ' - ***';
                    //}
                //}
            //}
            //else
            //{
                //errs = 'Could not find program record for ID ' + programId;
            //}
            //if (errs.length() > 0)
            //{
                //this.JSONResponse = '{"status":"failed","error":"' + errs +'"}';
            //}
            //else
            //{
                //this.JSONResponse = '{"status":"success"}';
            //}
            //return errs;
        //}
        //catch (Exception ex)
        //{
            //this.JSONResponse = '{"status":"failed","error":"' + ex.getMessage() +'"}';
            //return 'Exception sending email';
        //}
    //}
    //
    //
//
    //private void getIPAddress()
    //{
        //String ip = ApexPages.currentPage().getHeaders().get('X-Salesforce-SIP');
////      Map<String,String> ip = ApexPages.currentPage().getHeaders();
        //this.JSONResponse = '{"status":"success","ip":' + JSON.serialize(ip) + '}';
    //}
//
    //public static User createCustomerUser(String accountId, String username, String lastName ) 
    //{
        //String profileName = 'Authenticated Website';
//
        //String alias = username.split('@').get(0);
        //alias = alias.substring(0,8);
        //
        //Profile profile = [
           //select Id from Profile where Name=:profileName
        //];
        //
        //List<String> AU_Contact_RTs = new List<String>{'AU_Contact'};
    //
        //Id conRT = [select Id from RecordType where sObjectType = 'Contact' and DeveloperName NOT IN :AU_Contact_RTs limit 1].Id;
        //
        //Contact contact = new Contact(
            //AccountId = accountId, 
            //LastName = lastName,
            //RecordTypeId = conRT
        //);
        //insert contact;
        //
        //User user = new User(
            //ContactId = contact.Id,
            //Username = username,
            //Email = username,
            //LastName = lastName,
            //Alias = alias,
            //ProfileID = profile.Id,
            //PortalRole = 'Manager',
            //LocaleSidKey = 'en_US',
            //LanguageLocaleKey = 'en_US',
            //TimeZoneSidKey = 'America/Los_Angeles',
            //EmailEncodingKey='UTF-8'
        //);
        //insert user;
        //
        //return user;
    //}
//
    //@future
    //public static void disableUsers(Set<Id> uIds)
    //{
        //List<User> usersToUpdate = new List<User>();
        //for (User u : [SELECT Id, isActive, isPortalEnabled, Username FROM User WHERE Id IN :uIds])
        //{
            //if (u.isActive && u.isPortalEnabled)
            //{
                //u.isActive = false;
                //u.isPortalEnabled = false;
                //u.Username = '_' + u.Username + String.valueOf(Math.random()); 
                //System.Debug('Check User:' +u.Username);             
                //usersToUpdate.add(u);
            //}
        //}
        //if (usersToUpdate.size() > 0)
        //{
            //update usersToUpdate;
        //}
    //}    
    //
    ///* Client request comment out, informed this class will go away.
    //08/14/14
    //
    //@IsTest(SeeAllData=true)    
    //static void testCreatePortalUser()
    //{
        //List<String> AU_Acc_RTs = new List<String>{'AU_Fuel_Customer'};
        //
        //Id accRT = [select Id from RecordType where sObjectType = 'Account' and DeveloperName NOT IN :AU_Acc_RTs limit 1].Id;
        //
        //Account acc = new Account();
        //acc.Name = 'Test Portal Account';
        //acc.RecordTypeId = accRT;
        //insert acc;
//
        //Program__c p = new Program__c();
        //p.Name = 'Test Program Name';
        //p.Inside_Sales_Phone_Number__c = '+1 877 666 6666';
        //p.Credit_Department_Phone_Number__c = '+1 877 666 7777';
        //p.Email_From_Name__c = 'Test From';
        //p.Email_Reply_To_Address__c = 'no-reply@sinclair.com';
        //p.BOCA_Resume_Application_URL__c = 'https://orch-test1-developer-edition.na9.force.com/oca_login';
        //insert p;
        //
        //ApexPages.currentPage().getParameters().put('action', 'createPortalUser');
        //ApexPages.currentPage().getParameters().put('username', 'rc@acanac.net');
        //ApexPages.currentPage().getParameters().put('password', 'test123');
        //ApexPages.currentPage().getParameters().put('program', p.Id);
        //
        //OCMS_WEPortalUtility pu = new OCMS_WEPortalUtility();
        ////  Test with a null account ID
        //pu.loadResponse();
//
        ////  Now test with a non-null account ID     
        //ApexPages.currentPage().getParameters().put('id', acc.Id);
        //pu.loadResponse();
        //System.debug(pu.JSONResponse);  
//
        ////  Test with a really long username
        //ApexPages.currentPage().getParameters().put('username', 'thisisareallylongusernametotestfieldlengthlimits@areallylongdomainname.com');
        //pu.loadResponse();
        //System.debug(pu.JSONResponse);  
//
        ////  Test the login
        //pu.loginUser('rc@acanac.net','test123',p.Id);
        //System.debug(pu.JSONResponse);  
//
        ////  Get the IP address      
        //ApexPages.currentPage().getParameters().put('action', 'getIP');
        //pu.loadResponse();
        //System.debug(pu.JSONResponse);  
//
        ////  Test getting the program
        //ApexPages.currentPage().getParameters().put('action', 'getProgram');
        //ApexPages.currentPage().getParameters().put('program', p.Id);
        //pu.loadResponse();
        //System.debug(pu.JSONResponse);  
        //
        ////  Test an invalid program
        //ApexPages.currentPage().getParameters().put('action', 'getProgram');
        //ApexPages.currentPage().getParameters().put('program', 'abcdef');
        //pu.loadResponse();
        //System.debug(pu.JSONResponse);  
        //
        ////  Test an invalid program
        //ApexPages.currentPage().getParameters().put('action', 'getAllPrograms');
        //pu.loadResponse();
        //System.debug(pu.JSONResponse);  
        //
        ////  Test sending email
        //ApexPages.currentPage().getParameters().put('action', 'sendconfirm');
        //ApexPages.currentPage().getParameters().put('username', 'rc@acanac.net');
        //ApexPages.currentPage().getParameters().put('program', p.Id);
        //pu.loadResponse();
        //System.debug(pu.JSONResponse);  
//
        //// Test the email method directly
  ////      User u = createCustomerUser(acc.Id, 'stantivetest@stantive.com', 'Technologies');
  ////      u.IsPortalEnabled = true;
  ////      update u;
  ////      pu.sendMailToUser(p.Id, u.Username);        
//
        //pu.getSessionId();
        //System.debug(pu.JSONResponse);
        //
        //WeFormObject__c we = new WeFormObject__c();
        //we.Address_Line_2__c = 'Suite 100';
        //we.Billing_Address_Line_2__c = 'Suite 100';
        //we.Billing_City__c = 'Kingston';
        //we.Billing_Contact_First_Name__c = 'Professional';
        //we.Billing_Contact_Last_Name__c = 'Services';
        //we.Billing_Email__c = 'ps@stantive.com';
        //we.Billing_Fax__c = '';
        //we.Billing_Phone__c = '613-555-5556';
        //we.Billing_State__c = 'ON';
        //we.Billing_Street_Address__c = '4 Cataraqui Street';
        //we.Billing_Zip_Code__c = '62106';
        //we.Business_fax__c = '613-555-5554';
        //we.Business_Phone__c = '613-555-5555';
        //we.Business_Street_Address__c = '4 Cataraqui Street';
        //we.City__c = 'Kingston';
        //we.Company_Name__c = 'Stantive Technologies';
        //we.Doing_Business_As__c = 'Stantive';
        //we.Email__c = 'peter.sawicki@wexinc.com';
        //we.Employee_Id__c = '1234';
        //we.Estimated_Monthly_Vehicle_Expenses__c = 9000.0;
        //we.First_Name__c = 'Professional';
        //we.Fiscal_Year_Starts__c = 'Jan';
        //we.Group_Code__c = 'ABC';
        //we.How_did_you_hear_about_this_offer__c = 'Web';
        //we.Is_business_exempt_from_Motor_Fuels_Tax__c = 'Yes';
        //we.Last_Name__c = 'Services';
        //we.Legal_Structure__c = 'Corporation';
        //we.Location_Code__c = 'NW';
        //we.Promotional_Code__c = 'B1C';
        //we.Sales_Id__c = '663434';
        //we.Same_as_Business_Address__c = true;
        //we.Signer_s_Email__c = 'ps@stantive.com';
        //we.Signer_s_First_Name__c = 'Development';
        //we.Signer_s_Last_Name__c = 'Services';
        //we.Signer_s_Phone__c = '613-555-1111';
        //we.signer_title__c = 'President';
        //we.State__c = 'ON';
        //we.Taxpayer_ID__c = '5664363';
        //we.Years_in_Business__c = 'Less than 6 months';
        //we.Zip_code__c = '62106';
//
        //Online_Application_Status__c oas = new Online_Application_Status__c();
        //oas.Name = 'Stage04';
        //oas.Description__c = 'Test stage 04';
        //insert oas;
        //
        //Map<String, String> status = OCMS_WEPortalUtility.getApplicationStatuses();
        //we.Online_Application_Status__c = status.get('Stage04');
//
        //insert we;
//
        //ApexPages.currentPage().getParameters().put('action','sendappsubmitconfirm');
        //ApexPages.currentPage().getParameters().put('program', p.Id);
        //ApexPages.currentPage().getParameters().put('id', we.Id);
        //pu.loadResponse();
        //System.debug(pu.JSONResponse);
//
        //List<String> AU_Opp_RTs = new List<String>{'AU_Fuel_Card_Business','AU_Fuel_Card_Individual','AU_Fuel_Merchant'};
        //
        //Id oppRT = [select Id from RecordType where sObjectType = 'Opportunity' and DeveloperName NOT IN :AU_Opp_RTs limit 1].Id;
        ////  Test getting new opportunity
        //Opportunity opp = new Opportunity();
        //opp.RecordTypeId = oppRT;
        //opp.AccountId = acc.Id;
        //opp.Name = 'Test Company';
        //opp.Doing_Business_As__c = 'Stantive';
//
        ////  add the close date (today)
        //Date dToday = Date.today();
        //opp.CloseDate = dToday;
        //opp.StageName = 'Qualification';   // This will change based on the new external sales stage statuses
        //opp.Years_In_Business__c = 10;
        //opp.Exempt_from_Motor_Fuels_Tax__c = true;
        //opp.How_did_you_hear_about_this_offer__c = 'Web';
        //insert opp;
//
        //ApexPages.currentPage().getParameters().put('action','getAppStatus');
        //ApexPages.currentPage().getParameters().put('id', opp.Id);
        //pu.loadResponse();
        //System.debug(pu.JSONResponse);
//
        //Map<String, String> st = OCMS_WEPortalUtility.getApplicationStatuses();
        //System.debug(st);
    //}*/
    //
    //@IsTest(SeeAllData=true)    
    //public static void testIsValidCouponCode()
    //{
        //OCMS_WEPortalUtility pu = new OCMS_WEPortalUtility();
        //String sProgram = 'Sinclair Fleet Track';
        //String sCoupon = '123';
        //pu.isCouponValid(sProgram, sCoupon);
    //}
    //
    //@IsTest(SeeAllData=true)    
    //public static void testGetDefaultTC()
    //{
        //OCMS_WEPortalUtility pu = new OCMS_WEPortalUtility();
        //String programId = 'a0Z70000001uySwEAI';
        //pu.getDefaultTC(programId);
    //}        
   //
    //@IsTest(SeeAllData=true)    
    //public static void testSendMailToUser()
    //{
        //OCMS_WEPortalUtility pu = new OCMS_WEPortalUtility();
        //String id = 'a0Z70000001uySwEAI';
        //String user = 'peter.sawicki@wexinc.com';
        //pu.sendMailToUser(id,user);
    //}
}