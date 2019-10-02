trigger WexUK_Account_Trigger on Account (after insert, before insert,  after update, before update) {

    Bulk_Data_Load_Settings__c bulkDataLoadSettings = Bulk_Data_Load_Settings__c.getInstance();
    if(bulkDataLoadSettings != null && bulkDataLoadSettings.Disable_Account_Automation__c) { return; }

    List<Account> acctlist = new List<Account>();
    List<Account> oldAccontList = new List<Account>();

    
    for(Account acc : Trigger.new)
    {
        Id rtId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('WES Accounts').getRecordTypeId();

        if(acc.recordtypeid == rtId)
        {
            acctlist.add(acc);

            if(Trigger.oldMap != null)
            {
               oldAccontList.add(Trigger.oldMap.get(acc.Id)); 
            }
        }
    }


    if (!acctlist.isEmpty() &&  Trigger.isBefore && (Trigger.isInsert || Trigger.isupdate)) {
        
        WexUK_AccountTrigger_handler.updateAccounthistoryAndCreditUtil(acctlist, oldAccontList,Trigger.oldMap); 
    }


    if (!acctlist.isEmpty() && Trigger.IsBefore && Trigger.isUpdate) {
        //system.debug('acctlist ' + acctlist);
        WexUK_AccountTrigger_handler.handleApprovalProcess(acctlist, oldAccontList);

    }

    if (!acctlist.isEmpty() && Trigger.isAfter && (Trigger.isInsert || Trigger.isupdate)) {
       WexUK_AccountTrigger_handler.createCreditUtilizationHistory(Trigger.oldMap, Trigger.newMap);

    }

    if (!acctlist.isEmpty() && Trigger.IsAfter && Trigger.isUpdate) {
        WexUK_AccountTrigger_handler.doReviewAudit(oldAccontList, acctlist, Trigger.oldMap);

    }

    if (!acctlist.isEmpty() && Trigger.IsBefore && Trigger.isInsert) {
        WexUK_AccountTrigger_handler.addCreditPolicy(acctlist);

    }
}