/*
 * Description: When a Contact or Lead Record is edited with new Opt-in/Opt-Out issue with Child records
 * Date: April 2, 2020
 * Author: Lev
 */
public class MCBatchSweep implements Database.Batchable<sObject>{
    public String objectType;
    public String whereClause;
    public String fields;
    public List<Lead> leadRecords;
    public List<Contact> contactRecords;
    
    public Database.QueryLocator start(Database.BatchableContext BC){
      String query = 'SELECT' + fields + ' FROM ' + objectType + 'WHERE ' + whereClause;
      return Database.getQueryLocator(query);
   }

    public void execute(Database.BatchableContext BC, List<sObject> scope){
        for(Sobject s : scope){
            //s.put(fields,Value); 
        }      
        update scope;
    }

   public void finish(Database.BatchableContext BC){

   }
}