({
	onGohelper : function(component, event, helper) {
        debugger;
        var aactNumber= component.find('AccountNumber').get('v.value');
        var zipCode = component.find('zipCode').get('v.value');
        var action = component.get('c.validateAccountAndZip');
        var self=this;
        
        action.setParams({
            aactNumber:aactNumber,
            zipCode:zipCode
        })
        action.setCallback(this, function(response){
            console.log('response: ', response.getReturnValue());
            var rtnValue = response.getReturnValue();
            console.log('response.getState', response.getState());
            var state = response.getState();
            if(state === 'SUCCESS'){
                if(rtnValue ==='The Account Number is invalid'){
                     component.set("v.showErrorAccount", false);
                    component.set("v.showErrorZipCode", false);
                    component.set("v.showMessage", true);
                     component.set("v.showError", false);
                    component.set("v.message", 'Will be landed to New page'); 
                    
                  /*  
                    component.set("v.showErrorAccount", true);
 					component.set("v.showMessage", false);
                     component.set("v.showError", false);
                    component.set("v.AccounterrorMessage", 'The Account Number is invalid'); */
                }
                else if(rtnValue ==='The Postal Code is invalid'){
                    component.set("v.showErrorZipCode", true);
                    component.set("v.showMessage", false);
                     component.set("v.showError", false);
                   // component.set("v.zipErroMessage", 'The Postal Code is invalid');
                     component.set("v.zipErroMessage", 'The Account number/Carrier ID & Billing Postal Code does not match');
                    
                }else if(rtnValue ==='Both are invalid'){
                   component.set("v.showErrorAccount", false);
                    component.set("v.showErrorZipCode", false);
                    component.set("v.showMessage", true);
                     component.set("v.showError", false);
                    component.set("v.message", 'Will be landed to New page'); 
                    
                 /*   component.set("v.showErrorAccount", true);
                    component.set("v.showMessage", false);
                    component.set("v.AccounterrorMessage", 'The Account Number is invalid');   
                    component.set("v.showErrorZipCode", true);
                     component.set("v.showError", false);
                    component.set("v.zipErroMessage", 'The Postal Code is invalid'); */
                }
                    else if(rtnValue ==='NA fleet SUCCESS'){
                    
                    component.set("v.showErrorAccount", false);
                    component.set("v.showErrorZipCode", false);
                    component.set("v.showMessage", true);
                         component.set("v.showError", false);
                    component.set("v.message", 'NA fleet SUCCESS'); 
                        //navigate to NA fleet page
                        //Toast Msg should be displayed
                }else if(rtnValue ==='EFS SUCCESS'){
                    component.set("v.showErrorAccount", false);
                    component.set("v.showErrorZipCode", false);
                    component.set("v.showMessage", true);
                    component.set("v.showError", false);
                    component.set("v.message", 'EFS SUCCESS');  
                    //navigate to efs page
                }else if(rtnValue ==='EFS not matching'){
                    component.set("v.showErrorAccount", false);
                    component.set("v.showErrorZipCode", false);
                    component.set("v.showMessage", true);
                     component.set("v.showError", false);
                    component.set("v.message", 'Will be landed to New page');  
                }
                    else if(rtnValue ==='not matching'){
                        component.set("v.showErrorAccount", false);
                        component.set("v.showErrorZipCode", false);
                          component.set("v.showMessage", false);
                        component.set("v.showError", true);
                        component.set("v.errorMessage", 'The Account number/Carrier ID & Billing Postal Code does not match');  
                    }
            }else if(state === 'ERROR'){
                alert('Error');
            }
        });
        $A.enqueueAction(action);
    }
})