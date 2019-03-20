/*
 * 
 * This class allows the HTML TNC's to be displayed and not mess with the rest of the BOCA
 * 
 */
public class OTRTermsAndConditionsController {

    public String tncID {
        get {
            return ApexPages.CurrentPage().getParameters().get('attachmentId');
        }
    }
    
    public String termsAndConditions { 
        get {
            System.debug(tncId);
           	Attachment tnc = [SELECT Id, Name, Body FROM Attachment where Id = :tncId];
            
            if(tnc != null) {
				HttpRequest tmp = new HttpRequest();
				tmp.setBodyAsBlob(tnc.Body);
                        
                String converted = tmp.getBody();
                        
				return converted;
           	}
            
           	return null;
        }
    }
    
    public OTRTermsAndConditionsController() {

    }
    
}