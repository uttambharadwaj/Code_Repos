public with sharing class AutoCaseStatusController {
	@AuraEnabled
	public static Boolean checkCaseStatusServ(Id recordId) {
		List<Case> caseList = [SELECT Status, Previously_Closed__c FROM Case WHERE Status = 'Unread' AND ID = :recordId LIMIT 1];
		if (!caseList.isEmpty()) {
			Case c = caseList[0];
			if (c.Previously_Closed__c == true) {
				c.Status = 'Closed';
			} else if (c.Previously_Closed__c == false) {
				c.Status = 'Working';
			}
			update c;
			return true;
		}
		return false;
	}
}