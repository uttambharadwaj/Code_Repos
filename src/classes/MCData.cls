
public class MCData {

    public String subscriberKey;
    public String toAddress;
    Public Map<String, Object> subscriberAttributes;

    public String generateJSON() {

        RootObject objJSONRoot = new RootObject();

        To objLocation = new To();
        objLocation.address = toAddress;
        objLocation.subscriberKey = subscriberKey;

        ContactAttributes ca = new ContactAttributes();
        ca.SubscriberAttributes = subscriberAttributes;

        objLocation.ContactAttributes = ca;
        objJSONRoot.To = objLocation;

        return JSON.serialize(objJSONRoot);
    }


    public class To {
        public String address { get; set; }
        public String subscriberKey { get; set; }
        public ContactAttributes ContactAttributes { get; set; }
    }

    public class RootObject {
        public To To { get; set; }
    }

    public class ContactAttributes {
        public Map<String, Object> SubscriberAttributes;
    }
}