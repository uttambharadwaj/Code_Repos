<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>AU_MVF_Intro_Email</fullName>
        <description>AU MVF Intro Email</description>
        <protected>false</protected>
        <recipients>
            <field>Email</field>
            <type>email</type>
        </recipients>
        <senderAddress>sales@wexaustralia.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>AU_Email_Templates/AU_MVF_Right_prom</template>
    </alerts>
    <fieldUpdates>
        <fullName>AURecType</fullName>
        <description>Changes the record type to AU Fuel</description>
        <field>RecordTypeId</field>
        <lookupValue>AU_Fuel</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>AURecType</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Lead_Status_to_Working</fullName>
        <field>Status</field>
        <literalValue>Working</literalValue>
        <name>Set Lead Status to Working</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Tag_Partner_123Loadboard</fullName>
        <field>Created_by_Partner_Tag__c</field>
        <formula>&quot;123Loadboard&quot;</formula>
        <name>Tag Partner 123Loadboard</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Tag_Partner_ASSIST_FINANCIAL_SERVICES</fullName>
        <field>Created_by_Partner_Tag__c</field>
        <formula>&quot;ASSIST FINANCIAL SERVICES&quot;</formula>
        <name>Tag Partner ASSIST FINANCIAL SERVICES</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Tag_Partner_Advanced_Commercial_Credit</fullName>
        <field>Created_by_Partner_Tag__c</field>
        <formula>&quot;Advanced Commercial Credit&quot;</formula>
        <name>Tag Partner Advanced Commercial Credit</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Tag_Partner_Aladdin_Financial</fullName>
        <field>Created_by_Partner_Tag__c</field>
        <formula>&quot;Aladdin Financial&quot;</formula>
        <name>Tag Partner Aladdin Financial</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Tag_Partner_CJM_Financial</fullName>
        <field>Created_by_Partner_Tag__c</field>
        <formula>&quot;CJM Financial&quot;</formula>
        <name>Tag Partner CJM Financial</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Tag_Partner_Century</fullName>
        <field>Created_by_Partner_Tag__c</field>
        <formula>&quot;Century&quot;</formula>
        <name>Tag Partner Century</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Tag_Partner_Commercial_Funding</fullName>
        <field>Created_by_Partner_Tag__c</field>
        <formula>&quot;Commercial Funding&quot;</formula>
        <name>Tag Partner Commercial Funding</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Tag_Partner_CoreFund_Capital</fullName>
        <field>Created_by_Partner_Tag__c</field>
        <formula>&quot;CoreFund Capital&quot;</formula>
        <name>Tag Partner CoreFund Capital</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Tag_Partner_DAT</fullName>
        <field>Created_by_Partner_Tag__c</field>
        <formula>&quot;DAT&quot;</formula>
        <name>Tag Partner DAT</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Tag_Partner_ECAPITAL</fullName>
        <field>Created_by_Partner_Tag__c</field>
        <formula>&quot;ECAPITAL&quot;</formula>
        <name>Tag Partner ECAPITAL</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Tag_Partner_ENGS_Commercial_Capital</fullName>
        <description>Populate the &quot;Created by Partner Tag&quot; text field with the name &quot;ENGS Commercial Capital&quot;</description>
        <field>Created_by_Partner_Tag__c</field>
        <formula>&quot;ENGS Commercial Capital&quot;</formula>
        <name>Tag Partner ENGS Commercial Capital</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Tag_Partner_Envio_360</fullName>
        <field>Created_by_Partner_Tag__c</field>
        <formula>&quot;Envio 360&quot;</formula>
        <name>Tag Partner Envio 360</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Tag_Partner_Express_Freight_Finance</fullName>
        <field>Created_by_Partner_Tag__c</field>
        <formula>&quot;Express Freight Finance&quot;</formula>
        <name>Tag Partner Express Freight Finance</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Tag_Partner_Far_West_Capital</fullName>
        <field>Created_by_Partner_Tag__c</field>
        <formula>&quot;Far West Capital&quot;</formula>
        <name>Tag Partner Far West Capital</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Tag_Partner_FedEx_Custom_Critical</fullName>
        <field>Created_by_Partner_Tag__c</field>
        <formula>&quot;FedEx Custom Critical&quot;</formula>
        <name>Tag Partner FedEx Custom Critical</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Tag_Partner_Financial_Carrier_Service</fullName>
        <field>Created_by_Partner_Tag__c</field>
        <formula>&quot;Financial Carrier Service&quot;</formula>
        <name>Tag Partner Financial Carrier Service</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Tag_Partner_Foley_Carrier_Services</fullName>
        <field>Created_by_Partner_Tag__c</field>
        <formula>&quot;Foley Carrier Services&quot;</formula>
        <name>Tag Partner Foley Carrier Services</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Tag_Partner_Freight_Factoring_Special</fullName>
        <field>Created_by_Partner_Tag__c</field>
        <formula>&quot;Freight Factoring Special&quot;</formula>
        <name>Tag Partner Freight Factoring Special</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Tag_Partner_G_H_Factor</fullName>
        <field>Created_by_Partner_Tag__c</field>
        <formula>&quot;G.H. Factor&quot;</formula>
        <name>Tag Partner G.H. Factor</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Tag_Partner_G_SQUARED</fullName>
        <field>Created_by_Partner_Tag__c</field>
        <formula>&quot;G SQUARED&quot;</formula>
        <name>Tag Partner G SQUARED</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Tag_Partner_Great_Plains</fullName>
        <field>Created_by_Partner_Tag__c</field>
        <formula>&quot;Great Plains&quot;</formula>
        <name>Tag Partner Great Plains</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Tag_Partner_Integra</fullName>
        <field>Created_by_Partner_Tag__c</field>
        <formula>&quot;Integra&quot;</formula>
        <name>Tag Partner Integra</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Tag_Partner_Integrated_Logistics</fullName>
        <field>Created_by_Partner_Tag__c</field>
        <formula>&quot;Integrated Logistics&quot;</formula>
        <name>Tag Partner Integrated Logistics</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Tag_Partner_Interstate_Capital</fullName>
        <field>Created_by_Partner_Tag__c</field>
        <formula>&quot;Interstate Capital&quot;</formula>
        <name>Tag Partner Interstate Capital</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Tag_Partner_JB_Hunt</fullName>
        <field>Created_by_Partner_Tag__c</field>
        <formula>&quot;JB Hunt&quot;</formula>
        <name>Tag Partner JB Hunt</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Tag_Partner_JD_Factors</fullName>
        <field>Created_by_Partner_Tag__c</field>
        <formula>&quot;JD Factors&quot;</formula>
        <name>Tag Partner JD Factors</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Tag_Partner_Liquid_Capital</fullName>
        <field>Created_by_Partner_Tag__c</field>
        <formula>&quot;Liquid Capital&quot;</formula>
        <name>Tag Partner Liquid Capital</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Tag_Partner_OTR_Capital</fullName>
        <field>Created_by_Partner_Tag__c</field>
        <formula>&quot;OTR Capital&quot;</formula>
        <name>Tag Partner OTR Capital</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Tag_Partner_Parikh_Financial</fullName>
        <field>Created_by_Partner_Tag__c</field>
        <formula>&quot;Parikh Financial&quot;</formula>
        <name>Tag Partner Parikh Financial</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Tag_Partner_Partners_Funding</fullName>
        <field>Created_by_Partner_Tag__c</field>
        <formula>&quot;Partners Funding&quot;</formula>
        <name>Tag Partner Partners Funding</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Tag_Partner_Pay4Freight</fullName>
        <field>Created_by_Partner_Tag__c</field>
        <formula>&quot;Pay4Freight&quot;</formula>
        <name>Tag Partner Pay4Freight</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Tag_Partner_Petro_Solutions</fullName>
        <field>Created_by_Partner_Tag__c</field>
        <formula>&quot;Petro Solutions&quot;</formula>
        <name>Tag Partner Petro Solutions</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Tag_Partner_Quick_Pay_Funding</fullName>
        <field>Created_by_Partner_Tag__c</field>
        <formula>&quot;Quick Pay Funding&quot;</formula>
        <name>Tag Partner Quick Pay Funding</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Tag_Partner_SUMMAR</fullName>
        <description>Populate the &quot;Created by Partner Tag&quot; text field with the name &quot;SUMMAR&quot;</description>
        <field>Created_by_Partner_Tag__c</field>
        <formula>&quot;SUMMAR&quot;</formula>
        <name>Tag Partner SUMMAR</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Tag_Partner_St_Johns</fullName>
        <field>Created_by_Partner_Tag__c</field>
        <formula>&quot;St Johns&quot;</formula>
        <name>Tag Partner St Johns</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Tag_Partner_Steelhead</fullName>
        <field>Created_by_Partner_Tag__c</field>
        <formula>&quot;Steelhead&quot;</formula>
        <name>Tag Partner Steelhead</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Tag_Partner_Sunbelt</fullName>
        <field>Created_by_Partner_Tag__c</field>
        <formula>&quot;Sunbelt&quot;</formula>
        <name>Tag Partner Sunbelt</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Tag_Partner_TRANSPORT_FINANCIAL_SOLUTIO</fullName>
        <field>Created_by_Partner_Tag__c</field>
        <formula>&quot;TRANSPORT FINANCIAL SOLUTIONS&quot;</formula>
        <name>Tag Partner TRANSPORT FINANCIAL SOLUTIO</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Tag_Partner_TRIUMPH_BUSINESS_CAPITAL</fullName>
        <description>Populate the &quot;Created by Partner Tag&quot; text field with the name &quot;TRIUMPH BUSINESS CAPITAL&quot;</description>
        <field>Created_by_Partner_Tag__c</field>
        <formula>&quot;TRIUMPH BUSINESS CAPITAL&quot;</formula>
        <name>Tag Partner TRIUMPH BUSINESS CAPITAL</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Tag_Partner_Thunder_Carrier_Services</fullName>
        <field>Created_by_Partner_Tag__c</field>
        <formula>&quot;Thunder Carrier Services&quot;</formula>
        <name>Tag Partner Thunder Carrier Services</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Tag_Partner_Truckers_Solutions</fullName>
        <field>Created_by_Partner_Tag__c</field>
        <formula>&quot;Truckers Solutions&quot;</formula>
        <name>Tag Partner Truckers Solutions</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Tag_Partner_Vero_Business_Capital</fullName>
        <field>Created_by_Partner_Tag__c</field>
        <formula>&quot;Vero Business Capital&quot;</formula>
        <name>Tag Partner Vero Business Capital</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Tag_Partner_Xfactors</fullName>
        <field>Created_by_Partner_Tag__c</field>
        <formula>&quot;Xfactors&quot;</formula>
        <name>Tag Partner Xfactors</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Tag_Partner_iThrive_Funding</fullName>
        <field>Created_by_Partner_Tag__c</field>
        <formula>&quot;iThrive Funding&quot;</formula>
        <name>Tag Partner iThrive Funding</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>WES_Add_to_Call_Outreach_Total</fullName>
        <field>WES_Call_Count__c</field>
        <formula>IF(WES_Call_Count__c &gt; 0, WES_Call_Count__c + 1, 1)</formula>
        <name>WES - Add to Call Outreach Total</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>WES_Assign_to_Telesales_RR_queue</fullName>
        <field>OwnerId</field>
        <lookupValue>WES_Telesales_auto_assign</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>WES - Assign to Telesales RR queue</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>WES_Auto_Assign_to_Field_Sales_Queue</fullName>
        <field>OwnerId</field>
        <lookupValue>WES_Field_Sales_auto_assign</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>WES - Auto Assign to Field Sales Queue</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>WES_Change_Lead_Status_to_Disqualified</fullName>
        <field>Status</field>
        <literalValue>Disqualified</literalValue>
        <name>WES - Change Lead Status to Disqualified</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>WES_Clear_Auto_Assign</fullName>
        <field>AssigntoQueue__c</field>
        <name>WES - Clear Auto-Assign</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>WES_Manually_Assign_Fieldsales_Queue</fullName>
        <field>OwnerId</field>
        <lookupValue>WES_Field_Sales_manually_assign</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>WES - Manually Assign Fieldsales Queue</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>WES_Manually_Assign_Telesales_Queue</fullName>
        <field>OwnerId</field>
        <lookupValue>WES_Telesales_manually_assign</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>WES - Manually Assign Telesales Queue</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>WES_Reset_Call_Outcome</fullName>
        <field>Call_Outcome__c</field>
        <name>WES - Reset Call Outcome</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>WES_Reset_Callback_Comments</fullName>
        <field>Call_Outcome_Comments__c</field>
        <name>WES - Reset Callback Comments</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>WES_Reset_Callback_Time</fullName>
        <field>WES_Call_Back_Time__c</field>
        <name>WES - Reset Callback Time</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>WES_Reset_Sub_Status_1</fullName>
        <field>WES_Sub_Status1__c</field>
        <name>WES - Reset Sub-Status 1</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>WES_Reset_Sub_Status_2</fullName>
        <field>WES_Sub_Status2__c</field>
        <name>WES - Reset Sub-Status 2</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>WES_Set_Callback_Time</fullName>
        <field>WES_Call_Back_Time__c</field>
        <formula>NOW()+ (1/6)</formula>
        <name>WES - Set Default Callback Time</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>WES_Set_Diesel_used_month_GBP</fullName>
        <description>Sets Diesel used per month based on Litres. Using 1.2 GBP per Litre as price</description>
        <field>WES_Diesel_per_month_GBP__c</field>
        <formula>WES_Diesel_per_month_Litres__c * 1.2</formula>
        <name>WES Set Diesel used / month (GBP)</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>WES_Set_Diesel_used_month_Litres</fullName>
        <description>Sets Litres used per month based on GBP. Using 1.2 GBP per Litre as price</description>
        <field>WES_Diesel_per_month_Litres__c</field>
        <formula>WES_Diesel_per_month_GBP__c / 1.2</formula>
        <name>WES Set Diesel used / month (Litres)</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>WES_Set_Disqualified_Reason_1</fullName>
        <description>Used by WES</description>
        <field>WES_Disqualified_Reason1__c</field>
        <formula>TEXT(WES_Sub_Status1__c)</formula>
        <name>WES - Set Disqualified Reason 1</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>WES_Set_Disqualified_Reason_2</fullName>
        <description>Used by WES</description>
        <field>WES_Disqualified_Reason2__c</field>
        <formula>TEXT(WES_Sub_Status2__c)</formula>
        <name>WES - Set Disqualified Reason 2</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>WES_Set_Last_Call_Outcome_Time</fullName>
        <field>LastCallOutcomeTime__c</field>
        <formula>NOW()</formula>
        <name>WES - Set Last Call Outcome Time</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>WES_Set_Petrol_used_month_GBP</fullName>
        <description>Sets Petrol used per month based on Litres. Using 1.2 GBP per Litre as price</description>
        <field>WES_Petrol_used_per_month_GBP__c</field>
        <formula>WES_Petrol_used_per_month_Litres__c * 1.2</formula>
        <name>WES Set Petrol used / month (GBP)</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>WES_Set_Petrol_used_month_Litres</fullName>
        <description>Sets Litres used per month based on GBP. Using 1.2 GBP per Litre as price</description>
        <field>WES_Petrol_used_per_month_Litres__c</field>
        <formula>WES_Petrol_used_per_month_GBP__c / 1.2</formula>
        <name>WES Set Petrol used / month (Litres)</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>WES_Set_Street</fullName>
        <field>Street</field>
        <formula>WES_Address_Line1__c&amp;BR()&amp;
