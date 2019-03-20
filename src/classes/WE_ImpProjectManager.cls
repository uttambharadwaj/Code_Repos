public class WE_ImpProjectManager {

	// See https://gist.github.com/aplssf/4b4ee42d355cda94e1866ffd36a5f0c5 for scheduled template

	Map<Id,Opportunity> oldOpps;
	Map<Id,Opportunity> newOpps;
	Static Boolean oppsEvaluated = false;
	Set<Id> oldOppsIds;
	Set<Id> newOppsIds;
	Opportunity oldOpp;
	Set<Id> changedOppIds = new Set<Id>();
	Set<String> oppRegions = new Set<String>();
	String oppRegion;

	public WE_ImpProjectManager(
	Map<Id, Opportunity> oldTriggerOpps,
	Map<Id, Opportunity> newTriggerOpps) {
		oldOpps = oldTriggerOpps;
		newOpps = newTriggerOpps;
	}

	public void evaluateOpportunities() {

		if (!oppsEvaluated == true) {
			oppsEvaluated = true;

			// create Object from Class
			WE_ApexUtility apxUtil = new WE_ApexUtility();

			if (WE_ApexUtility.apxCntrlrProjectCreationStatusAssessed == false) {
				WE_ApexUtility.checkApexControllerStatus('Automatic Project Creation');
			}
			if (!WE_ApexUtility.projectCreationDisabled.contains(true)) {
				apxUtil.retrieveValidRecordTypes(
				'EU Opps');
				apxUtil.retrieveValidRecordTypes(
				'NA Opps');
				apxUtil.retrieveValidRecordTypes(
				'Virtual AU Opps');

				for(Opportunity o : newOpps.values()) {
					if (oldOpps != null) {
						oldOpp = oldOpps.get(o.Id);
					}
					if (WE_ApexUtility.validEuRecordTypeIds.contains(o.RecordTypeId) &&
						// probability for Opportunity's Stage 4 is 50%
						(oldOpp == null ||
						 oldOpp.Probability < 75) &&
						 o.Probability >= 75)
					{
						changedOppIds.add(o.Id);
						oppRegions.add('EU');
					}
					else if ((WE_ApexUtility.validNaRecordTypeIds.contains(o.RecordTypeId) ||
							  WE_ApexUtility.validAuRecordTypeIds.contains(o.RecordTypeId)) &&
							 // probability for Opportunity's Stage 5 is 100%
							 (oldOpp == null ||
							  oldOpp.Probability < 100) &&
							  o.Probability >= 100)
					{
						changedOppIds.add(o.Id);
						oppRegions.add('NA');
					}
				}
				// check that only one region's Opportunities are being inserted to avoid complications when choosing Project / Milestone templates
				if (oppRegions.size() > 1) {
					for(Opportunity o : newOpps.values()) {
						o.addError(' Please only insert Opportunities for a single geographic region at once.');
					}
					// !!! Need to make sure that adding this error causes the code to Return too.
					// Don't want to use Return here, in case errors don't work & code fails siltently
				}
				for(String r : oppRegions) {
					oppRegion = r;
				}
				if (changedOppIds != null &&
					changedOppIds.size() > 0)
				{
					CreateImplementationProjects projectCreator = new CreateImplementationProjects(changedOppIds,oppRegion);
					Id jobId = System.enqueueJob(projectCreator);
				}
			}
		}
	}

	public class CreateImplementationProjects implements Queueable {

		private Set<Id> stage4PlusOpportunities = new Set<Id>();
		private String oppRegion;

		// constructor
		public CreateImplementationProjects (Set<Id> stg4OppIds,String oppRgn) {
			this.stage4PlusOpportunities = stg4OppIds;
			this.oppRegion = oppRgn;
		}

		List<Opportunity> changedOpportunities = new List<Opportunity>();
		Set<Id> changedOppIds = new Set<Id>();
		Set<Id> changedOppOwnerProfileIds = new Set<Id>();
		Map<Id,Id> profileIdByOppOwnerId = new Map<Id,Id>();
		Map<Id,Set<Id>> oppIdByOppOwnerProfiles = new Map<Id,Set<Id>>();
		Set<Id> profilesToEvaluate = new Set<Id>();
		Map<String, Schema.RecordTypeInfo> rts;
		List<Project_Template__mdt> projectTemplateWithMilestoneTemplates;
		Map<String, String> userRegionToField = new Map<String, String>{'AU'=>'AU__c','EU'=>'EU__c','NA'=>'NA__c'};
		String queueName;
		List<MPM4_BASE__Milestone1_Project__c> projectsToInsert = new List<MPM4_BASE__Milestone1_Project__c>();
		List<MPM4_BASE__Milestone1_Project__c> newProjects = new List<MPM4_BASE__Milestone1_Project__c>();
		Map<String,MPM4_BASE__Milestone1_Project__c> newProjectsByOppId = new Map<String,MPM4_BASE__Milestone1_Project__c>();
		List<ProjectxOpp__c> pxosToInsert = new List<ProjectxOpp__c>();
		List<MPM4_BASE__Milestone1_Milestone__c> milestonesToInsert = new List<MPM4_BASE__Milestone1_Milestone__c>();
		String projectName;
		String projectStage;
		Id regionRecordTypeId;
		Map<String,VUserProfileOrg__mdt> queuesByQueueNames = new Map<String,VUserProfileOrg__mdt>();
		VUserProfileOrg__mdt queueMeta;
		Id queueId;
		Map<String,Id> queueIdsByRegion = new Map<String,Id>();
		Id oppOwnerProfileId;
		List<ProjectxOpp__c> newProjectIds = new List<ProjectxOpp__c>();

		public void execute (QueueableContext context) {

			for(Opportunity o : [SELECT Id,Opportunity.Name,OwnerId,AccountId,Owner.ProfileId
								   FROM Opportunity
								  WHERE Id IN :stage4PlusOpportunities])
			{
				changedOpportunities.add(o);
				changedOppIds.add(o.Id);
				changedOppOwnerProfileIds.add(o.Owner.ProfileId);
				profileIdByOppOwnerId.put(o.OwnerId,o.Owner.ProfileId);

				Set<Id> oppIds = oppIdByOppOwnerProfiles.get(o.Owner.ProfileId);
				if (oppIds == null) {
					oppIds = new Set<Id>();
					oppIdByOppOwnerProfiles.put(o.Owner.ProfileId, oppIds);
				}
				oppIds.add(o.Id);
			}

            for(Id pId : changedOppOwnerProfileIds) {
				if (!WE_ApexUtility.evaluatedRegionsProfiles.contains(pId)) {
					profilesToEvaluate.add(pId);
				}
			}

			if (profilesToEvaluate.size() > 0) {
				WE_ApexUtility.checkValidProfile(profilesToEvaluate);
			}

			rts = User.SObjectType.getDescribe().getRecordTypeInfosByName();

			String projectRegionClause = ( oppRegion == 'EU' ? ' EU_Project__c = TRUE ' :
										 ( oppRegion == 'NA' ? ' NA_Project__c = TRUE ' :
										 					   ' AU_Project__c = TRUE '));

			String milestoneRegionClause = ( oppRegion == 'EU' ? ' EU_Milestone__c = TRUE ' :
										   ( oppRegion == 'NA' ? ' NA_Milestone__c = TRUE ' :
											 					 ' AU_Milestone__c = TRUE '));

			String testContextClause = 'Test_Record__c = ' + WE_ApexUtility.testContextStatus;

			String query1 =  '  SELECT Project_Name__c, Project_Stage__c,   			';
				   query1 += ' (SELECT Milestone_Name__c              					';
				   query1 += '    FROM Milestone_Templates__r         					';
				   query1 += '   WHERE ' + milestoneRegionClause + '  					';
				   query1 += '     AND ' + testContextClause + ')						';
				   query1 += '    FROM Project_Template__mdt          					';
				   query1 += '   WHERE ' + projectRegionClause + '    					';
				   query1 += '     AND ' + testContextClause							 ;

			projectTemplateWithMilestoneTemplates = Database.query(query1);

			projectName  = projectTemplateWithMilestoneTemplates[0].Project_Name__c;
			projectStage = projectTemplateWithMilestoneTemplates[0].Project_Stage__c;

			WE_ApexUtility apxUtil = new WE_ApexUtility();

			if (oppRegion == 'EU') {
				apxUtil.retrieveValidRecordTypes(
				'Virtual EU Projects');
				for(Id rtId : WE_ApexUtility.validEuProjectRecordTypeIds) {
					regionRecordTypeId = rtId;
				}
			}
			else if (oppRegion == 'NA') {
				apxUtil.retrieveValidRecordTypes(
				'Virtual NA Projects');
				for(Id rtId : WE_ApexUtility.validNaProjectRecordTypeIds) {
					regionRecordTypeId = rtId;
				}
			}

			for(VUserProfileOrg__mdt vqm : [SELECT MasterLabel,AuUPO__c,EuUPO__c,NaUPO__c
											FROM VUserProfileOrg__mdt
										   WHERE ImplementationUPO__c = TRUE
											 AND UpoLocation__c = 'Queue'
										     AND Test_Record__c = :WE_ApexUtility.testContext])
			{
				queuesByQueueNames.put(vqm.MasterLabel,vqm);
			}

			for(Group rq : [SELECT Id,Name
							  FROM Group
							 WHERE Name IN :queuesByQueueNames.keySet()])
			{
				queueMeta = queuesByQueueNames.get(rq.Name);
				queueId = rq.Id;

				if (queueMeta.AuUpo__c == TRUE) {
					queueIdsByRegion.put('AU',queueId);
				}
				else if (queueMeta.EuUpo__c == TRUE) {
					queueIdsByRegion.put('EU',queueId);
				}
				else if (queueMeta.NaUpo__c == TRUE) {
					queueIdsByRegion.put('NA',queueId);
				}
			}

			for(Opportunity o : changedOpportunities) {
				// Do not create Projects (& Milestones) for Asia Opportunities
				oppOwnerProfileId = profileIdByOppOwnerId.get(o.OwnerId);
				if (!WE_ApexUtility.validAsiaSalesRmProfiles.contains(oppOwnerProfileId)) {
					MPM4_BASE__Milestone1_Project__c project = new MPM4_BASE__Milestone1_Project__c();
					if (projectName != null) {
						project.Name = projectName;
					}
					else {
						project.Name = o.Name;
					}
					project.MPM4_BASE__Account__c = o.AccountId;
					project.Stage__c = projectStage;
					project.CreatedFromOpportunityID__c = o.Id;
					project.RecordTypeId = regionRecordTypeId;

					if (WE_ApexUtility.validEuSalesRmProfiles.contains(oppOwnerProfileId)) {
						project.OwnerId = queueIdsByRegion.get('EU');
					}
					else if (WE_ApexUtility.validAuSalesRmProfiles.contains(oppOwnerProfileId)) {
						project.OwnerId = queueIdsByRegion.get('AU');
					}
					else {
						project.OwnerId = queueIdsByRegion.get('NA');
					}
					projectsToInsert.add(project);
				}
			}
			insert projectsToInsert;

			// query for newly created Project & insert ProjectxOpp record to join to Opp
			for(MPM4_BASE__Milestone1_Project__c p : [SELECT Id,CreatedFromOpportunityID__c
														FROM MPM4_BASE__Milestone1_Project__c
													   WHERE CreatedFromOpportunityID__c IN :changedOppIds])
			{
				newProjectsByOppId.put(p.CreatedFromOpportunityID__c,p);
			}

			for(Opportunity o : changedOpportunities) {
				ProjectxOpp__c pxo = new ProjectxOpp__c();
				pxo.Opportunity__c = o.Id;
				pxo.Project__c = newProjectsByOppId.get(o.Id).Id;
				pxosToInsert.add(pxo);
			}
			insert pxosToInsert;

			newProjectIds = [SELECT Project__c
							   FROM ProjectxOpp__c
							  WHERE Opportunity__c IN :changedOpportunities];

			for(ProjectxOpp__c pId : newProjectIds) {
				for(Milestone_Template__mdt mt : projectTemplateWithMilestoneTemplates[0].Milestone_Templates__r) {
					MPM4_BASE__Milestone1_Milestone__c milestone = new MPM4_BASE__Milestone1_Milestone__c();
					milestone.Name = mt.Milestone_Name__c;
					milestone.MPM4_BASE__Project__c = pId.Project__c;
					milestonesToInsert.add(milestone);
				}
			}
			insert milestonesToInsert;
		}
	}

}