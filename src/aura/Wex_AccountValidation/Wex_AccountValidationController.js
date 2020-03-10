({
	doInit : function(component, event, helper) {
		
	},
     onPress: function(component,event,helper){
      
        if(event.keyCode === 13){
         
        helper.onGohelper(component, event, helper);
            }
    },
    onGo :  function(component,event,helper){
        var confirmAccountNumber =  component.get("v.confirmAccountNumber");
          var getAccountNumber = component.find("AccountNumber").get("v.value");
        var getConfirmAccountNumber = component.find("ConfirmAccountNumber").get("v.value");
        if(getAccountNumber != getConfirmAccountNumber) {
            component.set("v.showMessage", false);
            component.set("v.showErrorAccount", false);
            component.set("v.showErrorZipCode", false);
             component.set("v.confirmAccountNumber", false);
            component.set("v.showError", true);
            component.set("v.errorMessage", 'The Account number & Confirmation Account Number does not match');
        }else{
            component.set("v.confirmAccountNumber", true);
            component.set("v.showError", false);
            component.set("v.errorMessage", '');
               helper.onGohelper(component, event, helper);
        }
        
       /* if(confirmAccountNumber){
            helper.onGohelper(component, event, helper);
        } */
    },
    checkAccountNumber :  function(component,event,helper){
        var getAccountNumber = component.find("AccountNumber").get("v.value");
        var getConfirmAccountNumber = component.find("ConfirmAccountNumber").get("v.value");
        if(getAccountNumber != getConfirmAccountNumber) {
            component.set("v.showMessage", false);
            component.set("v.showErrorAccount", false);
            component.set("v.showErrorZipCode", false);
             component.set("v.confirmAccountNumber", false);
            component.set("v.showError", true);
            component.set("v.errorMessage", 'The Account number & Confirmation Account Number does not match');
        }else{
            component.set("v.confirmAccountNumber", true);
            component.set("v.showError", false);
            component.set("v.errorMessage", '');
        }
    }
})