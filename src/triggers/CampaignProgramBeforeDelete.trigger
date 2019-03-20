trigger CampaignProgramBeforeDelete on Campaign_Program__c (before delete) {
	WEXProgramUtility util = new WEXProgramUtility();
    Campaign_Program__c cp = Trigger.old[0];
     
    if (util.isDefault(cp)){
        //Fail - can't delete a default T&C.
		cp.adderror('The default Terms and Conditions cannot be deleted until a new default is selected.');                  	
    }
}