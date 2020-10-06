<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Community_Notify_partner_community_that_a_new_announcement_has_been_posted</fullName>
        <description>Community: Notify partner community that a new announcement has been posted</description>
        <protected>false</protected>
        <recipients>
            <recipient>All_Community_Users_Group</recipient>
            <type>group</type>
        </recipients>
        <senderAddress>noreply@wexinc.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>WEX_Partner_Community_Templates/Community_Notify_partner_users_of_new_Announcement</template>
    </alerts>
    <rules>
        <fullName>Community%3A Notify partner users of new Announcement</fullName>
        <actions>
            <name>Community_Notify_partner_community_that_a_new_announcement_has_been_posted</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Announcements__c.CreatedDate</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Purpose is to notify partner users that a new announcement has been posted</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
