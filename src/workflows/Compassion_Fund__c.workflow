<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Compassion_Fund_Final_Approval</fullName>
        <description>Compassion Fund - Final Approval</description>
        <protected>false</protected>
        <recipients>
            <recipient>Compassion_Fund_Manager</recipient>
            <type>group</type>
        </recipients>
        <recipients>
            <recipient>christopher.jackson@wexinc.com</recipient>
            <type>user</type>
        </recipients>
        <senderAddress>wexcares@wexinc.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Compassion_Fund_Community/Compassion_Fund_Final_Approval</template>
    </alerts>
    <alerts>
        <fullName>Compassion_Fund_Final_Rejection</fullName>
        <description>Compassion Fund - Final Rejection</description>
        <protected>false</protected>
        <recipients>
            <recipient>Compassion_Fund_Manager</recipient>
            <type>group</type>
        </recipients>
        <recipients>
            <recipient>christopher.jackson@wexinc.com</recipient>
            <type>user</type>
        </recipients>
        <senderAddress>wexcares@wexinc.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Compassion_Fund_Community/Compassion_Fund_Final_Rejection</template>
    </alerts>
    <alerts>
        <fullName>Compassion_Fund_Individual_Approval</fullName>
        <description>Compassion Fund - Individual Approval</description>
        <protected>false</protected>
        <recipients>
            <recipient>Compassion_Fund_Manager</recipient>
            <type>group</type>
        </recipients>
        <recipients>
            <recipient>christopher.jackson@wexinc.com</recipient>
            <type>user</type>
        </recipients>
        <senderAddress>wexcares@wexinc.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Compassion_Fund_Community/Compassion_Fund_Individual_Approval</template>
    </alerts>
    <alerts>
        <fullName>Compassion_Fund_Individual_Rejection</fullName>
        <description>Compassion Fund - Individual Rejection</description>
        <protected>false</protected>
        <recipients>
            <recipient>Compassion_Fund_Manager</recipient>
            <type>group</type>
        </recipients>
        <recipients>
            <recipient>christopher.jackson@wexinc.com</recipient>
            <type>user</type>
        </recipients>
        <senderAddress>wexcares@wexinc.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Compassion_Fund_Community/Compassion_Fund_Individual_Rejection</template>
    </alerts>
    <alerts>
        <fullName>Compassion_Fund_Submitted</fullName>
        <description>Compassion Fund - Submitted</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <recipient>Compassion_Fund_Manager</recipient>
            <type>group</type>
        </recipients>
        <recipients>
            <recipient>christopher.jackson@wexinc.com</recipient>
            <type>user</type>
        </recipients>
        <senderAddress>wexcares@wexinc.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Compassion_Fund_Community/Compassion_Fund_Submitted</template>
    </alerts>
    <fieldUpdates>
        <fullName>Compassion_Fund_Approval_Approved</fullName>
        <description>Updates Request Status to Approved if all approvers accept the submission.</description>
        <field>Request_Status__c</field>
        <literalValue>Approved</literalValue>
        <name>Compassion Fund Approval - Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Compassion_Fund_Approval_Board_Review</fullName>
        <description>Updates Request Status to Board Review for while approvers are reviewing application</description>
        <field>Request_Status__c</field>
        <literalValue>Board Review</literalValue>
        <name>Compassion Fund Approval - Board Review</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Compassion_Fund_Approval_Rejected</fullName>
        <description>Updates Request Status to Rejected if any approver rejects the submission.</description>
        <field>Request_Status__c</field>
        <literalValue>Rejected</literalValue>
        <name>Compassion Fund Approval - Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Compassion_Fund_Approval_Review</fullName>
        <field>Request_Status__c</field>
        <literalValue>Manager Review</literalValue>
        <name>Compassion Fund Approval - Review</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
</Workflow>
