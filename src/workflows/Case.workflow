<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Account_Created</fullName>
        <description>Virtual EU CS - Account Created</description>
        <protected>false</protected>
        <recipients>
            <field>User__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Virtual_EU_Templates/CorporatePay_Account_Created</template>
    </alerts>
    <alerts>
        <fullName>Application_KYB_KYC_Checks_Complete</fullName>
        <ccEmails>implementation@wexeurope.com</ccEmails>
        <description>Application KYB KYC Checks Complete</description>
        <protected>false</protected>
        <senderType>CurrentUser</senderType>
        <template>Virtual_EU_Templates/Application_KYB_KYC_Checks_Complete</template>
    </alerts>
    <alerts>
        <fullName>Application_Rejected</fullName>
        <description>Virtual EU CS - Application Rejected</description>
        <protected>false</protected>
        <recipients>
            <field>User__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Virtual_EU_Templates/Case_Application_Rejected</template>
    </alerts>
    <alerts>
        <fullName>Application_Submitted_Notification</fullName>
        <description>VIrtual EU CS - Application Submitted</description>
        <protected>false</protected>
        <recipients>
            <recipient>none@corporatepay.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Virtual_EU_Templates/CorporatePay_Case_New_Application_Notification</template>
    </alerts>
    <alerts>
        <fullName>Business_Requestor_Case_SLA_Exceeded_Notification</fullName>
        <description>Virtual EU CS - SLA Exceeded - Business Requestor</description>
        <protected>false</protected>
        <recipients>
            <field>User__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Virtual_EU_Templates/CorporatePay_Bus_Requestor_Case_Exceeded_Notification</template>
    </alerts>
    <alerts>
        <fullName>CSDM_Case_SLA_Exceeded_Notification</fullName>
        <description>Virtual EU CS - SLA Exceeded - CS</description>
        <protected>false</protected>
        <recipients>
            <recipient>bonnie.macarthur@wexeurope.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Virtual_EU_Templates/CorporatePay_CSDM_Case_Exceeded_Notification</template>
    </alerts>
    <alerts>
        <fullName>Case_Acceptance_Overdue_Bonnie</fullName>
        <description>Virtual EU CS - Application Case Acceptance Overdue - CSDM</description>
        <protected>false</protected>
        <recipients>
            <recipient>bonnie.macarthur@wexeurope.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Virtual_EU_Templates/CorporatePay_Case_Acceptance_Overdue_Bonnie</template>
    </alerts>
    <alerts>
        <fullName>Case_Acceptance_Overdue_CS_Team</fullName>
        <description>Virtual EU CS - Application Case Acceptance Overdue - CS</description>
        <protected>false</protected>
        <recipients>
            <recipient>CorporatePay_Customer_Services_1</recipient>
            <type>role</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Virtual_EU_Templates/CorporatePay_Case_Acceptance_Overdue_CS_Team</template>
    </alerts>
    <alerts>
        <fullName>Case_Account_Approval_Declined</fullName>
        <description>Virtual EU CS - Account Approval Declined</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Virtual_EU_Templates/CorporatePay_Case_Account_Declined</template>
    </alerts>
    <alerts>
        <fullName>Case_Being_Worked_Alert</fullName>
        <description>Salesforce Support Case Being Worked, Notify Business Requestor</description>
        <protected>false</protected>
        <recipients>
            <recipient>rbeattie@wrightexpress.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <field>User__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>WEX_University_Sales_Training/Case_Being_Worked</template>
    </alerts>
    <alerts>
        <fullName>Case_Owner_Case_SLA_Exceeded_Notification</fullName>
        <description>Virtual EU CS - Assignment Milestone Overdue</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Virtual_EU_Templates/CorporatePay_Case_Owner_Case_Exceeded_Notification</template>
    </alerts>
    <alerts>
        <fullName>Case_Update_Notification_for_AU_Asia_Virtual_Payment_Cases</fullName>
        <ccEmails>timothy.mason@wexinc.com</ccEmails>
        <description>Virtual Asia &amp; AU AM - Case Status Changed</description>
        <protected>false</protected>
        <recipients>
            <field>SuppliedEmail</field>
            <type>email</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Virtual_Asia_Case_Notifications/SupportCaseUpdatedorClosed_Asia</template>
    </alerts>
    <alerts>
        <fullName>Case_Warning_Notification_CSDM</fullName>
        <description>Virtual EU CS - Case Completion Milestone Due Warning</description>
        <protected>false</protected>
        <recipients>
            <recipient>bonnie.macarthur@wexeurope.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Virtual_EU_Templates/CorporatePay_Case_Warning_Notification_CSDM</template>
    </alerts>
    <alerts>
        <fullName>Case_Warning_Notification_Case_Owner</fullName>
        <description>Virtual EU CS - Assignment Milestone Due Warning</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Virtual_EU_Templates/CorporatePay_Case_Warning_Notification_Case_Owner</template>
    </alerts>
    <alerts>
        <fullName>Case_assignment_notification</fullName>
        <description>Case - assignment notification</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Service_Operations/Case_assignment_notification</template>
    </alerts>
    <alerts>
        <fullName>Cc_SalesforceSupportTeam_on_new_Email_Cases</fullName>
        <ccEmails>SalesforceSupportTeam@wrightexpress.com</ccEmails>
        <description>Cc SalesforceSupportTeam on new Email Cases</description>
        <protected>false</protected>
        <recipients>
            <recipient>adam.palmer@wexinc.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>jroney@fleetone.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>WEX_SF_Admin_Email_Templates/SF_Support_Case_Auto_Response</template>
    </alerts>
    <alerts>
        <fullName>E_mail_to_Business_Requestor_when_Target_Completion_Date_is_Updated</fullName>
        <description>E-mail to Business Requestor when Target Completion Date is Updated</description>
        <protected>false</protected>
        <recipients>
            <field>SuppliedEmail</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>WEX_SF_Admin_Email_Templates/Facilities_Case_Target_Completion_Auto_Response</template>
    </alerts>
    <alerts>
        <fullName>E_mail_to_business_requestor_when_case_is_closed</fullName>
        <description>E-mail to business requestor when case is closed</description>
        <protected>false</protected>
        <recipients>
            <field>SuppliedEmail</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>WEX_SF_Admin_Email_Templates/SF_Support_Case_Closed_Auto_Response</template>
    </alerts>
    <alerts>
        <fullName>Field_Support_Case_Submitted</fullName>
        <ccEmails>sandra.perkins@wexinc.com</ccEmails>
        <ccEmails>peter.wood@wexinc.com</ccEmails>
        <ccEmails>timothy.mason@wexinc.com</ccEmails>
        <description>Field Support Case Submitted</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <recipient>field.support@wexinc.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>Support/FIELD_SUPPORT_User_Case_Created_Updated_Notice</template>
    </alerts>
    <alerts>
        <fullName>High_Limit_Application_Submitted</fullName>
        <description>Virtual EU Compliance - High Limit Application Submitted</description>
        <protected>false</protected>
        <recipients>
            <recipient>none@corporatepay.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Virtual_EU_Templates/CorporatePay_Case_New_High_Limit_Application_Notification</template>
    </alerts>
    <alerts>
        <fullName>Imp_Case_Closed</fullName>
        <ccEmails>karyna.woods@gmail.com</ccEmails>
        <description>Imp Case Closed</description>
        <protected>false</protected>
        <recipients>
            <recipient>Opportunity Owner</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Implementation_Case_Closed_Cards</template>
    </alerts>
    <alerts>
        <fullName>New_Comment_CS_Email</fullName>
        <description>Virtual EU CS - New Comment to Business Requestor</description>
        <protected>false</protected>
        <recipients>
            <field>User__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Virtual_EU_Templates/CorporatePay_Case_Application_New_CS_Comment</template>
    </alerts>
    <alerts>
        <fullName>New_Comment_CS_Email_Information_Request</fullName>
        <description>Virtual EU CS - New Comment - Information Request</description>
        <protected>false</protected>
        <recipients>
            <field>User__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Virtual_EU_Templates/CorporatePay_Case_Application_New_Commercial_Comment_Information_Requested</template>
    </alerts>
    <alerts>
        <fullName>New_Comment_Commercial_Email</fullName>
        <description>Virtual EU CS - New Comment from Business Requestor</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Virtual_EU_Templates/CorporatePay_Case_Application_New_Commercial_Comment_1</template>
    </alerts>
    <alerts>
        <fullName>New_Comment_Commercial_Email_Information_Update</fullName>
        <description>Virtual EU CS - New Comment - Information Update</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Virtual_EU_Templates/CorporatePay_Case_Application_New_Commercial_Comment_Information_Update</template>
    </alerts>
    <alerts>
        <fullName>New_SF_Support_Case</fullName>
        <description>Virtual New SF Support Case</description>
        <protected>false</protected>
        <recipients>
            <recipient>Virtual_System_Administrator</recipient>
            <type>role</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Virtual_EU_Templates/New_SF_Support_Case</template>
    </alerts>
    <alerts>
        <fullName>New_Sales_Engineer_Case_Notification</fullName>
        <description>Virtual EU IM - New Sales Engineer Case</description>
        <protected>false</protected>
        <recipients>
            <recipient>Director_Global_Strategic_Accounts</recipient>
            <type>role</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Virtual_Templates/New_Sales_Engineer_Case_Notification</template>
    </alerts>
    <alerts>
        <fullName>Notify_Diane_if_Virtual_Payment_case_is_unassigned</fullName>
        <description>Notify Diane if Virtual Payment case is unassigned</description>
        <protected>false</protected>
        <recipients>
            <recipient>diane.simpsonpye@wexinc.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>richard.bean@wexinc.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Virtual_Templates/New_Case_Unassigned</template>
    </alerts>
    <alerts>
        <fullName>OTR_CS_Alert</fullName>
        <ccEmails>cory.herzog@wexinc.com</ccEmails>
        <description>OTR CS Alert</description>
        <protected>false</protected>
        <recipients>
            <recipient>OTR_Customer_Service_Alert</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>OTR_Sales_Email_Templates/OTR_Customer_Service_Notification</template>
    </alerts>
    <alerts>
        <fullName>SFDC_Support_E_mail_to_Business_Requestor_when_Target_Completion_Date_is_Updated</fullName>
        <description>SFDC Support: E-mail to Business Requestor when Target Completion Date is Updated</description>
        <protected>false</protected>
        <recipients>
            <field>SuppliedEmail</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>WEX_SF_Admin_Email_Templates/WEX_SFDC_Support_email_response_when_assigned</template>
    </alerts>
    <alerts>
        <fullName>SFDC_Support_E_mail_to_business_requestor_when_case_is_closed</fullName>
        <description>SFDC Suport E-mail to business requestor when case is closed</description>
        <protected>false</protected>
        <recipients>
            <field>SuppliedEmail</field>
            <type>email</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <field>User__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>WEX_SF_Admin_Email_Templates/SF_Support_Case_Closed</template>
    </alerts>
    <alerts>
        <fullName>Service_Operations_Auto_Response</fullName>
        <description>Service Operations - Auto Response</description>
        <protected>false</protected>
        <recipients>
            <field>SuppliedEmail</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Service_Operations/New_Case_Auto_Response</template>
    </alerts>
    <alerts>
        <fullName>Transaction_Dispute_Submitted</fullName>
        <ccEmails>disputes@fleetfraudservices.com</ccEmails>
        <description>Transaction Dispute Submitted</description>
        <protected>false</protected>
        <recipients>
            <recipient>adam.palmer@wexinc.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>derek.gilbert@wexinc.com</recipient>
            <type>user</type>
        </recipients>
        <senderAddress>disputes@fleetfraudservices.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Fraud_General/New_Transaction_Dispute_Form_Submission</template>
    </alerts>
    <alerts>
        <fullName>Virtual_CS_Business_Support_Close_Case</fullName>
        <description>Virtual EU CS - Business Support - Close Case</description>
        <protected>false</protected>
        <recipients>
            <field>ContactId</field>
            <type>contactLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Virtual_Service_CS_Close_Case/Close_Case_Virtual_Business_CS_HTML</template>
    </alerts>
    <alerts>
        <fullName>Virtual_CS_Virtual_Credit_Close_Case</fullName>
        <description>Virtual EU CS - Virtual Credit - Case Closed</description>
        <protected>false</protected>
        <recipients>
            <field>ContactId</field>
            <type>contactLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Virtual_Service_CS_Close_Case/Close_Case_VC_Support_HTML</template>
    </alerts>
    <alerts>
        <fullName>Virtual_CS_Virtual_Prepaid_Close_Case</fullName>
        <description>Virtual EU CS - Virtual Prepaid - Case Closed</description>
        <protected>false</protected>
        <recipients>
            <field>ContactId</field>
            <type>contactLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Virtual_Service_CS_Close_Case/Close_Case_Customer_Services_HTML</template>
    </alerts>
    <alerts>
        <fullName>Virtual_Closed_SF_Support_Case</fullName>
        <description>Virtual Closed SF Support Case</description>
        <protected>false</protected>
        <recipients>
            <recipient>Virtual_System_Administrator</recipient>
            <type>role</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Virtual_EU_Templates/Closed_Virtual_SF_Support_Case</template>
    </alerts>
    <alerts>
        <fullName>We_ll_miss_you_in_Sales_Onboarding</fullName>
        <description>We&apos;ll miss you in Sales Onboarding!</description>
        <protected>false</protected>
        <recipients>
            <recipient>Requestor</recipient>
            <type>caseTeam</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>WEX_University_Sales_Training/X0_3_Salesforce_Onboarding_Prerequisite_Mgr_Survey</template>
    </alerts>
    <fieldUpdates>
        <fullName>Account_Approved_Case_Closed</fullName>
        <field>Status</field>
        <literalValue>Application Approved</literalValue>
        <name>Account Approved - Case Closed</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Application_Rejected</fullName>
        <field>Status</field>
        <literalValue>Application Rejected</literalValue>
        <name>Application Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Application_Submitted</fullName>
        <field>Status</field>
        <literalValue>Application Submitted</literalValue>
        <name>Application Submitted</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Approval_Declined</fullName>
        <field>Status</field>
        <literalValue>Approval Declined</literalValue>
        <name>Approval Declined</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Assign_PreCard_Case_Queue</fullName>
        <field>OwnerId</field>
        <lookupValue>PreCard_Queue</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Assign to PreCard Case Queu</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Assign_to_Cobrand_Queue_for_Omni</fullName>
        <field>OwnerId</field>
        <lookupValue>CoBrand_Implementation_Cases</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Assign to Cobrand Queue for Omni</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Assign_to_Fleet_Implementation_Case</fullName>
        <field>OwnerId</field>
        <lookupValue>Fleet_Implementation_Case_Queue</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Assign to Fleet Implementation Case</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Assign_to_Jazmine</fullName>
        <field>OwnerId</field>
        <lookupValue>jazmine.campbell@wexinc.com</lookupValue>
        <lookupValueType>User</lookupValueType>
        <name>Assign to Jazmine</name>
        <notifyAssignee>true</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Case_Campaign_Program_WF_TXT</fullName>
        <description>Sets Campaign Program WF TXT Field Value based on Campaign Program formula field.</description>
        <field>Campaign_Program_WF_TXT__c</field>
        <formula>Opportunity__r.Campaign_Program__r.Name</formula>
        <name>Case - Campaign Program WF TXT</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Case_OTR_CS_Close_Case</fullName>
        <description>Closes case</description>
        <field>Status</field>
        <literalValue>Closed</literalValue>
        <name>Case - OTR CS Close Case</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Case_Reassigned</fullName>
        <field>Case_Reassigned__c</field>
        <literalValue>1</literalValue>
        <name>Case Reassigned</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Case_Status_Case_Accepted</fullName>
        <field>Status</field>
        <literalValue>Case Accepted</literalValue>
        <name>Case Status - Case Accepted</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Case_Status_Update_CSDM_Approval</fullName>
        <field>Status</field>
        <literalValue>CSDM Approval Requested</literalValue>
        <name>Case Status Update - CSDM Approval</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Client_Operations_Director_Approval</fullName>
        <field>Status</field>
        <literalValue>COD Approval Requested</literalValue>
        <name>Client Operations Director Approval</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Close_Case</fullName>
        <field>Status</field>
        <literalValue>Closed</literalValue>
        <name>Close Case</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Close_Revolver_Case</fullName>
        <field>Status</field>
        <literalValue>Closed</literalValue>
        <name>Close Revolver Case</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Compliance_Approval_Requested</fullName>
        <description>Delete if this can be set by JavaScript?</description>
        <field>Status</field>
        <literalValue>Compliance Approval Requested</literalValue>
        <name>Compliance Approval Requested</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Corporate_Payment_Routing_Jessie_Stuar</fullName>
        <field>OwnerId</field>
        <lookupValue>jessie.stuart@wexinc.com</lookupValue>
        <lookupValueType>User</lookupValueType>
        <name>Corporate Payment - Routing Jessie Stuar</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Corporate_Payment_Routing_Joe_Hutchins</fullName>
        <field>OwnerId</field>
        <lookupValue>joe.hutchinson@wexinc.com</lookupValue>
        <lookupValueType>User</lookupValueType>
        <name>Corporate Payment - Routing Joe Hutchins</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Corporate_Payment_Routing_Patrick_Kenn</fullName>
        <field>OwnerId</field>
        <lookupValue>patrick.kenney@wexinc.com</lookupValue>
        <lookupValueType>User</lookupValueType>
        <name>Corporate Payment - Routing Patrick Kenn</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Corporate_Payment_Routing_Richard_Bean</fullName>
        <field>OwnerId</field>
        <lookupValue>richard.bean@wexinc.com</lookupValue>
        <lookupValueType>User</lookupValueType>
        <name>Corporate Payment - Routing Richard Bean</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Corporate_Payment_Routing_Sally_Fredsa</fullName>
        <field>OwnerId</field>
        <lookupValue>sally.fredsall@wexinc.com</lookupValue>
        <lookupValueType>User</lookupValueType>
        <name>Corporate Payment - Routing Sally Fredsa</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Corporate_Payment_Silvia_Chang</fullName>
        <field>OwnerId</field>
        <lookupValue>silvia.chang@wexinc.com</lookupValue>
        <lookupValueType>User</lookupValueType>
        <name>Corporate Payment - Silvia Chang</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>High_Limit_Account_Approved</fullName>
        <description>So that Milestones are applied to the Case</description>
        <field>High_Limit_Account_Approved__c</field>
        <literalValue>1</literalValue>
        <name>High Limit Account Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Restart_SLA_Timer</fullName>
        <field>IsStopped</field>
        <literalValue>0</literalValue>
        <name>Restart SLA Timer</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Stop_SLA_Timer</fullName>
        <field>IsStopped</field>
        <literalValue>1</literalValue>
        <name>Stop SLA Timer</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Target_Completiton_Date</fullName>
        <description>Sets the Target Completion date for Customer Success cases to TODAY Plus 20</description>
        <field>Target_Completion_Date__c</field>
        <formula>TODAY()+ 20</formula>
        <name>Target Completiton Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Case_Type_AM_Email2Case</fullName>
        <field>Type</field>
        <literalValue>Existing Account - Currently pumping</literalValue>
        <name>Update Case Type AM Email2Case</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>update_and_mgr_approve</fullName>
        <field>Approval_Status__c</field>
        <formula>&apos;Approved By Manager&apos;</formula>
        <name>update and mgr approve</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>update_and_recall</fullName>
        <field>Approval_Status__c</field>
        <formula>&apos;Recalled by Submitter&apos;</formula>
        <name>update and recall</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>update_to_Rejected_by_mgr</fullName>
        <field>Approval_Status__c</field>
        <formula>&apos;Rejected by Manager&apos;</formula>
        <name>update to Rejected by mgr</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>update_to_pending</fullName>
        <field>Approval_Status__c</field>
        <formula>&apos;Pending&apos;</formula>
        <name>update to pending</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Application Rejected</fullName>
        <actions>
            <name>Application_Rejected</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Application_Rejected</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND( 

/* WE Application */ 
RecordTypeId = &apos;012700000005x2r&apos;,

Reject_Application__c = TRUE

)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Asia Virtual Payments Case Requestor notification</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Wex Asia Virtual Payments</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>Customer Email,Email,External Email,Internal Email</value>
        </criteriaItems>
        <description>This will send an acknowledgement to the requestor that their case has been opened.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Asia%2FAU Virtual Payments Support Case update notification</fullName>
        <actions>
            <name>Case_Update_Notification_for_AU_Asia_Virtual_Payment_Cases</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>This workflow will send an e-mail to the person that opened the case is assigned and being worked</description>
        <formula>AND(
  NOT(ISBLANK(SuppliedEmail)),
  OR(
    RecordType.Name = &apos;WEX Australia Virtual Payments&apos;,
    RecordType.Name = &apos;Wex Asia Virtual Payments&apos;
  ),
  OR(
    TEXT(Status) = &apos;Working&apos;,
    TEXT(Status) = &apos;Case Accepted&apos;,
    TEXT(Status) = &apos;Closed&apos;,
    TEXT(Status) = &apos;Escalated&apos;,
    TEXT(Status) = &apos;Case Assigned&apos;
  ),
  NOT($User.Id = Owner:User.Id)
)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Case - Campaign Program WF TXT</fullName>
        <actions>
            <name>Case_Campaign_Program_WF_TXT</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Campaign_Program_WF_TXT__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <description>Sets Campaign Program WF TXT field value from Campaign Program formula field</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Case - OTR CS Alert</fullName>
        <actions>
            <name>OTR_CS_Alert</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Case_OTR_CS_Close_Case</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>OTR Customer Support</value>
        </criteriaItems>
        <description>OTR Customer Service Incident Documentation.
