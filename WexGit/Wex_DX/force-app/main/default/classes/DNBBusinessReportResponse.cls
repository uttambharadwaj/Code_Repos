public class DNBBusinessReportResponse {

	public class OrderCompanyReportResponse {
		public TransactionResult TransactionResult;
		public OrderCompanyReportResponseDetail OrderCompanyReportResponseDetail;
	}

	public class TransactionResult {
		public String SeverityText;
		public String ResultID;
		public String ResultText;
	}

	public class OrderCompanyReportResponseDetail {
		public Product Product;
	}

	public OrderCompanyReportResponse OrderCompanyReportResponse;

	public class ObjectAttachment {
		public String ContentObject;
	}

	public class Product {
		public List<ObjectAttachment> ObjectAttachment;
	}
	
	public static DNBBusinessReportResponse parse(String json) {
		return (DNBBusinessReportResponse) System.JSON.deserialize(json, DNBBusinessReportResponse.class);
	}
}