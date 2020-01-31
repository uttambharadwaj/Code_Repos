/**
 * Created by jharrell on 1/28/20.
 */

public class WebDAMConnectorAuthResponse {

    public String access_token;
    public String token_type;
    public String refresh_token;

    public List<Items> items;

    public class Items {
        public String id;
        public String status;
        public String name;
        public String filesize;
        public String filename;
        public String filetype;
        public String description;
        public String version;
        public Folder folder;
    }

    public class Folder {
        public String name;
    }


//    public class items {
//
//    }
//    public String id;
//    public String filename;

    public static WebDAMConnectorAuthResponse parse(String json){
        return (WebDAMConnectorAuthResponse) System.JSON.deserialize(json, WebDAMConnectorAuthResponse.class);
    }

}