Sales team reports customer service quality incidents.
Case is closed immediately, GM OTR is notified of the issue.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Case - Service operations - Assignment Notification</fullName>
        <actions>
            <name>Case_assignment_notification</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>RecordType.Name = &apos;Service Operations&apos; &amp;&amp;  Case_Owner_Type__c = &apos;User&apos; &amp;&amp;  OwnerId &lt;&gt; $User.Id &amp;&amp; OR( ISCHANGED(OwnerId), AND( ISNEW(),TEXT(Origin) &lt;&gt; &apos;Chat&apos;))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Case Accepted</fullName>
        <actions>
            <name>Case_Status_Case_Accepted</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(
/* WE Application */
RecordTypeId = &apos;012700000005x2r&apos;,
/* Wex Europe Customer Services Queue */
ISCHANGED(OwnerId),
PRIORVALUE(OwnerId) = &apos;00G70000002eXkY&apos;
)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Case Reassigned</fullName>
        <actions>
            <name>Case_Reassigned</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Updates if the case changes from user --&gt; user, not queue --&gt; user or user --&gt; queue</description>
        <formula>AND(ISCHANGED(OwnerId),        AND(        PRIORVALUE(OwnerId)&lt;&gt; &quot;00G29000000RwrE&quot;,        PRIORVALUE(OwnerId)&lt;&gt; &quot;00G29000000RwrF&quot;,        PRIORVALUE(OwnerId)&lt;&gt; &quot;00G29000000RwrG&quot;,        PRIORVALUE(OwnerId)&lt;&gt; &quot;00G29000000RwrH&quot;,        PRIORVALUE(OwnerId)&lt;&gt; &quot;00G29000000RwrI&quot;       ),     AND(        OwnerId &lt;&gt; &quot;00G29000000RwrE&quot;,        OwnerId &lt;&gt; &quot;00G29000000RwrF&quot;,        OwnerId &lt;&gt; &quot;00G29000000RwrG&quot;,        OwnerId &lt;&gt; &quot;00G29000000RwrH&quot;,        OwnerId &lt;&gt; &quot;00G29000000RwrI&quot;       ))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Cc SalesforceSupportTeam on new cases</fullName>
        <actions>
            <name>Cc_SalesforceSupportTeam_on_new_Email_Cases</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>WEX Salesforce Support Request</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>Email</value>
        </criteriaItems>
        <description>Send a cc notification to the SalesforceSupportTeam email list when a new case is created via email.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Close Case Ticked</fullName>
        <actions>
            <name>Close_Case</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <formula>AND(
  OR(
    RecordType.DeveloperName = &apos;Virtual_Business_Support_CS&apos;,
    RecordType.DeveloperName = &apos;Virtual_Credit_CS&apos;,
    RecordType.DeveloperName = &apos;Virtual_Prepaid_CS&apos;
  ),
  Close_Case__c = TRUE
)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>CoBrand Implementation Cases</fullName>
        <actions>
            <name>Assign_to_Cobrand_Queue_for_Omni</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND (2 OR 3 OR 4) AND 5</booleanFilter>
        <criteriaItems>
            <field>Case.ParentId</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Campaign_Program__c</field>
            <operation>equals</operation>
            <value>Hill Petroleum,Speedy&apos;s,City Service Valcon,LLC.,McAnany Oil,Hutchinson Oil Co,Cardwell Distributing Inc,Sinclair Commercial,Pilot Thomas Logistics,Bill Williams,Gene Moeller Oil,Dal Soglio,County Fuels,Sinclair Fleet Track,Pump &amp; Pantry Fleet Select Card</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Campaign_Program__c</field>
            <operation>equals</operation>
            <value>Al&apos;s Corner Oil,Hi-Noon,Basin Enterprises LLC,Rash Oil Company,Stinker/Fearless Farris,Dyno Oil Co,Campo Oil,Petroleum Services Company LLC,John E Jones Oil Co,Offen Petroleum,Christensen Oil,Superpumper Corporate,Ram Inc,Bailey Enterprises</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Campaign_Program__c</field>
            <operation>equals</operation>
            <value>Motorlease Fuel,Idealease,Leasing Associates,Mike Albert,Enterprise Tri Brand Sheetz,Enterprise Tri Brand Phillips,Enterprise Tri Brand Exxon Mobil,Enterprise Fleet Management</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Fleet Implementation</value>
        </criteriaItems>
        <description>routing cases to CoBrand Queue</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Corporate Payment - Routing Jessie Stuart</fullName>
        <actions>
            <name>Corporate_Payment_Routing_Jessie_Stuar</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <formula>AND(  RecordType.Name = &quot;Service Operations&quot;, Owner:Queue.QueueName = &apos;Corporate Payments&apos;,   OR(  Account.Name = &quot;Gateway Mechanical Services&quot;,  Account.Name = &quot;Gateway Management Services&quot;,  Account.Name = &quot;National Auto Care Corporation&quot;,  Account.Name = &quot;National Corporate Housing, Inc. (DMA Housing Inc)&quot;,  Account.Name = &quot;Driven Solutions&quot;,  Account.Name = &quot;Noventis, Inc. f/k/a PreCash, Inc.&quot;,  Account.Name = &quot;American Tours&quot;,  Account.Name = &quot;Liftopia Inc&quot;,  Account.Name = &quot;H&amp;M Hennes &amp; Mauritz L.P.&quot;,  Account.Name = &quot;Zurich North America Company (VSC CLAIMS-OVERLAND PARK, KS OFFICE)&quot;,  Account.Name = &quot;Smartpay Leasing Inc.&quot;,  Account.Name = &quot;Element&quot;,  Account.Name = &quot;PHH VEHICLE MANAGEMENT SVCS&quot;,  Account.Name = &quot;Sabre Communications Corp 41720&quot;,  Account.Name = &quot;LGM Financial Services, Inc.&quot;,  Account.Name = &quot;Comfort Systems&quot;,  Account.Name = &quot;LJK Companies&quot;,  Account.Name = &quot;Cartus under Realogy (Kimberly Clark, Lafarge,Lockheed,Shell,USSA)&quot;,  Account.Name = &quot;Alpha Warranty Services, Inc.&quot;,  Account.Name = &quot;ISS Facililty Management&quot;,  Account.Name = &quot;Cornerstone United&quot;,  Account.Name = &quot;LJK Companies, Inc dba Travelliance&quot;,  Account.Name = &quot;Progressive Finance&quot;,  Account.Name = &quot;Nissan Extended Services North America&quot;,  Account.Name = &quot;Crowley Maritime Corporation&quot;,  Account.Name = &quot;WALCO (aka Animal Health International, Inc)&quot;,  Account.Name = &quot;LJK Purchasing&quot;,  Account.Name = &quot;Infinity Insurance Companies&quot;,  Account.Name = &quot;Infinity Property and Casualty Company&quot;,  Account.Name = &quot;United Car Care&quot;,  Account.Name = &quot;Gateway Management Services&quot;,  Account.Name = &quot;Envision Healthcare Corporation&quot;,  Account.Name = &quot;National Adjustment Bureau, Inc dba Nation Safe Drivers&quot;  ))</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Corporate Payment - Routing Joe Hutchinson</fullName>
        <actions>
            <name>Corporate_Payment_Routing_Joe_Hutchins</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <formula>AND(  RecordType.Name = &quot;Service Operations&quot;,  OR(  Account.Name = &quot;USA Gateway, Inc.&quot;,  Account.Name = &quot;Century Automotive Service Corporation&quot;,  Account.Name = &quot;Road America&quot;,  Account.Name = &quot;Consumer Club, Inc.&quot;,  Account.Name = &quot;Borderfree&quot;,  Account.Name = &quot;vRide (VPSI)&quot;,  Account.Name = &quot;Affinion Group Holdings, Inc.&quot;,  Account.Name = &quot;Lasell College&quot;,  Account.Name = &quot;Arrow Truck Sales&quot;,  Account.Name = &quot;Novant Health, Inc.&quot;,  Account.Name = &quot;21st Century Insurance Company&quot;,  Account.Name = &quot;Huntsman Intl. LLC&quot;,  Account.Name = &quot;Huntsman Chemical&quot;,  Account.Name = &quot;Graphic Enterprises&quot;,  Account.Name = &quot;Robertson Heating&quot;,  Account.Name = &quot;Bookit.com Total&quot;,  Account.Name = &quot;Hunterdon Medical Center&quot;,  Account.Name = &quot;Despegar.com USA Inc.&quot;,  Account.Name = &quot;Transit Pros&quot;,  Account.Name = &quot;The GEO Group Inc&quot;,  Account.Name = &quot;Protective Life Corporation&quot;,  Account.Name = &quot;Marathon Administrative Company&quot;,  Account.Name = &quot;Sonsio Inc&quot;,  Account.Name = &quot;Accelerated Service International (ASI)&quot;,  Account.Name = &quot;Sutherland Global Services Inc.&quot;,  Account.Name = &quot;SCIF (State Compensations Insurance Fund)&quot;,  Account.Name = &quot;Agero&quot;,  Account.Name = &quot;Commercial Tire&quot;,  Account.Name = &quot;Visual Edge Technology&quot;,  Account.Name = &quot;The Kleinfelder Group, Inc.&quot;,  Account.Name = &quot;Tourico&quot;,  Account.Name = &quot;Huntsman Chemical&quot;  ))</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Corporate Payment - Routing Patrick Kenney</fullName>
        <actions>
            <name>Corporate_Payment_Routing_Patrick_Kenn</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <formula>AND(  RecordType.Name = &quot;Service Operations&quot;,  OR(  Account.Name = &quot;Agoda Services Co Ltd&quot;,  Account.Name = &quot;Expedia Corp AP - Media&quot;,  Account.Name = &quot;TravelJigsaw Ltd&quot;,  Account.Name = &quot;Expedia AMEX Service Excellence&quot;,  Account.Name = &quot;Expedia Ancillary Accounts Parent&quot;,  Account.Name = &quot;Expedia Air Program&quot;,  Account.Name = &quot;Priceline&quot;,  Account.Name = &quot;Blue Cross Blue Shield of Nebraska&quot;,  Account.Name = &quot;Expedia Inc Parent Account&quot;,  Account.Name = &quot;Classic Vacations&quot;,  Account.Name = &quot;Texas State University&quot;,  Account.Name = &quot;Orbitz Worldwide&quot;,  Account.Name = &quot;Lexyl Travel Technologies, Inc&quot;,  Account.Name = &quot;Tauck, Inc.&quot;,  Account.Name = &quot;Schluter Systems L.P.&quot;,  Account.Name = &quot;Hotwire&quot;  ))</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Corporate Payment - Routing Richard Bean</fullName>
        <actions>
            <name>Corporate_Payment_Routing_Richard_Bean</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <formula>AND(  RecordType.Name = &quot;Service Operations&quot;,  OR(  Account.Name = &quot;Inspirato LLC&quot;,  Account.Name = &quot;Palmer Administrative Services&quot;,  Account.Name = &quot;Travelers Haven&quot;,  Account.Name = &quot;Mercfuel, Inc.&quot;,  Account.Name = &quot;NSC Technologies&quot;,  Account.Name = &quot;Brookshire Management Inc&quot;,  Account.Name = &quot;Gillette Children&apos;s Specialty Healthcare&quot;,  Account.Name = &quot;Glidewell Labs&quot;,  Account.Name = &quot;National Warranty Corp OR&quot;,  Account.Name = &quot;CNA National Warranty Corporation&quot;,  Account.Name = &quot;Mastech Inc&quot;,  Account.Name = &quot;Rowan Companies Inc.&quot;,  Account.Name = &quot;4Warranty Corporation&quot;,  Account.Name = &quot;American Ring Travel, Inc&quot;,  Account.Name = &quot;UpLift&quot;,  Account.Name = &quot;Cambia Health Solutions (Regence Group)&quot;,  Account.Name = &quot;Cambia Health Solutions - Primary&quot;,  Account.Name = &quot;Airplus International&quot;,  Account.Name = &quot;University Of Montana Ap&quot;,  Account.Name = &quot;Viator Inc&quot;,  Account.Name = &quot;American Auto Shield LLC&quot;,  Account.Name = &quot;PaySpan, Inc.&quot;,  Account.Name = &quot;Pleasant Holidays, LLC&quot;,  Account.Name = &quot;Lake Hospital System Inc&quot;,  Account.Name = &quot;Petersen-Dean, Inc&quot;,  Account.Name = &quot;The University of Montana (MC)&quot;,  Account.Name = &quot;Auto Knight Motor Club&quot;,  Account.Name = &quot;PGT Trucking Inc&quot;,  Account.Name = &quot;Ace Electric Inc&quot;,  Account.Name = &quot;Oldcastle&quot;,  Account.Name = &quot;Old Republic Insured Automotive Services Inc.&quot;,  Account.Name = &quot;MC DEAN&quot;,  Account.Name = &quot;WWStay Inc&quot;,  Account.Name = &quot;Hotel Connections&quot;,  Account.Name = &quot;AirPlus International, Inc.&quot;,  Account.Name = &quot;Old Republic Home Protection Company Inc&quot;,  Account.Name = &quot;ECI Travel US&quot;,  Account.Name = &quot;Sam Houston State University&quot;,  Account.Name = &quot;Rovia LLC&quot;,  Account.Name = &quot;CHG Healthcare Services, Inc.&quot;,  Account.Name = &quot;American Guardian Warranty&quot;,  Account.Name = &quot;Regence&quot;,  Account.Name = &quot;American Guardian Warranty Services&quot;,  Account.Name = &quot;Ameriflight&quot;, 
Account.Name = &quot;Cambria&quot;, 
Account.Name = &quot;Viajes El Corte Ingles HBSi&quot;  ))</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Corporate Payment - Routing Sally Fredsall</fullName>
        <actions>
            <name>Corporate_Payment_Routing_Sally_Fredsa</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <formula>AND(  RecordType.Name = &quot;Service Operations&quot;,  OR(  Account_Name__c = &quot;wex&quot;,  Account.Name = &quot;WEX&quot;,  Account.Name = &quot;Hotel Tonight&quot;,  Account.Name = &quot;Venterra Realty Management Company, Inc. SUNGARD&quot;,  Account.Name = &quot;Jamestown, L.P. (SUNGARD)&quot;,  Account.Name = &quot;Casto Partners, LLC (SUNGARD)&quot;,  Account.Name = &quot;S.A. Recycling S.A.LLC (SUNGARD)&quot;,  Account.Name = &quot;The John Stewart Company (SUNGARD)&quot;,  Account.Name = &quot;AT&amp;T Services SUNGARD&quot;,  Account.Name = &quot;Frank&apos;s International (SUNGARD)&quot;,  Account.Name = &quot;Oilfield Lodging.com&quot;,  Account.Name = &quot;Benaissance&quot;,  Account.Name = &quot;The Donaldson Group L L C SUNGARD REFERRAL&quot;,  Account.Name = &quot;SteelWave SUNGARD ACCOUNT&quot;,  Account.Name = &quot;National Service Source, Inc.(SUNGARD)&quot;,  Account.Name = &quot;Southwest Re, Inc.&quot;,  Account.Name = &quot;Colliers International Group Inc (SUNGARD)&quot;,  Account.Name = &quot;Apex Healthcare Partners&quot;,  Account.Name = &quot;La Macchia Enterprises Inc&quot;,  Account.Name = &quot;The Home Sales Company (SUNGARD)&quot;,  Account.Name = &quot;P2 Energy Solutions, Inc. SUNGARD&quot;,  Account.Name = &quot;Verifone&quot;,  Account.Name = &quot;Royal Administration Services&quot;,  Account.Name = &quot;GS Administrator Inc (Gulf States Financial Group)&quot;,  Account.Name = &quot;Draper Labs (The Charles Stark Draper Laboratory, Inc)&quot;,  Account.Name = &quot;Phoenix American Insurance Group&quot;,  Account.Name = &quot;Safe-Guard Products International&quot;,  Account.Name = &quot;Mark Travel / La Macchia&quot;,  Account.Name = &quot;SPINIELLO COMPANIES MC&quot;,  Account.Name = &quot;Thomas Eye Group, P.C. SUNGARD&quot;,  Account.Name = &quot;SilverRock, Inc.&quot;,  Account.Name = &quot;Middlesex Country (SUNGARD)&quot;,  Account.Name = &quot;USSI (SUNGARD) (MC)&quot;,  Account.Name = &quot;County of Kern (SUNGARD)&quot;,  Account.Name = &quot;The Caton Companies SUNGARD&quot;,  Account.Name = &quot;VPTC Management Partners, LLC (SUNGARD)&quot;,  Account.Name = &quot;Jefferson Parrish Public Schools (SUNGARD)&quot;,  Account.Name = &quot;Vantage Administration Services, LP&quot;,  Account.Name = &quot;Ethos Group Inc&quot;,  Account.Name = &quot;Conifer Realty, LLC - (SunGard)&quot;,  Account.Name = &quot;Landsman Real Estate Services Inc. - (SunGard)&quot;,  Account.Name = &quot;Safe-Guard Products International, Inc&quot;,  Account.Name = &quot;Avalon Healthcare&quot;,  Account.Name = &quot;WEX&quot;,  Account.Name = &quot;Delta Vacations&quot;,  Account.Name = &quot;Hamilton College&quot;,  Account.Name = &quot;First Communities Management SUNGARD&quot;,  Account.Name = &quot;Mid America Asset Management Inc (SunGard)&quot;,  Account.Name = &quot;Campus Acquisitions Holdings, LLC SUNGARD ACCOUNT&quot;  ))</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Corporate Payment - Routing Silvia Change</fullName>
        <actions>
            <name>Corporate_Payment_Silvia_Chang</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <formula>AND(  RecordType.Name = &quot;Service Operations&quot;,  OR(  Account.Name = &quot;LY - Tong Cheng&quot;,  Account.Name = &quot;HONG KONG BEAUTY BRIGADE TRAVEL LIMITED&quot;,  Account.Name = &quot;China Travel International (Guangdong) LTD.&quot;,  Account.Name = &quot;LETSFLY TECHNOLOGY LIMITED&quot;,  Account.Name = &quot;Fortune Travel Pte Ltd&quot;,  Account.Name = &quot;SamePage Travel&quot;,  Account.Name = &quot;Changi Travel Services Pte. Ltd.&quot;,  Account.Name = &quot;LETSFLY TECHNOLOGY LIMITED&quot;,  Account.Name = &quot;On The Way (Hong Kong) Travel Limited&quot;,  Account.Name = &quot;Alibaba Group&quot;,  Account.Name = &quot;Trafree Travel Technology(HK) Co., Limited&quot;,  Account.Name = &quot;Shenzheng XFX Travel Agency Co. LTD&quot;,  Account.Name = &quot;Hunan Mengtu Travel Technology Co., Ltd&quot;,  Account.Name = &quot;Guangzhou Meiya E-Commerce International Business Travel Service Co., Ltd&quot;,  Account.Name = &quot;MG Group&quot;,  Account.Name = &quot;MG Group&quot;,  Account.Name = &quot;Beijing Little Dragonfly Airline Service Co., Ltd.&quot;,  Account.Name = &quot;Chongqing Yunshang Aviation Ticketing Co., LTD&quot;,  Account.Name = &quot;JeTour Holding Limited&quot;,  Account.Name = &quot;JC Blue International Pte Ltd&quot;,  Account.Name = &quot;JX Nippon Oil &amp; Energy Asia Pte Ltd&quot;,  Account.Name = &quot;HitchHiker GmbH&quot;,  Account.Name = &quot;Showloy Co., Ltd.&quot;,  Account.Name = &quot;Athena&quot;   ))</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>ESSO Implementation Cases</fullName>
        <actions>
            <name>Assign_to_Jazmine</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Type</field>
            <operation>equals</operation>
            <value>ESSO</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Facilities Close Case e-mail response</fullName>
        <actions>
            <name>E_mail_to_business_requestor_when_case_is_closed</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.IsClosed</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Facilities Request</value>
        </criteriaItems>
        <description>This workflow will send an e-mail to the person that opened the case when it is closed</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Facilities Target Completion Date e-mail response</fullName>
        <actions>
            <name>E_mail_to_Business_Requestor_when_Target_Completion_Date_is_Updated</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.IsClosed</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Facilities Request</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Target_Completion_Date__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>This workflow will send an e-mail to the person that opened the case when the target completion date is updated</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Implementation Call</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Case.Type</field>
            <operation>equals</operation>
            <value>Implementation Call</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.ParentId</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>wait 7 days before assigning to Fleet Implementation Case Queue</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Assign_to_Fleet_Implementation_Case</name>
                <type>FieldUpdate</type>
            </actions>
            <timeLength>7</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>New Application</fullName>
        <actions>
            <name>Application_Submitted_Notification</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Wex Europe WE Application Cases only</description>
        <formula>/* WE Application */
