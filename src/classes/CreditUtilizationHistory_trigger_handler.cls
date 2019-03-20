public class CreditUtilizationHistory_trigger_handler {
	public static void updateCreditUtilizationOnUltParentAccount(List<Credit_Utilization_History__c> creditUtilHistories){

		Set<Id> setAccountIds = new Set<Id>(); // Set of Ids to hold Account Ids

		for(Credit_Utilization_History__c cUtilHist : creditUtilHistories){
			setAccountIds.add(cUtilHist.Account__c);
		}

		List<Account> listAccounts = [select id, Credit_Utilization__c, Account_Id__c, Ultimate_Parent_External_Id__c, (select id, Credit_Utilization__c from Credit_Utilizations__r order by lastmodifieddate desc limit 1) from Account where  id =: setAccountIds]; 
		List<Account> toUpdateAccounts = new List<Account>();

		for(Account acc : listAccounts){

			Credit_Utilization_History__c cUtil = null;

			if(!acc.Credit_Utilizations__r.isEmpty()){
				cUtil =  acc.Credit_Utilizations__r[0];
			}
			
			if(!String.isBlank(acc.Account_Id__c) && !String.isBlank(acc.Ultimate_Parent_External_Id__c) && acc.Account_Id__c == acc.Ultimate_Parent_External_Id__c && !String.isBlank(String.valueOf(cUtil.Credit_Utilization__c))){
				acc.Credit_Utilization__c = cUtil.Credit_Utilization__c;
				toUpdateAccounts.add(acc);
			}

		}

		if(!toUpdateAccounts.isEmpty()){
			Database.update(toUpdateAccounts,false);
		}
	}
}