WES_Address_Line2__c&amp;BR()&amp; 
WES_Address_Line3__c</formula>
        <name>WES - Set Street</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>WES_Set_Trading_Country</fullName>
        <field>Country</field>
        <formula>TEXT(WES_Trading_Country__c)</formula>
        <name>WES - Set Trading Country</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>WES_Set_Trading_County</fullName>
        <field>State</field>
        <formula>WES_Trading_County__c</formula>
        <name>WES - Set Trading County</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>WES_Set_Trading_County_based_on_State</fullName>
        <field>WES_TradingPostcode__c</field>
        <formula>PostalCode</formula>
        <name>WES - Set Trading Postcode</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>WES_Set_Trading_County_on_State</fullName>
        <field>WES_Trading_County__c</field>
        <formula>State</formula>
        <name>WES - Set Trading County based on State</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>WES_Set_Trading_Postcode</fullName>
        <field>PostalCode</field>
        <formula>WES_TradingPostcode__c</formula>
        <name>WES - Set Trading Postcode</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>WES_Set_Trading_Street_with_Billing</fullName>
        <field>WES_Address_Line1__c</field>
        <formula>Street</formula>
        <name>WES - Set Trading Street with Billing</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>WES_Set_Trading_Town</fullName>
        <field>City</field>
        <formula>WES_Trading_Town__c</formula>
        <name>WES - Set City based on Trading Town</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>WES_Set_Trading_Town_based_on_City</fullName>
        <field>WES_Trading_Town__c</field>
        <formula>City</formula>
        <name>WES - Set Trading Town based on City</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>WES_Update_Last_Call_Outcome</fullName>
        <field>WES_Last_Call_Outcome__c</field>
        <formula>TEXT(Call_Outcome__c)</formula>
        <name>WES - Update Last Call Outcome</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>WEX_Facebeok_Leads</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Wright_Leads</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>WEX Facebeok Leads</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>AU %3A Application status sales queue</fullName>
        <actions>
            <name>AU_Application_Status_Follow_Up</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.OwnerId</field>
            <operation>equals</operation>
            <value>AU Sales Queue</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Status</field>
            <operation>notEqual</operation>
            <value>Untouched</value>
        </criteriaItems>
        <description>If Lead is in the Sales Queue and Lead status = &quot;untouched&quot;, update the Lead application status.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>AU Application Status</fullName>
        <actions>
            <name>AU_Application_Status_Credit_Queue</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.OwnerId</field>
            <operation>equals</operation>
            <value>AU Credit Queue</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Status</field>
            <operation>notEqual</operation>
            <value>Untouched</value>
        </criteriaItems>
        <description>If owned by the Credit queue and lead status = &quot;untouched&quot;, then update the Lead Application Status</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>AU Lead%3A In progress update</fullName>
        <actions>
            <name>AU_Lead_In_progress_update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 OR 2</booleanFilter>
        <criteriaItems>
            <field>Lead.AU_Application_Status__c</field>
            <operation>equals</operation>
            <value>Ready for Assessment</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Details_Complete__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>Change the Lead status to &quot;In Progress&quot; if the application status is &quot;Ready for Assessment&quot; and the lead details are complete.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>AU MVF Rule</fullName>
        <actions>
            <name>AU_MVF_Intro_Email</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>AURecType</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.LeadSource</field>
            <operation>equals</operation>
            <value>2018-MP-EXPERTMARKET</value>
        </criteriaItems>
        <description>This rules sends a promotional email to the contact upon creation and changes the record type to AU Fuel</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>AU_TEMP_MVF_RecTypeToAUFuel</fullName>
        <active>false</active>
        <criteriaItems>
            <field>Lead.LeadSource</field>
            <operation>equals</operation>
            <value>2018-MP-EXPERTMARKET</value>
        </criteriaItems>
        <description>Changes the record type to AU fuel when the lead source is 2018-MP-EXPERTMARKET</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>MVF Email to Contact</fullName>
        <actions>
            <name>Email_sent_to_Contact_for_MMVF</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Lead.Coupon_Code_2__c</field>
            <operation>equals</operation>
            <value>MFG</value>
        </criteriaItems>
        <description>This rule send an email to the contact when the lead record is created for leads that come in from MVF</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Tag 123Loadboard Leads</fullName>
        <actions>
            <name>Tag_Partner_123Loadboard</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.CreatedById</field>
            <operation>equals</operation>
            <value>WILLIE ANDRUSS</value>
        </criteriaItems>
        <description>If 123Loadboard Partner User WILLIE ANDRUSS creates a lead.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Tag ASSIST FINANCIAL SERVICES Leads</fullName>
        <actions>
            <name>Tag_Partner_ASSIST_FINANCIAL_SERVICES</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.CreatedById</field>
            <operation>equals</operation>
            <value>Karen Tulloss</value>
        </criteriaItems>
        <description>If ASSIST FINANCIAL SERVICES Partner User Karen Tulloss creates a lead.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Tag Advanced Commercial Credit Leads</fullName>
        <actions>
            <name>Tag_Partner_Advanced_Commercial_Credit</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.CreatedById</field>
            <operation>equals</operation>
            <value>Rob Timmons</value>
        </criteriaItems>
        <description>If Advanced Commercial Credit Partner User Rob Timmons creates a lead.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Tag Aladdin Financial Leads</fullName>
        <actions>
            <name>Tag_Partner_Aladdin_Financial</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.CreatedById</field>
            <operation>equals</operation>
            <value>Jay Larson</value>
        </criteriaItems>
        <description>If Aladdin Financial Partner User Jay Larson creates a lead.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Tag CJM Financial Leads</fullName>
        <actions>
            <name>Tag_Partner_CJM_Financial</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.CreatedById</field>
            <operation>equals</operation>
            <value>TRENT MURPHY</value>
        </criteriaItems>
        <description>If CJM Financial Partner User TRENT MURPHY creates a lead.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Tag Century Leads</fullName>
        <actions>
            <name>Tag_Partner_Century</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.CreatedById</field>
            <operation>equals</operation>
            <value>JARED SEEMAN</value>
        </criteriaItems>
        <description>If Century Partner User JARED SEEMAN creates a lead.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Tag Commercial Funding Leads</fullName>
        <actions>
            <name>Tag_Partner_Commercial_Funding</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.CreatedById</field>
            <operation>equals</operation>
            <value>Julie Murphy</value>
        </criteriaItems>
        <description>If Commercial Funding Partner User Julie Murphy creates a lead.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Tag CoreFund Capital Leads</fullName>
        <actions>
            <name>Tag_Partner_CoreFund_Capital</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.CreatedById</field>
            <operation>equals</operation>
            <value>Bonnie Castillo</value>
        </criteriaItems>
        <description>If CoreFund Capital Partner User Bonnie Castillo creates a lead.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Tag DAT Leads</fullName>
        <actions>
            <name>Tag_Partner_DAT</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.CreatedById</field>
            <operation>equals</operation>
            <value>Bert Goo</value>
        </criteriaItems>
        <description>If DAT User Bert Goo creates a lead.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Tag ECAPITAL Leads</fullName>
        <actions>
            <name>Tag_Partner_ECAPITAL</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.CreatedById</field>
            <operation>equals</operation>
            <value>Raul Pena</value>
        </criteriaItems>
        <description>If ECAPITAL Partner User  Raul Pena creates a lead.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Tag Engs Commercial Capital Leads</fullName>
        <actions>
            <name>Tag_Partner_ENGS_Commercial_Capital</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.CreatedById</field>
            <operation>equals</operation>
            <value>Leslye Campos</value>
        </criteriaItems>
        <description>If Engs Commercial Capital Partner User Leslye Campos creates a lead.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Tag Envio 360 Leads</fullName>
        <actions>
            <name>Tag_Partner_Envio_360</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.CreatedById</field>
            <operation>equals</operation>
            <value>Larry Cuddy</value>
        </criteriaItems>
        <description>If Envio 360 Partner User Larry Cuddy creates a lead.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Tag Express Freight Leads</fullName>
        <actions>
            <name>Tag_Partner_Express_Freight_Finance</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.CreatedById</field>
            <operation>equals</operation>
            <value>Bryan Doty</value>
        </criteriaItems>
        <description>If Express Freight Partner User Bryan Doty creates a lead.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Tag Far West Capital Leads</fullName>
        <actions>
            <name>Tag_Partner_Far_West_Capital</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.CreatedById</field>
            <operation>equals</operation>
            <value>Brenda Pinon</value>
        </criteriaItems>
        <description>If Far West Capital Partner User Brenda Pinon creates a lead.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Tag FedEx Custom Critical Leads</fullName>
        <actions>
            <name>Tag_Partner_FedEx_Custom_Critical</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.CreatedById</field>
            <operation>equals</operation>
            <value>MARIANNE TAMMINEN</value>
        </criteriaItems>
        <description>If FedEx Custom Critical Partner User MARIANNE TAMMINEN creates a lead.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Tag Financial Carrier Service Leads</fullName>
        <actions>
            <name>Tag_Partner_Financial_Carrier_Service</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.CreatedById</field>
            <operation>equals</operation>
            <value>Alex Kelis</value>
        </criteriaItems>
        <description>If Financial Carrier Service Partner User Alex Kelis creates a lead.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Tag Foley Carrier Services Leads</fullName>
        <actions>
            <name>Tag_Partner_Foley_Carrier_Services</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.CreatedById</field>
            <operation>equals</operation>
            <value>Matt Nulle</value>
        </criteriaItems>
        <description>If Foley Carrier Services Partner User Matt Nulle creates a lead.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Tag Freight Factoring Special Leads</fullName>
        <actions>
            <name>Tag_Partner_Freight_Factoring_Special</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.CreatedById</field>
            <operation>equals</operation>
            <value>Steven Newman</value>
        </criteriaItems>
        <description>If Freight Factoring Special Partner User Steven Newman creates a lead.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Tag G SQUARED Leads</fullName>
        <actions>
            <name>Tag_Partner_G_SQUARED</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.CreatedById</field>
            <operation>equals</operation>
            <value>RON GABBAI</value>
        </criteriaItems>
        <description>If G SQUARED Partner User RON GABBAI creates a lead.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Tag G%2EH%2E Factor Leads</fullName>
        <actions>
            <name>Tag_Partner_G_H_Factor</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.CreatedById</field>
            <operation>equals</operation>
            <value>Karla Revilla</value>
        </criteriaItems>
        <description>If G.H. Factor Partner User Karla Revilla creates a lead.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Tag Great Plains Leads</fullName>
        <actions>
            <name>Tag_Partner_Great_Plains</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.CreatedById</field>
            <operation>equals</operation>
            <value>Jerry Van Wyk</value>
        </criteriaItems>
        <description>If Great Plains Partner User Jerry Van Wyk creates a lead.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Tag Integra Leads</fullName>
        <actions>
            <name>Tag_Partner_Integra</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.CreatedById</field>
            <operation>equals</operation>
            <value>Kyle Klatzkin</value>
        </criteriaItems>
        <description>If Integra Partner User Kyle Klatzkin creates a lead.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Tag Integrated Logistics Leads</fullName>
        <actions>
            <name>Tag_Partner_Integrated_Logistics</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.CreatedById</field>
            <operation>equals</operation>
            <value>Amanda Keller</value>
        </criteriaItems>
        <description>If Integrated Logistics Partner User Amanda Keller creates a lead.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Tag Interstate Capital Leads</fullName>
        <actions>
            <name>Tag_Partner_Interstate_Capital</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.CreatedById</field>
            <operation>equals</operation>
            <value>Sarah Williams</value>
        </criteriaItems>
        <description>If Interstate Capital Partner User Sarah Williams creates a lead.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Tag JB Hunt Leads</fullName>
        <actions>
            <name>Tag_Partner_JB_Hunt</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.CreatedById</field>
            <operation>equals</operation>
            <value>Mandy Robinson</value>
        </criteriaItems>
        <description>If JB Hunt Partner User Mandy Robinson creates a lead.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Tag JD Factors Leads</fullName>
        <actions>
            <name>Tag_Partner_JD_Factors</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.CreatedById</field>
            <operation>equals</operation>
            <value>CHIP WILEY</value>
        </criteriaItems>
        <description>If JD Factors Partner User CHIP WILEY creates a lead.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Tag Liquid Capital Leads</fullName>
        <actions>
            <name>Tag_Partner_Liquid_Capital</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.CreatedById</field>
            <operation>equals</operation>
            <value>Ernane Iung</value>
        </criteriaItems>
        <description>If Liquid Capital Partner User Ernane Iung creates a lead.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Tag OTR Capital Leads</fullName>
        <actions>
            <name>Tag_Partner_OTR_Capital</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.CreatedById</field>
            <operation>equals</operation>
            <value>Cody Barwig</value>
        </criteriaItems>
        <description>If OTR Capital Partner User Cody Barwig creates a lead.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Tag Parikh Financial Leads</fullName>
        <actions>
            <name>Tag_Partner_Parikh_Financial</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.CreatedById</field>
            <operation>equals</operation>
            <value>Raj Parikh</value>
        </criteriaItems>
        <description>If Parikh Financial Partner User Raj Parikh creates a lead.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Tag Partners Funding Leads</fullName>
        <actions>
            <name>Tag_Partner_Partners_Funding</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.CreatedById</field>
            <operation>equals</operation>
            <value>Patti Mielke</value>
        </criteriaItems>
        <description>If Partners Funding Partner User Patti Mielke creates a lead.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Tag Pay4Freight Leads</fullName>
        <actions>
            <name>Tag_Partner_Pay4Freight</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.CreatedById</field>
            <operation>equals</operation>
            <value>Robert Beard</value>
        </criteriaItems>
        <description>If Pay4Freight Partner User Robert Beard creates a lead.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Tag Petro Solutions Leads</fullName>
        <actions>
            <name>Tag_Partner_Petro_Solutions</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.CreatedById</field>
            <operation>equals</operation>
            <value>Chuck Miller</value>
        </criteriaItems>
        <description>If Petro Solutions Partner User Chuck Miller creates a lead.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Tag Quick Pay Funding Leads</fullName>
        <actions>
            <name>Tag_Partner_Quick_Pay_Funding</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.CreatedById</field>
            <operation>equals</operation>
            <value>JUAN ESTRADA</value>
        </criteriaItems>
        <description>If Quick Pay Funding Partner User JUAN ESTRADA creates a lead.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Tag SUMMAR Leads</fullName>
        <actions>
            <name>Tag_Partner_SUMMAR</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.CreatedById</field>
            <operation>equals</operation>
            <value>Jessi Saker</value>
        </criteriaItems>
        <description>If SUMMAR Partner User Jessi Saker creates a lead.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Tag St Johns Leads</fullName>
        <actions>
            <name>Tag_Partner_St_Johns</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.CreatedById</field>
            <operation>equals</operation>
            <value>Christina Kordik</value>
        </criteriaItems>
        <description>If St Johns Partner User Christina Kordik creates a lead.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Tag Steelhead Leads</fullName>
        <actions>
            <name>Tag_Partner_Steelhead</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.CreatedById</field>
            <operation>equals</operation>
            <value>Rich Templeton</value>
        </criteriaItems>
        <description>If Steelhead Partner User Rich Templeton creates a lead.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Tag Sunbelt Leads</fullName>
        <actions>
            <name>Tag_Partner_Sunbelt</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.CreatedById</field>
            <operation>equals</operation>
            <value>Debbie Kimberland</value>
        </criteriaItems>
        <description>If Sunbelt Partner User Debbie Kimberland creates a lead.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Tag TRANSPORT FINANCIAL SOLUTIONS Leads</fullName>
        <actions>
            <name>Tag_Partner_TRANSPORT_FINANCIAL_SOLUTIO</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.CreatedById</field>
            <operation>equals</operation>
            <value>Sheri Breedlove</value>
        </criteriaItems>
        <description>If TRANSPORT FINANCIAL SOLUTIONS Partner User Sheri Breedlove creates a lead.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Tag TRIUMPH Leads</fullName>
        <actions>
            <name>Tag_Partner_TRIUMPH_BUSINESS_CAPITAL</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 OR 2</booleanFilter>
        <criteriaItems>
            <field>Lead.CreatedById</field>
            <operation>equals</operation>
            <value>Ray Workman</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.CreatedById</field>
            <operation>equals</operation>
            <value>Jason Mullican</value>
        </criteriaItems>
        <description>If TRIUMPH BUSINESS CAPITAL LLC Partner User Ray Workman or Jason Mullican creates a lead.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Tag Thunder Carrier Services Leads</fullName>
        <actions>
            <name>Tag_Partner_Thunder_Carrier_Services</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.CreatedById</field>
            <operation>equals</operation>
            <value>Willie Andruss</value>
        </criteriaItems>
        <description>If Thunder Carrier Services Partner User Willie Andruss creates a lead.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Tag Truckers Solutions Leads</fullName>
        <actions>
            <name>Tag_Partner_Truckers_Solutions</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.CreatedById</field>
            <operation>equals</operation>
            <value>Dennis Woods</value>
        </criteriaItems>
        <description>If Truckers Solutions Partner User Dennis Woods creates a lead.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Tag Vero Business Capital Leads</fullName>
        <actions>
            <name>Tag_Partner_Vero_Business_Capital</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.CreatedById</field>
            <operation>equals</operation>
            <value>Trey Heath</value>
        </criteriaItems>
        <description>If Vero Business Capital Partner User Trey Heath creates a lead.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Tag Xfactors Leads</fullName>
        <actions>
            <name>Tag_Partner_Xfactors</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.CreatedById</field>
            <operation>equals</operation>
            <value>JEFFREY COLBURN</value>
        </criteriaItems>
        <description>If Xfactors Partner User JEFFREY COLBURN creates a lead.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Tag iThrive Funding Leads</fullName>
        <actions>
            <name>Tag_Partner_iThrive_Funding</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.CreatedById</field>
            <operation>equals</operation>
            <value>Robert Marker</value>
        </criteriaItems>
        <description>If iThrive Funding Partner User Robert Marker creates a lead.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>WES - Call Outcome Logged</fullName>
        <actions>
            <name>WES_Add_to_Call_Outreach_Total</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>WES_Reset_Call_Outcome</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>WES_Reset_Callback_Comments</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>WES_Set_Disqualified_Reason_1</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>WES_Set_Disqualified_Reason_2</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>WES_Set_Last_Call_Outcome_Time</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>WES_Update_Last_Call_Outcome</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ISCHANGED(Call_Outcome__c)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>WES - Change Lead Status to Disqualified</fullName>
        <actions>
            <name>WES_Change_Lead_Status_to_Disqualified</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.Call_Outcome__c</field>
            <operation>equals</operation>
            <value>Not Interested,Invalid,Barred,Existing Customer,Unreachable,Incorrect country,Test Lead</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>WES - Change Lead Status to Working</fullName>
        <actions>
            <name>Set_Lead_Status_to_Working</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.Call_Outcome__c</field>
            <operation>equals</operation>
            <value>Unanswered,Callback</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.RecordTypeId</field>
            <operation>equals</operation>
            <value>WES Lead</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>WES - Clear Callback Time</fullName>
        <actions>
            <name>WES_Reset_Callback_Time</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND( 
ISCHANGED(Call_Outcome__c), 
TEXT(Call_Outcome__c) &lt;&gt; &quot;Callback&quot;, 
TEXT(Call_Outcome__c) &lt;&gt; &quot;Unanswered&quot;	
)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>WES - Reset Sub-Statuses</fullName>
        <actions>
            <name>WES_Reset_Sub_Status_1</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>WES_Reset_Sub_Status_2</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>OR( 
ISCHANGED(WES_Disqualified_Reason1__c), 
ISCHANGED(WES_Disqualified_Reason2__c) 
)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>WES - Set Default Callback Time</fullName>
        <actions>
            <name>WES_Set_Callback_Time</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>TEXT(Call_Outcome__c) = &quot;Unanswered&quot; 
