public class Calabrio_ServiceHistoricalGISFileWriter {
    
    public static String serviceHistoricalToGISFormat(Calabrio_ServiceHistorical serviceHistorical) {
        
        String serviceFileString = serviceHistorical.getHeader();
        serviceFileString+= 'acdServiceId,contactsOffered,contactsHandled,contactsAnswered,contactsAbandoned,totalTalkSeconds,' +
                             'totalHoldSeconds,totalAfterContactWorkSeconds,totalAnswerDelaySeconds,serviceLevelPercent\n';
        for(Calabrio_ServiceHistoricalRow row : serviceHistorical.getRows()) {
            
            serviceFileString+=row.getAcdServiceId()+','+row.getContactsOffered()+','+row.getContactsHandled()+','+row.getContactsAnswered()+
                ','+row.getContactsAbandoned()+','+row.getTotalTalkSeconds()+','+row.getTotalHoldSeconds()+','+row.getTotalAfterContactWorkSeconds()
                    +','+row.getTotalAnswerDelaySeconds()+','+row.getServiceLevelPercent()+'\n';
        } 
        return serviceFileString;
    }
}