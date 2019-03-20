trigger FleetEnrollmentValidate on Program__c (before update) {
	Program__c program = Trigger.new[0];
    Program__c oldProgram = Trigger.old[0];
    
    if(oldProgram.Publish_Fleet_Data_Capture_Form__c == false && program.Publish_Fleet_Data_Capture_Form__c == true) {
        
        System.debug('FDFC is being enabled.. Entering validation..');

        // Check Attachments
        List<attachment> attachments = [SELECT id, name from Attachment where Parentid =: program.Id];
        
        Boolean hasCardImageNoText = false;
        Boolean hasCardImage = false;
        
        for(Integer i = 0; i < attachments.size(); i++) {
            if(attachments[i].name == 'ui-credit-card-no-text.png') { hasCardImageNoText = true; }
            if(attachments[i].name == 'ui-credit-card.png') { hasCardImage = true; }
        }
        
        System.debug('hasCardImage: ' + hasCardImage + ', hasCardImageNoText: ' + hasCardImageNoText);
        
        if(!hasCardImage || !hasCardImageNoText) {
            System.debug('ERROR: Missing Card Image and/or Card Image w/o Text');
            program.addError('Please ensure this program has both attachments - card image (\"ui-credit-card.png\") and blank card image (\"ui-credit-card-no-text.png\") for the Fleet Data Capture Form');
        }
        
        // Check for e-mail template
        if(program.Fleet_Data_Capture_Email_Template__c == null || program.Fleet_Data_Capture_Email_Template__c == '') {
            System.debug('ERROR: No email template configured');
            program.addError('Please ensure an e-mail template is configured for the Fleet Data Capture Form');
        }
        
        if(program.Fleet_Data_Capture_Form_Delivery__c == null) {
            System.debug('ERROR: Delivery timeframe not selected');
            program.addError('Please select a Fleet Card Delivery Timeframe for the Fleet Data Capture Form');
        }
        
		if(program.Brand_Long_Name__c == null) {
            System.debug('ERROR: Brand long name not populated');
			program.addError('Please ensure Brand Long Name is not blank for the Fleet Data Capture Form');
		}
        
		if(program.Implementation_Team_Number__c == null) {
            System.debug('ERROR: Implementation Team Number not populated');
			program.addError('Please ensure Implementation Team Number is not blank for the Fleet Data Capture Form');
		}
        
		if(program.Brand_Color_1__c == null) {
            System.debug('ERROR: Brand Color not populated');
			program.addError('Please ensure Brand Color 1 is not blank for the Fleet Data Capture Form');
		}
        
		if(program.Brand_Short_Name__c == null) {
            System.debug('ERROR: Brand Short Name not populated');
			program.addError('Please ensure Brand Short Name is not blank for the Fleet Data Capture Form');
		}
    }
}