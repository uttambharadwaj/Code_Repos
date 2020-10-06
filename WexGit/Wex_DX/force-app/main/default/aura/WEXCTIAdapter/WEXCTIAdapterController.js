({
    doInit: function(component, event, helper) {

        // Need to get some user information!
        var action = component.get('c.getUserInformation');

        component.set('v.hideMatched', true);

        console.log('***** doInit *****');

        action.setCallback(this, function(response) {

            var state = response.getState();

            if(component.isValid() && state === "SUCCESS") {

                component.set('v.userRecord', response.getReturnValue());

                component.set('v.username', component.get('v.userRecord.ACD_Id__c'));

                var settingsAction = component.get('c.getCTIPOPSettings');

                settingsAction.setCallback(this, function(response) {

                    state = response.getState();

                    if(component.isValid() && state === "SUCCESS") {

                        component.set('v.ctiPOPSettings', response.getReturnValue());
                        component.set('v.boshURL', component.get('v.ctiPOPSettings.BOSH_URL__c'));
                        component.set('v.finesseAPIUrl', component.get('v.ctiPOPSettings.Finesse_API_URL__c'));
                        component.set('v.popMinimizeTime', component.get('v.ctiPOPSettings.PopupMinimizeTime__c'));
                        component.set('v.userNameSuffix', component.get('v.ctiPOPSettings.Username_Suffix__c'));
                        component.set('v.gadgetEnabled', component.get('v.ctiPOPSettings.Gadget_Enabled__c'));
                        component.set('v.ctiPopFlow', component.get('v.ctiPOPSettings.Default_Component__c'));

                        var userAction = component.get('c.getCachedFinesseUser');

                        userAction.setCallback(this, function(userResponse) {

                            var userState = userResponse.getState();
                            var userInfo = userResponse.getReturnValue();

                            if(component.isValid() && userState === "SUCCESS") {
                                console.log('***** doInit getCachedFinesseUser SUCCESS***** Username: ' + userInfo.username + " password: " + userInfo.password);
                                component.set('v.username', userInfo.username);
                                component.set('v.password', userInfo.password);

                                var a = component.get('c.performLogin');
                                $A.enqueueAction(a);
                            }

                        });

                        $A.enqueueAction(userAction);
                    }
                });

                $A.enqueueAction(settingsAction);

            }

        });

        $A.enqueueAction(action);

    },

    formPress: function(component, event, helper) {
		if (event.keyCode === 13) {
			var a = component.get('c.performLogin');
            $A.enqueueAction(a);
		}
		
	},

    performLogin : function(component, event, helper) {

        var name = component.get('v.username');
        var username = name.toLowerCase();
        var password = component.get('v.password');

        console.log('performLogin Username : ' + username + " pass: " + password + " uname: " + name);

        if(username){

            var spinner = component.find("loadingSpinner");
            $A.util.removeClass(spinner, "slds-hide");

            console.log(component.get('v.userRecord'));

            var BOSH_SERVICE=component.get('v.boshURL');
            console.log('BOSH_SERVICE: ' + BOSH_SERVICE);

            window.connection = null;

            window.connection = new Strophe.Connection(BOSH_SERVICE);

            console.log('Username Suffix: ' + component.get('v.userNameSuffix'));

            window.connection.connect(username + component.get('v.userNameSuffix'), password, function(status) {

                console.log(status);

                if(status == Strophe.Status.CONNECTED) {
                    console.log('CONNECTED TO BOSH SERVICE SUCESSFULLY');

                    // Callout to Finesse API to get user information
                    helper.updateUserInfoFromFinesse(component, helper);

                    component.set('v.showError', false);
                    component.set('v.errorMessage', '');
                    component.set('v.username', username);
                    component.set('v.password', password);

                    // Have to send presence to receive messages!
                    window.connection.send($pres());

                    window.connection.addHandler(function(msg) { console.log(msg); helper.onFinesseMessage(msg, component, helper, event); return true; }, null, "message", null, null, null);

                    $A.util.addClass(spinner, "slds-hide");

                    component.set('v.loggedIn', true);

                    console.log('CACHING USER DETAILS');
                    helper.cacheFinesseLogin(component);

                }
                else if(status == Strophe.Status.AUTHFAIL) {

                    component.set('v.showError', true);
                    component.set('v.errorMessage', 'Unable to login! Please check your username and password!');

                    $A.util.addClass(spinner, "slds-hide");

                }
                else if (status == Strophe.Status.CONNFAIL || status == Strophe.Status.CONNTIMEOUT || status == Strophe.Status.ERROR) {

                    component.set('v.showError', true);
                    component.set('v.errorMessage', 'Unable to connect to Finesse.');

                    $A.util.addClass(spinner, "slds-hide");

                }
                else {

                    component.set('v.showError', false);
                    component.set('v.errorMessage', '');
                }

            });
        }
    },

    answerCall : function(component, event, helper) {

    },

    endCall : function(component, event, helper) {

    },

    performLogout : function(component, event, helper) {

        window.connection.disconnect();

        component.set('v.loggedIn', false);
        component.set('v.password', '');

    }

})