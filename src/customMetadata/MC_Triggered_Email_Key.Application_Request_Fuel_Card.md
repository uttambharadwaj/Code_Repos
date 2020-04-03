<?xml version="1.0" encoding="UTF-8"?>
<CustomMetadata xmlns="http://soap.sforce.com/2006/04/metadata" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
    <label>Application Request - Fuel Card</label>
    <protected>false</protected>
    <values>
        <field>Active__c</field>
        <value xsi:nil="true"/>
    </values>
    <values>
        <field>ContactType__c</field>
        <value xsi:nil="true"/>
    </values>
    <values>
        <field>EmailAddress__c</field>
        <value xsi:type="xsd:string">App_Signer__r.Email</value>
    </values>
    <values>
        <field>FirstName__c</field>
        <value xsi:type="xsd:string">App_Signer__r.FirstName</value>
    </values>
    <values>
        <field>Online__c</field>
        <value xsi:nil="true"/>
    </values>
    <values>
        <field>OpportunityID__c</field>
        <value xsi:type="xsd:string">Opportunity__c</value>
    </values>
    <values>
        <field>OwnerID__c</field>
        <value xsi:type="xsd:string">ownerid</value>
    </values>
    <values>
        <field>RecordType__c</field>
        <value xsi:type="xsd:string">Application_Fuel_Card</value>
    </values>
    <values>
        <field>RepName__c</field>
        <value xsi:nil="true"/>
    </values>
    <values>
        <field>Required_Fields__c</field>
        <value xsi:type="xsd:string">SFProgramId,applicationRequestID,FirstName,OpportunityID</value>
    </values>
    <values>
        <field>SFProgramId__c</field>
        <value xsi:type="xsd:string">Opportunity__r.Campaign_Program__r.Program__c</value>
    </values>
    <values>
        <field>applicationRequestID__c</field>
        <value xsi:nil="true"/>
    </values>
    <values>
        <field>createddate__c</field>
        <value xsi:type="xsd:string">createddate</value>
    </values>
</CustomMetadata>
