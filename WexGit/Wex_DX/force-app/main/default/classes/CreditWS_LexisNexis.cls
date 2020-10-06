/*
*
* Credit Decisioning Process
* Module: Lexis/Nexis
* Author: Derek Gilbert
* Initial Date: 3/5/2018
*
*/
global class CreditWS_LexisNexis {

    public static Credit_Decision_Engine_Endpoints__mdt lnSettings {
        get {

            try {

                Credit_Decision_Engine_Endpoints__mdt lnSettings = [SELECT Id, Account_ID__c, Operating_Mode__c FROM Credit_Decision_Engine_Endpoints__mdt WHERE DeveloperName = 'LexisNexisIID'];

                return lnSettings;

            }
            catch(Exception e) {

                System.debug('### ERROR: Error getting Lexis Nexis connection settings.');

            }

            return null;

        }
    }

    public static Id passedBeneficialEntityId { get; set; }

    public static String lexisNexisLog { get; set; }
    
    public static String userSessionId {
        get {
            return UserInfo.getSessionId();
        }
    }

    public CreditWS_LexisNexis() {

    }

    // Legacy backfill for Lightning
    public CreditWS_LexisNexis(ApexPages.StandardController controller) {
        passedBeneficialEntityId = controller.getRecord().id;
    }

    public class lexisNexisException extends Exception {}

    // Legacy backfill for Lightning
    public static PageReference runBeneficialOwnerVerificationVF() {

        if(passedBeneficialEntityId != null) {

            List<Beneficial_Owner_Entity__c> beneficialOwnerEntity = [SELECT Id, No_Beneficial_Owners__c, Record_Status__c, Verification_Status__c, Certified_By__c, Certified_Date__c, Legal_Structure__c, Paper_App__c FROM Beneficial_Owner_Entity__c WHERE Id =: passedBeneficialEntityId];

            if(beneficialOwnerEntity.size() > 0) {

                if(!(beneficialOwnerEntity[0].Record_Status__c).equalsIgnoreCase('Archived') && !(beneficialOwnerEntity[0].Verification_Status__c).equalsIgnoreCase('Exempted') && !(beneficialOwnerEntity[0].Verification_Status__c).equalsIgnoreCase('Passed')) {

                     if((beneficialOwnerEntity[0].Certified_By__c == null || beneficialOwnerEntity[0].Certified_Date__c == null) && !beneficialOwnerEntity[0].Paper_App__c) {

                        ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, 'Please ensure you have the Certified By and Certified Date fields filled in before running verification!'));

                    }
                    else {

                        List<Beneficial_Owner_Prong__c> owners = [SELECT Id FROM Beneficial_Owner_Prong__c WHERE Beneficial_Owner_Entity__c =: passedBeneficialEntityId and (RecordType.Name = 'Beneficial Owner' or RecordType.Name = 'Beneficial Owner - Locked')];

                        List<Beneficial_Owner_Prong__c> controllers = [SELECT Id FROM Beneficial_Owner_Prong__c WHERE Beneficial_Owner_Entity__c =: passedBeneficialEntityId and (RecordType.Name = 'Control Person' or RecordType.Name = 'Control Person - Locked')];

                        if(!(beneficialOwnerEntity[0].Legal_Structure__c).equalsIgnoreCase('Non-Profit') && beneficialOwnerEntity[0].No_Beneficial_Owners__c == false && owners.size() == 0) {

                            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, 'No Beneficial Owner records exist. Please only run verification after they have been added.'));

                        }
                        else {

                            if(controllers.size() == 0) {

                                ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, 'No Control Person record exists. Please only run verification after they have been added.'));

                            }
                            else {

                                beneficialOwnerVerification(passedBeneficialEntityId);

                                PageReference redirect = new PageReference('/' + passedBeneficialEntityId);

                                return redirect;

                            }

                        }

                    }

                }
                else {

                    ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, 'Verification cannot be run from an archived record, or any record that is either exempted, or has already passed verification'));

                }


            }
            else {

                ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, 'Unable to find entity. Please try again.'));

            }

        }
        else {

            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, 'No ID was passed.'));

        }

        return null;

    }

    // If called from a button
    webservice static void runBeneficialOwnerVerificationButton(Id beneficialEntityId) {
        beneficialOwnerVerification(beneficialEntityId);
    }

    @future(callout=true)
    public static void beneficialOwnerVerificationFutureCallout(Id beneficialEntityId) {
        beneficialOwnerVerification(beneficialEntityId);
    }

    // If called from APEX
    public static void beneficialOwnerVerification(Id beneficialEntityId) {

        try {

            Beneficial_Owner_Entity__c boEntity = [SELECT Id, Record_Status__c, RecordTypeId, RecordType.Name, Opportunity__c, Lexis_Nexis_Log__c, Verification_Log__c, Verification_Status__c, Application_Request__c FROM Beneficial_Owner_Entity__c WHERE Id =: beneficialEntityId];

            List<Beneficial_Owner_Prong__c> boOwners = [SELECT Id, RecordType.Name, First_Name__c, Last_Name__c, Address_Line_1__c, City__c,
                    State__c, Postal_Code__c, Date_of_Birth__c, Verification_Status__c, Social_Security_Number__c,
                    Country__c, Country_of_Issue__c
            FROM Beneficial_Owner_Prong__c WHERE Beneficial_Owner_Entity__c =: beneficialEntityId];

            if(boOwners.size() == 0) {
                throw new lexisNexisException('No Beneficial Owner records exist. Please add Beneficial Owners/Control Person records before running verification.');
            }

            Boolean overallVerified = true;

            String overallVerificationLog = '';

            for(Beneficial_Owner_Prong__c boOwner : boOwners) {

                if((boOwner.Verification_Status__c).equalsIgnoreCase('Passed')) {
                    continue;
                }

                String individualVerificationLog = '';

                if(boOwner.Country__c != null && (boOwner.Country__c).equalsIgnoreCase('United States') && (boOwner.Country_of_Issue__c == null || (boOwner.Country_of_Issue__c).equalsIgnoreCase('United States'))) {

                    InstantIDRequest verificationRequest = new InstantIDRequest();

                    verificationRequest.firstName = boOwner.First_Name__c;
                    verificationRequest.lastName = boOwner.Last_Name__c;

                    verificationRequest.addressLine1 = boOwner.Address_Line_1__c;
                    verificationRequest.city = boOwner.City__c;
                    verificationRequest.state = boOwner.State__c;
                    verificationRequest.postalCode = boOwner.Postal_Code__c;

                    verificationRequest.socialSecurityNumber = boOwner.Social_Security_Number__c;
                    verificationRequest.dateOfBirth = boOwner.Date_of_Birth__c;

                    InstantIDResponse verificationResults = lexisNexisInstantIDVerification(verificationRequest);

                    System.debug(verificationResults);

                    if(verificationResults != null && verificationResults.calloutFailed == false) {

                        System.debug('### HERE ' + verificationResults.verificationFailures);

                        if(verificationResults.individualVerified == false) {
                            overallVerified = false;
                            boOwner.Verification_Status__c = 'Failed';
                            boOwner.Verification_Failures__c = String.join(verificationResults.verificationFailures, ', ');
                        }
                        else {
                            boOwner.Verification_Status__c = 'Passed';
                            boOwner.Verification_Failures__c = '';

                            if((boOwner.RecordType.Name).equalsIgnoreCase('Control Person') && Schema.SObjectType.Beneficial_Owner_Prong__c.getRecordTypeInfosByName().get('Control Person - Locked') != null) {
                                boOwner.RecordTypeId = Schema.SObjectType.Beneficial_Owner_Prong__c.getRecordTypeInfosByName().get('Control Person - Locked').getRecordTypeId();
                            }

                            if((boOwner.RecordType.Name).equalsIgnoreCase('Beneficial Owner') && Schema.SObjectType.Beneficial_Owner_Prong__c.getRecordTypeInfosByName().get('Beneficial Owner - Locked') != null) {
                                boOwner.RecordTypeId = Schema.SObjectType.Beneficial_Owner_Prong__c.getRecordTypeInfosByName().get('Beneficial Owner - Locked').getRecordTypeId();
                            }
                        }

                    }
                    else {
                        overallVerified = false;
                        boOwner.Verification_Status__c = 'Failed';
                        boOwner.Verification_Failures__c = verificationResults.errorLog;
                    }

                    boOwner.Lexis_Nexis_Response__c = verificationResults.verifiedInput;


                }
                else if(boOwner.Country__c != null && (boOwner.Country__c).equalsIgnoreCase('Canada')) {

                    InstantVerifyInternationalRequest verificationRequest = new InstantVerifyInternationalRequest();

                    verificationRequest.firstName = boOwner.First_Name__c;
                    verificationRequest.lastName = boOwner.Last_Name__c;

                    verificationRequest.addressLine1 = boOwner.Address_Line_1__c;
                    verificationRequest.city = boOwner.City__c;
                    verificationRequest.state = boOwner.State__c;
                    verificationRequest.postalCode = boOwner.Postal_Code__c;

                    verificationRequest.dateOfBirth = boOwner.Date_of_Birth__c;

                    InstantVerifyInternationalResponse verificationResults = lexisNexisInstantVerifyInternationalVerification(verificationRequest);

                    System.debug(verificationResults);

                    if(verificationResults != null && verificationResults.calloutFailed == false) {

                        if(verificationResults.individualVerified) {
                            boOwner.Verification_Status__c = 'Passed';
                            boOwner.Verification_Failures__c = '';

                            if((boOwner.RecordType.Name).equalsIgnoreCase('Control Person') && Schema.SObjectType.Beneficial_Owner_Prong__c.getRecordTypeInfosByName().get('Control Person - Locked') != null) {
                                boOwner.RecordTypeId = Schema.SObjectType.Beneficial_Owner_Prong__c.getRecordTypeInfosByName().get('Control Person - Locked').getRecordTypeId();
                            }

                            if((boOwner.RecordType.Name).equalsIgnoreCase('Beneficial Owner') && Schema.SObjectType.Beneficial_Owner_Prong__c.getRecordTypeInfosByName().get('Beneficial Owner - Locked') != null) {
                                boOwner.RecordTypeId = Schema.SObjectType.Beneficial_Owner_Prong__c.getRecordTypeInfosByName().get('Beneficial Owner - Locked').getRecordTypeId();
                            }
                        }
                        else {
                            overallVerified = false;
                            boOwner.Verification_Status__c = 'Failed';
                            boOwner.Verification_Failures__c = String.join(verificationResults.verificationFailures, ', ');
                        }

                    }
                    else {
                        overallVerified = false;
                        boOwner.Verification_Status__c = 'Failed';

                        if(verificationResults.errorLog != null) {
                            boOwner.Verification_Failures__c = verificationResults.errorLog;
                        }
                        else {
                            boOwner.Verification_Failures__c = 'Error during Lexis/Nexis call-out. Please try re-running validation.';
                        }
                    }

                }
                else {
                    overallVerified = false;
                    boOwner.Verification_Status__c = 'Failed';
                    boOwner.Verification_Failures__c = 'Owner does not reside in the US. Document-based verification needed.';
                }

                // Add to the BO Parent verification log
                if(overallVerified == false) {
                    if(!(overallVerificationLog).equalsIgnoreCase('')) { overallVerificationLog += ' || '; }
                    overAllVerificationLog += 'Failures For \'' + boOwner.Last_Name__c + ', ' + boOwner.First_Name__c + '\': ' + boOwner.Verification_Failures__c;
                }

            }

            upsert boOwners;
			System.debug('overallVerified: ' + overallVerified);
            if(overallVerified == false) {
                boEntity.Verification_Status__c = 'Failed';
                boEntity.Verification_Log__c = overAllVerificationLog;
            }
            else {
                boEntity.Verification_Status__c = 'Passed';
                boEntity.Verification_Log__c = '';

                if((boEntity.RecordType.Name).equalsIgnoreCase('Fuel Card')) {
                    if(Schema.SObjectType.Beneficial_Owner_Entity__c.getRecordTypeInfosByName().get('Fuel Card - Locked') != null) {
                        boEntity.RecordTypeId = Schema.SObjectType.Beneficial_Owner_Entity__c.getRecordTypeInfosByName().get('Fuel Card - Locked').getRecordTypeId();
                    }
                }

                if((boEntity.RecordType.Name).equalsIgnoreCase('Fleet Card')) {
                    if(Schema.SObjectType.Beneficial_Owner_Entity__c.getRecordTypeInfosByName().get('Fleet Card - Locked') != null) {
                        boEntity.RecordTypeId = Schema.SObjectType.Beneficial_Owner_Entity__c.getRecordTypeInfosByName().get('Fleet Card - Locked').getRecordTypeId();
                    }
                }

                if((boEntity.RecordType.Name).equalsIgnoreCase('Factoring')) {
                    if(Schema.SObjectType.Beneficial_Owner_Entity__c.getRecordTypeInfosByName().get('Fleet Card - Locked') != null) {
                        boEntity.RecordTypeId = Schema.SObjectType.Beneficial_Owner_Entity__c.getRecordTypeInfosByName().get('Factoring - Locked').getRecordTypeId();
                    }
                }
            }
			
            if((boEntity.Record_Status__c).equalsIgnoreCase('Awaiting Customer')) {
                boEntity.Record_Status__c = 'Active';
            }
		
            upsert boEntity;

            // Sending activity to Siebel - will be removed later once Credit Adjudication is moved to Salesforce.
            if((boEntity.RecordType.Name).equalsIgnoreCase('Fuel Card') && boEntity.Opportunity__c != null && boEntity.Application_Request__c != null && (boEntity.Verification_Status__c).equalsIgnoreCase('Passed')) {

                Id taskOwnerId = [SELECT Id FROM User WHERE Alias = 'dcred'].Id;

                List<Task> boInfoNeededTasks = [SELECT Id, OwnerId, Status FROM Task WHERE Type = 'BO Info Needed' and Status != 'Completed'];

                if(boInfoNeededTasks.size() > 0) {

                    taskOwnerId = boInfoNeededTasks[0].OwnerId;

                    boInfoNeededTasks[0].Status = 'Completed';

                    upsert boInfoNeededTasks[0];

                }

                Task creditTask = new Task();

                creditTask.RecordTypeId = UtilityClass.getRecordTypeByName(Task.getSObjectType(),'General');
                creditTask.Subject = 'BO Info Returned';
                creditTask.WhatId = boEntity.Opportunity__c;
                creditTask.Description = 'BO Info Gathered & Verified via Lexis/Nexis';
                creditTask.Status = 'In Progress';
                creditTask.Priority = '3-Medium';
                creditTask.Activity_Type__c = 'BO Info Returned';
                creditTask.Type = 'BO Info Returned';
                creditTask.ActivityDate = Date.today();
                creditTask.OwnerId = taskOwnerId;

                insert creditTask;

            }

        }
        catch(Exception e) {

        }

    }

    public static InstantIDResponse lexisNexisInstantIDVerification(InstantIDRequest request) {

        InstantIDResponse response = new InstantIDResponse();

        try {

            HttpRequest req = new HttpRequest();
            req.setEndpoint('callout:Lexis_Nexis_IID');
            req.setMethod('POST');
            req.setHeader('Accept', 'application/json');
            req.setHeader('Content-Type', 'application/json');

            JSONGenerator gen = JSON.createGenerator(true);

            gen.writeStartObject();

            gen.writeFieldName('Settings');
            gen.writeStartObject();
            gen.writeStringField('AccountNumber', lnSettings.Account_ID__c);
            gen.writeStringField('Workflow', 'WEX.Bank.RDP.online.iid');
            gen.writeStringField('Mode', lnSettings.Operating_Mode__c);
            gen.writeStringField('Reference', 'Reference1');
            gen.writeStringField('Locale', 'en_US');
            gen.writeStringField('Venue', 'online');
            gen.writeEndObject();

            gen.writeFieldName('Person');
            gen.writeStartObject();

            gen.writeFieldName('Name');
            gen.writeStartObject();
            gen.writeStringField('FirstName', request.firstName);
            gen.writeStringField('LastName', request.lastName);
            gen.writeEndObject();

            gen.writeFieldName('Addresses');
            gen.writeStartArray();
            gen.writeStartObject();
            gen.writeStringField('StreetAddress1', request.addressLine1);
            gen.writeStringField('City', request.city);
            gen.writeStringField('State', request.state);
            gen.writeStringField('Zip5', request.postalCode);
            gen.writeStringField('Country', 'US');
            gen.writeStringField('Context', 'primary');
            gen.writeEndObject();
            gen.writeEndArray();

            gen.writeFieldName('SSN');
            gen.writeStartObject();
            gen.writeStringField('Number', request.socialSecurityNumber.replaceAll('\\D',''));
            gen.writeStringField('Type', 'ssn9');
            gen.writeEndObject();

            gen.writeFieldName('DateOfBirth');
            gen.writeStartObject();
            gen.writeStringField('Year', String.valueOf(request.dateOfBirth.year()));
            gen.writeStringField('Month', String.valueOf(request.dateOfBirth.month()));
            gen.writeStringField('Day', String.valueOf(request.dateOfBirth.day()));
            gen.writeEndObject();

            gen.writeEndObject();

            gen.writeEndObject();

            req.setBody(gen.getAsString());

            Http http = new Http();
            HTTPResponse res = http.send(req);

            if(res.getStatusCode() != 200) {
                throw new lexisNexisException(res.getBody());
            }

            System.debug(res.getBody());

            lexisNexisLog = lexisNexisLog + res.getBody();

            PassThroughs results = (PassThroughs)JSON.deserialize(res.getBody(), PassThroughs.class);

            if(results != null && results.PassThroughs != null) {

                for(PassThrough passThrough : results.PassThroughs) {

                    System.debug(passThrough);

                    if((passThrough.Type).equalsIgnoreCase('INSTANT_ID')) {

                        InstantIDResponseExWrapper lexisNexisResponse = (InstantIDResponseExWrapper)JSON.deserialize(passThrough.Data, InstantIDResponseExWrapper.class);

                        if(lexisNexisResponse.InstantIDResponseEx != null && lexisNexisResponse.InstantIDResponseEx.response != null
                                && lexisNexisResponse.InstantIDResponseEx.response.Result != null && lexisNexisResponse.InstantIDResponseEx.response.Result.VerifiedInput != null
                                && lexisNexisResponse.InstantIDResponseEx.response.Result.UniqueId != null) {

                            System.debug(lexisNexisResponse.InstantIDResponseEx.response.Result.VerifiedInput);

                            if(lexisNexisResponse.InstantIDResponseEx.response.Result.VerifiedInput.Name == null) {
                                response.verificationFailures.add('First Name');
                                response.verificationFailures.add('Last Name');
                            }

                            if(lexisNexisResponse.InstantIDResponseEx.response.Result.VerifiedInput.DOB != null) {

                                if(lexisNexisResponse.InstantIDResponseEx.response.Result.VerifiedInput.DOB.Day != request.dateOfBirth.day() ||
                                        lexisNexisResponse.InstantIDResponseEx.response.Result.VerifiedInput.DOB.Month != request.dateOfBirth.month() ||
                                        lexisNexisResponse.InstantIDResponseEx.response.Result.VerifiedInput.DOB.Year != request.dateOfBirth.year()) {

                                    response.verificationFailures.add('Date Of Birth');

                                }

                            }
                            else {
                                response.verificationFailures.add('Date Of Birth');
                            }

                            if(lexisNexisResponse.InstantIDResponseEx.response.Result.VerifiedInput.SSN != null) {

                                if(!(lexisNexisResponse.InstantIDResponseEx.response.Result.VerifiedInput.SSN).equalsIgnoreCase(request.socialSecurityNumber.replaceAll('-', ''))) {
                                    response.verificationFailures.add('Social Security Number');
                                }

                            }
                            else {
                                response.verificationFailures.add('Social Security Number');
                            }

                            if(lexisNexisResponse.InstantIDResponseEx.response.Result.VerifiedInput.Address != null) {

                                if(lexisNexisResponse.InstantIDResponseEx.response.Result.VerifiedInput.Address.StreetAddress1 == null) {

                                    response.verificationFailures.add('Address Line 1');

                                }

                                if(lexisNexisResponse.InstantIDResponseEx.response.Result.VerifiedInput.Address.City == null) {

                                    response.verificationFailures.add('City');

                                }

                                if(lexisNexisResponse.InstantIDResponseEx.response.Result.VerifiedInput.Address.State == null) {

                                    response.verificationFailures.add('State');

                                }

                                if(lexisNexisResponse.InstantIDResponseEx.response.Result.VerifiedInput.Address.Zip5 == null) {

                                    response.verificationFailures.add('Postal Code');

                                }

                            }
                            else {
                                response.verificationFailures.addAll(new List<String>{'Address Line 1', 'City', 'State', 'Postal Code'});
                            }

                            if(response.verificationFailures.size() == 0) {
                                response.individualVerified = true;
                            }

                            try {
                                // Pull back the response
                                response.verifiedInput = 'Name: ' + lexisNexisResponse.InstantIDResponseEx.response.Result.VerifiedInput.Name.First + ' ' + lexisNexisResponse.InstantIDResponseEx.response.Result.VerifiedInput.Name.Last;

                                if(lexisNexisResponse.InstantIDResponseEx.response.Result.VerifiedInput.Address != null) {

                                    response.verifiedInput += '\r\nAddress: ' + lexisNexisResponse.InstantIDResponseEx.response.Result.VerifiedInput.Address.StreetAddress1 + ', ' +
                                            lexisNexisResponse.InstantIDResponseEx.response.Result.VerifiedInput.Address.City + ', ' +
                                            lexisNexisResponse.InstantIDResponseEx.response.Result.VerifiedInput.Address.State + ' ' + lexisNexisResponse.InstantIDResponseEx.response.Result.VerifiedInput.Address.Zip5;

                                }

                                if(lexisNexisResponse.InstantIDResponseEx.response.Result.VerifiedInput.DOB != null) {

                                    response.verifiedInput += '\r\nDOB: ' + lexisNexisResponse.InstantIDResponseEx.response.Result.VerifiedInput.DOB.Month + '/' + lexisNexisResponse.InstantIDResponseEx.response.Result.VerifiedInput.DOB.Day + '/' + lexisNexisResponse.InstantIDResponseEx.response.Result.VerifiedInput.DOB.Year;

                                }

                                if(lexisNexisResponse.InstantIDResponseEx.response.Result.VerifiedInput.SSN != null) {

                                    response.verifiedInput += '\r\nSSN: XXX-XX-' + (lexisNexisResponse.InstantIDResponseEx.response.Result.VerifiedInput.SSN).right(4);

                                }

                                System.debug('### ' + response.verifiedInput);
                            }
                            catch(Exception e) {
                                System.debug('Unable to generate value for the response field');

                                response.verifiedInput += String.valueOf(lexisNexisResponse.InstantIDResponseEx.response.Result.VerifiedInput);
                            }

                        }

                    }

                }

            }

            // Overall failure catch
            if(response.individualVerified == false && response.verificationFailures.size() == 0) {

                response.verificationFailures.addAll(new List<String>{'First Name', 'Last Name', 'Date of Birth', 'Social Security Number', 'Address Line 1', 'City', 'State', 'Postal Code'});

            }



        }
        catch(Exception e) {

            System.debug(e);

            response.calloutFailed = true;
            response.errorLog = e.getMessage();
        }

        return response;

    }

    public static InstantVerifyInternationalResponse lexisNexisInstantVerifyInternationalVerification(InstantVerifyInternationalRequest request) {

        InstantVerifyInternationalResponse response = new InstantVerifyInternationalResponse();

        try {

            HttpRequest req = new HttpRequest();
            req.setEndpoint('callout:Lexis_Nexis_IVI');
            req.setMethod('POST');
            req.setHeader('Accept', 'application/json');
            req.setHeader('Content-Type', 'application/json');

            JSONGenerator gen = JSON.createGenerator(true);

            gen.writeStartObject();

            gen.writeFieldName('Settings');
            gen.writeStartObject();
            gen.writeStringField('AccountNumber', lnSettings.Account_ID__c);
            gen.writeStringField('Workflow', 'WEX.Bank.RDP.online.ivi');
            gen.writeStringField('Mode', lnSettings.Operating_Mode__c);
            gen.writeStringField('Reference', 'Reference1');
            gen.writeStringField('Locale', 'en_ca');
            gen.writeStringField('Venue', 'online');
            gen.writeEndObject();

            gen.writeFieldName('CustomData');
            gen.writeStartArray();
            gen.writeStartObject();

            gen.writeStringField('Type', 'IVI');
            gen.writeStringField('Name', 'IVI_COUNTRY_CONSENT');
            gen.writeStringField('Value', 'YES');

            gen.writeEndObject();
            gen.writeEndArray();

            gen.writeFieldName('Person');
            gen.writeStartObject();

            gen.writeFieldName('Name');
            gen.writeStartObject();
            gen.writeStringField('FirstName', request.firstName);
            gen.writeStringField('LastName', request.lastName);
            gen.writeEndObject();

            gen.writeFieldName('Addresses');
            gen.writeStartArray();
            gen.writeStartObject();
            gen.writeStringField('StreetAddress1', request.addressLine1);
            gen.writeStringField('Locality', request.city);
            gen.writeStringField('Province', request.state);
            gen.writeStringField('Postcode', request.postalCode);
            gen.writeStringField('Country', 'CA');
            gen.writeStringField('Context', 'primary');
            gen.writeEndObject();
            gen.writeEndArray();

            gen.writeEndObject();

            gen.writeEndObject();

            req.setBody(gen.getAsString());

            Http http = new Http();
            HTTPResponse res = http.send(req);

            if(res.getStatusCode() != 200) {
                throw new lexisNexisException(res.getBody());
            }

            lexisNexisLog = lexisNexisLog + res.getBody();

            InstantVerifyInternationalResponseWrapper responseWrapper = (InstantVerifyInternationalResponseWrapper) System.JSON.deserialize(res.getBody(), InstantVerifyInternationalResponseWrapper.class);

            System.debug(responseWrapper);

            if(responseWrapper.Products != null && responseWrapper.Products.size() > 0) {

                Products product = responseWrapper.Products[0];

                if(product.Items != null & product.Items.size() > 0) {

                    Items item = product.Items[0];

                    if((item.ItemStatus).equalsIgnoreCase('pass')) {

                        response.individualVerified = true;

                    }
                    else {

                        Set<String> failures = new Set<String>{'First Name', 'Last Name', 'Address Line 1', 'City', 'Province', 'Postal Code'};

                        if(item.ItemInformationDetails != null && item.ItemInformationDetails.size() > 0) {

                            for(ItemInformationDetails verificationDetails : item.ItemInformationDetails) {

                                if((verificationDetails.Value.toUpperCase()).contains('FULL MATCH') && (verificationDetails.Value.toUpperCase()).contains('FIRST NAME')) {
                                    failures.remove('First Name');
                                }

                                if((verificationDetails.Value.toUpperCase()).contains('FULL MATCH') && (verificationDetails.Value.toUpperCase()).contains('LAST NAME')) {
                                    failures.remove('Last Name');
                                }

                                if((verificationDetails.Value.toUpperCase()).contains('FULL MATCH') && (verificationDetails.Value.toUpperCase()).contains('ADDRESS LINES')) {
                                    failures.remove('Address Line 1');
                                }

                                if((verificationDetails.Value.toUpperCase()).contains('FULL MATCH') && (verificationDetails.Value.toUpperCase()).contains('CITY')) {
                                    failures.remove('City');
                                }

                                if((verificationDetails.Value.toUpperCase()).contains('FULL MATCH') && (verificationDetails.Value.toUpperCase()).contains('POSTAL CODE')) {
                                    failures.remove('Postal Code');
                                }

                                if((verificationDetails.Value.toUpperCase()).contains('FULL MATCH') && (verificationDetails.Value.toUpperCase()).contains('PROVINCE')) {
                                    failures.remove('Province');
                                }

                            }

                        }

                        response.verificationFailures.addAll(failures);

                    }

                }

            }

        }
        catch(Exception e) {
            response.calloutFailed = true;
            response.errorLog = e.getMessage();
        }

        return response;

    }

    public class InstantIDRequest {

        public String firstName;
        public String lastName;
        public String addressLine1;
        public String city;
        public String state;
        public String postalCode;
        public String socialSecurityNumber;
        public Date dateOfBirth;

    }

    public class InstantIDResponse {

        public Boolean individualVerified;

        public List<String> verificationFailures;

        public Boolean calloutFailed;
        public String errorLog;
        public String verifiedInput;

        public InstantIDResponse() {

            // Assume false unless passed in the callout
            individualVerified = false;

            verificationFailures = new List<String>();

            calloutFailed = false;

        }

    }

    // InstantID POJO's for the response
    public class PassThroughs {

        public List<PassThrough> PassThroughs;

    }

    public class PassThrough {

        public String Type;
        public String Data;

    }

    public class InstantIDResponseExWrapper {

        public InstantIDResponseEx InstantIDResponseEx { get; set; }

    }

    public class InstantIDResponseEx {

        public Response response { get; set; }

    }

    public class Response {

        public Result Result { get; set; }

    }

    public class Result {

        public String UniqueId { get; set; }
        public VerifiedInput VerifiedInput { get; set; }

    }

    public class VerifiedInput {

        public Name Name { get; set; }
        public DOB DOB { get; set; }
        public String SSN { get; set; }
        public Address Address { get; set; }

    }

    public class Name {

        public String Last { get; set; }
        public String First { get; set; }

    }

    public class DOB {

        public Integer Month {get;set;}
        public Integer Year {get;set;}
        public Integer Day {get;set;}

    }

    public class Address {

        public String StreetName { get; set; }
        public String State { get; set;}
        public Integer Zip4 { get; set; }
        public String StreetNumber { get; set; }
        public String City { get; set; }
        public String County { get; set; }
        public String Zip5 { get; set; }
        public String StreetSuffix { get; set; }
        public String StreetAddress1 { get; set; }

    }

    // International Verification
    public class InstantVerifyInternationalRequest {

        public String firstName;
        public String lastName;
        public String addressLine1;
        public String city;
        public String state;
        public String postalCode;
        public Date dateOfBirth;

    }

    public class InstantVerifyInternationalResponse {

        public Boolean individualVerified;

        public List<String> verificationFailures;

        public Boolean calloutFailed;
        public String errorLog;

        public InstantVerifyInternationalResponse() {

            // Assume false unless passed in the callout
            individualVerified = false;

            verificationFailures = new List<String>();

            calloutFailed = false;

        }

    }

    public class InstantVerifyInternationalResponseWrapper {

        public Status Status { get; set; }
        public List<Products> Products { get; set; }

    }

    public class Status {
        public String ConversationId { get; set; }
        public String RequestId { get; set; }
        public String TransactionStatus { get; set; }
        public String Reference { get; set; }
    }

    public class ItemInformationDetails {
        public String Name { get; set; }
        public String Value { get; set; }
    }

    public class Products {
        public String ProductType { get; set; }
        public String ExecutedStepName { get; set; }
        public String ProductConfigurationName { get; set; }
        public String ProductStatus { get; set; }
        public List<Items> Items { get; set; }
    }



    public class Items {
        public String ItemName { get; set; }
        public String ItemStatus { get; set; }
        public ItemReason ItemReason { get; set; }
        public List<ItemInformationDetails> ItemInformationDetails { get; set; }
    }

    public class ItemReason {
        public String Code { get; set; }
    }

}