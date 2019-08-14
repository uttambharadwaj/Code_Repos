public class Calabrio_AgentProductivity {
    private DateTime intervalStart;
    private Integer acdId;

    private List<Calabrio_AgentProductivityRow> rows;
    
    public Calabrio_AgentProductivity(DateTime intervalStart, Integer acdId, List<Calabrio_AgentProductivityRow> rows) {
        this.intervalStart = intervalStart;
        this.acdId = acdId;
        this.rows = rows;
    }
    
    public String getFileName() {
        String formattedFileDateTime = intervalStart.format('yyyyMMddHHmm');
        String formattedFileTZOffset = Calabrio_IntegrationHelper.getFormattedTimeZoneOffset();
        String formattedHeaderTZOffset = formattedFileTZOffset.replace('-', 'N');
        
        String agentFileName = formattedFileDateTime + formattedFileTZOffset + '_' + acdId +'_AgentProductivity.AGENT';
        return agentFileName;
    }
    
    public String getHeader() {
        String formattedHeaderDate = intervalStart.format('yyyy-MM-dd');
        String formattedHeaderTime = intervalStart.format('HH:mm');
        String formattedFileTZOffset = Calabrio_IntegrationHelper.getFormattedTimeZoneOffset();
        String formattedHeaderTZOffset = formattedFileTZOffset.replace('N', '-');
        
        String agentFileString = 'AGENT DATE: ' + formattedHeaderDate + ' INTERVAL: ' + formattedHeaderTime + 
            ' TZOFFSET: ' + formattedHeaderTZOffset + ' ACD: '+acdId+'\n'; 
        return agentFileString;
    }
    
    public DateTime getIntervalStart() {
        return intervalStart;
    }
    
    public Integer getAcdId() {
        return acdId;
    }

    public List<Calabrio_AgentProductivityRow> getRows() {
        return rows;
    }
}