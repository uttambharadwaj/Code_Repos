<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Cards_Shipped_Email_Alert</fullName>
        <description>Cards Shipped Email Alert</description>
        <protected>false</protected>
        <recipients>
            <field>External_Referred_By_Contact__c</field>
            <type>contactLookup</type>
        </recipients>
        <recipients>
            <field>Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>Partner_Group_Email_Address__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>noreply@wexinc.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Online_Applications/CardsShipped</template>
    </alerts>
    <alerts>
        <fullName>Decisioned_Email_Alert</fullName>
        <description>Decisioned Email Alert</description>
        <protected>false</protected>
        <recipients>
            <field>External_Referred_By_Contact__c</field>
            <type>contactLookup</type>
        </recipients>
        <recipients>
            <field>Partner_Group_Email_Address__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>noreply@wexinc.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Online_Applications/X5a_CrDecision</template>
    </alerts>
    <alerts>
        <fullName>Edgecard_Credit_Declined_Email_Alert</fullName>
        <description>Edgecard Credit Declined Email Alert</description>
        <protected>false</protected>
        <recipients>
            <field>External_Referred_By_Contact__c</field>
            <type>contactLookup</type>
        </recipients>
        <recipients>
            <field>Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>Partner_Group_Email_Address__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>noreply@wexinc.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Fleet_Sales_EDGE/EDGE_Credit_Denied</template>
    </alerts>
    <alerts>
        <fullName>Edgecard_Credit_Declined_PREPAY_Email_Alert</fullName>
        <description>Edgecard Credit Declined PREPAY Email Alert</description>
        <protected>false</protected>
        <recipients>
            <field>External_Referred_By_Contact__c</field>
            <type>contactLookup</type>
        </recipients>
        <recipients>
            <field>Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>Partner_Group_Email_Address__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>noreply@wexinc.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Fleet_Sales_EDGE/EDGE_Credit_Declined_Prepay1</template>
    </alerts>
    <alerts>
        <fullName>Email_notification</fullName>
        <description>Email notification</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>SFDC_Admin_InternalUseOnly/eApp_Assignment_Notification</template>
    </alerts>
    <alerts>
        <fullName>Notify_Online_App_Owner</fullName>
        <ccEmails>michael.farrell@wexinc.com</ccEmails>
        <description>Notify Online App Owner</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>unfiled$public/Online_App_Assignment</template>
    </alerts>
    <alerts>
        <fullName>Online_Application_Stage_Implementation</fullName>
        <description>Online Application Stage - Implementation</description>
        <protected>false</protected>
        <recipients>
            <field>Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Partner_NASTC_Email_Templates/Changed_to_Implementation</template>
    </alerts>
    <alerts>
        <fullName>RTS_Account_Setup_Email_Alert</fullName>
        <description>RTS Account Setup Email Alert</description>
        <protected>false</protected>
        <recipients>
            <field>External_Referred_By_Contact__c</field>
            <type>contactLookup</type>
        </recipients>
        <recipients>
            <field>Partner_Group_Email_Address__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>noreply@wexinc.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Online_Applications/RTS7_AccSetup</template>
    </alerts>
    <alerts>
        <fullName>Send_Edgecard_App_Incomplete_email_alert</fullName>
        <description>Send Edgecard App Incomplete email alert</description>
        <protected>false</protected>
        <recipients>
            <field>External_Referred_By_Contact__c</field>
            <type>contactLookup</type>
        </recipients>
        <recipients>
            <field>Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>Partner_Group_Email_Address__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>noreply@wexinc.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Fleet_Sales_EDGE/EDGE_Incomplete_eApp</template>
    </alerts>
    <alerts>
        <fullName>Send_Edgecard_Cards_Shipped_email_alert</fullName>
        <description>Send Edgecard Cards Shipped email alert</description>
        <protected>false</protected>
        <recipients>
            <field>External_Referred_By_Contact__c</field>
            <type>contactLookup</type>
        </recipients>
        <recipients>
            <field>Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>Partner_Group_Email_Address__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>noreply@wexinc.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Fleet_Sales_EDGE/Cards_have_Shipped_EDGE1</template>
    </alerts>
    <alerts>
        <fullName>Send_Edgecard_Credit_Approved_Email</fullName>
        <description>Send Edgecard Credit Approved Email</description>
        <protected>false</protected>
        <recipients>
            <field>External_Referred_By_Contact__c</field>
            <type>contactLookup</type>
        </recipients>
        <recipients>
            <field>Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>Partner_Group_Email_Address__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>noreply@wexinc.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Fleet_Sales_EDGE/EDGE_Credit_Approved</template>
    </alerts>
    <alerts>
        <fullName>Send_Edgecard_Welcome_Email</fullName>
        <ccEmails>inside-implementations@wexinc.com</ccEmails>
        <description>Send Edgecard Welcome Email</description>
        <protected>false</protected>
        <recipients>
            <field>External_Referred_By_Contact__c</field>
            <type>contactLookup</type>
        </recipients>
        <recipients>
            <field>Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>Partner_Group_Email_Address__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>noreply@wexinc.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Fleet_Sales_EDGE/EDGE_Welcome_Letter</template>
    </alerts>
    <alerts>
        <fullName>Send_Incomplete_Alert</fullName>
        <description>Send Incomplete Alert</description>
        <protected>false</protected>
        <recipients>
            <field>Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>noreply@wexinc.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Online_Applications/AppIncomplete</template>
    </alerts>
    <alerts>
        <fullName>Send_LLC_Edgecard_Welcome_Email</fullName>
        <ccEmails>justine.libby@wexinc.com</ccEmails>
        <ccEmails>jessica.fought@wexinc.com</ccEmails>
        <ccEmails>tiana.tapia@wexinc.com</ccEmails>
        <description>Send LLC Edgecard Welcome Email</description>
        <protected>false</protected>
        <recipients>
            <field>External_Referred_By_Contact__c</field>
            <type>contactLookup</type>
        </recipients>
        <recipients>
            <field>Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>Partner_Group_Email_Address__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>noreply@wexinc.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Online_Applications/EDGE_Carrier_Welcome_Letter</template>
    </alerts>
    <alerts>
        <fullName>Send_Partner_Welcome_Email</fullName>
        <ccEmails>inside-implementations@wexinc.com</ccEmails>
        <description>Send Partner Welcome Email</description>
        <protected>false</protected>
        <recipients>
            <field>External_Referred_By_Contact__c</field>
            <type>contactLookup</type>
        </recipients>
        <recipients>
            <field>Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>Partner_Group_Email_Address__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>noreply@wexinc.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Online_Applications/F1_Carrier_Welcome_Letter</template>
    </alerts>
    <alerts>
        <fullName>Send_email_to_app_owner_for_esignature_status_change</fullName>
        <description>Send email to app owner for esignature status change</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>SFDC_Admin_InternalUseOnly/App_Received_Notice</template>
    </alerts>
    <alerts>
        <fullName>send_welcome_email_alert</fullName>
        <description>send welcome email alert</description>
        <protected>false</protected>
        <recipients>
            <field>External_Referred_By_Contact__c</field>
            <type>contactLookup</type>
        </recipients>
        <recipients>
            <field>Partner_Group_Email_Address__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>noreply@wexinc.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Online_Applications/AccSetup</template>
    </alerts>
    <fieldUpdates>
        <fullName>Assign_To_Michael</fullName>
        <field>OwnerId</field>
        <lookupValue>michael.monroe@efsllc.com</lookupValue>
        <lookupValueType>User</lookupValueType>
        <name>Assign To Michael</name>
        <notifyAssignee>true</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Assign_to_Alex_Kelis</fullName>
        <field>OwnerId</field>
        <lookupValueType>User</lookupValueType>
        <name>Assign to Alex Kelis</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Assign_to_Amanda</fullName>
        <field>OwnerId</field>
        <lookupValue>astack@fleetone.com</lookupValue>
        <lookupValueType>User</lookupValueType>
        <name>Assign to Amanda</name>
        <notifyAssignee>true</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Assign_to_Amanda_Keller</fullName>
        <field>OwnerId</field>
        <lookupValueType>User</lookupValueType>
        <name>Assign to Amanda Keller</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Assign_to_Ashley_Wendorff</fullName>
        <field>OwnerId</field>
        <lookupValueType>User</lookupValueType>
        <name>Assign to Ashley Wendorff</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Assign_to_Ben_Cave</fullName>
        <field>OwnerId</field>
        <lookupValue>benjamin.cave@efsllc.com</lookupValue>
        <lookupValueType>User</lookupValueType>
        <name>Assign to Ben Cave</name>
        <notifyAssignee>true</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Assign_to_Bert_Goo</fullName>
        <field>OwnerId</field>
        <lookupValueType>User</lookupValueType>
        <name>Assign to Bert Goo</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Assign_to_Bonnie_Castillo</fullName>
        <field>OwnerId</field>
        <lookupValueType>User</lookupValueType>
        <name>Assign to Bonnie Castillo</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Assign_to_Brenda_Pinon</fullName>
        <field>OwnerId</field>
        <lookupValueType>User</lookupValueType>
        <name>Assign to Brenda Pinon</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Assign_to_Bryan_Doty</fullName>
        <field>OwnerId</field>
        <lookupValueType>User</lookupValueType>
        <name>Assign to Bryan Doty</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Assign_to_CHIP_WILEY</fullName>
        <field>OwnerId</field>
        <lookupValueType>User</lookupValueType>
        <name>Assign to CHIP WILEY</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Assign_to_Christina_Kordik</fullName>
        <field>OwnerId</field>
        <lookupValueType>User</lookupValueType>
        <name>Assign to Christina Kordik</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Assign_to_Christine</fullName>
        <field>OwnerId</field>
        <lookupValue>cjennings@fleetone.com</lookupValue>
        <lookupValueType>User</lookupValueType>
        <name>Assign to Christine</name>
        <notifyAssignee>true</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Assign_to_Chuck_Miller</fullName>
        <field>OwnerId</field>
        <lookupValueType>User</lookupValueType>
        <name>Assign to Chuck Miller</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Assign_to_Cody_Barwig</fullName>
        <field>OwnerId</field>
        <lookupValueType>User</lookupValueType>
        <name>Assign to Cody Barwig</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Assign_to_Cole</fullName>
        <field>OwnerId</field>
        <lookupValue>cole.hoskins@wexinc.com</lookupValue>
        <lookupValueType>User</lookupValueType>
        <name>Assign to Cole</name>
        <notifyAssignee>true</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Assign_to_Daniel_Pesek</fullName>
        <field>OwnerId</field>
        <lookupValueType>User</lookupValueType>
        <name>Assign to Daniel Pesek</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Assign_to_Danielle</fullName>
        <field>OwnerId</field>
        <lookupValue>danielle.vidaurre@wexinc.com</lookupValue>
        <lookupValueType>User</lookupValueType>
        <name>Assign to Danielle</name>
        <notifyAssignee>true</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Assign_to_David</fullName>
        <field>OwnerId</field>
        <lookupValue>david.sedlacek@efsllc.com.wex</lookupValue>
        <lookupValueType>User</lookupValueType>
        <name>Assign to David</name>
        <notifyAssignee>true</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Assign_to_Debbie_Kimberland</fullName>
        <field>OwnerId</field>
        <lookupValueType>User</lookupValueType>
        <name>Assign to Debbie Kimberland</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Assign_to_England_Sales_Team</fullName>
        <field>OwnerId</field>
        <lookupValueType>User</lookupValueType>
        <name>Assign to England Sales Team</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Assign_to_Eric</fullName>
        <field>OwnerId</field>
        <lookupValue>eric.hunter@efsllc.com.wex</lookupValue>
        <lookupValueType>User</lookupValueType>
        <name>Assign to Eric</name>
        <notifyAssignee>true</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Assign_to_Ernane_Iung</fullName>
        <field>OwnerId</field>
        <lookupValueType>User</lookupValueType>
        <name>Assign to Ernane Iung</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Assign_to_Harold</fullName>
        <description>temporary assignment rule until new person is hired
