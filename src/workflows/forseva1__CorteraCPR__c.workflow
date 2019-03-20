<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Credit_Limit_Effective_Date_Today</fullName>
        <field>forseva1__F_Credit_Limit_Effective_Date__c</field>
        <formula>Today ()</formula>
        <name>Credit Limit Effective Date = Today</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Credit_Quality_Rating</fullName>
        <field>forseva1__F_Credit_Quality_Rating__c</field>
        <formula>(

(IF(VALUE(forseva1__YearStarted__c)  &gt; 2010, 0,
IF(VALUE(forseva1__YearStarted__c) &gt; 2007, 2,
IF(VALUE(forseva1__YearStarted__c) &gt; 2004, 5,
IF(VALUE(forseva1__YearStarted__c) &gt;=  2001, 7,
IF(VALUE(forseva1__YearStarted__c) &lt; 2001, 10, 0))))) * 0.20)
+
(IF(forseva1__CprIndexRating__c &gt; 750, 10,
IF(forseva1__CprIndexRating__c &gt; 600, 8,
IF(forseva1__CprIndexRating__c &gt; 450, 4,
IF(forseva1__CprIndexRating__c &gt; 300, 2, 
IF(forseva1__CprIndexRating__c &gt; 0, 0, 0))))) * 0.55)
+
(IF(forseva1__CprReportLiensCount__c   =  0, 10,
IF(forseva1__CprReportLiensCount__c &gt; 0, 0, 0)) * 0.10)
+
(IF( forseva1__CprReportTradeLinesCount__c  &gt; 20, 10,
IF(forseva1__CprReportTradeLinesCount__c &gt; 16, 7,
IF(forseva1__CprReportTradeLinesCount__c &gt; 11, 5,
IF(forseva1__CprReportTradeLinesCount__c &gt; 6, 2,
IF(forseva1__CprReportTradeLinesCount__c &gt;= 0, 0, 0))))) * 0.15)

)
+
CASE( forseva1__CprIndexTrend__c, &apos;X&apos;, -1, &apos;Y&apos;, -2, &apos;Z&apos;, -3, 0)</formula>
        <name>Credit Quality Rating</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Credit_Review_Date_Today</fullName>
        <field>forseva1__F_Credit_Review_Date__c</field>
        <formula>Today ()</formula>
        <name>Credit Review Date = Today</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Review_Status_Passed</fullName>
        <field>forseva1__F_Credit_Review_Status__c</field>
        <formula>&quot;Passed&quot;</formula>
        <name>Review Status = Passed</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Verify_Bankruptcy_Comments</fullName>
        <field>forseva1__F_Verification_Comments__c</field>
        <formula>&quot;Bankruptcy reported in Cortera CPR&quot;</formula>
        <name>Verify Bankruptcy Comments</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Verify_Date_Today</fullName>
        <field>forseva1__F_Verification_Date__c</field>
        <formula>Today ()</formula>
        <name>Verify Date = Today</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Verify_Failed</fullName>
        <field>forseva1__F_Verification_Status__c</field>
        <formula>&quot;Failed&quot;</formula>
        <name>Verify Failed</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Verify_Status_Passed</fullName>
        <field>forseva1__F_Verification_Status__c</field>
        <formula>&quot;Passed&quot;</formula>
        <name>Verify Status Passed</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
</Workflow>
