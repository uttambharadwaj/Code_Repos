global class Calabrio_DataImportProcessor {
    
    global DateTime startTime;
    global DateTime endTime;
    public List<Calabrio_CaseHistoryWrapper> caseHistories { get; set; } // Used for testing
    
    global Calabrio_DataImportProcessor (DateTime startTime, DateTime endTime) {
        this.startTime = startTime;
        this.endTime = endTime;
    }
    
    global void runImport() {
        //System.debug('Info:');
        //System.debug(startTime);
        //System.debug(endTime);
        /*System.debug(LoggingLevel.Info,'execute method execution');
        for(case caseObj : caseList) {
            System.debug(LoggingLevel.Info,caseObj.CaseNumber+'  '+caseObj.origin+'  '+caseObj.CreatedDate+'  '+caseObj.ClosedDate+'  '+caseObj.Disposition__c);
        }*/
        Set<Id> userIdSet = new Set<Id>();
        
        
        //List<CaseHistory> chList = new List<caseHistory>();
        List<Calabrio_CaseHistoryWrapper> chwList = new List<Calabrio_CaseHistoryWrapper>();
        if(Test.isRunningTest()){
            chwList = this.caseHistories;
        } else {
            for(CaseHistory ch : [SELECT CaseId, Case.Origin, Case.Owner.Id, CreatedById, Field, IsDeleted, NewValue, OldValue, 
                              CreatedDate, Case.CreatedDate, Case.ClosedDate, Case.Secondary_Reason__c from caseHistory 
                              where (Createddate >= :startTime AND CreatedDate < :endTime AND Case.RecordType.Name = 'Service Operations')]) {
                System.debug('Case: Id: ' + ch.CaseId + ' Reason: ' + ch.Case.Secondary_Reason__c); 
                userIdSet.add(ch.Case.Owner.Id);                      
                chwList.add(new Calabrio_CaseHistoryWrapper(ch.Field, ch.NewValue, ch.OldValue, ch.Case.Owner.Id, 
                    ch.Case.Origin, ch.CaseId, ch.Case.Secondary_Reason__c));
            } 
        }
        

        Calabrio_Chats chats = new Calabrio_Chats();
        //System.debug(LoggingLevel.Info,'Printing chats');
        for(List<LiveChatTranscript> chatList : [SELECT Name,WaitTime,ChatDuration,RequestTime,startTime,CreatedDate,
                                                    EndTime,Status,Disposition__C,OwnerId from LiveChatTranscript 
                                                 where (RequestTime >= :startTime AND RequestTime < :endTime) OR (EndTime >= :startTime AND EndTime < :endTime)]) {
            
            for(LiveChatTranscript chat :  chatList){
                //System.debug(LoggingLevel.Info,chat.Name+'  '+chat.WaitTime+'  '+chat.ChatDuration+'  '+chat.StartTime+'  '+chat.CreatedDate+'  '+chat.EndTime);
                if((chat.RequestTime >= startTime) && (chat.RequestTime < endTime)) {
                    chats.getCreatedChats().add(chat);
                } 
                if((chat.EndTime >= startTime) && (chat.EndTime < endTime)) {
                    chats.getClosedChats().add(chat);
                }
                userIdSet.add(chat.OwnerId);
            }
        }
        
        Map<Id,User> userMap = new Map<Id,User>([SELECT Id,
                                                        ACD_Id__c
                                                 FROM   User
                                                 WHERE  Id IN :userIdSet]);
        
        Calabrio_Integration_Setting__c[]  setting = [SELECT     API_AuthenticationEndpoint__c,
                                                               API_AuthenticationUserId__c,
                                                               API_AuthenticationPassword__c,
                                                               API_Endpoint__c,
                                                               Chat_Queue_ID__c,
                                                               Email_Queue_ID__c,
                                                               SMS_Queue_ID__c
                                                        FROM   Calabrio_Integration_Setting__c
                                                        WHERE  Name = 'Calabrio_Environment'];
                                                        
        if (setting.size() == 0)
            setting = [SELECT     API_AuthenticationEndpoint__c,
                                                               API_AuthenticationUserId__c,
                                                               API_AuthenticationPassword__c,
                                                               API_Endpoint__c,
                                                               Chat_Queue_ID__c,
                                                               Email_Queue_ID__c,
                                                               SMS_Queue_ID__c
                                                        FROM   Calabrio_Integration_Setting__c
                                                        WHERE  Name = 'Calabrio_TestEnvironment'];
                                                                       
        Calabrio_ServiceHistorical serviceHistorical = new Calabrio_ServiceDataCreator().getServiceHistoricalData(setting[0], startTime,chwList,chats);
        Calabrio_AgentProductivity agentProductivity = new Calabrio_AgentDataCreator().getAgentProductivityData(setting[0], startTime,chwList,chats, userMap); 
        
        System.debug(agentProductivity.getFileName());
        System.debug(Calabrio_AgentProductivityGISFileWriter.agentProductivityToGISFormat(agentProductivity));
        System.debug(serviceHistorical.getFileName());
        System.debug(Calabrio_ServiceHistoricalGISFileWriter.serviceHistoricalToGISFormat(serviceHistorical));
        System.debug('agentProductivity size: ' + agentProductivity.getRows().size());
        System.debug('serviceHistorical size: ' + serviceHistorical.getRows().size());
        if(agentProductivity.getRows().size() == 0 && serviceHistorical.getRows().size() == 0){
            System.debug('Skipping sending to Calabrio. Files are empty');
        } else {
            Integer attempts = 4;
            Integer afterMinutes = 2;
            if(System.IsBatch() == false && System.isFuture() == false){ 
                processRequest(afterMinutes, attempts, String.valueOf(setting[0].API_Endpoint__c), 
                               agentProductivity.getFileName(), 
                               Blob.valueOf(Calabrio_AgentProductivityGISFileWriter.agentProductivityToGISFormat(agentProductivity)),
                               serviceHistorical.getFileName(),
                               Blob.valueOf(Calabrio_ServiceHistoricalGISFileWriter.serviceHistoricalToGISFormat(serviceHistorical)),
                               String.valueOf(setting[0].API_AuthenticationEndpoint__c),
                               setting[0].API_AuthenticationUserId__c, setting[0].API_AuthenticationPassword__c, 
                               startTime, endTime);
            } else {
                processRequestNoFuture(afterMinutes, attempts, String.valueOf(setting[0].API_Endpoint__c), 
                           agentProductivity.getFileName(), 
                           Blob.valueOf(Calabrio_AgentProductivityGISFileWriter.agentProductivityToGISFormat(agentProductivity)),
                           serviceHistorical.getFileName(),
                           Blob.valueOf(Calabrio_ServiceHistoricalGISFileWriter.serviceHistoricalToGISFormat(serviceHistorical)),
                           String.valueOf(setting[0].API_AuthenticationEndpoint__c),
                           setting[0].API_AuthenticationUserId__c, setting[0].API_AuthenticationPassword__c, 
                           startTime, endTime);
            }

        }
        System.debug('Import complete.');
    }
    
    private static void processRequestNoFuture(Integer afterMinutes, Integer retriesLeft, String apiEndpoint, String agentProductivityFileName, 
                                       Blob agentProductivityBlob, String serviceHistoricalFileName, 
                                       Blob serviceHistoricalBlob, String apiAuthenticationEndpoint,
                                       String apiUserId, String apiPassword, DateTime startTime, DateTime endTime){
            try {
              String sessionCookie = Calabrio_IntegrationHelper.authenticateSession(apiAuthenticationEndpoint, apiUserId, apiPassword);
              Integer statusCode = Calabrio_IntegrationHelper.sendAgentServiceFiles(apiEndpoint, sessionCookie, agentProductivityFileName,
                                                               agentProductivityBlob, 
                                                               serviceHistoricalFileName, 
                                                               serviceHistoricalBlob);
              if(statusCode != 200 || Test.isRunningTest()){
                    if (Test.isRunningTest()) {
                        retriesLeft = 2;
                    }
                    System.debug('Error sending batch, code ' + statusCode + ' begin: ' + startTime + ' end: ' + endTime);
                    retriesLeft = retriesLeft - 1;
                             
                    if(retriesLeft > 0){
                        System.debug('Scheduling delayed API retry due to error');
                        Calabrio_ScheduledApiCall.scheduleApiCallDelayed(afterMinutes * 2/* minutes delay */, retriesLeft /* retries */, apiEndpoint, agentProductivityFileName, agentProductivityBlob, serviceHistoricalFileName, 
                        serviceHistoricalBlob, apiAuthenticationEndpoint, apiUserId, apiPassword, startTime, endTime);
                    } else {
                        System.debug('No retries left for Calabrio API call');
                    }

              }
            } catch (Exception e) {
                System.debug(e);
            }
    
    }
    
    @Future(callout=true)
    public static void processRequest(Integer afterMinutes, Integer retriesLeft, String apiEndpoint, String agentProductivityFileName, 
                                       Blob agentProductivityBlob, String serviceHistoricalFileName, 
                                       Blob serviceHistoricalBlob, String apiAuthenticationEndpoint,
                                       String apiUserId, String apiPassword, DateTime startTime, DateTime endTime) {
            processRequestNoFuture(afterMinutes, retriesLeft, apiEndpoint, agentProductivityFileName, agentProductivityBlob, serviceHistoricalFileName, 
                                   serviceHistoricalBlob, apiAuthenticationEndpoint, apiUserId, apiPassword, startTime, endTime);
    }
    
    public class IllegalArgumentsException extends Exception{}

}