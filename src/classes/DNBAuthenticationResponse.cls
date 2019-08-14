public class DNBAuthenticationResponse {

   	public AuthenticationDetail AuthenticationDetail;
    
	public class AuthenticationDetail {
		public String Token;
	}
	
	public static DNBAuthenticationResponse parse(String json) {
		return (DNBAuthenticationResponse) System.JSON.deserialize(json, DNBAuthenticationResponse.class);
	}
}