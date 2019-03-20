@isTest
class PartnersCommLoginControllerTests implements HttpCalloutMock
{
    @IsTest(SeeAllData=true)        
    private static void testPartnersCommLoginController() 
    {   
        Deployment_PartnersCommunity d = new Deployment_PartnersCommunity(Deployment_PartnersCommunity.Environment.DEV);

        d.run();

        String testPortalName = 'Portal Site Test';

        PartnersCommLoginController controller = new PartnersCommLoginController ();

        controller.username = 'test@salesforce.com';
        controller.password = '123456'; 

        Test.startTest();

        Test.setMock (HttpCalloutMock.class, new PartnersCommLoginControllerTests());
        System.assertEquals(controller.login(), null);

        Test.stopTest();
    }

    @isTest
    static void TestBadUserPass()
    {
        Deployment_PartnersCommunity d = new Deployment_PartnersCommunity(Deployment_PartnersCommunity.Environment.DEV);

        d.run();

        String testPortalName = 'Portal Site Test';

        PartnersCommLoginController controller = new PartnersCommLoginController ();

        Test.startTest();
        
        PartnersCommLoginControllerTests mock = new PartnersCommLoginControllerTests();

        // force an exception if we actually get into the ws mock - we're testing
        // stuff that should exit before that
        mock.ThrowError = true;

        Test.setMock (HttpCalloutMock.class, mock);

        System.assertEquals(controller.login(), null);

        string user = 'test@salesforce.com';
        string pass = '123456';
        
        controller.username = user;
        controller.password = null;
        System.assertEquals(controller.login(), null);

        controller.username = null;
        controller.password = pass; 
        System.assertEquals(controller.login(), null);

        try
        {
            controller.username = user;
	        controller.password = pass; 
	        System.assertEquals(controller.login(), null);

            // should get an exception from mock ThrowError
            system.assert (false, 'exception expected but not thrown');
        }
        catch (Exception ex)
        {
            // good.. this is expected.. 
        }

        Test.stopTest();
    }

    // mock-related code below..
    public boolean ThrowError = false;
    public integer WantedStatus = 200;
    public string ResponseBody = 'Your login attempt has failed';
    public map<string, string>ResponseHeaders = new map<string, string>
        {'Content-Type' => 'application/json'}
    ;

    public HTTPResponse respond(HTTPRequest req) 
    {
        if (ThrowError)
            throw new PartnersCommLoginController.CustomException ('exception!');

        HttpResponse res = new HttpResponse();

        if (ResponseHeaders != null)
        {
            for (string key : ResponseHeaders.keyset())
                res.setHeader (key, ResponseHeaders.get (key));
        }

        res.setBody(ResponseBody);
        res.setStatusCode(WantedStatus);

        return res;
    }
}