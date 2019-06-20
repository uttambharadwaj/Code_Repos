@isTest
private class Test_E2COwnerAssignment
{
	
	@testSetup
    static void setup(){
        UtilityTestLoader.setAutomation(false);
    }

    @isTest static void positiveTests() 
	{
		GlobalSettings__c gs = new GlobalSettings__c();
		gs.Name = 'test';
		gs.Virtual_Card_Queue_ID__c = UserInfo.getUserId();
		insert gs;

		//system.debug('** in test class: ' + gs.Virtual_Card_Queue_ID__c);

		List<Account> a = UTestData.getAccounts(1);
		insert a;

		Id profileId = [Select Id from Profile Where Name = 'System Administrator' LIMIT 1].Id;
		User u = UTestData.getUserRecord(profileId);
		insert u;

		AccountTeamMember atm = new AccountTeamMember();
		atm.userId = u.Id;
		atm.AccountId = a[0].Id;
		atm.TeamMemberRole = 'Account Manager';
		insert atm;


		test.starttest();
		List<Case> cases = UTestData.getCases(a);
		insert cases;
		test.stoptest();

		system.assertEquals([Select OwnerId from Case Where Id = :cases[0].Id].OwnerId, u.Id);

	}

}