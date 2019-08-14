/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class AssetConversionTest {
    static testMethod void myUnitTest() {
   
    Child_Host__c objchild = new Child_Host__c(name='Test',ship_notes__c='test', of_amerinet_sites__c=100);
            insert objchild;
            
    Account a = new Account();
    a.name = 'test';
    insert a;            
            
    Account_Asset__c assetbuild = new Account_Asset__c (Name='test', Active_Cards__c=500, of_Amerinet_Sites__c=500);//, of_Retail_Sites__c, of_PacPride_Sites__c, of_PrideNet_Sites__c, of_Cards__c,X3rd_Party_Vendor__c, X4X10_Sign_Ordered__c,Account__c,Account_Asset_Billing_City__c,Account_Asset_Billing_State__c,  Account_Asset_Billing_Street__c, Account_Asset_Billing_Zip_Code__c, Account_Asset_Shipping_City__c,Account_Asset_Shipping_State__c,Account_Asset_Shipping_Street__c, Account_Asset_Shipping_Zip_Code__c,Account_Health__c,    Additional_Business_Type__c,Additional_Contact__c,Address__c,Ad_Fund__c,Ad_Fund_Current_Year_Total__c,Ad_Fund_Year_End_Total__c,Agreement_Length__c,Agreement_Modified__c,Amount_of_Security_Instrument__c, Approval_Date__c,Assistance_with_Conversion__c,Batch_File_Type__c,Billing_Address__c, Billing_System__c,Block_of_Cards_Issued__c,Branded__c,Card_Funding__c,Card_Ordering_Training__c,Cards_Allowed_to_be_Issued__c, CA_SG__c,Comdata_Fired__c,Comdata_Ordered__c,Company_Tax_ID_Name__c,Contact__c,Contact_Address__c,Contact_Fax__c,Contact_Other_Address__c, Contact_Phone__c,Contract_End_Date__c,Contract_Start_Date__c,Conversion_From_Optical_Cards__c, Co_Op_Fund__c,Date_Form_Reviewed_and_Sent__c,Historical_Account_Asset__c, Date_signed_by_Client__c, Date_Submitted_to_FSV_Bancorp__c,Disclosure_Receipt_on_File__c,Dual_Marketer__c,  Due_Diligence_Stage__c,Email__c, Fax__c ,Fees_Waived__c,Fees_Waived_Amount__c, Fee_Waived_Date__c ,Fire_Date__c ,Fire_Notes__c, First_Pay_Date__c,FP_Fee__c ,FP_Gallons__c, FP_Month_Year__c ,Franchise_Renewal_Date__c,FS_Fee__c ,FS_Gallons__c, FS_Month_year__c ,Gallons_per_Month__c,Notes__c ,Go_Live_Date__c, Growth_Notes__c, High_Priority__c,Host_Number__c,Increase_or_Decrease_Amount__c,Inspection_Year__c,Install_Date__c,Installer__c, Install_Notes__c, Insurance_Cancelation_Date__c,Insurance_Carrier__c,Insurance_Expiration_Date__c,Insurance_Deadline_Date__c, Interest_in_Adding_Sites__c,Legal_Name__c , Line_of_Business__c,Logo_Set_Up__c,Mail_Merge__c,Marketer_Type__c ,Marketer_Type_Date__c,Marketing_Materials_Sent__c ,MC_Account__c,MC_Spend_per_Month__c,New_Franchise_Act__c , New_Franchise_Est__c ,New_Security_Amount__c,Govt_Extentions__c ,Notice_of_Term_Period__c, Opportunity__c, Status_Effective_Date__c,Current_Security_Amount__c ,Originating_Sales_Rep__c,PAC_Pride_ID__c,Participating_in_Pacific_Pride_Meetings__c,Payment_Terms__c,Pay_Period__c,Phone_Number__c,Photos__c,Platform_Type__c,Portal_Set_Up__c,Pump_Striping_Ordered__c ,Rebate__c,Recall__c ,Receivable_Manager__c,Record_Source_Created_Date__c, Record_Source_Creator__c , Record_Source_Last_Modified_Date__c,Record_Source_Merge_Date__c ,Reimbursement__c,Co_Op_Fund_Reimbursement__c,Reimbursement_Amount__c,Reimbursement_Date__c,Reimbursement_Reason__c,Renewal_Fee_Due_Date__c,Retail__c,Risk_Description__c,Risk_Grade__c ,Risk_Result__c,Risk_Type__c ,Security_Amount_Change__c, Security_Amount_Change_Date__c,Security_Cancelation_Date__c , Security_Expiration_Date__c ,Security_Deadline_Date__c, SFTP_Sent_Date__c ,Ship_Date__c,Ship_Notes__c ,Shipping_Address__c,Signage_Credit_Granted__c,Signage_Ordered__c, Site_Type__c ,Site_Upgrades__c,Site_visit_per_Rollout__c, State_Maps_Ordered__c,States_of_Operation__c, Status_N__c, Status_Notes__c,Sub_Company_ID__c,Tax_ID_Number__c,Total_Cards__c,Total_Renewal_Fee_Due__c, Training__c,Training_Attended__c, Training_Date__c,Type_of_Card__c,Type_of_Cards_Issued__c,Type_of_Security__c, W_9_1099__c,Wallet_Card_Ordered__c, WEX_Account__c);
    assetbuild.Account__c = a.id;
           insert assetbuild;
            
      System.currentPageReference().getParameters().put('Id', objchild.Id);   
      ApexPages.StandardController std = new ApexPages.StandardController(objchild);      
      AssetConversion act = new AssetConversion();
      AssetConversion.ChildDevelopment(assetbuild.id);
    

objchild.of_Amerinet_Sites__c=assetbuild.of_Amerinet_Sites__c;
objchild.of_Cards__c=assetbuild.of_Cards__c;
objchild.of_PacPride_Sites__c=assetbuild.of_PacPride_Sites__c;
objchild.of_PrideNet_Sites__c=assetbuild.of_PrideNet_Sites__c;
objchild.of_Retail_Sites__c=assetbuild.of_Retail_Sites__c;
objchild.X3rd_Party_Vendor__c=assetbuild.X3rd_Party_Vendor__c;
objchild.X4X10_Sign_Ordered__c=assetbuild.X4X10_Sign_Ordered__c;
objchild.Account__c=assetbuild.Account__c;
objchild.Account_Asset_Billing_City__c=assetbuild.Account_Asset_Billing_City__c;
objchild.Account_Asset_Billing_State__c=assetbuild.Account_Asset_Billing_State__c;
objchild.Account_Asset_Billing_Street__c=assetbuild.Account_Asset_Billing_Street__c;
objchild.Account_Asset_Billing_Zip_Code__c=assetbuild.Account_Asset_Billing_Zip_Code__c;
objchild.Account_Asset_Shipping_City__c=assetbuild.Account_Asset_Shipping_City__c;
objchild.Account_Asset_Shipping_State__c=assetbuild.Account_Asset_Shipping_State__c;
objchild.Account_Asset_Shipping_Street__c=assetbuild.Account_Asset_Shipping_Street__c;
objchild.Account_Asset_Shipping_Zip_Code__c=assetbuild.Account_Asset_Shipping_Zip_Code__c;
objchild.Account_Health__c=assetbuild.Account_Health__c;
objchild.Account_Manager__c=assetbuild.Account_Manager__c;
objchild.Active_Cards__c=assetbuild.Active_Cards__c;
objchild.Additional_Business_Type__c=assetbuild.Additional_Business_Type__c;
objchild.Additional_Contact__c=assetbuild.Additional_Contact__c;
objchild.Ad_Fund__c=assetbuild.Ad_Fund__c;
objchild.Ad_Fund_Current_Year_Total__c=assetbuild.Ad_Fund_Current_Year_Total__c;
objchild.Ad_Fund_Year_End_Total__c=assetbuild.Ad_Fund_Year_End_Total__c;
objchild.Agreement_Length__c=assetbuild.Agreement_Length__c;
objchild.Amount_of_Security_Instrument__c=assetbuild.Amount_of_Security_Instrument__c;
objchild.Approval_Date__c=assetbuild.Approval_Date__c;
objchild.Assistance_with_Conversion__c=assetbuild.Assistance_with_Conversion__c;
objchild.Billing_System__c=assetbuild.Billing_System__c;
objchild.Block_of_Cards_Issued__c=assetbuild.Block_of_Cards_Issued__c;
objchild.Branded__c=assetbuild.Branded__c;
objchild.Card_Funding__c=assetbuild.Card_Funding__c;
objchild.Card_Ordering_Training__c=assetbuild.Card_Ordering_Training__c;
objchild.Cards_Allowed_to_be_Issued__c=assetbuild.Cards_Allowed_to_be_Issued__c;
objchild.Comdata_Fired__c=assetbuild.Comdata_Fired__c;
objchild.Comdata_Ordered__c=assetbuild.Comdata_Ordered__c;
objchild.Company_Tax_ID_Name__c=assetbuild.Company_Tax_ID_Name__c;
objchild.Contact__c=assetbuild.Contact__c;
objchild.Contract_End_Date__c=assetbuild.Contract_End_Date__c;
objchild.Contract_Start_Date__c=assetbuild.Contract_Start_Date__c;
objchild.Conversion_From_Optical_Cards__c=assetbuild.Conversion_From_Optical_Cards__c;
objchild.Co_Op_Fund__c=assetbuild.Co_Op_Fund__c;
objchild.Date_Form_Reviewed_and_Sent__c=assetbuild.Date_Form_Reviewed_and_Sent__c;
objchild.Date_signed_by_Client__c=assetbuild.Date_signed_by_Client__c;
objchild.Date_Submitted_to_FSV_Bancorp__c=assetbuild.Date_Submitted_to_FSV_Bancorp__c;
objchild.Disclosure_Receipt_on_File__c=assetbuild.Disclosure_Receipt_on_File__c;
objchild.Dual_Marketer__c=assetbuild.Dual_Marketer__c;
objchild.Due_Diligence_Stage__c=assetbuild.Due_Diligence_Stage__c;
objchild.Email__c=assetbuild.Email__c;
objchild.Fees_Waived__c=assetbuild.Fees_Waived__c;
objchild.Fees_Waived_Amount__c=assetbuild.Fees_Waived_Amount__c;
objchild.Fee_Waived_Date__c=assetbuild.Fee_Waived_Date__c;
objchild.Fire_Date__c=assetbuild.Fire_Date__c;
objchild.Fire_Notes__c=assetbuild.Fire_Notes__c;
objchild.FP_Fee__c=assetbuild.FP_Fee__c;
objchild.FP_Gallons__c=assetbuild.FP_Gallons__c;
objchild.FP_Month_Year__c=assetbuild.FP_Month_Year__c;
objchild.Franchise_Renewal_Date__c=assetbuild.Franchise_Renewal_Date__c;
objchild.FS_Fee__c=assetbuild.FS_Fee__c;
objchild.FS_Gallons__c=assetbuild.FS_Gallons__c;
objchild.FS_Month_year__c=assetbuild.FS_Month_year__c;
objchild.Gallons_per_Month__c=assetbuild.Gallons_per_Month__c;
objchild.Notes__c=assetbuild.Notes__c;
objchild.Growth_Notes__c=assetbuild.Growth_Notes__c;
objchild.High_Priority__c=assetbuild.High_Priority__c;
objchild.Host_Number__c=assetbuild.Host_Number__c;
objchild.Increase_or_Decrease_Amount__c=assetbuild.Increase_or_Decrease_Amount__c;
objchild.Inspection_Year__c=assetbuild.Inspection_Year__c;
objchild.Install_Date__c=assetbuild.Install_Date__c;
objchild.Installer__c=assetbuild.Installer__c;
objchild.Install_Notes__c=assetbuild.Install_Notes__c;
objchild.Insurance_Cancelation_Date__c=assetbuild.Insurance_Cancelation_Date__c;
objchild.Insurance_Carrier__c=assetbuild.Insurance_Carrier__c;
objchild.Insurance_Expiration_Date__c=assetbuild.Insurance_Expiration_Date__c;
objchild.Insurance_Renewal_Date__c=assetbuild.Insurance_Deadline_Date__c;
objchild.Interest_in_Adding_Sites__c=assetbuild.Interest_in_Adding_Sites__c;
objchild.Legal_Name__c=assetbuild.Legal_Name__c;
objchild.Line_of_Business__c=assetbuild.Line_of_Business__c;
objchild.Logo_Set_Up__c=assetbuild.Logo_Set_Up__c;
objchild.Mail_Merge__c=assetbuild.Mail_Merge__c;
objchild.Marketer_Type__c=assetbuild.Marketer_Type__c;
objchild.Marketer_Type_Date__c=assetbuild.Marketer_Type_Date__c;
objchild.MC_Account__c=assetbuild.MC_Account__c;
objchild.MC_Spend_per_Month__c=assetbuild.MC_Spend_per_Month__c;
objchild.New_Franchise_Act__c=assetbuild.New_Franchise_Act__c;
objchild.New_Franchise_Est__c=assetbuild.New_Franchise_Est__c;
objchild.Govt_Extentions__c=assetbuild.Govt_Extentions__c;
objchild.Name=assetbuild.Name;
objchild.Notice_of_Term_Period__c=assetbuild.Notice_of_Term_Period__c;
objchild.Status_Effective_Date__c=assetbuild.Status_Effective_Date__c;
objchild.Current_Security_Amount__c=assetbuild.Current_Security_Amount__c;
objchild.Originating_Sales_Rep__c=assetbuild.Originating_Sales_Rep__c;
objchild.PAC_Pride_ID__c=assetbuild.PAC_Pride_ID__c;
objchild.Participating_in_Pacific_Pride_Meetings__c=assetbuild.Participating_in_Pacific_Pride_Meetings__c;
objchild.Payment_Terms__c=assetbuild.Payment_Terms__c;
objchild.Photos__c=assetbuild.Photos__c;
objchild.Platform_Type__c=assetbuild.Platform_Type__c;
objchild.Pump_Striping_Ordered__c=assetbuild.Pump_Striping_Ordered__c;
objchild.Rebate__c=assetbuild.Rebate__c;
objchild.Recall__c=assetbuild.Recall__c;
objchild.Receivable_Manager__c=assetbuild.Receivable_Manager__c;
objchild.Record_Source_Created_Date__c=assetbuild.Record_Source_Created_Date__c;
objchild.Record_Source_Creator__c=assetbuild.Record_Source_Creator__c;
objchild.Record_Source_Last_Modified_Date__c=assetbuild.Record_Source_Last_Modified_Date__c;
objchild.Record_Source_Merge_Date__c=assetbuild.Record_Source_Merge_Date__c;
objchild.Reimbursement__c=assetbuild.Reimbursement__c;
objchild.Co_Op_Fund_Reimbursement__c=assetbuild.Co_Op_Fund_Reimbursement__c;
objchild.Reimbursement_Amount__c=assetbuild.Reimbursement_Amount__c;
objchild.Reimbursement_Date__c=assetbuild.Reimbursement_Date__c;
objchild.Reimbursement_Reason__c=assetbuild.Reimbursement_Reason__c;
objchild.Renewal_Fee_Due_Date__c=assetbuild.Renewal_Fee_Due_Date__c;
objchild.Retail__c=assetbuild.Retail__c;
objchild.Risk_Description__c=assetbuild.Risk_Description__c;
objchild.Risk_Grade__c=assetbuild.Risk_Grade__c;
objchild.Risk_Result__c=assetbuild.Risk_Result__c;
objchild.Risk_Type__c=assetbuild.Risk_Type__c;
objchild.Security_Amount_Change__c=assetbuild.Security_Amount_Change__c;
objchild.Security_Amount_Change_Date__c=assetbuild.Security_Amount_Change_Date__c;
objchild.Security_Cancelation_Date__c=assetbuild.Security_Cancelation_Date__c;
objchild.Security_Expiration_Date__c=assetbuild.Security_Expiration_Date__c;
objchild.Security_Renewal_Date__c=assetbuild.Security_Deadline_Date__c;
objchild.Ship_Date__c=assetbuild.Ship_Date__c;
objchild.Ship_Notes__c=assetbuild.Ship_Notes__c;
objchild.Signage_Credit_Granted__c=assetbuild.Signage_Credit_Granted__c;
objchild.Signage_Ordered__c=assetbuild.Signage_Ordered__c;
objchild.Site_Type__c=assetbuild.Site_Type__c;
objchild.Site_Upgrades__c=assetbuild.Site_Upgrades__c;
objchild.State_Maps_Ordered__c=assetbuild.State_Maps_Ordered__c;
objchild.Status_N__c=assetbuild.Status_N__c;
objchild.Status_Notes__c=assetbuild.Status_Notes__c;
objchild.Tax_ID_Number__c=assetbuild.Tax_ID_Number__c;
objchild.Total_Cards__c=assetbuild.Total_Cards__c;
objchild.Training__c=assetbuild.Training__c;
objchild.Training_Attended__c=assetbuild.Training_Attended__c;
objchild.Training_Date__c=assetbuild.Training_Date__c;
objchild.Type_of_Card__c=assetbuild.Type_of_Card__c;
objchild.Type_of_Cards_Issued__c=assetbuild.Type_of_Cards_Issued__c;
objchild.Type_of_Security__c=assetbuild.Type_of_Security__c;
objchild.W_9_1099__c=assetbuild.W_9_1099__c;
objchild.Wallet_Card_Ordered__c=assetbuild.Wallet_Card_Ordered__c;
objchild.WEX_Account__c=assetbuild.WEX_Account__c;
        update objchild;
        
        //Opportunity OppUpd = [select sales_Rep__c, OwnerID, Opportunity_Type__c from Opportunity where id = :OpptoCreate.Id];
        System.assert(objchild.account__r.id == assetbuild.account__r.id);
        
        /* End - TO DO: implement unit test */        
    }
    }