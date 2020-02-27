@IsTest
public with sharing class FleetAccountMaintenanceWS_Main_Mock implements HttpCalloutMock {


    public HttpResponse respond(HttpRequest param1) {
        // Create a fake response
        HttpResponse res = new HttpResponse();
        return res;
    }
}