Moved to Sam Carper until new person hired</description>
        <field>OwnerId</field>
        <lookupValue>samantha.carper@efsllc.com.wex</lookupValue>
        <lookupValueType>User</lookupValueType>
        <name>Assign to Harold</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Assign_to_JEFFREY_COLBURN</fullName>
        <field>OwnerId</field>
        <lookupValueType>User</lookupValueType>
        <name>Assign to JEFFREY COLBURN</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Assign_to_JUAN_ESTRADA</fullName>
        <field>OwnerId</field>
        <lookupValueType>User</lookupValueType>
        <name>Assign to JUAN ESTRADA</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Assign_to_James_Ladner</fullName>
        <field>OwnerId</field>
        <lookupValueType>User</lookupValueType>
        <name>Assign to James Ladner</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Assign_to_Jason_Mullican</fullName>
        <field>OwnerId</field>
        <lookupValueType>User</lookupValueType>
        <name>Assign to Jason Mullican</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Assign_to_Jay_Larson</fullName>
        <field>OwnerId</field>
        <lookupValueType>User</lookupValueType>
        <name>Assign to Jay Larson</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Assign_to_Jessi_Saker</fullName>
        <field>OwnerId</field>
        <lookupValueType>User</lookupValueType>
        <name>Assign to Jessi Saker</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Assign_to_John</fullName>
        <field>OwnerId</field>
        <lookupValue>john.white@efsllc.com.wex</lookupValue>
        <lookupValueType>User</lookupValueType>
        <name>Assign to John</name>
        <notifyAssignee>true</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Assign_to_John_Cave</fullName>
        <field>OwnerId</field>
        <lookupValue>john.cave@efsllc.com.wex</lookupValue>
        <lookupValueType>User</lookupValueType>
        <name>Assign to John Cave</name>
        <notifyAssignee>true</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Assign_to_John_F_Randles</fullName>
        <field>OwnerId</field>
        <lookupValue>jrandles@fleetone.com</lookupValue>
        <lookupValueType>User</lookupValueType>
        <name>Assign to John F Randles</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Assign_to_John_Randles</fullName>
        <field>OwnerId</field>
        <lookupValue>jrandles@fleetone.com</lookupValue>
        <lookupValueType>User</lookupValueType>
        <name>Assign to John Randles</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Assign_to_Joni</fullName>
        <field>OwnerId</field>
        <lookupValue>jcrockarell@fleetone.com</lookupValue>
        <lookupValueType>User</lookupValueType>
        <name>Assign to Joni</name>
        <notifyAssignee>true</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Assign_to_Julie_Murphy</fullName>
        <field>OwnerId</field>
        <lookupValueType>User</lookupValueType>
        <name>Assign to Julie Murphy</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Assign_to_Justin</fullName>
        <field>OwnerId</field>
        <lookupValue>justin.lee@efsllc.com.wex</lookupValue>
        <lookupValueType>User</lookupValueType>
        <name>Assign to Justin</name>
        <notifyAssignee>true</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Assign_to_Justin_Crabb</fullName>
        <field>OwnerId</field>
        <lookupValue>mandee.reams@efsllc.com</lookupValue>
        <lookupValueType>User</lookupValueType>
        <name>Assign to Mandee Reams</name>
        <notifyAssignee>true</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Assign_to_Justin_Heim</fullName>
        <field>OwnerId</field>
        <lookupValueType>User</lookupValueType>
        <name>Assign to Justin Heim</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Assign_to_Karla_Revilla</fullName>
        <field>OwnerId</field>
        <lookupValueType>User</lookupValueType>
        <name>Assign to Karla Revilla</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Assign_to_Kris</fullName>
        <field>OwnerId</field>
        <lookupValue>kris.chadwick@efsllc.com.wex</lookupValue>
        <lookupValueType>User</lookupValueType>
        <name>Assign to Kris</name>
        <notifyAssignee>true</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Assign_to_Kyle_Klatzkin</fullName>
        <field>OwnerId</field>
        <lookupValueType>User</lookupValueType>
        <name>Assign to Kyle Klatzkin</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Assign_to_Leslye_Campos</fullName>
        <field>OwnerId</field>
        <lookupValueType>User</lookupValueType>
        <name>Assign to Leslye Campos</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Assign_to_Matt_Miller</fullName>
        <field>OwnerId</field>
        <lookupValueType>User</lookupValueType>
        <name>Assign to Matt Miller</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Assign_to_Matt_Nulle</fullName>
        <field>OwnerId</field>
        <lookupValueType>User</lookupValueType>
        <name>Assign to Matt Nulle</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Assign_to_Melanie</fullName>
        <field>OwnerId</field>
        <lookupValue>melanie.sleigh@efsllc.com</lookupValue>
        <lookupValueType>User</lookupValueType>
        <name>Assign to Melanie</name>
        <notifyAssignee>true</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Assign_to_Michael_Lingman</fullName>
        <field>OwnerId</field>
        <lookupValueType>User</lookupValueType>
        <name>Assign to Michael Lingman</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Assign_to_Noel</fullName>
        <field>OwnerId</field>
        <lookupValue>noel.glasgow@efsllc.com.wex</lookupValue>
        <lookupValueType>User</lookupValueType>
        <name>Assign to Noel</name>
        <notifyAssignee>true</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Assign_to_Patti_Mielke</fullName>
        <field>OwnerId</field>
        <lookupValueType>User</lookupValueType>
        <name>Assign to Patti Mielke</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Assign_to_Raj_Parikh</fullName>
        <field>OwnerId</field>
        <lookupValueType>User</lookupValueType>
        <name>Assign to Raj Parikh</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Assign_to_Raul_Pena</fullName>
        <field>OwnerId</field>
        <lookupValueType>User</lookupValueType>
        <name>Assign to Raul Pena</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Assign_to_Reginald</fullName>
        <field>OwnerId</field>
        <lookupValue>reginald.craig@efsllc.com.wex</lookupValue>
        <lookupValueType>User</lookupValueType>
        <name>Assign to Reginald</name>
        <notifyAssignee>true</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Assign_to_Rich_Templeton</fullName>
        <field>OwnerId</field>
        <lookupValueType>User</lookupValueType>
        <name>Assign to Rich Templeton</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Assign_to_Rob_Timmons</fullName>
        <field>OwnerId</field>
        <lookupValueType>User</lookupValueType>
        <name>Assign to Rob Timmons</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Assign_to_Robert_Beard</fullName>
        <field>OwnerId</field>
        <lookupValueType>User</lookupValueType>
        <name>Assign to Robert Beard</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Assign_to_Robert_Marker</fullName>
        <field>OwnerId</field>
        <lookupValueType>User</lookupValueType>
        <name>Assign to Robert Marker</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Assign_to_Ryan_Knowles</fullName>
        <field>OwnerId</field>
        <lookupValue>ryan.knowles@efsllc.com.wex</lookupValue>
        <lookupValueType>User</lookupValueType>
        <name>Assign to Ryan Knowles</name>
        <notifyAssignee>true</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Assign_to_Sandi_Baylis</fullName>
        <description>Assign to Sandi Baylis</description>
        <field>OwnerId</field>
        <lookupValue>sbaylis@fleetone.com</lookupValue>
        <lookupValueType>User</lookupValueType>
        <name>Assign to Sandi Baylis</name>
        <notifyAssignee>true</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Assign_to_Sarah_Williams</fullName>
        <field>OwnerId</field>
        <lookupValueType>User</lookupValueType>
        <name>Assign to Sarah Williams</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Assign_to_Sheri_Breedlove</fullName>
        <field>OwnerId</field>
        <lookupValueType>User</lookupValueType>
        <name>Assign to Sheri Breedlove</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Assign_to_Steven_Newman</fullName>
        <field>OwnerId</field>
        <lookupValueType>User</lookupValueType>
        <name>Assign to Steven Newman</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Assign_to_TRENT_MURPHY</fullName>
        <field>OwnerId</field>
        <lookupValueType>User</lookupValueType>
        <name>Assign to TRENT MURPHY</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Assign_to_Tony</fullName>
        <description>Eapp with 200+ unitis in those states gets assigned to this user</description>
        <field>OwnerId</field>
        <lookupValue>tony.lehenbauer@efsllc.com.wex</lookupValue>
        <lookupValueType>User</lookupValueType>
        <name>Assign to Tony</name>
        <notifyAssignee>true</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Assign_to_Trey_Heath</fullName>
        <field>OwnerId</field>
        <lookupValueType>User</lookupValueType>
        <name>Assign to Trey Heath</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Assign_to_Trish</fullName>
        <field>OwnerId</field>
        <lookupValue>andria.bowens@efsllc.com</lookupValue>
        <lookupValueType>User</lookupValueType>
        <name>Assign to Trish</name>
        <notifyAssignee>true</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Assign_to_Tyler</fullName>
        <description>Assign Application to Tyler</description>
        <field>OwnerId</field>
        <lookupValue>tyler.thompson@fleetone.com</lookupValue>
        <lookupValueType>User</lookupValueType>
        <name>Assign to Tyler</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Assign_to_Willie_Andruss</fullName>
        <field>OwnerId</field>
        <lookupValueType>User</lookupValueType>
        <name>Assign to Willie Andruss</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Assign_to_Yance</fullName>
        <field>OwnerId</field>
        <lookupValue>yance.baker@efsllc.com.wex</lookupValue>
        <lookupValueType>User</lookupValueType>
        <name>Assign to Yance</name>
        <notifyAssignee>true</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Assign_to_Zach</fullName>
        <field>OwnerId</field>
        <lookupValue>zjohnson@fleetone.com</lookupValue>
        <lookupValueType>User</lookupValueType>
        <name>Assign to Zach</name>
        <notifyAssignee>true</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Assign_to_Zachwall</fullName>
        <field>OwnerId</field>
        <lookupValueType>User</lookupValueType>
        <name>Assign to Zach</name>
        <notifyAssignee>true</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Assing_to_Jerry_Van_Wyk</fullName>
        <field>OwnerId</field>
        <lookupValueType>User</lookupValueType>
        <name>Assing to Jerry Van Wyk</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Assing_to_Larry_Cuddy</fullName>
        <field>OwnerId</field>
        <lookupValueType>User</lookupValueType>
        <name>Assing to Larry Cuddy</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Brady_Dransfield</fullName>
        <field>OwnerId</field>
        <lookupValueType>User</lookupValueType>
        <name>John Aalders</name>
        <notifyAssignee>true</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CarsArrive</fullName>
        <field>OwnerId</field>
        <lookupValueType>User</lookupValueType>
        <name>CarsArrive</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Change_owner_of_Online_App_from_Guest_Us</fullName>
        <field>OwnerId</field>
        <lookupValue>fgotten@fleetone.com</lookupValue>
        <lookupValueType>User</lookupValueType>
        <name>Change owner of Online App from Guest Us</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>JB_Hunt_Online_App_Assignment</fullName>
        <description>Assign to JB Hunt Implementation Queue</description>
        <field>OwnerId</field>
        <lookupValue>JB_Hunt_Implementation</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>JB Hunt Online App Assignment</name>
        <notifyAssignee>true</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Offer_Name_WF_TXT</fullName>
        <field>Offer_Name_WF_TXT__c</field>
        <formula>Offer__r.Name</formula>
        <name>Update Offer Name WF TXT to Offer</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Owner</fullName>
        <description>Change Online Application Owner to partner user D&amp;S Support.</description>
        <field>OwnerId</field>
        <lookupValueType>User</lookupValueType>
        <name>Owner D&amp;S Support</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Owner_BSNF_Fuel_Card_Jared_Williams</fullName>
        <field>OwnerId</field>
        <lookupValueType>User</lookupValueType>
        <name>Owner - BSNF Fuel Card (Jared Williams)</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Owner_Changed_to_Dennis_Woods</fullName>
        <field>OwnerId</field>
        <lookupValueType>User</lookupValueType>
        <name>Owner Changed to Dennis Woods</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Owner_Changed_to_WILLIE_ANDRUSS</fullName>
        <field>OwnerId</field>
        <lookupValueType>User</lookupValueType>
        <name>Owner Changed to WILLIE ANDRUSS</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Owner_Corey_Luttrell</fullName>
        <field>OwnerId</field>
        <lookupValue>marti.watson@efsllc.com.wex</lookupValue>
        <lookupValueType>User</lookupValueType>
        <name>Owner Ryan Momodou</name>
        <notifyAssignee>true</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Owner_D_S_Fuel_Card_Candy_Hill</fullName>
        <field>OwnerId</field>
        <lookupValueType>User</lookupValueType>
        <name>Owner - D&amp;S Fuel Card (Candy Hill)</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Owner_Dave_Swan</fullName>
        <field>OwnerId</field>
        <lookupValueType>User</lookupValueType>
        <name>Owner Dave Swan</name>
        <notifyAssignee>true</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Owner_Discount_Diesel_Fuel_Card</fullName>
        <description>Set the owner to George Williams for Discount Diesel Fuel Card Apps</description>
        <field>OwnerId</field>
        <lookupValueType>User</lookupValueType>
        <name>Owner - Discount Diesel Fuel Card</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Owner_Eapp_Queue</fullName>
        <field>OwnerId</field>
        <lookupValue>eapp_Queue</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Owner Eapp Queue</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Owner_England_Logistics_TL</fullName>
        <field>OwnerId</field>
        <lookupValueType>User</lookupValueType>
        <name>Owner England Logistics- TL1</name>
        <notifyAssignee>true</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Owner_Fleet_Savings</fullName>
        <field>OwnerId</field>
        <lookupValueType>User</lookupValueType>
        <name>Owner - Fleet Savings (Michele VanCleve)</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Owner_Jessie_Singh</fullName>
        <description>Change owner of Online App from Guest User to Jessie Singh, based on the Application Title.</description>
        <field>OwnerId</field>
        <lookupValueType>User</lookupValueType>
        <name>Owner Jessie Singh</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Owner_Joni_Crockarell</fullName>
        <description>Change Online Application Owner to Joni Crockarell</description>
        <field>OwnerId</field>
        <lookupValue>jcrockarell@fleetone.com</lookupValue>
        <lookupValueType>User</lookupValueType>
        <name>Owner Joni Crockarell</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Owner_Josh_Norris</fullName>
        <field>OwnerId</field>
        <lookupValueType>User</lookupValueType>
        <name>Owner Josh Norris</name>
        <notifyAssignee>true</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Owner_Martha_Ibarra</fullName>
        <description>Set owner to Martha Ibarra if PrePass A, B, or C</description>
        <field>OwnerId</field>
        <lookupValueType>User</lookupValueType>
        <name>Owner Martha Ibarra</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Owner_Milos_Pavlovic</fullName>
        <field>OwnerId</field>
        <lookupValueType>User</lookupValueType>
        <name>Owner Milos Pavlovic</name>
        <notifyAssignee>true</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Owner_Pavestone_Capital</fullName>
        <description>Change Online Application Owner to partner user Pavestone Capital.</description>
        <field>OwnerId</field>
        <lookupValueType>User</lookupValueType>
        <name>Owner Pavestone Capital</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Owner_RTS</fullName>
        <field>OwnerId</field>
        <lookupValue>RTS_Partner_Queue</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Owner RTS</name>
        <notifyAssignee>true</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Owner_Roady_s_Card</fullName>
        <description>Change Online Application Owner to partner user Roady&apos;s Card.</description>
        <field>OwnerId</field>
        <lookupValueType>User</lookupValueType>
        <name>Owner Roady&apos;s Card</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Owner_STC</fullName>
        <description>When Application starts with STC assign to STC partner</description>
        <field>OwnerId</field>
        <lookupValueType>User</lookupValueType>
        <name>Owner - STC</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Owner_Shelly_Gordon</fullName>
        <description>Change owner to Shelly Gordon (Faye Gotten until Shelly&apos;s replacement)</description>
        <field>OwnerId</field>
        <lookupValue>fgotten@fleetone.com</lookupValue>
        <lookupValueType>User</lookupValueType>
        <name>Owner Shelly Gordon</name>
        <notifyAssignee>true</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Owner_Single_Point_Fuel_Card</fullName>
        <description>Set the owner to Becki Tarver for Single Point Fuel Card Apps</description>
        <field>OwnerId</field>
        <lookupValueType>User</lookupValueType>
        <name>Owner - Single Point Fuel Card</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Owner_Truckers_B2B</fullName>
        <description>Change owner of Online App from Guest User to Danielle Vidaurre , based on the Application Title.</description>
        <field>OwnerId</field>
        <lookupValue>sstein@truckersb2b.com.wex</lookupValue>
        <lookupValueType>User</lookupValueType>
        <name>Owner - Truckers B2B Danielle Vidaurre</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Partner_Group_Email</fullName>
        <description>Offer__r.Partner_Group_Email_Address__c</description>
        <field>Partner_Group_Email_Address__c</field>
        <formula>Offer__r.Partner_Group_Email_Address__c</formula>
        <name>Partner Group Email</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Populate_Credit_Approved_Amount</fullName>
        <field>Credit_Line_Approved__c</field>
        <formula>Credit_Line_Requested__c</formula>
        <name>Populate Credit Approved Amount</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Michael_Lingman_as_owner</fullName>
        <field>OwnerId</field>
        <lookupValueType>User</lookupValueType>
        <name>Set Michael Lingman as owner</name>
        <notifyAssignee>true</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Owner_to_Knight_Logistics</fullName>
        <field>OwnerId</field>
        <lookupValue>fgotten@fleetone.com</lookupValue>
        <lookupValueType>User</lookupValueType>
        <name>Set owner Knight Logistics</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Owner_to_OTR_IS_Apps_Queue</fullName>
        <description>Set Owner to OTR IS Apps Queue</description>
        <field>OwnerId</field>
        <lookupValue>OTR_IS_Apps</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Set Owner to OTR IS Apps Queue</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_PlusCheks</fullName>
        <field>PlusChek__c</field>
        <formula>Number_of_Cards_Needed__c</formula>
        <name>Set PlusCheks #</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_owner_to_FleetPro_Services</fullName>
        <field>OwnerId</field>
        <lookupValue>fgotten@fleetone.com</lookupValue>
        <lookupValueType>User</lookupValueType>
        <name>Set owner to FleetPro Services</name>
        <notifyAssignee>true</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UpdateStatusPendingSetupData</fullName>
        <field>Status__c</field>
        <literalValue>Pending Setup Data</literalValue>
        <name>UpdateStatusPendingSetupData</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Owner_RTS</fullName>
        <description>Change owner of Online App from Guest User to RTS Queue based on the Offer Name WF Text.</description>
        <field>OwnerId</field>
        <lookupValue>RTS_Partner_Queue</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Update Owner RTS</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_To_Cards_Produced</fullName>
        <field>Status__c</field>
        <literalValue>Cards Produced</literalValue>
        <name>Update To Cards Produced</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_eApp_Owner_Faye_Gotten</fullName>
        <description>Update owner to Faye Gotten</description>
        <field>OwnerId</field>
        <lookupValue>fgotten@fleetone.com</lookupValue>
        <lookupValueType>User</lookupValueType>
        <name>Update eApp Owner - Faye Gotten</name>
        <notifyAssignee>true</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Updated_Owner_RTS</fullName>
        <description>Change owner of Online App from Guest User to RTS Queue based on the Application Title.</description>
        <field>OwnerId</field>
        <lookupValue>RTS_Partner_Queue</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Update Owner RTS</name>
        <notifyAssignee>true</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>clear_In_Progress_flag</fullName>
        <field>In_Progress__c</field>
        <literalValue>0</literalValue>
        <name>clear In Progress flag</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>clear_In_Progress_user</fullName>
        <field>In_Progress_User__c</field>
        <name>clear In Progress user</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>eApp_Owner_CSI_Global_Fleet</fullName>
        <field>OwnerId</field>
        <lookupValueType>User</lookupValueType>
        <name>Owner - CSI Global-Fleet</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>eApp_Owner_Denise_Offutt</fullName>
        <description>Change Online Application Owner to Denise Offutt.</description>
        <field>OwnerId</field>
        <lookupValue>doffutt@fleetone.com</lookupValue>
        <lookupValueType>User</lookupValueType>
        <name>eApp Owner - Denise Offutt</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>eApp_Owner_Faye_Gotten</fullName>
        <field>OwnerId</field>
        <lookupValue>fgotten@fleetone.com</lookupValue>
        <lookupValueType>User</lookupValueType>
        <name>eApp Owner - Faye Gotten</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>eApp_Owner_Kyle_Cox_Quality_Companies</fullName>
        <description>Assign the Quality Companies eApps to Kyle Cox (Partner User)</description>
        <field>OwnerId</field>
        <lookupValueType>User</lookupValueType>
        <name>eApp Owner - Kyle Cox -Quality Companies</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>nastc_owner</fullName>
        <description>Change Online Application Owner to John Randles</description>
        <field>OwnerId</field>
        <lookupValue>jrandles@fleetone.com</lookupValue>
        <lookupValueType>User</lookupValueType>
        <name>NASTC set owner to Randles</name>
        <notifyAssignee>true</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>set_Credit_Limit_Requested</fullName>
        <field>Credit_Line_Requested__c</field>
        <formula>0</formula>
        <name>set Credit Limit Requested</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>set_In_Progress_user</fullName>
        <field>In_Progress_User__c</field>
        <formula>$User.FirstName+&quot; &quot;+$User.LastName</formula>
        <name>set In Progress user</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>set_NASTC_Directory</fullName>
        <field>NASTC_QPN_Directory__c</field>
        <formula>Number_of_Cards_Needed__c</formula>
        <name>set NASTC Directory</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>set_Owner_to_CarsArrive</fullName>
        <field>OwnerId</field>
        <lookupValueType>User</lookupValueType>
        <name>set Owner to CarsArrive</name>
        <notifyAssignee>true</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>set_Owner_to_Tom_Moreland</fullName>
        <field>OwnerId</field>
        <lookupValueType>User</lookupValueType>
        <name>set Owner to Tom Moreland</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>set_Stage_to_Implementation</fullName>
        <field>Application_Stage__c</field>
        <literalValue>Implementation</literalValue>
        <name>set Stage to Implementation</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>set_Status_to_Pending_Setup</fullName>
        <description>If all these fields are complete the status will change to Pending Setup.</description>
        <field>Status__c</field>
        <literalValue>Pending Setup</literalValue>
        <name>set Status to Pending Setup</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>App Owner - CenterFire</fullName>
        <actions>
            <name>Assign_to_Justin_Heim</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>OnlineApplication__c.Offer_Name_WF_TXT__c</field>
            <operation>startsWith</operation>
            <value>CenterFire</value>
        </criteriaItems>
        <criteriaItems>
            <field>OnlineApplication__c.CreatedById</field>
            <operation>equals</operation>
            <value>CreditApplication Site Guest User</value>
        </criteriaItems>
        <description>Change owner of Online App from Guest User to Justin Heim, based on the Offer Name WF TXT.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>App Owner - Patriot Fleet</fullName>
        <actions>
            <name>Assign_to_Michael_Lingman</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>OnlineApplication__c.Offer_Name_WF_TXT__c</field>
            <operation>startsWith</operation>
            <value>Patriot Fleet</value>
        </criteriaItems>
        <criteriaItems>
            <field>OnlineApplication__c.CreatedById</field>
            <operation>equals</operation>
            <value>CreditApplication Site Guest User</value>
        </criteriaItems>
        <description>Change owner of Online App from Guest User to Michael Lingman, based on the Offer Name WF TXT.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Audit Complete Email Alert</fullName>
        <actions>
            <name>send_welcome_email_alert</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>email sent when online app status equals audit complete</description>
        <formula>ISPICKVAL(Status__c,&quot;Audit Complete&quot;) &amp;&amp;
Owner:User.ProfileId &lt;&gt; &quot;00e70000000xEKrAAM&quot; &amp;&amp;
Offer__c &lt;&gt; &quot;a3L700000002GaB&quot; &amp;&amp;
Offer__c &lt;&gt; &quot;a3L70000000koW8&quot; &amp;&amp;
NOT(CONTAINS(Application_Title__c, &quot;rts&quot;))</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Bring over Offer Group Email</fullName>
        <actions>
            <name>Partner_Group_Email</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>OnlineApplication__c.Name</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Bring over the email address from the associated Offer for the partner group</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Cards Shipped Email Alert</fullName>
        <actions>
            <name>Cards_Shipped_Email_Alert</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <description>sent when online app status equals cards shipped</description>
        <formula>AND(
  OR(
    ISPICKVAL(Status__c,&quot;Cards Shipped&quot;),
    ISPICKVAL(Status__c,&quot;Cards Produced&quot;)
    ),
  Owner:User.ProfileId &lt;&gt; &quot;00e70000000xEKr&quot;,
  Number_of_Cards_Needed__c &gt;= 1,
  Offer__c &lt;&gt; &quot;a3L700000002GaB&quot;,
  Offer__c &lt;&gt; &quot;a3L70000000koW8&quot;
)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Corecard Edgecard Audit Complete Email Alert</fullName>
        <actions>
            <name>Send_Edgecard_Welcome_Email</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <description>Welcome email sent when online app offer = Edgecard and Status = Cards Produced</description>
        <formula>Offer__c = &quot;a3L700000002GaB&quot;   
&amp;&amp; ISPICKVAL(Status__c,&quot;Cards Produced&quot;)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Decisioned Email Alert</fullName>
        <actions>
            <name>Decisioned_Email_Alert</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>OnlineApplication__c.Status__c</field>
            <operation>equals</operation>
            <value>Decisioned</value>
        </criteriaItems>
        <criteriaItems>
            <field>OnlineApplication__c.OwnerId</field>
            <operation>notEqual</operation>
            <value>appl Site Guest User</value>
        </criteriaItems>
        <description>email is sent to when app status = decisioned</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Default App Incomplete Email Alert</fullName>
        <actions>
            <name>Send_Incomplete_Alert</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>sent when online app status equals saved incomplete and offer does not equal edgecard</description>
        <formula>ISPICKVAL(Status__c,&quot;Saved-Incomplete&quot;) &amp;&amp; 
Owner:User.ProfileId &lt;&gt; &quot;00e70000000xEKr&quot; &amp;&amp; 
Offer__c &lt;&gt; &quot;a3L700000002GaB&quot;</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Edgecard App Incomplete Email Alert</fullName>
        <actions>
            <name>Send_Edgecard_App_Incomplete_email_alert</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>sent when online app status equals saved incomplete and offer equals edgecard</description>
        <formula>ISPICKVAL(Status__c,&quot;Saved-Incomplete&quot;) &amp;&amp;
Owner:User.ProfileId &lt;&gt; &quot;00e70000000xEKr&quot; &amp;&amp;
Offer__c = &quot;a3L700000002GaB&quot;</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Edgecard Cards Shipped Email Alert</fullName>
        <actions>
            <name>Send_Edgecard_Cards_Shipped_email_alert</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>sent when online app status equals cards shipped and offer equals edgecard</description>
        <formula>ISPICKVAL(Status__c,&quot;Cards Shipped&quot;) &amp;&amp;
Owner:User.ProfileId &lt;&gt; &quot;00e70000000xEKr&quot; &amp;&amp;
Number_of_Cards_Needed__c &gt;= 1 &amp;&amp;
Offer__c = &quot;a3L700000002GaB&quot;</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Edgecard Credit Approved Email Alert</fullName>
        <actions>
            <name>Send_Edgecard_Credit_Approved_Email</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>sent when online app status equals &quot;Approved-Requested&quot; OR &quot;Approved-Counter Offer&quot; OR &quot;Approved-Secured Requested&quot; and offer equals edgecard</description>
        <formula>OR(ISPICKVAL(Credit_Decision__c ,&quot;Approved-Requested&quot;),
ISPICKVAL(Credit_Decision__c ,&quot;Approved-Counter Offer&quot;), ISPICKVAL(Credit_Decision__c ,&quot;Approved-Secured Requested&quot;)) &amp;&amp;
Owner:User.ProfileId &lt;&gt; &quot;00e70000000xEKr&quot; &amp;&amp;
Offer__c = &quot;a3L700000002GaB&quot;</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Edgecard Credit Declined Email Alert</fullName>
        <actions>
            <name>Edgecard_Credit_Declined_Email_Alert</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>sent when online app status equals &quot;Declined&quot; and offer equals edgecard</description>
        <formula>ISPICKVAL(Credit_Decision__c ,&quot;Declined&quot;)&amp;&amp; 
