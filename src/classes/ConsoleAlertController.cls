public without sharing class ConsoleAlertController {
	@AuraEnabled
	public static Service_Alerts__c checkForAlertServ() {
		Service_Alerts__c alert;
		List<Service_Alerts__c> alertList = [SELECT Id, Subject__c, Color__c FROM Service_Alerts__c WHERE Active__c = true ORDER BY CreatedDate DESC LIMIT 1];
		if (!alertList.isEmpty()) {
			alert = alertList[0];
		}
		return alert;
	}
}