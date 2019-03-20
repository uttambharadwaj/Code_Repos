/**
* Forseva online application code.
*/
public with sharing class EchoSignDocumentRenderer {

    public EchoSignDocumentRenderer(OnlineApplicationOffer__c offer, OnlineApplication application) {
        m_offer = offer;
        m_oa = application;
    }
    
    public Blob getEchoSignContractContents() {
        
        OnlineApplication__c oa = (OnlineApplication__c)SOUtility.getCompleteSObject(OnlineApplication__c.SObjectType, m_oa.getSO().Id);
        Map<String,String> nlMap = OnlineApplication.getNameLabelFieldMap(OnlineApplication__c.SObjectType);
        
        String theContents = '<html><body>';
        
        theContents += '<style>';
        theContents += 'body {margin-top:20px;margin-bottom:20px;margin-left:50px;margin-right:50px;font-family:arial;} ';
        theContents += 'table {font-size:12px;text-align:left;width:100%;} ';
        theContents += 'tr,td,th {font-size:12px;text-align:left;} ';
        theContents += '.title1 {font-size:20px;font-weight:bold;margin-bottom:10px;} ';
        theContents += '.title2 {font-size:12px;float:right;} ';
        theContents += '.heading1 {font-size:16px;font-weight:bold;border-bottom:1px black solid;width:100%;margin-top:10px;margin-bottom:10px;} ';
        theContents += '.tcText {font-size:12px;font-weight:bold;} ';
        theContents += '.shipToText {font-size:12px;margin-top:10px;margin-bottom:10px;} ';
        theContents += '.disclosureHeader {font-size:16px;font-weight:bold;margin-top:10px;margin-bottom:10px;} ';
        theContents += '.disclosureText {font-size:12px;} ';
        theContents += '</style>';
        
        if(m_offer.EchoSign_Header_Image__c != null) {
            theContents += '<img width="850px" src="' + m_offer.EchoSign_Header_Image__c.toLowerCase().replace('https','http') + '" />';
        }
        
        theContents += '<span class="title1">' + oa.Application_Title__c + '</span>';
        theContents += '<span class="title2">' + oa.Name + '</span><br/><br/>';
        
        //--------------------
        // company information
        //--------------------      

        theContents += generateContractDetailTable(oa, Label.CustomerInformation,
            new List<String>{'Promotional_Code__c', 'Legal_Business_Name__c', 'Trade_Name__c', 'Business_Street_Address__c',
                             'City__c', 'State__c', 'Zip_Code__c', 'Contact_Name__c', 'Email__c', 'Phone_Number__c', 'Fax_Number__c', 'Cell_Number__c',
                             'Embossing_Line_1_Company_Name__c'},
            new List<String>{'Type_of_Business__c', 'Federal_Tax_ID__c', 'MC_FF_or_DOT__c','Year_Established__c', 'Name_of_Parent_Company__c',
                             'Business_Description__c', 'Type_of_Business_Other__c', 'DUNS__c',
                             'Number_of_Vehicles__c', 'Number_of_Trucks__c', 'Number_of_Trailers__c', 'Number_of_Employees__c',
                             'Number_of_Drivers__c', 'Number_of_Cards_Needed__c'});
        
        //--------------------
        // account preferences
        //--------------------

        theContents += generateContractDetailTable(oa, Label.AccountPreferences,
            new List<String>{'Billing_Cycle__c', 'Payment_Method__c', 'Day_of_Payment__c'},        
            new List<String>{'Credit_Line_Requested__c', 'Invoice_Delivery_Method__c', 'Invoice_Delivery_Method_Email__c', 'Invoice_Delivery_Method_Fax__c'});

        //--------------------
        // bank account setup
        //--------------------

        if(oa.Financial_Institution__c != null) {
            theContents += generateContractDetailTable(oa, Label.BankAccountSetup,
                new List<String>{'Financial_Institution__c', 'Branch_Phone_Number__c', 'Branch_Address__c', 'Branch_City__c', 'Branch_State__c', 'Branch_Zip_Code__c'},
                new List<String>{'Checking_Account_Number__c', 'ABA_Routing_Number__c'});
        }

        //--------------------
        // authorizing officer
        //--------------------

        theContents += generateContractDetailTable(oa, Label.ProprietorPartner,
            new List<String>{'AO_Name__c', 'AO_Title__c', 'AO_Address__c', 'AO_City__c', 'AO_State__c', 'AO_Zip_Code__c'},
            new List<String>{'AO_Date_of_Birth__c', 'AO_Social_Security_Number__c', 'AO_Work_Email__c', 'AO_Home_Phone_Number__c'});

        if(OnlineApplication.MASTERCARD == m_oa.getProductType()) {
            theContents += generateContractListTable(m_oa.getAuthorizedContacts(), Label.AuthorizedContacts, 100, 
                new List<String>{'Name', 'Security_Code__c', 'Email__c'});
        }
        else {
            theContents += generateContractListTable(m_oa.getAuthorizedContacts(), Label.AuthorizedContacts, 100, 
                new List<String>{'Name', 'Security_Code__c', 'Email__c', 'Online_Password__c'});        
        }

        //--------------------
        // card setup
        //--------------------

        if(oa.Card_Setup_Bypassed__c == false) {

            if(OnlineApplication.MASTERCARD == m_oa.getProductType()) {

                // need a div between the table header and the table

                theContents += generateContractListTable(m_oa.getCardSetups(), Label.CardSetups, 100,
                    new List<String>{});
            	
            	theContents += '<div style="font-weight:bold;font-size:12px;width:100%;text-align:right;">' + Label.DailySpendingLimits + '</div>';
            	
            	theContents += generateContractListTable(m_oa.getCardSetups(), null, 100,
            	    new List<String>{'Card_Type__c', 'Cardholder_Name__c', 'Security_Code_Driver_ID__c', 'Card_Restrictions__c', 'Credit_Limit__c',
            	                     'Cash__c', 'All_Merchants__c', 'Fuel__c', 'Maint__c'});
                
                theContents += generateContractListTable(m_oa.getVehicleSetups(), Label.VehicleSetups, 60,
                    new List<String>{'Vehicle_Description__c', 'Vehicle_Id__c'});            	
            }
            else {
                theContents += generateContractListTable(m_oa.getVehicleSetups(), Label.VehicleSetups, 100,
                    new List<String>{'Vehicle_Description__c', 'Vehicle_Type__c', 'Fuel_Grade__c', 'Fuel__c', 'Maintenance__c', 'Additives__c', 'Miscellaneous__c'});
            }

            if(OnlineApplication.LOCAL == m_oa.getProductType()) {
                theContents += generateContractListTable(m_oa.getDriverSetups(), Label.DriverSetups, 100,
                    new List<String>{'Driver_Name__c', 'Driver_ID__c'});
            }
            else {
                theContents += generateContractListTable(m_oa.getDriverSetups(), Label.DriverSetups, 100,
                    new List<String>{'Driver_Name__c', 'Driver_ID__c', 'ATM_Access__c', 'Fuel_Grade__c', 'Fuel_Limit__c', 'Cash_Limit__c', 'Misc_Limit__c'});            
            }        

            if(OnlineApplication.OTR == m_oa.getProductType() && m_oa.getShowCardSetupPage()) {
                theContents += generateContractDetailTable(oa, Label.AdditionalPromptsAndServices,
                    new List<String>{'Odometer__c', 'Unit__c'},
                    new List<String>{'Trip__c', 'Other_Services__c'});        
            }

            List<OnlineApplicationUnitNumber__c> units = m_oa.getUnitNumbers();
            if(OnlineApplication.OTR == m_oa.getProductType() && units.size() > 0) {
                theContents += generateContractListTable(units, Label.UnitNumbers, 20, new List<String>{'Name'});        
            }

            theContents += '<div class="shipToText"><b>Ship To</b><br/><br/> ' + m_oa.getShipToAddress() + '</div>';

            // blank divider
            theContents += generateContractDetailTable(oa, '', new List<String>{}, new List<String>{});
        }

        //--------------------
        // legalese
        //--------------------

        theContents += '<div class="tcText"><input type="checkbox" name="n" value="" checked>' + 
                           getTermsAndConditionsVersion() + ' ' + Label.AcceptanceLowerCase + ': ' + Label.IOnBehalfOfMyself + 
                       '</div>';         
        
        theContents += '<div class="disclosureHeader">' + Label.Disclosure + '</div>';
        theContents += '<div class="disclosureText">' + m_oa.getDisclosure() + '</div>';

        theContents += '<div class="disclosureHeader">' + Label.AuthorizedRepresentative + '</div>';

        theContents += '</body></html>';
        return Blob.valueOf(theContents);       
    }

    //----------------
    // private
    //----------------
    
    private OnlineApplicationOffer__c m_offer;
    private OnlineApplication m_oa;

    private String generateContractDetailTable(OnlineApplication__c oa, String name, List<String> leftSide, List<String> rightSide) {

        Map<String,String> nlMap = OnlineApplication.getNameLabelFieldMap(OnlineApplication__c.SObjectType);
        String theContents = '';
   
        if(name != null) {
            theContents = '<span class="heading1">' + name + '</span>';
        }
        
        theContents += '<table><tr>';        
        theContents += '<td style="vertical-align:top;width:50%;"><table cellpadding="3" border="0">';
        for(String leftSideItem : leftSide) {
            String leftSideItemValue = OnlineApplication.getFormattedValue(OnlineApplication__c.SObjectType, leftSideItem, oa.get(leftSideItem));
            if(leftSideItemValue != null && leftSideItemValue.length() > 0) {
                theContents += '<tr><td><b>' + nlMap.get(leftSideItem) + '</b></td><td>' + leftSideItemValue + '</td></tr>';        
            }
        }
        theContents += '</table></td>';
        theContents += '<td style="vertical-align:top;width:50%;"><table cellpadding="3" border="0">';
        for(String rightSideItem : rightSide) {
            String rightSideItemValue = OnlineApplication.getFormattedValue(OnlineApplication__c.SObjectType, rightSideItem, oa.get(rightSideItem));
            if(rightSideItemValue != null && rightSideItemValue.length() > 0) {
                theContents += '<tr><td><b>' + nlMap.get(rightSideItem) + '</b></td><td>' + rightSideItemValue + '</td></tr>';        
            }
        }
        theContents += '</table></td>';
        theContents += '</tr></table>';
        
        return theContents;
    }
                           
    private String generateContractListTable(List<SObject> objs, String name, Integer headerWidthPercent, List<String> columns) {
        
        if(objs.size() == 0) {
            return '';
        }
    
        Map<String,String> nlMap = OnlineApplication.getNameLabelFieldMap(objs[0].getSObjectType());
        String theContents = '';
    
        if(name != null) {    
            theContents = '<div class="heading1" style="width:' + headerWidthPercent + '%;">' + name + '</div>';
        }
        
        theContents += '<table cellpadding="3" border="0">';
    
        // table header row
        theContents += '<tr width="100%">';
        for(String column : columns) {
            theContents += '<th width="25%">' + nlMap.get(column) + '</th>';
        }    
        theContents += '</tr>';
    
        // table detail rows
        for(SObject so : objs) {
            theContents += '<tr width="100%">';
            for(String column : columns) {
                Object columnValue = so.get(column);
                theContents += '<td width="25%">' + OnlineApplication.getFormattedValue(objs[0].getSObjectType(), column, columnValue) + '</td>';
            }
            theContents += '</tr>';
        }
    
        theContents += '</table>';
    
        return theContents;    
    }
    
    private String getTermsAndConditionsVersion() {    
        OnlineApplication__c oa = [select Id, Offer__r.Terms_and_Conditions_Version__c from OnlineApplication__c where Id = :m_oa.getSO().Id];
        return oa.Offer__r.Terms_and_Conditions_Version__c;
    }    

}

// EOF