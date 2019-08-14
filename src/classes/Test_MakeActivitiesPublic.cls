@isTest
private class Test_MakeActivitiesPublic {
	
	@testSetup
    static void setup(){
        UtilityTestLoader.setAutomation(false);
    }

    @isTest static void test_tasks() {
		//setup
		Task t = new Task();
		t.Subject = 'test1';
		t.ActivityDate = system.now().date();		
		insert t;

		
		test.starttest();

		Id bId = Database.executeBatch(new Batch_MakeTasksPublic());

		test.stoptest();

		//asserts
		system.assertEquals([Select Id, IsVisibleInSelfService 
							from Task Where IsVisibleInSelfService=true].size(),1);
	}
	
	@isTest static void test_events() {
		//setup
		Event e = new Event();
		e.subject = 'test';
		e.StartDateTime = system.now();
		e.EndDateTime = system.now();
		e.Type = 'test';
		insert e;



		//run batch
		test.starttest();

		Id bId = Database.executeBatch(new Batch_MakeEventsPublic());

		test.stoptest();

		//asserts
		system.assertEquals([select Id from Event Where IsVisibleInSelfService=true].size(),1);
	}
	
}