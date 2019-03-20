<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Notify_AU_Application_Request_Approved</fullName>
        <description>Notify Owner - AU Application Request Credit Approved</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>AU_Email_Templates/AU_Fuel_Application_Credit_Approved</template>
    </alerts>
    <alerts>
        <fullName>Notify_AU_Application_Request_Final_Rejection</fullName>
        <description>Notify Owner - AU Application Request Final Rejection</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>AU_Email_Templates/AU_Fuel_Application_Credit_Rejected</template>
    </alerts>
    <alerts>
        <fullName>Notify_AU_Application_Request_Owner_Final_Approved</fullName>
        <description>Notify AU Application Request Owner Final Approved</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>AU_Email_Templates/AU_Fuel_Application_Credit_Approved</template>
    </alerts>
    <alerts>
        <fullName>Notify_AU_Application_Request_Team_Leader_Review_Needed</fullName>
        <description>Notify Team Leader - AU Application Request Review Needed</description>
        <protected>false</protected>
        <recipients>
            <recipient>AU_Credit_Team_Leader</recipient>
            <type>role</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>AU_Email_Templates/AU_Application_Credit_Approval_Request</template>
    </alerts>
    <alerts>
        <fullName>Notify_AU_Credit_Team_Leader_Final_Approved_Application_Request</fullName>
        <description>Notify Credit Team Leader - AU Final Approved Application Request</description>
        <protected>false</protected>
        <recipients>
            <recipient>AU_Credit_Team_Leader</recipient>
            <type>role</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>AU_Email_Templates/AU_Fuel_Application_Credit_Approved</template>
    </alerts>
    <fieldUpdates>
        <fullName>AUARUpdateReason</fullName>
        <field>WSS_Status_Reason__c</field>
        <formula>Opportunity__r.Response_Summary__c</formula>
        <name>AUARUpdateReason</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>AU_Application_Credit_Limit</fullName>
        <description>Set the AU Application Request Credit Limit field with the Opportunity Credit Limit value.</description>
        <field>Credit_Limit__c</field>
        <formula>Opportunity__r.Credit_Limit__c</formula>
        <name>AU Application Credit Limit</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>AU_Application_Final_Status_Date</fullName>
        <description>Set the AU Application Request Final Status Date to todays date</description>
        <field>Final_Status_Date__c</field>
        <formula>Today()</formula>
        <name>AU Application Final Status Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>AU_Application_Owner_to_AU_Credit_Q</fullName>
        <description>Change the AU Application Request Owner to the AU Credit Queue</description>
        <field>OwnerId</field>
        <lookupValue>AU_Credit_Queue</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>AU Application Owner to AU Credit Q</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>AU_Application_Owner_to_CentralQ</fullName>
        <description>Change the Owner to the AU Central Services Queue</description>
        <field>OwnerId</field>
        <lookupValue>AU_Central_Services_Queue</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>AU Application Owner to CentralQ</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>AU_Application_Owner_to_CustCareQ</fullName>
        <description>Change the AU Application owner to the AU Customer Care Queue</description>
        <field>OwnerId</field>
        <lookupValue>AU_Customer_Care</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>AU Application Owner to CustCareQ</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>AU_Application_Status_Approved</fullName>
        <description>Set the AU Application Request Application Status to Approved</description>
        <field>Application_Status__c</field>
        <literalValue>Approved</literalValue>
        <name>AU Application Status Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>AU_Application_Status_Declined_Initial</fullName>
        <description>Set the AU Application Status to Declined Initial</description>
        <field>Application_Status__c</field>
        <literalValue>Declined Initial</literalValue>
        <name>AU Application Status Declined Initial</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>AU_Application_Status_Pending_Approval</fullName>
        <description>Set the AU Application Request Status to &quot;Pending Approval&quot;</description>
        <field>Application_Status__c</field>
        <literalValue>Pending Approval</literalValue>
        <name>AU Application Status Pending Approval</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>AU_Application_to_AU_Key_Accounts_Q</fullName>
        <description>Change the AU Application Request Owner to the AU Key Accounts queue</description>
        <field>OwnerId</field>
        <lookupValue>AU_Key_Accounts</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>AU Application to AU Key Accounts Q</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>AU_Approval_Status_Approved</fullName>
        <description>Set the AU Application Request Approval Status to Approved</description>
        <field>Approval_Status__c</field>
        <literalValue>Approved</literalValue>
        <name>AU Approval Status Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>AU_Approval_Status_Approved_1st</fullName>
        <description>Set the AU Application Request Approval Status to Approved 1st</description>
        <field>Approval_Status__c</field>
        <literalValue>Approved 1st</literalValue>
        <name>AU Approval Status Approved 1st</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>AU_Approval_Status_Approved_2nd</fullName>
        <description>Set the AU Approval Status to Approved 2nd</description>
        <field>Approval_Status__c</field>
        <literalValue>Approved 2nd</literalValue>
        <name>AU Approval Status Approved 2nd</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>AU_Approval_Status_Declined</fullName>
        <description>Set the AU Approval Status to Declined</description>
        <field>Approval_Status__c</field>
        <literalValue>Declined</literalValue>
        <name>AU Approval Status Declined</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>AU_Approval_Status_Pending_Approval</fullName>
        <description>Set the AU Application Request Approval Status to Pending Approval</description>
        <field>Approval_Status__c</field>
        <literalValue>Pending Approval</literalValue>
        <name>AU Approval Status Pending Approval</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>AU_Partner_Created_by_Beevo</fullName>
        <description>Edited Thought World Field Update to this.</description>
        <field>Created_by_Partner_Tag__c</field>
        <formula>&quot;Beevo&quot;</formula>
        <name>AU Partner - Created by Beevo</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>AU_Partner_Created_by_Salmat</fullName>
        <field>Created_by_Partner_Tag__c</field>
        <formula>&quot;Salmat&quot;</formula>
        <name>AU Partner - Created by Salmat</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>AU_Partner_Created_by_TRIUMPH</fullName>
        <field>Created_by_Partner_Tag__c</field>
        <formula>&quot;TRIUMPH BUSINESS CAPITAL&quot;</formula>
        <name>AU Partner - Created by TRIUMPH</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>EMAP_Reset_Assess_End_Time</fullName>
        <description>Reset Assess End Time</description>
        <field>Assess_End_Time__c</field>
        <name>EMAP Reset Assess End Time</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>EMAP_Update_Application_Final_Date</fullName>
        <description>Update Application Final Date</description>
        <field>Application_Final_Date__c</field>
        <formula>Today()</formula>
        <name>EMAP Update Application Final Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>EMAP_Update_Application_decision_date</fullName>
        <description>Update Application decision date</description>
        <field>Application_decision_date__c</field>
        <formula>NOW()</formula>
        <name>EMAP Update Application decision date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>EMAP_Update_Assess_End_Time</fullName>
        <description>Update Assess End Time</description>
        <field>Assess_End_Time__c</field>
        <formula>NOW()</formula>
        <name>EMAP Update Assess End Time</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>EMAP_Update_Assess_Start_Time</fullName>
        <description>Update Assess Start Time</description>
        <field>Assess_Start_Time__c</field>
        <formula>NOW()</formula>
        <name>EMAP Update Assess Start Time</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>EMAP_Update_Date_field_within_5_days</fullName>
        <description>Update Date field within 5 days</description>
        <field>SLA_within_5_days__c</field>
        <formula>TODAY()</formula>
        <name>EMAP Update Date field within 5 days</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Empty_Integration_Status_Details</fullName>
        <description>Sets the integration status details field to empty so that it only contains the details from the last outbound message callback.</description>
        <field>Integration_Status_Detail__c</field>
        <name>Empty Integration Status Details</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Reset_Send_App_To_IFCS_for_App_Req</fullName>
        <description>Resets the Send App To IFCS value to false</description>
        <field>Send_App_to_IFCS__c</field>
        <literalValue>0</literalValue>
        <name>Reset Send App To IFCS for App Req</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <outboundMessages>
        <fullName>Application_to_IFCS</fullName>
        <apiVersion>32.0</apiVersion>
        <description>This message sends the necessary data elements to IFCS to create and account</description>
        <endpointUrl>https://ie-apac.prod.emea.wexinc.co.uk/consumer/Exxon/BusinessConnect</endpointUrl>
        <fields>AU_Marketing_Offers__c</fields>
        <fields>Accnt_Business_Financial_Year_Month_End__c</fields>
        <fields>Account_Behavioural_Score__c</fields>
        <fields>Account_Billing_City__c</fields>
        <fields>Account_Billing_Country__c</fields>
        <fields>Account_Billing_Frequency__c</fields>
        <fields>Account_Billing_Plan__c</fields>
        <fields>Account_Billing_State__c</fields>
        <fields>Account_Billing_Street__c</fields>
        <fields>Account_Billing_Zip_Code__c</fields>
        <fields>Account_Business_Registration_Number__c</fields>
        <fields>Account_Business_Structure__c</fields>
        <fields>Account_Business_Trading_Name__c</fields>
        <fields>Account_Class_of_Buyer__c</fields>
        <fields>Account_Company_Email_Address__c</fields>
        <fields>Account_Company_Name__c</fields>
        <fields>Account_Credit_Limit_LCY__c</fields>
        <fields>Account_Credit_Plan__c</fields>
        <fields>Account_Customer_Type__c</fields>
        <fields>Account_Cycle__c</fields>
        <fields>Account_Date_Business_Started__c</fields>
        <fields>Account_Direct_Debit_Account_Number__c</fields>
        <fields>Account_Direct_Debit_Bank_Account_Name__c</fields>
        <fields>Account_Direct_Debit_Bank_Name__c</fields>
        <fields>Account_Direct_Debit_Bank_Number__c</fields>
        <fields>Account_Direct_Debit_Branch_Number__c</fields>
        <fields>Account_Embassy_Code__c</fields>
        <fields>Account_Fax__c</fields>
        <fields>Account_Id__c</fields>
        <fields>Account_Industry__c</fields>
        <fields>Account_Legacy_Id__c</fields>
        <fields>Account_Mail_Indicator__c</fields>
        <fields>Account_Mobile_Phone__c</fields>
        <fields>Account_Number_of_Employees__c</fields>
        <fields>Account_Parent_Account__c</fields>
        <fields>Account_Payment_Days__c</fields>
        <fields>Account_Payment_Method__c</fields>
        <fields>Account_Percent_Secured__c</fields>
        <fields>Account_Phone__c</fields>
        <fields>Account_Preferred_Language__c</fields>
        <fields>Account_Sales_Area_Administration__c</fields>
        <fields>Account_Sales_Area_Marketing__c</fields>
        <fields>Account_Secondary_Mobile_Phone__c</fields>
        <fields>Account_Security_Indicator__c</fields>
        <fields>Account_Shipping_City__c</fields>
        <fields>Account_Shipping_Country__c</fields>
        <fields>Account_Shipping_State__c</fields>
        <fields>Account_Shipping_Street__c</fields>
        <fields>Account_Shipping_Zip_Code__c</fields>
        <fields>Account_Speedpass_Key_Tag__c</fields>
        <fields>Account_Total_Exposure_Limit_USD__c</fields>
        <fields>Application_Risk_Grade__c</fields>
        <fields>Application_Type__c</fields>
        <fields>Card_Pin__c</fields>
        <fields>Card_Program__c</fields>
        <fields>Client_Id__c</fields>
        <fields>Contact_Email__c</fields>
        <fields>Contact_Fax__c</fields>
        <fields>Contact_Phone_Number__c</fields>
        <fields>Contact_Title__c</fields>
        <fields>Contact_Type__c</fields>
        <fields>E_Business_OLS__c</fields>
        <fields>Electronic_Marketing_Flag__c</fields>
        <fields>Id</fields>
        <fields>Parent_Account_IFCS_Id__c</fields>
        <fields>Parent_Account_Name__c</fields>
        <fields>Parent_Account_Number__c</fields>
        <fields>Primary_Contact_First_Name__c</fields>
        <fields>Primary_Contact_Last_Name__c</fields>
        <fields>Primary_Contact_Mobile_Number__c</fields>
        <fields>Primary_Contact_Mobile_Phone2__c</fields>
        <fields>Total_Card_Requested__c</fields>
        <fields>Total_Security_Value__c</fields>
        <includeSessionId>true</includeSessionId>
        <integrationUser>salesforce@wrightexpress.com</integrationUser>
        <name>Application to IFCS</name>
        <protected>false</protected>
        <useDeadLetterQueue>true</useDeadLetterQueue>
    </outboundMessages>
    <rules>
        <fullName>AU AR Update Status Reason</fullName>
        <actions>
            <name>AUARUpdateReason</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>true</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>AU Application Credit Limit</fullName>
        <actions>
            <name>AU_Application_Credit_Limit</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>AU_Application_Request__c.Credit_Limit__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>AU_Application_Request__c.RecordTypeId</field>
            <operation>notEqual</operation>
            <value>EMAP Application Request</value>
        </criteriaItems>
        <description>Upon creation set the Credit Limit field with the Opportunity Credit Limit value IF no value is already entered.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>AU Application to AU Central Services Queue</fullName>
        <actions>
            <name>AU_Application_Owner_to_CentralQ</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>AU_Application_Request__c.Application_Status__c</field>
            <operation>equals</operation>
            <value>Pending Data Check</value>
        </criteriaItems>
        <criteriaItems>
            <field>AU_Application_Request__c.Approval_Status__c</field>
            <operation>equals</operation>
            <value>Approved</value>
        </criteriaItems>
        <criteriaItems>
            <field>AU_Application_Request__c.Opportunity_Lead_Source__c</field>
            <operation>notEqual</operation>
            <value>Third Party</value>
        </criteriaItems>
        <criteriaItems>
            <field>AU_Application_Request__c.RecordTypeId</field>
            <operation>notEqual</operation>
            <value>EMAP Application Request</value>
        </criteriaItems>
        <description>Various logic conditions to route records to the AU Central Services Queue.
