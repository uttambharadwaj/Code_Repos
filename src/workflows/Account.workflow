<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Account_Team_Member_Reassignment_Request</fullName>
        <description>Account Team Member Reassignment Request</description>
        <protected>false</protected>
        <recipients>
            <type>accountOwner</type>
        </recipients>
        <recipients>
            <recipient>alex.sherwood@wexeurope.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <field>Team_Member_Name__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Virtual_EU_Templates/CorporatePay_Team_Member_Role_Reassignment_Request</template>
    </alerts>
    <alerts>
        <fullName>Account_Type_Ex_Customer</fullName>
        <description>Account Type - Ex-Customer</description>
        <protected>false</protected>
        <recipients>
            <recipient>CorporatePay_Head_Of_RM</recipient>
            <type>role</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Virtual_EU_Templates/CorporatePay_Account_Type_Ex_Customer</template>
    </alerts>
    <alerts>
        <fullName>B2B_Welcome_Email</fullName>
        <description>B2B Welcome Email</description>
        <protected>false</protected>
        <recipients>
            <field>Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Admin_Templates/New_Member_Welcome</template>
    </alerts>
    <alerts>
        <fullName>Edge_Welcome_Email</fullName>
        <description>Edge Welcome Email</description>
        <protected>false</protected>
        <recipients>
            <field>Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Admin_Templates/EDGE_Welcome_Email</template>
    </alerts>
    <alerts>
        <fullName>Email_New_E_Capital_Members</fullName>
        <description>Email New E-Capital Members</description>
        <protected>false</protected>
        <recipients>
            <field>Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Admin_Templates/EcapFuel_Enrollment_Welcome</template>
    </alerts>
    <alerts>
        <fullName>FTS_Gold_Program_Overview</fullName>
        <description>FTS Gold Program Overview</description>
        <protected>false</protected>
        <recipients>
            <field>Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>FTS_Tires/FTS_Gold_Program_Overview</template>
    </alerts>
    <alerts>
        <fullName>FTS_Savings_Reminder</fullName>
        <ccEmails>info@ftsplus.com</ccEmails>
        <description>FTS Savings Reminder</description>
        <protected>false</protected>
        <recipients>
            <field>Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>FTS_Other/PostenrollmentFTS_Savings_Overview</template>
    </alerts>
    <alerts>
        <fullName>FTS_Welcome_Email</fullName>
        <description>FTS Welcome Email</description>
        <protected>false</protected>
        <recipients>
            <field>Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>info@ftsplus.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Admin_Templates/FTS_Plus_Welcome_Email</template>
    </alerts>
    <alerts>
        <fullName>Gold_Program_Benefits_Email_EDGE</fullName>
        <description>Gold Program Benefits Email EDGE</description>
        <protected>false</protected>
        <recipients>
            <field>Primary_Contact__c</field>
            <type>contactLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>EDGE/Gold_Tire_Benefits</template>
    </alerts>
    <alerts>
        <fullName>RM_Assigned_Account_Owner_Notification</fullName>
        <description>RM Assigned - Account Owner Notification</description>
        <protected>false</protected>
        <recipients>
            <type>accountOwner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Virtual_EU_Templates/RM_Assigned_Account_Owner</template>
    </alerts>
    <alerts>
        <fullName>RM_Assigned_RM_Notification</fullName>
        <description>RM Assigned - RM Notification</description>
        <protected>false</protected>
        <recipients>
            <field>Assigned_Relationship_Manager__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Virtual_EU_Templates/RM_Assigned_RM</template>
    </alerts>
    <fieldUpdates>
        <fullName>AU_Account_Shipping_Postcode_with_Posta</fullName>
        <field>ShippingPostalCode</field>
        <formula>AU_Postal_Postcode__c</formula>
        <name>AU Account: Shipping Postcode with Posta</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>AU_Account_Shipping_State_with_Postal</fullName>
        <field>ShippingState</field>
        <formula>TEXT(AU_Postal_State__c)</formula>
        <name>AU Account: Shipping State with Postal</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>AU_Account_Shipping_Suburb_with_Postal</fullName>
        <field>ShippingCity</field>
        <formula>AU_Postal_Suburb__c</formula>
        <name>AU Account: Shipping Suburb with Postal</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>AU_Account_Update_Shipping_with_Postal</fullName>
        <field>ShippingStreet</field>
        <formula>AU_Postal_Address__c</formula>
        <name>AU Account: Update Shipping with Postal</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Account_Assign_Adam_Aurich</fullName>
        <field>OwnerId</field>
        <lookupValue>aaurich@truckersb2b.com.wex</lookupValue>
        <lookupValueType>User</lookupValueType>
        <name>Account: Assign Adam Aurich</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Account_Assign_Ian_Wilkinson</fullName>
        <field>OwnerId</field>
        <lookupValue>ian.wilkinson@efsllc.com.wex</lookupValue>
        <lookupValueType>User</lookupValueType>
        <name>Account: Assign Ian Wilkinson</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Account_Assign_Jennifer_Nelson</fullName>
        <field>OwnerId</field>
        <lookupValue>jnelson@truckersb2b.com.wex</lookupValue>
        <lookupValueType>User</lookupValueType>
        <name>Account:Assign Jennifer Nelson</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Account_Assign_Tyler_Douglass</fullName>
        <field>OwnerId</field>
        <lookupValue>tdouglass@truckersb2b.com.wex</lookupValue>
        <lookupValueType>User</lookupValueType>
        <name>Account: Assign Tyler Douglass</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Account_B2B_Check_Processing_Fee</fullName>
        <description>Sets the check processing fee to the standard TruckersB2B fee</description>
        <field>Check_Processing_Fee__c</field>
        <literalValue>12</literalValue>
        <name>Account:B2B Check Processing Fee</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Account_Dawna_Cole</fullName>
        <field>OwnerId</field>
        <lookupValue>dcole@truckersb2b.com.wex</lookupValue>
        <lookupValueType>User</lookupValueType>
        <name>Account: Dawna Cole</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Account_FTS_Plus_Check_Fee</fullName>
        <field>Check_Processing_Fee__c</field>
        <literalValue>8</literalValue>
        <name>Account: FTS Plus Check Fee</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Account_Fax_Via_Email</fullName>
        <description>Send faxes via an email address</description>
        <field>Email__c</field>
        <formula>SUBSTITUTE(SUBSTITUTE(SUBSTITUTE(SUBSTITUTE(Fax, &quot;(&quot;, &quot;&quot;), &quot;)&quot;, &quot;&quot;), &quot; &quot;, &quot;&quot;), &quot;-&quot;, &quot;&quot;) &amp; &quot;@api.westfax.com&quot;</formula>
        <name>Account:Fax Via Email</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Account_Hearsource_1800_Sweeper</fullName>
        <field>Hearsource__c</field>
        <literalValue>1800 Sweeper</literalValue>
        <name>Account:Hearsource 1800 Sweeper</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Account_Hearsource_TransAm</fullName>
        <description>Set hearsource to TransAm</description>
        <field>Hearsource__c</field>
        <literalValue>TransAm</literalValue>
        <name>Account:Hearsource TransAm</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Account_Interstate_Private_Label</fullName>
        <field>Private_Label_Program__c</field>
        <literalValue>Interstate Capital</literalValue>
        <name>Account: Interstate Private Label</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Account_Lead_Commission_TransAm</fullName>
        <description>Set the lead commission as TransAm</description>
        <field>Lead_Commission__c</field>
        <literalValue>TransAm</literalValue>
        <name>Account:Lead Commission TransAm</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Account_NPGA_Lead_Commission</fullName>
        <description>Set the lead commission to NPGA</description>
        <field>Lead_Commission__c</field>
        <literalValue>NPGA</literalValue>
        <name>Account:NPGA Lead Commission</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Account_Not_Created_From_Lead_Convert</fullName>
        <description>Account has not been created from Lead convert, as Account already exists. Overwrite value populated by field mapping</description>
        <field>Created_From_Lead_Convert__c</field>
        <literalValue>0</literalValue>
        <name>Account Not Created From Lead Convert</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Account_Type_Update_WEX_Managed</fullName>
        <description>Update the Account Type to WEX MANAGED ACCOUNT if owner role is Account Executive, Account Manager, or Relationship Manager (East)</description>
        <field>Type</field>
        <literalValue>WEX Managed Account</literalValue>
        <name>Account Type Update (WEX Managed)</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Account_Update_Member_Signup_Date</fullName>
        <field>Member_Signup_Date__c</field>
        <formula>TODAY()</formula>
        <name>Account: Update Member Signup Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Account_lead_Commission_Interstate</fullName>
        <description>set the lead commission as Interstate when hear source is selected or private label = Interstate</description>
        <field>Lead_Commission__c</field>
        <literalValue>Interstate Capital</literalValue>
        <name>Account:lead Commission Interstate</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Billing_to_Shipping_City</fullName>
        <field>ShippingCity</field>
        <formula>BillingCity</formula>
        <name>Billing to Shipping City</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Billing_to_Shipping_Country</fullName>
        <field>ShippingCountry</field>
        <formula>BillingCountry</formula>
        <name>Billing to Shipping Country</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Billing_to_Shipping_State</fullName>
        <field>ShippingState</field>
        <formula>BillingState</formula>
        <name>Billing to Shipping State</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Billing_to_Shipping_Street</fullName>
        <field>ShippingStreet</field>
        <formula>BillingStreet</formula>
        <name>Billing to Shipping Street</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Billing_to_Shipping_ZipCode</fullName>
        <field>ShippingPostalCode</field>
        <formula>BillingPostalCode</formula>
        <name>Billing to Shipping ZipCode</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CPS_Account_Name</fullName>
        <field>Name</field>
        <formula>IF(or( 
RecordTypeId=&quot;012700000005fy6&quot;, 
RecordTypeId=&quot;012700000005fxw&quot;, 
RecordTypeId=&quot;012700000005fy1&quot;, 
RecordTypeId=&quot;012700000005fxr&quot;), 

Name &amp;&quot; CPS&quot;, Name )</formula>
        <name>CPS Account Name</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CPS_Account_Type_Update</fullName>
        <field>RecordTypeId</field>
        <lookupValue>CPS_Accounts</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>CPS Account Type Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Change_Account_To_Customer</fullName>
        <field>Type</field>
        <literalValue>Customer</literalValue>
        <name>Change Account To Customer</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Change_Acct_Record_Type_to_Fleet</fullName>
        <description>Change the Account Record Type to &quot;Fleet&quot;</description>
        <field>RecordTypeId</field>
        <lookupValue>Fleet_Account</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Change Acct Record Type to Fleet</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Circle_K_Account_Name</fullName>
        <field>Name</field>
        <formula>IF( RecordTypeId =&quot;012700000005fxh&quot;,Name &amp; &quot; Circle K&quot;, Name)</formula>
        <name>Circle K Account Name</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Created_By_Partner_GE_Capital</fullName>
        <field>Created_by_Partner_Tag__c</field>
        <formula>&quot;GE Capital&quot;</formula>
        <name>Tag Partner GE Capital</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Credit_Limit_Approved_Local</fullName>
        <field>forseva1__Credit_Limit_Approved__c</field>
        <formula>(
IF(forseva1__Credit_Quality_Rating__c  = 10, 10000,
IF(forseva1__Credit_Quality_Rating__c &gt; 9.5, 9000,
IF(forseva1__Credit_Quality_Rating__c &gt; 9.0, 8000,
IF(forseva1__Credit_Quality_Rating__c &gt; 8.5, 7000,
IF(forseva1__Credit_Quality_Rating__c &gt; 8.0, 5000,
IF(forseva1__Credit_Quality_Rating__c &gt; 7.5, 4000,
IF(forseva1__Credit_Quality_Rating__c &gt; 7.0, 3000,
IF(forseva1__Credit_Quality_Rating__c &gt; 6.5, 2000,
IF(forseva1__Credit_Quality_Rating__c &gt; 6.0, 1000,
IF(forseva1__Credit_Quality_Rating__c &gt;= 0, 0, 0))))))))))
)</formula>
        <name>Credit Limit Approved Local</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Credit_Limit_Approved_OTR</fullName>
        <field>forseva1__Credit_Limit_Approved__c</field>
        <formula>MIN(2500  *  Number_of_Vehicles__c ,
( 
IF(forseva1__Credit_Quality_Rating__c = 10, 10000, 
IF(forseva1__Credit_Quality_Rating__c &gt; 9.5, 9000, 
IF(forseva1__Credit_Quality_Rating__c &gt; 9.0, 8000, 
IF(forseva1__Credit_Quality_Rating__c &gt; 8.5, 7000, 
IF(forseva1__Credit_Quality_Rating__c &gt; 8.0, 5000, 
IF(forseva1__Credit_Quality_Rating__c &gt; 7.5, 4000, 
IF(forseva1__Credit_Quality_Rating__c &gt; 7.0, 3000, 
IF(forseva1__Credit_Quality_Rating__c &gt; 6.5, 2000, 
IF(forseva1__Credit_Quality_Rating__c &gt; 6.0, 1000, 
IF(forseva1__Credit_Quality_Rating__c &gt;= 0, 0, 0)))))))))) 
)
)</formula>
        <name>Credit Limit Approved OTR</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Credit_Limit_Effective_Date_Today</fullName>
        <field>forseva1__Credit_Limit_Effective_Date__c</field>
        <formula>Today ()</formula>
        <name>Credit Limit Effective Date = Today</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Credit_Limit_Expiration_Date_1_Year</fullName>
        <field>forseva1__Credit_Limit_Expiration_Date__c</field>
        <formula>Today () + 365</formula>
        <name>Credit Limit Expiration Date = 1 Year</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Duns_Number_Default</fullName>
        <field>DUNS_Number__c</field>
        <formula>&quot;000000000&quot;</formula>
        <name>Duns Number Default</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>EMAP_Send_Account_to_IFCS</fullName>
        <description>Send Account to IFCS</description>
        <field>Send_Credit_to_IFCS__c</field>
        <literalValue>1</literalValue>
        <name>EMAP Send Account to IFCS</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>EMAP_Turn_off_Send_to_IFCS</fullName>
        <description>Turn off Send to IFCS</description>
        <field>Is_sent_to_IFCS__c</field>
        <literalValue>0</literalValue>
        <name>EMAP Turn off Send to IFCS</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>EMAP_Turn_off_Send_to_IFCS_Btn</fullName>
        <description>Turn off Send to IFCS Btn</description>
        <field>Send_to_IFCS_clicked__c</field>
        <literalValue>0</literalValue>
        <name>EMAP Turn off Send to IFCS Btn</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>EMAP_Turn_on_Send_to_IFCS</fullName>
        <field>Is_sent_to_IFCS__c</field>
        <literalValue>1</literalValue>
        <name>EMAP Turn on Send to IFCS</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>EMAP_Update_Account_Controller_as_EMTC</fullName>
        <description>If TEL (Aggregated TEL)  &gt; USD $50K then Account Controller = EMTC</description>
        <field>Account_Controller__c</field>
        <literalValue>EMTC</literalValue>
        <name>EMAP Update Account Controller as EMTC</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>EMAP_Update_Account_Controller_as_WEX</fullName>
        <description>If TEL (Aggregated TEL)  =&lt; USD $50K then Account Controller = WEX</description>
        <field>Account_Controller__c</field>
        <literalValue>WEX</literalValue>
        <name>EMAP Update Account Controller as WEX</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>EMAP_Update_Account_Status</fullName>
        <description>Update Account Status after IFCS delta update</description>
        <field>Status__c</field>
        <literalValue>1 - Active</literalValue>
        <name>EMAP Update Account Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>EMAP_Update_Account_Sub_status</fullName>
        <description>Update Account Sub-status after IFCS delta update</description>
        <field>Account_Sub_Status__c</field>
        <literalValue>Active</literalValue>
        <name>EMAP Update Account Sub-status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>EMAP_Update_Blocked_Account_Status</fullName>
        <description>Update blocked account status to Active</description>
        <field>Status__c</field>
        <literalValue>1 - Active</literalValue>
        <name>EMAP Update Blocked Account Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>EMAP_Update_Blocked_Account_Sub_status</fullName>
        <description>Update Blocked Account Sub-status to ACtive</description>
        <field>Account_Sub_Status__c</field>
        <literalValue>Active</literalValue>
        <name>EMAP Update Blocked Account Sub-status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>EMAP_Update_Date_Account_Received_in_SF</fullName>
        <description>This is the date salesforce received its first update from IFCS</description>
        <field>Date_Account_Received_in_Salesforce__c</field>
        <formula>NOW()</formula>
        <name>EMAP Update Date Account Received in SF</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>EMAP_Update_Total_Security_Value_History</fullName>
        <description>Update Total Security Value Track History</description>
        <field>Total_Security_Value_Track_History__c</field>
        <formula>Total_Security_Value__c</formula>
        <name>EMAP Update Total Security Value History</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Exxon_Mobil_Account_Name</fullName>
        <field>Name</field>
        <formula>IF( RecordTypeId =&quot;012700000005fxc&quot;,Name &amp; &quot;  Exxon Mobil&quot;, Name)</formula>
        <name>Exxon Mobil Account Name</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>International_Account_Name</fullName>
        <field>Name</field>
        <formula>IF( RecordTypeId =&quot;012700000005jA9&quot;,Name &amp; &quot; International&quot;, Name)</formula>
        <name>International Account Name</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Pac_Pride_Jason_s_Territories</fullName>
        <field>Territory__c</field>
        <literalValue>Cole</literalValue>
        <name>Pac Pride Jason&apos;s Territories</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Pac_Pride_Marcia_s_Territories</fullName>
        <field>Territory__c</field>
        <literalValue>Pollard</literalValue>
        <name>Pac Pride Marcia&apos;s Territories</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Pac_Pride_Roger_s_Territories</fullName>
        <field>Territory__c</field>
        <literalValue>Rolewicz</literalValue>
        <name>Pac Pride Roger&apos;s Territories</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Pacific_Pride_Account_Name</fullName>
        <field>Name</field>
        <formula>IF( RecordTypeId =&quot;012700000005g15&quot;,Name &amp; &quot;  Pacific Pride&quot;, Name)</formula>
        <name>Pacific Pride Account Name</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Populate_Card_Program_WF_TXT</fullName>
        <description>When there&apos;s a value in the Card Program field, copy it to Card Program WF TXT.</description>
        <field>Card_Program_WF_TXT__c</field>
        <formula>Card_Program__r.Name</formula>
        <name>Populate Card Program WF TXT</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Remove_Assigned_RM</fullName>
        <description>Assigned RM no longer needed once they are the Account owner</description>
        <field>Assigned_Relationship_Manager__c</field>
        <name>Remove Assigned RM</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Reset_Send_App_to_IFCS</fullName>
        <description>Set the Send App to IFCS field to false if it is true.  This basically resets it once the value is updated to true so that it can be triggered again.</description>
        <field>Send_App_to_IFCS__c</field>
        <literalValue>0</literalValue>
        <name>Reset Send App to IFCS</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Reset_Send_Credit_to_IFCS</fullName>
        <description>Set the Send Credit to IFCS field to false if it is true. This basically resets it once the value is updated to true so that it can be triggered again.</description>
        <field>Send_Credit_to_IFCS__c</field>
        <literalValue>0</literalValue>
        <name>Reset Send Credit to IFCS</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Reset_Send_HK_Account_to_IFCS</fullName>
        <description>Reset Send HK Account to IFCS checkbox to true</description>
        <field>Send_HK_Account_to_IFCS__c</field>
        <literalValue>0</literalValue>
        <name>Reset Send HK Account to IFCS</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Reset_Send_Late_Payer_and_Dishonour</fullName>
        <description>Reset &apos;Send Late Payer and Dishonour to IFCS&apos; field to false</description>
        <field>Send_Late_Payer_and_Dishonour_to_IFCS__c</field>
        <literalValue>0</literalValue>
        <name>Reset Send Late Payer and Dishonour</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Reset_Send_SG_Account_to_IFCS</fullName>
        <description>Reset Send Singapore Account to IFCS checkbox to false</description>
        <field>Send_SG_Account_to_IFCS__c</field>
        <literalValue>0</literalValue>
        <name>Reset Send SG Account to IFCS</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Reset_Send_to_IFCS</fullName>
        <field>Send_WES_to_IFCS__c</field>
        <literalValue>0</literalValue>
        <name>Reset Send to IFCS</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SIC_Code_Update_Blank</fullName>
        <field>Sic</field>
        <name>SIC Code Update Blank</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Adam_Aurich_Owner</fullName>
        <field>OwnerId</field>
        <lookupValue>aaurich@truckersb2b.com.wex</lookupValue>
        <lookupValueType>User</lookupValueType>
        <name>Set Adam Aurich Owner</name>
        <notifyAssignee>true</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Dawna_Cole_Owner</fullName>
        <field>OwnerId</field>
        <lookupValue>dcole@truckersb2b.com.wex</lookupValue>
        <lookupValueType>User</lookupValueType>
        <name>Set Dawna Cole Owner</name>
        <notifyAssignee>true</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Ian_Wilkinson_Owner</fullName>
        <field>OwnerId</field>
        <lookupValue>ian.wilkinson@efsllc.com.wex</lookupValue>
        <lookupValueType>User</lookupValueType>
        <name>Set Ian Wilkinson Owner</name>
        <notifyAssignee>true</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Tyler_Douglass_Owner</fullName>
        <field>OwnerId</field>
        <lookupValue>tdouglass@truckersb2b.com.wex</lookupValue>
        <lookupValueType>User</lookupValueType>
        <name>Set Tyler  Douglass Owner</name>
        <notifyAssignee>true</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Sunoco_Account_Name</fullName>
        <field>Name</field>
        <formula>IF( RecordTypeId =&quot;012700000005fxm&quot;,Name &amp; &quot;  Sunoco&quot;, Name)</formula>
        <name>Sunoco Account Name</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Tag_CenterFire_Account</fullName>
        <field>Created_by_Partner_Tag__c</field>
        <formula>&apos;CenterFire&apos;</formula>
        <name>Tag CenterFire Account</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
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
        <fullName>Tag_Partner_Aable_iFleet</fullName>
        <field>Created_by_Partner_Tag__c</field>
        <formula>&quot;Aable iFleet&quot;</formula>
        <name>Tag Partner Aable iFleet</name>
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
        <fullName>Tag_Partner_Ambest</fullName>
        <field>Created_by_Partner_Tag__c</field>
        <formula>&quot;AMBEST&quot;</formula>
        <name>Tag Partner Ambest</name>
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
        <fullName>Tag_Partner_D_S_Supoort</fullName>
        <field>Created_by_Partner_Tag__c</field>
        <formula>&quot;D&amp;S Support&quot;</formula>
        <name>Tag Partner D&amp;S Supoort</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Tag_Partner_DandS_Fuel_Card</fullName>
        <field>Created_by_Partner_Tag__c</field>
        <formula>&quot;D&amp;S Fuel Card&quot;</formula>
        <name>Tag Partner D&amp;S Fuel Card</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
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
        <description>Populate the &quot;Created by Partner Tag&quot; Account text field with the name &quot;ENGS Commercial Capital&quot;</description>
        <field>Created_by_Partner_Tag__c</field>
        <formula>&quot;ENGS Commercial Capital&quot;</formula>
        <name>Tag Partner ENGS Commercial Capital</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Tag_Partner_England_Logistics</fullName>
        <field>Created_by_Partner_Tag__c</field>
        <formula>&quot;England Logistics&quot;</formula>
        <name>Tag Partner England Logistics</name>
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
        <fullName>Tag_Partner_Jessie_Singh</fullName>
        <description>Populate the &quot;Created by Partner Tag&quot; Account text field with the name &quot;Jessie Singh&quot;</description>
        <field>Created_by_Partner_Tag__c</field>
        <formula>&quot;Jessie Singh&quot;</formula>
        <name>Tag Partner Jessie Singh</name>
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
        <fullName>Tag_Partner_Mike_Gordon</fullName>
        <description>Populate the &quot;Created by Partner Tag&quot; Account text field with the name &quot;Mike Gordon&quot;</description>
        <field>Created_by_Partner_Tag__c</field>
        <formula>&quot;Mike Gordon&quot;</formula>
        <name>Tag Partner Mike Gordon</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Tag_Partner_Milos</fullName>
        <field>Created_by_Partner_Tag__c</field>
        <formula>&apos;Milos Pavlovic&apos;</formula>
        <name>Tag Partner Milos</name>
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
        <fullName>Tag_Partner_PTP_Stop_NATSN</fullName>
        <field>Created_by_Partner_Tag__c</field>
        <formula>&quot;PTP Stop NATSN&quot;</formula>
        <name>Tag Partner PTP Stop NATSN</name>
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
        <fullName>Tag_Partner_Pavestone_Capital</fullName>
        <field>Created_by_Partner_Tag__c</field>
        <formula>&quot;Pavestone Capital&quot;</formula>
        <name>Tag Partner Pavestone Capital</name>
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
        <fullName>Tag_Partner_PrePass</fullName>
        <field>Created_by_Partner_Tag__c</field>
        <formula>&quot;PrePass&quot;</formula>
        <name>Tag Partner PrePass</name>
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
        <fullName>Tag_Partner_Rick_Albright</fullName>
        <description>Populate the &quot;Created by Partner Tag&quot; Account text field with the name &quot;Rick Albright&quot;</description>
        <field>Created_by_Partner_Tag__c</field>
        <formula>&quot;Rick Albright&quot;</formula>
        <name>Tag Partner Rick Albright</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Tag_Partner_Roady_s_Card</fullName>
        <field>Created_by_Partner_Tag__c</field>
        <formula>&quot;Roady&apos;s Card&quot;</formula>
        <name>Tag Partner Roady&apos;s Card</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Tag_Partner_SUMMAR</fullName>
        <description>Populate the &quot;Created by Partner Tag&quot; Account text field with the name &quot;SUMMAR&quot;</description>
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
        <description>Populate the &quot;Created by Partner Tag&quot; Account text field with the name &quot;TRIUMPH BUSINESS CAPITAL&quot;</description>
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
        <fullName>Tag_Partner_Truckers_B2B</fullName>
        <field>Created_by_Partner_Tag__c</field>
        <formula>&quot;Truckers B2B&quot;</formula>
        <name>Tag Partner Truckers B2B</name>
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
        <fullName>Tag_Partner_Trulos</fullName>
        <field>Created_by_Partner_Tag__c</field>
        <formula>&quot;Trulos&quot;</formula>
        <name>Tag Partner Trulos</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Tag_Partner_Vero_Business_Capital</fullName>
        <description>Populate the &quot;Created by Partner Tag&quot; Account text field with the name &quot;Vero Business Capital&quot;</description>
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
        <fullName>Tag_Partner_Zach</fullName>
        <field>Created_by_Partner_Tag__c</field>
        <formula>&apos;Zach Wall&apos;</formula>
        <name>Tag Partner Zach</name>
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
        <fullName>Tag_Patriot_Fleet_Systems</fullName>
        <field>Created_by_Partner_Tag__c</field>
        <formula>&apos;Patriot Fleet Systems&apos;</formula>
        <name>Tag Patriot Fleet Systems</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Tag_TBS</fullName>
        <field>Created_by_Partner_Tag__c</field>
        <formula>&apos;TBS Factoring Service&apos;</formula>
        <name>Tag TBS Factoring Service</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Tag_XPO_Logistics_Account</fullName>
        <field>Created_by_Partner_Tag__c</field>
        <formula>&apos;XPO Logistics&apos;</formula>
        <name>Tag XPO Logistics Account</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Telapoint_Account_Name</fullName>
        <field>Name</field>
        <formula>IF( RecordTypeId =&quot;012700000005gEE&quot;,Name &amp; &quot; Telapoint&quot;, Name)</formula>
        <name>Telapoint Account Name</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Carrier_ID_Added</fullName>
        <field>Carrier_ID_Added__c</field>
        <formula>TODAY()</formula>
        <name>Update Carrier ID Added</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>WES_Set_Account_ID</fullName>
        <description>Sets the Account ID to the IFCS Record ID</description>
        <field>Account_Id__c</field>
        <formula>IFCS__c</formula>
        <name>WES - Set Account ID</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>WES_Set_Billing_City</fullName>
        <field>BillingCity</field>
        <formula>Physical_City__c</formula>
        <name>WES - Set Billing City</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>WES_Set_Billing_Country</fullName>
        <field>BillingCountry</field>
        <formula>TEXT(WES_ISO_Country_Code__c)</formula>
        <name>WES - Set Billing Country</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>WES_Set_Billing_Postcode</fullName>
        <field>Physical_Zip_Postal_Code__c</field>
        <formula>Physical_Zip_Postal_Code__c</formula>
        <name>WES - Set Billing Postcode</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>WES_Set_Billing_State</fullName>
        <field>BillingState</field>
        <formula>Physical_State__c</formula>
        <name>WES - Set Billing State</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>WES_Set_Primary_Account_Number</fullName>
        <description>Copies the IFCS Record ID to the Account ID and Primary Account ID for WES Accounts</description>
        <field>AccountNumber</field>
        <formula>IFCS__c</formula>
        <name>WES - Set Primary Account Number</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>WES_Set_Trading_Street_on_Account</fullName>
        <field>BillingStreet</field>
        <formula>Physical_Street_Address__c&amp;BR()&amp;
