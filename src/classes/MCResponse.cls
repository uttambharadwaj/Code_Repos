public class MCResponse {

    public String access_token;
    public String token_type;
    public List<Responses> responses;
    public String requestId;
    public class Responses {
        public String recipientSendId;
        public Boolean hasErrors;
        public List<String> messages;
    }

    public static MCResponse parse(String json) {
        return (MCResponse) System.JSON.deserialize(json, MCResponse.class);
    }

}
