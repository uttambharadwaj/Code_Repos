/**
 * Always returns the given HttpResponse given to constructor.
 */
@isTest
public with sharing class GenericHttpCalloutMockImpl implements HttpCalloutMock {

    private HttpResponse response { get; set; }

    public GenericHttpCalloutMockImpl( HttpResponse response ) {
        this.response = response;
    }

    public HttpResponse respond( HttpRequest request ) {
        return this.response;
    }

}