WES_Address_Line2__c&amp;BR()&amp;
WES_Address_Line3__c</formula>
        <name>WES - Set Billing Street</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <outboundMessages>
        <fullName>Credit_Decision_to_IFCS_Day_0</fullName>
        <apiVersion>35.0</apiVersion>
        <description>Credit Decision Batch Job for Singapore Data Migration</description>
        <endpointUrl>https://ie-apac.prod.emea.wexinc.co.uk/consumer/Exxon/BusinessConnect</endpointUrl>
        <fields>Behavioural_Score__c</fields>
        <fields>Client_Id__c</fields>
        <fields>Credit_Limit_Lcy__c</fields>
        <fields>IFCS__c</fields>
        <fields>Id</fields>
        <fields>Risk_Grade__c</fields>
        <fields>Security_Indicator__c</fields>
        <fields>Temporary_Credit_Expire_Date__c</fields>
        <fields>Temporary_Credit_Limit__c</fields>
        <fields>Temporary_Credit_Reason__c</fields>
        <fields>Total_Exposure_Limit_USD__c</fields>
        <fields>Total_Security_Value__c</fields>
        <includeSessionId>true</includeSessionId>
        <integrationUser>salesforce@wrightexpress.com</integrationUser>
        <name>Credit Decision to IFCS Day 0</name>
        <protected>false</protected>
        <useDeadLetterQueue>true</useDeadLetterQueue>
    </outboundMessages>
    <outboundMessages>
        <fullName>Credit_to_IFCS</fullName>
        <apiVersion>32.0</apiVersion>
        <description>This message sends the necessary data elements to IFCS to update an account</description>
        <endpointUrl>https://ie-apac.prod.emea.wexinc.co.uk/consumer/Exxon/BusinessConnect</endpointUrl>
        <fields>Account_Sub_Status__c</fields>
        <fields>Behavioural_Score__c</fields>
        <fields>Client_Id__c</fields>
        <fields>Credit_Limit_Lcy__c</fields>
        <fields>IFCS__c</fields>
        <fields>Id</fields>
        <fields>LastModifiedDate</fields>
        <fields>Risk_Grade__c</fields>
        <fields>Security_Indicator__c</fields>
        <fields>Status__c</fields>
        <fields>Temporary_Credit_Expire_Date__c</fields>
        <fields>Temporary_Credit_Limit__c</fields>
        <fields>Temporary_Credit_Reason__c</fields>
        <fields>Total_Exposure_Limit_USD__c</fields>
        <fields>Total_Security_Value__c</fields>
        <includeSessionId>true</includeSessionId>
        <integrationUser>salesforce@wrightexpress.com</integrationUser>
        <name>Credit to IFCS</name>
        <protected>false</protected>
        <useDeadLetterQueue>true</useDeadLetterQueue>
    </outboundMessages>
    <outboundMessages>
        <fullName>WexUK_Account_to_IFCS</fullName>
        <apiVersion>37.0</apiVersion>
        <endpointUrl>https://www.prod.emea.wexinc.co.uk:8101/consumer/WES/BusinessConnect/CreditUpdate?wsdl</endpointUrl>
        <fields>AccountNumber</fields>
        <fields>Account_Sub_Status__c</fields>
        <fields>Id</fields>
        <fields>Insured_Credit_limit__c</fields>
        <fields>Overall_Credit_limit_WES__c</fields>
        <fields>Risk_Grade_UK__c</fields>
        <fields>Security_Limit__c</fields>
        <fields>Security_Type__c</fields>
        <fields>Status__c</fields>
        <fields>Temporary_Credit_Expire_Date__c</fields>
        <fields>Temporary_Credit_Reason__c</fields>
        <fields>WES_Temporary_Credit_Limit__c</fields>
        <fields>forseva1__Credit_Limit_Effective_Date__c</fields>
        <includeSessionId>false</includeSessionId>
        <integrationUser>rbeattie@wrightexpress.com</integrationUser>
        <name>WexUK Account to IFCS</name>
        <protected>false</protected>
        <useDeadLetterQueue>true</useDeadLetterQueue>
    </outboundMessages>
    <rules>
        <fullName>AU Account%3A Update Shipping with Postal Address</fullName>
        <actions>
            <name>AU_Account_Shipping_Postcode_with_Posta</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>AU_Account_Shipping_State_with_Postal</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>AU_Account_Shipping_Suburb_with_Postal</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>AU_Account_Update_Shipping_with_Postal</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <booleanFilter>1 AND (2 OR 3 OR 4 OR 5)</booleanFilter>
        <criteriaItems>
            <field>Account.RecordTypeId</field>
            <operation>equals</operation>
            <value>AU Fuel Customer,AU Fuel Merchant,AU Prepaid Customer,AU VCC</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.AU_Postal_Address__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Account.AU_Postal_Suburb__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Account.AU_Postal_State__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Account.AU_Postal_Postcode__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Updates the Shipping Address to the Postal</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Account Owner Changed To RM</fullName>
        <actions>
            <name>Change_Account_To_Customer</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Virtual record types only</description>
        <formula>AND(    RecordType.DeveloperName = &apos;CorporatePay_Accounts&apos;,   ISCHANGED(OwnerId),   OR(     Owner.UserRoleId = &apos;00E70000001LilO&apos;,     Owner.UserRoleId = &apos;00E70000001LilJ&apos;   ),   OR(      Owner.UserRoleId = &apos;00E70000001LtCA&apos;,      Owner.UserRoleId = &apos;00E70000001LtCF&apos;   ) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Account Type - Ex-Customer</fullName>
        <actions>
            <name>Account_Type_Ex_Customer</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Wex Europe record types only</description>
        <formula>AND(
/* CorporatePay Accounts */
RecordTypeId = &apos;012700000005oqE&apos;,

/* CorporatePay Relationship Manager */
Owner.UserRoleId = &apos;00E70000001LtCF&apos;,

TEXT(Type) = &apos;Ex-Customer&apos;
)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Account%3AB2B Member</fullName>
        <actions>
            <name>Account_B2B_Check_Processing_Fee</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Account has become a TruckersB2B member</description>
        <formula>ISCHANGED( Status__c ) &amp;&amp; ISPICKVAL(Status__c , &quot;Member&quot;) &amp;&amp; ISPICKVAL(Private_Label_Program__c, &quot;&quot;) &amp;&amp;  CONTAINS(RecordType.Name, &quot;Truckers&quot;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Account%3AFTS Plus Member</fullName>
        <actions>
            <name>Account_FTS_Plus_Check_Fee</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Account has become a FTS Plus member for Truckers</description>
        <formula>ISCHANGED(Status__c ) &amp;&amp; ISPICKVAL(Status__c , &quot;Member&quot;) &amp;&amp; ISPICKVAL(Private_Label_Program__c, &quot;FTS Plus&quot;) &amp;&amp; CONTAINS(RecordType.Name, &quot;Truckers&quot;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Account%3AHeasource Interstate</fullName>
        <actions>
            <name>Account_Interstate_Private_Label</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Account_lead_Commission_Interstate</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.RecordTypeId</field>
            <operation>equals</operation>
            <value>Truckers - Accounts</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Hearsource__c</field>
            <operation>equals</operation>
            <value>Interstate Capital</value>
        </criteriaItems>
        <description>An account has a hearsource of Interstate on creation for Truckers</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Account%3AHeasource NPGA</fullName>
        <actions>
            <name>Account_NPGA_Lead_Commission</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.RecordTypeId</field>
            <operation>equals</operation>
            <value>Truckers - Accounts</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Hearsource__c</field>
            <operation>equals</operation>
            <value>NPGA</value>
        </criteriaItems>
        <description>An account has a hearsource of NPGA on creation for Truckers</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Account%3ANew Member Black</fullName>
        <actions>
            <name>B2B_Welcome_Email</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Account_Assign_Ian_Wilkinson</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>WF_Rule_Email_Sent</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.Status__c</field>
            <operation>equals</operation>
            <value>Member</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Region__c</field>
            <operation>equals</operation>
            <value>Black</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Private_Label_Program__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Hearsource__c</field>
            <operation>notEqual</operation>
            <value>E-Capital,ECS</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.RecordTypeId</field>
            <operation>equals</operation>
            <value>Truckers - Accounts</value>
        </criteriaItems>
        <description>An account becomes a TruckersB2B member in the Black region</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Routine_Followup</name>
                <type>Task</type>
            </actions>
            <offsetFromField>Account.CreatedDate</offsetFromField>
            <timeLength>120</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Account%3ANew Member Burgundy</fullName>
        <actions>
            <name>B2B_Welcome_Email</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Account_Assign_Adam_Aurich</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>WF_Rule_Email_Sent</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.Status__c</field>
            <operation>equals</operation>
            <value>Member</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Region__c</field>
            <operation>equals</operation>
            <value>Burgundy</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Private_Label_Program__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Hearsource__c</field>
            <operation>notEqual</operation>
            <value>E-Capital,ECS</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.RecordTypeId</field>
            <operation>equals</operation>
            <value>Truckers - Accounts</value>
        </criteriaItems>
        <description>An account becomes a TruckersB2B member in the Burgundy region</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Routine_Followup</name>
                <type>Task</type>
            </actions>
            <offsetFromField>Account.CreatedDate</offsetFromField>
            <timeLength>120</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Account%3ANew Member E-Capital</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Account.RecordTypeId</field>
            <operation>equals</operation>
            <value>Truckers - Accounts</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Status__c</field>
            <operation>equals</operation>
            <value>Member</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Hearsource__c</field>
            <operation>equals</operation>
            <value>E-Capital</value>
        </criteriaItems>
        <description>An account becomes a TruckersB2B member E-Capital</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Email_New_E_Capital_Members</name>
                <type>Alert</type>
            </actions>
            <timeLength>14</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>ECapital_Welcome_Call</name>
                <type>Task</type>
            </actions>
            <timeLength>90</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Account%3ANew Member FTS - Black</fullName>
        <actions>
            <name>FTS_Welcome_Email</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Set_Ian_Wilkinson_Owner</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>WF_Rule_Email_Sent</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.RecordTypeId</field>
            <operation>equals</operation>
            <value>Truckers - Accounts</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Status__c</field>
            <operation>equals</operation>
            <value>Member</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Private_Label_Program__c</field>
            <operation>equals</operation>
            <value>FTS Plus</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Region__c</field>
            <operation>contains</operation>
            <value>Black</value>
        </criteriaItems>
        <description>An account becomes a TruckersB2B member in the FTS region</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>FTS_Gold_Program_Overview</name>
                <type>Alert</type>
            </actions>
            <actions>
                <name>FTS_Welcome_Call</name>
                <type>Task</type>
            </actions>
            <actions>
                <name>WF_Rule_Email_Sent</name>
                <type>Task</type>
            </actions>
            <timeLength>30</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>FTS_Savings_Reminder</name>
                <type>Alert</type>
            </actions>
            <actions>
                <name>WF_Rule_Email_Sent</name>
                <type>Task</type>
            </actions>
            <timeLength>90</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>Routine_Followup</name>
                <type>Task</type>
            </actions>
            <timeLength>270</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Account%3ANew Member FTS - Burgundy</fullName>
        <actions>
            <name>FTS_Welcome_Email</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Set_Adam_Aurich_Owner</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>WF_Rule_Email_Sent</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.RecordTypeId</field>
            <operation>equals</operation>
            <value>Truckers - Accounts</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Status__c</field>
            <operation>equals</operation>
            <value>Member</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Private_Label_Program__c</field>
            <operation>equals</operation>
            <value>FTS Plus</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Region__c</field>
            <operation>contains</operation>
            <value>Burgundy</value>
        </criteriaItems>
        <description>An account becomes a TruckersB2B member in the FTS region</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>FTS_Gold_Program_Overview</name>
                <type>Alert</type>
            </actions>
            <actions>
                <name>FTS_Welcome_Call</name>
                <type>Task</type>
            </actions>
            <actions>
                <name>WF_Rule_Email_Sent</name>
                <type>Task</type>
            </actions>
            <timeLength>30</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>FTS_Savings_Reminder</name>
                <type>Alert</type>
            </actions>
            <actions>
                <name>WF_Rule_Email_Sent</name>
                <type>Task</type>
            </actions>
            <timeLength>90</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>Routine_Followup</name>
                <type>Task</type>
            </actions>
            <timeLength>270</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Account%3ANew Member FTS - Grey</fullName>
        <actions>
            <name>FTS_Welcome_Email</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Set_Tyler_Douglass_Owner</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>WF_Rule_Email_Sent</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.RecordTypeId</field>
            <operation>equals</operation>
            <value>Truckers - Accounts</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Status__c</field>
            <operation>equals</operation>
            <value>Member</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Private_Label_Program__c</field>
            <operation>equals</operation>
            <value>FTS Plus</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Region__c</field>
            <operation>contains</operation>
            <value>Grey</value>
        </criteriaItems>
        <description>An account becomes a TruckersB2B member in the FTS region</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>FTS_Gold_Program_Overview</name>
                <type>Alert</type>
            </actions>
            <actions>
                <name>FTS_Welcome_Call</name>
                <type>Task</type>
            </actions>
            <actions>
                <name>WF_Rule_Email_Sent</name>
                <type>Task</type>
            </actions>
            <timeLength>30</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>FTS_Savings_Reminder</name>
                <type>Alert</type>
            </actions>
            <actions>
                <name>WF_Rule_Email_Sent</name>
                <type>Task</type>
            </actions>
            <timeLength>90</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>Routine_Followup</name>
                <type>Task</type>
            </actions>
            <timeLength>270</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Account%3ANew Member FTSrevised</fullName>
        <actions>
            <name>FTS_Welcome_Email</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Set_Dawna_Cole_Owner</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>WF_Rule_Email_Sent</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.RecordTypeId</field>
            <operation>equals</operation>
            <value>Truckers - Accounts</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Status__c</field>
            <operation>equals</operation>
            <value>Member</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Private_Label_Program__c</field>
            <operation>equals</operation>
            <value>FTS Plus</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Region__c</field>
            <operation>contains</operation>
            <value>White</value>
        </criteriaItems>
        <description>An account becomes a TruckersB2B member in the FTS region</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>FTS_Savings_Reminder</name>
                <type>Alert</type>
            </actions>
            <actions>
                <name>WF_Rule_Email_Sent</name>
                <type>Task</type>
            </actions>
            <timeLength>90</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>FTS_Gold_Program_Overview</name>
                <type>Alert</type>
            </actions>
            <actions>
                <name>FTS_Welcome_Call</name>
                <type>Task</type>
            </actions>
            <actions>
                <name>WF_Rule_Email_Sent</name>
                <type>Task</type>
            </actions>
            <timeLength>30</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>Routine_Followup</name>
                <type>Task</type>
            </actions>
            <timeLength>270</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Account%3ANew Member Grey</fullName>
        <actions>
            <name>B2B_Welcome_Email</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Account_Assign_Tyler_Douglass</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>WF_Rule_Email_Sent</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.Status__c</field>
            <operation>equals</operation>
            <value>Member</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Region__c</field>
            <operation>equals</operation>
            <value>Grey</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Private_Label_Program__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Hearsource__c</field>
            <operation>notEqual</operation>
            <value>E-Capital,ECS</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.RecordTypeId</field>
            <operation>equals</operation>
            <value>Truckers - Accounts</value>
        </criteriaItems>
        <description>An account becomes a TruckersB2B member in the Grey region</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Routine_Followup</name>
                <type>Task</type>
            </actions>
            <offsetFromField>Account.CreatedDate</offsetFromField>
            <timeLength>120</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Account%3ANew Member Red</fullName>
        <actions>
            <name>B2B_Welcome_Email</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Account_Assign_Jennifer_Nelson</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>WF_Rule_Email_Sent</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.Status__c</field>
            <operation>equals</operation>
            <value>Member</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Region__c</field>
            <operation>equals</operation>
            <value>Red</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Private_Label_Program__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Hearsource__c</field>
            <operation>notEqual</operation>
            <value>E-Capital,ECS</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.RecordTypeId</field>
            <operation>equals</operation>
            <value>Truckers - Accounts</value>
        </criteriaItems>
        <description>An account becomes a TruckersB2B member in the Red region</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Routine_Followup</name>
                <type>Task</type>
            </actions>
            <offsetFromField>Account.CreatedDate</offsetFromField>
            <timeLength>120</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Account%3ANew Member White</fullName>
        <actions>
            <name>B2B_Welcome_Email</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Account_Dawna_Cole</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>WF_Rule_Email_Sent</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.Status__c</field>
            <operation>equals</operation>
            <value>Member</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Region__c</field>
            <operation>equals</operation>
            <value>White</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Private_Label_Program__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Hearsource__c</field>
            <operation>notEqual</operation>
            <value>E-Capital,ECS</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.RecordTypeId</field>
            <operation>equals</operation>
            <value>Truckers - Accounts</value>
        </criteriaItems>
        <description>An account becomes a TruckersB2B member in the White region</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Routine_Followup</name>
                <type>Task</type>
            </actions>
            <offsetFromField>Account.CreatedDate</offsetFromField>
            <timeLength>120</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Account%3ANo Email With Fax</fullName>
        <actions>
            <name>Account_Fax_Via_Email</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.RecordTypeId</field>
            <operation>equals</operation>
            <value>Truckers - Accounts</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Email__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Fax</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>A member doesn&apos;t have an email address, but has a fax number</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Account%3APrivateLabel 1800 Sweeper</fullName>
        <actions>
            <name>Account_Hearsource_1800_Sweeper</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.RecordTypeId</field>
            <operation>equals</operation>
            <value>Truckers - Accounts</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Private_Label_Program__c</field>
            <operation>equals</operation>
            <value>1800 Sweeper</value>
        </criteriaItems>
        <description>An account came in with the private label of 1800 Sweeper for Truckers</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Account%3APrivateLabel TransAm</fullName>
        <actions>
            <name>Account_Hearsource_TransAm</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Account_Lead_Commission_TransAm</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.RecordTypeId</field>
            <operation>equals</operation>
            <value>Truckers - Accounts</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Private_Label_Program__c</field>
            <operation>equals</operation>
            <value>TransAm</value>
        </criteriaItems>
        <description>An account came in with the private label of TransAm for Truckers</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Account%3ASet Signup Date</fullName>
        <actions>
            <name>Account_Update_Member_Signup_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Sets the member sign-up to be the date that is went to a member status</description>
        <formula>ISPICKVAL(Status__c , &quot;Member&quot;) &amp;&amp; ISNULL( Member_Signup_Date__c ) &amp;&amp; CONTAINS(RecordType.Name, &quot;Truckers&quot;)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Assigned RM Changed To Account Owner</fullName>
        <actions>
            <name>Remove_Assigned_RM</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Wex Europe record types only</description>
        <formula>AND(
/* CorporatePay Accounts */
RecordTypeId = &apos;012700000005oqE&apos;,
ISCHANGED(OwnerId),
OwnerId = Assigned_Relationship_Manager__c
)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Billing to Shipping</fullName>
        <actions>
            <name>Billing_to_Shipping_City</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Billing_to_Shipping_Country</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Billing_to_Shipping_State</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Billing_to_Shipping_Street</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Billing_to_Shipping_ZipCode</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.Same_as_Billing__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Card Program Text Field</fullName>
        <actions>
            <name>Populate_Card_Program_WF_TXT</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.Card_Program_TXT__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Need a text version of the Card Program lookup field for use in sharing rules. (can&apos;t use lookup field or formula field.)</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Carrier ID Added To Account</fullName>
        <actions>
            <name>Update_Carrier_ID_Added</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ISCHANGED(Carrier_ID__c)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Channel Acct Record Type Change</fullName>
        <actions>
            <name>Change_Acct_Record_Type_to_Fleet</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.F1_Account_Type__c</field>
            <operation>equals</operation>
            <value>Fleet</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.F1_Account_Sub_Type__c</field>
            <operation>equals</operation>
            <value>Fleet</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.RecordTypeId</field>
            <operation>equals</operation>
            <value>Channel Account</value>
        </criteriaItems>
        <description>If a Channel Record Type account is created, but the F1 Acct Type = Fleet, and the F1 Lead Sub-Type = Fleet, then change the record type to Fleet.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Credit Limit Calculation - Local</fullName>
        <actions>
            <name>Credit_Limit_Approved_Local</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Credit_Limit_Effective_Date_Today</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Credit_Limit_Expiration_Date_1_Year</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.forseva1__Credit_Quality_Rating__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Card_Product_del__c</field>
            <operation>equals</operation>
            <value>Local</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Credit Limit Calculation - OTR</fullName>
        <actions>
            <name>Credit_Limit_Approved_OTR</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Credit_Limit_Effective_Date_Today</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Credit_Limit_Expiration_Date_1_Year</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.forseva1__Credit_Quality_Rating__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Card_Product_del__c</field>
            <operation>equals</operation>
            <value>OTR,Local</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>EMAP IFCS Date Update in Salesforce</fullName>
        <actions>
            <name>EMAP_Update_Date_Account_Received_in_SF</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>This workflow will date/time stamp the Date Account Received in Salesforce field in salesforce with the current date/time when the first update is received from IFCS</description>
        <formula>AND( RecordType.Name == &apos;EMAP Fuel Accounts&apos;, ISCHANGED( IFCS__c), ISBLANK(PRIORVALUE(IFCS__c)) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>EMAP Late Payer And Dishonor Update to IFCS</fullName>
        <actions>
            <name>Reset_Send_Late_Payer_and_Dishonour</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Credit_to_IFCS</name>
            <type>OutboundMessage</type>
        </actions>
        <active>false</active>
        <description>Number of Late Payer And Dishonor count update send to IFCS</description>
        <formula>AND(   RecordType.Name  = &apos;EMAP Fuel Accounts&apos;,  Send_Late_Payer_and_Dishonour_to_IFCS__c = true, OR(  ISCHANGED( Number_of_Dishonours_in_Last_3_Months__c ),  ISCHANGED( Number_of_Late_Payments_Last_3_Months__c ) ) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>EMAP Send HK Account to IFCS</fullName>
        <actions>
            <name>Reset_Send_HK_Account_to_IFCS</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Credit_Decision_to_IFCS_Day_0</name>
            <type>OutboundMessage</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Account.RecordTypeId</field>
            <operation>equals</operation>
            <value>EMAP Fuel Accounts</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Client_Name__c</field>
            <operation>equals</operation>
            <value>ExxonMobil Hong Kong</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Send_HK_Account_to_IFCS__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>Send HK Accounts to IFCS</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>EMAP Turn off Send to IFCS</fullName>
        <actions>
            <name>EMAP_Turn_off_Send_to_IFCS</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>EMAP_Turn_off_Send_to_IFCS_Btn</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.RecordTypeId</field>
            <operation>equals</operation>
            <value>EMAP Fuel Accounts</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.LastModifiedById</field>
            <operation>notEqual</operation>
            <value>IFCS Connector</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Is_sent_to_IFCS__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.LastModifiedById</field>
            <operation>notEqual</operation>
            <value>Amit Patel</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>EMAP Turn on Send to IFCS</fullName>
        <actions>
            <name>EMAP_Turn_on_Send_to_IFCS</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>(1 OR 2) AND 3</booleanFilter>
        <criteriaItems>
            <field>Account.LastModifiedById</field>
            <operation>equals</operation>
            <value>IFCS Connector</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Send_to_IFCS_clicked__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.RecordTypeId</field>
            <operation>equals</operation>
            <value>EMAP Fuel Accounts</value>
        </criteriaItems>
        <description>Turn on Send to IFCS</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>EMAP Update Account Controller as EMTC</fullName>
        <actions>
            <name>EMAP_Update_Account_Controller_as_EMTC</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Account.RecordTypeId</field>
            <operation>equals</operation>
            <value>EMAP Fuel Accounts</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Aggregated_Tel_USD__c</field>
            <operation>greaterThan</operation>
            <value>50000</value>
        </criteriaItems>
        <description>Update Account Controller as EMTC, If TEL (Aggregated TEL) &gt; USD $50K</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>EMAP Update Account Controller as WEX</fullName>
        <actions>
            <name>EMAP_Update_Account_Controller_as_WEX</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Account.RecordTypeId</field>
            <operation>equals</operation>
            <value>EMAP Fuel Accounts</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Aggregated_Tel_USD__c</field>
            <operation>lessOrEqual</operation>
            <value>50000</value>
        </criteriaItems>
        <description>Update Account Controller as WEX, If TEL (Aggregated TEL)  =&lt; USD $50K</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>EMAP Update Account Status and Sub status</fullName>
        <actions>
            <name>EMAP_Update_Account_Status</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>EMAP_Update_Account_Sub_status</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Update Account status and sub status, once IFCS sends Account Number to SF</description>
        <formula>AND(  RecordType.Name == &apos;EMAP Fuel Accounts&apos;, NOT( ISBLANK( AU_Application_Request__c )),  NOT( ISBLANK( AU_Account_Number__c ) ) )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>EMAP Update Blocked Account status</fullName>
        <actions>
            <name>EMAP_Send_Account_to_IFCS</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>EMAP_Update_Blocked_Account_Status</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>EMAP_Update_Blocked_Account_Sub_status</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Change Account Status from Blocked to Active - When (Current Balance &lt; Credit Limit) OR (Current Balance &lt; Credit Limit + Temp Credit Limit)</description>
        <formula>AND(
RecordType.Name == &apos;EMAP Fuel Accounts&apos;,
ISPICKVAL( Status__c , &apos;9 - Temporary Locked&apos;),
ISPICKVAL( Account_Sub_Status__c , &apos;F - AutoStop&gt;Credit Limit&apos;),
OR(
AND(
ISCHANGED(Credit_Limit_Lcy__c),
AR_Current_Balance__c &lt; Credit_Limit_Lcy__c
),
AND(
ISCHANGED(Temporary_Credit_Limit__c),
AR_Current_Balance__c &lt; (Credit_Limit_Lcy__c + Temporary_Credit_Limit__c),
Temporary_Credit_Expire_Date__c &gt; TODAY()
)
)
)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>EMAP Update Child Account Controller as EMTC</fullName>
        <actions>
            <name>EMAP_Update_Account_Controller_as_EMTC</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>If Hierarchy Level = 1 or 3  and the account is Child Account then 
Look up Parent Account TEL USD
If TEL &gt; 50K then EMTC, else WEX</description>
        <formula>AND(
RecordType.Name == &apos;EMAP Fuel Accounts&apos;,
NOT(ISBLANK( ParentId )),
OR(
ISPICKVAL(Hierarchy_Level__c, &apos;01&apos;),
ISPICKVAL(Hierarchy_Level__c, &apos;03&apos;)),
AND(
NOT(ISBLANK(Parent.Aggregated_Tel_USD__c)),
Parent.Aggregated_Tel_USD__c &gt; 50000)
)</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>EMAP Update Child Account Controller as WEX</fullName>
        <actions>
            <name>EMAP_Update_Account_Controller_as_WEX</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>If Hierarchy Level = 1 or 3  and the account is Child Account then 
Look up Parent Account TEL USD
If TEL &gt; 50K then EMTC, else WEX</description>
        <formula>AND(
RecordType.Name == &apos;EMAP Fuel Accounts&apos;,
NOT(ISBLANK( ParentId )), 
OR( 
ISPICKVAL(Hierarchy_Level__c, &apos;01&apos;), 
ISPICKVAL(Hierarchy_Level__c, &apos;03&apos;) ), 
OR(
ISBLANK(Parent.Aggregated_Tel_USD__c),
Parent.Aggregated_Tel_USD__c &lt;= 50000)
)</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>EMAP Update Total Security Value History</fullName>
        <actions>
            <name>EMAP_Update_Total_Security_Value_History</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Update Total Security Value Track History</description>
        <formula>AND ( RecordType.Name == &apos;EMAP Fuel Accounts&apos;, ISCHANGED(Total_Security_Value__c ),  NOT(ISBLANK( Total_Security_Value__c )), Total_Security_Value__c &gt;= 0 )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Edge Account Welcome - White Region</fullName>
        <actions>
            <name>Set_Dawna_Cole_Owner</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.Status__c</field>
            <operation>equals</operation>
            <value>Member</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Region__c</field>
            <operation>contains</operation>
            <value>White</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Private_Label_Program__c</field>
            <operation>equals</operation>
            <value>Fleet One EDGE</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.RecordTypeId</field>
            <operation>equals</operation>
            <value>Truckers - Accounts</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Edge_Welcome_Email</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Account.CreatedDate</offsetFromField>
            <timeLength>7</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>Edge_Benefits_Call</name>
                <type>Task</type>
            </actions>
            <offsetFromField>Account.CreatedDate</offsetFromField>
            <timeLength>15</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>Gold_Program_Benefits_Email_EDGE</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Account.CreatedDate</offsetFromField>
            <timeLength>30</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Edge Account Welcome -Black Region</fullName>
        <actions>
            <name>Set_Ian_Wilkinson_Owner</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.Status__c</field>
            <operation>equals</operation>
            <value>Member</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Region__c</field>
            <operation>contains</operation>
            <value>Black</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Private_Label_Program__c</field>
            <operation>equals</operation>
            <value>Fleet One EDGE</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.RecordTypeId</field>
            <operation>equals</operation>
            <value>Truckers - Accounts</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Edge_Welcome_Email</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Account.CreatedDate</offsetFromField>
            <timeLength>7</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>Edge_Benefits_Call</name>
                <type>Task</type>
            </actions>
            <offsetFromField>Account.CreatedDate</offsetFromField>
            <timeLength>15</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>Gold_Program_Benefits_Email_EDGE</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Account.CreatedDate</offsetFromField>
            <timeLength>30</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Edge Account Welcome -Burgundy Region</fullName>
        <actions>
            <name>Set_Adam_Aurich_Owner</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.Status__c</field>
            <operation>equals</operation>
            <value>Member</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Region__c</field>
            <operation>contains</operation>
            <value>Burgundy</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Private_Label_Program__c</field>
            <operation>equals</operation>
            <value>Fleet One EDGE</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.RecordTypeId</field>
            <operation>equals</operation>
            <value>Truckers - Accounts</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Edge_Welcome_Email</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Account.CreatedDate</offsetFromField>
            <timeLength>7</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>Edge_Benefits_Call</name>
                <type>Task</type>
            </actions>
            <offsetFromField>Account.CreatedDate</offsetFromField>
            <timeLength>15</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>Gold_Program_Benefits_Email_EDGE</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Account.CreatedDate</offsetFromField>
            <timeLength>30</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Edge Account Welcome -Grey Regio</fullName>
        <actions>
            <name>Set_Tyler_Douglass_Owner</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.Status__c</field>
            <operation>equals</operation>
            <value>Member</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Region__c</field>
            <operation>contains</operation>
            <value>Grey</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Private_Label_Program__c</field>
            <operation>equals</operation>
            <value>Fleet One EDGE</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.RecordTypeId</field>
            <operation>equals</operation>
            <value>Truckers - Accounts</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Edge_Welcome_Email</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Account.CreatedDate</offsetFromField>
            <timeLength>7</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>Edge_Benefits_Call</name>
                <type>Task</type>
            </actions>
            <offsetFromField>Account.CreatedDate</offsetFromField>
            <timeLength>15</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>Gold_Program_Benefits_Email_EDGE</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Account.CreatedDate</offsetFromField>
            <timeLength>30</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>First Sale To Customer Complete</fullName>
        <actions>
            <name>Change_Account_To_Customer</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Virtual record types only</description>
        <formula>AND(   OR(     RecordType.DeveloperName = &apos;CorporatePay_Accounts&apos;,     RecordType.DeveloperName = &apos;Virtual&apos;   ),   ISCHANGED(Number_of_Won_Opportunities__c),   Number_of_Won_Opportunities__c &gt; 0,   NOT(TEXT(Type) = &apos;Customer&apos;) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Forseva Account Owner Change</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Account.OwnerId</field>
            <operation>equals</operation>
            <value>appl Site Guest User</value>
        </criteriaItems>
        <description>When Forseva creates an Account, change owner to Drew. (From &quot;appl Site Guest User&quot;)</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Forseva Credit Manager Notification</fullName>
        <actions>
            <name>Manual_Credit_Review_Needed</name>
            <type>Task</type>
        </actions>
        <active>false</active>
        <booleanFilter>1 OR 2</booleanFilter>
        <criteriaItems>
            <field>Account.forseva1__Credit_Review_Status__c</field>
            <operation>equals</operation>
            <value>Failed</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.forseva1__Credit_Review_Status__c</field>
            <operation>equals</operation>
            <value>Pending</value>
        </criteriaItems>
        <description>Forseva Implementation</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>INTEGRATION - Send Account to IFCS</fullName>
        <actions>
            <name>Reset_Send_to_IFCS</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>WexUK_Account_to_IFCS</name>
            <type>OutboundMessage</type>
        </actions>
        <active>true</active>
        <formula>IF(  AND(RecordTypeId == &apos;0120g0000009t9Y&apos;, $User.LastName != &apos;ETL&apos;,  OR(ISCHANGED(AccountNumber),ISCHANGED(Account_Sub_Status__c),ISCHANGED(Id),ISCHANGED(Insured_Credit_limit__c),ISCHANGED(Overall_Credit_limit_WES__c),ISCHANGED(Risk_Grade_UK__c)  ,ISCHANGED(Security_Limit__c),ISCHANGED(Security_Type__c),ISCHANGED(Status__c),ISCHANGED(Temporary_Credit_Expire_Date__c),ISCHANGED(Temporary_Credit_Reason__c)  ,ISCHANGED(WES_Temporary_Credit_Limit__c),ISCHANGED(forseva1__Credit_Limit_Effective_Date__c))  )  , true, false)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>INTEGRATION - Send Credit to IFCS</fullName>
        <actions>
            <name>Reset_Send_Credit_to_IFCS</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Credit_to_IFCS</name>
            <type>OutboundMessage</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.Send_Credit_to_IFCS__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.RecordTypeId</field>
            <operation>equals</operation>
            <value>EMAP Fuel Accounts</value>
        </criteriaItems>
        <description>This workflow sends a credit application to IFCS (International Fuel Card System)</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>INTEGRATION - Send to IFCS Button %28Application%29</fullName>
        <actions>
            <name>Reset_Send_App_to_IFCS</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.Send_App_to_IFCS__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.RecordTypeId</field>
            <operation>equals</operation>
            <value>EMAP Fuel Accounts</value>
        </criteriaItems>
        <description>This workflow sends a credit application to IFCS (International Fuel Card System) apon button click on the Account page.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Lead Converted - After Account Creation</fullName>
        <actions>
            <name>Account_Not_Created_From_Lead_Convert</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>/* assumption is that this field will only be changed by field mapping */
AND(
ISCHANGED(Created_From_Lead_Convert__c),
PRIORVALUE(Created_From_Lead_Convert__c) = FALSE,
NOT(ISNEW())
)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Managed Account</fullName>
        <actions>
            <name>Account_Type_Update_WEX_Managed</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>This rule will apply to any account that is managed by an AE, RM, SRM, or AM and will verify that the Account Type is set to WEX MANAGED ACCOUNT if that is the case.</description>
        <formula>AND( NOT(ISPICKVAL(Type,  &quot;Prospect&quot;)),
OR((Owner.UserRole.Name = &quot;Relationship Manager (East)&quot;), (Owner.UserRole.Name = &quot;Account Manager&quot;),
(Owner.UserRole.Name = &quot;Account Executive&quot;),
(Owner.UserRole.Name = &quot;Strategic Relationship Manager&quot;)))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Notification Coupon Code Entered</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Account.Coupon_Code__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Account.RecordTypeId</field>
            <operation>equals</operation>
            <value>Pacific Pride</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Owner Changed to 123Loadboard</fullName>
        <actions>
            <name>Tag_Partner_123Loadboard</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.OwnerId</field>
            <operation>equals</operation>
            <value>WILLIE ANDRUSS</value>
        </criteriaItems>
        <description>If anyone changes ownership of an Account to 123Loadboard partner user WILLIE ANDRUSS.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Owner Changed to 3MD</fullName>
        <actions>
            <name>Tag_Partner_Milos</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.OwnerId</field>
            <operation>equals</operation>
            <value>Milos Pavlovic</value>
        </criteriaItems>
        <description>If anyone changes ownership of an Account to 3M partner user Milos</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Owner Changed to AMBEST</fullName>
        <actions>
            <name>Tag_Partner_Ambest</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.OwnerId</field>
            <operation>equals</operation>
            <value>Matthew Miller</value>
        </criteriaItems>
        <description>If anyone changes ownership of an Account to AMBEST partner user Matthew Miller .</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Owner Changed to Aable iFleet</fullName>
        <actions>
            <name>Tag_Partner_Aable_iFleet</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.OwnerId</field>
            <operation>equals</operation>
            <value>Daniel Pesek</value>
        </criteriaItems>
        <description>If anyone changes ownership of an Account to Aable iFleet partner user Jessi Saker .</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Owner Changed to Advanced Commercial Credit</fullName>
        <actions>
            <name>Tag_Partner_Advanced_Commercial_Credit</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.OwnerId</field>
            <operation>equals</operation>
            <value>Rob Timmons</value>
        </criteriaItems>
        <description>If anyone changes ownership of an Account to Advanced Commercial Credit partner user Rob Timmons.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Owner Changed to Aladdin Financial</fullName>
        <actions>
            <name>Tag_Partner_Aladdin_Financial</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.OwnerId</field>
            <operation>equals</operation>
            <value>Jay Larson</value>
        </criteriaItems>
        <description>If anyone changes ownership of an Account to Aladdin Financial partner user Jay Larson.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Owner Changed to CJM Financial</fullName>
        <actions>
            <name>Tag_Partner_CJM_Financial</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.OwnerId</field>
            <operation>equals</operation>
            <value>TRENT MURPHY</value>
        </criteriaItems>
        <description>If anyone changes ownership of an Account to CJM Financial partner user TRENT MURPHY.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Owner Changed to CenterFire</fullName>
        <actions>
            <name>Tag_CenterFire_Account</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.OwnerId</field>
            <operation>equals</operation>
            <value>Justin Heim</value>
        </criteriaItems>
        <description>If anyone changes ownership of an Account to Justin Heim</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Owner Changed to Commercial Funding</fullName>
        <actions>
            <name>Tag_Partner_Commercial_Funding</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.OwnerId</field>
            <operation>equals</operation>
            <value>Julie Murphy</value>
        </criteriaItems>
        <description>If anyone changes ownership of an Account to Commercial Funding partner user Julie Murphy.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Owner Changed to CoreFund Capital</fullName>
        <actions>
            <name>Tag_Partner_CoreFund_Capital</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.OwnerId</field>
            <operation>equals</operation>
            <value>Bonnie Castillo</value>
        </criteriaItems>
        <description>If anyone changes ownership of an Account to CoreFund Capital partner user Patti Mielke.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Owner Changed to D%26S Fuel Card</fullName>
        <actions>
            <name>Tag_Partner_DandS_Fuel_Card</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.OwnerId</field>
            <operation>equals</operation>
            <value>D&amp;S Fuel Card</value>
        </criteriaItems>
        <description>If anyone changes ownership of an Account to D&amp;S Fuel Card</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Owner Changed to D%26S Support</fullName>
        <actions>
            <name>Tag_Partner_D_S_Supoort</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.OwnerId</field>
            <operation>equals</operation>
            <value>D&amp;S Support</value>
        </criteriaItems>
        <description>If anyone changes ownership of an Account to D&amp;S Support</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Owner Changed to DAT</fullName>
        <actions>
            <name>Tag_Partner_DAT</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.OwnerId</field>
            <operation>equals</operation>
            <value>Bert Goo</value>
        </criteriaItems>
        <description>If anyone changes ownership of an Account to DAT partner user Bert Goo.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Owner Changed to ECAPITAL</fullName>
        <actions>
            <name>Tag_Partner_ECAPITAL</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.OwnerId</field>
            <operation>equals</operation>
            <value>Raul Pena</value>
        </criteriaItems>
        <description>If anyone changes ownership of an Account to ECAPITAL partner user Raul Pena.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Owner Changed to ENGS Commercial Capital</fullName>
        <actions>
            <name>Tag_Partner_ENGS_Commercial_Capital</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.OwnerId</field>
            <operation>equals</operation>
            <value>Leslye Campos</value>
        </criteriaItems>
        <description>If anyone changes ownership of an Account to ENGS Commercial Capital partner user Leslye Campos</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Owner Changed to England Logistics</fullName>
        <actions>
            <name>Tag_Partner_England_Logistics</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 OR 2 OR 3</booleanFilter>
        <criteriaItems>
            <field>Account.OwnerId</field>
            <operation>equals</operation>
            <value>Kevin Ellis</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.OwnerId</field>
            <operation>equals</operation>
            <value>Steven Mouritsen</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.OwnerId</field>
            <operation>equals</operation>
            <value>Alex Weiche</value>
        </criteriaItems>
        <description>If anyone changes ownership of an Account a England Logistics Partner User</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Owner Changed to Envio 360</fullName>
        <actions>
            <name>Tag_Partner_Envio_360</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.OwnerId</field>
            <operation>equals</operation>
            <value>Larry Cuddy</value>
        </criteriaItems>
        <description>If anyone changes ownership of an Account to Envio 360 partner user Larry Cuddy.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Owner Changed to Express Freight Finance</fullName>
        <actions>
            <name>Tag_Partner_Express_Freight_Finance</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.OwnerId</field>
            <operation>equals</operation>
            <value>Bryan Doty</value>
        </criteriaItems>
        <description>If anyone changes ownership of an Account to Express Freight Finance partner user Bryan Doty.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Owner Changed to Far West Capital</fullName>
        <actions>
            <name>Tag_Partner_Far_West_Capital</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.OwnerId</field>
            <operation>equals</operation>
            <value>Brenda Pinon</value>
        </criteriaItems>
        <description>If anyone changes ownership of an Account to Far West Capital partner user Brenda Pinon.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Owner Changed to FedEx Custom Critical</fullName>
        <actions>
            <name>Tag_Partner_FedEx_Custom_Critical</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.OwnerId</field>
            <operation>equals</operation>
            <value>MARIANNE TAMMINEN</value>
        </criteriaItems>
        <description>If anyone changes ownership of an Account to FedEx Custom Critical partner user MARIANNE TAMMINEN.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Owner Changed to Financial Carrier Service</fullName>
        <actions>
            <name>Tag_Partner_Financial_Carrier_Service</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.OwnerId</field>
            <operation>equals</operation>
            <value>Alex Kelis</value>
        </criteriaItems>
        <description>If anyone changes ownership of an Account to Financial Carrier Service partner user Alex Kelis.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Owner Changed to Foley Carrier Services</fullName>
        <actions>
            <name>Tag_Partner_Foley_Carrier_Services</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.OwnerId</field>
            <operation>equals</operation>
            <value>Matt Nulle</value>
        </criteriaItems>
        <description>If anyone changes ownership of an Account to Foley Carrier Services partner user Matt Nulle.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Owner Changed to Freight Factoring Special</fullName>
        <actions>
            <name>Tag_Partner_Freight_Factoring_Special</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.OwnerId</field>
            <operation>equals</operation>
            <value>Steven Newman</value>
        </criteriaItems>
        <description>If anyone changes ownership of an Account to Freight Factoring Special partner user Steven Newman.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Owner Changed to G%2EH%2E Factor</fullName>
        <actions>
            <name>Tag_Partner_G_H_Factor</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.OwnerId</field>
            <operation>equals</operation>
            <value>Karla Revilla</value>
        </criteriaItems>
        <description>If anyone changes ownership of an Account to G.H. Factor partner user Karla Revilla.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Owner Changed to GE Capital</fullName>
        <actions>
            <name>Created_By_Partner_GE_Capital</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 OR 2</booleanFilter>
        <criteriaItems>
            <field>Account.OwnerId</field>
            <operation>equals</operation>
            <value>John Conkin</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.OwnerId</field>
            <operation>equals</operation>
            <value>Kristin Larimore</value>
        </criteriaItems>
        <description>If anyone changes ownership of an Account a GE Capital Partner User</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Owner Changed to Great Plains</fullName>
        <actions>
            <name>Tag_Partner_Great_Plains</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.OwnerId</field>
            <operation>equals</operation>
            <value>Jerry Van Wyk</value>
        </criteriaItems>
        <description>If anyone changes ownership of an Account to Great Plains partner user Jerry Van Wyk.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Owner Changed to Integra</fullName>
        <actions>
            <name>Tag_Partner_Integra</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.OwnerId</field>
            <operation>equals</operation>
            <value>Kyle Klatzkin</value>
        </criteriaItems>
        <description>If anyone changes ownership of an Account to Integra partner user Kyle Klatzkin.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Owner Changed to Integrated Logistics</fullName>
        <actions>
            <name>Tag_Partner_Integrated_Logistics</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.OwnerId</field>
            <operation>equals</operation>
            <value>Amanda Keller</value>
        </criteriaItems>
        <description>If anyone changes ownership of an Account to Integrated Logistics partner user Amanda Keller.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Owner Changed to Interstate Capital</fullName>
        <actions>
            <name>Tag_Partner_Interstate_Capital</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.OwnerId</field>
            <operation>equals</operation>
            <value>Sarah Williams</value>
        </criteriaItems>
        <description>If anyone changes ownership of an Account to Interstate Capital partner user Sarah Williams .</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Owner Changed to JB Hunt</fullName>
        <actions>
            <name>Tag_Partner_JB_Hunt</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.OwnerId</field>
            <operation>equals</operation>
            <value>Mandy Robinson</value>
        </criteriaItems>
        <description>If anyone changes ownership of an Account to JB Hunt partner user Mandy Robinson.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Owner Changed to JD Factors</fullName>
        <actions>
            <name>Tag_Partner_JD_Factors</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.OwnerId</field>
            <operation>equals</operation>
            <value>CHIP WILEY</value>
        </criteriaItems>
        <description>If anyone changes ownership of an Account to JD Factors partner user CHIP WILEY.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Owner Changed to Liquid Capital</fullName>
        <actions>
            <name>Tag_Partner_Liquid_Capital</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.OwnerId</field>
            <operation>equals</operation>
            <value>Ernane Iung</value>
        </criteriaItems>
        <description>If anyone changes ownership of an Account to Liquid Capital partner user Ernane Iung.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Owner Changed to Mansfield Oil Company</fullName>
        <actions>
            <name>Tag_Partner_Zach</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.OwnerId</field>
            <operation>equals</operation>
            <value>Zach Wall</value>
        </criteriaItems>
        <description>If anyone changes ownership of an Account to Mansfield Oil Company partner user Zach</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Owner Changed to NASTC</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Account.OwnerId</field>
            <operation>equals</operation>
            <value>Jeff Stuck</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Owner Changed to OTR Capital</fullName>
        <actions>
            <name>Tag_Partner_OTR_Capital</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.OwnerId</field>
            <operation>equals</operation>
            <value>Cody Barwig</value>
        </criteriaItems>
        <description>If anyone changes ownership of an Account to OTR Capital partner user Patti Mielke.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Owner Changed to PTP Stop NATSN</fullName>
        <actions>
            <name>Tag_Partner_PTP_Stop_NATSN</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.OwnerId</field>
            <operation>equals</operation>
            <value>James Latner</value>
        </criteriaItems>
        <description>If anyone changes ownership of an Account to PTP Stop NATSN partner user James Latner.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Owner Changed to Parikh Financial</fullName>
        <actions>
            <name>Tag_Partner_Parikh_Financial</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.OwnerId</field>
            <operation>equals</operation>
            <value>Raj Parikh</value>
        </criteriaItems>
        <description>If anyone changes ownership of an Account to Parikh Financial partner user Raj Parikh.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Owner Changed to Partners Funding</fullName>
        <actions>
            <name>Tag_Partner_Partners_Funding</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.OwnerId</field>
            <operation>equals</operation>
            <value>Patti Mielke</value>
        </criteriaItems>
        <description>If anyone changes ownership of an Account to Partners Funding partner user Patti Mielke.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Owner Changed to Patriot Fleet Systems</fullName>
        <actions>
            <name>Tag_Patriot_Fleet_Systems</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.OwnerId</field>
            <operation>equals</operation>
            <value>Michael Lingman</value>
        </criteriaItems>
        <description>If anyone changes ownership of an Account to Michael Lingman</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Owner Changed to Pavestone Capital</fullName>
        <actions>
            <name>Tag_Partner_Pavestone_Capital</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.OwnerId</field>
            <operation>equals</operation>
            <value>Pavestone Capital</value>
        </criteriaItems>
        <description>If anyone changes ownership of an Account to Pavestone Capital</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Owner Changed to Pay4Freight</fullName>
        <actions>
            <name>Tag_Partner_Pay4Freight</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.OwnerId</field>
            <operation>equals</operation>
            <value>Robert Beard</value>
        </criteriaItems>
        <description>If anyone changes ownership of an Account to Pay4Freight partner user Robert Beard.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Owner Changed to Petro Solutions</fullName>
        <actions>
            <name>Tag_Partner_Petro_Solutions</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.OwnerId</field>
            <operation>equals</operation>
            <value>Chuck Miller</value>
        </criteriaItems>
        <description>If anyone changes ownership of an Account to Petro Solutions partner user Chuck Miller.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Owner Changed to Prepass</fullName>
        <actions>
            <name>Tag_Partner_PrePass</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.OwnerId</field>
            <operation>equals</operation>
            <value>Travis Lehew</value>
        </criteriaItems>
        <description>If anyone changes ownership of an Account to Travis Lehew</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Owner Changed to Quick Pay Funding</fullName>
        <actions>
            <name>Tag_Partner_Quick_Pay_Funding</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.OwnerId</field>
            <operation>equals</operation>
            <value>JUAN ESTRADA</value>
        </criteriaItems>
        <description>If anyone changes ownership of an Account to Quick Pay Funding partner user JUAN ESTRADA.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Owner Changed to RTS</fullName>
        <actions>
            <name>Tag_Partner_Rick_Albright</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.OwnerId</field>
            <operation>equals</operation>
            <value>Rick Albright</value>
        </criteriaItems>
        <description>If anyone changes ownership of an Account to RTS Partner User Rick Albright.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Owner Changed to Roady%27s Card</fullName>
        <actions>
            <name>Tag_Partner_Roady_s_Card</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.OwnerId</field>
            <operation>equals</operation>
            <value>Roady&apos;s Card</value>
        </criteriaItems>
        <description>If anyone changes ownership of an Account to Roady&apos;s Card</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Owner Changed to SUMMAR</fullName>
        <actions>
            <name>Tag_Partner_SUMMAR</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.OwnerId</field>
            <operation>equals</operation>
            <value>Jessi Saker</value>
        </criteriaItems>
        <description>If anyone changes ownership of an Account to SUMMAR partner user Jessi Saker .</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Owner Changed to St Johns</fullName>
        <actions>
            <name>Tag_Partner_St_Johns</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.OwnerId</field>
            <operation>equals</operation>
            <value>Christina Kordik</value>
        </criteriaItems>
        <description>If anyone changes ownership of an Account to St Johns partner user Christina Kordik.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Owner Changed to Steelhead</fullName>
        <actions>
            <name>Tag_Partner_Steelhead</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.OwnerId</field>
            <operation>equals</operation>
            <value>Rich Templeton</value>
        </criteriaItems>
        <description>If anyone changes ownership of an Account to Steelhead partner user Rich Templeton.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Owner Changed to Sunbelt</fullName>
        <actions>
            <name>Tag_Partner_Sunbelt</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.OwnerId</field>
            <operation>equals</operation>
            <value>Debbie Kimberland</value>
        </criteriaItems>
        <description>If anyone changes ownership of an Account to Sunbelt partner user Debbie Kimberland.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Owner Changed to TBS Factoring Service</fullName>
        <actions>
            <name>Tag_TBS</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.OwnerId</field>
            <operation>equals</operation>
            <value>Ashley Wendorff</value>
        </criteriaItems>
        <description>If anyone changes ownership of an Account to TBS Factoring Servicepartner user Wendorff, Ashley</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Owner Changed to TRANSPORT FINANCIAL SOLUTIONS</fullName>
        <actions>
            <name>Tag_Partner_TRANSPORT_FINANCIAL_SOLUTIO</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.OwnerId</field>
            <operation>equals</operation>
            <value>Sheri Breedlove</value>
        </criteriaItems>
        <description>If anyone changes ownership of an Account to TRANSPORT FINANCIAL SOLUTIONS partner user Sheri Breedlove.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Owner Changed to TRIUMPH BUSINESS CAPITAL</fullName>
        <actions>
            <name>Tag_Partner_TRIUMPH_BUSINESS_CAPITAL</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 OR 2</booleanFilter>
        <criteriaItems>
            <field>Account.OwnerId</field>
            <operation>equals</operation>
            <value>Ray Workman</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.OwnerId</field>
            <operation>equals</operation>
            <value>Jason Mullican</value>
        </criteriaItems>
        <description>If anyone changes ownership of an Account to TRIUMPH BUSINESS CAPITAL partner user Ray Workman or .</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Owner Changed to Thunder Carrier Services</fullName>
        <actions>
            <name>Tag_Partner_Thunder_Carrier_Services</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.OwnerId</field>
            <operation>equals</operation>
            <value>Willie Andruss</value>
        </criteriaItems>
        <description>If anyone changes ownership of an Account to Thunder Carrier Services partner user Willie Andruss.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Owner Changed to Trans-Alliance</fullName>
        <actions>
            <name>Tag_Partner_Jessie_Singh</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.OwnerId</field>
            <operation>equals</operation>
            <value>Jessie Singh</value>
        </criteriaItems>
        <description>If anyone changes ownership of an Account to Trans-Alliance partner user Jessie Singh.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Owner Changed to Truckers B2B</fullName>
        <actions>
            <name>Tag_Partner_Truckers_B2B</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.OwnerId</field>
            <operation>equals</operation>
            <value>Amberley Rodriguez</value>
        </criteriaItems>
        <description>If anyone changes ownership of an Account to Truckers B2B Partner User</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Owner Changed to Truckers Solutions</fullName>
        <actions>
            <name>Tag_Partner_Truckers_Solutions</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.OwnerId</field>
            <operation>equals</operation>
            <value>Dennis Woods</value>
        </criteriaItems>
        <description>If anyone changes ownership of an Account to Truckers Solutions partner user Dennis Woods.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Owner Changed to Trulos</fullName>
        <actions>
            <name>Tag_Partner_Trulos</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.OwnerId</field>
            <operation>equals</operation>
            <value>Winfield Rinkle</value>
        </criteriaItems>
        <description>If anyone changes ownership of an Account to Trulos Partner User</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Owner Changed to Vero Business Capital</fullName>
        <actions>
            <name>Tag_Partner_Vero_Business_Capital</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.OwnerId</field>
            <operation>equals</operation>
            <value>Trey Heath</value>
        </criteriaItems>
        <description>If anyone changes ownership of an Account to Vero Business Capital partner user Trey Heath.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Owner Changed to WilcoHess</fullName>
        <actions>
            <name>Tag_Partner_Mike_Gordon</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.OwnerId</field>
            <operation>equals</operation>
            <value>Mike Gordon</value>
        </criteriaItems>
        <description>If anyone changes ownership of an Account to WilcoHess Partner User Mike Gordon.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Owner Changed to XPO Logistics</fullName>
        <actions>
            <name>Tag_XPO_Logistics_Account</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.OwnerId</field>
            <operation>equals</operation>
            <value>Corey Luttrell</value>
        </criteriaItems>
        <description>If anyone changes ownership of an Account to XPO Logistics Partner User Corey Luttrell</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Owner Changed to Xfactors</fullName>
        <actions>
            <name>Tag_Partner_Xfactors</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.OwnerId</field>
            <operation>equals</operation>
            <value>JEFFREY COLBURN</value>
        </criteriaItems>
        <description>If anyone changes ownership of an Account to Xfactors partner user JEFFREY COLBURN.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Owner Changed to iThrive Funding</fullName>
        <actions>
            <name>Tag_Partner_iThrive_Funding</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.OwnerId</field>
            <operation>equals</operation>
            <value>Robert Marker</value>
        </criteriaItems>
        <description>If anyone changes ownership of an Account to iThrive Funding partner user Robert Marker.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Relationship Manager Assigned</fullName>
        <actions>
            <name>RM_Assigned_Account_Owner_Notification</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>RM_Assigned_RM_Notification</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Wex Europe record types only</description>
        <formula>AND(
ISCHANGED(Assigned_Relationship_Manager__c),

NOT(ISBLANK(Assigned_Relationship_Manager__c))

)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Sales Owner Assignment</fullName>
        <active>false</active>
        <booleanFilter>1 OR 2</booleanFilter>
        <criteriaItems>
            <field>User.UserRoleId</field>
            <operation>equals</operation>
            <value>Business Payment Sales Rep</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.UserRoleId</field>
            <operation>equals</operation>
            <value>CorporatePay Sales</value>
        </criteriaItems>
        <description>Automatically assigns the account owner to an account team role.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>WES - Populate IFCS Record ID</fullName>
        <actions>
            <name>WES_Set_Account_ID</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>WES_Set_Primary_Account_Number</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>Copies the IFCS Record ID to the Account ID and Primary Account ID for WES Accounts</description>
        <formula>AND( RecordType.DeveloperName = &quot;WES_Accounts&quot;, NOT(ISBLANK(IFCS__c)), ISNEW() || ISCHANGED(IFCS__c) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>WES - Set Billing Address based on Trading</fullName>
        <actions>
            <name>WES_Set_Billing_City</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>WES_Set_Billing_Country</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>WES_Set_Billing_Postcode</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>WES_Set_Billing_State</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>WES_Set_Trading_Street_on_Account</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Used to populate Billing Address based on Trading Address</description>
        <formula>AND( RecordType.DeveloperName = &quot;WES_Accounts&quot;, OR( NOT(ISBLANK(Physical_Street_Address__c)),  NOT(ISBLANK(WES_Address_Line2__c)),  NOT(ISBLANK(WES_Address_Line3__c)),	 NOT(ISBLANK(Physical_City__c)),	 NOT(ISBLANK(Physical_State__c)),	 NOT(ISBLANK(TEXT(WES_ISO_Country_Code__c))) 				   ), OR(ISNEW(),  ISCHANGED(Physical_Street_Address__c),  ISCHANGED(WES_Address_Line2__c),  ISCHANGED(WES_Address_Line3__c),	 ISCHANGED(Physical_City__c),	 ISCHANGED(Physical_State__c),	 ISCHANGED(WES_ISO_Country_Code__c)  ))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>WES - Set Trading Address Fields</fullName>
        <active>false</active>
        <formula>AND(  RecordType.DeveloperName = &quot;WES_Accounts&quot;, ISBLANK(Physical_Street_Address__c),  ISBLANK(Physical_City__c),	 ISBLANK(Physical_State__c), ISBLANK(Physical_Zip_Postal_Code__c),								 OR(ISNEW(),  ISCHANGED(BillingStreet),  ISCHANGED(BillingCity),  ISCHANGED(BillingState), ISCHANGED(BillingPostalCode)   ))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <tasks>
        <fullName>ECapital_Welcome_Call</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>1</dueDateOffset>
        <notifyAssignee>true</notifyAssignee>
        <priority>High</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>E-Capital Welcome Call</subject>
    </tasks>
    <tasks>
        <fullName>Edge_Benefits_Call</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>1</dueDateOffset>
        <notifyAssignee>true</notifyAssignee>
        <priority>4-Medium</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Edge Benefits Call</subject>
    </tasks>
    <tasks>
        <fullName>FTS_Welcome_Call</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>1</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>High</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>FTS Welcome Call</subject>
    </tasks>
    <tasks>
        <fullName>Manual_Credit_Review_Needed</fullName>
        <assignedTo>dcraigmile@fleetone.com</assignedTo>
        <assignedToType>user</assignedToType>
        <dueDateOffset>1</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <offsetFromField>Account.CreatedDate</offsetFromField>
        <priority>High</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Manual Credit Review Needed</subject>
    </tasks>
    <tasks>
        <fullName>Routine_Followup</fullName>
        <assignedToType>owner</assignedToType>
        <description>how about another shot at seeing what we can help with?</description>
        <dueDateOffset>120</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <offsetFromField>Account.CreatedDate</offsetFromField>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Routine Followup</subject>
    </tasks>
    <tasks>
        <fullName>WF_Rule_Email_Sent</fullName>
        <assignedTo>danielle.vidaurre@wexinc.com</assignedTo>
        <assignedToType>user</assignedToType>
        <description>A WF rule email was just sent to the member.</description>
        <dueDateOffset>1</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Completed</status>
        <subject>WF Rule Email Sent</subject>
    </tasks>
</Workflow>
