public class Calabrio_AgentDataCreator {
    
    public Calabrio_AgentDataCreator() {
        
    }
    
    public Calabrio_AgentProductivity getAgentProductivityData(Calabrio_Integration_Setting__c setting, 
            DateTime intervalStart,List<Calabrio_CaseHistoryWrapper> caseHistoryList, Calabrio_Chats chats, 
            Map<Id,User> userMap) {
        
        List<Calabrio_AgentProductivityRow> dataRows = new List<Calabrio_AgentProductivityRow>();
        Set<Id> missingAcdIds = new Set<Id>(); 
        if(chats != null) {
            Map<String,List<LiveChatTranscript>> agentsToChats = new Map<String,List<LiveChatTranscript>>();
            for (LiveChatTranscript chat : chats.getClosedChats()) {
                if(userMap.containsKey(chat.OwnerId)){
                    string agentId = userMap.get(chat.OwnerId).ACD_Id__c;
                    if(agentId != null){
                        if(!agentsToChats.containsKey(agentId)) {
                            agentsToChats.put(agentId,new List<LiveChatTranscript>());
                        }
                        agentsToChats.get(agentId).add(chat);  
                    } else {
                        missingAcdIds.add(chat.OwnerId);
                    }

                } else {
                    System.debug('Missing user ' + chat.OwnerId);
                }
               
            }
            dataRows.addAll(getAgentProductivityRowsChats(setting.Chat_Queue_ID__c, agentsToChats));
        }
            
        if(caseHistoryList != null) {
            Map<String,List<Calabrio_CaseHistoryWrapper>> agentsToCH = new Map<String,List<Calabrio_CaseHistoryWrapper>>();
            for(Calabrio_CaseHistoryWrapper ch : caseHistoryList) {
                //if(ch.Id == '0171L0000aekxtzQAA'){
                //   System.debug('CaseId: ' + ch.CaseId + ' CHID: ' + ch.Id + ' CreatedDate: ' + ch.CreatedDate + ' Owner ' + ch.Case.Owner.Id);
                //}
                if(ch.CaseOrigin == 'Email') {
                    if(userMap.containsKey(ch.CaseOwnerId)) {
                        String agentId = userMap.get(ch.CaseOwnerId).ACD_Id__c;
                        //if(ch.Id == '0171L0000aekxtzQAA'){
                        //   System.debug('Owner Id: ' + ch.Case.Owner.Id + ' VOIP: ' + agentId);
                        //}
                        if(agentId != null){
                            if(!agentsToCH.containsKey(agentId)) {
                                agentsToCH.put(agentId,new List<Calabrio_CaseHistoryWrapper>());
                            }
                            agentsToCH.get(agentId).add(ch);  
                        } else {
                            missingAcdIds.add(ch.CaseOwnerId);
                        }   
                    }
                }
            }
            dataRows.addAll(getAgentProductivityRowsEmails(setting.Email_Queue_ID__c, agentsToCH));
        }
        
        if(missingAcdIds.size() > 0){
            System.debug('Missing acd ids for users: ');
            for(Id i: missingAcdIds){
                System.debug(i);
            }
        }
               
        return new Calabrio_AgentProductivity(intervalStart,22,dataRows); 
  
    }
    
    private List<Calabrio_AgentProductivityRow> getAgentProductivityRowsChats(String acdServiceId, 
            Map<String,List<LiveChatTranscript>> agentsToChats) {
        
        List<Calabrio_AgentProductivityRow> dataRows = new List<Calabrio_AgentProductivityRow>();
        
        for(String agentId : agentsToChats.keySet()) {
            
            String acdAgentId = agentId;
            //String acdServiceId = '90111'; //'90111';
            Double contactsHandled = 0;
            Double totalTalkSeconds = 0;
            Double totalHoldSeconds = 0;
            Double totalAnswerDelaySeconds = 0;
            for(LiveChatTranscript chat : agentsToChats.get(agentId)) {  
                if(chat.Status != 'Missed'){
                    contactsHandled++;
                }
                if(chat.ChatDuration != null) {
                  totalTalkSeconds+=chat.ChatDuration;
                }
                if(chat.WaitTime != null) {
                  totalAnswerDelaySeconds += chat.WaitTime;
                }
            }
            Calabrio_AgentProductivityRow row = new Calabrio_AgentProductivityRow(acdAgentId,acdServiceId,contactsHandled,totalTalkSeconds,totalHoldSeconds,0,0,0,0,0,totalAnswerDelaySeconds);
            dataRows.add(row);
        }
        return dataRows;
    }
    
    private List<Calabrio_AgentProductivityRow> getAgentProductivityRowsEmails(String acdServiceId, 
            Map<String,List<Calabrio_CaseHistoryWrapper>> agentsToCH) {
        
        List<Calabrio_AgentProductivityRow> dataRows = new List<Calabrio_AgentProductivityRow>();
        
        for(String agentId : agentsToCH.keySet()) {
            
            String acdAgentId = agentId;
            //String acdServiceId = '90113';
            Double contactsHandled = 0;
            Double totalTalkSeconds = 0;
            Double totalHoldSeconds = 0;
            Double totalAnswerDelaySeconds = 0;
            
            for(Calabrio_CaseHistoryWrapper ch : agentsToCH.get(agentId)) {           
                if(ch.Field == 'Status' && ch.NewValue == 'closed') {
                    contactsHandled++;
                }                
            }
            
            if(contactsHandled != 0 ){
                Calabrio_AgentProductivityRow row = new Calabrio_AgentProductivityRow(acdAgentId,acdServiceId,contactsHandled,totalTalkSeconds,totalHoldSeconds,0,0,0,0,0,totalAnswerDelaySeconds);
                dataRows.add(row);
            }
        }
        return dataRows;
    }
    
}