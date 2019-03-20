public class OTRBOCAErrorController {
    
    public Program__c program { get; set; }
    
    public String errorReferenceNumber { 
        get {
            return ApexPages.CurrentPage().getParameters().get('errorReferenceNumber');
        }
    }
    
    public String errorTimeStamp { 
        get {
            return String.valueOf(Date.today());
        }
    }
    
    public String programParameter { 
        get { 
            return ApexPages.CurrentPage().getParameters().get('pgm');
        }                           
	}
    
    public String languageCode { 
        get {
            String languageCodeParameter = ApexPages.CurrentPage().getParameters().get('lang');
        	
            if(languageCodeParameter == null || languageCodeParameter == '') {
                return 'en_us';
            }
            return languageCodeParameter;
    	}
	}
    
    public String errorCode {
        get {
            String errorCodeParameter = ApexPages.currentPage().getParameters().get('errorCode');
            
            if(errorCodeParameter == '' || errorCodeParameter == null) {
                return '1';
            }
            
            return errorCodeParameter;
        }
    }
    
    public OTRBOCAErrorController() {
        
        if(!String.isEmpty(programParameter)) {
            List<Program__c> programs = [SELECT Id, Analytics_Body_Block__c, Analytics_Head_Block__c,  
                                         Inside_Sales_Phone_Number__c, Brand_Color_1__c, Brand_Color_2__c
                                         FROM Program__c WHERE Brand_Short_Name__c = :programParameter];
            
            if(!programs.isEmpty()) {
				program = programs[0]; 
			}
        }
        
    }
    
}