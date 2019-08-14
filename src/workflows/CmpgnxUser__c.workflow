<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Event_Feedback_Survey_Request</fullName>
        <description>Event Feedback Survey Request</description>
        <protected>false</protected>
        <recipients>
            <field>Attendee__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Virtual_EU_Templates/CorporatePay_Event_Feedback_Survey</template>
    </alerts>
</Workflow>
