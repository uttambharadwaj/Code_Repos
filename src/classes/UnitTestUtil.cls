//A class to help with performing webservice method tests as SF doesn't allow @test on these
public class UnitTestUtil {  
    private static UnitTestUtil oUnitTestUtil;

    public boolean IsUnitTesting {get;set;}
    public TG_XmlNode MockResponse {get;set;}

    private UnitTestUtil() {
        IsUnitTesting = false;
        MockResponse = null;
    }

    public static UnitTestUtil getInstance() {
        if (oUnitTestUtil == null) {
            oUnitTestUtil = new UnitTestUtil();
        }

        return oUnitTestUtil;
    }

   
}