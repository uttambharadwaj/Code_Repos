public class CompaniesHouseResponse {

    public class Registered_office_address {

        public String address_line_1;
        public String address_line_2;
        public String locality;
        public String region;
        public String postal_code;
    }

    public String company_number;
    public String company_name;
    public Registered_office_address registered_office_address;


    public static CompaniesHouseResponse parse(String json) {
        return (CompaniesHouseResponse) System.JSON.deserialize(json, CompaniesHouseResponse.class);
    }
}