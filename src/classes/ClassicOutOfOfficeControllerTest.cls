/**
 * Created by jharrell on 11/27/19.
 */
@IsTest
public class ClassicOutOfOfficeControllerTest {

    private static final String TEST_MESSAGE = 'This is a test';

    public static void testSaveOutOfOffice() {


        Test.startTest();

        ClassicOutOfOfficeController officeController = new ClassicOutOfOfficeController();
        officeController.init();
        officeController.outOfOffice.Message = TEST_MESSAGE;
        officeController.saveOutOfOffice();

        Test.stopTest();

        List<OutOfOffice> outOfOffices = [ SELECT Id, Message, StartDate, EndDate FROM OutOfOffice WHERE UserId = :UserInfo.getUserId() ];
        System.assertEquals(true, !outOfOffices.isEmpty());
        System.assertEquals(TEST_MESSAGE, outOfOffices[0].Message);
    }

}