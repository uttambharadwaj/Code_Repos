trigger WexUK_Acctounts_Receivable on Wes_Accounts_Receivable__c (after insert, after update) {

list<Wes_Accounts_Receivable__c> acctRecvbleList = Trigger.new;


WexUK_Reassessment_Handler.updateIsParentOverdue(acctRecvbleList);

/*set<Account> parentAccount = new set<Account> ();



List<Account> childAcct = new  List<Account>();

for(Wes_Accounts_Receivable__c accountRcbl : acctRecvbleList){
  childAcct.add(new account(id = accountRcbl.account__c));
}

system.debug('childAcct ' +childAcct);

List<Account> acctParent = [select parentid from account where id = :childAcct];

system.debug('acctParent ' + acctParent);

for(Account acct : acctParent){
  parentAccount.add(new account(id = acct.parentid ));
}


List<Wes_Accounts_Receivable__c> acctRcvblTBU = [Select isOverdue__c, Account__r.id, Account__r.parentid, Account__r.parent.Overdue_6_months__c from Wes_Accounts_Receivable__c where  Account__r.parentid =:parentAccount ];

system.debug('acctRcvblTBU ' +acctRcvblTBU);

set<Account> OverdueAccount = new set<Account> ();
Account acct = null;
list<boolean> overdueList =  null;

map<Account, list<boolean>> AcctOverdueMap= new map<Account, list<boolean>>();

for(Wes_Accounts_Receivable__c recvble : acctRcvblTBU){
  overdueList = AcctOverdueMap.get(new Account(id = recvble.Account__r.parentid));
    if(overdueList == null){
    overdueList = new List<boolean>();
    overdueList.add(recvble.isOverdue__c);
  }else {
    overdueList.add(recvble.isOverdue__c);
  }
  AcctOverdueMap.put(new Account(id = recvble.Account__r.parentid), overdueList);
}

Boolean isoverdueFlag = false;
Boolean isNotoverdueFlag = false;

for(Account acctmap : AcctOverdueMap.keySet()){
  for(Boolean isOverdue :  AcctOverdueMap.get(acctmap)){
  if(isOverdue == true){
    isoverdueFlag = true;
    break;
  }else {
    isNotoverdueFlag = true;
  }
  
  }
  if(isoverdueFlag){
    acct = new Account(id = acctmap.id);
    acct.Overdue_6_months__c = true;
  }else {
    acct = new Account(id = acctmap.id);
    acct.Overdue_6_months__c = false;
  }
  
  OverdueAccount.add(acct);
  isoverdueFlag = false;
  isNotoverdueFlag = false;
}

List<Account> acctList = new List<Account>();
acctList.addall(OverdueAccount);
update acctList;

 */   

}