Owner:User.ProfileId &lt;&gt; &quot;00e70000000xEKr&quot; &amp;&amp; 
Offer__c = &quot;a3Le00000006kbP&quot; &amp;&amp; ISPICKVAL(Status__c, &apos;Decisioned&apos;)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Edgecard Declined-Prepay Email Alert</fullName>
        <actions>
            <name>Edgecard_Credit_Declined_PREPAY_Email_Alert</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>sent when online app status equals &quot;Declined-Prepay/Secured Only&quot; and offer equals edgecard</description>
        <formula>ISPICKVAL(Credit_Decision__c ,&apos;Declined-Prepay/Secured Only&apos;) &amp;&amp; 
Owner:User.ProfileId &lt;&gt; &quot;00e70000000xEKr&quot; &amp;&amp; 
Offer__c = &quot;a3Le00000006kbP&quot; &amp;&amp; ISPICKVAL(Status__c, &apos;Decisioned&apos;)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>JB Hunt Online App Assignment</fullName>
        <actions>
            <name>JB_Hunt_Online_App_Assignment</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>OnlineApplication__c.Offer_Name__c</field>
            <operation>equals</operation>
            <value>J.B. Hunt 360 Carrier Program</value>
        </criteriaItems>
        <description>Assign to JB Hunt Implementation Queue</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>LLC Edgecard Audit Complete Email Alert</fullName>
        <actions>
            <name>Send_LLC_Edgecard_Welcome_Email</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <description>Welcome email sent when online app offer = Edgecard and Status = Cards Produced</description>
        <formula>Offer__c = &quot;a3L0g000000HJ7g&quot; &amp;&amp;
ISPICKVAL(Status__c,&quot;Cards Produced&quot;) &amp;&amp;
$User.Id = &apos;00570000005FfZv&apos;</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Move To Cards Produced After LLC Integration Complete</fullName>
        <actions>
            <name>Update_To_Cards_Produced</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <formula>AND($User.Id = &apos;00570000005FfZv&apos;, OR( PRIORVALUE( AR_ID_Number__c) == null, PRIORVALUE( Carrier_ID_Number__c) == null ),   Carrier_ID_Number__c != null, AR_ID_Number__c != null  )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>NASTC Directories</fullName>
        <actions>
            <name>set_NASTC_Directory</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>OnlineApplication__c.Application_Title__c</field>
            <operation>startsWith</operation>
            <value>NASTC</value>
        </criteriaItems>
        <criteriaItems>
            <field>OnlineApplication__c.Number_of_Cards_Needed__c</field>
            <operation>greaterThan</operation>
            <value>0</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>NASTC Implementation eAppp</fullName>
        <actions>
            <name>Online_Application_Stage_Implementation</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>OnlineApplication__c.Application_Title__c</field>
            <operation>startsWith</operation>
            <value>NASTC</value>
        </criteriaItems>
        <criteriaItems>
            <field>OnlineApplication__c.Application_Stage__c</field>
            <operation>equals</operation>
            <value>Implementation</value>
        </criteriaItems>
        <criteriaItems>
            <field>OnlineApplication__c.Status__c</field>
            <operation>equals</operation>
            <value>Pending Setup</value>
        </criteriaItems>
        <description>automatic email to be triggered once their Online Application status is changed to “Implementation”</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Notify sales of esign status</fullName>
        <actions>
            <name>Send_email_to_app_owner_for_esignature_status_change</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>OnlineApplication__c.eSignature_Status__c</field>
            <operation>equals</operation>
            <value>Executed and Invalid Signer,Executed and Received</value>
        </criteriaItems>
        <criteriaItems>
            <field>OnlineApplication__c.OwnerId</field>
            <operation>notEqual</operation>
            <value>appl Site Guest User</value>
        </criteriaItems>
        <description>When eSignature Status is Executive and Received, or &quot;Executed and Invalid Signer&quot; send an email notice to the application owner.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Offer Name WF TXT - Offer</fullName>
        <actions>
            <name>Offer_Name_WF_TXT</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>OnlineApplication__c.Offer_Name__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Change Offer Name WF TXT of Online App based on the Offer Name.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Online Application - Notify OTR IS Rep Of Round Robin Assignment</fullName>
        <actions>
            <name>Notify_Online_App_Owner</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <formula>AND(
  CreatedBy.Alias = &quot;guest&quot;,
  Owner:User.UserRole.Name = &quot;OTR IS Sales Inbound&quot;
)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>RTS Audit Complete Email Alert</fullName>
        <actions>
            <name>RTS_Account_Setup_Email_Alert</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>email sent when online app status equals audit complete for RTS Apps</description>
        <formula>ISPICKVAL(Status__c,&quot;Audit Complete&quot;) &amp;&amp;
Owner:User.ProfileId &lt;&gt; &quot;00e70000000xEKrAAM&quot; &amp;&amp;
Offer__c &lt;&gt; &quot;a3L700000002GaB&quot; &amp;&amp;
CONTAINS(Application_Title__c, &quot;rts&quot;)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Set Owner to OTR IS APPs Queue</fullName>
        <actions>
            <name>Set_Owner_to_OTR_IS_Apps_Queue</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>Set Owner to OTR IS APPs Queue when TRUE</description>
        <formula>AND( 
  Number_of_Trucks__c &lt;= 50, 
  Number_of_Trucks__c &gt;= 3,
  NOT(ISPICKVAL(Status__c, &quot;App-Incomplete&quot;)),
  OR( 
    CreatedById = &apos;00570000002S3Sl&apos;, 
    CreatedById = &apos;00570000003hCBt&apos; 
  ), 
  OR( 
    Offer__r.Name = &apos;WEX Fleet One All Roads&apos;, 
    Offer__r.Name = &apos;Fleet One LLC Edge BOCA&apos;, 
    Offer__r.Name = &apos;Fleet One Over the Road&apos;, 
    Offer__r.Name = &apos;Fleet One Owner/Operator OO-2015&apos;, 
    Offer__r.Name = &apos;Fleet One EDGE&apos;, 
    Offer__r.Name = &apos;Fleet One Over the Road O/O Microsite 2016&apos;, 
    Offer__r.Name = &apos;RR - Over the Road&apos;, 
    Offer__r.Name = &apos;Fleet One Edge Over The Road&apos;,
    Offer__r.Name = &apos;Fleet One Edge LLC BOCA SG&apos; 
  ) 
)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Set PlusCheks %23</fullName>
        <actions>
            <name>Set_PlusCheks</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>and(
Number_of_Cards_Needed__c &gt; 0,
or(
includes(Other_Services__c, &quot;ATM &amp; PlusCheks&quot;),
includes(Other_Services__c, &quot;PlusCheks Only&quot;)
))</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Set PrePay Credit Limit</fullName>
        <actions>
            <name>set_Credit_Limit_Requested</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>OnlineApplication__c.Billing_Cycle__c</field>
            <operation>equals</operation>
            <value>Prepay</value>
        </criteriaItems>
        <description>When Billing Frequency = PrePay, set Credit Limit to PrePay</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Update Credit Line Approved</fullName>
        <actions>
            <name>Populate_Credit_Approved_Amount</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ISPICKVAL(Address_Verification_Source__c, &quot;BizID-Pass&quot;)&amp;&amp;  Offer__r.Name = &quot;Fuelbook Select&quot;</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Update Status Decisioned to Pending Setup</fullName>
        <actions>
            <name>set_Status_to_Pending_Setup</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>If all these fields are complete the status will change to Pending Setup.</description>
        <formula>AND( 

(OR(Text(Credit_Decision__c) = &apos;Approved-Requested&apos;, 
Text(Credit_Decision__c) = &apos;Approved-Counter Accepted&apos;, 
Text(Credit_Decision__c) = &apos;Approved-Secured Accepted&apos; 
)), 

Text(Status__c) = &apos;Decisioned&apos;, 
not(ISBLANK(Offer__c )), 
not(ISBLANK( Text(Product_Type__c))), 
not(ISBLANK(Credit_Line_Approved__c)), 
not(ISBLANK(Legal_Business_Name__c)), 
not(ISBLANK(Business_Street_Address__c)), 
not(ISBLANK(City__c)), 
not(ISBLANK(Text(State__c))), 
not(ISBLANK(Zip_Code__c)), 
not(ISBLANK(Email__c)), 
not(ISBLANK(Contact_Name__c)), 
not(ISBLANK(Phone_Number__c)), 
not(ISBLANK(Text(Billing_Cycle__c))), 
not(ISBLANK(Text(Payment_Method__c))), 
not(ISBLANK(Day_of_Payment__c)), 
not(ISBLANK(Text(Invoice_Delivery_Method__c))), 
not(ISBLANK(Invoice_Delivery_Method_Email__c)), 
not(ISBLANK(Financial_Institution__c)), 
not(ISBLANK(Branch_Phone_Number__c)), 
not(ISBLANK(Branch_City__c)), 
not(ISBLANK(Text(Branch_State__c))), 
Driver_Setup_Count__c &gt;0, 
not(ISBLANK(AO_Name__c)), 
not(ISBLANK(AO_Address__c)), 
not(ISBLANK(AO_City__c)), 
not(ISBLANK(Text(AO_State__c))), 
not(ISBLANK(AO_Zip_Code__c)), 
or(Unit__c=FALSE, and(Unit__c=TRUE, Unit_Count__c &gt; 0)) 

)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Update Status Decisioned to Pending Setup Data</fullName>
        <actions>
            <name>UpdateStatusPendingSetupData</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>set_Stage_to_Implementation</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>If any of these fields is blank or not complete the status will change to Pending Setup Data.</description>
        <formula>and( 

AND( 
Text(Status__c) = &apos;Decisioned&apos;, 
(OR(Text(Credit_Decision__c) = &apos;Approved-Requested&apos;, 
Text(Credit_Decision__c) = &apos;Approved-Counter Accepted&apos;, 
Text(Credit_Decision__c) = &apos;Approved-Secured Accepted&apos; 
)), 

(or( 

ISBLANK(Offer__c ), 
ISBLANK( Text(Product_Type__c)), 
ISBLANK(Credit_Line_Approved__c), 
ISBLANK(Legal_Business_Name__c), 
ISBLANK(Business_Street_Address__c), 
ISBLANK(City__c), 
ISBLANK(Text(State__c)), 
ISBLANK(Zip_Code__c), 
ISBLANK(Email__c), 
ISBLANK(Contact_Name__c), 
ISBLANK(Phone_Number__c), 
ISBLANK(Text(Billing_Cycle__c)), 
ISBLANK(Text(Payment_Method__c)), 
ISBLANK(Day_of_Payment__c), 
ISBLANK(Text(Invoice_Delivery_Method__c)), 
ISBLANK(Invoice_Delivery_Method_Email__c), 
ISBLANK(Financial_Institution__c), 
ISBLANK(Branch_Phone_Number__c), 
ISBLANK(Branch_City__c), 
ISBLANK(Text(Branch_State__c)), 
ISBLANK(AO_Name__c), 
ISBLANK(AO_Address__c), 
ISBLANK(AO_City__c), 
ISBLANK(Text(AO_State__c)), 
ISBLANK(AO_Zip_Code__c), 
Driver_Setup_Count__c =0, 
and(Unit__c=TRUE,Unit_Count__c = 0) 

) 
) 
))</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Update Status from Pending Setup Data to Pending Setup</fullName>
        <actions>
            <name>set_Status_to_Pending_Setup</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>If all these fields are complete the status will change to Pending Setup.</description>
        <formula>AND( 

(OR(Text(Credit_Decision__c) = &apos;Approved-Requested&apos;, 
Text(Credit_Decision__c) = &apos;Approved-Counter Accepted&apos;, 
Text(Credit_Decision__c) = &apos;Approved-Secured Accepted&apos; 
)), 

Text(Status__c) = &apos;Pending Setup Data&apos;, 
Credit_Line_Approved__c&gt;0, 
not(ISBLANK(Offer__c )), 
not(ISBLANK( Text(Product_Type__c))), 
not(ISBLANK(Legal_Business_Name__c)), 
not(ISBLANK(Business_Street_Address__c)), 
not(ISBLANK(City__c)), 
not(ISBLANK(Text(State__c))), 
not(ISBLANK(Zip_Code__c)), 
not(ISBLANK(Email__c)), 
not(ISBLANK(Contact_Name__c)), 
not(ISBLANK(Phone_Number__c)), 
not(ISBLANK(Text(Billing_Cycle__c))), 
not(ISBLANK(Text(Payment_Method__c))), 
not(ISBLANK(Day_of_Payment__c)), 
not(ISBLANK(Text(Invoice_Delivery_Method__c))), 
not(ISBLANK(Invoice_Delivery_Method_Email__c)), 
not(ISBLANK(Financial_Institution__c)), 
not(ISBLANK(Branch_Phone_Number__c)), 
not(ISBLANK(Branch_City__c)), 
not(ISBLANK(Text(Branch_State__c))), 
Driver_Setup_Count__c &gt;0, 
not(ISBLANK(AO_Name__c)), 
not(ISBLANK(AO_Address__c)), 
not(ISBLANK(AO_City__c)), 
not(ISBLANK(Text(AO_State__c))), 
not(ISBLANK(AO_Zip_Code__c)), 
or(Unit__c=FALSE, and(Unit__c=TRUE, Unit_Count__c &gt; 0)) 

)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>clear In Progress when Status changes</fullName>
        <actions>
            <name>clear_In_Progress_flag</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>clear_In_Progress_user</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ISCHANGED(Status__c)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>eApp Owner - 123Loadboard</fullName>
        <actions>
            <name>Owner_Changed_to_WILLIE_ANDRUSS</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>OnlineApplication__c.Offer_Name_WF_TXT__c</field>
            <operation>startsWith</operation>
            <value>123Loadboard</value>
        </criteriaItems>
        <criteriaItems>
            <field>OnlineApplication__c.CreatedById</field>
            <operation>equals</operation>
            <value>CreditApplication Site Guest User</value>
        </criteriaItems>
        <description>Change owner of Online App from Guest User to WILLIE ANDRUSS, based on the Offer Name WF TXT.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>eApp Owner - AMBEST</fullName>
        <actions>
            <name>Assign_to_Matt_Miller</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>OnlineApplication__c.Offer_Name_WF_TXT__c</field>
            <operation>startsWith</operation>
            <value>AMBEST</value>
        </criteriaItems>
        <criteriaItems>
            <field>OnlineApplication__c.CreatedById</field>
            <operation>equals</operation>
            <value>CreditApplication Site Guest User</value>
        </criteriaItems>
        <description>Change owner of Online App from Guest User to Matthew Miller, based on the Offer Name WF TXT.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>eApp Owner - Aable iFleet</fullName>
        <actions>
            <name>Assign_to_Daniel_Pesek</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>OnlineApplication__c.Offer_Name_WF_TXT__c</field>
            <operation>startsWith</operation>
            <value>Aable iFleet</value>
        </criteriaItems>
        <criteriaItems>
            <field>OnlineApplication__c.CreatedById</field>
            <operation>equals</operation>
            <value>CreditApplication Site Guest User</value>
        </criteriaItems>
        <description>Change owner of Online App from Guest User to Daniel Pesek, based on the Offer Name WF TXT.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>eApp Owner - Advanced Commercial Credit</fullName>
        <actions>
            <name>Assign_to_Rob_Timmons</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>OnlineApplication__c.Offer_Name_WF_TXT__c</field>
            <operation>startsWith</operation>
            <value>Advanced Commercial Credit</value>
        </criteriaItems>
        <criteriaItems>
            <field>OnlineApplication__c.CreatedById</field>
            <operation>equals</operation>
            <value>CreditApplication Site Guest User</value>
        </criteriaItems>
        <description>Change owner of Online App from Guest User to Rob Timmons, based on the Offer Name WF TXT.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>eApp Owner - Aladdin Financial</fullName>
        <actions>
            <name>Assign_to_Jay_Larson</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>OnlineApplication__c.Offer_Name_WF_TXT__c</field>
            <operation>startsWith</operation>
            <value>Aladdin Financial</value>
        </criteriaItems>
        <criteriaItems>
            <field>OnlineApplication__c.CreatedById</field>
            <operation>equals</operation>
            <value>CreditApplication Site Guest User</value>
        </criteriaItems>
        <description>Change owner of Online App from Guest User to Jay Larson, based on the Offer Name WF TXT.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>eApp Owner - Amanda Stack</fullName>
        <actions>
            <name>Assign_to_Amanda</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>Assign eApp with 0-50 units</description>
        <formula>(Number_of_Trucks__c &lt;= 50) &amp;&amp; 
(ISPICKVAL(State__c, &apos;TN&apos;) || 
ISPICKVAL(State__c, &apos;KY&apos;) || 
ISPICKVAL(State__c, &apos;MD&apos;))&amp;&amp; 
OR(
CreatedById = &apos;00570000002S3Sl&apos;,
CreatedById = &apos;00570000003hCBt&apos;
)
&amp;&amp; 
(Offer__r.Name = &apos;WEX Fleet One All Roads&apos; ||
Offer__r.Name = &apos;Fleet One LLC Edge BOCA&apos; || 
Offer__r.Name = &apos;Fleet One Over the Road&apos; || 
Offer__r.Name = &apos;Fleet One Owner/Operator OO-2015&apos; || 
Offer__r.Name = &apos;Fleet One EDGE&apos; ||
Offer__r.Name = &apos;RR - Over the Road&apos; ||
Offer__r.Name = &apos;Fleet One Over the Road O/O Microsite 2016&apos; ||
Offer__r.Name = &apos;Fleet One Edge Over The Road&apos; ||
Offer__r.Name = &apos;Fleet One Edge LLC BOCA SG&apos;)</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>eApp Owner - Andi Bowens</fullName>
        <actions>
            <name>Assign_to_Trish</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>Assign eApp with 0-50 units</description>
        <formula>(Number_of_Trucks__c &lt;= 50) &amp;&amp; 
(ISPICKVAL(State__c,&apos;ID&apos;) || 
ISPICKVAL(State__c, &apos;LA&apos;) || 
ISPICKVAL(State__c, &apos;SD&apos;)|| 
ISPICKVAL(State__c, &apos;NM&apos;)|| 
ISPICKVAL(State__c, &apos;ND&apos;)|| 
ISPICKVAL(State__c, &apos;NV&apos;)||
ISPICKVAL(State__c, &apos;MT&apos;))&amp;&amp; 
OR(
CreatedById = &apos;00570000002S3Sl&apos;,
CreatedById = &apos;00570000003hCBt&apos;
)
&amp;&amp; 
(Offer__r.Name = &apos;WEX Fleet One All Roads&apos; ||
Offer__r.Name = &apos;Fleet One LLC Edge BOCA&apos; || 
Offer__r.Name = &apos;Fleet One Over the Road&apos; || 
Offer__r.Name = &apos;Fleet One Owner/Operator OO-2015&apos; || 
Offer__r.Name = &apos;Fleet One EDGE&apos; ||
Offer__r.Name = &apos;RR - Over the Road&apos; ||
Offer__r.Name = &apos;Fleet One Over the Road O/O Microsite 2016&apos; ||
Offer__r.Name = &apos;Fleet One Edge Over The Road&apos; ||
Offer__r.Name = &apos;Fleet One Edge LLC BOCA SG&apos;)</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>eApp Owner - BSNF Fuel Card</fullName>
        <actions>
            <name>Owner_BSNF_Fuel_Card_Jared_Williams</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>OnlineApplication__c.Application_Title__c</field>
            <operation>startsWith</operation>
            <value>BSNF</value>
        </criteriaItems>
        <criteriaItems>
            <field>OnlineApplication__c.CreatedById</field>
            <operation>equals</operation>
            <value>appl Site Guest User</value>
        </criteriaItems>
        <description>Change owner of Online App from Guest User to BSNF Fuel Card, based on the Application Title.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>eApp Owner - Ben Cave</fullName>
        <actions>
            <name>Assign_to_Ben_Cave</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>Assign eApp with 0-50 units</description>
        <formula>(Number_of_Trucks__c &lt;= 50) &amp;&amp; 
