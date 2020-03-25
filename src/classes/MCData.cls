
public class MCData {

    public String subscriberKey;
    public String toAddress;
    Public Map<String, Object> subscriberAttributes;

    public String generateJSON() {

        RootObject rootObj = new RootObject();

        To toObj = new To();
        toObj.address = toAddress;
        toObj.subscriberKey = subscriberKey;

        ContactAttributes ca = new ContactAttributes();
        ca.SubscriberAttributes = subscriberAttributes;

        toObj.ContactAttributes = ca;

        Options opts = new Options();
        opts.RequestType = 'SYNC';

        rootObj.Options = opts;
        rootObj.To = toObj;

        return JSON.serialize(rootObj);
    }


    public class To {
        public String address { get; set; }
        public String subscriberKey { get; set; }
        public ContactAttributes ContactAttributes { get; set; }
    }

    public class RootObject {
        public To To { get; set; }
        public Options Options { get; set; }
    }

    public class Options {
        public String RequestType { get; set; }
    }
    public class ContactAttributes {
        public Map<String, Object> SubscriberAttributes;
    }
}