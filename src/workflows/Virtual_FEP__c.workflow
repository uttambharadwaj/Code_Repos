<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>AP_File_Due</fullName>
        <description>AP File Due</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Virtual_Templates/AP_File_Due</template>
    </alerts>
    <alerts>
        <fullName>Contract_Expiry_in_30_Days</fullName>
        <description>Contract Expiry in 30 Days</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Virtual_EU_Templates/CorporatePay_Contract_Expiry_30_Days</template>
    </alerts>
    <alerts>
        <fullName>Contract_Expiry_in_60_Days</fullName>
        <description>Contract Expiry in 60 Days</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Virtual_EU_Templates/CorporatePay_Contract_Expiry_60_Days</template>
    </alerts>
    <alerts>
        <fullName>Contract_Expiry_in_90_Days</fullName>
        <description>Contract Expiry in 90 Days</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Virtual_EU_Templates/CorporatePay_Contract_Expiry_90_Days</template>
    </alerts>
    <alerts>
        <fullName>Start_Of_Fiscal_Year</fullName>
        <description>Start Of Fiscal Year</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Virtual_EU_Templates/Start_Of_Fiscal_Year_Alert</template>
    </alerts>
    <rules>
        <fullName>New FEP</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Virtual_FEP__c.CreatedDate</field>
            <operation>equals</operation>
            <value>TODAY</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
