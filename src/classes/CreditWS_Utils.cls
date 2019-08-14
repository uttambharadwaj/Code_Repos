/**
 * Created by dgilbert on 10/18/2018.
 */

public with sharing class CreditWS_Utils {

    public static String buildHTTPCalloutParameterString(Map<String, String> parameters) {

        List<String> joinedParameters = new List<String>();

        for(String key : parameters.keySet()) {

            if(parameters.get(key) != null) {

                joinedParameters.add(key + '=' + EncodingUtil.urlEncode(parameters.get(key), 'UTF-8'));

            }

        }

        return String.join(joinedParameters, '&');

    }

}