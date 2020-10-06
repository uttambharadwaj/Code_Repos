public class Calabrio_ServiceDataCreator {
    
    
    public Calabrio_ServiceDataCreator() {
    }
    
    public Calabrio_ServiceHistorical getServiceHistoricalData(Calabrio_Integration_Setting__c setting, 
            DateTime intervalStart,List<Calabrio_CaseHistoryWrapper> caseHistoryList, Calabrio_Chats chats) {
        
        List<Calabrio_ServiceHistoricalRow> dataRows =new List<Calabrio_ServiceHistoricalRow>();
        String[] acdServiceIds = new List<String>{'email','chat'};
       
        for(String acdServiceId : acdServiceIds) {
            Calabrio_ServiceHistoricalRow row;    
            if(acdServiceId.equals('email')) {
                row = getServiceHistoricalRowofEmails(setting.Email_Queue_ID__c, caseHistoryList);
            }  else if(acdServiceId.equals('chat')) {
                row = getServiceHistoricalRowofChats(setting.Chat_Queue_ID__c, chats);
            } 
            if(row!=null) {
                dataRows.add(row);
            }
             
        }
        return new Calabrio_ServiceHistorical(intervalStart,22,dataRows); 
    }
    
    private Calabrio_ServiceHistoricalRow getServiceHistoricalRowofEmails(String acdServiceId, 
            List<Calabrio_CaseHistoryWrapper> caseHistoryList) {
        
        if(caseHistoryList == null) {
            return null;
        }
        Map<String,List<Calabrio_CaseHistoryWrapper>> caseCHList = new Map<String,List<Calabrio_CaseHistoryWrapper>>();
        for(Calabrio_CaseHistoryWrapper ch : caseHistoryList) {
            
            if(ch.CaseOrigin == 'Email' && ch.Reason != 'Junk Email') {
                if(!caseCHList.containsKey(ch.CaseId)) {
                    caseCHList.put(ch.CaseId,new List<Calabrio_CaseHistoryWrapper>());
                }
                caseCHList.get(ch.CaseId).add(ch);
            }
        }
        
        //String acdServiceId = '90113'; //'90113'
        Double contactsOffered = 0;
        Double contactsHandled = 0;
        Double contactsAbandoned = 0;
        Double totalTalkSeconds = 0;
        Double totalHoldSeconds = 0;
        Double totalAfterContactWorkSeconds = 0;
        Double totalAnswerDelaySeconds = 0;
        Double serviceLevelPercent = 0; 
        
        for(String caseId : caseCHList.keySet()) {
            for(Calabrio_CaseHistoryWrapper ch : caseCHList.get(caseId)) {
                
                //System.debug('CaseId: ' + caseId + ' CHID: ' + ch.Id + ' CreatedDate: ' + ch.CreatedDate);
                if(ch.Field == 'created') {
                    contactsOffered++;
                }
                else if(ch.Field == 'Status') {
                    if(ch.OldValue == 'Closed') {
                        contactsOffered++;
                    } else if(ch.NewValue == 'Closed' || ch.NewValue == 'Duplicate Case'){
                        contactsHandled++;
                    }
                }
            }
        }
        if((contactsOffered == 0) && (contactsHandled == 0) && (contactsAbandoned == 0)) {
            return null;
        }
        Double contactsAnswered = contactsHandled;
        Calabrio_ServiceHistoricalRow row = new Calabrio_ServiceHistoricalRow(acdServiceId,contactsOffered,contactsHandled,contactsAnswered,contactsAbandoned,totalTalkSeconds,
                                                             totalHoldSeconds,totalAfterContactWorkSeconds,totalAnswerDelaySeconds,serviceLevelPercent);
        return row;
    }
    private Calabrio_ServiceHistoricalRow getServiceHistoricalRowofChats(String acdServiceId, Calabrio_Chats chats) {
        
        if(chats == null || (chats.getCreatedChats().size() == 0 && chats.getClosedChats().size() == 0)) {
           return null;
        }

        //String acdServiceId  = '90111'; //'90111';
        Double contactsOffered = chats.getCreatedChats().size();
        Double contactsHandled = 0; 
        Double contactsAbandoned = 0;
        Double totalTalkSeconds = 0;
        Double totalHoldSeconds = 0;
        Double totalAfterContactWorkSeconds = 0;
        Double totalAnswerDelaySeconds = 0;
        Double serviceLevelPercent = 0; 
        
        for(LiveChatTranscript chat : chats.getClosedChats()) {
            if((chat.Disposition__c == 'Canceled by Visitor') || 
                    (chat.Disposition__c == 'Canceled (No Queue)') ||
                    (chat.Disposition__c == 'Canceled (No Agent)')){
                contactsAbandoned++;
            } else {
                contactsHandled++;
            }
            if(chat.ChatDuration != null){
              totalTalkSeconds+=chat.ChatDuration;
            }
            if(chat.WaitTime != null){
              totalAnswerDelaySeconds += chat.WaitTime;
            }
        }
        
        Double contactsAnswered = contactsHandled;
        
        Calabrio_ServiceHistoricalRow row = new Calabrio_ServiceHistoricalRow(acdServiceId,contactsOffered,contactsHandled,contactsAnswered,contactsAbandoned,totalTalkSeconds,
                                                              totalHoldSeconds,totalAfterContactWorkSeconds,totalAnswerDelaySeconds,serviceLevelPercent);
        
        return row;
    }
 
}