<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>EMAP_Notify_Credit_Team_Leader_Credit_Assessment_Approved</fullName>
        <description>EMAP Notify Credit Team Leader - Credit Assessment Approved</description>
        <protected>false</protected>
        <recipients>
            <recipient>AU_Credit_Team_Leader</recipient>
            <type>role</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/EMAP_Credit_Assessment_Approved</template>
    </alerts>
    <alerts>
        <fullName>EMAP_Notify_Owner_Credit_Assessment_Approved</fullName>
        <description>EMAP Notify Owner - Credit Assessment Approved</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/EMAP_Credit_Assessment_Approved</template>
    </alerts>
    <alerts>
        <fullName>EMAP_Notify_owner_Credit_Assessment_Rejected</fullName>
        <description>EMAP Notify owner - Credit Assessment Rejected</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/EMAP_Credit_Assessment_Rejected</template>
    </alerts>
    <fieldUpdates>
        <fullName>EMAP_Update_Approval_Status_1st</fullName>
        <description>Update Approval Status as &apos;Approval 1st&apos;</description>
        <field>Approval_Status__c</field>
        <literalValue>Approval 1st</literalValue>
        <name>EMAP Update Approval Status 1st</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>EMAP_Update_Approval_Status_2nd</fullName>
        <description>Update Approval StatusFor 2nd Level</description>
        <field>Approval_Status__c</field>
        <literalValue>Approval 2nd</literalValue>
        <name>EMAP Update Approval Status 2nd</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>EMAP_Update_Approval_Status_3rd</fullName>
        <description>Update Approval Status For 3rd Level</description>
        <field>Approval_Status__c</field>
        <literalValue>Approval 3rd</literalValue>
        <name>EMAP Update Approval Status 3rd</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>EMAP_Update_Approval_Status_4th</fullName>
        <description>Update Approval Status For 4th Level</description>
        <field>Approval_Status__c</field>
        <literalValue>Approval 4th</literalValue>
        <name>EMAP Update Approval Status 4th</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>EMAP_Update_Approval_Status_Rejection</fullName>
        <field>Approval_Status__c</field>
        <literalValue>Rejected</literalValue>
        <name>EMAP Update Approval Status Rejection</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>EMAP_Update_FinalJudgement_Rejection</fullName>
        <field>Final_Judgement__c</field>
        <literalValue>Declined</literalValue>
        <name>EMAP Update FinalJudgement Rejection</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>EMAP_Update_FinalJudgemnt_RejectReason</fullName>
        <description>Update Final Judgementon Rejection Reason</description>
        <field>Credit_Assessment_Decline_Reason__c</field>
        <literalValue>Declined by approver</literalValue>
        <name>EMAP Update FinalJudgemnt RejectReason</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>EMAP_Update_Final_Judgement</fullName>
        <field>Final_Judgement__c</field>
        <literalValue>Approved</literalValue>
        <name>EMAP Update Final Judgement</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
</Workflow>
