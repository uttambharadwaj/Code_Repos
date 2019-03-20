/*
 *
 * Credit Decision Engine
 * BREeze Function: Credit Line Calculator 
 * 
*/
global class CreditUtil_CalculateCreditLine implements BREeze.FunctionCheckerPrePost {

    global object getFunctionValue(object functionName, sObject so, String fieldType, String functionExtension, String ruleName, Id ruleId) {

        try {

            String objectType = (Id.valueOf(so.Id)).getSobjectType().getDescribe().getName();
            System.debug('Object Type ======= ' + objectType);

            // CORPORATE PAYMENTS
            if (objectType != null && (objectType).equalsIgnoreCase('CP_Application_Request__c')) {

                List<CP_Application_Request__c> cpApps = [
                        SELECT Id,Credit_Line_Recommendation__c,Credit_Line_Requested__c,Risk_Grade__c,DNB_SBRI_High_Credit__c,PG_Required__c,PG_High_Credit_Amount__c,
                                DNB_SBFE_High_Credit__c,DNB_CSAD_High_Credit__c,DNB_Credit_Line_Recommendation__c
                        FROM CP_Application_Request__c
                        WHERE Id = :so.Id
                ];

                if (cpApps.size() > 0) {
                    CP_Application_Request__c cp = cpApps[0];
                    Decimal creditLineRequested = cp.Credit_Line_Requested__c;
                    String riskGrade = cp.Risk_Grade__c;
                    Decimal highCreditAmount = cp.PG_High_Credit_Amount__c;
                    cp.Credit_Line_Recommendation__c = 0;

                    // Check if calculating based on DNB info
                    // if DNB credit line recommendation is not covered by their high credit, attempt to approve requested credit line
                    if (!cp.PG_Required__c && cp.DNB_Credit_Line_Recommendation__c > 0) {

                        cp.Credit_Line_Recommendation__c = cp.DNB_Credit_Line_Recommendation__c;

                        // if DNB recommends a higher credit line than the customer requested, cap the recommended at the requested credit line
                        if (cp.Credit_Line_Recommendation__c > creditLineRequested) {
                            cp.Credit_Line_Recommendation__c = creditLineRequested;
                        }
                        highCreditAmount = getHighestCreditAmount(cp.DNB_SBFE_High_Credit__c, cp.DNB_CSAD_High_Credit__c);
                    }

                    if (riskGrade.equals('1') || riskGrade.equals('2')) {
                        if (creditLineRequested <= 25000) {
                            cp.Credit_Line_Recommendation__c = creditLineRequested;
                        }
                        else if (creditLineRequested > 25000 && creditLineRequested <= 150000) {
                            if (highCreditAmount >= creditLineRequested) {
                                cp.Credit_Line_Recommendation__c = creditLineRequested;
                            } else {
                                cp.Credit_Line_Recommendation__c = highCreditAmount;
                            }
                        }
                    }
                    else if (riskGrade.equals('3') || riskGrade.equals('4')) {                       
                        if (creditLineRequested <= 10000) {
                            cp.Credit_Line_Recommendation__c = creditLineRequested;
                        } else if (creditLineRequested > 10000 && creditLineRequested <= 150000) {
                            if (highCreditAmount >= creditLineRequested) {
                                cp.Credit_Line_Recommendation__c = creditLineRequested;
                            } else {
                                cp.Credit_Line_Recommendation__c = highCreditAmount;
                            }
                        }
                    }
                    return cp.Credit_Line_Recommendation__c;
                }
            }

            // OTR
            else if (objectType != null && (objectType).equalsIgnoreCase('OnlineApplication__c')) {

                System.debug(so.Id);

                List<OnlineApplication__c> onlineApplications = [
                        SELECT Id,Credit_Line_Recommendation__c,DNB_Credit_Line_Recommendation__c,Credit_Line_Requested__c,Risk_Grade__c,Decision_Comments__c,
                                DNB_CSAD_High_Credit__c,DNB_SBFE_High_Credit__c,Team_Drivers_Slip_Seat__c,Number_of_Trucks__c,PG_Required__c,PG_High_Credit_Amount__c,PG_Score__c
                        FROM OnlineApplication__c
                        WHERE Id = :so.Id
                ];

                if (onlineApplications.size() > 0) {

                    OnlineApplication__c oa = onlineApplications[0];

                    Decimal creditLineRequested = oa.Credit_Line_Requested__c;
                    Decimal highCreditAmount = oa.PG_High_Credit_Amount__c;
                    String riskGrade = oa.Risk_Grade__c;                   
                    Decimal creditLineRequestedWithTrucks = 0;
                    System.debug('requested credit line - original requested: ' + creditLineRequested);

                    // Update the credit line requested based on the number of trucks
                    if (oa.Team_Drivers_Slip_Seat__c) {
                        creditLineRequestedWithTrucks = oa.Number_of_Trucks__c * 3500;
                    } else {
                        creditLineRequestedWithTrucks = oa.Number_of_Trucks__c * 2500;
                    }
                    if (creditLineRequested < creditLineRequestedWithTrucks) {
                        creditLineRequested = creditLineRequestedWithTrucks;
                    }
                    System.debug('requested credit line - after choosing higher of requested vs with trucks adj: ' + creditLineRequested);

                    // If a PG has been pulled, calculate the recommended credit line based on consumer PG information
                    if (oa.PG_Required__c && null != oa.PG_High_Credit_Amount__c) {
                        Decimal FICO = oa.PG_Score__c;
                        oa.Credit_Line_Recommendation__c = 0;

                        if (creditLineRequested <= highCreditAmount) {
                            oa.Credit_Line_Recommendation__c = creditLineRequested;
                        } else {
                            oa.Credit_Line_Recommendation__c = highCreditAmount;
                        }
                        System.debug('recommended credit line - after looking at high credit amount: ' + oa.Credit_Line_Recommendation__c);

                        if (FICO > 750) {

                            // cap for this FICO range is $25k
                            if (oa.Credit_Line_Recommendation__c > 25000) {
                                oa.Credit_Line_Recommendation__c = 25000;
                            }
                        }

                        else if (FICO >= 720 && FICO <= 750) {

                            // cap for this FICO range is $15k
                            if (oa.Credit_Line_Recommendation__c > 15000) {
                                oa.Credit_Line_Recommendation__c = 15000;
                            }
                        }

                        else if (FICO >= 680 && FICO <= 719) {

                            // cap for this FICO range is $10k
                            if (oa.Credit_Line_Recommendation__c > 10000) {
                                oa.Credit_Line_Recommendation__c = 10000;
                            }
                        }

                        else if ((FICO >= 660 && FICO <= 679) || (FICO >= 630 && FICO <= 659 && (oa.Program__r.Brand_Short_Name__c.equalsIgnoreCase('NASTC') || oa.Program__r.Brand_Short_Name__c.equalsIgnoreCase('JBH360')|| oa.Program__r.Brand_Short_Name__c.equalsIgnoreCase('EDGE')))) {

                            // cap for this FICO range is $5k
                            if (oa.Credit_Line_Recommendation__c > 5000) {
                                oa.Credit_Line_Recommendation__c = 5000;
                            }
                        }

                        else {
                            oa.Credit_Line_Recommendation__c = 0;
                        }
                        System.debug('recommended credit line - after looking at FICO: ' + oa.Credit_Line_Recommendation__c);

                        // calculate recommended credit line based on commercial DNB information
                    } else {
                        
                         oa.Credit_Line_Recommendation__c = oa.DNB_Credit_Line_Recommendation__c;

                        // if DNB recommends a higher credit line than the customer requested, cap the recommended at the requested credit line
                        if (oa.Credit_Line_Recommendation__c > creditLineRequested) {
                            oa.Credit_Line_Recommendation__c = creditLineRequested;
                        }
                        
                         // determine which high credit amount is highest
                        highCreditAmount = getHighestCreditAmount(oa.DNB_SBFE_High_Credit__c, oa.DNB_CSAD_High_Credit__c);

                        if (riskGrade.equals('1') || riskGrade.equals('2')) {
                            if (oa.Credit_Line_Recommendation__c <= 25000) {
                                return oa.Credit_Line_Recommendation__c;
                            }
                            else {
                                if (oa.Credit_Line_Recommendation__c <= highCreditAmount) {
                                    return oa.Credit_Line_Recommendation__c;
                                }
                                else {
                                    oa.Credit_Line_Recommendation__c = highCreditAmount;
                                }
                            }
                        }
                        if (riskGrade.equals('3')) {
                            if (oa.Credit_Line_Recommendation__c <= 10000) {
                                return oa.Credit_Line_Recommendation__c;
                            }
                            else {
                                if (oa.Credit_Line_Recommendation__c <= highCreditAmount) {
                                    return oa.Credit_Line_Recommendation__c;
                                }
                                else {
                                    oa.Credit_Line_Recommendation__c = highCreditAmount;
                                }
                            }
                        }
                    }

                    // Commercial Risk Grade 4 will have a credit line recommendation based on PG information, but has a cap credit line of $5k.
                    if (riskGrade != null && riskGrade.equals('4')) {
                        oa.Decision_Comments__c = oa.Decision_Comments__c + ' ACH 2x weekly required. No cash products allowed.';
                        if (oa.Credit_Line_Recommendation__c > 5000) {
                            oa.Credit_Line_Recommendation__c = 5000;
                        }
                    }


                    // For any given credit line recommendation, a minimum credit line of 2500 is required (Slip Seat minimum is 3500)
                    if (oa.Credit_Line_Recommendation__c < 3500 && oa.Credit_Line_Recommendation__c != 0 && oa.Team_Drivers_Slip_Seat__c) {
                        oa.Credit_Line_Recommendation__c = 3500;
                    }
                    if (oa.Credit_Line_Recommendation__c < 2500 && oa.Credit_Line_Recommendation__c != 0) {
                        oa.Credit_Line_Recommendation__c = 2500;
                    }

                    return oa.Credit_Line_Recommendation__c;
                }
            }

            // NA Fleet
            // Credit Line Recommendation for Commercial is returned to us via DNB
            else if (objectType != null && (objectType).equalsIgnoreCase('Application_Request__c')) {

                System.debug(so.Id);

                List<Application_Request__c> applicationRequests = [
                        SELECT Id,Credit_Line_Recommendation__c,DNB_Credit_Line_Recommendation__c,Requested_Credit_Limit_Currency__c,PG_Required__c,PG_High_Credit_Amount__c,PG_FICO_Score__c, Risk_Grade__c,
                                DNB_CSAD_High_Credit__c, DNB_SBFE_High_Credit__c
                        FROM Application_Request__c
                        WHERE Id = :so.Id
                ];

                if (applicationRequests.size() > 0) {
                    Application_Request__c ar = applicationRequests[0];
                    Decimal creditLineRequested = ar.Requested_Credit_Limit_Currency__c;
                    String riskGrade = ar.Risk_Grade__c;
                    Decimal highCreditAmount = ar.PG_High_Credit_Amount__c;

                    // If using Commercial recommended credit line
                    // if DNB credit line recommendation is not covered by their high credit, attempt to approve requested credit line
                    if (!ar.PG_Required__c && ar.DNB_Credit_Line_Recommendation__c > 0) {

                        ar.Credit_Line_Recommendation__c = ar.DNB_Credit_Line_Recommendation__c;
                        
                        // if DNB recommends a higher credit line than the customer requested, cap the recommended at the requested credit line
                        if (ar.Credit_Line_Recommendation__c > creditLineRequested) {
                            ar.Credit_Line_Recommendation__c = creditLineRequested;
                        }

                        // determine which high credit amount is highest
                        highCreditAmount = getHighestCreditAmount(ar.DNB_SBFE_High_Credit__c, ar.DNB_CSAD_High_Credit__c);

                        if (riskGrade.equals('1') || riskGrade.equals('2')) {
                            // don't increase requested to the 25k min if the applicant requested less
                            if (creditLineRequested < 25000) {
                                ar.Credit_Line_Recommendation__c = creditLineRequested;
                                return ar.Credit_Line_Recommendation__c;
                            }
                            if (ar.Credit_Line_Recommendation__c > 25000) {
                                if (ar.Credit_Line_Recommendation__c <= highCreditAmount) {
                                    return ar.Credit_Line_Recommendation__c;
                                }
                                else {
                                    ar.Credit_Line_Recommendation__c = highCreditAmount;
                                }
                            }
                            // set a minimum credit line recommendation of 25k for this RG range
                            if (ar.Credit_Line_Recommendation__c < 25000) {
                                ar.Credit_Line_Recommendation__c = 25000;
                            }
                               return ar.Credit_Line_Recommendation__c;
                        }

                        if (riskGrade.equals('3') || riskGrade.equals('4')) {
                            // don't increase requested to the 10k min if the applicant requested less
                            if (creditLineRequested < 10000) {
                                ar.Credit_Line_Recommendation__c = creditLineRequested;
                                return ar.Credit_Line_Recommendation__c;
                            }
                            if (ar.Credit_Line_Recommendation__c > 10000) {
                                if (ar.Credit_Line_Recommendation__c <= highCreditAmount) {
                                    return ar.Credit_Line_Recommendation__c;
                                }
                                else {
                                    ar.Credit_Line_Recommendation__c = highCreditAmount;
                                }
                            }
                            // set a minimum credit line recommendation of 10k for this RG range
                            if (ar.Credit_Line_Recommendation__c < 10000) {
                                ar.Credit_Line_Recommendation__c = 10000;
                            }
                            return ar.Credit_Line_Recommendation__c;
                        }

                    }
                    // if PG pulled, calculate the recommended credit line
                    else {
                        ar.Credit_Line_Recommendation__c = 0;

                        if (riskGrade.equals('1') || riskGrade.equals('2')) {
                            if (creditLineRequested <= 25000) {
                                ar.Credit_Line_Recommendation__c = creditLineRequested;
                            } else if (creditLineRequested > 25000 && creditLineRequested <= 150000) {
                                if (highCreditAmount != null) {
                                    if (highCreditAmount >= creditLineRequested) {
                                        ar.Credit_Line_Recommendation__c = creditLineRequested;
                                    } else {
                                        ar.Credit_Line_Recommendation__c = highCreditAmount;
                                    }
                                } else {
                                    ar.Credit_Line_Recommendation__c = 0;
                                }
                            }
                        } else if (riskGrade.equals('3') || riskGrade.equals('4')) {
                            if (creditLineRequested <= 10000) {
                                ar.Credit_Line_Recommendation__c = creditLineRequested;
                            } else if (creditLineRequested > 10000 && creditLineRequested <= 150000) {
                                if (highCreditAmount != null) {
                                    if (highCreditAmount >= creditLineRequested) {
                                        ar.Credit_Line_Recommendation__c = creditLineRequested;
                                    } else {
                                        ar.Credit_Line_Recommendation__c = highCreditAmount;
                                    }
                                } else {
                                    ar.Credit_Line_Recommendation__c = 0;
                                }
                            }
                        }
                    }
                    return ar.Credit_Line_Recommendation__c;
                }
            }

        } catch (Exception e) {
            System.debug('### ERROR: ' + e.getMessage() + '(Line: ' + e.getLineNumber() + ') in class: CreditUtil_CalculateCreditLine');
            System.debug('Unable to calculate recommended credit line, possibly an unexpected null field in application id: ' + so.id);

        }
        return 0;
    }

    /**
    * Determines between SBFE and CSAD, which is the higher credit amount. Returns the higher of the two, or 0 if both null.
     */
    private static Decimal getHighestCreditAmount(Decimal DNBSBFEHighCredit, Decimal DNBCSADHighCredit) {

        Decimal highCreditAmount = 0;

        if (null != DNBSBFEHighCredit && null != DNBCSADHighCredit) {
            if (DNBCSADHighCredit > DNBSBFEHighCredit) {
                highCreditAmount = DNBCSADHighCredit;
            } else {
                highCreditAmount = DNBSBFEHighCredit;
            }
        }
        else if (null != DNBCSADHighCredit) {
            highCreditAmount = DNBCSADHighCredit;
        }
        else if (null != DNBSBFEHighCredit) {
            highCreditAmount = DNBSBFEHighCredit;
        }
        else {
            highCreditAmount = 0;
        }

        return highCreditAmount;
    }


    global void postProcess() {

    }

    global void preProcess(List<sObject> records, String RuleName, String objectName) {

    }

}