&amp;&amp; ( 
ISBLANK(WES_Call_Back_Time__c) || 
WES_Call_Back_Time__c &lt;= (NOW() + 1/6) 
)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>WES - Update Billing Address</fullName>
        <actions>
            <name>WES_Set_Street</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>WES_Set_Trading_Country</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>WES_Set_Trading_County</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>WES_Set_Trading_Postcode</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>WES_Set_Trading_Town</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND( 
RecordType.DeveloperName = &quot;WES_Lead&quot;, 
OR( 
ISCHANGED(WES_Address_Line1__c), 
ISCHANGED(WES_Address_Line2__c), 
ISCHANGED(WES_Address_Line3__c),	
ISCHANGED(WES_Trading_Town__c), 
ISCHANGED(WES_TradingPostcode__c), 
ISCHANGED(WES_Trading_County__c)	
) || 
AND( 
NOT(ISBLANK(WES_Address_Line1__c)), 
NOT(ISBLANK(WES_Trading_Town__c)), 
NOT(ISBLANK(WES_TradingPostcode__c)),	
ISBLANK(Street), 
ISBLANK(City), 
ISBLANK(PostalCode) 
) 
)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>WES Set Diesel used %2F month %28GBP%29</fullName>
        <actions>
            <name>WES_Set_Diesel_used_month_GBP</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Sets Diesel used per month based on Litres if Litres are set but GBP is blank.</description>
        <formula>AND( 
ISNEW(), 
NOT(ISBLANK(WES_Diesel_per_month_Litres__c)), 
ISBLANK(WES_Diesel_per_month_GBP__c) 
) || 
AND(	
ISCHANGED(WES_Diesel_per_month_Litres__c), 
NOT(ISCHANGED(WES_Diesel_per_month_GBP__c)) 
)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>WES Set Diesel used %2F month %28Litres%29</fullName>
        <actions>
            <name>WES_Set_Diesel_used_month_Litres</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND( 
ISNEW(), 
NOT(ISBLANK(WES_Diesel_per_month_GBP__c)), 
ISBLANK(WES_Diesel_per_month_Litres__c) 
) || 
AND(	
ISCHANGED(WES_Diesel_per_month_GBP__c), 
NOT(ISCHANGED(WES_Diesel_per_month_Litres__c)) 
)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>WES Set Petrol used %2F month %28GBP%29</fullName>
        <actions>
            <name>WES_Set_Petrol_used_month_GBP</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND( 
ISNEW(), 
NOT(ISBLANK(WES_Petrol_used_per_month_Litres__c)),	
ISBLANK(WES_Petrol_used_per_month_GBP__c) 
) || 
AND( 
ISCHANGED(WES_Petrol_used_per_month_Litres__c),	
NOT(ISCHANGED(WES_Petrol_used_per_month_GBP__c)) 
)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>WES Set Petrol used %2F month %28Litres%29</fullName>
        <actions>
            <name>WES_Set_Petrol_used_month_Litres</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND( 
ISNEW(), 
NOT(ISBLANK(WES_Petrol_used_per_month_GBP__c)),	
ISBLANK(WES_Petrol_used_per_month_Litres__c) 
) || 
AND( 
ISCHANGED(WES_Petrol_used_per_month_GBP__c),	
NOT(ISCHANGED(WES_Petrol_used_per_month_Litres__c)) 
)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>WEX Facebook Leads</fullName>
        <actions>
            <name>WEX_Facebeok_Leads</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.Coupon_Code_2__c</field>
            <operation>equals</operation>
            <value>K62</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
