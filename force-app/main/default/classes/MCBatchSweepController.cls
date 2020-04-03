/*
 * Description: Once the Contact or Lead Trigger is executed, send changes to batch in dynamic size
 * Date: April 2, 2020
 * Author: Lev
 */
public class MCBatchSweepController {
    public final Integer sweepSize = Integer.valueOf(Label.MCBatchSweepSize);
    
    //Description: When a Lead record is updated handle the child record sweep 
    //Batch class: MCBatchSweep
    //Batch Size: MCBatchSweepSize custom label
    public void handleLeadSweep(List <Lead> changedLeads) {
        MCBatchSweep sweep = new MCBatchSweep();
        sweep.objectType = 'Lead';
        sweep.leadRecords = changedLeads;
        sweep.fields = '';
        sweep.whereClause = '';
        
        //Send lead batch details to MCBatchSweep
        Database.executeBatch(sweep, sweepSize);
    }
    
    //Description: When a Contact record is updated handle the child record sweep 
    //Batch class: MCBatchSweep
    //Batch Size: MCBatchSweepSize custom label
    public void handleContactSweep(List<Contact> changedContacts) {
        MCBatchSweep sweep = new MCBatchSweep();
        sweep.objectType = 'Contact';
        sweep.contactRecords = changedContacts;
        sweep.fields = '';
        sweep.whereClause = '';
        
        //Send contact batch details to MCBatchSweep        
        Database.executeBatch(sweep, sweepSize);
    }

}