(ISPICKVAL(State__c, &apos;OH&apos;) || 
ISPICKVAL(State__c, &apos;CT&apos;) || 
ISPICKVAL(State__c, &apos;AL&apos;))&amp;&amp; 
OR(
CreatedById = &apos;00570000002S3Sl&apos;,
CreatedById = &apos;00570000003hCBt&apos;
)
&amp;&amp; 
(Offer__r.Name = &apos;WEX Fleet One All Roads&apos; ||
Offer__r.Name = &apos;Fleet One LLC Edge BOCA&apos; || 
Offer__r.Name = &apos;Fleet One Over the Road&apos; || 
Offer__r.Name = &apos;Fleet One Owner/Operator OO-2015&apos; || 
Offer__r.Name = &apos;Fleet One EDGE&apos; ||
Offer__r.Name = &apos;RR - Over the Road&apos; ||
Offer__r.Name = &apos;Fleet One Over the Road O/O Microsite 2016&apos; ||
Offer__r.Name = &apos;Fleet One Edge Over The Road&apos; ||
Offer__r.Name = &apos;Fleet One Edge LLC BOCA SG&apos;)</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>eApp Owner - Bryant Taylor</fullName>
        <active>false</active>
        <description>Assign eApp with 0-50 units</description>
        <formula>(Number_of_Trucks__c &lt;= 50) &amp;&amp; 
(ISPICKVAL(State__c, &apos;NC&apos;) || 
ISPICKVAL(State__c, &apos;SC&apos;))&amp;&amp; 
OR(
CreatedById = &apos;00570000002S3Sl&apos;,
CreatedById = &apos;00570000003hCBt&apos;
)
&amp;&amp; 
(Offer__r.Name = &apos;WEX Fleet One All Roads&apos; ||
Offer__r.Name = &apos;Fleet One LLC Edge BOCA&apos; || 
Offer__r.Name = &apos;Fleet One Over the Road&apos; || 
Offer__r.Name = &apos;Fleet One Owner/Operator OO-2015&apos; || 
Offer__r.Name = &apos;Fleet One EDGE&apos; ||
Offer__r.Name = &apos;RR - Over the Road&apos; ||
Offer__r.Name = &apos;Fleet One Over the Road O/O Microsite 2016&apos; ||
Offer__r.Name = &apos;Fleet One Edge Over The Road&apos;)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>eApp Owner - CJM Financial</fullName>
        <actions>
            <name>Assign_to_TRENT_MURPHY</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>OnlineApplication__c.Offer_Name_WF_TXT__c</field>
            <operation>startsWith</operation>
            <value>CJM Financial</value>
        </criteriaItems>
        <criteriaItems>
            <field>OnlineApplication__c.CreatedById</field>
            <operation>equals</operation>
            <value>CreditApplication Site Guest User</value>
        </criteriaItems>
        <description>Change owner of Online App from Guest User to TRENT MURPHY, based on the Offer Name WF TXT.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>eApp Owner - CarsArrive</fullName>
        <actions>
            <name>set_Owner_to_CarsArrive</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>OnlineApplication__c.Offer_Name_WF_TXT__c</field>
            <operation>startsWith</operation>
            <value>CarsArrive</value>
        </criteriaItems>
        <criteriaItems>
            <field>OnlineApplication__c.CreatedById</field>
            <operation>equals</operation>
            <value>CreditApplication Site Guest User</value>
        </criteriaItems>
        <description>Change owner of Online App from Guest User to CarsArrivet, based on the Offer Name WF TXT.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>eApp Owner - CarsArrive 1</fullName>
        <actions>
            <name>CarsArrive</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>OnlineApplication__c.Application_Title__c</field>
            <operation>startsWith</operation>
            <value>CarsArrive</value>
        </criteriaItems>
        <criteriaItems>
            <field>OnlineApplication__c.CreatedById</field>
            <operation>equals</operation>
            <value>appl Site Guest User</value>
        </criteriaItems>
        <description>Change owner of Online App from Guest User to CarsArrivet, based on the Application Title.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>eApp Owner - CenterFire</fullName>
        <active>true</active>
        <criteriaItems>
            <field>OnlineApplication__c.Application_Title__c</field>
            <operation>startsWith</operation>
            <value>CenterFire</value>
        </criteriaItems>
        <criteriaItems>
            <field>OnlineApplication__c.CreatedById</field>
            <operation>equals</operation>
            <value>appl Site Guest User</value>
        </criteriaItems>
        <description>Change owner of Online App from Guest User to Justin Heim, based on the Application Title.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>eApp Owner - Christine Jennings</fullName>
        <actions>
            <name>Assign_to_Christine</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>Assign eApp with 0-50 units</description>
        <formula>Number_of_Trucks__c &lt;= 50 &amp;&amp; 
(ISPICKVAL(State__c, &apos;IL&apos;) )
&amp;&amp; 
OR(
CreatedById = &apos;00570000002S3Sl&apos;,
CreatedById = &apos;00570000003hCBt&apos;
)
&amp;&amp; 
(Offer__r.Name = &apos;WEX Fleet One All Roads&apos; ||
Offer__r.Name = &apos;Fleet One LLC Edge BOCA&apos; || 
Offer__r.Name = &apos;Fleet One Over the Road&apos; || 
Offer__r.Name = &apos;Fleet One Owner/Operator OO-2015&apos; || 
Offer__r.Name = &apos;Fleet One EDGE&apos; ||
Offer__r.Name = &apos;RR - Over the Road&apos; ||
Offer__r.Name = &apos;Fleet One Over the Road O/O Microsite 2016&apos; ||
Offer__r.Name = &apos;Fleet One Edge Over The Road&apos; ||
Offer__r.Name = &apos;Fleet One Edge LLC BOCA SG&apos;)</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>eApp Owner - Commercial Funding</fullName>
        <actions>
            <name>Assign_to_Julie_Murphy</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>OnlineApplication__c.Offer_Name_WF_TXT__c</field>
            <operation>startsWith</operation>
            <value>Commercial Funding</value>
        </criteriaItems>
        <criteriaItems>
            <field>OnlineApplication__c.CreatedById</field>
            <operation>equals</operation>
            <value>CreditApplication Site Guest User</value>
        </criteriaItems>
        <description>Change owner of Online App from Guest User to Julie Murphy, based on the Offer Name WF TXT.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>eApp Owner - CoreFund Capital</fullName>
        <actions>
            <name>Assign_to_Bonnie_Castillo</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>OnlineApplication__c.Offer_Name_WF_TXT__c</field>
            <operation>startsWith</operation>
            <value>CoreFund Capital</value>
        </criteriaItems>
        <criteriaItems>
            <field>OnlineApplication__c.CreatedById</field>
            <operation>equals</operation>
            <value>CreditApplication Site Guest User</value>
        </criteriaItems>
        <description>Change owner of Online App from Guest User to Bonnie Castillo, based on the Offer Name WF TXT.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>eApp Owner - D%26S Fuel Card</fullName>
        <actions>
            <name>Owner_D_S_Fuel_Card_Candy_Hill</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>OnlineApplication__c.Application_Title__c</field>
            <operation>startsWith</operation>
            <value>D and S Fuel Card</value>
        </criteriaItems>
        <criteriaItems>
            <field>OnlineApplication__c.CreatedById</field>
            <operation>equals</operation>
            <value>appl Site Guest User</value>
        </criteriaItems>
        <description>Change owner of Online App from Guest User to D&amp;S Fuel Card, based on the Application Title.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>eApp Owner - D%26S Support</fullName>
        <actions>
            <name>Owner</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>OnlineApplication__c.Application_Title__c</field>
            <operation>startsWith</operation>
            <value>IT - D and S Factors</value>
        </criteriaItems>
        <criteriaItems>
            <field>OnlineApplication__c.CreatedById</field>
            <operation>equals</operation>
            <value>appl Site Guest User</value>
        </criteriaItems>
        <description>Change owner of Online App from Guest User to D&amp;S Support, based on the Application Title.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>eApp Owner - DAT</fullName>
        <actions>
            <name>Assign_to_Bert_Goo</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>OnlineApplication__c.Offer_Name_WF_TXT__c</field>
            <operation>startsWith</operation>
            <value>DAT</value>
        </criteriaItems>
        <criteriaItems>
            <field>OnlineApplication__c.CreatedById</field>
            <operation>equals</operation>
            <value>CreditApplication Site Guest User</value>
        </criteriaItems>
        <description>Change owner of Online App from Guest User to Bert Goo, based on the Offer Name WF TXT.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>eApp Owner - David Pruitt</fullName>
        <active>false</active>
        <criteriaItems>
            <field>OnlineApplication__c.Application_Title__c</field>
            <operation>startsWith</operation>
            <value>NFN - Local</value>
        </criteriaItems>
        <criteriaItems>
            <field>OnlineApplication__c.CreatedById</field>
            <operation>equals</operation>
            <value>appl Site Guest User</value>
        </criteriaItems>
        <description>Change the eApp Owner from Site Guest User to Davit Pruitt based on the Application Title</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>eApp Owner - David Sedlacek</fullName>
        <actions>
            <name>Assign_to_David</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Assign eApp with 200+ units</description>
        <formula>Number_of_Trucks__c  &gt;= 200 &amp;&amp;
(ISPICKVAL(State__c, &apos;TX&apos;)|| 
ISPICKVAL(State__c, &apos;OK&apos;)|| 
ISPICKVAL(State__c, &apos;MO&apos;)|| 
ISPICKVAL(State__c, &apos;AZ&apos;)|| 
ISPICKVAL(State__c, &apos;OR&apos;)|| 
ISPICKVAL(State__c, &apos;MT&apos;)|| 
ISPICKVAL(State__c, &apos;NV&apos;)|| 
ISPICKVAL(State__c, &apos;KS&apos;))&amp;&amp; 
OR(
CreatedById = &apos;00570000002S3Sl&apos;,
CreatedById = &apos;00570000003hCBt&apos;
)
&amp;&amp; 
(Offer__r.Name = &apos;WEX Fleet One All Roads&apos; ||
Offer__r.Name = &apos;Fleet One LLC Edge BOCA&apos; || 
Offer__r.Name = &apos;Fleet One Over the Road&apos; || 
Offer__r.Name = &apos;Fleet One Owner/Operator OO-2015&apos; || 
Offer__r.Name = &apos;Fleet One EDGE&apos; ||
Offer__r.Name = &apos;RR - Over the Road&apos; ||
Offer__r.Name = &apos;Fleet One Over the Road O/O Microsite 2016&apos; ||
Offer__r.Name = &apos;Fleet One Edge Over The Road&apos;)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>eApp Owner - Denise Offutt</fullName>
        <actions>
            <name>eApp_Owner_Denise_Offutt</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>(1 OR 3) AND 2</booleanFilter>
        <criteriaItems>
            <field>OnlineApplication__c.Application_Title__c</field>
            <operation>startsWith</operation>
            <value>Servco</value>
        </criteriaItems>
        <criteriaItems>
            <field>OnlineApplication__c.CreatedById</field>
            <operation>equals</operation>
            <value>appl Site Guest User</value>
        </criteriaItems>
        <criteriaItems>
            <field>OnlineApplication__c.Application_Title__c</field>
            <operation>startsWith</operation>
            <value>PTP</value>
        </criteriaItems>
        <description>Change owner of Online App from Guest User to Denise Offutt, based on the Application Title (Servco or PTP)</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>eApp Owner - Discount Diesel Fuel Card</fullName>
        <actions>
            <name>Owner_Discount_Diesel_Fuel_Card</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>OnlineApplication__c.Application_Title__c</field>
            <operation>startsWith</operation>
            <value>Discount Diesel</value>
        </criteriaItems>
        <criteriaItems>
            <field>OnlineApplication__c.CreatedById</field>
            <operation>equals</operation>
            <value>appl Site Guest User</value>
        </criteriaItems>
        <description>Change owner of Online App from Guest User to Discount Diesel Fuel Card, based on the Application Title.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>eApp Owner - ECAPITAL</fullName>
        <actions>
            <name>Assign_to_Raul_Pena</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>OnlineApplication__c.Offer_Name_WF_TXT__c</field>
            <operation>startsWith</operation>
            <value>ECAPITAL</value>
        </criteriaItems>
        <criteriaItems>
            <field>OnlineApplication__c.CreatedById</field>
            <operation>equals</operation>
            <value>CreditApplication Site Guest User</value>
        </criteriaItems>
        <description>Change owner of Online App from Guest User to Raul Pena, based on the Offer Name WF TXT.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>eApp Owner - England Logistics</fullName>
        <actions>
            <name>Brady_Dransfield</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>OnlineApplication__c.Application_Title__c</field>
            <operation>startsWith</operation>
            <value>England</value>
        </criteriaItems>
        <criteriaItems>
            <field>OnlineApplication__c.CreatedById</field>
            <operation>equals</operation>
            <value>appl Site Guest User</value>
        </criteriaItems>
        <criteriaItems>
            <field>OnlineApplication__c.Offer_Name__c</field>
            <operation>notContain</operation>
            <value>TL</value>
        </criteriaItems>
        <description>Change owner of Online App from Guest User to Brady Dransfield, based on the Application Title.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>eApp Owner - England Logistics - TL1</fullName>
        <actions>
            <name>Owner_England_Logistics_TL</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>OnlineApplication__c.Application_Title__c</field>
            <operation>startsWith</operation>
            <value>England</value>
        </criteriaItems>
        <criteriaItems>
            <field>OnlineApplication__c.CreatedById</field>
            <operation>equals</operation>
            <value>appl Site Guest User</value>
        </criteriaItems>
        <criteriaItems>
            <field>OnlineApplication__c.Offer_Name__c</field>
            <operation>contains</operation>
            <value>TL1</value>
        </criteriaItems>
        <description>Change owner of Online App from Guest User to Ryan Christiansen, based on the Application Title.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>eApp Owner - England Logistics - TL2</fullName>
        <actions>
            <name>Owner_Dave_Swan</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>OnlineApplication__c.Application_Title__c</field>
            <operation>startsWith</operation>
            <value>England</value>
        </criteriaItems>
        <criteriaItems>
            <field>OnlineApplication__c.CreatedById</field>
            <operation>equals</operation>
            <value>appl Site Guest User</value>
        </criteriaItems>
        <criteriaItems>
            <field>OnlineApplication__c.Offer_Name__c</field>
            <operation>contains</operation>
            <value>TL2</value>
        </criteriaItems>
        <description>Change owner of Online App from Guest User to Dave Swann, based on the Application Title.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>eApp Owner - England Logistics - TL3</fullName>
        <actions>
            <name>Owner_Josh_Norris</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>OnlineApplication__c.Application_Title__c</field>
            <operation>startsWith</operation>
            <value>England</value>
        </criteriaItems>
        <criteriaItems>
            <field>OnlineApplication__c.CreatedById</field>
            <operation>equals</operation>
            <value>appl Site Guest User</value>
        </criteriaItems>
        <criteriaItems>
            <field>OnlineApplication__c.Offer_Name__c</field>
            <operation>contains</operation>
            <value>TL3</value>
        </criteriaItems>
        <description>Change owner of Online App from Guest User to Josh Norris, based on the Application Title.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>eApp Owner - England Logistics BOCA</fullName>
        <actions>
            <name>Assign_to_England_Sales_Team</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>OnlineApplication__c.Offer_Name_WF_TXT__c</field>
            <operation>startsWith</operation>
            <value>England Logistics OTR</value>
        </criteriaItems>
        <criteriaItems>
            <field>OnlineApplication__c.CreatedById</field>
            <operation>equals</operation>
            <value>CreditApplication Site Guest User</value>
        </criteriaItems>
        <description>Change owner of Online App from Guest User to England Sales Team, based on the Offer Name WF TXT.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>eApp Owner - Engs Commercial Capital</fullName>
        <actions>
            <name>Assign_to_Leslye_Campos</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>OnlineApplication__c.Offer_Name_WF_TXT__c</field>
            <operation>startsWith</operation>
            <value>ENGS Commercial</value>
        </criteriaItems>
        <criteriaItems>
            <field>OnlineApplication__c.CreatedById</field>
            <operation>equals</operation>
            <value>CreditApplication Site Guest User</value>
        </criteriaItems>
        <description>Change owner of Online App from Guest User to Leslye Campos, based on the Offer Name WF TXT.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>eApp Owner - Envio 360</fullName>
        <actions>
            <name>Assing_to_Larry_Cuddy</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>OnlineApplication__c.Offer_Name_WF_TXT__c</field>
            <operation>startsWith</operation>
            <value>Envio 360</value>
        </criteriaItems>
        <criteriaItems>
            <field>OnlineApplication__c.CreatedById</field>
            <operation>equals</operation>
            <value>CreditApplication Site Guest User</value>
        </criteriaItems>
        <description>Change owner of Online App from Guest User to Larry Cuddy, based on the Offer Name WF TXT.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>eApp Owner - Express Freight Finance</fullName>
        <actions>
            <name>Assign_to_Bryan_Doty</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>OnlineApplication__c.Offer_Name_WF_TXT__c</field>
            <operation>startsWith</operation>
            <value>Express Freight Finance</value>
        </criteriaItems>
        <criteriaItems>
            <field>OnlineApplication__c.CreatedById</field>
            <operation>equals</operation>
            <value>CreditApplication Site Guest User</value>
        </criteriaItems>
        <description>Change owner of Online App from Guest User to Bryan Doty, based on the Offer Name WF TXT.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>eApp Owner - Express Truck Tax</fullName>
        <active>true</active>
        <criteriaItems>
            <field>OnlineApplication__c.Application_Title__c</field>
            <operation>startsWith</operation>
            <value>Express Truck Tax</value>
        </criteriaItems>
        <criteriaItems>
            <field>OnlineApplication__c.CreatedById</field>
            <operation>equals</operation>
            <value>appl Site Guest User</value>
        </criteriaItems>
        <description>Change owner of Online App from Guest User to Tim Haynes , based on the Application Title.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>eApp Owner - Far West Capital</fullName>
        <actions>
            <name>Assign_to_Brenda_Pinon</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>OnlineApplication__c.Offer_Name_WF_TXT__c</field>
            <operation>startsWith</operation>
            <value>Far West Capital</value>
        </criteriaItems>
        <criteriaItems>
            <field>OnlineApplication__c.CreatedById</field>
            <operation>equals</operation>
            <value>CreditApplication Site Guest User</value>
        </criteriaItems>
        <description>Change owner of Online App from Guest User to Brenda Pinon, based on the Offer Name WF TXT.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>eApp Owner - Faye Gotten</fullName>
        <actions>
            <name>eApp_Owner_Faye_Gotten</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>OnlineApplication__c.Application_Title__c</field>
            <operation>startsWith</operation>
            <value>TI Advisors,IT - Roady&apos;s</value>
        </criteriaItems>
        <criteriaItems>
            <field>OnlineApplication__c.CreatedById</field>
            <operation>equals</operation>
            <value>appl Site Guest User</value>
        </criteriaItems>
        <description>Change owner of Online App from Guest User to Faye Gotten, based on the Application Title.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>eApp Owner - Financial Carrier Service</fullName>
        <actions>
            <name>Assign_to_Alex_Kelis</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>OnlineApplication__c.Offer_Name_WF_TXT__c</field>
            <operation>startsWith</operation>
            <value>Financial Carrier Service</value>
        </criteriaItems>
        <criteriaItems>
            <field>OnlineApplication__c.CreatedById</field>
            <operation>equals</operation>
            <value>CreditApplication Site Guest User</value>
        </criteriaItems>
        <description>Change owner of Online App from Guest User to Alex Kelis, based on the Offer Name WF TXT.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>eApp Owner - Fleet Savings</fullName>
        <actions>
            <name>Owner_Fleet_Savings</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>OnlineApplication__c.Application_Title__c</field>
            <operation>startsWith</operation>
            <value>Fleet Savings</value>
        </criteriaItems>
        <criteriaItems>
            <field>OnlineApplication__c.CreatedById</field>
            <operation>equals</operation>
            <value>appl Site Guest User</value>
        </criteriaItems>
        <description>Change owner of Online App from Guest User to Fleet Savings, based on the Application Title.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>eApp Owner - FleetPro Services</fullName>
        <actions>
            <name>Set_owner_to_FleetPro_Services</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>OnlineApplication__c.Application_Title__c</field>
            <operation>startsWith</operation>
            <value>FleetPro Services</value>
        </criteriaItems>
        <criteriaItems>
            <field>OnlineApplication__c.CreatedById</field>
            <operation>equals</operation>
            <value>appl Site Guest User</value>
        </criteriaItems>
        <description>Change owner of Online App from Guest User to FleetPro Services, based on the Application Title.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>eApp Owner - FleetPro Services and InTouch GPS</fullName>
        <actions>
            <name>Update_eApp_Owner_Faye_Gotten</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>((1 OR 3)AND 2)</booleanFilter>
        <criteriaItems>
            <field>OnlineApplication__c.Application_Title__c</field>
            <operation>startsWith</operation>
            <value>FleetPro</value>
        </criteriaItems>
        <criteriaItems>
            <field>OnlineApplication__c.CreatedById</field>
            <operation>equals</operation>
            <value>appl Site Guest User</value>
        </criteriaItems>
        <criteriaItems>
            <field>OnlineApplication__c.Application_Title__c</field>
            <operation>startsWith</operation>
            <value>InTouch</value>
        </criteriaItems>
        <description>Change owner of Online App from Guest User to Dean Shreve, based on the Application Title being FleetPro Services or InTouch GPS</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>eApp Owner - Foley Carrier Services</fullName>
        <actions>
            <name>Assign_to_Matt_Nulle</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>OnlineApplication__c.Offer_Name_WF_TXT__c</field>
            <operation>startsWith</operation>
            <value>Foley Carrier Services</value>
        </criteriaItems>
        <criteriaItems>
            <field>OnlineApplication__c.CreatedById</field>
            <operation>equals</operation>
            <value>CreditApplication Site Guest User</value>
        </criteriaItems>
        <description>Change owner of Online App from Guest User to Matt Nulle, based on the Offer Name WF TXT.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>eApp Owner - Freight Factoring Special</fullName>
        <actions>
            <name>Assign_to_Steven_Newman</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>OnlineApplication__c.Offer_Name_WF_TXT__c</field>
            <operation>startsWith</operation>
            <value>Freight Factoring Special</value>
        </criteriaItems>
        <criteriaItems>
            <field>OnlineApplication__c.CreatedById</field>
            <operation>equals</operation>
            <value>CreditApplication Site Guest User</value>
        </criteriaItems>
        <description>Change owner of Online App from Guest User to Steven Newman, based on the Offer Name WF TXT.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>eApp Owner - Fuelbook</fullName>
        <actions>
            <name>Owner_Joni_Crockarell</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>OnlineApplication__c.Application_Title__c</field>
            <operation>startsWith</operation>
            <value>Fuelbook</value>
        </criteriaItems>
        <criteriaItems>
            <field>OnlineApplication__c.CreatedById</field>
            <operation>equals</operation>
            <value>appl Site Guest User</value>
        </criteriaItems>
        <criteriaItems>
            <field>OnlineApplication__c.Status__c</field>
            <operation>equals</operation>
            <value>Saved-Incomplete,App-Incomplete</value>
        </criteriaItems>
        <description>Change owner of Online App from Guest User to Joni Crockarell, based on the Application Title.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>eApp Owner - G%2EH%2E Factor</fullName>
        <actions>
            <name>Assign_to_Karla_Revilla</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>OnlineApplication__c.Offer_Name_WF_TXT__c</field>
            <operation>startsWith</operation>
            <value>G.H. Factor</value>
        </criteriaItems>
        <criteriaItems>
            <field>OnlineApplication__c.CreatedById</field>
            <operation>equals</operation>
            <value>CreditApplication Site Guest User</value>
        </criteriaItems>
        <description>Change owner of Online App from Guest User to Karla Revilla, based on the Offer Name WF TXT.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>eApp Owner - Great Plains</fullName>
        <actions>
            <name>Assing_to_Jerry_Van_Wyk</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>OnlineApplication__c.Offer_Name_WF_TXT__c</field>
            <operation>startsWith</operation>
            <value>Great Plains</value>
        </criteriaItems>
        <criteriaItems>
            <field>OnlineApplication__c.CreatedById</field>
            <operation>equals</operation>
            <value>CreditApplication Site Guest User</value>
        </criteriaItems>
        <description>Change owner of Online App from Guest User to Jerry Van Wyk, based on the Offer Name WF TXT.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>eApp Owner - Iesha Vann</fullName>
        <active>false</active>
        <criteriaItems>
            <field>OnlineApplication__c.Application_Title__c</field>
            <operation>startsWith</operation>
            <value>Fleet One Owner/Operator</value>
        </criteriaItems>
        <criteriaItems>
            <field>OnlineApplication__c.CreatedById</field>
            <operation>equals</operation>
            <value>appl Site Guest User</value>
        </criteriaItems>
        <description>Change the eApp Owner from Site Guest User to Iesha Vann based on the Application Title</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>eApp Owner - Integra</fullName>
        <actions>
            <name>Assign_to_Kyle_Klatzkin</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>OnlineApplication__c.Offer_Name_WF_TXT__c</field>
            <operation>startsWith</operation>
            <value>Integra</value>
        </criteriaItems>
        <criteriaItems>
            <field>OnlineApplication__c.CreatedById</field>
            <operation>equals</operation>
            <value>CreditApplication Site Guest User</value>
        </criteriaItems>
        <description>Change owner of Online App from Guest User to Kyle Klatzkin, based on the Offer Name WF TXT.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>eApp Owner - Integrated Logistics</fullName>
        <actions>
            <name>Assign_to_Amanda_Keller</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>OnlineApplication__c.Offer_Name_WF_TXT__c</field>
            <operation>startsWith</operation>
            <value>Integrated Logistics</value>
        </criteriaItems>
        <criteriaItems>
            <field>OnlineApplication__c.CreatedById</field>
            <operation>equals</operation>
            <value>CreditApplication Site Guest User</value>
        </criteriaItems>
        <description>Change owner of Online App from Guest User to Amanda Keller, based on the Offer Name WF TXT.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>eApp Owner - Interstate Capital</fullName>
        <actions>
            <name>Assign_to_Sarah_Williams</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>OnlineApplication__c.Offer_Name_WF_TXT__c</field>
            <operation>startsWith</operation>
            <value>Interstate Capital</value>
        </criteriaItems>
        <criteriaItems>
            <field>OnlineApplication__c.CreatedById</field>
            <operation>equals</operation>
            <value>CreditApplication Site Guest User</value>
        </criteriaItems>
        <description>Change owner of Online App from Guest User to Sarah Williams, based on the Offer Name WF TXT.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>eApp Owner - JD Factors</fullName>
        <actions>
            <name>Assign_to_CHIP_WILEY</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>OnlineApplication__c.Offer_Name_WF_TXT__c</field>
            <operation>startsWith</operation>
            <value>JD Factors</value>
        </criteriaItems>
        <criteriaItems>
            <field>OnlineApplication__c.CreatedById</field>
            <operation>equals</operation>
            <value>CreditApplication Site Guest User</value>
        </criteriaItems>
        <description>Change owner of Online App from Guest User to CHIP WILEY, based on the Offer Name WF TXT.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>eApp Owner - Jessie Singh</fullName>
        <actions>
            <name>Owner_Jessie_Singh</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>OnlineApplication__c.Application_Title__c</field>
            <operation>startsWith</operation>
            <value>Trans-Alliance</value>
        </criteriaItems>
        <criteriaItems>
            <field>OnlineApplication__c.CreatedById</field>
            <operation>equals</operation>
            <value>appl Site Guest User</value>
        </criteriaItems>
        <description>Change owner of Online Appp from Guest User to Jessie Singh, based on the Application Title.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>eApp Owner - John Cave</fullName>
        <actions>
            <name>Assign_to_John_Cave</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>assign 51-199 units to &apos;all east &apos;</description>
        <formula>(Number_of_Trucks__c &gt;= 51 &amp;&amp; Number_of_Trucks__c &lt;= 199) &amp;&amp; 
