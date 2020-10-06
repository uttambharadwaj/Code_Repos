@isTest
private class VeloxyLeadUtilTest {

    @testSetup
    static void setup(){
        UtilityTestLoader.setAutomation(false);
    }

    static testMethod void conversionRestApiTest() {
        
        Lead lead = new Lead();

        Map <String,String> sta = new Map <String,String>();
        lead.FirstName = 'Veloxy';
        lead.LastName = 'Test';
        lead.Email = 'support@veloxy.io';
        lead.Company = 'veloxyTest';
        lead.Status = 'Open - Not Contacted';
    
        Database.SaveResult db = Database.insert(lead, false);
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        
        req.requestURI = '/services/apexrest/VeloxyLeadUtil/' + db.getId();  //Request URL
        req.httpMethod = 'POST';//HTTP Request Type
        RestContext.request = req;
        RestContext.response= res;
        
        Map<String,String> stas=VeloxyLeadUtil.doPost();
        system.assert(stas.get('id')!=null);//Similarly assert rest as well

    }
}