/**
 * Created by lhowland on 4/20/2018.
 */

public with sharing class JaroWinklerDistance {

    public static final Double DEFAULT_THRESHOLD = 0.7;


    public static Double getAverageScoreOfList(List<StringPair> stringPairs) {

        List<Double> jwScores = new List<Double>();
        Double averageScore = 0.0;

        for (StringPair stringPair : stringPairs) {
            Double jwScore = getScore(stringPair.strToCompare1, stringPair.strToCompare2);
            jwScores.add(jwScore);
        }
        System.debug(jwScores);

        for (Double jwScore : jwScores) {
            averageScore += jwScore;
            System.debug('### SCORE: ' + jwScore);
        }
        if (jwScores.size() > 0) {
            System.debug('### AVG: ' + averageScore + ' ' + jwScores.size());
            averageScore = averageScore / jwScores.size();

        }
        System.debug('Score average = ' + averageScore);
        return averageScore;
    }

    /**
     * Finds the Jaro Winkler Distance to score the similarity between two Strings.
     * Returns a value in the interval [0.0, 1.0].
     */
    public static Double getScore(String string1, String string2) {

        if (string1 == null || string2 == null) {
            System.debug('One of the Strings are null: string1 = ' + string1 + ', string2 = ' + string2);
            return 0.0;
        }

        string1 = string1.trim();
        string2 = string2.trim();

        // they are an identical match - no need to get all fancy
        if (string1.equalsIgnoreCase(string2)) {
            System.debug('The Strings are equal: string1 = ' + string1 + ', string2 = ' + string2);
            return 1.0;
        }

        // mtp = matches/transpositions/prefix
        final Integer[] mtp = matches(string1, string2);
        final Double matchedChars = mtp[0];
        if (matchedChars == 0) { return 0.0; }

        // calculate the jaro distance (defined in terms of the number of matching characters and the number of transpositions)
        final Double j = ((matchedChars / string1.length() + matchedChars / string2.length() + (matchedChars - mtp[1]) / matchedChars)) / 3;

        // calculate the jaro score using the jaro distance
        final Double jwScore = j < DEFAULT_THRESHOLD ? j : j + Math.min(0.1, 1 / mtp[3]) * mtp[2] * (1 - j);

        System.debug('Jaro Winkler Score for "' + string1 + '" and "' + string2 + '" = ' + jwscore);
        return jwScore;
    }

    private static String getCharAtIndex(String str, integer index) {

        String[] stringArray = str.split('');
        return stringArray[index];
    }

    private static Integer[] matches (String string1, String string2) {

        String max, min;
        if (string1.length() > string2.length()) {
            max = string1;
            min = string2;
        } else {
            max = string2;
            min = string1;
        }

        final Integer matchRange = Math.max(max.length() / 2 - 1, 0);
        final Integer[] matchIndexes = new integer[min.length()];

        // Arryas.fill(matchIndexes, -1);
        for (Integer i = 0; i<matchIndexes.size(); i++) {
            matchIndexes[i] = -1;
        }

        final Boolean[] matchFlags = new Boolean[max.length()];
        // set default values
        for (Integer i = 0; i < matchFlags.size(); i++) {
            matchFlags[i] = false;
        }

        // find how many matching letters there are
        Integer matches = 0;
        for (Integer mi = 0; mi < min.length(); mi++) {
            final String c1 = getCharAtIndex(min, mi);
            for (Integer xi = Math.max(mi - matchRange, 0), xn = Math.min(mi + matchRange + 1, max.length()); xi < xn; xi++) {
                if (!matchFlags[xi] && c1 == getCharAtIndex(max, xi)) {
                    matchIndexes[mi] = xi;
                    matchFlags[xi] = true;
                    matches++;
                    break;
                }
            }
        }

        final String[] matchStr1 = new String[matches];
        final String[] matchStr2 = new String[matches];
        for (Integer i = 0, si = 0; i < min.length(); i++) {
            if (matchIndexes[i] != -1) {
                matchStr1[si] = getCharAtIndex(min, i);
                si++;
            }
        }

        for (Integer i = 0, si = 0; i < max.length(); i++) {
            if (matchFlags[i]) {
                matchStr2[si] = getCharAtIndex(max, i);
                si++;
            }
        }

        // After matching, the subsequence of characters actually matched in both strings is extracted.
        Integer transpositions = 0;
        for (Integer mi = 0; mi < matchStr1.size(); mi++) {
            if (matchStr1[mi] != matchStr2[mi]) {
                transpositions++;
            }
        }

        Integer prefix = 0;
        for (integer mi = 0; mi < min.length(); mi++) {
            if (getCharAtIndex(string1, mi) == getCharAtIndex(string2, mi)) {
                prefix++;
            } else {
                break;
            }
        }
        
        return new Integer[] {matches, transpositions / 2, prefix, max.length()};
    }

    public class StringPair {

        public String strToCompare1 { get; set; }
        public String strToCompare2 { get; set; }

        public StringPair() {

        }

        public StringPair(String strToCompare1, String strToCompare2) {

            this.strToCompare1 = strToCompare1;
            this.strToCompare2 = strToCompare2;

        }

    }
}