@isTest
public class MockServiceGenerator implements WebServiceMock{

    public String myRequest;

    public MockServiceGenerator(String myParam){
        this.myRequest = myParam;
    }

    public void doInvoke(Object stub, Object request, Map<String, Object> response, String endpoint, String soapAction, String requestName, String responseNS, String responseName, String responseType){
        MockServiceRequest msr = new MockServiceRequest(stub, request, response, endpoint, soapAction, requestName, responseNS, responseName, responseType);
        msr.invokeThis(myRequest);
    }

    public class MockServiceRequest {
        protected Object stub;
        protected Object request;
        protected Map<String, Object> response;
        protected String endpoint;
        protected String soapAction;
        protected String requestName;
        protected String responseNS;
        protected String responseName;
        protected String responseType;

        public MockServiceRequest(Object stub, Object request, Map<String, Object> response, String endpoint, String soapAction, String requestName, String responseNS, String responseName, String responseType){
            this.stub = stub;
            this.request = request;
            this.response = response;
            this.endpoint = endpoint;
            this.soapAction = soapAction;
            this.requestName = requestName;
            this.responseNS = responseNS;
            this.responseName = responseName;
            this.responseType = responseType;
        }

        public void invokeThis(String myRequest){
            switch on myRequest{
                when 'WSS2_good'{
                    processWSS2(true);
                }
                when 'WSS2_bad'{
                    processWSS2(false);
                    throw new CustomException('IO Exception: Read timed out');   
                }
            }
        }

        private void processWSS2(Boolean result){
            WS_WSS2_CreditDecisionService.UpdateApplicationStatusResponse_element myResponseElement = new WS_WSS2_CreditDecisionService.UpdateApplicationStatusResponse_element();
            
            WS_WSS2_CreditDecisionService.UpdateApplicationStatusResponse myResponse = new WS_WSS2_CreditDecisionService.UpdateApplicationStatusResponse();
            myResponse.Result = result;
            myResponse.DataObject = new WS_WSS2_CreditDecisionService.ArrayOfError();

            myResponseElement.UpdateApplicationStatusResult = myResponse;
            response.put('response_x', myResponseElement);
        }


    }

    public class CustomException extends Exception {}
}