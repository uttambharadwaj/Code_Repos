/**
* Forseva online application code.
*/
public virtual class ForsevaControllerBase {

    //------------------
    // protected
    //------------------
    
    protected void addSuccessMessage(String msg) {
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, msg));  
    }
        
    protected void addErrorMessage(String msg) {
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, msg));     
    }

    protected void handleException(Exception e, Boolean showException, String optionalMessage) {
    	
        System.debug('FORSEVA handleException(): ' + e.getTypeName() + ': ' + e.getMessage());
        if(showException && optionalMessage != null) {
            addErrorMessage(optionalMessage);
        }
    }
    
}

// EOF