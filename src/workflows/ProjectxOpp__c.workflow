<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <rules>
        <fullName>ProjectxOpp Created %2F Edited</fullName>
        <active>false</active>
        <formula>/* workflow first created to trigger Opportunity FSR field update and I needed to enter something as criteria */

Opportunity__r.Net_Full_Service_Revenue__c &gt; 0</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
