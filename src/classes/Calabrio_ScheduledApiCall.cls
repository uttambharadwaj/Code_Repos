public class Calabrio_ScheduledApiCall implements Schedulable {

    private Integer retriesLeft;
    private Integer minutesDelay;
    private String apiEndpoint;
    private String agentProductivityFileName;
    private Blob agentProductivityBlob;
    private String serviceHistoricalFileName;
    private Blob serviceHistoricalBlob;
    private String apiAuthenticationEndpoint;
    private String apiUserId;
    private String apiPassword;
    private DateTime startTime;
    private DateTime endTime;
    private String name;

    public Calabrio_ScheduledApiCall(Integer retriesLeft, Integer minutesDelay, String apiEndpoint, String agentProductivityFileName, 
                                       Blob agentProductivityBlob, String serviceHistoricalFileName, 
                                       Blob serviceHistoricalBlob, String apiAuthenticationEndpoint,
                                       String apiUserId, String apiPassword, DateTime startTime, DateTime endTime, String name) {
        this.retriesLeft = retriesLeft;
        this.minutesDelay = minutesDelay;
        this.apiEndpoint = apiEndpoint;
        this.agentProductivityFileName = agentProductivityFileName;
        this.agentProductivityBlob = agentProductivityBlob;
        this.serviceHistoricalFileName  = serviceHistoricalFileName;
        this.serviceHistoricalBlob = serviceHistoricalBlob;
        this.apiAuthenticationEndpoint = apiAuthenticationEndpoint;
        this.apiUserId = apiUserId;
        this.apiPassword = apiPassword;
        this.startTime = startTime;
        this.endTime = endTime;
        this.name = name;
    }

    public void Execute(SchedulableContext sc) {
        try {
            Calabrio_DataImportProcessor.processRequest(minutesDelay, retriesLeft, apiEndpoint, agentProductivityFileName, 
                                       agentProductivityBlob, serviceHistoricalFileName, 
                                       serviceHistoricalBlob, apiAuthenticationEndpoint,
                                       apiUserId, apiPassword, startTime, endTime);
        } finally {
           String name = this.name;
            for(CronJobDetail detail : [SELECT Id FROM CronJobDetail WHERE Name = :name]){
                for(CronTrigger job : [SELECT Id from CronTrigger WHERE CronJobDetailId = :detail.Id]){
                        try {
                            System.abortJob(job.Id);
                        } catch (Exception e){}
                }
            }
        } 
    }

    public static void scheduleApiCallDelayed(Integer afterMinutes, Integer retriesLeft, String apiEndpoint, String agentProductivityFileName, 
                                       Blob agentProductivityBlob, String serviceHistoricalFileName, 
                                       Blob serviceHistoricalBlob, String apiAuthenticationEndpoint,
                                       String apiUserId, String apiPassword, DateTime startTime, DateTime endTime){
      DateTime nextFireTime = Datetime.now().addMinutes(afterMinutes);
      String hour = String.valueOf(nextFireTime.hour());
      String min = String.valueOf(nextFireTime.minute()); 
      String ss = String.valueOf(nextFireTime.second());
      String nextFireTimeCron = ss + ' ' + min + ' ' + hour + ' * * ?';
      String name = 'Calabrio_ScheduledApiCall Scheduled At ' + String.valueOf(Datetime.now());
      Calabrio_ScheduledApiCall job = new Calabrio_ScheduledApiCall(retriesLeft, afterMinutes, apiEndpoint, agentProductivityFileName, 
                                       agentProductivityBlob, serviceHistoricalFileName, 
                                       serviceHistoricalBlob, apiAuthenticationEndpoint,
                                       apiUserId, apiPassword, startTime, endTime, name);
      System.schedule(name, nextFireTimeCron, job);
    }

}