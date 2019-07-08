public class CreditWSUtil_LexisNexisIID{

    // Request Class Definitions
    public String Type_x { get; set; }	//Initiate

    public cls_Settings Settings { get; set; }

    public cls_Persons[] Persons { get; set; }

    public class cls_Settings {
        public String Mode;	//testing
        public String Reference;	//REST_Transaction
        public String Locale;	//en_US
        public String Venue;	//online
    }

    public class cls_Persons {
        public cls_Name Name;
        public cls_Addresses[] Addresses;
        public cls_SSN SSN;
        public cls_DateOfBirth DateOfBirth;
        public cls_Phones[] Phones;
        public String Context;	//primary
    }

    public class cls_Name {
        public String FirstName;	//John
        public String LastName;	//Doe
    }

    public class cls_Addresses {
        public String StreetAddress1;	//413 StreetName Ct
        public String City;	//CityName
        public String State;	//MD
        public String Zip5;	//21158
        public String Country;	//US
        public String Context;	//primary
    }

    public class cls_SSN {
        public String Number_x;	//21790####
        public String Type_x;	//ssn9
    }

    public class cls_DateOfBirth {
        public String Year;	//1966
        public String Month;	//9
        public String Day;	//5
    }

    public class cls_Phones {
        public String Number_x;	//5615555555
        public String Context;	//mobile
    }

    // Response Class Definitions
    public cls_Status Status { get; set; }

    public cls_Products[] Products { get; set; }

    public class cls_Status {
        public String ConversationId;	//31000001697452
        public String RequestId;	//3802402
        public String TransactionStatus;	//passed
        public String Reference;	//REST_Transaction
        public String ServerInfo;	//server.domain.domain.net
    }

    public class cls_Products {
        public String ProductType;	//InstantID
        public String ExecutedStepName;	//INSTANT_ID_STEP
        public String ProductConfigurationName;	//InstantID_NewPassThrough
        public String ProductStatus;	//pass
        public cls_ParameterDetails[] ParameterDetails;
    }

    public class cls_ParameterDetails {
        public String Group_x;	//INSTANT_ID
        public String Name;	//LexID
        public cls_Values[] Values;
    }

    public class cls_Values {
        public String Value;	//374820893
    }

    public static CreditWSUtil_LexisNexisIID parse(String json){
        return (CreditWSUtil_LexisNexisIID) System.JSON.deserialize(json, CreditWSUtil_LexisNexisIID.class);
    }

}