(ISPICKVAL(State__c, &apos;TN&apos;) ||
ISPICKVAL(State__c, &apos;GA&apos;) ||
ISPICKVAL(State__c, &apos;FL&apos;)||
ISPICKVAL(State__c, &apos;IN&apos;)||
ISPICKVAL(State__c, &apos;MI&apos;)||
ISPICKVAL(State__c, &apos;NY&apos;)||
ISPICKVAL(State__c, &apos;MA&apos;)||
ISPICKVAL(State__c, &apos;ME&apos;)||
ISPICKVAL(State__c, &apos;KY&apos;)||
ISPICKVAL(State__c, &apos;IL&apos;) ||
ISPICKVAL(State__c, &apos;OH&apos;)||
ISPICKVAL(State__c, &apos;WI&apos;)||
ISPICKVAL(State__c, &apos;PA&apos;)||
ISPICKVAL(State__c, &apos;NJ&apos;)||
ISPICKVAL(State__c, &apos;CT&apos;)||
ISPICKVAL(State__c, &apos;VT&apos;)||
ISPICKVAL(State__c, &apos;AL&apos;)||
ISPICKVAL(State__c, &apos;SC&apos;)||
ISPICKVAL(State__c, &apos;NC&apos;)||
ISPICKVAL(State__c, &apos;VA&apos;)||
ISPICKVAL(State__c, &apos;WV&apos;)||
ISPICKVAL(State__c, &apos;MD&apos;)||
ISPICKVAL(State__c, &apos;DC&apos;)||
ISPICKVAL(State__c, &apos;DE&apos;)||
ISPICKVAL(State__c, &apos;RI&apos;)||
ISPICKVAL(State__c, &apos;NH&apos;)||
ISPICKVAL(State__c, &apos;MN&apos;)||
ISPICKVAL(State__c, &apos;IA&apos;)||
ISPICKVAL(State__c, &apos;SD&apos;) ||
ISPICKVAL(State__c, &apos;ND&apos;))&amp;&amp; 
OR(
CreatedById = &apos;00570000002S3Sl&apos;,
CreatedById = &apos;00570000003hCBt&apos;
)
&amp;&amp; 
(Offer__r.Name = &apos;WEX Fleet One All Roads&apos; ||
Offer__r.Name = &apos;Fleet One LLC Edge BOCA&apos; || 
Offer__r.Name = &apos;Fleet One Over the Road&apos; || 
Offer__r.Name = &apos;Fleet One Owner/Operator OO-2015&apos; || 
Offer__r.Name = &apos;Fleet One EDGE&apos; ||
Offer__r.Name = &apos;RR - Over the Road&apos; ||
Offer__r.Name = &apos;Fleet One Over the Road O/O Microsite 2016&apos; ||
Offer__r.Name = &apos;Fleet One Edge Over The Road&apos;)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>eApp Owner - John White</fullName>
        <actions>
            <name>Assign_to_John</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Assign eApp with 200+ units</description>
        <formula>Number_of_Trucks__c  &gt;= 200 &amp;&amp;
(ISPICKVAL(State__c, &apos;CA&apos;) || 
ISPICKVAL(State__c, &apos;CO&apos;) || 
ISPICKVAL(State__c, &apos;AR&apos;)|| 
ISPICKVAL(State__c, &apos;LA&apos;)|| 
ISPICKVAL(State__c, &apos;MS&apos;)|| 
ISPICKVAL(State__c, &apos;UT&apos;)|| 
ISPICKVAL(State__c, &apos;WA&apos;)|| 
ISPICKVAL(State__c, &apos;ID&apos;)|| 
ISPICKVAL(State__c, &apos;WY&apos;)|| 
ISPICKVAL(State__c, &apos;TN&apos;) )
&amp;&amp; 
OR(
CreatedById = &apos;00570000002S3Sl&apos;,
CreatedById = &apos;00570000003hCBt&apos;
)
&amp;&amp; 
(Offer__r.Name = &apos;WEX Fleet One All Roads&apos; ||
Offer__r.Name = &apos;Fleet One LLC Edge BOCA&apos; || 
Offer__r.Name = &apos;Fleet One Over The Road&apos; || 
Offer__r.Name = &apos;Fleet One Owner/Operator OO-2015&apos; || 
Offer__r.Name = &apos;Fleet One EDGE&apos; ||
Offer__r.Name = &apos;RR - Over the Road&apos; ||
Offer__r.Name = &apos;Fleet One Over the Road O/O Microsite 2016&apos; ||
Offer__r.Name = &apos;Fleet One Edge Over The Road&apos;)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>eApp Owner - Joni Crockarell</fullName>
        <actions>
            <name>Assign_to_Joni</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>Assign eApp with 0-50 units</description>
        <formula>Number_of_Trucks__c &lt;= 50 &amp;&amp; 
(ISPICKVAL(State__c,&apos;IA&apos;)|| 
ISPICKVAL(State__c,&apos;AZ&apos;)||
ISPICKVAL(State__c,&apos;OK&apos;)||
ISPICKVAL(State__c,&apos;AR&apos;)) &amp;&amp;
OR(
CreatedById = &apos;00570000002S3Sl&apos;,
CreatedById = &apos;00570000003hCBt&apos;
)
&amp;&amp; 
(Offer__r.Name = &apos;WEX Fleet One All Roads&apos; ||
Offer__r.Name = &apos;Fleet One LLC Edge BOCA&apos; ||
Offer__r.Name = &apos;Fleet One Over the Road&apos;|| 
Offer__r.Name = &apos;Fleet One Owner/Operator OO-2015&apos; || 
Offer__r.Name = &apos;Fleet One EDGE&apos; ||
Offer__r.Name = &apos;Fleet One Over the Road O/O Microsite 2016&apos; ||
Offer__r.Name = &apos;RR - Over the Road&apos; ||
Offer__r.Name = &apos;Fleet One Edge Over The Road&apos; ||
Offer__r.Name = &apos;Fleet One Edge LLC BOCA SG&apos;)</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>eApp Owner - Justin Crabb</fullName>
        <actions>
            <name>Assign_to_Justin_Crabb</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Assign Canadian apps to Justin</description>
        <formula>(ISPICKVAL(State__c,&apos;AB&apos;)|| 
ISPICKVAL(State__c,&apos;BC&apos;)|| 
ISPICKVAL(State__c,&apos;MB&apos;)|| 
ISPICKVAL(State__c,&apos;NB&apos;)|| 
ISPICKVAL(State__c,&apos;NL&apos;)|| 
ISPICKVAL(State__c,&apos;NT&apos;)||
ISPICKVAL(State__c,&apos;NS&apos;)||
ISPICKVAL(State__c,&apos;NU&apos;)||
ISPICKVAL(State__c,&apos;ON&apos;)||
ISPICKVAL(State__c,&apos;PE&apos;)||
ISPICKVAL(State__c,&apos;QC&apos;)||
ISPICKVAL(State__c,&apos;SK&apos;)||
ISPICKVAL(State__c,&apos;YT&apos;)) &amp;&amp; 
OR(
CreatedById = &apos;00570000002S3Sl&apos;,
CreatedById = &apos;00570000003hCBt&apos;
)
&amp;&amp; 
(Offer__r.Name = &apos;WEX Fleet One All Roads&apos; ||
Offer__r.Name = &apos;Fleet One LLC Edge BOCA&apos; || 
Offer__r.Name = &apos;Fleet One Over the Road&apos;|| 
Offer__r.Name = &apos;Fleet One Owner/Operator OO-2015&apos; || 
Offer__r.Name = &apos;Fleet One EDGE&apos; || 
Offer__r.Name = &apos;RR - Over the Road&apos; || 
Offer__r.Name = &apos;Fleet One Over the Road O/O Microsite 2016&apos; ||
Offer__r.Name = &apos;C-Sunoco OTR DM 042016&apos;|| 
Offer__r.Name = &apos;Fuelbook Social 2016&apos;|| 
Offer__r.Name = &apos;BP Lab Services - OTR - Business Services Agreement&apos;|| 
Offer__r.Name = &apos;uShip OTR&apos;|| 
Offer__r.Name = &apos;PrePass - Package B&apos;|| 
Offer__r.Name = &apos;GE Capital OTR&apos;|| 
Offer__r.Name = &apos;UTA OTR BAA&apos; || 
Offer__r.Name = &apos;Idealease OTR&apos;|| 
Offer__r.Name = &apos;Truckers Advantage&apos;|| 
Offer__r.Name = &apos;AMSA Fleet Discount - Local&apos;|| 
Offer__r.Name = &apos;Fuelbook Card&apos;|| 
Offer__r.Name = &apos;AMSA - Fleet Discount Card&apos;|| 
Offer__r.Name = &apos;Sunoco OTR for Website&apos;|| 
Offer__r.Name = &apos;PrePass - Package A&apos;|| 
Offer__r.Name = &apos;C-Sunoco OTR 2016 EM #1&apos; || 
Offer__r.Name = &apos;C-Sunoco OTR 2016 EM #2&apos;|| 
Offer__r.Name = &apos;Fuelbook Select&apos;|| 
Offer__r.Name = &apos;Fuelbook B&apos;|| 
Offer__r.Name = &apos;Exxon Mobil NAD (OTR)&apos;|| 
Offer__r.Name = &apos;Pilot OTR Business Card Agreement&apos;|| 
Offer__r.Name = &apos;CTA - OTR&apos;|| 
Offer__r.Name = &apos;NAVL Fleet Card - Over the Road&apos;|| 
Offer__r.Name = &apos;Fleet One Over the Road Rigdig&apos;|| 
Offer__r.Name = &apos;FTI Benefits - Local - Business Services Agreement&apos;|| 
Offer__r.Name = &apos;Discount Diesel&apos;|| 
Offer__r.Name = &apos;Knight Logistics&apos;|| 
Offer__r.Name = &apos;Sinclair OTR&apos;||
Offer__r.Name = &apos;Fleet One Edge Over The Road&apos;)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>eApp Owner - Justin Lee</fullName>
        <actions>
            <name>Assign_to_Justin</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>assign 51-199 units to &apos;all West &apos;</description>
        <formula>(Number_of_Trucks__c &gt;= 51 &amp;&amp; Number_of_Trucks__c &lt;= 199) &amp;&amp; 
(ISPICKVAL(State__c, &apos;UT&apos;)||
ISPICKVAL(State__c, &apos;OK&apos;)||
ISPICKVAL(State__c, &apos;AZ&apos;)||
ISPICKVAL(State__c, &apos;KS&apos;)||
ISPICKVAL(State__c, &apos;ID&apos;)||
ISPICKVAL(State__c, &apos;WY&apos;)||
ISPICKVAL(State__c, &apos;TX&apos;)||
ISPICKVAL(State__c, &apos;TN&apos;)||
ISPICKVAL(State__c, &apos;MO&apos;)||
ISPICKVAL(State__c, &apos;LA&apos;)||
ISPICKVAL(State__c, &apos;AR&apos;)||
ISPICKVAL(State__c, &apos;CO&apos;)||
ISPICKVAL(State__c, &apos;WA&apos;)||
ISPICKVAL(State__c, &apos;OR&apos;)||
ISPICKVAL(State__c, &apos;MS&apos;)||
ISPICKVAL(State__c, &apos;MT&apos;)||
ISPICKVAL(State__c, &apos;NM&apos;)||
ISPICKVAL(State__c, &apos;NV&apos;)||
ISPICKVAL(State__c, &apos;CA&apos;)||
ISPICKVAL(State__c, &apos;AK&apos;))&amp;&amp; 
(CreatedById = &apos;00570000002S3Sl&apos;) &amp;&amp; 
(Offer__r.Name = &apos;WEX Fleet One All Roads&apos; || 
Offer__r.Name = &apos;Fleet One Over the Road&apos; || 
Offer__r.Name = &apos;Fleet One Owner/Operator OO-2015&apos; || 
Offer__r.Name = &apos;Fleet One EDGE&apos; ||
Offer__r.Name = &apos;RR - Over the Road&apos; ||
Offer__r.Name = &apos;Fleet One Over the Road O/O Microsite 2016&apos; ||
Offer__r.Name = &apos;Fleet One Edge Over The Road&apos;)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>eApp Owner - Katie Haywood</fullName>
        <active>false</active>
        <description>Assign eApp with 0-50 units</description>
        <formula>Number_of_Trucks__c &lt;= 50 &amp;&amp; 
