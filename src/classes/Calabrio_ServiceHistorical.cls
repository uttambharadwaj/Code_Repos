public class Calabrio_ServiceHistorical {
    
    private DateTime intervalStart;
    private Integer acdId;
    private List<Calabrio_ServiceHistoricalRow> rows; 
    
     public Calabrio_ServiceHistorical(DateTime intervalStart, Integer acdId, List<Calabrio_ServiceHistoricalRow> rows) {
        this.intervalStart = intervalStart;
        this.acdId = acdId;
        this.rows = rows;
    }
    
    public String getFileName() {
        String formattedFileDateTime = intervalStart.format('yyyyMMddHHmm');
        String formattedFileTZOffset = Calabrio_IntegrationHelper.getFormattedTimeZoneOffset();
        String formattedHeaderTZOffset = formattedFileTZOffset.replace('N', '-');
        
        String serviceFileName = formattedFileDateTime + formattedFileTZOffset + '_' + acdId +'_ServiceHistorical.SERVICE';
        return serviceFileName;
    }
    
    public String getHeader() {
        String formattedHeaderDate = intervalStart.format('yyyy-MM-dd');
        String formattedHeaderTime = intervalStart.format('HH:mm');
        String formattedFileTZOffset = Calabrio_IntegrationHelper.getFormattedTimeZoneOffset();
        String formattedHeaderTZOffset = formattedFileTZOffset.replace('N', '-');
        
        String serviceFileString = 'SERVICE DATE: ' + formattedHeaderDate + ' INTERVAL: ' + formattedHeaderTime + 
            ' TZOFFSET: ' + formattedHeaderTZOffset + ' ACD: '+acdId+'\n'; 
        return serviceFileString;
    }
    
    public DateTime getIntervalStart() {
        return intervalStart;
    }
    
    public Integer getAcdId() {
        return acdId;
    }

    public List<Calabrio_ServiceHistoricalRow> getRows() {
        return rows;
    }    

}