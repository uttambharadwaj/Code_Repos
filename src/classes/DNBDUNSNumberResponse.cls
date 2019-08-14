public class DNBDUNSNumberResponse {
    public MatchResponse MatchResponse;

    public class MatchResponse {
        public MatchResponseDetail MatchResponseDetail;
    }

    public class MatchCandidate {
        public String DUNSNumber;
    }

    public class MatchResponseDetail {
        public List<MatchCandidate> MatchCandidate;
    }

    public static DNBDUNSNumberResponse parse(String json) {
        return (DNBDUNSNumberResponse) System.JSON.deserialize(json, DNBDUNSNumberResponse.class);
    }
}