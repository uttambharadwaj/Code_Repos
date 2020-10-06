public with sharing class ProgramEmailAssetController {
    
    public String programId { get; set; }
    
    public String brandingLogo {
        get {
            System.debug(programId);
     		if(programId != null) {
                try {
					transient Attachment logo = [SELECT Id, Name, Body FROM Attachment where ParentId = :programId AND Name = 'ui-logo.png'];
                    
                    return logo.Id;
                }
                catch(Exception e) {
                    
                }
        	}       
            return null;
        }
    }
    
    public String brandingCard {
        get {
            System.debug(programId);
     		if(programId != null) {
				transient Attachment card = [SELECT Id, Name, Body FROM Attachment where ParentId = :programId AND Name = 'ui-credit-card.png'];
                
                return card.Id;
        	}       
            return null;
        }
    }
    
    public ProgramEmailAssetController() {
        
    }

}