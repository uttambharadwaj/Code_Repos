public class WEXProgramUtility {
 
    // Called from the before insert/update trigger on Terms and Conditions.  
    // Called when the Terms and Conditions is updated or inserted AND the default flag == true
    // 
    //This method will update the default flag to false for all
    //Terms and Conditions under the program - theoretically there should always only be one set anyway.
    //
    public void resetDefaultFlagForProgram(Campaign_Program__c cp){
        
          
        List<Campaign_Program__c> cpList = [
            select id, Program__c, Campaign__c, Default__c
            from Campaign_Program__c 
            where Program__c = :cp.program__c
            and campaign__c != :cp.Campaign__c
            and id != :cp.Id
            and Default__c = true
        ];
        
        for (Campaign_Program__c newDefaultcp : cpList){
            newDefaultcp.Default__c = false;
        }
        
        update cpList;
    }
   
    public boolean isDefault(Campaign_Program__c cp){

        if (cp.Default__c == true){
            return true;
        }
        
        return false;
    }
    // Called from the program BeforeUpdate/Insert trigger.  Only allow anything to be published if 
    // it has a default Terms and Conditions set.
    //
    // Used to find out if the program has a default Terms and Conditions setup already
    //
    public boolean hasAnotherDefaultTermsAndConditionsSet(Campaign_Program__c cp){
        List<Campaign_Program__c> cpList = [
            select Program__c, id,  Default__c
            from Campaign_Program__c 
            where Program__c = :cp.Program__c 
            and id != :cp.Id
            and Default__c = true];
        
        if (cpList.size() > 0){
            return true;
        }
        
        return false;
    }
    //restructure code to check for all required branding 
    public void hasAllBranding(Program__c prog){
        if(prog.Publish_BOCA__c == true){
        	if(prog.Custom_Email_Header_URL__c == null){
            	prog.addError('Email header url must be present to publish the program');
        	}
            if(prog.Form_Template__c == null){
                prog.addError('Form template must be chosen to publish the program');
            }
            if(prog.Brand_Color_1__c == null){
                prog.addError('Brand color 1 must have a value in order to publish the program');
            }
            if(prog.Brand_Color_2__c == null){
                prog.addError('Brand color 2 must have a value in order to publish the program');
            }
            
            // Check Attachments
        	List<attachment> attachments = [SELECT id, name from Attachment where Parentid =: prog.Id];
        
        	Boolean hasLogo = false;
        	Boolean hasCardImage = false;
        
    	    for(Integer i = 0; i < attachments.size(); i++) {
	            if(attachments[i].name == 'ui-logo.png') { hasLogo = true; }
    	        if(attachments[i].name == 'ui-credit-card.png') { hasCardImage = true; }
	        }
        
    	    if(!hasCardImage || !hasLogo) {
	            prog.addError('Please ensure this program has both attachments - card image (\"ui-credit-card.png\") and logo (\"ui-logo.png\").');
        	}
            
            List<BOCA_res__c> br = [SELECT ISO_code__c, Email_Template_ID__c, Name FROM BOCA_res__c WHERE Program__c =: prog.id];
            if(br.size() == 0){
                prog.addError('Program must have at least one Branding Utility created in order to publish.');
                
            }
            if(br.size() != 0){
                for(BOCA_res__c b : br){
                    if(b.ISO_code__c == null){
                        prog.addError('Branding resource ' + b.name + ' must have an ISO code in order to publish the program');
                    }
                    if(b.Email_Template_ID__c == null){
                        prog.addError('Branding resource ' + b.Name + ' must have an email template in order to publish the program');
                    }
                }
                
            }
            
        }
        
        
        
    }
    
    public boolean hasDefaultTermsAndConditions(Id pgmId){
        
        List<Campaign_Program__c> cpList = [
            select id, Program__c, Default__c
            from Campaign_Program__c 
            where Program__c = :pgmId 
            and Default__c = true];
        
        if (cpList.size() > 0){
            return true;
        }
        
        return false;
    }
    
    public boolean hasDefaultOnlineApplicationOffer(Id pgmId){
        
        List<OnlineApplicationOffer__c> onlineOffers = [
            select id, Program__c, BOCA_Default_Offer__c
            from OnlineApplicationOffer__c 
            where Program__c = :pgmId 
            and BOCA_Default_Offer__c = true];
        
        if (onlineOffers.size() > 0){
            return true;
        }
        
        return false;
    }
    
    public boolean isPublished (id pgmId){
        List<Program__c> pgm = [select Publish_BOCA__c from program__c where id = :pgmId];
        
        if (pgm.size() > 0 && pgm[0].Publish_BOCA__c == true){
            return true;
        }
        
        return false;
    }
}