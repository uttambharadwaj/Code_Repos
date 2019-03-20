public class ForteAuthResponse {
	public echeck echeck;
	public Double authorization_amount;
	public String action;
	public String location_id;
	public response response;
	public String transaction_id;
	public class response {
		public String environment;
		public String response_type;
		public String authorization_code;
		public String preauth_result;
		public String response_desc;
		public String preauth_desc;
		public String response_code;
	}
	public class echeck {
		public String masked_account_number;
		public String routing_number;
	}

	public static ForteAuthResponse deserialize(String json) {
		return(ForteAuthResponse) System.JSON.deserialize(json, ForteAuthResponse.class);
	}

	public static String serialize(ForteAuthResponse obj) {
		return System.JSON.serialize(obj, true);
	}
}