@IsTest
private class TestPOboxChecker{
    
//    static testmethod void UpdateWeFormFail(){
//
//	    try {
//
//	        WeFormObject__c we = new WeFormObject__c();
//
//	        we.Address_Line_2__c = 'Suite 100';
//	        we.Billing_Address_Line_2__c = 'Suite 100';
//	        we.Billing_City__c = 'Kingston';
//	        we.Billing_Contact_First_Name__c = 'Professional';
//	        we.Billing_Contact_Last_Name__c = 'Services';
//	        we.Billing_Email__c = 'ps@stantive.com';
//	        we.Billing_Fax__c = '555-555-5555';
//	        we.Billing_Phone__c = '613-555-5556';
//	        we.Billing_State__c = 'ON';
//	        we.Billing_Street_Address__c = 'P.O. Box 4 Cataraqui Street';
//	        we.Billing_Zip_Code__c = '62106';
//	        we.Business_fax__c = '613-555-5554';
//	        we.Business_Phone__c = '613-555-5555';
//	        we.Business_Street_Address__c = 'Box 4 Cataraqui Street';
//	        we.Billing_Mobile_Phone__c = '555-555-5555';
//	        we.Date_of_Birth__c = '10/01/1986';
//	        we.PG_SSN__c = '123-45-6789';
//	        we.Mobile_Phone__c = '555-555-5555';
//	        we.PG_Residential_Street_Address__c = '11 Awesome Street';
//	        we.PG_Residential_City__c = 'Adventure Land';
//	        we.PG_Residential_State__c = 'CA';
//	        we.PG_Residential_Zip__c = '43402';
//	        we.Guarantor_Annual_Income__c = 100000;
//	        we.DUNS_Number__c = '97124';
//	        we.Avg_Monthly_Fuel_Service_Expenses__c = 24000;
//	        we.Annual_Gross_Revenue__c = 250000;
//
//
//	        we.Campaign_Program_Id__c = '012456';
//	        //cp1.Campaign__c = '70170000000fo68AAA';
//	        //cp1.Program__c = 'a0Z70000001uyLHEAY';
//	        we.City__c = 'Kingston';
//	        we.Company_Name__c = 'Stantive Technologies';
//	        we.Doing_Business_As__c = 'Stantive';
//	       // we.Email__c = 'ps@stantive.com';
//	        we.Employee_Id__c = '1234';
//	        we.Estimated_Monthly_Vehicle_Expenses__c = 9000.0;
//	        we.First_Name__c = 'Professional';
//	        we.Fiscal_Year_Starts__c = 'Jan';
//	        we.Group_Code__c = 'ABC';
//	        we.How_did_you_hear_about_this_offer__c = 'Web';
//	        we.Is_business_exempt_from_Motor_Fuels_Tax__c = 'Yes';
//	        we.Last_Name__c = 'Services';
//	        we.Legal_Structure__c = 'Corporation';
//	        we.Location_Code__c = 'NW';
//	        we.Promotional_Code__c = 'B1C';
//	        we.Paperless_Flag__c = 'yes';
//	        we.Sales_Id__c = '663434';
//	        we.Same_as_Business_Address__c = true;
//	        we.Signer_s_Email__c = 'ps@stantive.com';
//	        we.Signer_s_First_Name__c = 'Development';
//	        we.Signer_s_Last_Name__c = 'Services';
//	        we.Signer_s_Phone__c = '613-555-1111';
//	        we.signer_title__c = 'President';
//	        we.State__c = 'ON';
//	        we.Taxpayer_ID__c = '5664363';
//	        we.Years_in_Business__c = 'Less than 12 months';
//	        we.Zip_code__c = '62106';
//
//	        /* Added by Trekbin on 13 Aug, 2015*/
//	        Test.setMock(HttpCalloutMock.class, new CustomHttpCalloutMock());
//			Test.startTest();
//	    		insert we;
//
//		} catch(DMLException e){
//
//			//Assert Error Message
//			System.debug('error code' + e.getMessage() + 'failure occured at:' + e.getNumDml());
//
//		}
//
//	 	Test.stopTest();
//  	}
//
//
//    static testMethod void checkPhysicalAddressOpp(){
//
//        Opportunity testOpp = new Opportunity();
//        testOpp.Physical_Street__c = 'P.O. box 123';
//        testOpp.Physical_Street_Line_2__c = 'po box 456';
//        testOpp.Name = 'Test the Awesome';
//        testOpp.StageName = '5) Signed';
//        testOpp.CloseDate = date.newInstance(2017, 2, 17);
//
//		test.startTest();
//        try{
//       		 insert testOpp;
//        }
//       catch(DMLException e){
//            //Assert Error Message
// 	  		System.debug('error code' + e.getMessage() + 'failure occured at:' + e.getNumDml());
//
//        }
//        test.stopTest();
//
//    }
//
//    /* Added by Trekbin on 13 Aug, 2015*/
//    // Prepare mock callout
//	public class CustomHttpCalloutMock implements HttpCalloutMock {
//
//		public HTTPResponse respond(HTTPRequest req) {
//
//			HTTPResponse retVal = new HTTPResponse();
//			retVal.setStatusCode(200);
//			return retVal;
//		}
//	}
}