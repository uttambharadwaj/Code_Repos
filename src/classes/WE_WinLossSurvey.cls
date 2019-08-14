public class WE_WinLossSurvey {

	/**
	* Class is not currently sending surveys for Won opportunities
	**/

	Map<Id,Opportunity> oldOpps;
	Map<Id,Opportunity> newOpps;
	Set<Id> oldOppsIds;
	Set<Id> newOppsIds;
	Opportunity oldOpp;
	Set<String> reasonCodes = new Set<String>();
	Set<Id> lostOppIds = new Set<Id>();
	List<Opportunity> oppsWithNoDmContact = new List<Opportunity>();
	Set<Id> oppIdsToProcess = new Set<Id>();

	// constructor
	public WE_WinLossSurvey(
	Map<Id, Opportunity> oldTriggerOpps,
	Map<Id, Opportunity> newTriggerOpps) {
		oldOpps = oldTriggerOpps;
		newOpps = newTriggerOpps;

		// create Object from Class
		WE_ApexUtility apxUtil = new WE_ApexUtility();

		if (WE_ApexUtility.apxCntrlrLostDealSurveyStatusAssessed == false) {
			WE_ApexUtility.checkApexControllerStatus('Lost Deal Survey');
		}
		if (!WE_ApexUtility.lostDealSurveyDisabled.contains(true)){

			apxUtil.retrieveValidRecordTypes(
				'EU Opps');

			for(Opportunity o : newOpps.values()) {
				oldOpp = oldOpps.get(o.Id);
				if (WE_ApexUtility.validEuRecordTypeIds.contains(o.RecordTypeId)) {
					// no need to execute query if none of the Opportunity's record types are valid
					if (reasonCodes.isEmpty()) {
						for(V_Reason_Codes__mdt mdt : [SELECT Label FROM V_Reason_Codes__mdt WHERE Send_Lost_Deal_Survey__c = true]) {
							reasonCodes.add(mdt.Label);
						}
					}
					// Existing Customers Opportunities not excluded from criteria, will be controlled using Custom Setting
					// in case RM does want to send survey
					// Additional logic controlled by Workflow Rule which Triggers field update to Send_Lost_Deal_Survey__c
					if (reasonCodes.contains(o.Reason_Code__c) &&
					oldOpp.Send_Lost_Deal_Survey__c != o.Send_Lost_Deal_Survey__c &&
					o.Send_Lost_Deal_Survey__c == true)
					{
						lostOppIds.add(o.Id);
					}
				}
			}
			if (lostOppIds.size() > 0) {
				for(Opportunity o : [SELECT Id,
									(SELECT Contact.Id
									   FROM OpportunityContactRoles
									  WHERE Role = 'Decision Maker')
									   FROM Opportunity
									  WHERE Id IN :lostOppIds])
				{
					if (o.OpportunityContactRoles.size() == 0) {
						oppsWithNoDmContact.add(newOpps.get(o.Id));
					} else {
						oppIdsToProcess.add(o.Id);
					}
				}
				if (oppsWithNoDmContact.size() > 0) {
					for(Opportunity o : oppsWithNoDmContact) {
						o.addError(' Please select a Contact with the Role \'Decision Maker\'. This Contact will receive the Lost Deal Survey');
					}
				}
				System.debug('+++ oppIdsToProcess size is ' + oppIdsToProcess.size());
				if (oppIdsToProcess.size() > 0) {
					SendWinLossSurveyEmails surveySender = new SendWinLossSurveyEmails(lostOppIds);
					Id jobId = System.enqueueJob(surveySender);
				}
			}
		}
	}

	public class SendWinLossSurveyEmails implements Queueable {

		private Set<Id> lostOppIds = new Set<Id>();

		// constructor
		public SendWinLossSurveyEmails(Set<Id> lOppIds) {
			this.lostOppIds = lOppIds;
		}

		public void execute(QueueableContext context) {

			List<Messaging.SingleEmailMessage> emailsToSend = new List<Messaging.SingleEmailMessage>();
			List<String> sendTos = new List<String>();
			List<String> ccTos = new List<String>();
			List<String> bccTos = new List<String>();
			String subject;
			String body;
			String firstName;

			if (lostOppIds.size() > 0) {

				for(Opportunity o : [SELECT Id, Owner.Email, Owner.SenderName,
									(SELECT Contact.Email, Contact.FirstName
									   FROM OpportunityContactRoles
									  WHERE Role = 'Decision Maker')
									   FROM Opportunity
									  WHERE Id IN :lostOppIds])
				{
					WE_ApexUtility.PrepareEmails pe = new WE_ApexUtility.PrepareEmails();
					Messaging.reserveSingleEmailCapacity(o.OpportunityContactRoles.size());
					for(OpportunityContactRole ocr : o.OpportunityContactRoles) {
						firstName = ocr.Contact.FirstName;

						subject = 'Please give us your feedback';
						body = '<html lang="ja"><body>'+
						'<br><br>'+'Dear '+firstName+
						'<br><br>'+'We’re sorry to see that you’ve decided not to use our solutions.'+
						'<br><br>'+'In order to improve our people and products in the future we’d like to complete a short survey so that we understand what influenced your decision not to use our solutions.'+
						'<br><br><a href="https://www.surveymonkey.co.uk/r/M9CLZ77">Take the survey now.</a>'+
						'<br><br>'+'Kind regards,'+
						'<br>'+'WEX Europe';

						sendTos.add(ocr.Contact.Email);
						// ccTo & bccTo deliberately left empty
						emailsToSend.add(pe.createEmail(
						sendTos,			// sendTo
						o.Owner.Email,		// replyTo
						o.Owner.SenderName,	// displayName
						ccTos,				// ccTo
						bccTos,				// bccTo
						subject,			// subject
						body));				// body
						sendTos.Clear();
						ccTos.Clear();
						bccTos.Clear();
					}
				}
				if (emailsToSend.size() > 0) {
					for(Messaging.SingleEmailMessage e : emailsToSend) {
						Messaging.SendEmail(new Messaging.SingleEmailMessage[] { e });
					}
				}
			}
		}
	}

 }