<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>WES_House_Check_Fail</fullName>
        <ccEmails>eric.mcclatchy@gearscrm.com</ccEmails>
        <description>WES - House Check Fail</description>
        <protected>false</protected>
        <recipients>
            <recipient>WES_Sr_Telesales_Coordinator</recipient>
            <type>role</type>
        </recipients>
        <recipients>
            <recipient>WES_Telesales_Team_Leader</recipient>
            <type>role</type>
        </recipients>
        <recipients>
            <field>Sales_Agent_Assigned__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>WES/WES_Sense_Check_Failed</template>
    </alerts>
    <alerts>
        <fullName>WES_Returned_from_Credit</fullName>
        <ccEmails>eric.mcclatchy@gearscrm.com</ccEmails>
        <description>WES - Returned from Credit</description>
        <protected>false</protected>
        <recipients>
            <recipient>WES_Sr_Telesales_Coordinator</recipient>
            <type>role</type>
        </recipients>
        <recipients>
            <recipient>WES_Telesales_Team_Leader</recipient>
            <type>role</type>
        </recipients>
        <recipients>
            <field>Sales_Agent_Assigned__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>WES/WES_General_App_Status_Change</template>
    </alerts>
    <alerts>
        <fullName>WES_Returned_from_Sales</fullName>
        <ccEmails>eric.mcclatchy@gearscrm.com</ccEmails>
        <description>WES - Returned from Sales</description>
        <protected>false</protected>
        <recipients>
            <recipient>WES_Credit_Vetting_Manager</recipient>
            <type>role</type>
        </recipients>
        <recipients>
            <recipient>WES_Credit_Vetting_Supervisor</recipient>
            <type>role</type>
        </recipients>
        <recipients>
            <field>CreditAgentAssigned__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>WES/WES_General_App_Status_Change</template>
    </alerts>
    <alerts>
        <fullName>WES_Send_Application_to_Credit_Supervisors</fullName>
        <ccEmails>eric.mcclatchy@gearscrm.com</ccEmails>
        <description>WES - Send Application to Credit Supervisors / Managers</description>
        <protected>false</protected>
        <recipients>
            <recipient>WES_Credit_Vetting_Manager</recipient>
            <type>role</type>
        </recipients>
        <recipients>
            <recipient>WES_Credit_Vetting_Supervisor</recipient>
            <type>role</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>WES/WES_Refer_Application_to_Higher_Authority</template>
    </alerts>
    <alerts>
        <fullName>WES_Send_Application_to_Sales_Supervisors_for_Security_Check</fullName>
        <ccEmails>eric.mcclatchy@gearscrm.com</ccEmails>
        <description>WES - Send Application to Sales Supervisors for Security Check</description>
        <protected>false</protected>
        <recipients>
            <recipient>WES_Sr_Telesales_Coordinator</recipient>
            <type>role</type>
        </recipients>
        <recipients>
            <recipient>WES_Telesales_Team_Leader</recipient>
            <type>role</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>WES/WES_Awaiting_Security_Check</template>
    </alerts>
    <alerts>
        <fullName>WES_Send_Notification_Failed_Security_Check</fullName>
        <ccEmails>eric.mcclatchy@gearscrm.com</ccEmails>
        <description>WES - Send Notification - Failed Security Check</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <field>Sales_Agent_Assigned__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>WES/WES_Failed_Security_Check</template>
    </alerts>
    <alerts>
        <fullName>WES_Send_Notification_Passed_Security_Check</fullName>
        <ccEmails>eric.mcclatchy@gearscrm.com</ccEmails>
        <description>WES - Send Notification - Passed Security Check</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <field>Sales_Agent_Assigned__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>WES/WES_Passed_Security_Check</template>
    </alerts>
    <alerts>
        <fullName>WES_Send_Notification_Returned_to_Credit</fullName>
        <ccEmails>eric.mcclatchy@gearscrm.com</ccEmails>
        <description>WES - Send Notification - Returned to Credit</description>
        <protected>false</protected>
        <recipients>
            <recipient>WES_Credit_Vetting_Manager</recipient>
            <type>role</type>
        </recipients>
        <recipients>
            <recipient>WES_Credit_Vetting_Supervisor</recipient>
            <type>role</type>
        </recipients>
        <recipients>
            <field>CreditAgentAssigned__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>WES/WES_Awaiting_Security_Check</template>
    </alerts>
    <alerts>
        <fullName>WES_Send_Notification_Returned_to_Sales</fullName>
        <ccEmails>eric.mcclatchy@gearscrm.com</ccEmails>
        <description>WES - Sense Check Failed</description>
        <protected>false</protected>
        <recipients>
            <recipient>WES_Telesales_Team_Leader</recipient>
            <type>role</type>
        </recipients>
        <recipients>
            <field>Sales_Agent_Assigned__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>WES/WES_Sense_Check_Failed</template>
    </alerts>
    <alerts>
        <fullName>WES_Send_Sales_Accepted_Application_Notification</fullName>
        <ccEmails>eric.mcclatchy@gearscrm.com</ccEmails>
        <description>WES - Send Sales Accepted Application Notification</description>
        <protected>false</protected>
        <recipients>
            <recipient>WES_Sr_Telesales_Coordinator</recipient>
            <type>role</type>
        </recipients>
        <recipients>
            <recipient>WES_Telesales_Team_Leader</recipient>
            <type>role</type>
        </recipients>
        <recipients>
            <field>Sales_Agent_Assigned__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>WES/WES_Application_Accepted</template>
    </alerts>
    <alerts>
        <fullName>WES_Send_Sales_Decline_Reason</fullName>
        <ccEmails>eric.mcclatchy@gearscrm.com</ccEmails>
        <description>WES - Send Sales Decline Reason</description>
        <protected>false</protected>
        <recipients>
            <recipient>WES_Sr_Telesales_Coordinator</recipient>
            <type>role</type>
        </recipients>
        <recipients>
            <recipient>WES_Telesales_Team_Leader</recipient>
            <type>role</type>
        </recipients>
        <recipients>
            <field>Sales_Agent_Assigned__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>WES/WES_Send_Sales_Decline_Reason</template>
    </alerts>
    <fieldUpdates>
        <fullName>Set_Failed_Security_Check_True</fullName>
        <field>Failed_Security_Check__c</field>
        <literalValue>1</literalValue>
        <name>Set Failed Security Check True</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>WES_Allow_Security_Check</fullName>
        <description>Marks the</description>
        <field>ProceedwithSecurityCheck__c</field>
        <literalValue>1</literalValue>
        <name>WES - Proceed with Security Check</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>WES_App_Status_Sales_to_Obtain</fullName>
        <field>Application_Status__c</field>
        <literalValue>Sales to Obtain Further Information</literalValue>
        <name>WES - App Status - Sales to Obtain</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>WES_Assign_to_Sales_Queue</fullName>
        <field>OwnerId</field>
        <lookupValue>WES_Credit_manually_assign</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>WES - Assign to Sales Manual Queue</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>WES_Auto_Assign_to_Credit_Queue</fullName>
        <field>OwnerId</field>
        <lookupValue>WES_Credit_auto_assign</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>WES - Auto Assign to Credit Queue</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>WES_Calculate_Required_Credit_Limit</fullName>
        <field>Required_Credit_Limit__c</field>
        <formula>CreditLimitFormula__c</formula>
        <name>WES - Calculate Required Credit Limit</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>WES_Change_to_Manual_Assignment_Queue</fullName>
        <field>OwnerId</field>
        <lookupValue>WES_Credit_manually_assign</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>WES - Change to Manual Assignment Queue</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>WES_Charity_App_Record_Type</fullName>
        <field>RecordTypeId</field>
        <lookupValue>WES_Charity_or_Trust</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>WES - Charity App Record Type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>WES_Clear_Auto_Assign_Queue</fullName>
        <field>AutoAssignQueue__c</field>
        <name>WES - Clear Auto Assign Queue</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>WES_Credit_Team_Assigned</fullName>
        <field>TeamAssigned__c</field>
        <literalValue>Credit</literalValue>
        <name>WES - Credit Team Assigned</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>WES_Passed_Security_Check</fullName>
        <field>Passed_Security_Check__c</field>
        <literalValue>1</literalValue>
        <name>WES - Passed Security Check</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>WES_Reset_Security_Check_Reason</fullName>
        <field>Security_Check_Failure_Reason__c</field>
        <name>WES - Reset Security Check Reason</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>WES_Sales_team_assigned</fullName>
        <field>TeamAssigned__c</field>
        <literalValue>Sales</literalValue>
        <name>WES - Sales team assigned</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>WES_Send_App_to_IFCS</fullName>
        <field>Send_App_to_IFCS__c</field>
        <literalValue>1</literalValue>
        <name>WES - Send App to IFCS</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>WES_Set_App_Status_to_Awaiting_Assign</fullName>
        <field>Application_Status__c</field>
        <literalValue>Awaiting Assignment</literalValue>
        <name>WES - Set App Status to Awaiting Assign</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>WES_Set_App_Status_to_Being_Worked</fullName>
        <field>Application_Status__c</field>
        <literalValue>Being Credit Checked</literalValue>
        <name>WES - Set App Status Being Credit Check</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>WES_Set_App_Status_to_Rejected</fullName>
        <field>Application_Status__c</field>
        <literalValue>Rejected</literalValue>
        <name>WES - Set App Status to Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>WES_Set_App_Status_to_Unable_to_Proces</fullName>
        <field>Application_Status__c</field>
        <literalValue>Unable to Process</literalValue>
        <name>WES - Set App Status to Unable to Proces</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>WES_Set_App_to_Awaiting_Security_Check</fullName>
        <field>Application_Status__c</field>
        <literalValue>Awaiting Security Check</literalValue>
        <name>WES - Set App to Awaiting Security Check</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>WES_Set_Application_Status_to_Accepted</fullName>
        <field>Application_Status__c</field>
        <literalValue>Accepted</literalValue>
        <name>WES - Set Application Status to Accepted</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>WES_Set_Awaiting_Credit_Check</fullName>
        <field>Application_Status__c</field>
        <literalValue>Awaiting Credit Check</literalValue>
        <name>WES - Set Awaiting Credit Check</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>WES_Set_Biggest_Vehicle_Cars</fullName>
        <field>BiggestVehicle__c</field>
        <literalValue>Cars</literalValue>
        <name>WES - Set Biggest Vehicle - Cars</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>WES_Set_Biggest_Vehicle_Coaches</fullName>
        <field>BiggestVehicle__c</field>
        <literalValue>Coaches</literalValue>
        <name>WES - Set Biggest Vehicle - Coaches</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>WES_Set_Biggest_Vehicle_HGV</fullName>
        <field>BiggestVehicle__c</field>
        <literalValue>HGV</literalValue>
        <name>WES - Set Biggest Vehicle - HGV</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>WES_Set_Biggest_Vehicle_LGV</fullName>
        <field>BiggestVehicle__c</field>
        <literalValue>LGV</literalValue>
        <name>WES - Set Biggest Vehicle - LGV</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>WES_Set_Biggest_Vehicle_Vans</fullName>
        <field>BiggestVehicle__c</field>
        <literalValue>Vans</literalValue>
        <name>WES - Set Biggest Vehicle - Vans</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>WES_Set_Company_Reg</fullName>
        <field>Company_registration_number__c</field>
        <formula>Company_Reg_Num__c</formula>
        <name>WES - Set Company Reg #</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>WES_Set_Credit_Decision_to_Accepted</fullName>
        <field>Credit_Decision__c</field>
        <literalValue>Accepted</literalValue>
        <name>WES - Set Credit Decision to Accepted</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>WES_Set_Credit_Decision_to_Rejected</fullName>
        <field>Credit_Decision__c</field>
        <literalValue>Rejected</literalValue>
        <name>WES - Set Credit Decision to Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>WES_Set_Credit_Level_Request_True</fullName>
        <field>CreditLevelRequestApproved__c</field>
        <literalValue>1</literalValue>
        <name>WES - Set Credit Level Request True</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>WES_Set_Decision_Date_to_Today</fullName>
        <field>Application_decision_date__c</field>
        <formula>NOW()</formula>
        <name>WES - Set Decision Date to Today</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>WES_Set_Diesel_used_month_GBP</fullName>
        <description>Sets Diesel used per month based on Litres. Using 1.2 GBP per Litre as price</description>
        <field>Diesel_used_per_month_GBP__c</field>
        <formula>Diesel_per_month_Litres__c * 1.2</formula>
        <name>WES Set Diesel used / month (GBP)</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>WES_Set_Diesel_used_month_Litres</fullName>
        <description>Sets Litres used per month based on GBP. Using 1.2 GBP per Litre as price</description>
        <field>Diesel_per_month_Litres__c</field>
        <formula>Diesel_used_per_month_GBP__c / 1.2</formula>
        <name>WES Set Diesel used / month (Litres)</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>WES_Set_Govt_App_Record_Type</fullName>
        <field>RecordTypeId</field>
        <lookupValue>WES_Government_Body</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>WES - Set Govt App Record Type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>WES_Set_International_Customer</fullName>
        <field>isInternational__c</field>
        <literalValue>Y</literalValue>
        <name>WES - Set International Customer</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>WES_Set_Limited_Co_App_Record_Type</fullName>
        <field>RecordTypeId</field>
        <lookupValue>WES_Limited_Company</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>WES - Set Limited Co App Record Type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>WES_Set_Limited_Part_App_Record_Type</fullName>
        <field>RecordTypeId</field>
        <lookupValue>WES_Limited_Liability_Partnership</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>WES - Set Limited Part App Record Type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>WES_Set_Name_of_Signatory</fullName>
        <description>Used to populate name of signatory based on Primary Contact once DD script has been completed successfully.</description>
        <field>nameofSignature__c</field>
        <formula>Primary_Contact_Name__c</formula>
        <name>WES - Set Name of Signatory</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>WES_Set_National_Customer</fullName>
        <field>isInternational__c</field>
        <literalValue>N</literalValue>
        <name>WES - Set National Customer</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>WES_Set_Partner_App_Record_Type</fullName>
        <field>RecordTypeId</field>
        <lookupValue>WES_Partnership</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>WES - Set Partner App Record Type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>WES_Set_Petrol_used_month_GBP</fullName>
        <description>Sets Petrol used per month based on Litres. Using 1.2 GBP per Litre as price</description>
        <field>Petrol_used_per_month_GBP__c</field>
        <formula>Petrol_used_per_month_Litres__c * 1.2</formula>
        <name>WES Set Petrol used / month (GBP)</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>WES_Set_Petrol_used_month_Litres</fullName>
        <description>Sets Litres used per month based on GBP. Using 1.2 GBP per Litre as price</description>
        <field>Petrol_used_per_month_Litres__c</field>
        <formula>Petrol_used_per_month_GBP__c / 1.2</formula>
        <name>WES Set Petrol used / month (Litres)</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>WES_Set_Proceed_with_App_to_TRUE</fullName>
        <field>Proceed_with_Invalid_BAN__c</field>
        <literalValue>1</literalValue>
        <name>WES -  Set Proceed with App to TRUE</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>WES_Set_Product_Type_Esso_Internation</fullName>
        <field>Product_Type__c</field>
        <literalValue>Esso + International UK (WEX)</literalValue>
        <name>WES  - Set Product Type Esso Internation</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>WES_Set_Product_Type_to_Esso_National</fullName>
        <field>Product_Type__c</field>
        <literalValue>Esso + National UK (WEX)</literalValue>
        <name>WES - Set Product Type to Esso National</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>WES_Set_Public_Lim_App_Record_Type</fullName>
        <field>RecordTypeId</field>
        <lookupValue>WES_Public_Limited_Company</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>WES - Set Public Lim App Record Type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>WES_Set_Record_Locked_to_True</fullName>
        <description>Sets Record Lock to true for validation rule to prevent editing.</description>
        <field>RecordLocked__c</field>
        <literalValue>1</literalValue>
        <name>WES - Set Record Locked to True</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>WES_Set_Request_ID</fullName>
        <description>Sets the request ID based on the last digits of the application name.</description>
        <field>requestID__c</field>
        <formula>VALUE(SUBSTITUTE(Name,&quot;WES-AR-&quot;, &quot;&quot;))</formula>
        <name>WES - Set Request ID</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>WES_Set_Sole_Prop_App_Record_Type</fullName>
        <field>RecordTypeId</field>
        <lookupValue>WES_Sole_Proprietor</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>WES - Set Sole Prop App Record Type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>WES_Set_Status_to_Awaiting_Credit_Chec</fullName>
        <field>Application_Status__c</field>
        <literalValue>Awaiting Credit Check</literalValue>
        <name>WES - Set Status to Awaiting Credit Chec</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>WES_Set_Status_to_Draft</fullName>
        <field>Application_Status__c</field>
        <literalValue>Draft</literalValue>
        <name>WES - Set Status to Draft</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>WES_Set_Status_to_Higher_Authority</fullName>
        <field>Application_Status__c</field>
        <literalValue>Higher Authority</literalValue>
        <name>WES - Set Status to Higher Authority</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>WES_Update_Vehicle_Type_to_Cars</fullName>
        <field>BiggestVehicle__c</field>
        <literalValue>Cars</literalValue>
        <name>WES - Update Vehicle Type to Cars</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>WES_Update_Vehicle_Type_to_Coach</fullName>
        <field>BiggestVehicle__c</field>
        <literalValue>Coaches</literalValue>
        <name>WES - Update Vehicle Type to Coach</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Set Status to Awaiting Assignment</fullName>
        <actions>
            <name>WES_Set_App_Status_to_Awaiting_Assign</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>WES_Application_Request__c.Passed_Security_Check__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>WES_Application_Request__c.CreditAgentAssigned__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>WES_Application_Request__c.Application_Status__c</field>
            <operation>equals</operation>
            <value>Draft,Awaiting Security Check</value>
        </criteriaItems>
        <description>If the application has passed the security and doesn&apos;t have a credit agent assigned, it should be set to &quot;Awaiting assignment&quot;</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>WES - App Status - Awaiting Assignment</fullName>
        <actions>
            <name>WES_Set_Awaiting_Credit_Check</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Automatically change the application status to &quot;Awaiting Assignment&quot; when its been auto or manually assigned.</description>
        <formula>TEXT(Application_Status__c) = &quot;Awaiting Assignment&quot; &amp;&amp; Owner:Queue.QueueName = &quot;WES_Credit_manually_assign&quot;</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>WES - Application - Referred to Higher Authority</fullName>
        <actions>
            <name>WES_Send_Application_to_Credit_Supervisors</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <formula>ISCHANGED(Application_Status__c) &amp;&amp; BEGINS(TEXT(Application_Status__c),&quot;Referred to Higher Authority&quot;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>WES - Application is Accepted</fullName>
        <actions>
            <name>WES_Send_Sales_Accepted_Application_Notification</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>WES_Send_App_to_IFCS</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>WES_Set_Decision_Date_to_Today</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>WES_Set_Record_Locked_to_True</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>WES_Application_Request__c.Application_Status__c</field>
            <operation>equals</operation>
            <value>Accepted</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>WES - Application is Rejected</fullName>
        <actions>
            <name>WES_Send_Sales_Decline_Reason</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>WES_Application_Request__c.Application_Status__c</field>
            <operation>equals</operation>
            <value>Rejected</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>WES - Application is Unable to Process</fullName>
        <actions>
            <name>WES_Send_Sales_Decline_Reason</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>WES_Application_Request__c.Application_Status__c</field>
            <operation>equals</operation>
            <value>Unable to Process</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>WES - Auto Assign to Credit Queue</fullName>
        <actions>
            <name>WES_Auto_Assign_to_Credit_Queue</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>WES_Application_Request__c.AutoAssignQueue__c</field>
            <operation>equals</operation>
            <value>WES Credit (auto-assign)</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>WES - Auto-approve Application</fullName>
        <actions>
            <name>WES_Set_Application_Status_to_Accepted</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <formula>AND( Required_Credit_Limit__c &lt;= 500, TEXT(Account_Billing_Frequency__c) = &quot;Weekly&quot;, VALUE(TEXT(Account_Payment_Days__c)) &lt;= 7, OR( Risk_Category_Formula__c = &quot;Medium&quot;, Risk_Category_Formula__c = &quot;Low&quot;, Risk_Category_Formula__c = &quot;Very Low&quot;), ISBLANK(TEXT(Adverse_Indicators__c)) 					)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>WES - Calculate Credit Limit</fullName>
        <actions>
            <name>WES_Calculate_Required_Credit_Limit</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Calculates Required Credit Limit based on fuel usage and drawing frequency.</description>
        <formula>AND( 				NOT(ISBLANK(MonthlyFuelVolumeLitres__c)), 						 VolumeConversionFormula__c &gt; 0, 				   WeeksDrawPayment__c &gt;= 1, OR(ISNEW(), 			ISCHANGED(Petrol_used_per_month_Litres__c), 			ISCHANGED(Diesel_per_month_Litres__c),  		ISCHANGED(Account_Billing_Frequency__c),  		ISCHANGED(Account_Payment_Days__c) ))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>WES - Clear Auto Assign Queue</fullName>
        <actions>
            <name>WES_Clear_Auto_Assign_Queue</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>WES_Application_Request__c.AutoAssignQueue__c</field>
            <operation>equals</operation>
            <value>WES Credit (auto-assign)</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>WES - Credit Decision Accept</fullName>
        <actions>
            <name>WES_Set_Application_Status_to_Accepted</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Update status to Accepted when a credit decision is made</description>
        <formula>AND( TEXT(Credit_Decision__c) = &quot;Accepted&quot;,   		 TEXT(Application_Status__c) &lt;&gt; &quot;Accepted&quot; 				)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>WES - Credit Decision Rejected</fullName>
        <actions>
            <name>WES_Set_App_Status_to_Rejected</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>WES_Set_Decision_Date_to_Today</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>WES_Application_Request__c.Credit_Decision__c</field>
            <operation>equals</operation>
            <value>Rejected</value>
        </criteriaItems>
        <description>Update status to Rejected when a credit decision is made</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>WES - Credit Decision Unable to Process</fullName>
        <actions>
            <name>WES_Set_App_Status_to_Unable_to_Proces</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>WES_Set_Decision_Date_to_Today</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>WES_Application_Request__c.Credit_Decision__c</field>
            <operation>equals</operation>
            <value>Unable to Process</value>
        </criteriaItems>
        <description>Update status to Unable to Process when a credit decision is made</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>WES - Enable Credit to Edit</fullName>
        <actions>
            <name>WES_Credit_Team_Assigned</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>WES_Application_Request__c.Application_Status__c</field>
            <operation>equals</operation>
            <value>Awaiting Assignment,Awaiting Credit Check,Being Credit Checked,Awaiting Further Information,Returned from Sales,Higher Authority,Rejected,Accepted</value>
        </criteriaItems>
        <description>Enables Credit team to edit based on application status</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>WES - Enable Sales to Edit</fullName>
        <actions>
            <name>WES_Sales_team_assigned</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>WES_Application_Request__c.Application_Status__c</field>
            <operation>equals</operation>
            <value>Draft,Awaiting Security Check,Sales to Obtain Further Information,Rejected,Unable to Process</value>
        </criteriaItems>
        <description>Enables Sales team to edit based on application status</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>WES - House Check Fail</fullName>
        <actions>
            <name>WES_House_Check_Fail</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>WES_App_Status_Sales_to_Obtain</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <formula>TEXT(Companies_House_Check__c) = &quot;Fail&quot;</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>WES - Returned from Credit</fullName>
        <actions>
            <name>WES_Returned_from_Credit</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>WES_Application_Request__c.Application_Status__c</field>
            <operation>equals</operation>
            <value>Sales to Obtain Further Information</value>
        </criteriaItems>
        <description>Application status is set to &quot;Sales to Obtain Further Information&quot; by credit analyst and is reassigned back to Sales agent.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>WES - Returned from Sales</fullName>
        <actions>
            <name>WES_Returned_from_Sales</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>WES_Application_Request__c.Application_Status__c</field>
            <operation>equals</operation>
            <value>Returned from Sales</value>
        </criteriaItems>
        <description>Application status is set to &quot;Returned from Sales&quot; after obtaining further information.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>WES - Security Check Failed</fullName>
        <actions>
            <name>WES_Send_Notification_Failed_Security_Check</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>WES_Set_Status_to_Draft</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND( ISCHANGED(Security_Check_Failure_Reason__c), NOT(ISBLANK(TEXT(Security_Check_Failure_Reason__c))) 										)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>WES - Sense Check Failed</fullName>
        <actions>
            <name>WES_Send_Notification_Returned_to_Sales</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>WES_App_Status_Sales_to_Obtain</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>WES_Application_Request__c.SenseCheck__c</field>
            <operation>equals</operation>
            <value>Failed</value>
        </criteriaItems>
        <description>Provides Sales team a notification when Application Sense check has Failed from Credit.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>WES - Set App Status to Being Worked</fullName>
        <actions>
            <name>WES_Set_App_Status_to_Being_Worked</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>If a WES Credit Vetting Analyst updates the application, it should get the status updated to being Credit Checked</description>
        <formula>AND( TEXT(Application_Status__c) = &quot;Awaiting Credit Check&quot;, 
LastModifiedBy.UserRole.DeveloperName = &quot;WES_Credit_Vetting_Analyst&quot;
)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>WES - Set Biggest Vehicle - Cars</fullName>
        <actions>
            <name>WES_Set_Biggest_Vehicle_Cars</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Sets the Biggest Vehicle based on the Type of Vehicles selected in the related opportunity.</description>
        <formula>AND( 				 OppBiggestVehicle__c = &quot;Cars&quot;, 				 ISBLANK(TEXT(BiggestVehicle__c)) 				)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>WES - Set Biggest Vehicle - Coaches</fullName>
        <actions>
            <name>WES_Set_Biggest_Vehicle_Coaches</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Sets the Biggest Vehicle based on the Type of Vehicles selected in the related opportunity.</description>
        <formula>AND( 				 OppBiggestVehicle__c = &quot;Coaches&quot;, 				 ISBLANK(TEXT(BiggestVehicle__c)) 				)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>WES - Set Biggest Vehicle - HGV</fullName>
        <actions>
            <name>WES_Set_Biggest_Vehicle_HGV</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Sets the Biggest Vehicle based on the Type of Vehicles selected in the related opportunity.</description>
        <formula>AND( 				 OppBiggestVehicle__c = &quot;HGV&quot;, 				 ISBLANK(TEXT(BiggestVehicle__c)) 				)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>WES - Set Biggest Vehicle - LGV</fullName>
        <actions>
            <name>WES_Set_Biggest_Vehicle_LGV</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Sets the Biggest Vehicle based on the Type of Vehicles selected in the related opportunity.</description>
        <formula>AND( 				 OppBiggestVehicle__c = &quot;LGV&quot;, 				 ISBLANK(TEXT(BiggestVehicle__c)) 				)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>WES - Set Biggest Vehicle - Vans</fullName>
        <actions>
            <name>WES_Set_Biggest_Vehicle_Vans</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Sets the Biggest Vehicle based on the Type of Vehicles selected in the related opportunity.</description>
        <formula>AND( 				 OppBiggestVehicle__c = &quot;Vans&quot;, 				 ISBLANK(TEXT(BiggestVehicle__c)) 				)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>WES - Set Charity Application Record Type</fullName>
        <actions>
            <name>WES_Charity_App_Record_Type</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>TEXT(Account__r.WES_Business_Entity_Type__c) = &quot;Charity or Trust&quot;</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>WES - Set Govt Application Record Type</fullName>
        <actions>
            <name>WES_Set_Govt_App_Record_Type</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>TEXT(Account__r.WES_Business_Entity_Type__c) = &quot;Government Body&quot;</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>WES - Set Limited Co Application Record Type</fullName>
        <actions>
            <name>WES_Set_Limited_Co_App_Record_Type</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>TEXT(Account__r.WES_Business_Entity_Type__c) = &quot;Limited Company&quot;</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>WES - Set Limited Partner Application Record Type</fullName>
        <actions>
            <name>WES_Set_Limited_Part_App_Record_Type</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>TEXT(Account__r.WES_Business_Entity_Type__c) = &quot;Limited Liability Partnership&quot;</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>WES - Set Partnership Application Record Type</fullName>
        <actions>
            <name>WES_Set_Partner_App_Record_Type</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>TEXT(Account__r.WES_Business_Entity_Type__c) = &quot;Partnership&quot;</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>WES - Set Public Limited Co Application Record Type</fullName>
        <actions>
            <name>WES_Set_Public_Lim_App_Record_Type</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>TEXT(Account__r.WES_Business_Entity_Type__c) = &quot;Public Limited Company&quot;</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>WES - Set Request ID</fullName>
        <actions>
            <name>WES_Set_Request_ID</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>WES_Application_Request__c.requestID__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <description>Sets the a unique identifier when sending application to IFCS through the C3 interface.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>WES - Set Signatory for Phone DD</fullName>
        <actions>
            <name>WES_Set_Name_of_Signatory</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Set the Signatory name based on Primary Contact once the Phone DD Mandate script has been successfully completed.</description>
        <formula>AND( TEXT(DD_Mandate_Method__c) = &quot;Phone&quot;, NOT(ISBLANK(DDMandateCompleteTimestamp__c)), ISCHANGED(DDMandateCompleteTimestamp__c) 				)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>WES - Set Sole Prop Application Record Type</fullName>
        <actions>
            <name>WES_Set_Sole_Prop_App_Record_Type</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>TEXT(Account__r.WES_Business_Entity_Type__c) = &quot;Sole Proprietor&quot;</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>WES - Update Status to Awaiting Credit Check</fullName>
        <actions>
            <name>WES_Set_Status_to_Awaiting_Credit_Chec</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Once an application&apos;s owner is assigned to a Credit Analyst, the application&apos;s status updates to Awaiting Credit Check</description>
        <formula>AND( TEXT(Application_Status__c) = &quot;Awaiting Assignment&quot;,  NOT(ISBLANK(CreditAgentAssigned__c)) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>WES Check field to proceed with Security Check</fullName>
        <actions>
            <name>WES_Allow_Security_Check</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>WES_Application_Request__c.ProceedwithSecurityCheck__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>WES_Application_Request__c.ApplicationDetailsComplete__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>WES_Application_Request__c.FuelCardInfoComplete__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>WES_Application_Request__c.DDMandateComplete__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>WES_Application_Request__c.CompanyInfoComplete__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>If all required fields are complete it allows the approval process for the Security Check</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
