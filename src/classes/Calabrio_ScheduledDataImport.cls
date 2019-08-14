public class Calabrio_ScheduledDataImport implements Schedulable {

    private Datetime previousFireTime; // Used for testing
    private List<Calabrio_CaseHistoryWrapper> caseHistories; // Used for testing

    public Calabrio_ScheduledDataImport(Datetime previousFireTime, List<Calabrio_CaseHistoryWrapper> caseHistories) {
        this.previousFireTime = previousFireTime;
        this.caseHistories = caseHistories;
    }

    public void Execute(SchedulableContext sc) {
        //System.debug('Is null:');
        //System.debug(previousFireTime);
        if(previousFireTime == null || !Test.isRunningTest()){
            CronTrigger ct = [SELECT Id, CronExpression, PreviousFireTime, TimesTriggered, NextFireTime FROM CronTrigger WHERE Id = :sc.getTriggerId()];
            previousFireTime = ct.PreviousFireTime;
        }

        DateTime startTime = previousFireTime.addMinutes(-45);
        DateTime endTime = startTime.addMinutes(30);

        Calabrio_DataImportProcessor dt  = new Calabrio_DataImportProcessor(startTime,endTime);
        dt.caseHistories = caseHistories;
        dt.runImport();
    }
    
}