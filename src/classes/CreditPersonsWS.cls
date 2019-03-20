/**
* Forseva consumer credit check code.
*/
global class CreditPersonsWS {

    // used by blended reports only -- currently unused 
    WebService static List<PersonWS> getCreditSubject(ID acctId) {
    
        List<Contact> contacts = [Select Id, MailingStreet, MailingState, MailingPostalCode, MailingCity, 
                                         Salutation, LastName, FirstName, Birthdate, Social_Security_Number__c, Report_Permission_Granted__c //Last_Valid_Authorized_Signer__c 
                                  From   Contact 
                                  where  accountId = :acctId];
        
        List<PersonWS> persons = new List<PersonWS>();
        for(Contact ct : contacts) {
        	if(ct.Report_Permission_Granted__c == true) { 
                PersonWS p = new PersonWS();
                p.FirstName = ct.FirstName;
                p.LastName = ct.LastName;
                p.UnparsedAddress = ct.MailingStreet;
                p.City = ct.MailingCity;
                p.State = ct.MailingState;
                p.PostalCode = ct.MailingPostalCode;
                p.SSN = ct.Social_Security_Number__c;
                p.personId = ct.id;
                if(ct.Birthdate != null) {
                    p.age = ct.Birthdate.monthsBetween(Date.today())/12;
                }
                persons.add(p);
        	}
        } 

        return persons;        
    }
    
    WebService static List<PersonWS> getCreditSubjectUsingParameterString(String parameterString) {
        
        System.debug('parameterString=' + parameterString);
        ID accountId = null;
        ID contactId = null;
        list<String> nvpList = parameterString.split(',');
        for (String nvp: nvpList) {
            String nm = getNameFromNvp(nvp);
            String val = getValueFromNvp(nvp);
            if (nm == 'accountId') {
                accountId = Id.valueOf(val);
            }
            if (nm == 'contactId') {
                contactId = Id.valueOf(val);
            }
        }
        
        List<Contact> contacts = null;
        
        if(accountId != null) {
            contacts = [Select Salutation, MailingStreet, MailingState, MailingPostalCode, MailingCity, 
                               LastName, Id, FirstName, Birthdate, Social_Security_Number__c, Report_Permission_Granted__c //Last_Valid_Authorized_Signer__c 
                        From   Contact 
                        where  accountId = :accountId];
        }
        if(contactId != null) {
            contacts = [Select Salutation, MailingStreet, MailingState, MailingPostalCode, MailingCity, 
                               LastName, Id, FirstName, Birthdate, Social_Security_Number__c, Report_Permission_Granted__c  //Last_Valid_Authorized_Signer__c
                        From   Contact 
                        where  Id = :contactId];
        }
        
        List<PersonWS> persons = new List<PersonWS>();
        for(Contact ct : contacts) {
            if(ct.Report_Permission_Granted__c == true) { 
                PersonWS p = new PersonWS();
                p.FirstName = ct.FirstName;
                p.LastName = ct.LastName;
                p.UnparsedAddress = ct.MailingStreet;
                p.City = ct.MailingCity;
                p.State = ct.MailingState;
                p.PostalCode = ct.MailingPostalCode;
                if(ct.Social_Security_Number__c != null) {
                    p.SSN = ct.Social_Security_Number__c;
                }
                p.personId = ct.id;
                if(ct.Birthdate != null) {
                    p.age = ct.Birthdate.monthsBetween(Date.today())/12;
                }
                persons.add(p);
            }
        } 

        return persons;
    }
        
    WebService static List<String> getCreditBureauRequestParameters(String parameterString) {

        // equifax parms

        String parm;
        List<String> parmlist = new List<String>();

        parm = 'Flags!BeaconFlag';
        parmlist.add(parm);
        parm = 'Flags!OnLineDirectoryFlag';
        parmlist.add(parm);
        parm = 'Flags!ConsumerReferralLocationFlag';
        parmlist.add(parm);
        parm = 'Flags!AlertContactFlag';
        parmlist.add(parm);

        parm = 'Models!2784';        
        parmlist.add(parm);

        parm = 'Customer Options!RawFileAppendIndicator:N';        
        parmlist.add(parm);
        parm = 'Customer Options!PrintImageCDATAInclude:Y';        
        parmlist.add(parm);
        parm = 'Customer Options!OutputFormat:67';  // Acrofile Advanced 6.0
        parmlist.add(parm);

        string accountId = null;        
        list<String> nvpList = parameterString.split(',');
        for (String nvp: nvpList) {
            String nm = getNameFromNvp(nvp);
            String val = getValueFromNvp(nvp);
            if(nm == 'accountId') {
                accountId = id.valueOf(val);
                parm = 'accountId!' + accountId;
                parmList.add(parm);
            }        
        }
        
        return parmList;
    }
    
    WebService static String parseAndScore(String dataProviderName, ID accountId, ID personId, String parameterString, String xml) {
    
        String serstr = null;        
            
        forseva1.ConsumerReportService crs = new forseva1.ConsumerReportService(xml, dataProviderName);
        forseva1__DataProviderProduct__c efxDdp = [select id from forseva1__DataProviderProduct__c where name = 'Equifax Consumer Credit'];
        forseva1__EquifaxConsumer__c ec = new forseva1__EquifaxConsumer__c();
        ec.forseva1__Data_Provider_Product__c = efxDdp.id;
        ec.forseva1__Account__c = accountId;
        if(personId != null) {
            ec.forseva1__Contact__c = personId;
        }            
        
        try {

            ec.forseva1__F_Credit_Review_Comments__c = 'Equifax Scoring: ';

            //------------------------------
            // beacon score and trade lines
            //------------------------------

            String beacon = crs.getNodeValue('EfxTransmit/EfxReport/USConsumerCreditReports/USConsumerCreditReport|relationshipIdentifier:Primary/USBeacon/BeaconScore');
            Integer tradeLineCount = crs.countNodes('EfxTransmit/EfxReport/USConsumerCreditReports/USConsumerCreditReport|relationshipIdentifier:Primary/USTrades/USTrade'); 

            if(beacon != null && tradeLineCount != null) {
            	ec.Beacon_Score__c = beacon;
                Decimal beaconScore = Decimal.valueOf(beacon);
                if(beaconScore >= 725 && tradeLineCount >= 10) {
                    ec.forseva1__F_Credit_Limit_Approved__c = 10000;
                    ec.forseva1__F_Credit_Quality_Rating__c = 5.0;
                    ec.forseva1__F_CQR_Description__c = 'Auto Approved';
                }
                else if(beaconScore >= 690 && tradeLineCount >= 8) {
                    ec.forseva1__F_Credit_Limit_Approved__c = 7500;
                    ec.forseva1__F_Credit_Quality_Rating__c = 4.0;
                    ec.forseva1__F_CQR_Description__c = 'Auto Approved';
                }
                else if(beaconScore >= 650 && tradeLineCount >= 5) {
                    ec.forseva1__F_Credit_Limit_Approved__c = 5000;
                    ec.forseva1__F_Credit_Quality_Rating__c = 3.0;
                    ec.forseva1__F_CQR_Description__c = 'Auto Approved';
                }                
                else if(beaconScore >= 620 && tradeLineCount >= 5) {
                    ec.forseva1__F_Credit_Limit_Approved__c = 2500;
                    ec.forseva1__F_Credit_Quality_Rating__c = 2.0;
                    ec.forseva1__F_CQR_Description__c = 'Auto Approved';
                }
                else {
                    ec.forseva1__F_Credit_Limit_Approved__c = 0;
                    ec.forseva1__F_Credit_Quality_Rating__c = 1.0;
                    ec.forseva1__F_CQR_Description__c = 'Manual Review Required';                
                }                
                ec.forseva1__F_Credit_Limit_Approver__c = UserInfo.getUserId();
                ec.forseva1__F_Credit_Limit_Effective_Date__c = Date.today();
                ec.forseva1__F_Credit_Limit_Expiration_Date__c = Date.today().addDays(365);                
            }
            else {
                ec.forseva1__F_Credit_Limit_Approved__c = 0;
                ec.forseva1__F_Credit_Quality_Rating__c = 0.0;
                ec.forseva1__F_CQR_Description__c = 'Incomplete Equifax Report';
                ec.forseva1__F_Credit_Review_Comments__c += 'Incomplete Equifax Report ;';            
            }

            //-------------------------------------
            // various bad things that might happen
            //-------------------------------------            

            Integer fraudCounter = crs.countNodes('EfxTransmit/EfxReport/USConsumerCreditReports/USConsumerCreditReport|relationshipIdentifier:Primary/USHeader/USCreditFile/FraudVictimIndicator');
            if(fraudCounter > 0) {
                ec.forseva1__F_Credit_Limit_Approved__c = 0;
                ec.forseva1__F_Credit_Quality_Rating__c = 0.0;
                ec.forseva1__F_CQR_Description__c = 'Fraud Victim Alert';
                ec.forseva1__F_Credit_Review_Comments__c += 'Fraud Victim Alert; ';                            
            }

            List<String> safescanCodes = crs.getAllAttributeValues('EfxTransmit/EfxReport/USConsumerCreditReports/USConsumerCreditReport|relationshipIdentifier:Primary/USHeader/USCreditFile/Safescans/Safescan','code');
            for(String code : safescanCodes) {
                if(code != 'S') {
                    ec.forseva1__F_Credit_Limit_Approved__c = 0;
                    ec.forseva1__F_Credit_Quality_Rating__c = 0.0;
                    ec.forseva1__F_CQR_Description__c = 'SafeScan Alert';
                    ec.forseva1__F_Credit_Review_Comments__c += 'SafeScan Alert; ';                            
                    break;
                }
            }

            String addressAlert = crs.getNodeValue('EfxTransmit/EfxReport/USConsumerCreditReports/USConsumerCreditReport|relationshipIdentifier:Primary/USHeader/USCreditFile/AddressDiscrepancyIndicator');
            if(addressAlert != null && addressAlert == 'Y') {
                ec.forseva1__F_Credit_Limit_Approved__c = 0;
                ec.forseva1__F_Credit_Quality_Rating__c = 0.0;
                ec.forseva1__F_CQR_Description__c = 'Address Discrepancy';      
                ec.forseva1__F_Credit_Review_Comments__c += 'Address Discrepancy; ';
            }
            
            Integer legalItems = crs.countNodes('EfxTransmit/EfxReport/USConsumerCreditReports/USConsumerCreditReport|relationshipIdentifier:Primary/USLegalItems/USLegalItem');
            if(legalItems > 0) {
                ec.forseva1__F_Credit_Limit_Approved__c = 0;
                ec.forseva1__F_Credit_Quality_Rating__c = 0.0;
                ec.forseva1__F_CQR_Description__c = 'Suits or Judgments';          
                ec.forseva1__F_Credit_Review_Comments__c += 'Suits or Judgments; ';
            }
            
            Integer taxLiens = crs.countNodes('EfxTransmit/EfxReport/USConsumerCreditReports/USConsumerCreditReport|relationshipIdentifier:Primary/USTaxLiens/USTaxLien');
            if(taxLiens > 0) {
                ec.forseva1__F_Credit_Limit_Approved__c = 0;
                ec.forseva1__F_Credit_Quality_Rating__c = 0.0;
                ec.forseva1__F_CQR_Description__c = 'Tax Liens';
                ec.forseva1__F_Credit_Review_Comments__c += 'Tax Liens; ';                      
            }
            
            Integer bankruptcies = crs.countNodes('EfxTransmit/EfxReport/USConsumerCreditReports/USConsumerCreditReport|relationshipIdentifier:Primary/USBankruptcies/USBankruptcy');
            if(bankruptcies > 0) {
                ec.forseva1__F_Credit_Limit_Approved__c = 0;
                ec.forseva1__F_Credit_Quality_Rating__c = 0.0;
                ec.forseva1__F_CQR_Description__c = 'Bankruptcies';      
                ec.forseva1__F_Credit_Review_Comments__c += 'Bankruptcies; ';                                  
            }
            
            Integer placedForCollections = crs.countDatesLessThanXDays(365, 'EfxTransmit/EfxReport/USConsumerCreditReports/USConsumerCreditReport|relationshipIdentifier:Primary/USCollections/USCollection/DateReported');
            if(placedForCollections > 0) {
                ec.forseva1__F_Credit_Limit_Approved__c = 0;
                ec.forseva1__F_Credit_Quality_Rating__c = 0.0;
                ec.forseva1__F_CQR_Description__c = 'Placed for Collections in Past 12 Months';
                ec.forseva1__F_Credit_Review_Comments__c += 'Placed for Collections in Past 12 Months; ';                                                        
            }

            Integer inquiriesPast2Months = crs.countDatesLessThanXDays(60, 'EfxTransmit/EfxReport/USConsumerCreditReports/USConsumerCreditReport|relationshipIdentifier:Primary/USInquiries/USInquiry/DateOfInquiry');
            if(inquiriesPast2Months > 7) {
                ec.forseva1__F_Credit_Limit_Approved__c = 0;
                ec.forseva1__F_Credit_Quality_Rating__c = 0.0;
                ec.forseva1__F_CQR_Description__c = inquiriesPast2Months + ' Inquiries in Past 2 Months';
                ec.forseva1__F_Credit_Review_Comments__c += inquiriesPast2Months + ' Inquiries in Past 2 Months ;';                                                        
            }

            Integer inquiriesPast6Months = crs.countDatesLessThanXDays(180, 'EfxTransmit/EfxReport/USConsumerCreditReports/USConsumerCreditReport|relationshipIdentifier:Primary/USInquiries/USInquiry/DateOfInquiry');
            if(inquiriesPast6Months > 15) {
                ec.forseva1__F_Credit_Limit_Approved__c = 0;
                ec.forseva1__F_Credit_Quality_Rating__c = 0.0;
                ec.forseva1__F_CQR_Description__c = inquiriesPast6Months + ' Inquiries in Past 6 Months';         
                ec.forseva1__F_Credit_Review_Comments__c += inquiriesPast6Months + ' Inquiries in Past 6 Months ;';
            }

            Integer OFACHit = crs.countDatesLessThanXDays(180, 'EfxTransmit/EfxReport/USConsumerCreditReports/USConsumerCreditReport|relationshipIdentifier:Primary/USOFACAlerts/USOFACAlert/ResponseCode|code:E');
            OFACHit += crs.countDatesLessThanXDays(180, 'EfxTransmit/EfxReport/USConsumerCreditReports/USConsumerCreditReport|relationshipIdentifier:Primary/USOFACAlerts/USOFACAlert/ResponseCode|code:O');
            if(OFACHit > 0) {
                ec.forseva1__F_Credit_Limit_Approved__c = 0;
                ec.forseva1__F_Credit_Quality_Rating__c = 0.0;
                ec.forseva1__F_CQR_Description__c = 'OFAC Alert';
                ec.forseva1__F_Credit_Review_Comments__c += 'OFAC Alert ;';                
            }

        }
        catch(Exception e) {
            ec.forseva1__F_Credit_Limit_Approved__c = 0;
            ec.forseva1__F_Credit_Quality_Rating__c = 0.0;
            ec.forseva1__F_CQR_Description__c = 'Error Reading Equifax Report';
            ec.forseva1__F_Credit_Review_Comments__c += 'Error Reading Equifax Report ;';
        }

        serstr =  crs.serializeSObject(ec);
        return serstr;                    
    }

    //--------------------------
    // private
    //--------------------------
    
    private static String getNameFromNvp(String nvp) {
        list<String> lst = nvp.split(':');
        return lst[0];
    }

    private static String getValueFromNvp(String nvp) {
        list<String> lst = nvp.split(':');
        return lst[1];
    }
    
}

// EOF