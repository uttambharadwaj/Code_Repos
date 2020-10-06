public class Calabrio_IntegrationHelper {
   
    /**
    *   {Purpose} - Method to return the beginning Date/Time for an Interval.
    *
    *   CHANGE HISTORY
    *   ============================================================================
    *   Date        Name                    Description
    *   20180330    Calabrio                Created
    *   ============================================================================
    **/
    /*public static Datetime getIntervalBeginDatetime(Datetime dateTimeValue) {

        DateTime returnDateTime = null;

        Integer currentMinute = dateTimeValue.minute();
        Integer minuteDifference = currentMinute;
        if (currentMinute < 30) {
            minuteDifference = (currentMinute+30);
        }
        Datetime beginDatetime = dateTimeValue.addMinutes(-minuteDifference);

        returnDateTime = Datetime.newInstance(beginDatetime.year(), beginDatetime.month(), beginDatetime.day(), beginDatetime.hour(), beginDatetime.minute(), 0);

        return returnDateTime;

    } // End Method: getIntervalBeginDatetime()

    /**
    *   {Purpose} - Method to return the appropriately formatted TimeZone Offset.
    *
    **/
    public static String getFormattedTimeZoneOffset() {

        String formattedTZOffset;

//      Timezone tz = Timezone.getTimeZone(timeZoneString);
        Timezone tz = UserInfo.getTimeZone();

        // Create a date before the 2007 shift of DST into November
        Datetime currentDatetime = Datetime.now();
        Datetime baseDateTime = Datetime.newInstanceGMT(currentDatetime.year(), currentDatetime.month(), currentDatetime.day(), currentDatetime.hour(), currentDatetime.minute(), currentDatetime.second());
        //Datetime baseDateTime = Datetime.newInstanceGMT(2000, 11, 1, 0, 0, 0);

        Integer timeZoneOffset = (tz.getOffset(baseDateTime) / (60 * 60 * 1000));
System.debug('Timezone offset ' + timeZoneOffset);
        if (timezoneOffset < 0) {
            String tempTZOffset = timeZoneOffset.format();
            tempTZOffset = tempTZOffset.substringAfter('-');
            formattedTZOffset = 'N0' + tempTZOffset + '00';
        }
        else {
            String tempTZOffset = timeZoneOffset.format();
            formattedTZOffset = 'P0' + tempTZOffset + '00';
        }

        return formattedTZOffset;

    } // End Method: getTimeZoneOffset()

    /**
    *   {Purpose} - Method to return an Agent Status-to-State Map.
    *
    *   CHANGE HISTORY
    *   ============================================================================
    *   Date        Name                    Description
    *   20180408    Calabrio                Created
    *   ============================================================================
    **/
   /* public static Map<Integer,Integer> getAgentStateMapping() {

        Map<Integer,Integer> returnMap = new Map<Integer,Integer>();

        // Status = 0 (Available) --> AgentState = 3 (Ready)
        returnMap.put(0,3);

        // Status = 1 (Break) --> AgentState = 2 (Not Ready)
        returnMap.put(1,2);

        // Status = 2 (Gone) --> AgentState = 1 (Logout)
        returnMap.put(2,1);

        // Status = 3 (Project) --> AgentState = 2 (Not Ready)
        returnMap.put(3,2);

        // Status = 4 (Esc) --> AgentState = 2 (Not Ready)
        returnMap.put(4,2);

        // Status = 5 (Duties) --> AgentState = 2 (Not Ready)
        returnMap.put(5,2);

        // Status = 6 (Slow) --> AgentState = 3 (Ready)
        returnMap.put(6,3);

        // Status = 7 (Phone) --> AgentState = 4 (Talking)
        returnMap.put(7,4);

        // Status = 8 (Limit) --> AgentState = 4 (Talking)
        returnMap.put(8,4);

        // Status = 9 (Meeting) --> AgentState = 2 (Not Ready)
        returnMap.put(9,2);

        return returnMap;

    } // End Method: getAgentStateMapping()

    /**
    *   {Purpose} - Method to return a User-to-Case-to-EmailMessage (List) Map for
    *               a Set of Users (Ids).
    *
    *   CHANGE HISTORY
    *   ============================================================================
    *   Date        Name                    Description
    *   20180324    Calabrio                Created
    *   ============================================================================
    **/
    /*public static Map<Id,Map<Id,List<EmailMessage>>> getUserCaseEmailMessageListMap(Set<Id> userIdSet, Datetime startDateTime) {

        Map<Id,Map<Id,List<EmailMessage>>> returnMap = new Map<Id,Map<Id,List<EmailMessage>>>();

        Datetime intervalBeginDatetime = startDateTime;
        Datetime intervalEndDatetime = startDateTime.addMinutes(30);

        for (EmailMessage em : [SELECT Id,
                                       ParentId,
                                       Incoming,
                                       CreatedById,
                                       CreatedDate
                                FROM   EmailMessage
                                WHERE  CreatedById IN :userIdSet
                                AND    Incoming = false
                                AND    ParentId != null
                                AND    CreatedDate >= :intervalBeginDatetime
                                AND    CreatedDate < :intervalEndDatetime
                                ORDER BY ParentId, CreatedDate ASC]) {

            if (!returnMap.containsKey(em.CreatedById)) {
                returnMap.put(em.CreatedById, new Map<Id,List<EmailMessage>>());
            }
            if (!returnMap.get(em.CreatedById).containsKey(em.ParentId)) {
                returnMap.get(em.CreatedById).put(em.ParentId, new List<EmailMessage>());
            }
            returnMap.get(em.CreatedById).get(em.ParentId).add(em);

        }

        return returnMap;

    } // End Method: getUserCaseEmailMessageListMap()

    /**
    *   {Purpose} - Method to return a User-to-Case-to-CaseHistory (List) Map for
    *               a Set of Users (Ids).
    *
    *   CHANGE HISTORY
    *   ============================================================================
    *   Date        Name                    Description
    *   20180324    Calabrio                Created
    *   ============================================================================
    **/
    /*public static Map<Id,Map<Id,List<CaseHistory>>> getUserCaseHistoryListMap(Set<Id> userIdSet, Datetime startDateTime) {

        Map<Id,Map<Id,List<CaseHistory>>> returnMap = new Map<Id,Map<Id,List<CaseHistory>>>();

        Datetime intervalBeginDatetime = startDateTime;
        Datetime intervalEndDatetime = startDateTime.addMinutes(30);

        for (CaseHistory ch : [SELECT Id,
                                      CaseId,
                                      CreatedById,
                                      CreatedDate,
                                      Field,
                                      OldValue,
                                      NewValue
                               FROM   CaseHistory
                               WHERE  CreatedById IN :userIdSet
                               AND    Field = 'Status'
                               AND    CreatedDate >= :intervalBeginDatetime
                               AND    CreatedDate < :intervalEndDatetime
                               ORDER BY CreatedById, CaseId, CreatedDate]) {

            if (ch.OldValue == 'Call in Progress' || ch.NewValue == 'Call in Progress') {

                if (!returnMap.containsKey(ch.CreatedById)) {
                    returnMap.put(ch.CreatedById, new Map<Id,List<CaseHistory>>());
                }
                if (!returnMap.get(ch.CreatedById).containsKey(ch.CaseId)) {
                    returnMap.get(ch.CreatedById).put(ch.CaseId, new List<CaseHistory>());
                }
                returnMap.get(ch.CreatedById).get(ch.CaseId).add(ch);

            }

        }

        return returnMap;

    } // End Method: getUserCaseHistoryListMap()

    /**
    *   {Purpose} - Method to return a User-to-CaseGroup-to-Case (Set) Map for
    *               a Set of Users (Ids).
    *
    *   CHANGE HISTORY
    *   ============================================================================
    *   Date        Name                    Description
    *   20180324    Calabrio                Created
    *   ============================================================================
    **/
    /*public static Map<Id,Map<Id,Set<Id>>> getUserCaseGroupCaseSetMap(Map<Id,Set<Id>> userCaseSetMap,
                                                                     Map<Id,Case> caseMap,
                                                                     Map<Id,Set<Id>> userCaseGroupSetMap,
                                                                     Map<Id,List<Case_Group_Rule__c>> caseGroupRuleListMap) {

        Map<Id,Map<Id,Set<Id>>> returnMap = new Map<Id,Map<Id,Set<Id>>>();

        for (Id userId : userCaseSetMap.keySet()) {

            if (!returnMap.containsKey(userId)) {
                returnMap.put(userId, new Map<Id,Set<Id>>());
            }

            for (Id caseId : userCaseSetMap.get(userId)) {

                if (caseMap.containsKey(caseId)) {
                    
                    Case currentCase = caseMap.get(caseId);

                    List<Case_Group_Rule__c> matchingCGRList = new List<Case_Group_Rule__c>();
                    for (Id caseGroupId : userCaseGroupSetMap.get(userId)) {
                        if (caseGroupRuleListMap.containsKey(caseGroupId)) {
                            for (Case_Group_Rule__c cgr : caseGroupRuleListMap.get(caseGroupId)) {

                                if (doesCaseMatchRule(currentCase, cgr)) {
                                    matchingCGRList.add(cgr);
                                }
                            }
                        }
                    }

                    if (!matchingCGRList.isEmpty()) {

                        Id matchingCaseGroupId = null;
                        Decimal matchingCaseGroupTier = 0;
                        for (Case_Group_Rule__c cgr : matchingCGRList) {
                            Boolean updateMatching = false;
                            if (matchingCaseGroupId == null) {
                                updateMatching = true;
                            }
                            else {
                                if (cgr.Case_Group__r.Tier__c > matchingCaseGroupTier) {
                                    updateMatching = true;
                                }
                            }
                            if (updateMatching) {
                                matchingCaseGroupId = cgr.Case_Group__c;
                                matchingCaseGroupTier = cgr.Case_Group__r.Tier__c;
                            }
                        }

                        if (!returnMap.get(userId).containsKey(matchingCaseGroupId)) {
                            returnMap.get(userId).put(matchingCaseGroupId, new Set<Id>());
                        }
                        returnMap.get(userId).get(matchingCaseGroupId).add(currentCase.Id);

                    }
                }
            }
        }

        return returnMap;

    } // End Method: getUserCaseGroupCaseListMap()

    /**
    *   {Purpose} - Method to return a User-to-CaseGroup-to-Email Count Map.
    *
    *   CHANGE HISTORY
    *   ============================================================================
    *   Date        Name                    Description
    *   20180324    Calabrio                Created
    *   ============================================================================
    **/
    /*public static Map<Id,Map<Id,Integer>> getUserCaseGroupEmailCountMap(Map<Id,Map<Id,Set<Id>>> userCaseGroupCaseSetMap,
                                                                        Map<Id,Map<Id,List<EmailMessage>>> userCaseEMListMap) {

        Map<Id,Map<Id,Integer>> returnMap = new Map<Id,Map<Id,Integer>>();

        for (Id userId : userCaseGroupCaseSetMap.keySet()) {
            if (userCaseEMListMap.containsKey(userId)) {
                for (Id caseGroupId : userCaseGroupCaseSetMap.get(userId).keySet()) {
                    for (Id caseId : userCaseGroupCaseSetMap.get(userId).get(caseGroupId)) {
                        if (userCaseEMListMap.get(userId).containsKey(caseId)) {
                            for (EmailMessage emailMessage : userCaseEMListMap.get(userId).get(caseId)) {
                                if (!returnMap.containsKey(userId)) {
                                    returnMap.put(userId, new Map<Id,Integer>());
                                }
                                if (!returnMap.get(userId).containsKey(caseGroupId)) {
                                    returnMap.get(userId).put(caseGroupId, 0);
                                }
                                Integer emailCount = (returnMap.get(userId).get(caseGroupId) + 1);
                                returnMap.get(userId).put(caseGroupId, emailCount);
                            }
                        }

                    } // End for (Id caseId : userCaseGroupCaseSetMap.get(userId).get(caseGroupId))

                } // End for (Id caseGroupId : userCaseGroupCaseSetMap.get(userId).get(caseGroupId))

            } // End if (userCaseEMListMap.containsKey(userId))

        } // End for (Id userId : userCaseGroupCaseSetMap.keySet())

        return returnMap;

    } // End Method: getUserCaseGroupEmailCountMap()

    /**
    *   {Purpose} - Method to return a User-to-CaseGroup-to-Call Count Map.
    *
    *   CHANGE HISTORY
    *   ============================================================================
    *   Date        Name                    Description
    *   20180324    Calabrio                Created
    *   ============================================================================
    **/
    /*public static Map<Id,Map<Id,Integer>> getUserCaseGroupCallCountMap(Map<Id,Map<Id,Set<Id>>> userCaseGroupCaseSetMap,
                                                                       Map<Id,Map<Id,List<CaseHistory>>> userCaseCHListMap) {

        Map<Id,Map<Id,Integer>> returnMap = new Map<Id,Map<Id,Integer>>();

        for (Id userId : userCaseGroupCaseSetMap.keySet()) {
            if (userCaseCHListMap.containsKey(userId)) {
                for (Id caseGroupId : userCaseGroupCaseSetMap.get(userId).keySet()) {
                    for (Id caseId : userCaseGroupCaseSetMap.get(userId).get(caseGroupId)) {
                        if (userCaseCHListMap.get(userId).containsKey(caseId)) {
                            for (CaseHistory caseHistory : userCaseCHListMap.get(userId).get(caseId)) {
                                if (caseHistory.NewValue == 'Call in Progress') {
                                    if (!returnMap.containsKey(userId)) {
                                        returnMap.put(userId, new Map<Id,Integer>());
                                    }
                                    if (!returnMap.get(userId).containsKey(caseGroupId)) {
                                        returnMap.get(userId).put(caseGroupId, 0);
                                    }
                                    Integer callCount = (returnMap.get(userId).get(caseGroupId) + 1);
                                    returnMap.get(userId).put(caseGroupId, callCount);
                                }
                            }
                        }

                    } // End for (Id caseId : userCaseGroupCaseSetMap.get(userId).get(caseGroupId))

                } // End for (Id caseGroupId : userCaseGroupCaseSetMap.get(userId).keySet())

            } // End if (userCaseCHListMap.containsKey(userId))

        } // End for (Id userId : userCaseGroupCaseSetMap.keySet())

        return returnMap;
        
    } // End Method: getUserCaseGroupCallCountMap()

    /**
    *   {Purpose} - Method to return a User-to-CaseGroup-to-CallSeconds Map.
    *
    *   CHANGE HISTORY
    *   ============================================================================
    *   Date        Name                    Description
    *   20180324    Calabrio                Created
    *   ============================================================================
    **/
    /*public static Map<Id,Map<Id,Long>> getUserCaseGroupCallSecondsMap(Map<Id,Map<Id,Set<Id>>> userCaseGroupCaseSetMap,
                                                                      Map<Id,Map<Id,List<CaseHistory>>> userCaseCHListMap) {

        Map<Id,Map<Id,Long>> returnMap = new Map<Id,Map<Id,Long>>();

        for (Id userId : userCaseGroupCaseSetMap.keySet()) {
            if (userCaseCHListMap.containsKey(userId)) {
                for (Id caseGroupId : userCaseGroupCaseSetMap.get(userId).keySet()) {
                    for (Id caseId : userCaseGroupCaseSetMap.get(userId).get(caseGroupId)) {
                        if (userCaseCHListMap.get(userId).containsKey(caseId)) {

                            Datetime startDatetime = null;
                            Datetime endDatetime = null;
                            for (CaseHistory caseHistory : userCaseCHListMap.get(userId).get(caseId)) {

                                if (caseHistory.NewValue == 'Call in Progress') {
                                    startDatetime = caseHistory.CreatedDate;
                                }
                                else if (caseHistory.OldValue == 'Call in Progress' && caseHistory.NewValue != 'Updated by Customer') {
                                    if (!returnMap.containsKey(userId)) {
                                        returnMap.put(userId, new Map<Id,Long>());
                                    }
                                    if (!returnMap.get(userId).containsKey(caseGroupId)) {
                                        returnMap.get(userId).put(caseGroupId, 0);
                                    }
                                    if (startDatetime != null) {
                                        endDatetime = caseHistory.CreatedDate;
                                        Long secondsDifference = ((returnMap.get(userId).get(caseGroupId)) + ((endDatetime.getTime() - startDatetime.getTime()) / 1000));
                                        returnMap.get(userId).put(caseGroupId, secondsDifference);
                                    }
                                }
                            }
                        }

                    } // End for (Id caseId : userCaseGroupCaeSetMap.get(userId).get(caseGroupId))

                } // End for (Id caseGroupId : userCaseGroupCaseSetMap.get(userId).keySet())

            } // End if (userCaseCHListMap.containsKey(userId))

        } // End for (Id userId : userCaseGroupCaseSetMap.keySet())

        return returnMap;

    } // End Method: getUserCaseGroupCallSecondsMap()

    /**
    *   {Purpose} - Method to determine whether or not a Case matches a Rule. Pulled
    *               from Case_Train.cls.
    *
    *   CHANGE HISTORY
    *   ============================================================================
    *   Date        Name                    Description
    *   20180324    Calabrio                Created
    *   ============================================================================
    **/
    /*public static Boolean doesCaseMatchRule(Case c, Case_Group_Rule__c r) {

        sObject testCase = c; // cast the case as a generic sObject to allow for dynamic field retrieval

        if(r.Key_1__c != null && !doesPassTest(r.Value_1__c, (string.valueOf(testCase.get(r.Key_1__c))), r.Operation_1__c)) return false; // if the key exists and the value isn't a match, this rule failed
        if(r.Key_2__c != null && !doesPassTest(r.Value_2__c, (string.valueOf(testCase.get(r.Key_2__c))), r.Operation_2__c)) return false;
        if(r.Key_3__c != null && !doesPassTest(r.Value_3__c, (string.valueOf(testCase.get(r.Key_3__c))), r.Operation_3__c)) return false;
        if(r.Key_4__c != null && !doesPassTest(r.Value_4__c, (string.valueOf(testCase.get(r.Key_4__c))), r.Operation_4__c)) return false;
        if(r.Key_5__c != null && !doesPassTest(r.Value_5__c, (string.valueOf(testCase.get(r.Key_5__c))), r.Operation_5__c)) return false;
        if(r.Key_6__c != null && !doesPassTest(r.Value_6__c, (string.valueOf(testCase.get(r.Key_6__c))), r.Operation_6__c)) return false;
        return true;
    }

    /**
    *   {Purpose} - Method to determine whether or not values match between a Case
    *               and a Rule.  Pulled from Case_Train.cls.
    *
    *   CHANGE HISTORY
    *   ============================================================================
    *   Date        Name                    Description
    *   20180324    Calabrio                Created
    *   ============================================================================
    **/
    /*public static Boolean doesPassTest(String testVal, String actVal, String operation){
        try{
            if(actVal == null) actVal = 'null'; // set to 'null' for null values
            list<String> valuesToTest = new list<String>();
            actVal = actVal.toLowerCase();
            if(testVal.contains(',')){ // this is a list of values to test
                for (string s : testVal.split(',',0)) {
                    try{
                        id i = s.trim(); // fix 15/18 character ids
                        valuesToTest.add(string.valueOf(i).toLowerCase());
                    }catch(exception e){
                        valuesToTest.add(s.trim().toLowerCase());
                    }
                }
            } else {
                try{
                    id i = testVal; // fix 15/18 character ids
                    valuesToTest.add(string.valueOf(i).toLowerCase());
                }catch(exception e){
                    valuesToTest.add(testVal.toLowerCase());
                }
            }
            if(operation == 'EQUALS'){  // test based on the specific operation
                for(string s : valuesToTest){
                    if(actVal == s) return true;
                }
                return false;
            }else if(operation == 'NOT EQUALS'){
                boolean passed = true;
                for(string s : valuesToTest){
                    if(actVal == s) passed = false;
                }
                return passed;
            }else if(operation == 'GREATER THAN'){
                if(double.valueOf(testVal) > double.valueOf(actVal)) return true;
                return false;
            }else if(operation == 'LESS THAN'){
                if(double.valueOf(testVal) < double.valueOf(actVal)) return true;
                return false;
            }else{ // unanticipated value, pass this test
                return true;
            }
        }catch(exception e){
            system.debug(LoggingLevel.ERROR, 'Failed test: ' + e);
            Error_Logging.recordException(e, 'Calabrio_BatchHelper', 'doesPassTest');
        }
        return true;
    }

    /**
    *   {Purpose} - Method to authenticate with Calabrio and return the Session Id.
    *
    *   CHANGE HISTORY
    *   ============================================================================
    *   Date        Name                    Description
    *   20180325    Calabrio                Created
    *   ============================================================================
    **/
    public static String authenticateSession(String reqEndPoint, String userId, String password) {

        String returnValue = '';

        // Grab the Authentication information from the Custom Metadata Type.
      //  Calabrio_Integration_Setting__c  setting= [SELECT API_AuthenticationEndpoint__c,
       //                                                      API_AuthenticationUserId__c,
       //                                                      API_AuthenticationPassword__c
       //                                               FROM   Calabrio_Integration_Setting__c
       //                                               WHERE  Name = :settingName];

        //String reqEndPoint = String.valueOf(setting.API_AuthenticationEndpoint__c);
        //String userId = setting.API_AuthenticationUserId__c;
        //String password = setting.API_AuthenticationPassword__c;

        String reqBody = '{"userId":"' + userId + '","password":"' + password + '","locale":"en"}';
       
        HttpRequest req = new HttpRequest();
        req.setEndpoint(reqEndPoint);
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/json;charset=UTF-8');
        req.setBody(reqBody);

        if (!Test.isRunningTest()) {
            Http http = new Http();
            HttpResponse resp = http.send(req);
            returnValue = resp.getHeader('Set-Cookie');
        }

        return returnValue;

    } // End Method: authenticateSession()

    /**
    *   {Purpose} - Method to send the EVENT JSON to Calabrio.
    *
    *   CHANGE HISTORY
    *   ============================================================================
    *   Date        Name                    Description
    *   20180408    Calabrio                Created
    *   ============================================================================
    **/
    /*public static void sendEventJSON(String settingName, String sessionCookie, String jsonRequest) {

        // Grab the EndPoint from the Custom Metadata Type.
        Calabrio_Integration_Setting__mdt settingMDT = [SELECT API_Endpoint__c
                                                        FROM   Calabrio_Integration_Setting__mdt
                                                        WHERE  DeveloperName = :settingName];

        String reqEndPoint = String.valueOf(settingMDT.API_Endpoint__c);

        HttpRequest req = new HttpRequest();
        req.setMethod('POST');
        req.setEndpoint(reqEndPoint);
        req.setHeader('Cookie',sessionCookie);
        req.setHeader('Content-Type', 'application/json;charset=UTF-8');
        req.setBody(jsonRequest);
        req.setTimeout(30000);

        if (!Test.isRunningTest()) {
            Http http = new Http();
            HTTPResponse res = http.send(req);
        }

    }

    /**
    *   {Purpose} - Method to send the AGENT and SERVICE files to Calabrio.
    *               Pulled from the following website:
    *               http://blog.zenkraft.com/how-to-merge-two-pdf-files-on-salesforce/
    *
    *   CHANGE HISTORY
    *   ============================================================================
    *   Date        Name                    Description
    *   20180403    Calabrio                Created
    *   ============================================================================
    **/
    public static Integer sendAgentServiceFiles(String reqEndPoint, String sessionCookie,
                                             String agentFileName, Blob agentFileBody,
                                             String serviceFileName, Blob serviceFileBody) {

        // Grab the EndPoint from the Custom Metadata Type.
        //Calabrio_Integration_Setting__c setting = [SELECT API_Endpoint__c
        //                                              FROM   Calabrio_Integration_Setting__c
        //                                              WHERE  Name = :settingName];

       // String reqEndPoint = String.valueOf(setting.API_Endpoint__c);
        
        String boundary = String.valueOf(DateTime.now().getTime());

        // Convert body of the AGENT file into HEX.
        String agentBody = '------------' + boundary + '\r\n';
        agentBody+='Content-Disposition: form-data; name="files"; filename="' + agentFileName + '"\r\n';
        agentBody+='Content-Type: application/octet-stream\r\n\r\n';

        String finalBody = EncodingUtil.convertToHex(Blob.valueOf(agentBody)) +
                           EncodingUtil.convertToHex(agentFileBody);

        // Convert body of the SERVICE file into HEX, append it to "final" body, and add footer.
        String serviceBody = '\r\n------------' + boundary + '\r\n';
        serviceBody+='Content-Disposition: form-data; name="files"; filename="' + serviceFileName + '"\r\n';
        serviceBody+='Content-Type: application/octet-stream\r\n\r\n';
        String bodyFooter = '\r\n------------' + boundary + '--';

        finalBody += EncodingUtil.convertToHex(Blob.valueOf(serviceBody)) +
                     EncodingUtil.convertToHex(serviceFileBody) +
                     EncodingUtil.convertToHex(Blob.valueOf(bodyFooter));
        
        HttpRequest req = new HttpRequest();
        req.setMethod('POST');
        req.setEndpoint(reqEndPoint);
        req.setHeader('Cookie',sessionCookie);
        req.setHeader('Content-Type', 'multipart/form-data; boundary=----------' + boundary);
        req.setBodyAsBlob(EncodingUtil.convertFromHex(finalBody));
        req.setTimeout(120000);

        Integer statusCode = 400;                                         
        if (!Test.isRunningTest()) {
            Http http = new Http();
            
            Integer attempts = 3;
            for (Integer attempt = 1; attempt < (attempts + 1); attempt++) {
               try {
                   System.debug('Sending GIS data attempt: ' + attempt);   
                   HTTPResponse res = http.send(req);
                   statusCode = res.getStatusCode();
                   System.debug(res.getStatusCode()+'---->'+res.getBody());
                   break;
               } catch(System.CalloutException e) {
                   System.debug(e);
                   if(attempt == attempts){
                       throw e;
                   }
               }
            }

        } else {
            statusCode = 200;
        }
        return statusCode;
    } 

}