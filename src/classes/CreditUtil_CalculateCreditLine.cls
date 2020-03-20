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
                        SELECT Id,Credit_Line_Recommendation__c,DNB_Credit_Line_Recommendation__c,Credit_Line_Requested__c,Risk_Grade__c,Decision_Comments__c, Offer__c,
                                DNB_CSAD_High_Credit__c,DNB_SBFE_High_Credit__c,Team_Drivers_Slip_Seat__c,Number_of_Trucks__c,PG_Required__c,PG_High_Credit_Amount__c,PG_Score__c
                        FROM OnlineApplication__c
                        WHERE Id = :so.Id
                ];

                if (onlineApplications.size() > 0) {

                    OnlineApplication__c oa = onlineApplications[0];

                    Decimal creditLineRequested = oa.Credit_Line_Requested__c;
                    Decimal highCreditAmount = oa.PG_High_Credit_Amount__c;
                    Decimal creditLineRequestedWithTrucks = 0;
                    System.debug('requested credit line - original requested: ' + creditLineRequested);

                    // Update the credit line requested based on the number of trucks
                    List<OnlineApplicationOffer__c> offers = [ SELECT Id, Credit_Limit_Per_Truck__c, Credit_Limit_Per_Truck_Slip_Seat__c FROM OnlineApplicationOffer__c where Id = :onlineApplications[0].Offer__c ];

                    Integer truckCalc = 2500;
                    Integer truckCalcSlipSeat = 3500;
                    // use the truck limits set at the offer level, if they are blank use the 2500/3500 as defaults
                    if (offers.size() > 0) {
                        if (null != offers[0].Credit_Limit_Per_Truck__c && null != offers[0].Credit_Limit_Per_Truck_Slip_Seat__c) {
                            truckCalc = Integer.valueOf(offers[0].Credit_Limit_Per_Truck__c);
                            truckCalcSlipSeat = Integer.valueOf(offers[0].Credit_Limit_Per_Truck_Slip_Seat__c);
                            System.debug('Offer truck limit: ' + offers[0].Credit_Limit_Per_Truck__c + '  and truck limit for slip seat: ' + offers[0].Credit_Limit_Per_Truck_Slip_Seat__c);
                        }
                    }

                    if (oa.Team_Drivers_Slip_Seat__c) {
                        creditLineRequestedWithTrucks = oa.Number_of_Trucks__c * truckCalcSlipSeat;
                    } else {
                        creditLineRequestedWithTrucks = oa.Number_of_Trucks__c * truckCalc;
                    }
                    if (creditLineRequested > creditLineRequestedWithTrucks) {
                        creditLineRequested = creditLineRequestedWithTrucks;
                    }
                    System.debug('requested credit line - after evaluating truck calculation: ' + creditLineRequested);

                    // If a PG has been pulled, calculate the recommended credit line based on consumer PG information
                    if (oa.PG_Required__c && null != oa.PG_High_Credit_Amount__c) {
                        oa.Credit_Line_Recommendation__c = calculateOTRCreditLimitPerPG(oa, highCreditAmount, creditLineRequested);

                    } else {
                        // calculate recommended credit line based on commercial DNB information
                        oa.Credit_Line_Recommendation__c = calculateOTRCreditLimitPerDNB(oa, highCreditAmount, creditLineRequested);
                    }

                    // For any given credit line recommendation, a minimum credit line of 2500 is required (Slip Seat minimum is 3500)
                    if (oa.Credit_Line_Recommendation__c < truckCalcSlipSeat && oa.Credit_Line_Recommendation__c != 0 && oa.Team_Drivers_Slip_Seat__c) {
                        oa.Credit_Line_Recommendation__c = truckCalcSlipSeat;
                    }
                    if (oa.Credit_Line_Recommendation__c < truckCalc && oa.Credit_Line_Recommendation__c != 0) {
                        oa.Credit_Line_Recommendation__c = truckCalc;
                    }

                    return oa.Credit_Line_Recommendation__c;
                }
            }

            // NA Fleet
            else if (objectType != null && (objectType).equalsIgnoreCase('Application_Request__c')) {

                System.debug(so.Id);

                List<Application_Request__c> applicationRequests = [
                        SELECT Id,Credit_Line_Recommendation__c,DNB_Credit_Line_Recommendation__c,Requested_Credit_Limit_Currency__c,PG_Required__c,PG_High_Credit_Amount__c,PG_FICO_Score__c, Risk_Grade__c,
                                DNB_CSAD_High_Credit__c, DNB_SBFE_High_Credit__c, DNB_Trade_Lines__c, BOCA_Type__c, Legal_Structure__c, Annual_Gross_Revenue__c, Years_In_Business__c, Credit_Decision_Comments__c
                        FROM Application_Request__c
                        WHERE Id = :so.Id
                ];

                if (applicationRequests.size() > 0) {
                    Application_Request__c ar = applicationRequests[0];
                    Decimal creditLineRequested = ar.Requested_Credit_Limit_Currency__c;
                    String riskGrade = ar.Risk_Grade__c;
                    Decimal highCreditAmount = ar.PG_High_Credit_Amount__c;

                    if (ar.BOCA_Type__c != null && ar.BOCA_Type__c.equalsIgnoreCase('Revolver Card')) {
                        if (creditLineRequested <= 25000) {
                            return calculateRevolverCreditLine(ar);
                        } else {
                            ar.Credit_Decision_Comments__c += ' Revolver account requesting more than $25k, requires manual review.';
                            return 0;
                        }
                    }

                    // If DNB match was successful, and PG was not required, calculate credit based on DNB info
                    if (!ar.PG_Required__c && ar.DNB_Credit_Line_Recommendation__c > 0) {
                        ar.Credit_Line_Recommendation__c = calculateNACreditLimitPerDNB(ar, creditLineRequested, riskGrade, highCreditAmount);

                    }
                    // If PG pulled, calculate the recommended credit line based on PG info
                    else {
                        ar.Credit_Line_Recommendation__c = calculateNACreditLimitPerPG(ar, creditLineRequested, riskGrade, highCreditAmount);
                    }

                    if (ar.Credit_Line_Recommendation__c != 0 && ar.Credit_Line_Recommendation__c < 500) {
                        ar.Credit_Line_Recommendation__c = 500;
                    }
                    return ar.Credit_Line_Recommendation__c;
                }
            }

        } catch (Exception e) {
            System.debug('### ERROR: ' + e.getMessage() + '(Line: ' + e.getLineNumber() + ') in class: CreditUtil_CalculateCreditLine');
            System.debug('Unable to calculate recommended credit line, possibly an unexpected null field in application id: ' + so.Id);

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

        return highCreditAmount;
    }

    /**
     * Calculate the OTR credit line recommndation based on Personal Guarentar information
     **/
    private static Decimal calculateOTRCreditLimitPerPG(OnlineApplication__c oa, Decimal highCreditAmount, Decimal creditLineRequested) {

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

        else if (FICO >= 660 && FICO <= 679) {

            // cap for this FICO range is $5k
            if (oa.Credit_Line_Recommendation__c > 5000) {
                oa.Credit_Line_Recommendation__c = 5000;
            }
        }

        else if (FICO >= 630 && FICO <= 659) {

            // cap for this FICO range is $5k
            oa.Decision_Comments__c = oa.Decision_Comments__c + ' ACH 2x weekly required. No cash products allowed.';
            if (oa.Credit_Line_Recommendation__c > 5000) {
                oa.Credit_Line_Recommendation__c = 5000;
            }
        }

        else {
            oa.Credit_Line_Recommendation__c = 0;
        }
        System.debug('recommended credit line - after looking at FICO: ' + oa.Credit_Line_Recommendation__c);
        return oa.Credit_Line_Recommendation__c;
    }

    private static Decimal calculateOTRCreditLimitPerDNB(OnlineApplication__c oa, Decimal highCreditAmount, Decimal creditLineRequested) {

        String riskGrade = oa.Risk_Grade__c;
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
                    return oa.Credit_Line_Recommendation__c = highCreditAmount;
                }
            }
        }
        if (riskGrade.equals('3') || riskGrade.equals('4')) {
            if (oa.Credit_Line_Recommendation__c <= 10000) {
                return oa.Credit_Line_Recommendation__c;
            }
            else {
                if (oa.Credit_Line_Recommendation__c <= highCreditAmount) {
                    return oa.Credit_Line_Recommendation__c;
                }
                else {
                    return oa.Credit_Line_Recommendation__c = highCreditAmount;
                }
            }
        }
        return 0;
    }


    /**
     * Calculate the NA Fleet credit line recommndation based on DNB information
     * If DNB credit line recommendation is not covered by their high credit, attempt to approve requested credit line
     **/
    private static Decimal calculateNACreditLimitPerDNB(Application_Request__c ar, Decimal creditLineRequested, String riskGrade, Decimal highCreditAmount) {

        System.debug('Calculating credit line recommendation based on DNB info...');
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
            if (ar.Credit_Line_Recommendation__c >= 25000) {
                if (ar.Credit_Line_Recommendation__c <= highCreditAmount) {
                    return ar.Credit_Line_Recommendation__c;
                }
                else {
                    ar.Credit_Line_Recommendation__c = highCreditAmount;
                }
            }
            // set a minimum credit line recommendation of 25k for this RG range unless applicant requested less
            if (ar.Credit_Line_Recommendation__c < 25000) {
                ar.Credit_Line_Recommendation__c = 25000;
            }
            return ar.Credit_Line_Recommendation__c;
        }

        if (riskGrade.equals('3') || riskGrade.equals('4') || (riskGrade.equals('5') && ar.Years_In_Business__c > 3)) {
            // don't increase requested to the 10k min if the applicant requested less
            if (creditLineRequested < 10000) {
                ar.Credit_Line_Recommendation__c = creditLineRequested;
                return ar.Credit_Line_Recommendation__c;
            }
            if (ar.Credit_Line_Recommendation__c >= 10000) {
                if (ar.Credit_Line_Recommendation__c <= highCreditAmount) {
                    return ar.Credit_Line_Recommendation__c;
                }
                else {
                    ar.Credit_Line_Recommendation__c = highCreditAmount;
                }
            }
            // set a minimum credit line recommendation of 10k for this RG range unless applicant requested less
            if (ar.Credit_Line_Recommendation__c < 10000) {
                ar.Credit_Line_Recommendation__c = 10000;
            }
            return ar.Credit_Line_Recommendation__c;
        }
        return 0;
    }

    /**
     * Calculate the NA Fleet credit line recommndation based on Personal Guarentar information
     **/
    private static Decimal calculateNACreditLimitPerPG(Application_Request__c ar, Decimal creditLineRequested, String riskGrade, Decimal highCreditAmount) {

        System.debug('Calculating credit line recommendation based on PG info...');
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
        return ar.Credit_Line_Recommendation__c;
    }

    /**
     * NA Fleet Revolver / Flex cards get their own special fancy pants credit line calculation matrix
     */
    private static Decimal calculateRevolverCreditLine(Application_Request__c appRequest) {

        System.debug('Calculating credit line recommendation for revolver card...');
        Decimal revenue = appRequest.Annual_Gross_Revenue__c;

        if (appRequest.Legal_Structure__c.equals('Sole Proprietorship') || appRequest.DNB_Trade_Lines__c > 3 || appRequest.Years_In_Business__c < 1) {

            return revolverCreditLimitTableOne(appRequest.Risk_Grade__c, revenue);

        } else if (appRequest.Years_In_Business__c >= 1 && appRequest.Years_In_Business__c <= 3) {

            return revolverCreditLimitTableThree(appRequest.Risk_Grade__c, revenue);

        }else if (appRequest.Years_In_Business__c >= 4) {

            return revolverCreditLimitTableFour(appRequest.Risk_Grade__c, revenue);
        }

        return 0;
    }

    /**
     * NA Fleet Credit Limit Table for Sole Prop businesses, thin credit files, and companies in business for less than 1 year
     **/
    private static Decimal revolverCreditLimitTableOne(String riskGrade, Decimal revenue) {

        System.debug('Credit limit table 1 / 2');
        if (riskGrade.equals('1')) {

            if (revenue <= 49000) {
                return 2000;
            }
            else if (revenue >= 50000 && revenue <= 99000) {
                return 4000;
            }
            else if (revenue >= 100000 && revenue <= 199000) {
                return 7000;
            }
            else if (revenue >= 200000 && revenue <= 499000) {
                return 10000;
            }
            else if (revenue >= 500000 && revenue <= 999000) {
                return 12500;
            }
            else if (revenue >= 1000000) {
                return 15000;
            }
        }

        else if (riskGrade.equals('2')) {

            if (revenue <= 49000) {
                return 1500;
            }
            else if (revenue >= 50000 && revenue <= 99000) {
                return 2500;
            }
            else if (revenue >= 100000 && revenue <= 199000) {
                return 5000;
            }
            else if (revenue >= 200000 && revenue <= 499000) {
                return 7500;
            }
            else if (revenue >= 500000 && revenue <= 999000) {
                return 10000;
            }
            else if (revenue >= 1000000) {
                return 12500;
            }
        }
        return 0;
    }

    /**
    * NA Fleet Credit Limit Table for companies in business for 1-3 years
    **/
    private static Decimal revolverCreditLimitTableThree(String riskGrade, Decimal revenue) {

        System.debug('Credit limit table 3');
        if (riskGrade.equals('1')) {

            if (revenue <= 49000) {
                return 3000;
            }
            else if (revenue >= 50000 && revenue <= 99000) {
                return 6000;
            }
            else if (revenue >= 100000 && revenue <= 199000) {
                return 9000;
            }
            else if (revenue >= 200000 && revenue <= 499000) {
                return 12000;
            }
            else if (revenue >= 500000 && revenue <= 999000) {
                return 16000;
            }
            else if (revenue >= 1000000) {
                return 20000;
            }
        }

        else if (riskGrade.equals('2')) {

            if (revenue <= 49000) {
                return 2000;
            }
            else if (revenue >= 50000 && revenue <= 99000) {
                return 4000;
            }
            else if (revenue >= 100000 && revenue <= 199000) {
                return 7500;
            }
            else if (revenue >= 200000 && revenue <= 499000) {
                return 10000;
            }
            else if (revenue >= 500000 && revenue <= 999000) {
                return 13000;
            }
            else if (revenue >= 1000000) {
                return 17500;
            }
        }

        return 0;
    }

    /**
     * NA Fleet Credit Limit Table for companies in business for 4 or more years
     **/
    private static Decimal revolverCreditLimitTableFour(String riskGrade, Decimal revenue) {

        System.debug('Credit limit table 4');
        if (riskGrade.equals('1')) {

            if (revenue <= 49000) {
                return 5000;
            }
            else if (revenue >= 50000 && revenue <= 99000) {
                return 8000;
            }
            else if (revenue >= 100000 && revenue <= 199000) {
                return 12000;
            }
            else if (revenue >= 200000 && revenue <= 499000) {
                return 16000;
            }
            else if (revenue >= 500000 && revenue <= 999000) {
                return 20000;
            }
            else if (revenue >= 1000000) {
                return 25000;
            }
        }

        else if (riskGrade.equals('2')) {

            if (revenue <= 49000) {
                return 3000;
            }
            else if (revenue >= 50000 && revenue <= 99000) {
                return 5000;
            }
            else if (revenue >= 100000 && revenue <= 199000) {
                return 8000;
            }
            else if (revenue >= 200000 && revenue <= 499000) {
                return 12000;
            }
            else if (revenue >= 500000 && revenue <= 999000) {
                return 16000;
            }
            else if (revenue >= 1000000) {
                return 20000;
            }
        }
        return 0;
    }


    global void postProcess() {

    }

    global void preProcess(List<sObject> records, String RuleName, String objectName) {

    }

}