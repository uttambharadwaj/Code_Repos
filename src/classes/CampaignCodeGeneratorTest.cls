@isTest
public class CampaignCodeGeneratorTest {

    public static void test_generateCode() {

        final String CHARS = '1234ABCD';
        final List<String> CHARS_LIST = CHARS.split('');
        final Integer LENGTH = 4;

        Test.startTest();
        String code = CampaignCodeGenerator.generateCode(LENGTH, CHARS);
        Test.stopTest();

        // Assert code is of correct length
        System.assertEquals(LENGTH, code.length());

        // Assert all the characters in the code are also in our original chars list
        List<String> codeList = code.split('');
        for (String character : codeList) {
            System.assertEquals(true, CHARS_LIST.contains(character));
        }
    }

    public static void test_getCode() {

        Test.startTest();
        String code = CampaignCodeGenerator.getCampaignCode();
        Test.stopTest();

        Campaign_Code__c campaignCode = [ SELECT Id, Code_Used__c FROM Campaign_Code__c WHERE Name = :code];

        // Assert that the method didn't return null
        System.assertEquals(true, code != null);

        // Assert that code used flag was set true
        System.assertEquals(true, campaignCode.Code_Used__c);

    }
}