/**
 * Created by dgilbert on 10/18/2018.
 * Revision History: 5/4/2020: Release 20.09: EAPT-1618: Added a method to check for Legal Structure vs Company Name - Uttam Bharadwaj
 *
 */

public with sharing class CreditWS_Utils {

    public static String buildHTTPCalloutParameterString(Map<String, String> parameters) {

        List<String> joinedParameters = new List<String>();

        for (String key : parameters.keySet()) {

            if (parameters.get(key) != null) {

                joinedParameters.add(key + '=' + EncodingUtil.urlEncode(parameters.get(key), 'UTF-8'));

            }

        }

        return String.join(joinedParameters, '&');

    }

    public static Boolean checkLegalStructure(String companyName, String legalStructure) {

        // Check for LLC
        //

        System.debug('####' + companyName + '  ###' + legalStructure);

        if ( legalStructure.equalsIgnoreCase('Internal Conversion')){
            return true;
        }

        if (
                ((companyName.endsWithIgnoreCase(' LLC')) || (companyName.endsWithIgnoreCase(' L.L.C.'))
                        || (companyName.endsWithIgnoreCase(' L.L.C')))
                        && legalStructure != 'Limited Liability Company'
                ) {
            return false;
        }

        // Check for Company, Corporation
        if (
                ((companyName.endsWithIgnoreCase(' Corp')) || (companyName.endsWithIgnoreCase(' Corporation')))
                        && (legalStructure != 'Corporation' && legalStructure != 'Corporation/Association')
                ) {
            return false;
        }

        // Check for Co
        if (
                (companyName.endsWithIgnoreCase(' Co'))
                        && (legalStructure != 'Corporation' && legalStructure != 'Corporation/Association' &&
                        legalStructure != 'Public Company and Majority Owned Affiliate')
                ) {
            return false;
        }

        // Check for Unincorporated Association
        if (
                (companyName.containsIgnoreCase('Unincorporated Association'))
                        && (legalStructure != 'Unincorporated Association')
                ) {
            return false;
        }

        // Check for Corporation/Association
        if (
                ((companyName.endsWithIgnoreCase(' Association')) || (companyName.endsWithIgnoreCase(' Associated')) ||
                        (companyName.endsWithIgnoreCase(' Assoc')))
                        && (legalStructure != 'Corporation/Association') && (!companyName.containsIgnoreCase('Unincorporated Association'))
                ) {
            return false;
        }

        // Check for Bank
        if (
                ((companyName.startsWithIgnoreCase('Bank')) || (companyName.endsWithIgnoreCase('Bank')) ||
                        (companyName.startsWithIgnoreCase('Credit Union')) || (companyName.endsWithIgnoreCase('Credit Union')))
                        && (legalStructure != 'Bank/Bank Holding Co/Credit Union')
                ) {
            return false;
        }

        // Check for Insurance Company
        if (
                (companyName.containsIgnoreCase('Insurance'))
                        && (legalStructure != 'Insurance Company' && legalStructure != 'Investment Company/Adviser')
                ) {
            return false;
        }

        // Check for Government Agency
        if (
                companyName.containsIgnoreCase('Department of')
                        && (legalStructure != 'Federal/State/Local Government Agency or Authority')
                ) {
            return false;
        }

        // Check for Investment Company/Adviser
        if (
                (companyName.containsIgnoreCase('Adviser'))
                        && (legalStructure != 'Investment Company/Adviser')
                ) {
            return false;
        }

        // Check for Non-Profit
        if (
                ((companyName.containsIgnoreCase('Non-Profit')) || (companyName.containsIgnoreCase('Non Profit')))
                        && (legalStructure != 'Non-Profit')
                ) {
            return false;
        }

        // Check for Non-Statutory Trust
        if (
                ((companyName.containsIgnoreCase('Non-Statutory Trust')) || (companyName.containsIgnoreCase('Non Statutory Trust')))
                        && (legalStructure != 'Non-Statutory Trust')
                ) {
            return false;
        }

        // Check for Partnership
        if (
                (companyName.containsIgnoreCase('Partners'))
                        && (legalStructure != 'Partnership')
                ) {
            return false;
        }

        // Check for CPA
        if (
                ((companyName.endsWithIgnoreCase(' CPA')) || (companyName.containsIgnoreCase(' CPA ')))
                        && (legalStructure != 'Public Accounting Firm')
                ) {
            return false;
        }

        // Check for Public Company
        if (
                ((companyName.containsIgnoreCase('Public Company')) || (companyName.containsIgnoreCase('Majority Owned Affiliate')))
                        && (legalStructure != 'Public Company and Majority Owned Affiliate')
                ) {
            return false;
        }

        // Check for Public Company
        if (
                ((companyName.containsIgnoreCase('Public Company')) || (companyName.containsIgnoreCase('Majority Owned Affiliate')))
                        && (legalStructure != 'Public Company and Majority Owned Affiliate')
                ) {
            return false;
        }

        // Check for Sole Proprietorship
        if (
                ((companyName.endsWithIgnoreCase('Sole Prop')) || (companyName.containsIgnoreCase('Sole Proprietorship')))
                        && (legalStructure != 'Sole Proprietorship')
                ) {
            return false;
        }

        // Check for Natural Person
        if (
                (companyName.containsIgnoreCase('Natural Person'))
                        && (legalStructure != 'Natural Person')
                ) {
            return false;
        }

        return true;


    }
}