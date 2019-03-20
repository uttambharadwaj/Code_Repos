<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>D_B_Decision_Support_CQR</fullName>
        <field>forseva1__F_Credit_Quality_Rating__c</field>
        <formula>IF( 
forseva1__CR_SCR_CLAS__c = &quot;1&quot; &amp;&amp; 
forseva1__PAYD_SCR__c &gt;= 70 &amp;&amp; 
forseva1__TOT_PMT__c &gt;= 15 &amp;&amp; 
YEAR(TODAY()) - VALUE(forseva1__STRT_YR__c) &gt;= 3 &amp;&amp; 
forseva1__SUIT_JDGT_IND__c != &apos;Y&apos; &amp;&amp; 
forseva1__OUT_BUS_IND__c != &apos;Y&apos;, 
5, 

IF( 
forseva1__CR_SCR_CLAS__c = &quot;2&quot; &amp;&amp; 
forseva1__PAYD_SCR__c &gt;= 65 &amp;&amp; 
forseva1__TOT_PMT__c &gt;= 10 &amp;&amp; 
YEAR(TODAY()) - VALUE(forseva1__STRT_YR__c) &gt;= 3 &amp;&amp; 
forseva1__SUIT_JDGT_IND__c != &apos;Y&apos; &amp;&amp; 
forseva1__OUT_BUS_IND__c != &apos;Y&apos;, 
4, 

IF( 
forseva1__CR_SCR_CLAS__c = &quot;3&quot; &amp;&amp; 
forseva1__PAYD_SCR__c &gt;= 65 &amp;&amp; 
forseva1__TOT_PMT__c &gt;= 8 &amp;&amp; 
YEAR(TODAY()) - VALUE(forseva1__STRT_YR__c) &gt;= 2 &amp;&amp; 
forseva1__SUIT_JDGT_IND__c != &apos;Y&apos; &amp;&amp; 
forseva1__OUT_BUS_IND__c != &apos;Y&apos;, 
3, 

0)))</formula>
        <name>D&amp;B Decision Support CQR</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>D_B_Decision_Support_CQR_Desc</fullName>
        <field>forseva1__F_CQR_Description__c</field>
        <formula>IF( 
forseva1__CR_SCR_CLAS__c = &quot;1&quot; &amp;&amp; 
forseva1__PAYD_SCR__c &gt;= 70 &amp;&amp; 
forseva1__TOT_PMT__c &gt;= 15 &amp;&amp; 
YEAR(TODAY()) - VALUE(forseva1__STRT_YR__c) &gt;= 3 &amp;&amp; 
forseva1__SUIT_JDGT_IND__c != &apos;Y&apos; &amp;&amp; 
forseva1__OUT_BUS_IND__c != &apos;Y&apos;, 
&quot;High Credit Awarded&quot;, 

IF( 
forseva1__CR_SCR_CLAS__c = &quot;2&quot; &amp;&amp; 
forseva1__PAYD_SCR__c &gt;= 65 &amp;&amp; 
forseva1__TOT_PMT__c &gt;= 10 &amp;&amp; 
YEAR(TODAY()) - VALUE(forseva1__STRT_YR__c) &gt;= 3 &amp;&amp; 
forseva1__SUIT_JDGT_IND__c != &apos;Y&apos; &amp;&amp; 
forseva1__OUT_BUS_IND__c != &apos;Y&apos;, 
&quot;Medium Credit Awarded&quot;, 

IF( 
forseva1__CR_SCR_CLAS__c = &quot;3&quot; &amp;&amp; 
forseva1__PAYD_SCR__c &gt;= 65 &amp;&amp; 
forseva1__TOT_PMT__c &gt;= 8 &amp;&amp; 
YEAR(TODAY()) - VALUE(forseva1__STRT_YR__c) &gt;= 2 &amp;&amp; 
forseva1__SUIT_JDGT_IND__c != &apos;Y&apos; &amp;&amp; 
forseva1__OUT_BUS_IND__c != &apos;Y&apos;, 
&quot;Low Credit Awarded&quot;, 

&quot;No Credit&quot;)))</formula>
        <name>D&amp;B Decision Support CQR Desc</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>D_B_Decision_Support_Credit_Limit</fullName>
        <field>forseva1__F_Credit_Limit_Approved__c</field>
        <formula>IF(
forseva1__CR_SCR_CLAS__c = &quot;1&quot; &amp;&amp; 
forseva1__PAYD_SCR__c &gt;= 70 &amp;&amp;
forseva1__TOT_PMT__c &gt;= 15 &amp;&amp;
YEAR(TODAY()) - VALUE(forseva1__STRT_YR__c) &gt;= 3 &amp;&amp;
forseva1__SUIT_JDGT_IND__c != &apos;Y&apos; &amp;&amp;
forseva1__OUT_BUS_IND__c != &apos;Y&apos;,
10000,

IF(
forseva1__CR_SCR_CLAS__c = &quot;2&quot; &amp;&amp; 
forseva1__PAYD_SCR__c &gt;= 65 &amp;&amp;
forseva1__TOT_PMT__c &gt;= 10 &amp;&amp;
YEAR(TODAY()) - VALUE(forseva1__STRT_YR__c) &gt;= 3 &amp;&amp;
forseva1__SUIT_JDGT_IND__c != &apos;Y&apos; &amp;&amp;
forseva1__OUT_BUS_IND__c != &apos;Y&apos;,
5000,

IF(
forseva1__CR_SCR_CLAS__c = &quot;3&quot; &amp;&amp; 
forseva1__PAYD_SCR__c &gt;= 65 &amp;&amp;
forseva1__TOT_PMT__c &gt;= 8 &amp;&amp;
YEAR(TODAY()) - VALUE(forseva1__STRT_YR__c) &gt;= 2 &amp;&amp;
forseva1__SUIT_JDGT_IND__c != &apos;Y&apos; &amp;&amp;
forseva1__OUT_BUS_IND__c != &apos;Y&apos;,
2500,

0)))</formula>
        <name>D&amp;B Decision Support Credit Limit</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>D_B_Decision_Support_Eff_Date</fullName>
        <field>forseva1__F_Credit_Limit_Effective_Date__c</field>
        <formula>today()</formula>
        <name>D&amp;B Decision Support Eff Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>D_B_Decision_Support_Exp_Date</fullName>
        <field>forseva1__F_Credit_Limit_Expiration_Date__c</field>
        <formula>today() + 365</formula>
        <name>D&amp;B Decision Support Exp Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>D_B_Decision_Support_Next_Review</fullName>
        <field>forseva1__F_Next_Credit_Review_Date__c</field>
        <formula>today() + 365</formula>
        <name>D&amp;B Decision Support Next Review</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>D_B_Decision_Support_Status</fullName>
        <field>forseva1__F_Credit_Review_Status__c</field>
        <formula>IF( 
forseva1__CR_SCR_CLAS__c = &quot;1&quot; &amp;&amp; 
forseva1__PAYD_SCR__c &gt;= 70 &amp;&amp; 
forseva1__TOT_PMT__c &gt;= 15 &amp;&amp; 
YEAR(TODAY()) - VALUE(forseva1__STRT_YR__c) &gt;= 3 &amp;&amp; 
forseva1__SUIT_JDGT_IND__c != &apos;Y&apos; &amp;&amp; 
forseva1__OUT_BUS_IND__c != &apos;Y&apos;, 
&quot;Passed&quot;, 

IF( 
forseva1__CR_SCR_CLAS__c = &quot;2&quot; &amp;&amp; 
forseva1__PAYD_SCR__c &gt;= 65 &amp;&amp; 
forseva1__TOT_PMT__c &gt;= 10 &amp;&amp; 
YEAR(TODAY()) - VALUE(forseva1__STRT_YR__c) &gt;= 3 &amp;&amp; 
forseva1__SUIT_JDGT_IND__c != &apos;Y&apos; &amp;&amp; 
forseva1__OUT_BUS_IND__c != &apos;Y&apos;, 
&quot;Passed&quot;, 

IF( 
forseva1__CR_SCR_CLAS__c = &quot;3&quot; &amp;&amp; 
forseva1__PAYD_SCR__c &gt;= 65 &amp;&amp; 
forseva1__TOT_PMT__c &gt;= 8 &amp;&amp; 
YEAR(TODAY()) - VALUE(forseva1__STRT_YR__c) &gt;= 2 &amp;&amp; 
forseva1__SUIT_JDGT_IND__c != &apos;Y&apos; &amp;&amp; 
forseva1__OUT_BUS_IND__c != &apos;Y&apos;, 
&quot;Passed&quot;, 

&quot;Failed&quot;)))</formula>
        <name>D&amp;B Decision Support Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
</Workflow>
