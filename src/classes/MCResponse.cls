public class MCResponse {

    public String access_token;
    public String token_type;


    public static MCResponse parse(String json) {
        return (MCResponse) System.JSON.deserialize(json, MCResponse.class);
    }

}
