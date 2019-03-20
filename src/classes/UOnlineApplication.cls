public with sharing class UOnlineApplication {
    public UOnlineApplication() {
        
    }

   	public static void verifyAcctRtNos(List<OnlineApplication__c> records, Boolean callFromButton) {
		List<Id> ids = new List<Id> ();
		if (!System.isFuture()) {
			for (OnlineApplication__c app : records) {
				if ((app.Forte_Response_Code__c == null || callFromButton == true) && app.Application_Stage__c == 'Adjudication' && !ForteIntegration.processedIds.contains(app.Id)) {
					ids.add(app.Id);
					ForteIntegration.processedIds.add(app.Id);
				}
			}

			if (!ids.isEmpty()) {
				ForteIntegration.verifyAcctRtNos(ids, callFromButton);
			}
		}
	}

	private static Boolean alreadyRanExperianCall= false;
    public static void callExperianBizScore(List<OnlineApplication__c> records, Map<Id,OnlineApplication__c> oldMap){

        if(alreadyRanExperianCall == true){
            return;
        }
        if(system.isFuture()){
            return;
        }
        
        alreadyRanExperianCall = true;

        List<Id> recordIds = new List<Id>();
        for(OnlineApplication__c oa : records){
            recordIds.add(oa.Id);
        }
        callExperianBizScoreFuture(recordIds);
    }

    @future(callout=true)
    public static void callExperianBizScoreFuture(List<Id> recordIds){
        system.debug('the reocrds---' + recordIds);
        List<OnlineApplication__c> records = getOnlineApplicationsToUpdate(recordIds);
        List<OnlineApplication__c> applicationsToProcess = new List<OnlineApplication__c>();
        List<ExperianBizID__c> ExperianBizIDsToInsert = new List<ExperianBizID__c>();
        Map<Id,OnlineApplication__c> recordsMap = new Map<Id, OnlineApplication__c>();
        for(OnlineApplication__c oa : records){
           System.debug('oa.Application_Stage__c: ' + oa.Application_Stage__c);
		   System.debug('oa.Experian_BizID_with_Score__c: ' + oa.Experian_BizID_with_Score__c);
            if(oa.Application_Stage__c == 'Adjudication'  && oa.Experian_BizID_with_Score__c == null){
                applicationsToProcess.add((OnlineApplication__c)oa);
                recordsMap.put(oa.Id,oa);
            }

        }

        if(applicationsToProcess.isEmpty()){
		System.debug(' No applicationsToProcess' );
            return;
        }

        Experian_BizID_Login__mdt experianCreds = getExperianCredentials();

        system.debug('the experianCreds----' + experianCreds);
        String url = experianCreds.Endpoint__c;
        HttpRequest reqAuthentication = new HttpRequest();
        reqAuthentication.setEndpoint(url);
        reqAuthentication.setMethod('POST');

        Blob headerValue = Blob.valueOf(experianCreds.User_ID__c + ':' + experianCreds.Password__c);
        String authorizationHeader = 'BASIC ' +
        EncodingUtil.base64Encode(headerValue);
        reqAuthentication.setHeader('Authorization', authorizationHeader);
        reqAuthentication.setHeader('Content-Type','application/x-www-form-urlencoded');
       
        //String content = 'NETCONNECT_TRANSACTION';
        Http http = new Http();
        HTTPResponse resAuthentication = http.send(reqAuthentication);
        system.debug('authentication resp' + resAuthentication);
        System.debug('authentication resp body' +resAuthentication.getBody());
        if(resAuthentication.getStatusCode() == 200){

            for(OnlineApplication__c oa : records){
			System.debug('oa: ' + oa);
                HttpRequest reqNetConnect = authenticateExperianNetConnect(resAuthentication.getBody(), authorizationHeader, experianCreds, oa);
                system.debug('biz connect req----' +reqNetConnect);
                system.debug('the biz connect body----' + reqNetConnect.getBody());
				reqNetConnect.setTimeout(30000);
                Http httpNetConnect = new Http();
                HTTPResponse bizIdScoreResponse = httpNetConnect.send(reqNetConnect);

                system.debug('biz response----' + bizIdScoreResponse);
                System.debug('biz response body----' +bizIdScoreResponse.getBody());

                String xml = bizIdScoreResponse.getBody();
                XmlStreamReader xsr = new XmlStreamReader(xml);
                ExperianBizID__c bizIdToInsert = new ExperianBizID__c();
                BizIdWithScore bis= parseBizIdWithScoreStream(xsr, oa);
                bis.onlineApplicationId = oa.Id;
                bis.accountId = oa.Account__c;
               


                bizIdToInsert = mapInsertFields(bis);
                ExperianBizIDsToInsert.add(mapInsertFields(bis));

                system.debug('before updating application---' + oa);
                system.debug('the bizId----' + ExperianBizIDsToInsert);
                
                /*Modified by Trekbin on 01 June, 2016 for Case 00025666*/ 
                if(bizIdToInsert.Decision__c !=null) {

                    if(oa.Offer__r.Name == 'FuelBook Select' || oa.Prepaid__c) {
                        
                        if(bizIdToInsert.Decision__c.toUpperCase() == 'ACC') {
                            
                            mapUpdatedFuelSelectFields(oa);
                            mapFuelSelectACCFields(oa);
                            
                        } else if(bizIdToInsert.Decision__c.toUpperCase() == 'REF') {
                            
                            mapUpdatedFuelSelectFields(oa);
                            mapFuelSelectDECFields(oa); 
                        }
                        
                    } else {
                        
                        if(bizIdToInsert.Decision__c.toUpperCase() == 'ACC')
                            mapNonFuelSelectACCFields(oa);
                            
                        else if(bizIdToInsert.Decision__c.toUpperCase() == 'REF')
                            mapNonFuelSelectDECFields(oa);
                    }
                }

                oa.Experian_BizID_with_Score__c = bizIdToInsert.Id;
                system.debug('the application before update----' + oa);
            }
        }


        
        if(!ExperianBizIDsToInsert.isEmpty()){
            insert ExperianBizIDsToInsert;
        }
        for(ExperianBizID__c ez : ExperianBizIDsToInsert){
            recordsMap.get(ez.Online_Application__c).Experian_BizID_with_Score__c = ez.Id;
        }
        update recordsMap.values();

    }


    public static HttpRequest authenticateExperianNetConnect(String endpoint, String authorizationHeader, Experian_BizID_Login__mdt experianCreds, OnlineApplication__c oa){

        HttpRequest reqNetConnect = new HttpRequest();
        reqNetConnect.setEndpoint(endpoint);
        reqNetConnect.setMethod('POST');
        reqNetConnect.setHeader('Authorization', authorizationHeader);
        reqNetConnect.setHeader('Content-Type','application/x-www-form-urlencoded');
		
		
		
        String requestBizScoreBody = '&NETCONNECT_TRANSACTION=<?xml version="1.0" encoding="UTF-8"?>' +
                                     '<NetConnectRequest>' +
                                     '<EAI>' + experianCreds.EAI__c + '</EAI>' +
                                     '<DBHost>' + experianCreds.DBHost__c + '</DBHost>' +
                                     '<ReferenceId>testing service pt-wex</ReferenceId>' +
                                     '<Request>' +
                                     '<Products>'+
                                         '<BizID>'+
                                             '<XMLVersion>03</XMLVersion>' +
                                             '<Subscriber>'+
                                             '<Preamble>' + experianCreds.Preamble__c + '</Preamble>'+
                                             '<OpInitials>'+ experianCreds.OpInitials__c +'</OpInitials>'+
                                             '<SubCode>' + experianCreds.Subcode__c + '</SubCode>'+
                                             '</Subscriber>'+
                                             //data for call-
                                              setBusinessPrincipal(oa) +
                                             '<BusinessPrincipal>' +
                                             '<Name>' +
                                                 '<Surname>' + oa.Contact_Name__c.subStringAfter(' ').replaceAll('&','').replaceAll('<','').replaceAll('>','').replaceAll('"','').replaceAll('`','') + '</Surname>' +
                                                 '<First>' + oa.Contact_Name__c.subStringBefore(' ').replaceAll('&','').replaceAll('<','').replaceAll('>','').replaceAll('"','').replaceAll('`','') + '</First>' +
                                             '</Name>';
											if(oa.AO_Social_Security_Number__c != null){
												requestBizScoreBody = requestBizScoreBody + '<SSN>' + oa.AO_Social_Security_Number__c.replaceAll('\\D','') + '</SSN>';
											} 
                                            requestBizScoreBody = requestBizScoreBody + '<CurrentAddress>' +
                                                 '<Street>' + oa.AO_Address__c + '</Street>' +
                                                 '<City>' + oa.AO_City__c + '</City>' +
                                                 '<State>' + oa.AO_State__c + '</State>' +
                                                 '<Zip>' + String.valueOf(oa.AO_Zip_Code__c).substring(0,5) + '</Zip>' +
                                             '</CurrentAddress>';
											 if(oa.AO_Date_of_Birth__c != null){
												requestBizScoreBody = requestBizScoreBody + '<DOB>' +
													'<Month>' + String.valueOf(oa.AO_Date_of_Birth__c.month()).leftPad(2).replace(' ', '0') + '</Month>' +
													'<Day>' + String.valueOf(oa.AO_Date_of_Birth__c.day()).leftPad(2).replace(' ', '0') + '</Day>' +
													'<Year>' +oa.AO_Date_of_Birth__c.year()+ '</Year>'+
													'</DOB>';
												}
                                             requestBizScoreBody = requestBizScoreBody +'</BusinessPrincipal>' +
                                             '<Options>'+
                                             '<ProductOption>112</ProductOption>' +
                                             '<ReferenceNumber>00</ReferenceNumber>'+
                                             '<IPAddress>00</IPAddress>'+
                                             '<Verbose>N</Verbose>'+
                                             '</Options>'+
                                         '</BizID>'+
                                     '</Products>'+
                                     '</Request>'+
                                     '</NetConnectRequest>';


        reqNetConnect.setBody(requestBizScoreBody);

        return reqNetConnect;
   
    }

    public static String setBusinessPrincipal(OnlineApplication__c oa){

        String bp = '<BusinessApplicant>'+'<BusinessName>';
        if(oa.Legal_Business_Name__c == null){
            bp += 'null';
        } 
        else{
          //  bp += oa.Legal_Business_Name__c;
            bp += oa.Legal_Business_Name__c.replaceAll('&','').replaceAll('<','').replaceAll('>','').replaceAll('"','').replaceAll('`','');
        }
        bp +='</BusinessName>';
		if(oa.Federal_Tax_ID__c != null){
		bp +='<TaxIDInfo><Number>'+ oa.Federal_Tax_ID__c.replaceAll('\\D','') +'</Number></TaxIDInfo>';
		}
		
        bp +='<CurrentAddress>';
        bp +='<Street>';
        if(oa.Business_Street_Address__c == null){
            bp += 'null';
        }
        else{
             bp += oa.Business_Street_Address__c;
        }
        bp += '</Street>';
        bp +='<City>';
        if(oa.City__c == null){
            bp+= 'null';
        }
        else{
            bp+= oa.City__c;
        }
        bp +='</City>';
        bp +='<State>';
        if(oa.State__c ==null){
            bp += 'null';
        }
        else{
            bp += oa.State__c;
        }
        bp += '</State>';
        bp +='<Zip>';
        if(String.valueOf(oa.Zip_Code__c) == null){
            bp += 'null';
        } 
        else{
            bp += String.valueOf(oa.Zip_Code__c).substring(0,5) ;
        }
        bp +='</Zip>';
        bp +='</CurrentAddress>';
		if(oa.Phone_Number__c != null){
			bp +='<Phone><Number>'+oa.Phone_Number__c.replaceAll('\\D','')+'</Number></Phone>';
		}
		
        bp +='</BusinessApplicant>';

		System.debug('out put for setBusinessPrincipal: ' + bp );
        return bp;

    }

    public static BizIdWithScore parseBizIdWithScoreStream(XmlStreamReader reader, OnlineApplication__c oa){

        BizIdWithScore bizScore = new BizIdWithScore();
        boolean isSafeToGetNextXmlElement = true;
        while(isSafeToGetNextXmlElement) {
            // Start at the beginning of the BizIdWithScore and make sure that it is a BizIdWithScore
            if (reader.getEventType() == XmlTag.START_ELEMENT) {
                if ('CompletionCode' == reader.getLocalName()) {
                    reader.next();
                    if(reader.getEventType() == XmlTag.CHARACTERS){
                        oa.Net_Connect_Completion_Code__c = reader.getText();
                    }
                }
                else if('ErrorMessage' == reader.getLocalName()){
                    reader.next();
                    if(reader.getEventType() == XmlTag.CHARACTERS)
                    oa.Net_Connect_Error_Description__c = reader.getText();
                }
                else if('ErrorTag' == reader.getLocalName()){
                    reader.next();
                    if(reader.getEventType() == XmlTag.CHARACTERS)
                    oa.Net_Connect_Error_Tag__c = reader.getText();
                }
                else if('ErrorCode' == reader.getLocalName()){
                    reader.next();
                    if(reader.getEventType() == XmlTag.CHARACTERS)
                    oa.BizID_Error_Code__c = reader.getText();  
                }
                else if('Error' == reader.getLocalName()){
                    reader.next();
                    if(reader.getEventType() == XmlTag.CHARACTERS)
                    oa.BizID_Error_Description__c = reader.getText();
                }
                else if ('Decision' ==reader.getLocalName()) {
                    reader.next();
                    if(reader.getEventType() == XmlTag.CHARACTERS){
                    bizScore.decision = reader.getText().subString(0,3).toUpperCase();
                    }
                }
                else if ('OFACCode' ==reader.getLocalName()) {
                        bizScore.ofacCode = reader.getAttributeValue(null, 'code');
                }
                else if ('Score' ==reader.getLocalName()) {
                    reader.next();
                    if(reader.getEventType() == XmlTag.CHARACTERS){
                        bizScore.score = Integer.valueOf(reader.getText());
                    }
                }
                else if ('ReportDate' ==reader.getLocalName()) {
                    reader.next();
                    if(reader.getEventType() == XmlTag.CHARACTERS){
                        String dateString = reader.getText();
                        bizScore.transactionDate = Date.newInstance(Integer.valueOf(dateString.subString(4)), Integer.valueOf(dateString.substring(0,2)), Integer.valueOf(dateString.subString(3,5)));
                    }
                }
                else if ('TransactionId' ==reader.getLocalName()) {
                    reader.next();
                    if(reader.getEventType() == XmlTag.CHARACTERS){
                        bizScore.transactionId = reader.getText();
                    }
                }
                else if ('ReportTime' ==reader.getLocalName()) {
                    reader.next();
                    if(reader.getEventType() == XmlTag.CHARACTERS){
                        String transactionTime = reader.getText();
                        bizScore.transactionDateTime = parseTime(transactionTime);
                    }
                }     
            }
            // Always use hasNext() before calling next() to confirm 
            // that we have not reached the end of the stream
            if (reader.hasNext()) {
                reader.next();
            } else {
                isSafeToGetNextXmlElement = false;
                break;
            }
        }
        return bizScore;
    }

    public static String parseTime(String transactionTime){
        String timeFormat = '';
        Integer hours = Integer.valueOf(transactionTime.subString(0,2));
        Integer minutes = Integer.valueOf(transactionTime.substring(3,5));
        timeFormat = String.valueOf(hours) + ':' + String.valueOf(minutes);
        if(hours < 12){
            timeFormat += ' AM';
        }
        else{
            timeFormat += ' PM';
        }

        return timeFormat;
    }


    public class BizIdWithScore{
        String decision;
        String ofacCode;
        Integer score;
        Date transactionDate;
        String transactionId;
        String transactionDateTime;
        String adverseActionCode;
        String creditDecision;
        String riskGrade;
        String riskGradeSource;
        String addressVerification;
        Id accountId;
        Id onlineApplicationId;
    }

    //maps fields relevant to dml inserts
    public static ExperianBizID__c mapInsertFields(BizIdWithScore bis){

        ExperianBizID__c epz = new ExperianBizID__c();
        if(bis.decision !=null){
            if(bis.decision.toUpperCase() == 'DEC'){
            epz.Decision__c = 'REF';
            }
            else{
                epz.Decision__c  = bis.decision;
            }
        }
        epz.OFACCode__c = bis.ofacCode;
        epz.Score__c = bis.score;
        epz.Transaction_Date__c = bis.transactionDate;
        epz.Transaction_Id__c = bis.transactionId;
        epz.Transaction_Time__c  = bis.transactionDateTime;
        epz.Account__c= bis.accountId ;
        epz.Online_Application__c = bis.onlineApplicationId;

        return epz;
    }

    //maps fields relevant to dml updates
    public static void mapUpdatedFuelSelectFields(OnlineApplication__c oa){

        oa.Risk_Grade__c = '0';
        oa.Risk_Grade_Source__c = 'Pre-Paid Secured';

    }
    
    /*Modified by Trekbin on 01 June, 2016 for Case 00025666*/ 
    public static void mapFuelSelectACCFields(OnlineApplication__c oa){

        oa.Status__c = 'Decisioned';
        oa.Credit_Decision__c = 'Approved-Secured Requested';
        oa.Decision_Comments__c = 'Passed BizID verification. Okay to setup.';
        oa.Cash_products_allowed__c = 'Yes';
        oa.Address_Verification_Source__c = 'BizID-Pass';

    }
    
    /*Modified by Trekbin on 01 June, 2016 for Case 00025666*/ 
    public static void mapFuelSelectDECFields(OnlineApplication__c oa){

        oa.Status__c = 'Decisioned';
        oa.Credit_Decision__c = 'Declined';
        oa.Decision_Comments__c = 'Failed BizID verification.';
        oa.Adverse_action_code__c = 'F5';
        oa.Address_Verification_Source__c = 'BizID-Fail';

    }

    public static void mapNonFuelSelectACCFields(OnlineApplication__c oa){

        oa.Address_Verification_Source__c = 'BizID-Pass';

    }

    public static void mapNonFuelSelectDECFields(OnlineApplication__c oa){

        oa.Address_Verification_Source__c = 'BizID-Fail';

    }

    private static Experian_BizID_Login__mdt getExperianCredentials(){

        return [SELECT Id, EAI__c, DBHost__c, Endpoint__c, OpInitials__c, Password__c, Preamble__c, Subcode__c, User_ID__c, BizID_Public_Group__c FROM Experian_BizID_Login__mdt LIMIT 1][0];
    }
    
    private static void sendErrorEmail(Id groupId){

        //send emailmessage
        //template name bizid_errors

    }
    
    /*Modified by Trekbin on 01 June, 2016 for Case 00025666*/ 
    private static List<OnlineApplication__c> getOnlineApplicationsToUpdate(List<Id> recordIds){
        return [SELECT Id,Application_Stage__c,Legal_Business_Name__c,Business_Street_Address__c, City__c, State__c, Zip_Code__c, Contact_Name__c, Account__c,
                       AO_Address__c, AO_City__c, AO_State__c,AO_Zip_Code__c, Offer__r.Name, Experian_BizID_with_Score__r.Decision__c, Net_Connect_Completion_Code__c, 
                       Net_Connect_Error_Description__c, Net_Connect_Error_Tag__c, BizID_Error_Code__c, BizID_Error_Description__c, Prepaid__c,
					   Federal_Tax_ID__c, AO_Date_of_Birth__c ,AO_Social_Security_Number__c, Phone_Number__c 
                FROM OnlineApplication__c WHERE Id IN:recordIds];   
    }


    
    /*  
        Method      : stampPartnerUserDetails
        Parameters  : old and new Online Applications
        Description 
                    * On insert if the CreatedById user is Partner community user then stamp user Contact and Account values on Online Application EXtrenal Account and Contact
                    * On update of owner field  if the Owner is Partner community user then stamp user Contact and Account values on Online Application EXtrenal Account and Contact
    
    */
    
    public void stampPartnerUserDetails(Map<Id,OnlineApplication__c> mapOldOnlineApplication, List<OnlineApplication__c> listOnlineApplication) {
        
        Set<Id> setOApplicationCreatedUserIds = new Set<Id>();   
        Map<Id,Id> mapOApplicationIdToOwner = new Map<Id,Id>();
        Map<Id, User> mapPartnerUserIdToObj = new Map<Id, User>();
        
        // iterate over map to get the ownerId's of OnlineApplication
        for(OnlineApplication__c objApplication : listOnlineApplication) 
        {
            if(Trigger.isInsert) 
                setOApplicationCreatedUserIds.add(objApplication.CreatedById);
            else if(Trigger.isUpdate)
            {
                if(mapOldOnlineApplication.get(objApplication.Id).OwnerId != objApplication.OwnerId) 
                    mapOApplicationIdToOwner.put(objApplication.Id, objApplication.OwnerId);
            }
        }
       
        
        // SWF 12/11/15 - 
        // in a simple test, this query executes 16 times fo rno reason
        if(setOApplicationCreatedUserIds.size() == 0 && mapOApplicationIdToOwner.size() == 0)
        {
            return;
        }
        
        
        // Query the Users  related to OnlineApplication
        for(User objuser : [SELECT Id, AccountId, ContactId
                            FROM User 
                            WHERE (Id IN : setOApplicationCreatedUserIds OR Id IN : mapOApplicationIdToOwner.values())
                            AND IsActive = true
                            AND AccountId != null 
                            AND ContactId != null ]) 
        {
            // check for partner users                  
            mapPartnerUserIdToObj.put(objuser.Id, objuser); 
        }   
   
        
        //iterate over  map to update the fields on OnlineApplication with Running users Partner Account and Running users Partner Contact
        //SWF 12/11/15 
        // if the mapPartnerUserIdToObj is empty, this is is a wate of time, add a check
        if(mapPartnerUserIdToObj.size() == 0)
        {
            return;
        }
        
        for(OnlineApplication__c objApplication : listOnlineApplication) 
        {
            if(trigger.isInsert) 
            { 
                if(mapPartnerUserIdToObj.containskey(objApplication.CreatedById)) 
                {    
                    objApplication.Referred_by_External_Account__c = mapPartnerUserIdToObj.get(objApplication.CreatedById).AccountId;
                    objApplication.External_Referred_By_Contact__c = mapPartnerUserIdToObj.get(objApplication.CreatedById).ContactId;
                }
            }
            else if(trigger.isUpdate)
            {
                 if(mapPartnerUserIdToObj.containskey(objApplication.OwnerId)) 
                 {   
                    objApplication.Referred_by_External_Account__c = mapPartnerUserIdToObj.get(objApplication.OwnerId).AccountId;
                    objApplication.External_Referred_By_Contact__c = mapPartnerUserIdToObj.get(objApplication.OwnerId).ContactId;
                }
            }
            system.debug('!!!!!!!!!!!!!!!!!!! acc : ' + objApplication.Referred_by_External_Account__c);
            system.debug('!!!!!!!!!!!!!!!!!!! con : ' + objApplication.External_Referred_By_Contact__c);
        }
    }
    
     /*
        Method      : afterInsertAndUpdateOfOA
        Parameters  : old and new Online Applications
        Description 
                    * On insert if the created by user and owner is different then create sharing record and share with that created by user
                    * On update of owner field check if the old owner is partner then share the record with him
                    * On update of External contact share the record with new contact and delete the sharing record of old external contact
    
    */
      public void afterInsertAndUpdateOfOA( Map<Id,OnlineApplication__c> mapOldOnlineApplication,  Map<Id,OnlineApplication__c> mapNewOnlineApplication) {
        
        List<OnlineApplication__Share> lstSharingRecordsToDelete = new List<OnlineApplication__Share>();
        List<OnlineApplicationOffer__Share> lstOfferSharingRecordsToDelete = new List<OnlineApplicationOffer__Share>();
        
        Set<Id> setPartnerAccountIds = new Set<Id>();
        Set<Id> setOfExternalContactId = new Set<Id>();
        Set<Id> setChnagedOwnerId = new Set<Id>();
        Set<Id> setOldOwnerIds = new Set<Id>();
        
        Map<Id,Id> mapContactIdToUserId = new Map<Id,Id>();
        Map<Id, User> mapUserIdToUser = new Map<Id,User>(); 
        Map<Id,Id> mapUserIdToAccountId = new Map<Id,Id>();
        Map<Id,Id> mapOfOAIdToCreatedById = new Map<Id,Id>();
        Map<Id, Id> mapOnlineAppIdToPartnerId = new Map<Id,Id>();
        Map<Id, Id> mapOApplicationOfferToPartnerUser = new Map<Id, Id>();
        //Map<Id, Id> mapOfAppIdToExternalContactToUpdate = new Map<Id, Id>();
        
        Map<Id,Id> mapOApplicationIdToOldContact = new Map<Id,Id>();
        Map<Id,Id> mapOApplicationOfferIdToOldContact = new Map<Id,Id>();
        
        //iterate over map to get the ownerId's of OnlineApplication
        for(OnlineApplication__c objApplication : mapNewOnlineApplication.values()) {
            
            if(Trigger.isInsert) {  
                  
                if(objApplication.CreatedById != objApplication.OwnerId)  // only if the created user and owner are different
                    mapOfOAIdToCreatedById.put(objApplication.Id, objApplication.CreatedById );
            }
            
             if(trigger.isupdate) {
                
                if(mapOldOnlineApplication.get(objApplication.Id).External_Referred_By_Contact__c != objApplication.External_Referred_By_Contact__c) {
                    
                    if(mapOldOnlineApplication.get(objApplication.Id).External_Referred_By_Contact__c != NULL) {
                        
                        setOfExternalContactId.add(mapOldOnlineApplication.get(objApplication.Id).External_Referred_By_Contact__c);
                    } 
                    if(objApplication.External_Referred_By_Contact__c != NULL) {
                        
                        setOfExternalContactId.add(objApplication.External_Referred_By_Contact__c);
                    }
                }
                //add ownerIds to list
                if(objApplication.OwnerId != mapOldOnlineApplication.get(objApplication.Id).OwnerId) {
                    
                    setOldOwnerIds.add(mapOldOnlineApplication.get(objApplication.Id).OwnerId);
                    setChnagedOwnerId.add(objApplication.OwnerId);
                }
            }
        }
       /* if(Test.isRunningTest()) { 
            
             List<User> lstUsers = [ Select Id, ContactId,AccountId from User where ContactId != null and isActive = true limit 1];
            
            //User objUser = createTestUser();
            
            // check for partner users                  
            mapContactIdToUserId.put(lstUsers[0].ContactId, lstUsers[0].Id);
            system.debug('!!!!!!!!!!!!!!!!!!!!!!!!!! SIZE 2 : ' + lstUsers.size());
            
         } else {*/
            
         // SWF 12/11/15
         if(setOfExternalContactId.size() > 0)
         {
            // iterating over user to get the account id
            for(User  objuser :[    SELECT Id,AccountId,ContactId
                                    FROM User
                                    WHERE ContactId IN : setOfExternalContactId]) {
                                        
                mapContactIdToUserId.put(objuser.ContactId, objuser.Id);
            }
         }  
            
     //   }
        
       /*  if(Test.isRunningTest()) {  
            
             List<User> lstUsers = [ Select Id,ContactId, AccountId from User where ContactId != null and AccountId != null and isActive = true limit 1];
             // User objUser = createTestUser();
              mapUserIdToAccountId.put(lstUsers[0].Id, lstUsers[0].AccountId);
              mapUserIdToUser.put(lstUsers[0].Id, lstUsers[0]);
            system.debug('!!!!!!!!!!!!!!!!!!!!!!!!!! SIZE 3 : ' + lstUsers.size());
         }else {*/
             
        //SWF 12/1/15 
        if(mapOfOAIdToCreatedById.size() > 0 || setChnagedOwnerId.size() > 0 || setOldOwnerIds.size() > 0 || mapContactIdToUserId.size() > 0)    
        {         
            // Get all users who created Online Applications
            for(User objuser : [  SELECT Id, AccountId, ContactId
                                  FROM User 
                                  WHERE isActive = true AND (Id IN : mapOfOAIdToCreatedById.values() OR Id IN : setChnagedOwnerId OR Id IN : setOldOwnerIds OR Id IN : mapContactIdToUserId.values())]) { // update owner
                // if Partner users will Account
                // SWF 12/11/15 Why is this not a part of the query if it must be populated?
                if(objuser.AccountId != null) 
                {                         
                    mapUserIdToAccountId.put(objuser.Id, objuser.AccountId);
                    mapUserIdToUser.put(objuser.Id, objuser);
                }
            }
        }
    //    }
        
       if(mapUserIdToAccountId.size() > 0)
       {
        // Cross verify whether the user is Partner user or not                      
        for(Account objAccount : [  SELECT Id, IsPartner 
                                    FROM Account
                                    WHERE Id IN : mapUserIdToAccountId.values()]) 
        {
            //SWF 12/11/15 why is this not a part of the query
            if(objAccount.IsPartner) 
            {
                setPartnerAccountIds.add(objAccount.Id);
            }
        }
       }
        
        //iterate over  map to update the fields on OnlineApplication with Running users Partner Account and Running users Partner Contact
        for(OnlineApplication__c objApplication : mapNewOnlineApplication.values()) {
            
            Id userId = objApplication.CreatedById;
            
            if(trigger.isUpdate) 
                userId = mapOldOnlineApplication.get(objApplication.Id).OwnerId;
                
                if(trigger.isInsert) {
                    
                    if( mapUserIdToUser.containskey(userId)  
                     && mapUserIdToAccountId.containskey(userId)
                     && setPartnerAccountIds.contains(mapUserIdToAccountId.get(userId))) {
                        
                         if(objApplication.Offer__c != null ) // Share Read access to online Application Offer record
                            mapOApplicationOfferToPartnerUser.put(objApplication.Offer__c,  userId);
                        // create online application share record
                        mapOnlineAppIdToPartnerId.put(objApplication.Id, userId);
                     }
            }
                
            if(trigger.isUpdate && objApplication.OwnerId != mapOldOnlineApplication.get(objApplication.Id).OwnerId) { // owner change, create share record
                    
                 if( mapUserIdToUser.containskey(userId)  
                     && mapUserIdToAccountId.containskey(userId)
                     && setPartnerAccountIds.contains(mapUserIdToAccountId.get(userId))) {
                     
                     // create sharing record 
                     if(objApplication.Offer__c != null) // Share Read access to online Application Offer record
                        mapOApplicationOfferToPartnerUser.put(objApplication.Offer__c,  userId);
                    // creat online application share record
                    mapOnlineAppIdToPartnerId.put(objApplication.Id, userId);
                }
            } 
            if(Trigger.isUpdate) {
                
                Id oldExternalContact, newExternalContact;
                
                oldExternalContact = mapOldOnlineApplication.get(objApplication.Id).External_Referred_By_Contact__c;
                newExternalContact = objApplication.External_Referred_By_Contact__c;
                // external Contact
                if(oldExternalContact != newExternalContact) {
                    
                    if(newExternalContact != null && mapContactIdToUserId.containskey(newExternalContact)  
                     && mapContactIdToUserId.get(newExternalContact) != objApplication.OwnerId
                     && mapUserIdToAccountId.containskey(mapContactIdToUserId.get(newExternalContact))
                     && setPartnerAccountIds.contains(mapUserIdToAccountId.get(mapContactIdToUserId.get(newExternalContact)))) { //&& mapContactIdToUserId.get(newExternalContact) != objApplication.OwnerId 
                        
                         // create sharing record 
                        if(objApplication.Offer__c != null) // Share Read access to online Application Offer record
                            mapOApplicationOfferToPartnerUser.put(objApplication.Offer__c,  mapContactIdToUserId.get(newExternalContact));
                    
                        mapOnlineAppIdToPartnerId.put(objApplication.Id, mapContactIdToUserId.get(newExternalContact));
                        // map to update Online applications
                    }
                    // delete if the contact user is not current owner or old owner then delete
                   if( oldExternalContact != NULL && mapContactIdToUserId.containskey(oldExternalContact)
                        && mapContactIdToUserId.get(oldExternalContact) != objApplication.OwnerId
                        && mapContactIdToUserId.get(oldExternalContact) != mapOldOnlineApplication.get(objApplication.Id).OwnerId
                        && mapUserIdToAccountId.containskey(mapContactIdToUserId.get(oldExternalContact))
                        && setPartnerAccountIds.contains(mapUserIdToAccountId.get(mapContactIdToUserId.get(oldExternalContact)))) {
                        
                        // add online app id and old conatct  
                        mapOApplicationIdToOldContact.put(objApplication.Id, mapContactIdToUserId.get(oldExternalContact));
                        mapOApplicationOfferIdToOldContact.put(objApplication.Offer__c, mapContactIdToUserId.get(oldExternalContact));
                    }
                }
            }
        }
        
        //SWF 12/11/15 
        if(mapOApplicationIdToOldContact.size() > 0 &&  mapOApplicationIdToOldContact.size() > 0)
        {
            // Execute only if External contact is changes 
            for(OnlineApplication__Share objsharing : [ SELECT Id,ParentId,UserOrGroupId 
                                                        FROM OnlineApplication__Share
                                                        WHERE ParentId IN : mapOApplicationIdToOldContact.keyset()
                                                        AND UserOrGroupId IN : mapOApplicationIdToOldContact.values()  ]) {
                                                                
                    lstSharingRecordsToDelete.add(objsharing);
                    
            }
        }
        
        
        if(mapOApplicationOfferIdToOldContact.size() > 0 && mapOApplicationOfferIdToOldContact.size() > 0)
        {
             // Execute only if External contact is changes 
            for(OnlineApplicationOffer__Share objOffersharing : [ SELECT Id,ParentId,UserOrGroupId 
                                                                  FROM OnlineApplicationOffer__Share
                                                                  WHERE ParentId IN : mapOApplicationOfferIdToOldContact.keyset()
                                                                  AND UserOrGroupId IN : mapOApplicationOfferIdToOldContact.values()  ]) {
                                                                
                  lstOfferSharingRecordsToDelete.add(objOffersharing);
            }
        }
        
        if(!lstOfferSharingRecordsToDelete.isEmpty())
            delete lstOfferSharingRecordsToDelete;
            
        if(!lstSharingRecordsToDelete.isEmpty())
            delete lstSharingRecordsToDelete;
            
        if(!mapOApplicationOfferToPartnerUser.isEmpty())
            UCreateAccountShareRecords.createOnlineApplicationOfferShareForCommunityUsers(mapOApplicationOfferToPartnerUser);
        
        if(!mapOnlineAppIdToPartnerId.isEmpty())
            UCreateAccountShareRecords.createOnlineApplicationForCommunityUsers(mapOnlineAppIdToPartnerId);
       
    }
     

}