RecordTypeId = &apos;012700000005x2r&apos;</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>New Transaction Dispute Form Submission</fullName>
        <actions>
            <name>Transaction_Dispute_Submitted</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>Transaction Dispute Form</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Case_Owner_Type__c</field>
            <operation>equals</operation>
            <value>Queue</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>New Virtual Sales Engineer Case</fullName>
        <actions>
            <name>New_Sales_Engineer_Case_Notification</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>AND(
  RecordType.DeveloperName = &apos;Virtual&apos;,
  TEXT(Origin) = &apos;Virtual Sales Engineer Request&apos;
)</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Overnight Implementation</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Case.Overnight__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Type</field>
            <operation>notEqual</operation>
            <value>ESSO</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.ParentId</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Assign_to_Fleet_Implementation_Case</name>
                <type>FieldUpdate</type>
            </actions>
            <timeLength>3</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>PreCard Call</fullName>
        <actions>
            <name>Assign_PreCard_Case_Queue</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Type</field>
            <operation>equals</operation>
            <value>PreCard Call</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.ParentId</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>assign to Fleet Implementation Case Queue</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Revolver Implementation Close</fullName>
        <actions>
            <name>Close_Revolver_Case</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Closed when created implementation cases on revolver apps</description>
        <formula>Opportunity__r.RecordType.Name = &apos;Revolver Record&apos;  &amp;&amp; RecordType.Name = &apos;Fleet Implementation&apos;</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>SFDC Support Close Case e-mail response</fullName>
        <actions>
            <name>SFDC_Support_E_mail_to_business_requestor_when_case_is_closed</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.IsClosed</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>WEX Salesforce Support Request,SFDC User Case</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>notEqual</operation>
            <value>Duplicate Case</value>
        </criteriaItems>
        <description>This workflow will send an e-mail to the person that opened the case when it is closed</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Saleforce Support Case being worked e-mail response</fullName>
        <actions>
            <name>Case_Being_Worked_Alert</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.User__c</field>
            <operation>notEqual</operation>
            <value></value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>WEX Salesforce Support Request</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Working</value>
        </criteriaItems>
        <description>This workflow will send an e-mail to the person that opened the case is assigned and being worked</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Salesforce Support Target Completion Date e-mail response</fullName>
        <actions>
            <name>SFDC_Support_E_mail_to_Business_Requestor_when_Target_Completion_Date_is_Updated</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Case.IsClosed</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>WEX Salesforce Support Request,SFDC User Case</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Target_Completion_Date__c</field>
            <operation>greaterThan</operation>
            <value>TODAY</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.LastModifiedById</field>
            <operation>notEqual</operation>
            <value>Salesforce Integration</value>
        </criteriaItems>
        <description>This workflow will send an e-mail to the person that opened the case when the target completion date is updated</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Target Completion Date to TODAY plus 20</fullName>
        <actions>
            <name>Target_Completiton_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Customer Success</value>
        </criteriaItems>
        <description>This is for Customer Success Record Types</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Update Case Type AM Email2Case</fullName>
        <actions>
            <name>Update_Case_Type_AM_Email2Case</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.SuppliedEmail</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Account Management Case</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Subject</field>
            <operation>notEqual</operation>
            <value>Bridgestone National Fleet Invoice Dispute Form</value>
        </criteriaItems>
        <description>Updates the case type for all AM record types coming through Email2Case when created to be existing account - currently pumping.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Virtual CS - Business Support - Close Case</fullName>
        <actions>
            <name>Virtual_CS_Business_Support_Close_Case</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Virtual Business Support CS</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Closed</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Virtual CS - Virtual Credit - Case Closed</fullName>
        <actions>
            <name>Virtual_CS_Virtual_Credit_Close_Case</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Virtual Credit CS</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Closed</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Virtual CS - Virtual Prepaid - Case Closed</fullName>
        <actions>
            <name>Virtual_CS_Virtual_Prepaid_Close_Case</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Virtual Prepaid CS</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Closed</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Virtual Payment No Manager Notification</fullName>
        <actions>
            <name>Notify_Diane_if_Virtual_Payment_case_is_unassigned</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.No_Account_Manager__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Notification_sent__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>Notify if Virtual Payments case is not assigned</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
