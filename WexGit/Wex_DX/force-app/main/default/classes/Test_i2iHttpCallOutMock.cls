@isTest
global class Test_i2iHttpCallOutMock implements HttpCalloutMock {

    global HTTPResponse respond(HTTPRequest req) {
        
        system.debug('-----Mock return endpoint = ' + req.getEndPoint());
        
        HttpResponse res = new HttpResponse();
        
        res.setHeader('Content-Type', 'application/json');
        //body needs to be what's returned.
		
		//OCR MATCH
        string resbody = '[{"ReturnDescription":"Success","i2iID":1,"FirstName":"test","LastName":"test","Company":"THE TEST COMPANY","Address":"127 STREET","City":"TEST","State":"MA","zip":11111,"Email":"test@test.com","Title":"","LeadSource":"","SICCode":"","SFDCContactID":"","SFDCParentLeadID":"","CouponCode":"test1","MailDate":"2/10/2014 12:00:00 AM","PromoCode":"test1-test","Offer":"","i2iContactId":""},';
        //LEAD MATCH
        resbody += '{"ReturnDescription":"Success","i2iID":4,"FirstName":"test","LastName":"test","Company":"THE TEST COMPANY","Address":"127 STREET","City":"TEST","State":"MA","zip":11111,"Email":"","Title":"","LeadSource":"","SICCode":"","SFDCContactID":"","SFDCParentLeadID":"","CouponCode":"test4","MailDate":"2/10/2014 12:00:00 AM","PromoCode":"test4-test4","Offer":"","i2iContactId":""},';
        //NO MATCH (2)
        resbody += '{"ReturnDescription":"Success","i2iID":199,"FirstName":"test","LastName":"test","Company":"THE TEST COMPANY","Address":"127 STREET","City":"TEST","State":"MA","zip":11111,"Email":"","Title":"","LeadSource":"","SICCode":"","SFDCContactID":"","SFDCParentLeadID":"","CouponCode":"199","MailDate":"2/10/2014 12:00:00 AM","PromoCode":"199","Offer":"","i2iContactId":""},';
		resbody += '{"ReturnDescription":"Success","i2iID":1999,"FirstName":"test","LastName":"test","Company":"THE TEST COMPANY","Address":"127 STREET","City":"TEST","State":"MA","zip":11111,"Email":"","Title":"","LeadSource":"","SICCode":"","SFDCContactID":"","SFDCParentLeadID":"","CouponCode":"1999","MailDate":"2/10/2014 12:00:00 AM","PromoCode":"1999","Offer":"","i2iContactId":""}]';        
        res.setBody(resbody);        



        res.setStatusCode(200);
        
        system.debug('..... res:' + res);
        
        return res;
        
        //body example from i2i
        /*
        [{"ReturnDescription":"Success","i2iID":3520411,"FirstName":"JAMES","LastName":"R BEARD","Company":"THE BEARD CONCRETE COMPANY","Address":"127 BOSTON POST ROAD","City":"MILFORD","State":"CT","zip":6460.0,"Email":"","Title":"","LeadSource":"","SICCode":"","SFDCContactID":"","SFDCParentLeadID":"","CouponCode":"F33","MailDate":"2/10/2014 12:00:00 AM","PromoCode":"F33-03520411","Offer":"","i2iContactId":3441182}
        ,{"ReturnDescription":"Success","i2iID":3520411,"FirstName":"JAMES","LastName":"R BEARD","Company":"THE BEARD CONCRETE COMPANY","Address":"127 BOSTON POST ROAD","City":"MILFORD","State":"CT","zip":6460.0,"Email":"","Title":"","LeadSource":"","SICCode":"","SFDCContactID":"","SFDCParentLeadID":"","CouponCode":"G2D","MailDate":"1/6/2014 12:00:00 AM","PromoCode":"G2D-03520411","Offer":"","i2iContactId":3441182}
        ,{"ReturnDescription":"Success","i2iID":22836164,"FirstName":"JAMES","LastName":"RANDY MARTIN","Company":"THE BEAVER EXCAVATING CO","Address":"2000 BEAVER PLACE AVE SW","City":"CANTON","State":"OH","zip":44706.0,"Email":"","Title":"","LeadSource":"","SICCode":"","SFDCContactID":"","SFDCParentLeadID":"","CouponCode":"M3P","MailDate":"12/5/2013 12:00:00 AM","PromoCode":"M3P-22836164","Offer":"","i2iContactId":19328510}
        ,{"ReturnDescription":"Success","i2iID":22836164,"FirstName":"JAMES","LastName":"RANDY MARTIN","Company":"THE BEAVER EXCAVATING CO","Address":"2000 BEAVER PLACE AVE SW","City":"CANTON","State":"OH","zip":44706.0,"Email":"","Title":"","LeadSource":"","SICCode":"","SFDCContactID":"","SFDCParentLeadID":"","CouponCode":"J2D","MailDate":"1/14/2014 12:00:00 AM","PromoCode":"J2D-22836164","Offer":"","i2iContactId":19328510}
        ,{"ReturnDescription":"Success","i2iID":3520411,"FirstName":"JAMES","LastName":"R BEARD","Company":"THE BEARD CONCRETE COMPANY","Address":"127 BOSTON POST ROAD","City":"MILFORD","State":"CT","zip":6460.0,"Email":"","Title":"","LeadSource":"","SICCode":"","SFDCContactID":"","SFDCParentLeadID":"","CouponCode":"W37","MailDate":"12/16/2013 12:00:00 AM","PromoCode":"W37-03520411","Offer":"","i2iContactId":3441182}]
        */
        
        
        
    }
    
}