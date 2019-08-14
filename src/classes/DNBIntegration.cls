public with sharing class DNBIntegration {
    public static final Integer BATCH_SIZE = 4;
    public static Boolean storeAuthToken;
    public static Set<Id> processedIds = new Set<Id> ();


    public static void getFailureScoreAndRisk(Set<Id> reqIds) {
        List<Id> records = new List<Id>(reqIds);
        for (Integer i = 0; i<(records.size() / BATCH_SIZE) + 1; i++) {
            Set<Id> batchIds = new Set<Id> ();
            for (Integer j = i * BATCH_SIZE; (j<(i * BATCH_SIZE) + BATCH_SIZE) && (j<records.size()); j++) {
                batchIds.add(records.get(j));
            }

            if (!batchIds.isEmpty()) {
                doCalloutsAsync(batchIds);
            }
        }
    }

    @future(callout = true)
    public static void doCalloutsAsync(Set<Id> batchIds) {
        doCallouts(batchIds);
    }

    public static void doCallouts(Set<Id> batchIds) {

        String authToken = getAuthenticationToken();

        List<WES_Application_Request__c> reqList = new List<WES_Application_Request__c> ();

        for (WES_Application_Request__c req : [SELECT Company_Reg_Num__c, DNB_Risk__c, DNB_Failure_Score__c FROM WES_Application_Request__c WHERE Id IN :batchIds]) {

            if (req.Company_Reg_Num__c!=null) {
                //String DUNSNumber = getDUNSNumber(req.Company_Reg_Num__c, authToken);
                String DUNSNumber = '804735132';
                if (String.isNotEmpty(DUNSNumber)) {
                    getFailureScoreAndRisk(DUNSNumber, req, authToken);
                    reqList.add(req);
                }
            }
        }

        //perform DML after callouts
        if (!reqList.isEmpty()) {
            update reqList;
        }

        if (storeAuthToken==true) {
            upsert new DNB_Integration_Settings__c(Name='Auth_Token', Authentication_Token__c = authToken) Name;
        }
    }

    private static String getAuthenticationToken() {
        String authToken;
        Datetime dt = Datetime.now().addHours(-23);
        List<DNB_Integration_Settings__c> tokenList = [SELECT Authentication_Token__c FROM DNB_Integration_Settings__c WHERE Name = 'Auth_Token' AND LastModifiedDate > :dt];
        if (!tokenList.isEmpty()) {
            authToken = tokenList[0].Authentication_Token__c;
        } else {
            String dnbUserName;
            String dnbPwd;
            for (DNB_Integration__mdt mdt : [SELECT MasterLabel, Value__c FROM DNB_Integration__mdt]) {
                if (mdt.MasterLabel=='x-dnb-user') {
                    dnbUserName = mdt.Value__c;
                }
                if (mdt.MasterLabel=='x-dnb-pwd') {
                    dnbPwd = mdt.Value__c;
                }
            }

            HttpRequest req = new HttpRequest();
            req.setEndpoint('callout:DNB_Authentication');

            req.setHeader('x-dnb-user', dnbUserName);
            req.setHeader('x-dnb-pwd', dnbPwd);

            req.setMethod('POST');
            Http http = new Http();
            try {
                HTTPResponse res = http.send(req);
                DNBAuthenticationResponse authResponse = DNBAuthenticationResponse.parse(res.getBody());
                authToken = authResponse.AuthenticationDetail.Token;
                storeAuthToken = true;
            } catch (Exception e) {
                System.debug(e.getMessage());
            }
        }

        return authToken;
    }

    private static String getDUNSNumber(String companyRegNum, String authToken) {
        String DUNSNumber;
        HttpRequest req = new HttpRequest();
        req.setEndpoint('callout:DNB_DUNSNumber' + '?match=true&MatchTypeText=Basic&OrganizationIdentificationNumber=' + companyRegNum +'&CountryISOAlpha2Code=GB');

        req.setHeader('Authorization', authToken);

        req.setMethod('GET');
        Http http = new Http();
        try {
            HTTPResponse res = http.send(req);
            DNBDUNSNumberResponse dunsResponse = DNBDUNSNumberResponse.parse(res.getBody());
            DUNSNumber = dunsResponse.MatchResponse.MatchResponseDetail.MatchCandidate[0].DUNSNumber;
        } catch (Exception e) {
            System.debug(e.getMessage());
        }
        return DUNSNumber;
    }

    private static void getFailureScoreAndRisk(String DUNSNumber, WES_Application_Request__c appReq, String authToken) {
        HttpRequest req = new HttpRequest();
        req.setEndpoint('callout:DNB_FailureScore/' + DUNSNumber + '/products/PBPR_STD');

        req.setHeader('Authorization', authToken);

        req.setMethod('GET');
        Http http = new Http();
        try {
            HTTPResponse res = http.send(req);
            DNBFailureScoreRiskResponse riskResponse = DNBFailureScoreRiskResponse.parse(res.getBody());
            appReq.DNB_Risk__c = Integer.valueOf(riskResponse.OrderProductResponse.OrderProductResponseDetail.Product.Organization.Assessment.FinancialStressScore[0].ClassScore);
            appReq.DNB_Failure_Score__c = riskResponse.OrderProductResponse.OrderProductResponseDetail.Product.Organization.Assessment.FinancialStressScore[0].NationalPercentile;
        } catch (Exception e) {
            System.debug(e.getMessage());
        }
    }

    public static void getBusinessReport(Set<Id> creditDetailsIds) {
        List<Id> records = new List<Id>(creditDetailsIds);
        for (Integer i = 0; i<(records.size() / BATCH_SIZE) + 1; i++) {
            Set<Id> batchIds = new Set<Id> ();
            for (Integer j = i * BATCH_SIZE; (j<(i * BATCH_SIZE) + BATCH_SIZE) && (j<records.size()); j++) {
                batchIds.add(records.get(j));
            }

            if (!batchIds.isEmpty()) {
                doBusinessReportCallouts(batchIds);
            }
        }
    }

    @future(callout = true)
    public static void doBusinessReportCallouts(Set<Id> batchIds) {

        String authToken = getAuthenticationToken();

        Map<Id, String> pdfMap = new Map<Id, String>();

        for (WES_Credit_Details__c det : [SELECT WES_Application_Request__r.Company_Reg_Num__c FROM WES_Credit_Details__c WHERE Id IN :batchIds]) {

            if (det.WES_Application_Request__r.Company_Reg_Num__c!=null) {
                //String DUNSNumber = getDUNSNumber(det.WES_Application_Request__r.Company_Reg_Num__c, authToken);
                String DUNSNumber = '804735132';
                if (String.isNotEmpty(DUNSNumber)) {
                    String pdfContent = getBusinessReport(DUNSNumber, authToken);
                    pdfMap.put(det.Id, pdfContent);
                }
            }
        }

        //perform DML after callouts
        Map<Id, ContentVersion> creditDetailsFileMap = new Map<Id, ContentVersion>();
        for (Id detId : pdfMap.keySet()) {
            ContentVersion v = new ContentVersion();
            v.versionData = EncodingUtil.base64Decode(pdfMap.get(detId));
            v.title = 'Business Report';
            v.pathOnClient ='/BusinessReport.pdf';
            creditDetailsFileMap.put(detId, v);
        }

        if (!creditDetailsFileMap.isEmpty()) {
            insert creditDetailsFileMap.values();
            
            Map<Id, Id> fileIdsMap = new Map<Id, Id>();

            for (Id detId : creditDetailsFileMap.keySet()) {
                fileIdsMap.put(creditDetailsFileMap.get(detId).Id, detId);
            }

            Map<Id, ContentVersion> cvMap = new Map<Id, ContentVersion>([SELECT Id, ContentDocumentId FROM ContentVersion WHERE Id IN :fileIdsMap.keySet()]);

            List<ContentDocumentLink> cdLinkList = new List<ContentDocumentLink>();
            for (Id cvId : cvMap.keySet()) {
                ContentDocumentLink  cdLink = new ContentDocumentLink();
                cdLink.ContentDocumentId = cvMap.get(cvId).ContentDocumentId;
                cdLink.LinkedEntityId = fileIdsMap.get(cvId);
                cdLink.ShareType = 'I';
                cdLinkList.add(cdLink);
            }

            insert cdLinkList;
        }

        if (storeAuthToken==true) {
            upsert new DNB_Integration_Settings__c(Name='Auth_Token', Authentication_Token__c = authToken) Name;
        }
    }

    private static String getBusinessReport(String DUNSNumber, String authToken) {
        HttpRequest req = new HttpRequest();
        req.setEndpoint('callout:DNB_BusinessReport/' + DUNSNumber + '/products/BIR?ProductFormatPreferenceCode=13204');

        req.setHeader('Authorization', authToken);

        req.setMethod('GET');

        String pdfContent;
        Http http = new Http();
        try {
            HTTPResponse res = http.send(req);
            DNBBusinessReportResponse reportResponse = DNBBusinessReportResponse.parse(res.getBody());
            pdfContent = reportResponse.OrderCompanyReportResponse.OrderCompanyReportResponseDetail.Product.ObjectAttachment[0].ContentObject;
        } catch (Exception e) {
            System.debug(e.getMessage());
        }
        return pdfContent;
    }
}