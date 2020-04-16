/**
 * Created by mfarrell on 4/13/20.
 */

@IsTest
public class LWC_ActivitiesControllerTest {

    public static void testGetAllActivities() {
        List<Case> C = [SELECT Id FROM Case WHERE Subject = 'Test Case 1' LIMIT 1];
        System.assert(C.size() > 0, 'We haz no case!');
        Test.startTest();
        List<Task> result = LWC_ActivitiesController.getAllActivities(1, 10, 5, C[0].Id);
        Integer countResult = LWC_ActivitiesController.getTaskCount(C[0].Id);
        Test.stopTest();
        System.assert(result.size() > 0, 'We haz no task!');
        System.assert(countResult > 0, 'We haz 0 tasks!');
    }

}