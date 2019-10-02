// TODO Add call controls
// TODO Add presence controls

({

    // Default handler for all Finesse messages from the BOSH service
    onFinesseMessage: function (msg, component, helper) {

        var ctiPopFlow = component.get('v.ctiPopFlow');

        // Convert the XML to JSON for easier usability
        var x2js = new X2JS();

        var results = x2js.xml2json(msg);

        if (results.event.items.item.notification != null) {

            console.log('### Debug: Helper: onFinesseMessage: Received Notification');

            var notificationResults = x2js.xml_str2json(results.event.items.item.notification);

            if (notificationResults.Update.data.user != undefined) {

                console.log('### Debug: Helper: onFinesseMessage: Received Presence Update');

                if (notificationResults.Update.data.user.state != undefined) {

                    this.handlePresence(component, notificationResults.Update.data.user.state);

                }

            }

            if (notificationResults.Update.data.dialogs != undefined && notificationResults.Update.data.dialogs.Dialog != undefined) {

                console.log('### Debug: Helper: onFinesseMessage: Received Call Notification');

                if (notificationResults.Update.data.dialogs.Dialog.state === "ALERTING" && notificationResults.Update.event === "POST") {

                    // This path will

                    console.log('### Debug: Helper: onFinesseMessage: Received Call Notification - INCOMING CALL');

                    // Grab the ANI
                    var ani = notificationResults.Update.data.dialogs.Dialog.fromAddress;

                    ani = ani.replace(new RegExp("^\\+1", "i"), "");

                    component.set('v.ani', ani);
					
                    component.set('v.sessionId', notificationResults.Update.data.dialogs.Dialog.id);
                    
                    var accountNumber = undefined;
                    var cardNumber = undefined;

                    // open the cti pop
                    var utilityAPI = component.find("WEXCTIAdapter");
                    utilityAPI.openUtility();

                    // Iterating over the call variables to pull out custom attributes from the IVR
                    for (var i = 0; i < notificationResults.Update.data.dialogs.Dialog.mediaProperties.callvariables.CallVariable.length; i++) {

                        var callVariableName = notificationResults.Update.data.dialogs.Dialog.mediaProperties.callvariables.CallVariable[i].name;
                        var callVariableValue = notificationResults.Update.data.dialogs.Dialog.mediaProperties.callvariables.CallVariable[i].value;

                        console.log('### Debug: Helper: onFinesseMessage: Call Variable: ' + callVariableName + ' : ' + callVariableValue);

                        switch(callVariableName) {

                            case "eccCardNumber":
                                cardNumber = callVariableValue;
                                component.set('v.cardNumber', callVariableValue);
                                break;
                            case "callVariable5":
                                component.set('v.ivrFunction', callVariableValue);
                                break;
                            case "callVariable6":
                                component.set('v.callerType', callVariableValue);
                                break;
                            case "eccDriverID":
                                component.set('v.dId', callVariableValue);
                                break;
                            case "eccLanguage":
                                component.set('v.language', callVariableValue);
                                break;
                            case "eccBillingAccount":
                                accountNumber = callVariableValue;
                                component.set('v.accountNumber', callVariableValue);
                                break;
                            case "eccLOB":    
                                component.set('v.LOB', callVariableValue);
                                break;
                        }

                    }

                    // This allows us to control the flow based on the user Profile (Service vs Sales)
                    if (ctiPopFlow === "c__CustomerDetails") {

                        console.log('### Debug: Helper: onFinesseMessage: c__CustomerDetails: Firing account search...');

                        helper.getCustomerDetails(component, accountNumber, cardNumber, ani, notificationResults.Update, helper);
						//helper.logIVRCallData(notificationResults.Update, component, customerSearchResult);
                        
                        var minimizeTimeMS = component.get('v.popMinimizeTime');
                        helper.sleep(minimizeTimeMS).then(() => {
                            component.find("WEXCTIAdapter").minimizeUtility();
                        });

                    } else if (ctiPopFlow === "i2iSearchPage") {

                        // DO NOTHING

                    }

                } else if (notificationResults.Update.event === "DELETE") {

                    console.log('### Debug: Helper: onFinesseMessage: Received Call Notification - CALL ENDED');

                    this.resetCallVariables(component);
					this.hideMatchedText(component);

                }

            }

        }

    },

    // Sleep function
    sleep : function (time){
        return new Promise((resolve) => setTimeout(resolve, time));
    },

    // Shows the search results
    showMatchedText : function(component, text, searchResults) {

        component.set('v.searchResults', searchResults);
        component.set('v.showMatchedText', true);
        component.set('v.searchResultsText', text);
    },

    // Hides the search results
    hideMatchedText : function(component) {

        component.set('v.showMatchedText', false);
    },

    // Gets customer details for the CustomerDetails service
    getCustomerDetails: function (component, accountNumber, cardNumber, ani, ctiData, helper) {

        console.log('### Debug: Helper: getCustomerDetails: ' + accountNumber + '/ani: ' + ani + '/card: ' + cardNumber + '/' + JSON.stringify(ctiData));

        var action = component.get("c.accountAndContactSearch");

        action.setParams({
            accountNumber: accountNumber,
            cardNumber: cardNumber,
            ani: ani
        });

        action.setCallback(this, function (response) {

            var state = response.getState();

            console.log(state);
            console.log(response.getReturnValue());

            if (component.isValid() && state === "SUCCESS") {

                var accountDetailsResult = response.getReturnValue();

                if(accountDetailsResult !== null) {
                    ctiData.SearchDisposition = accountDetailsResult.searchDisposition;
                }

                helper.logIVRCallData(ctiData, component, accountDetailsResult);
                
                if (accountDetailsResult !== null && accountDetailsResult.wexAccountNumber !== undefined && accountDetailsResult.wexAccountNumber !== "") {

                    var workspaceAPI = component.find("workspace");
                    workspaceAPI.openTab({
                        pageReference: {
                            "type": "standard__component",
                            "attributes": {
                                "componentName": component.get("v.ctiPopFlow")
                            },
                            "state": {
                                "c__accountNumber": accountDetailsResult.wexAccountNumber
                            }
                        },
                        focus: true
                    });

                    helper.showMatchedText(component, ctiData.SearchDisposition, 'match_found');
                    
                }
                else {

                    helper.showMatchedText(component, ctiData.SearchDisposition, 'no_match_found');
                }

                component.set('v.accountDetails', accountDetailsResult);

            }

        });

        $A.getCallback(function() {
            $A.enqueueAction(action);
        })();

    },

    // Handles any presence changes and transforms to a friendly name,
    // plus handles update from Finesse API during state transitions
	handlePresence: function (component, presence) {

        console.log(presence);

        var presenceStates = new Map([
            ['TALKING', 'Talking'],
            ['RESERVED', 'Reserved'],
            ['NOT_READY', 'Not Ready'],
            ['READY', 'Ready'],
            ['WORK', 'Wrap Up'],
            ['HOLD', 'On Hold'],
            ['LOGOUT', 'Not Logged Into Finesse']
        ]);

        // If we change state, we need to go back to the API and grab the user data
        if(component.get('v.presenceType') !== presence) {
            this.updateUserInfoFromFinesse(component, this);
        }

        component.set('v.presenceType', presence);
        component.set('v.presenceTypeText', presenceStates.get(presence));

        if(presence === 'READY'){
         	this.hideMatchedText(component);
        }

    },

    // Searches the i2i database
    getSalesDetails: function (component, ani) {

    },

    // FUTURE - Answer incoming call
    answerCall: function (component, currentDialog) {

        var Dialog = null;

        Dialog.requestedAction = 'ANSWER';
        Dialog.targetMediaAddress = component.get('v.extension');

        // var x2js = new X2JS();
        //
        // var results = x2js.xml2json(msg);


    },

    // FUTURE - Generate outbound call
    startCall: function (component) {

    },

    // FUTURE - End current call
    endCall: function (component) {

    },

    // FUTURE - Set presence in Finesse
    setPresence: function (component) {

    },

    // Grabs user data from Finesse REST API
    updateUserInfoFromFinesse: function (component, helper) {
        axios({
            method: 'get',
            url: component.get('v.finesseAPIUrl') + '/api/User/' + component.get('v.username'),
            auth: {
                username: component.get('v.username'),
                password: component.get('v.password')
            }
        }).then(function (response) {
            if (response !== undefined && response.status === 200) {
                var x2js = new X2JS();

                var responseJson = x2js.xml_str2json(response.data);
                console.log(response.data);
                console.log(responseJson);

                component.set('v.extension', responseJson.User.extension);

                console.log(responseJson.User.state);

                helper.handlePresence(component, responseJson.User.state);
            }
        });
    },

    // Reset the call variables
    resetCallVariables: function(component) {

        component.set('v.ani', null);
        component.set('v.accountNumber', null);
        component.set('v.ivrFunction', null);
        component.set('v.callerType', null);
        component.set('v.language', null);
        component.set('v.dId', null);
        component.set('v.searchResults', null);

    },
 	
    logIVRCallData: function(ctiData, component, customerSearchResult){
		console.log('### Debug: Helper: PersistIVRData:');

		var externalAccountNumber = component.get('v.accountNumber');
        var cardNumber = component.get('v.cardNumber');
		var iVROption	= component.get('v.ivrFunction');
        var iVRPayload = JSON.stringify(ctiData);	
        var lob = component.get('v.LOB');
		var matchedOn = customerSearchResult.matchedOn;
		var matchType = customerSearchResult.matchType;				
		var sessionId = component.get('v.sessionId');
        var ani = component.get('v.ani');
		//component.get('v.callerType');		        

        console.log('### Debug: Helper: PersistIVRData ExternalAccountNumber:' + externalAccountNumber + '  CardNumber: ' + cardNumber
                    + ' IVROption: ' + iVROption
                   + ' LOB: ' + lob
                   + ' MatchedOn: ' + matchedOn
                   + ' MatchType: ' + matchType
                   + ' SessionId: ' + sessionId
                   + ' ANI: ' + ani
                   + ' IVRPayload: ' + iVRPayload);
        
        var action = component.get("c.persistIVRCallData");

        action.setParams({
            externalAccountNumber: externalAccountNumber,
            cardNumber: cardNumber,
            iVROption: iVROption,
            iVRPayload: iVRPayload,
            lob: lob,
            matchedOn: matchedOn,
            matchType: matchType,
            sessionId:sessionId,
            ani: ani
        });

        action.setCallback(this, function (response) {

            var state = response.getState();

            console.log(state);
            console.log(response.getReturnValue());

            if (component.isValid() && state === "SUCCESS") {                

            }

        });

        $A.getCallback(function() {
            $A.enqueueAction(action);
        })();
                      
                                                        
    }
   
})