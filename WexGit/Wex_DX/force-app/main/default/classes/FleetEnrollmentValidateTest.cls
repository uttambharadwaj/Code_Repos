@isTest
public class FleetEnrollmentValidateTest {

    @testSetup
    static void setup(){
        UtilityTestLoader.setAutomation(false);
    }

    static testMethod void testFleetEnrollmentValidate() {
        
        Test.startTest();
        
        // Setup Program
        Program__c program = new Program__c();
        
        program.Name = 'Sunoco Fleet';         
      
        insert program;
        
        try {
        	program.Publish_Fleet_Data_Capture_Form__c = true;
        	update program;
        }
        catch(Exception e) {
            Boolean expectedExceptionThrown =  e.getMessage().contains('Please ensure Brand Short Name is not blank for the Fleet Data Capture Form') ? true : false;
			System.AssertEquals(expectedExceptionThrown, true);
        }
        
        Program__c updatedProgram = [SELECT Id, Publish_Fleet_Data_Capture_Form__c FROM Program__c WHERE Id = :program.Id];
        
        System.assert(updatedProgram.Publish_Fleet_Data_Capture_Form__c != true);
              
        // Setup Attachments
        Attachment cardImage = new Attachment();
        cardImage.Name = 'ui-credit-card.png';
        Blob cardImageBlob = Blob.valueOf('Unit Test Attachment Body');
        cardImage.body = cardImageBlob;
        cardImage.parentId = program.Id;
        upsert cardImage;
        
        Attachment cardImageNoText = new Attachment();
        cardImageNoText.Name = 'ui-credit-card-no-text.png';
        Blob cardImageNoTextBlob = Blob.valueOf('Unit Test Attachment Body');
        cardImageNoText.body = cardImageNoTextBlob;
        cardImageNoText.parentId = program.Id;
        upsert cardImageNoText;

        program.Brand_Short_Name__c = 'sunoco';
        program.Custom_Email_Header_URL__c = 'http://www.wexhosted.com/email/revolver/header_wexRevolver.jpg';
        program.Brand_Long_Name__c = 'Sunoco Fleet';
        program.Brand_Color_1__c = '#ccc';
        program.Implementation_Team_Number__c = '1-888-888-8888';
        program.Fleet_Data_Capture_Email_Template__c = '0000000';
        program.Fleet_Data_Capture_Form_Delivery__c = '2-3';
		program.Publish_Fleet_Data_Capture_Form__c = true;

	    upsert program;

        updatedProgram = [SELECT Id, Publish_Fleet_Data_Capture_Form__c FROM Program__c WHERE Id = :program.Id];
        
        System.assert(updatedProgram.Publish_Fleet_Data_Capture_Form__c == true);
        
        Test.stopTest();
        
    }
    
}