(ISPICKVAL(State__c,&apos;FL&apos;)) &amp;&amp;
OR(
CreatedById = &apos;00570000002S3Sl&apos;,
CreatedById = &apos;00570000003hCBt&apos;
)
&amp;&amp; 
(Offer__r.Name = &apos;WEX Fleet One All Roads&apos; ||
Offer__r.Name = &apos;Fleet One LLC Edge BOCA&apos; || 
Offer__r.Name = &apos;Fleet One Over the Road&apos; || 
Offer__r.Name = &apos;Fleet One Owner/Operator OO-2015&apos; || 
Offer__r.Name = &apos;Fleet One EDGE&apos; ||
Offer__r.Name = &apos;RR - Over the Road&apos; ||
Offer__r.Name = &apos;Fleet One Over the Road O/O Microsite 2016&apos; ||
Offer__r.Name = &apos;Fleet One Edge Over The Road&apos; ||
Offer__r.Name = &apos;Fleet One Edge LLC BOCA SG&apos;)</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>eApp Owner - Katie Schwerdtfeger</fullName>
        <active>false</active>
        <description>Assign eApp with 0-50 units</description>
        <formula>(Number_of_Trucks__c &lt;= 50) &amp;&amp; 
(ISPICKVAL(State__c, &apos;PA&apos;) || 
ISPICKVAL(State__c, &apos;NY&apos;) || 
ISPICKVAL(State__c, &apos;DE&apos;) || 
ISPICKVAL(State__c, &apos;DC&apos;))&amp;&amp; 
OR(
CreatedById = &apos;00570000002S3Sl&apos;,
CreatedById = &apos;00570000003hCBt&apos;
)
&amp;&amp; 
(Offer__r.Name = &apos;WEX Fleet One All Roads&apos; ||
Offer__r.Name = &apos;Fleet One LLC Edge BOCA&apos; || 
Offer__r.Name = &apos;Fleet One Over the Road&apos; || 
Offer__r.Name = &apos;Fleet One Owner/Operator OO-2015&apos; || 
Offer__r.Name = &apos;Fleet One EDGE&apos; ||
Offer__r.Name = &apos;RR - Over the Road&apos; ||
Offer__r.Name = &apos;Fleet One Over the Road O/O Microsite 2016&apos; ||
Offer__r.Name = &apos;Fleet One Edge Over The Road&apos; ||
Offer__r.Name = &apos;Fleet One Edge LLC BOCA SG&apos;)</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>eApp Owner - Knight Logistics</fullName>
        <actions>
            <name>Set_Owner_to_Knight_Logistics</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>OnlineApplication__c.Application_Title__c</field>
            <operation>startsWith</operation>
            <value>Knight Logistics</value>
        </criteriaItems>
        <criteriaItems>
            <field>OnlineApplication__c.CreatedById</field>
            <operation>equals</operation>
            <value>appl Site Guest User</value>
        </criteriaItems>
        <description>Change owner of Online App from Guest User to Faye Gotten, based on the Application Title.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>eApp Owner - Knight Logistics - Offer Name</fullName>
        <actions>
            <name>Change_owner_of_Online_App_from_Guest_Us</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>OnlineApplication__c.Offer_Name_WF_TXT__c</field>
            <operation>startsWith</operation>
            <value>Knight Logistics</value>
        </criteriaItems>
        <criteriaItems>
            <field>OnlineApplication__c.CreatedById</field>
            <operation>equals</operation>
            <value>CreditApplication Site Guest User</value>
        </criteriaItems>
        <description>Change owner of Online App from Guest User to Faye Gotten, based on the Application Title.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>eApp Owner - Kris Chadwick</fullName>
        <actions>
            <name>Assign_to_Kris</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>Assign eApp with 0-50 units</description>
        <formula>(Number_of_Trucks__c &lt;= 50) &amp;&amp; 
(ISPICKVAL(State__c, &apos;WA&apos;) || 
ISPICKVAL(State__c, &apos;CO&apos;) || 
ISPICKVAL(State__c, &apos;OR&apos;)|| 
ISPICKVAL(State__c, &apos;HI&apos;))&amp;&amp; 
OR(
CreatedById = &apos;00570000002S3Sl&apos;,
CreatedById = &apos;00570000003hCBt&apos;
)
&amp;&amp; 
(Offer__r.Name = &apos;WEX Fleet One All Roads&apos; ||
Offer__r.Name = &apos;Fleet One LLC Edge BOCA&apos; || 
Offer__r.Name = &apos;Fleet One Over the Road&apos; || 
Offer__r.Name = &apos;Fleet One Owner/Operator OO-2015&apos; || 
Offer__r.Name = &apos;Fleet One EDGE&apos; ||
Offer__r.Name = &apos;RR - Over the Road&apos; ||
Offer__r.Name = &apos;Fleet One Over the Road O/O Microsite 2016&apos; ||
Offer__r.Name = &apos;Fleet One Edge Over The Road&apos; ||
Offer__r.Name = &apos;Fleet One Edge LLC BOCA SG&apos;)</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>eApp Owner - Liquid Capital</fullName>
        <actions>
            <name>Assign_to_Ernane_Iung</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>OnlineApplication__c.Offer_Name_WF_TXT__c</field>
            <operation>startsWith</operation>
            <value>Liquid Capital</value>
        </criteriaItems>
        <criteriaItems>
            <field>OnlineApplication__c.CreatedById</field>
            <operation>equals</operation>
            <value>CreditApplication Site Guest User</value>
        </criteriaItems>
        <description>Change owner of Online App from Guest User to Ernane Iung, based on the Offer Name WF TXT.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>eApp Owner - Melanie Sleigh</fullName>
        <actions>
            <name>Assign_to_Melanie</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>Assign eApp with 0-50 units</description>
        <formula>Number_of_Trucks__c &lt;= 50 &amp;&amp; 
(ISPICKVAL(State__c,&apos;MN&apos;)|| 
ISPICKVAL(State__c,&apos;WI&apos;)|| 
ISPICKVAL(State__c,&apos;UT&apos;)||
ISPICKVAL(State__c,&apos;MS&apos;))  &amp;&amp; 
OR(
CreatedById = &apos;00570000002S3Sl&apos;,
CreatedById = &apos;00570000003hCBt&apos;
)
&amp;&amp; 
(Offer__r.Name = &apos;WEX Fleet One All Roads&apos; ||
Offer__r.Name = &apos;Fleet One LLC Edge BOCA&apos; || 
Offer__r.Name = &apos;Fleet One Over the Road&apos;|| 
Offer__r.Name = &apos;Fleet One Owner/Operator OO-2015&apos; || 
Offer__r.Name = &apos;Fleet One EDGE&apos; ||
Offer__r.Name = &apos;RR - Over the Road&apos; ||
Offer__r.Name = &apos;Fleet One Over the Road O/O Microsite 2016&apos; ||
Offer__r.Name = &apos;Fleet One Edge Over The Road&apos; ||
Offer__r.Name = &apos;Fleet One Edge LLC BOCA SG&apos;)</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>eApp Owner - Michael Monroe</fullName>
        <actions>
            <name>Assign_To_Michael</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>Assign eApp with 0-50 units</description>
        <formula>(Number_of_Trucks__c &lt;= 50) &amp;&amp; 
(ISPICKVAL(State__c, &apos;NJ&apos;) || 
ISPICKVAL(State__c, &apos;ME&apos;) || 
ISPICKVAL(State__c, &apos;NH&apos;)|| 
ISPICKVAL(State__c, &apos;RI&apos;)|| 
ISPICKVAL(State__c, &apos;VT&apos;)|| 
ISPICKVAL(State__c, &apos;VA&apos;) )
&amp;&amp; 
OR(
CreatedById = &apos;00570000002S3Sl&apos;,
CreatedById = &apos;00570000003hCBt&apos;
)
&amp;&amp; 
(Offer__r.Name = &apos;WEX Fleet One All Roads&apos; ||
Offer__r.Name = &apos;Fleet One LLC Edge BOCA&apos; || 
Offer__r.Name = &apos;Fleet One Over the Road&apos; || 
Offer__r.Name = &apos;Fleet One Owner/Operator OO-2015&apos; || 
Offer__r.Name = &apos;Fleet One EDGE&apos; ||
Offer__r.Name = &apos;RR - Over the Road&apos; ||
Offer__r.Name = &apos;Fleet One Over the Road O/O Microsite 2016&apos; ||
Offer__r.Name = &apos;Fleet One Edge Over The Road&apos; ||
Offer__r.Name = &apos;Fleet One Edge LLC BOCA SG&apos;)</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>eApp Owner - Milos Pavlovic</fullName>
        <actions>
            <name>Owner_Milos_Pavlovic</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>OnlineApplication__c.Application_Title__c</field>
            <operation>startsWith</operation>
            <value>3MD Solutions</value>
        </criteriaItems>
        <criteriaItems>
            <field>OnlineApplication__c.CreatedById</field>
            <operation>equals</operation>
            <value>appl Site Guest User</value>
        </criteriaItems>
        <description>Change owner of Online Appp from Guest User to Milos, based on the Application Title.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>eApp Owner - NASTC</fullName>
        <actions>
            <name>nastc_owner</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>OnlineApplication__c.Application_Title__c</field>
            <operation>startsWith</operation>
            <value>NASTC</value>
        </criteriaItems>
        <criteriaItems>
            <field>OnlineApplication__c.CreatedById</field>
            <operation>equals</operation>
            <value>appl Site Guest User</value>
        </criteriaItems>
        <description>Change owner of Online App from Guest User to John Randle, based on the Application Title.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>eApp Owner - NASTC %28BOCA%29</fullName>
        <actions>
            <name>Assign_to_John_Randles</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>OnlineApplication__c.Offer_Name_WF_TXT__c</field>
            <operation>startsWith</operation>
            <value>NASTC</value>
        </criteriaItems>
        <criteriaItems>
            <field>OnlineApplication__c.CreatedById</field>
            <operation>equals</operation>
            <value>CreditApplication Site Guest User</value>
        </criteriaItems>
        <description>Change owner of Online App from Guest User to John Randle, based on the OfferName WF TXT.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>eApp Owner - Noel Glasgow</fullName>
        <actions>
            <name>Assign_to_Noel</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Assign eApp with 200+ units</description>
        <formula>AND((Number_of_Trucks__c  &gt;= 200) &amp;&amp;
(ISPICKVAL(State__c, &apos;GA&apos;) || 
ISPICKVAL(State__c, &apos;FL&apos;) || 
ISPICKVAL(State__c, &apos;OH&apos;)|| 
ISPICKVAL(State__c, &apos;ME&apos;)|| 
ISPICKVAL(State__c, &apos;NH&apos;)|| 
ISPICKVAL(State__c, &apos;VT&apos;)|| 
ISPICKVAL(State__c, &apos;MA&apos;)|| 
ISPICKVAL(State__c, &apos;RI&apos;)|| 
ISPICKVAL(State__c, &apos;DE&apos;)|| 
ISPICKVAL(State__c, &apos;MD&apos;) ||
ISPICKVAL(State__c, &apos;DC&apos;) ||
ISPICKVAL(State__c, &apos;MI&apos;) ||
ISPICKVAL(State__c, &apos;NJ&apos;) ||
ISPICKVAL(State__c, &apos;TN&apos;) ||
ISPICKVAL(State__c, &apos;AL&apos;) ||
ISPICKVAL(State__c, &apos;MN&apos;) ||
ISPICKVAL(State__c, &apos;SC&apos;) ||
ISPICKVAL(State__c, &apos;NC&apos;) ||
ISPICKVAL(State__c, &apos;ND&apos;)) &amp;&amp; 
OR(
CreatedById = &apos;00570000002S3Sl&apos;,
CreatedById = &apos;00570000003hCBt&apos;
)
&amp;&amp; 
(Offer__r.Name = &apos;WEX Fleet One All Roads&apos; ||
Offer__r.Name = &apos;Fleet One LLC Edge BOCA&apos; || 
Offer__r.Name = &apos;Fleet One Over the Road&apos; || 
Offer__r.Name = &apos;Fleet One Owner/Operator OO-2015&apos; || 
Offer__r.Name = &apos;Fleet One EDGE&apos; ||
Offer__r.Name = &apos;RR - Over the Road&apos; ||
Offer__r.Name = &apos;Fleet One Over the Road O/O Microsite 2016&apos; ||
Offer__r.Name = &apos;Fleet One Edge Over The Road&apos;))</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>eApp Owner - OTR Capital</fullName>
        <actions>
            <name>Assign_to_Cody_Barwig</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>OnlineApplication__c.Offer_Name_WF_TXT__c</field>
            <operation>startsWith</operation>
            <value>OTR Capital</value>
        </criteriaItems>
        <criteriaItems>
            <field>OnlineApplication__c.CreatedById</field>
            <operation>equals</operation>
            <value>CreditApplication Site Guest User</value>
        </criteriaItems>
        <description>Change owner of Online App from Guest User to Cody Barwig, based on the Offer Name WF TXT.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>eApp Owner - PTP Stop NATSN</fullName>
        <actions>
            <name>Assign_to_James_Ladner</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>OnlineApplication__c.Offer_Name_WF_TXT__c</field>
            <operation>startsWith</operation>
            <value>NATSN</value>
        </criteriaItems>
        <criteriaItems>
            <field>OnlineApplication__c.CreatedById</field>
            <operation>equals</operation>
            <value>CreditApplication Site Guest User</value>
        </criteriaItems>
        <description>Change owner of Online App from Guest User to James Latner, based on the Offer Name WF TXT.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>eApp Owner - Partners Funding</fullName>
        <actions>
            <name>Assign_to_Patti_Mielke</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>OnlineApplication__c.Offer_Name_WF_TXT__c</field>
            <operation>startsWith</operation>
            <value>Partners Funding</value>
        </criteriaItems>
        <criteriaItems>
            <field>OnlineApplication__c.CreatedById</field>
            <operation>equals</operation>
            <value>CreditApplication Site Guest User</value>
        </criteriaItems>
        <description>Change owner of Online App from Guest User to Patti Mielke, based on the Offer Name WF TXT.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>eApp Owner - Patriot Fleet Solutions</fullName>
        <actions>
            <name>Set_Michael_Lingman_as_owner</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>OnlineApplication__c.Application_Title__c</field>
            <operation>startsWith</operation>
            <value>Patriot Fleet</value>
        </criteriaItems>
        <criteriaItems>
            <field>OnlineApplication__c.CreatedById</field>
            <operation>equals</operation>
            <value>appl Site Guest User</value>
        </criteriaItems>
        <description>Change owner of Online App from Guest User to Michael Lingman , based on the Application Title.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>eApp Owner - Pavestone Capital</fullName>
        <actions>
            <name>Owner_Pavestone_Capital</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>OnlineApplication__c.Application_Title__c</field>
            <operation>startsWith</operation>
            <value>IT - Pavestone Capital - OTR</value>
        </criteriaItems>
        <criteriaItems>
            <field>OnlineApplication__c.CreatedById</field>
            <operation>equals</operation>
            <value>appl Site Guest User</value>
        </criteriaItems>
        <description>Change owner of Online App from Guest User to Pavestone Capital, based on the Application Title.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>eApp Owner - Pay4Freight</fullName>
        <actions>
            <name>Assign_to_Robert_Beard</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>OnlineApplication__c.Offer_Name_WF_TXT__c</field>
            <operation>startsWith</operation>
            <value>Pay4Freight</value>
        </criteriaItems>
        <criteriaItems>
            <field>OnlineApplication__c.CreatedById</field>
            <operation>equals</operation>
            <value>CreditApplication Site Guest User</value>
        </criteriaItems>
        <description>Change owner of Online App from Guest User to Robert Beard, based on the Offer Name WF TXT.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>eApp Owner - Petro Solutions</fullName>
        <actions>
            <name>Assign_to_Chuck_Miller</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>OnlineApplication__c.Offer_Name_WF_TXT__c</field>
            <operation>startsWith</operation>
            <value>Petro Solutions</value>
        </criteriaItems>
        <criteriaItems>
            <field>OnlineApplication__c.CreatedById</field>
            <operation>equals</operation>
            <value>CreditApplication Site Guest User</value>
        </criteriaItems>
        <description>Change owner of Online App from Guest User to Chuck Miller, based on the Offer Name WF TXT.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>eApp Owner - Prepass</fullName>
        <actions>
            <name>Owner_Martha_Ibarra</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>OnlineApplication__c.Application_Title__c</field>
            <operation>startsWith</operation>
            <value>PrePass</value>
        </criteriaItems>
        <criteriaItems>
            <field>OnlineApplication__c.CreatedById</field>
            <operation>equals</operation>
            <value>appl Site Guest User</value>
        </criteriaItems>
        <description>Change owner of Online App from Guest User to Prepass Owner , based on the Application Title.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>eApp Owner - Quality Companies</fullName>
        <actions>
            <name>eApp_Owner_Kyle_Cox_Quality_Companies</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>OnlineApplication__c.Application_Title__c</field>
            <operation>startsWith</operation>
            <value>Quality Companies</value>
        </criteriaItems>
        <criteriaItems>
            <field>OnlineApplication__c.CreatedById</field>
            <operation>equals</operation>
            <value>appl Site Guest User</value>
        </criteriaItems>
        <description>Change owner of Online App from Guest User to Kyle Cox, based on the Application Title. (Quality Companies)</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>eApp Owner - Quick Pay Funding</fullName>
        <actions>
            <name>Assign_to_JUAN_ESTRADA</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>OnlineApplication__c.Offer_Name_WF_TXT__c</field>
            <operation>startsWith</operation>
            <value>Quick Pay Funding</value>
        </criteriaItems>
        <criteriaItems>
            <field>OnlineApplication__c.CreatedById</field>
            <operation>equals</operation>
            <value>CreditApplication Site Guest User</value>
        </criteriaItems>
        <description>Change owner of Online App from Guest User to JUAN ESTRADA, based on the Offer Name WF TXT.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>eApp Owner - RTS</fullName>
        <actions>
            <name>Update_Owner_RTS</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>OnlineApplication__c.Offer_Name_WF_TXT__c</field>
            <operation>startsWith</operation>
            <value>RTS Carrier Services</value>
        </criteriaItems>
        <criteriaItems>
            <field>OnlineApplication__c.CreatedById</field>
            <operation>equals</operation>
            <value>CreditApplication Site Guest User</value>
        </criteriaItems>
        <description>Change owner of Online App from Guest User to RTS Partner Queue, based on the Offer Name WF TXT.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>eApp Owner - RTS Queue</fullName>
        <actions>
            <name>Owner_RTS</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>Change owner of Online App from Guest User to RTS Queue based on the Application Title.</description>
        <formula>AND (BEGINS(Application_Title__c, &apos;RTS&apos;) &amp;&amp; (CreatedBy.UserRole.Name = &apos;RTS Carrier Services Partner User&apos; ||CreatedBy.UserRole.Name = &apos;RTS Carrier Services Partner Executive&apos;||CreatedBy.UserRole.Name = &apos;RTS Carrier Services Partner Manager&apos;))</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>eApp Owner - RTS Queue OLD</fullName>
        <actions>
            <name>Updated_Owner_RTS</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>OnlineApplication__c.Application_Title__c</field>
            <operation>startsWith</operation>
            <value>RTS</value>
        </criteriaItems>
        <criteriaItems>
            <field>OnlineApplication__c.CreatedById</field>
            <operation>equals</operation>
            <value>appl Site Guest User</value>
        </criteriaItems>
        <description>Change owner of Online App from Guest User to RTS Queue based on the Application Title.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>eApp Owner - Reginald Craig</fullName>
        <actions>
            <name>Assign_to_Reginald</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>Assign eApp with 0-50 units</description>
        <formula>(Number_of_Trucks__c &lt;= 50) &amp;&amp; 
