global class Calabrio_DataImportBatch implements Database.Batchable<DateTime>, Database.AllowsCallouts {

    global final Datetime beginTime;
    global final Datetime endTime;
    
    global Calabrio_DataImportBatch(DateTime beginTime, DateTime endTime) {
        this.beginTime = beginTime;
        this.endTime = endTime;
    }
    
    global List<DateTime> Start(Database.BatchableContext bc) {
        List<DateTime> dates = splitInterval(this.beginTime, this.endTime);
        System.debug('Running '+ dates.size() + ' intervals for batch: ' + bc.getJobId());
        return dates;
    }
 
     global void Execute(Database.BatchableContext BC, List<DateTime> startTimes) {
         for(DateTime start : startTimes){
           Calabrio_DataImportProcessor dt  = new Calabrio_DataImportProcessor(start, start.addMinutes(30));
           dt.runImport();
         }
     }
    
    global void Finish(Database.BatchableContext BC) {
      System.debug('Import complete, start: ' + beginTime + ' end: ' + endTime);    
    }
    
    private static List<DateTime> splitInterval(DateTime start, DateTime endTime) {
      List<DateTime> intervals = new List<DateTime>();
      DateTime nextStart = start;
      do {
        intervals.add(nextStart);
        nextStart = nextStart.addMinutes(30);
      } while ((nextStart < endTime) && (nextStart != endTime));
      return intervals;
    }

    
}