When the Application Status is Pending Data Check, the Approval Status is Approved and the Opportunity Lead Source is not 3rd party, route to the AU Central Queue.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>AU Application to AU Credit Q</fullName>
        <actions>
            <name>AU_Application_Owner_to_AU_Credit_Q</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Various logic conditions to route records to the AU Credit Queue.
- Created
- Application Status is Error Referred and the Opportunity Lead Source is NOT FMO Partner.</description>
        <formula>AND( 
RecordType.Name  &lt;&gt; &apos;EMAP Application Request&apos;,
OR(
ISNEW(),
AND(
ISPICKVAL(Application_Status__c, &apos;Error Referred&apos;),   Opportunity_Lead_Source__c &lt;&gt; &apos;FMO Partner&apos;
)
)
)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>AU Application to AU Cust Care Q</fullName>
        <actions>
            <name>AU_Application_Owner_to_CustCareQ</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>AU_Application_Request__c.Application_Status__c</field>
            <operation>equals</operation>
            <value>Pending Data Check</value>
        </criteriaItems>
        <criteriaItems>
            <field>AU_Application_Request__c.Approval_Status__c</field>
            <operation>equals</operation>
            <value>Approved</value>
        </criteriaItems>
        <criteriaItems>
            <field>AU_Application_Request__c.Opportunity_Lead_Source__c</field>
            <operation>equals</operation>
            <value>Third Party</value>
        </criteriaItems>
        <criteriaItems>
            <field>AU_Application_Request__c.RecordTypeId</field>
            <operation>notEqual</operation>
            <value>EMAP Application Request</value>
        </criteriaItems>
        <description>Various logic conditions to route records to the AU Customer Care Queue