(ISPICKVAL(State__c, &apos;TX&apos;))&amp;&amp; 
OR(
CreatedById = &apos;00570000002S3Sl&apos;,
CreatedById = &apos;00570000003hCBt&apos;
)
&amp;&amp; 
(Offer__r.Name = &apos;WEX Fleet One All Roads&apos; ||
Offer__r.Name = &apos;Fleet One LLC Edge BOCA&apos; || 
Offer__r.Name = &apos;Fleet One Over the Road&apos; || 
Offer__r.Name = &apos;Fleet One Owner/Operator OO-2015&apos; || 
Offer__r.Name = &apos;Fleet One EDGE&apos; ||
Offer__r.Name = &apos;RR - Over the Road&apos; ||
Offer__r.Name = &apos;Fleet One Over the Road O/O Microsite 2016&apos; ||
Offer__r.Name = &apos;Fleet One Edge Over The Road&apos; ||
Offer__r.Name = &apos;Fleet One Edge LLC BOCA SG&apos;)</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>eApp Owner - Richard Nevin</fullName>
        <active>false</active>
        <criteriaItems>
            <field>OnlineApplication__c.Application_Title__c</field>
            <operation>startsWith</operation>
            <value>WEX Fleet One All Roads</value>
        </criteriaItems>
        <criteriaItems>
            <field>OnlineApplication__c.CreatedById</field>
            <operation>equals</operation>
            <value>appl Site Guest User</value>
        </criteriaItems>
        <criteriaItems>
            <field>OnlineApplication__c.AO_State__c</field>
            <operation>equals</operation>
            <value>AR,OK,WA</value>
        </criteriaItems>
        <description>Change owner of Online App from Guest User to Richard Nevin, based on the Application Title.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>eApp Owner - Roady%27s Card</fullName>
        <actions>
            <name>Owner_Roady_s_Card</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>OnlineApplication__c.Application_Title__c</field>
            <operation>startsWith</operation>
            <value>IT - Roady&apos;s - OTR</value>
        </criteriaItems>
        <criteriaItems>
            <field>OnlineApplication__c.CreatedById</field>
            <operation>equals</operation>
            <value>appl Site Guest User</value>
        </criteriaItems>
        <description>Change owner of Online App from Guest User to Roady&apos;s Card, based on the Application Title.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>eApp Owner - Ryan Knowles</fullName>
        <actions>
            <name>Assign_to_Ryan_Knowles</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>Assign eApp with 0-50 units</description>
        <formula>Number_of_Trucks__c &lt;= 50 &amp;&amp; 
(ISPICKVAL(State__c,&apos;CA&apos;))&amp;&amp;
OR(
CreatedById = &apos;00570000002S3Sl&apos;,
CreatedById = &apos;00570000003hCBt&apos;
)
&amp;&amp; 
(Offer__r.Name = &apos;WEX Fleet One All Roads&apos; ||
Offer__r.Name = &apos;Fleet One LLC Edge BOCA&apos; || 
Offer__r.Name = &apos;Fleet One Over the Road&apos;|| 
Offer__r.Name = &apos;Fleet One Owner/Operator OO-2015&apos; || 
Offer__r.Name = &apos;Fleet One EDGE&apos; ||
Offer__r.Name = &apos;RR - Over the Road&apos; ||
Offer__r.Name = &apos;Fleet One Over the Road O/O Microsite 2016&apos; ||
Offer__r.Name = &apos;Fleet One Edge Over The Road&apos; ||
Offer__r.Name = &apos;Fleet One Edge LLC BOCA SG&apos;)</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>eApp Owner - STC</fullName>
        <actions>
            <name>Owner_STC</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>OnlineApplication__c.Application_Title__c</field>
            <operation>startsWith</operation>
            <value>STC</value>
        </criteriaItems>
        <criteriaItems>
            <field>OnlineApplication__c.CreatedById</field>
            <operation>equals</operation>
            <value>appl Site Guest User</value>
        </criteriaItems>
        <description>Change owner of Online App from Guest User to STC, based on the Application Title.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>eApp Owner - SUMMAR</fullName>
        <actions>
            <name>Assign_to_Jessi_Saker</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>OnlineApplication__c.Offer_Name_WF_TXT__c</field>
            <operation>startsWith</operation>
            <value>SUMMAR</value>
        </criteriaItems>
        <criteriaItems>
            <field>OnlineApplication__c.CreatedById</field>
            <operation>equals</operation>
            <value>CreditApplication Site Guest User</value>
        </criteriaItems>
        <description>Change owner of Online App from Guest User to Jessi Saker, based on the Offer Name WF TXT.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>eApp Owner - Sandi Baylis</fullName>
        <actions>
            <name>Assign_to_Sandi_Baylis</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>Assign eApp with 0-50 units</description>
        <formula>(Number_of_Trucks__c &lt;= 50) &amp;&amp; 
(ISPICKVAL(State__c, &apos;IN&apos;) || 
ISPICKVAL(State__c, &apos;MI&apos;) || 
ISPICKVAL(State__c, &apos;WV&apos;))&amp;&amp; 
OR(
CreatedById = &apos;00570000002S3Sl&apos;,
CreatedById = &apos;00570000003hCBt&apos;
)
&amp;&amp; 
(Offer__r.Name = &apos;WEX Fleet One All Roads&apos; ||
Offer__r.Name = &apos;Fleet One LLC Edge BOCA&apos; || 
Offer__r.Name = &apos;Fleet One Over the Road&apos; || 
Offer__r.Name = &apos;Fleet One Owner/Operator OO-2015&apos; || 
Offer__r.Name = &apos;Fleet One EDGE&apos; ||
Offer__r.Name = &apos;RR - Over the Road&apos; ||
Offer__r.Name = &apos;Fleet One Over the Road O/O Microsite 2016&apos; ||
Offer__r.Name = &apos;Fleet One Edge Over The Road&apos; ||
Offer__r.Name = &apos;Fleet One Edge LLC BOCA SG&apos;)</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>eApp Owner - Shelly Gordon</fullName>
        <actions>
            <name>Owner_Shelly_Gordon</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>OnlineApplication__c.Application_Title__c</field>
            <operation>startsWith</operation>
            <value>Pilot,360 OTR,NFN,OTR,Pavestone,Trucking Startup,Westar</value>
        </criteriaItems>
        <criteriaItems>
            <field>OnlineApplication__c.CreatedById</field>
            <operation>equals</operation>
            <value>appl Site Guest User</value>
        </criteriaItems>
        <description>Change owner of Online App from Guest User to Shelly Gordon, based on the Application Title.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>eApp Owner - Sherri Bateman</fullName>
        <active>false</active>
        <criteriaItems>
            <field>OnlineApplication__c.Application_Title__c</field>
            <operation>startsWith</operation>
            <value>CarsArrive</value>
        </criteriaItems>
        <criteriaItems>
            <field>OnlineApplication__c.CreatedById</field>
            <operation>equals</operation>
            <value>appl Site Guest User</value>
        </criteriaItems>
        <description>Change owner of Online App from Guest User to Tina Kimble, based on the Application Title.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>eApp Owner - Single Point Fuel Card</fullName>
        <actions>
            <name>Owner_Single_Point_Fuel_Card</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>OnlineApplication__c.Application_Title__c</field>
            <operation>startsWith</operation>
            <value>Single</value>
        </criteriaItems>
        <criteriaItems>
            <field>OnlineApplication__c.CreatedById</field>
            <operation>equals</operation>
            <value>appl Site Guest User</value>
        </criteriaItems>
        <description>Change owner of Online App from Guest User to Single Point Fuel Card, based on the Application Title.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>eApp Owner - St Johns</fullName>
        <actions>
            <name>Assign_to_Christina_Kordik</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>OnlineApplication__c.Offer_Name_WF_TXT__c</field>
            <operation>startsWith</operation>
            <value>St Johns</value>
        </criteriaItems>
        <criteriaItems>
            <field>OnlineApplication__c.CreatedById</field>
            <operation>equals</operation>
            <value>CreditApplication Site Guest User</value>
        </criteriaItems>
        <description>Change owner of Online App from Guest User to Christina Kordik, based on the Offer Name WF TXT.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>eApp Owner - Steelhead</fullName>
        <actions>
            <name>Assign_to_Rich_Templeton</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>OnlineApplication__c.Offer_Name_WF_TXT__c</field>
            <operation>startsWith</operation>
            <value>Steelhead</value>
        </criteriaItems>
        <criteriaItems>
            <field>OnlineApplication__c.CreatedById</field>
            <operation>equals</operation>
            <value>CreditApplication Site Guest User</value>
        </criteriaItems>
        <description>Change owner of Online App from Guest User to Rich Templeton, based on the Offer Name WF TXT.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>eApp Owner - Sunbelt</fullName>
        <actions>
            <name>Assign_to_Debbie_Kimberland</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>OnlineApplication__c.Offer_Name_WF_TXT__c</field>
            <operation>startsWith</operation>
            <value>Sunbelt</value>
        </criteriaItems>
        <criteriaItems>
            <field>OnlineApplication__c.CreatedById</field>
            <operation>equals</operation>
            <value>CreditApplication Site Guest User</value>
        </criteriaItems>
        <description>Change owner of Online App from Guest User to Debbie Kimberland, based on the Offer Name WF TXT.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>eApp Owner - TBS Factoring</fullName>
        <actions>
            <name>Assign_to_Ashley_Wendorff</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>OnlineApplication__c.Offer_Name_WF_TXT__c</field>
            <operation>startsWith</operation>
            <value>TBS Factoring</value>
        </criteriaItems>
        <criteriaItems>
            <field>OnlineApplication__c.CreatedById</field>
            <operation>equals</operation>
            <value>CreditApplication Site Guest User</value>
        </criteriaItems>
        <description>Change owner of Online App from Guest User to Ashley Wendorff, based on the Offer Name WF TXT.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>eApp Owner - TRANSPORT FINANCIAL SOLUTIONS</fullName>
        <actions>
            <name>Assign_to_Sheri_Breedlove</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>OnlineApplication__c.Offer_Name_WF_TXT__c</field>
            <operation>startsWith</operation>
            <value>TRANSPORT FINANCIAL SOLUTIONS</value>
        </criteriaItems>
        <criteriaItems>
            <field>OnlineApplication__c.CreatedById</field>
            <operation>equals</operation>
            <value>CreditApplication Site Guest User</value>
        </criteriaItems>
        <description>Change owner of Online App from Guest User to Sheri Breedlove, based on the Offer Name WF TXT.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>eApp Owner - TRIUMPH BUSINESS CAPITAL</fullName>
        <actions>
            <name>Assign_to_Jason_Mullican</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>OnlineApplication__c.Offer_Name_WF_TXT__c</field>
            <operation>startsWith</operation>
            <value>Triumph Business Capital</value>
        </criteriaItems>
        <criteriaItems>
            <field>OnlineApplication__c.CreatedById</field>
            <operation>equals</operation>
            <value>CreditApplication Site Guest User</value>
        </criteriaItems>
        <description>Change owner of Online App from Guest User to Jason Mullican, based on the Offer Name WF TXT.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>eApp Owner - Thunder Carrier Services</fullName>
        <actions>
            <name>Assign_to_Willie_Andruss</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>OnlineApplication__c.Offer_Name_WF_TXT__c</field>
            <operation>startsWith</operation>
            <value>Thunder Carrier Services</value>
        </criteriaItems>
        <criteriaItems>
            <field>OnlineApplication__c.CreatedById</field>
            <operation>equals</operation>
            <value>CreditApplication Site Guest User</value>
        </criteriaItems>
        <description>Change owner of Online App from Guest User to Willie Andruss, based on the Offer Name WF TXT.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>eApp Owner - Tina Kimble</fullName>
        <active>false</active>
        <criteriaItems>
            <field>OnlineApplication__c.Application_Title__c</field>
            <operation>startsWith</operation>
            <value>SA Fleet,Thorntons,Hucks,Nice,Rally</value>
        </criteriaItems>
        <criteriaItems>
            <field>OnlineApplication__c.CreatedById</field>
            <operation>equals</operation>
            <value>appl Site Guest User</value>
        </criteriaItems>
        <description>Change owner of Online App from Guest User to Tina Kimble, based on the Application Title.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>eApp Owner - Tony Lehenbauer</fullName>
        <actions>
            <name>Assign_to_Tony</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Assign eApp with 200+ units</description>
        <formula>Number_of_Trucks__c  &gt;= 200 &amp;&amp;
(ISPICKVAL(State__c, &apos;IA&apos;) || 
ISPICKVAL(State__c, &apos;IN&apos;) || 
ISPICKVAL(State__c, &apos;IL&apos;)|| 
ISPICKVAL(State__c, &apos;KY&apos;)|| 
ISPICKVAL(State__c, &apos;NE&apos;)|| 
ISPICKVAL(State__c, &apos;NY&apos;)|| 
ISPICKVAL(State__c, &apos;PA&apos;)|| 
ISPICKVAL(State__c, &apos;SD&apos;)|| 
ISPICKVAL(State__c, &apos;VA&apos;)|| 
ISPICKVAL(State__c, &apos;WI&apos;) ||
ISPICKVAL(State__c, &apos;WV&apos;))&amp;&amp; 
OR(
CreatedById = &apos;00570000002S3Sl&apos;,
CreatedById = &apos;00570000003hCBt&apos;
)
&amp;&amp; 
(Offer__r.Name = &apos;WEX Fleet One All Roads&apos; ||
Offer__r.Name = &apos;Fleet One LLC Edge BOCA&apos; || 
Offer__r.Name = &apos;Fleet One Over the Road&apos; || 
Offer__r.Name = &apos;Fleet One Owner/Operator OO-2015&apos; || 
Offer__r.Name = &apos;Fleet One EDGE&apos; ||
Offer__r.Name = &apos;RR - Over the Road&apos; ||
Offer__r.Name = &apos;Fleet One Over the Road O/O Microsite 2016&apos; ||
Offer__r.Name = &apos;Fleet One Edge Over The Road&apos;)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>eApp Owner - Truckers B2B</fullName>
        <actions>
            <name>Owner_Truckers_B2B</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>OnlineApplication__c.Application_Title__c</field>
            <operation>startsWith</operation>
            <value>Truckers B2B</value>
        </criteriaItems>
        <criteriaItems>
            <field>OnlineApplication__c.CreatedById</field>
            <operation>equals</operation>
            <value>appl Site Guest User</value>
        </criteriaItems>
        <description>Change owner of Online App from Guest User to eApp Queue, based on the Application Title.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>eApp Owner - Truckers Solutions</fullName>
        <actions>
            <name>Owner_Changed_to_Dennis_Woods</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>OnlineApplication__c.Offer_Name_WF_TXT__c</field>
            <operation>startsWith</operation>
            <value>Truckers Solutions</value>
        </criteriaItems>
        <criteriaItems>
            <field>OnlineApplication__c.CreatedById</field>
            <operation>equals</operation>
            <value>CreditApplication Site Guest User</value>
        </criteriaItems>
        <description>Change owner of Online App from Guest User to Dennis Woods, based on the Offer Name WF TXT.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>eApp Owner - Trulos</fullName>
        <actions>
            <name>Owner_Eapp_Queue</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>OnlineApplication__c.Application_Title__c</field>
            <operation>startsWith</operation>
            <value>Trulos</value>
        </criteriaItems>
        <criteriaItems>
            <field>OnlineApplication__c.CreatedById</field>
            <operation>equals</operation>
            <value>appl Site Guest User</value>
        </criteriaItems>
        <description>Change owner of Online App from Guest User to eApp Queue, based on the Application Title.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>eApp Owner - Tyler Thompson</fullName>
        <actions>
            <name>Assign_to_Tyler</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>Assign eApp with 0-50 units</description>
        <formula>(Number_of_Trucks__c &lt;= 50) &amp;&amp; 
(ISPICKVAL(State__c, &apos;GA&apos;) || 
ISPICKVAL(State__c, &apos;MA&apos;) )
&amp;&amp; 
OR(
CreatedById = &apos;00570000002S3Sl&apos;,
CreatedById = &apos;00570000003hCBt&apos;
)
&amp;&amp; 
(Offer__r.Name = &apos;WEX Fleet One All Roads&apos; ||
Offer__r.Name = &apos;Fleet One LLC Edge BOCA&apos; || 
Offer__r.Name = &apos;Fleet One Over the Road&apos; || 
Offer__r.Name = &apos;Fleet One Owner/Operator OO-2015&apos; || 
Offer__r.Name = &apos;Fleet One EDGE&apos; ||
Offer__r.Name = &apos;RR - Over the Road&apos; ||
Offer__r.Name = &apos;Fleet One Over the Road O/O Microsite 2016&apos; ||
Offer__r.Name = &apos;Fleet One Edge Over The Road&apos; ||
Offer__r.Name = &apos;Fleet One Edge LLC BOCA SG&apos;)</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>eApp Owner - Vero Business Capital</fullName>
        <actions>
            <name>Assign_to_Trey_Heath</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>OnlineApplication__c.Offer_Name_WF_TXT__c</field>
            <operation>startsWith</operation>
            <value>Vero Business Capital</value>
        </criteriaItems>
        <criteriaItems>
            <field>OnlineApplication__c.CreatedById</field>
            <operation>equals</operation>
            <value>CreditApplication Site Guest User</value>
        </criteriaItems>
        <description>Change owner of Online App from Guest User to Trey Heath, based on the Offer Name WF TXT.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>eApp Owner - Walker Choppin</fullName>
        <active>false</active>
        <criteriaItems>
            <field>OnlineApplication__c.Application_Title__c</field>
            <operation>startsWith</operation>
            <value>Fuelbook</value>
        </criteriaItems>
        <criteriaItems>
            <field>OnlineApplication__c.CreatedById</field>
            <operation>equals</operation>
            <value>appl Site Guest User</value>
        </criteriaItems>
        <description>Change owner of Online App from Guest User to Walker Choppin , based on the Application Title.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>eApp Owner - WilcoHess</fullName>
        <active>true</active>
        <criteriaItems>
            <field>OnlineApplication__c.Application_Title__c</field>
            <operation>startsWith</operation>
            <value>WilcoHess</value>
        </criteriaItems>
        <criteriaItems>
            <field>OnlineApplication__c.CreatedById</field>
            <operation>equals</operation>
            <value>appl Site Guest User</value>
        </criteriaItems>
        <description>Change owner of Online App from Guest User to Mike Gordon, based on the Application Title.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>eApp Owner - XPO Logistics</fullName>
        <actions>
            <name>Owner_Corey_Luttrell</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>(1 OR 4) AND (2 OR 3)</booleanFilter>
        <criteriaItems>
            <field>OnlineApplication__c.Application_Title__c</field>
            <operation>startsWith</operation>
            <value>XPO Logistics</value>
        </criteriaItems>
        <criteriaItems>
            <field>OnlineApplication__c.CreatedById</field>
            <operation>equals</operation>
            <value>appl Site Guest User</value>
        </criteriaItems>
        <criteriaItems>
            <field>OnlineApplication__c.CreatedById</field>
            <operation>equals</operation>
            <value>CreditApplication Site Guest User</value>
        </criteriaItems>
        <criteriaItems>
            <field>OnlineApplication__c.Offer_Name_WF_TXT__c</field>
            <operation>startsWith</operation>
            <value>XPO Logistics</value>
        </criteriaItems>
        <description>Change owner of Online App from Guest User to XPO Logistics, based on the Application Title.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>eApp Owner - Xfactors</fullName>
        <actions>
            <name>Assign_to_JEFFREY_COLBURN</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>OnlineApplication__c.Offer_Name_WF_TXT__c</field>
            <operation>startsWith</operation>
            <value>Xfactors</value>
        </criteriaItems>
        <criteriaItems>
            <field>OnlineApplication__c.CreatedById</field>
            <operation>equals</operation>
            <value>CreditApplication Site Guest User</value>
        </criteriaItems>
        <description>Change owner of Online App from Guest User to JEFFREY COLBURN, based on the Offer Name WF TXT.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>eApp Owner - Zach Wall</fullName>
        <actions>
            <name>Assign_to_Zachwall</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>OnlineApplication__c.Application_Title__c</field>
            <operation>startsWith</operation>
            <value>Mansfield</value>
        </criteriaItems>
        <criteriaItems>
            <field>OnlineApplication__c.CreatedById</field>
            <operation>equals</operation>
            <value>appl Site Guest User</value>
        </criteriaItems>
        <description>Change owner of Online Appp from Guest User to Zach Wall, based on the Application Title.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>eApp Owner - Zachary Johnson</fullName>
        <actions>
            <name>Assign_to_Zach</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>Assign eApp with 0-50 units</description>
        <formula>Number_of_Trucks__c &lt;= 50 &amp;&amp; 
