public class Calabrio_AgentProductivityGISFileWriter {
    
    public static String agentProductivityToGISFormat(Calabrio_AgentProductivity agentProductivity) {
        
        String agentFileString = agentProductivity.getHeader();
        agentFileString+= 'acdAgentId,acdServiceId,contactsHandled,totalTalkSeconds,totalHoldSeconds,totalAfterContactWorkSeconds,'+
                            'totalPeriodHandleTimeSeconds,totalUnproratedReadyWaitingSeconds,totalUnproratedNotReadyBusySeconds,'+
                            'totalUnproratedInSessionSeconds,totalAnswerDelaySeconds\n';
        for(Calabrio_AgentProductivityRow row : agentProductivity.getRows()) {
            //row.acdAgentId+
            agentFileString+=row.acdAgentId+','+row.getAcdServiceId()+','+row.getContactsHandled()+','+row.getTotalTalkSeconds()+
                ','+row.getTotalHoldSeconds()+','+row.getTotalAfterContactWorkSeconds()+','+row.getTotalPeriodHandleTimeSeconds()+','+
                row.getTotalUnproratedReadyWaitingSeconds()+','+row.getTotalUnproratedNotReadyBusySeconds()+','+row.getTotalUnproratedInSessionSeconds()+
                ','+row.getTotalAnswerDelaySeconds()+'\n';
        } 
        
        //agentFileString+='00516000006gxle,90112,2.000,273.000,76.000,74.000,0.000,0.000,0.000,0.000,205.000';
        return agentFileString;
    }
}