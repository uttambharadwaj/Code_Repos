/**
 * Created by lhowland on 5/04/2018.
 */

@isTest public with sharing class JaroWinklerDistanceTest {

    static testmethod void testOneStringPair()
    {
        test.startTest();

        List<JaroWinklerDistance.StringPair> stringPairs = new List<JaroWinklerDistance.StringPair>();
        JaroWinklerDistance.StringPair pair1 = new JaroWinklerDistance.StringPair();
        pair1.strToCompare1 = 'TestString';
        pair1.strToCompare2 = 'TestStrign';
        stringPairs.add(pair1);

        Double jwScore = JaroWinklerDistance.getAverageScoreOfList(stringPairs);
        System.assertEquals(0.9666666666666667,jwScore);

        test.stopTest();
    }

    static testmethod void testMultipleStringPairs()
    {
        test.startTest();

        List<JaroWinklerDistance.StringPair> stringPairs = new List<JaroWinklerDistance.StringPair>();
        JaroWinklerDistance.StringPair pair1 = new JaroWinklerDistance.StringPair();
        pair1.strToCompare1 = 'TestString';
        pair1.strToCompare2 = 'TestStrign';
        stringPairs.add(pair1);

        JaroWinklerDistance.StringPair pair2 = new JaroWinklerDistance.StringPair();
        pair2.strToCompare1 = 'TestPizza';
        pair2.strToCompare2 = 'TestDoughnut';
        stringPairs.add(pair2);

        Double jwScore = JaroWinklerDistance.getAverageScoreOfList(stringPairs);
        System.assertEquals(0.7796296296296297,jwScore); // averageScore = (0.9666666666666667 + 0.5925925925925926) / 2

        test.stopTest();
    }

    static testmethod void testNullStringPair()
    {
        test.startTest();

        List<JaroWinklerDistance.StringPair> stringPairs = new List<JaroWinklerDistance.StringPair>();
        JaroWinklerDistance.StringPair pair1 = new JaroWinklerDistance.StringPair();
        pair1.strToCompare1 = 'TestString';
        pair1.strToCompare2 = null;
        stringPairs.add(pair1);

        Double jwScore = JaroWinklerDistance.getAverageScoreOfList(stringPairs);
        System.assertEquals(0.0,jwScore);

        test.stopTest();
    }

    static testmethod void testDuplicateStringPair()
    {
        test.startTest();

        List<JaroWinklerDistance.StringPair> stringPairs = new List<JaroWinklerDistance.StringPair>();
        JaroWinklerDistance.StringPair pair1 = new JaroWinklerDistance.StringPair();
        pair1.strToCompare1 = 'TestString';
        pair1.strToCompare2 = 'TestString';
        stringPairs.add(pair1);

        Double jwScore = JaroWinklerDistance.getAverageScoreOfList(stringPairs);
        System.assertEquals(1.0,jwScore);

        test.stopTest();
    }

    static testmethod void testDuplicateStringPairOneWithExtraSpaces()
    {
        test.startTest();

        List<JaroWinklerDistance.StringPair> stringPairs = new List<JaroWinklerDistance.StringPair>();
        JaroWinklerDistance.StringPair pair1 = new JaroWinklerDistance.StringPair();
        pair1.strToCompare1 = 'TestString';
        pair1.strToCompare2 = 'TestString   ';
        stringPairs.add(pair1);

        Double jwScore = JaroWinklerDistance.getAverageScoreOfList(stringPairs);
        System.assertEquals(1.0,jwScore);

        test.stopTest();
    }

}