(ISPICKVAL(State__c,&apos;MO&apos;)|| 
ISPICKVAL(State__c,&apos;NE&apos;)||
ISPICKVAL(State__c,&apos;KS&apos;)||
ISPICKVAL(State__c,&apos;AK&apos;)||
ISPICKVAL(State__c,&apos;WY&apos;)) &amp;&amp;
OR(
CreatedById = &apos;00570000002S3Sl&apos;,
CreatedById = &apos;00570000003hCBt&apos;
)
&amp;&amp; 
(Offer__r.Name = &apos;WEX Fleet One All Roads&apos; ||
Offer__r.Name = &apos;Fleet One LLC Edge BOCA&apos; ||
Offer__r.Name = &apos;Fleet One Over the Road&apos;|| 
Offer__r.Name = &apos;Fleet One Owner/Operator OO-2015&apos; || 
Offer__r.Name = &apos;Fleet One EDGE&apos; ||
Offer__r.Name = &apos;Fleet One Over the Road O/O Microsite 2016&apos; ||
Offer__r.Name = &apos;RR - Over the Road&apos; ||
Offer__r.Name = &apos;Fleet One Edge Over The Road&apos; ||
Offer__r.Name = &apos;Fleet One Edge LLC BOCA SG&apos;)</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>eApp Owner - iThrive Funding</fullName>
        <actions>
            <name>Assign_to_Robert_Marker</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>OnlineApplication__c.Offer_Name_WF_TXT__c</field>
            <operation>startsWith</operation>
            <value>iThrive Funding</value>
        </criteriaItems>
        <criteriaItems>
            <field>OnlineApplication__c.CreatedById</field>
            <operation>equals</operation>
            <value>CreditApplication Site Guest User</value>
        </criteriaItems>
        <description>Change owner of Online App from Guest User to Robert Marker, based on the Offer Name WF TXT.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>eApp Owner -Parikh Financial</fullName>
        <actions>
            <name>Assign_to_Raj_Parikh</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>OnlineApplication__c.Offer_Name_WF_TXT__c</field>
            <operation>startsWith</operation>
            <value>Parikh Financial</value>
        </criteriaItems>
        <criteriaItems>
            <field>OnlineApplication__c.CreatedById</field>
            <operation>equals</operation>
            <value>CreditApplication Site Guest User</value>
        </criteriaItems>
        <description>Change owner of Online App from Guest User to Raj Parikh, based on the Offer Name WF TXT.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>eApp Owner CSI Global-Fleet</fullName>
        <actions>
            <name>eApp_Owner_CSI_Global_Fleet</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>OnlineApplication__c.Application_Title__c</field>
            <operation>startsWith</operation>
            <value>CSI Global</value>
        </criteriaItems>
        <criteriaItems>
            <field>OnlineApplication__c.CreatedById</field>
            <operation>equals</operation>
            <value>appl Site Guest User</value>
        </criteriaItems>
        <description>Change owner of Online App from Guest User to eApp Queue, based on the Application Title.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>eApp Owner Partner App - Cole Hoskins</fullName>
        <actions>
            <name>Assign_to_Cole</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Assign Partner apps to all east or all west reps</description>
        <formula>(ISPICKVAL(State__c, &apos;TN&apos;)|| 
ISPICKVAL(State__c,&apos;GA&apos;)|| 
ISPICKVAL(State__c,&apos;FL&apos;)|| 
ISPICKVAL(State__c,&apos;IN&apos;)|| 
ISPICKVAL(State__c,&apos;MI&apos;)|| 
ISPICKVAL(State__c,&apos;NY&apos;)|| 
ISPICKVAL(State__c,&apos;MA&apos;)|| 
ISPICKVAL(State__c,&apos;ME&apos;)||
ISPICKVAL(State__c,&apos;KY&apos;)|| 
ISPICKVAL(State__c,&apos;IL&apos;)||
ISPICKVAL(State__c,&apos;OH&apos;)|| 
ISPICKVAL(State__c,&apos;WI&apos;)||
ISPICKVAL(State__c,&apos;PA&apos;)|| 
ISPICKVAL(State__c,&apos;NJ&apos;)||
ISPICKVAL(State__c,&apos;CT&apos;)||
ISPICKVAL(State__c,&apos;VT&apos;)||
ISPICKVAL(State__c,&apos;AL&apos;)|| 
ISPICKVAL(State__c,&apos;SC&apos;)||
ISPICKVAL(State__c,&apos;NC&apos;)|| 
ISPICKVAL(State__c,&apos;VA&apos;)|| 
ISPICKVAL(State__c,&apos;WV&apos;)||
ISPICKVAL(State__c,&apos;MD&apos;)|| 
ISPICKVAL(State__c,&apos;DC&apos;)|| 
ISPICKVAL(State__c,&apos;DE&apos;)||
ISPICKVAL(State__c,&apos;RI&apos;)||
ISPICKVAL(State__c,&apos;NH&apos;)||
ISPICKVAL(State__c,&apos;MN&apos;)||
ISPICKVAL(State__c,&apos;IA&apos;)||
ISPICKVAL(State__c,&apos;SD&apos;)||
ISPICKVAL(State__c,&apos;OK&apos;)|| 
ISPICKVAL(State__c,&apos;AZ&apos;)|| 
ISPICKVAL(State__c,&apos;KS&apos;)|| 
ISPICKVAL(State__c,&apos;ID&apos;)|| 
ISPICKVAL(State__c,&apos;WY&apos;)|| 
ISPICKVAL(State__c,&apos;TX&apos;)|| 
ISPICKVAL(State__c,&apos;MO&apos;)|| 
ISPICKVAL(State__c,&apos;LA&apos;)|| 
ISPICKVAL(State__c,&apos;UT&apos;)|| 
ISPICKVAL(State__c,&apos;AR&apos;)|| 
ISPICKVAL(State__c,&apos;CO&apos;)|| 
ISPICKVAL(State__c,&apos;WA&apos;)|| 
ISPICKVAL(State__c,&apos;OR&apos;)|| 
ISPICKVAL(State__c,&apos;MS&apos;)|| 
ISPICKVAL(State__c,&apos;MT&apos;)|| 
ISPICKVAL(State__c,&apos;NM&apos;)|| 
ISPICKVAL(State__c,&apos;NV&apos;)|| 
ISPICKVAL(State__c,&apos;CA&apos;)|| 
ISPICKVAL(State__c,&apos;AK&apos;)|| 
ISPICKVAL(State__c,&apos;HI&apos;)|| 
ISPICKVAL(State__c,&apos;NE&apos;)||
ISPICKVAL(State__c,&apos;ND&apos;))
&amp;&amp; 
(CreatedById = &apos;00570000002S3Sl&apos;||
CreatedById = &apos;00570000003hCBt&apos;)
&amp;&amp;
(Offer__r.Name = &apos;C-Sunoco OTR DM 042016&apos;|| 
Offer__r.Name = &apos;Fuelbook Social 2016&apos;|| 
Offer__r.Name = &apos;BP Lab Services - OTR - Business Services Agreement&apos;||
Offer__r.Name = &apos;uShip OTR&apos;||
Offer__r.Name = &apos;PrePass - Package B&apos;||
Offer__r.Name = &apos;GE Capital OTR&apos;||
Offer__r.Name = &apos;UTA OTR BAA&apos; ||
Offer__r.Name = &apos;Idealease OTR&apos;||
Offer__r.Name = &apos;Truckers Advantage&apos;||
Offer__r.Name = &apos;AMSA Fleet Discount - Local&apos;||
Offer__r.Name = &apos;Fuelbook Card&apos;|| 
Offer__r.Name = &apos;AMSA - Fleet Discount Card&apos;||
Offer__r.Name = &apos;Sunoco OTR for Website&apos;|| 
Offer__r.Name = &apos;PrePass - Package A&apos;||
Offer__r.Name = &apos;C-Sunoco OTR 2016 EM #1&apos; ||
Offer__r.Name = &apos;C-Sunoco OTR 2016 EM #2&apos;||
Offer__r.Name = &apos;Fuelbook Select&apos;||
Offer__r.Name = &apos;Fuelbook B&apos;||
Offer__r.Name = &apos;Exxon Mobil NAD (OTR)&apos;||
Offer__r.Name = &apos;Pilot OTR Business Card Agreement&apos;||
Offer__r.Name = &apos;CTA - OTR&apos;||
Offer__r.Name = &apos;NAVL Fleet Card - Over the Road&apos;||
Offer__r.Name = &apos;Fleet One Over the Road Rigdig&apos;||
Offer__r.Name = &apos;FTI Benefits - Local - Business Services Agreement&apos;||
Offer__r.Name = &apos;Fleet Savings - OTR&apos;||
Offer__r.Name = &apos;TLC - OTR - Business Services Agreement&apos;||
Offer__r.Name = &apos;D&amp;S Fuel Card&apos;||
Offer__r.Name = &apos;Sinclair OTR&apos;)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>eApp Owner Partner App - Danielle</fullName>
        <actions>
            <name>Assign_to_Danielle</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>Assign Partner apps to all east or all west reps</description>
        <formula>(ISPICKVAL(State__c, &apos;TN&apos;)|| 
ISPICKVAL(State__c,&apos;GA&apos;)|| 
ISPICKVAL(State__c,&apos;FL&apos;)|| 
ISPICKVAL(State__c,&apos;IN&apos;)|| 
ISPICKVAL(State__c,&apos;MI&apos;)|| 
ISPICKVAL(State__c,&apos;NY&apos;)|| 
ISPICKVAL(State__c,&apos;MA&apos;)|| 
ISPICKVAL(State__c,&apos;ME&apos;)||
ISPICKVAL(State__c,&apos;KY&apos;)|| 
ISPICKVAL(State__c,&apos;IL&apos;)||
ISPICKVAL(State__c,&apos;OH&apos;)|| 
ISPICKVAL(State__c,&apos;WI&apos;)||
ISPICKVAL(State__c,&apos;PA&apos;)|| 
ISPICKVAL(State__c,&apos;NJ&apos;)||
ISPICKVAL(State__c,&apos;CT&apos;)||
ISPICKVAL(State__c,&apos;VT&apos;)||
ISPICKVAL(State__c,&apos;AL&apos;)|| 
ISPICKVAL(State__c,&apos;SC&apos;)||
ISPICKVAL(State__c,&apos;NC&apos;)|| 
ISPICKVAL(State__c,&apos;VA&apos;)|| 
ISPICKVAL(State__c,&apos;WV&apos;)||
ISPICKVAL(State__c,&apos;MD&apos;)|| 
ISPICKVAL(State__c,&apos;DC&apos;)|| 
ISPICKVAL(State__c,&apos;DE&apos;)||
ISPICKVAL(State__c,&apos;RI&apos;)||
ISPICKVAL(State__c,&apos;NH&apos;)||
ISPICKVAL(State__c,&apos;MN&apos;)||
ISPICKVAL(State__c,&apos;IA&apos;)||
ISPICKVAL(State__c,&apos;SD&apos;)||
ISPICKVAL(State__c,&apos;OK&apos;)|| 
ISPICKVAL(State__c,&apos;AZ&apos;)|| 
ISPICKVAL(State__c,&apos;KS&apos;)|| 
ISPICKVAL(State__c,&apos;ID&apos;)|| 
ISPICKVAL(State__c,&apos;WY&apos;)|| 
ISPICKVAL(State__c,&apos;TX&apos;)|| 
ISPICKVAL(State__c,&apos;MO&apos;)|| 
ISPICKVAL(State__c,&apos;LA&apos;)|| 
ISPICKVAL(State__c,&apos;UT&apos;)|| 
ISPICKVAL(State__c,&apos;AR&apos;)|| 
ISPICKVAL(State__c,&apos;CO&apos;)|| 
ISPICKVAL(State__c,&apos;WA&apos;)|| 
ISPICKVAL(State__c,&apos;OR&apos;)|| 
ISPICKVAL(State__c,&apos;MS&apos;)|| 
ISPICKVAL(State__c,&apos;MT&apos;)|| 
ISPICKVAL(State__c,&apos;NM&apos;)|| 
ISPICKVAL(State__c,&apos;NV&apos;)|| 
ISPICKVAL(State__c,&apos;CA&apos;)|| 
ISPICKVAL(State__c,&apos;AK&apos;)|| 
ISPICKVAL(State__c,&apos;HI&apos;)|| 
ISPICKVAL(State__c,&apos;NE&apos;)||
ISPICKVAL(State__c,&apos;ND&apos;))
&amp;&amp; 
(CreatedById = &apos;00570000002S3Sl&apos;) &amp;&amp;
(Offer__r.Name = &apos;C-Sunoco OTR DM 042016&apos;|| 
Offer__r.Name = &apos;Fuelbook Social 2016&apos;|| 
Offer__r.Name = &apos;BP Lab Services - OTR - Business Services Agreement&apos;||
Offer__r.Name = &apos;uShip OTR&apos;||
Offer__r.Name = &apos;PrePass - Package B&apos;||
Offer__r.Name = &apos;GE Capital OTR&apos;||
Offer__r.Name = &apos;UTA OTR BAA&apos; ||
Offer__r.Name = &apos;Idealease OTR&apos;||
Offer__r.Name = &apos;Truckers Advantage&apos;||
Offer__r.Name = &apos;AMSA Fleet Discount - Local&apos;||
Offer__r.Name = &apos;Fuelbook Card&apos;|| 
Offer__r.Name = &apos;AMSA - Fleet Discount Card&apos;||
Offer__r.Name = &apos;Sunoco OTR for Website&apos;|| 
Offer__r.Name = &apos;PrePass - Package A&apos;||
Offer__r.Name = &apos;C-Sunoco OTR 2016 EM #1&apos; ||
Offer__r.Name = &apos;C-Sunoco OTR 2016 EM #2&apos;||
Offer__r.Name = &apos;Fuelbook Select&apos;||
Offer__r.Name = &apos;Fuelbook B&apos;||
Offer__r.Name = &apos;Exxon Mobil NAD (OTR)&apos;||
Offer__r.Name = &apos;Pilot OTR Business Card Agreement&apos;||
Offer__r.Name = &apos;CTA - OTR&apos;||
Offer__r.Name = &apos;NAVL Fleet Card - Over the Road&apos;||
Offer__r.Name = &apos;Fleet One Over the Road Rigdig&apos;||
Offer__r.Name = &apos;FTI Benefits - Local - Business Services Agreement&apos;||
Offer__r.Name = &apos;Discount Diesel&apos;||
Offer__r.Name = &apos;Knight Logistics&apos;||
Offer__r.Name = &apos;Fleet Savings - OTR&apos;||
Offer__r.Name = &apos;TLC - OTR - Business Services Agreement&apos;||
Offer__r.Name = &apos;D&amp;S Fuel Card&apos;||
Offer__r.Name = &apos;Sinclair OTR&apos;)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>eApp Owner Partner App - Joni</fullName>
        <actions>
            <name>Assign_to_Joni</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>Assign Partner apps to all east or all west reps</description>
        <formula>(ISPICKVAL(State__c, &apos;OK&apos;)|| 
ISPICKVAL(State__c,&apos;AZ&apos;)||
ISPICKVAL(State__c,&apos;KS&apos;)||
ISPICKVAL(State__c,&apos;ID&apos;)||
ISPICKVAL(State__c,&apos;WY&apos;)||
ISPICKVAL(State__c,&apos;TX&apos;)||
ISPICKVAL(State__c,&apos;MO&apos;)||
ISPICKVAL(State__c,&apos;LA&apos;)||
ISPICKVAL(State__c,&apos;UT&apos;)||
ISPICKVAL(State__c,&apos;AR&apos;)|| 
ISPICKVAL(State__c,&apos;CO&apos;)||
ISPICKVAL(State__c,&apos;WA&apos;)||
ISPICKVAL(State__c,&apos;OR&apos;)||
ISPICKVAL(State__c,&apos;MS&apos;)|| 
ISPICKVAL(State__c,&apos;MT&apos;)|| 
ISPICKVAL(State__c,&apos;NM&apos;)||
ISPICKVAL(State__c,&apos;NV&apos;)||
ISPICKVAL(State__c,&apos;CA&apos;)|| 
ISPICKVAL(State__c,&apos;AK&apos;)||
ISPICKVAL(State__c,&apos;HI&apos;)) 
&amp;&amp; 
(CreatedById = &apos;00570000002S3Sl&apos;) &amp;&amp;
(Offer__r.Name = &apos;C-Sunoco OTR DM 042016&apos;|| 
Offer__r.Name = &apos;Fuelbook Social 2016&apos;|| 
Offer__r.Name = &apos;BP Lab Services - OTR - Business Services Agreement&apos;||
Offer__r.Name = &apos;uShip OTR&apos;||
Offer__r.Name = &apos;PrePass - Package B&apos;||
Offer__r.Name = &apos;GE Capital OTR&apos;||
Offer__r.Name = &apos;UTA OTR BAA&apos; ||
Offer__r.Name = &apos;Idealease OTR&apos;||
Offer__r.Name = &apos;Truckers Advantage&apos;||
Offer__r.Name = &apos;AMSA Fleet Discount - Local&apos;||
Offer__r.Name = &apos;Fuelbook Card&apos;|| 
Offer__r.Name = &apos;AMSA - Fleet Discount Card&apos;||
Offer__r.Name = &apos;Sunoco OTR for Website&apos;|| 
Offer__r.Name = &apos;PrePass - Package A&apos;||
Offer__r.Name = &apos;C-Sunoco OTR 2016 EM #1&apos; ||
Offer__r.Name = &apos;C-Sunoco OTR 2016 EM #2&apos;||
Offer__r.Name = &apos;Fuelbook Select&apos;||
Offer__r.Name = &apos;Fuelbook B&apos;||
Offer__r.Name = &apos;Exxon Mobil NAD (OTR)&apos;||
Offer__r.Name = &apos;Pilot OTR Business Card Agreement&apos;||
Offer__r.Name = &apos;NAVL Fleet Card - Over the Road&apos;||
Offer__r.Name = &apos;Fleet One Over the Road Rigdig&apos;||
Offer__r.Name = &apos;FTI Benefits - Local - Business Services Agreement&apos;||
Offer__r.Name = &apos;CTA - OTR&apos;||
Offer__r.Name = &apos;Knight Logistics&apos;||
Offer__r.Name = &apos;Discount Diesel&apos;||
Offer__r.Name = &apos;Fleet Savings - OTR&apos;||
Offer__r.Name = &apos;D&amp;S Fuel Card&apos;||
Offer__r.Name = &apos;TLC - OTR - Business Services Agreement&apos;||
Offer__r.Name = &apos;Sinclair OTR&apos;)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>set In Progress user</fullName>
        <actions>
            <name>set_In_Progress_user</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>OnlineApplication__c.In_Progress__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