When the Approval Status is Approved, the Application Status is Pending Data Check and the Opportunity Lead Source is 3rd party, route to the AU Customer Care Queue</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>AU Application to AU Key Accounts Q</fullName>
        <actions>
            <name>AU_Application_to_AU_Key_Accounts_Q</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>AU_Application_Request__c.Application_Status__c</field>
            <operation>equals</operation>
            <value>Error Referred</value>
        </criteriaItems>
        <criteriaItems>
            <field>AU_Application_Request__c.Opportunity_Lead_Source__c</field>
            <operation>equals</operation>
            <value>FMO Partner</value>
        </criteriaItems>
        <criteriaItems>
            <field>AU_Application_Request__c.RecordTypeId</field>
            <operation>notEqual</operation>
            <value>EMAP Application Request</value>
        </criteriaItems>
        <description>Various logic conditions to route records to the AU Key Accounts Queue.
When the Application Status is Error Referred and the Opportunity Lead Source is FMO Partner, route to the AU Key Accounts queue</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>AU Partner - Created by Beevo</fullName>
        <actions>
            <name>AU_Partner_Created_by_Beevo</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>AU_Application_Request__c.CreatedById</field>
            <operation>equals</operation>
            <value>Cat Bleach</value>
        </criteriaItems>
        <description>If created by Cat Bleach then set Created by Partner Tag to Beevo.  (for sharing rules)</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>AU Partner - Created by Salmat</fullName>
        <actions>
            <name>AU_Partner_Created_by_Salmat</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>AU_Application_Request__c.CreatedById</field>
            <operation>equals</operation>
            <value>Nitesh Basudkar</value>
        </criteriaItems>
        <description>If created by Nitesh then set Created by Partner Tag to Salmat. (For sharing rules)</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>EMAP SLA Within 5 days</fullName>
        <actions>
            <name>EMAP_Update_Date_field_within_5_days</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>AU_Application_Request__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>EMAP Application Request</value>
        </criteriaItems>
        <criteriaItems>
            <field>AU_Application_Request__c.Application_Status__c</field>
            <operation>equals</operation>
            <value>Credit Assessment,RPS Pending,Sent To IFCS</value>
        </criteriaItems>
        <description>update date field in AU Application when criteria met</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>EMAP Update Application Final Date</fullName>
        <actions>
            <name>EMAP_Update_Application_Final_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>AU_Application_Request__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>EMAP Application Request</value>
        </criteriaItems>
        <criteriaItems>
            <field>AU_Application_Request__c.Application_Status__c</field>
            <operation>equals</operation>
            <value>Cancelled,Declined,Fulfilled</value>
        </criteriaItems>
        <description>Update Application Final Date</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>EMAP Update Application decision date</fullName>
        <actions>
            <name>EMAP_Update_Application_decision_date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>AU_Application_Request__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>EMAP Application Request</value>
        </criteriaItems>
        <criteriaItems>
            <field>AU_Application_Request__c.Application_Status__c</field>
            <operation>equals</operation>
            <value>Approved,Declined</value>
        </criteriaItems>
        <description>Update date to which application status is updated</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>EMAP Update Assess End Time</fullName>
        <actions>
            <name>EMAP_Update_Assess_End_Time</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Update Assess End Time</description>
        <formula>AND( RecordType.Name == &apos;EMAP Application Request&apos;, ISCHANGED(Application_Status__c), ISPICKVAL(PRIORVALUE(Application_Status__c), &apos;Credit Assessment&apos;)  )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>EMAP Update Assess Start Time</fullName>
        <actions>
            <name>EMAP_Reset_Assess_End_Time</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>EMAP_Update_Assess_Start_Time</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>AU_Application_Request__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>EMAP Application Request</value>
        </criteriaItems>
        <criteriaItems>
            <field>AU_Application_Request__c.Application_Status__c</field>
            <operation>equals</operation>
            <value>Credit Assessment</value>
        </criteriaItems>
        <description>Update Assess Start Time</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>INTEGRATION - Send Application to IFCS</fullName>
        <actions>
            <name>Empty_Integration_Status_Details</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Reset_Send_App_To_IFCS_for_App_Req</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Application_to_IFCS</name>
            <type>OutboundMessage</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>AU_Application_Request__c.Send_App_to_IFCS__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>AU_Application_Request__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>EMAP Application Request</value>
        </criteriaItems>
        <description>This workflow sends a credit application to IFCS (International Fuel Card System)</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
