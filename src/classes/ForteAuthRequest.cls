public class ForteAuthRequest {
	public Double authorization_amount;
	public echeck echeck;
	public String action;
	public class echeck {
		public String routing_number;
		public String account_number;
	}

	public static ForteAuthRequest deserialize(String json) {
		return(ForteAuthRequest) System.JSON.deserialize(json, ForteAuthRequest.class);
	}

	public static String serialize(ForteAuthRequest obj) {
		return System.JSON.serialize(obj, true);
	}
}