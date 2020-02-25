/*
 * Description: Test Multicallouts
 */
@isTest
public class i2iGetMC_CalloutTest {
    public class TestMockException extends Exception {}
    
    public class TestMock implements HttpCalloutMock {
        private Integer statusCode;
        private String body;
        Map<String, String> headers; 
        
        public TestMock(Integer statusCode, String body, Map<String, String> headers) {
            this.statusCode = statusCode;
            this.body = body;
            this.headers = headers;
        }
        
        public HttpResponse respond (HttpRequest req) {
            HttpResponse res = new HttpResponse();
            for(String key : headers.keySet()) {
            	res.setHeader(key, headers.get(key));                
            }
            res.setBody(body);
            res.setStatusCode(statusCode);
            return res;
        }
    }
    
    public class MultiRequestMock implements HttpCalloutMock {
        private Map<String, HttpCalloutMock> requests;
        
        public MultiRequestMock(Map<String, HttpCalloutMock> requests) {
            this.requests = requests;
        }
        
        public HttpResponse respond(HttpRequest req) {
            String endpoints;
            for(String endpoint : requests.keySet()){
            	endpoints = endpoint;    
            }
            req.setEndpoint(endpoints);
            HttpCalloutMock mock = requests.get(req.getEndpoint());
            if (mock != null) {
                return mock.respond(req);
            } else {
                throw new TestMockException('No mock found for ' + req.getEndpoint());
            }
        } 
    }
}