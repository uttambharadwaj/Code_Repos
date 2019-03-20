<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Contact_voice_mail_follow_up_email</fullName>
        <description>Contact: voice mail follow up email</description>
        <protected>false</protected>
        <recipients>
            <field>Email</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Sales_and_Marketing/Voicemail_Follow_Up_Message_1</template>
    </alerts>
    <alerts>
        <fullName>New_Pardot_Activity_Notification_Contact</fullName>
        <description>New Pardot Activity Notification - Contact</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Virtual_EU_Templates/CorporatePay_Prospect_Activity_Alert_Contact</template>
    </alerts>
    <fieldUpdates>
        <fullName>Contact_FaxViaEmail</fullName>
        <description>This will set the email address to fax via an email sent to autofax.truckersb2b.com</description>
        <field>Email</field>
        <formula>SUBSTITUTE(SUBSTITUTE(SUBSTITUTE(SUBSTITUTE(Fax, &quot;(&quot;, &quot;&quot;), &quot;)&quot;, &quot;&quot;), &quot; &quot;, &quot;&quot;), &quot;-&quot;, &quot;&quot;) &amp; &quot;@api.westfax.com&quot;</formula>
        <name>Contact:FaxViaEmail</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Contact_Not_Created_From_Lead_Convert</fullName>
        <description>Contact has not been created from Lead convert, as Contact already exists. Overwrite value populated by field mapping</description>
        <field>Created_From_Lead_Convert__c</field>
        <literalValue>0</literalValue>
        <name>Contact Not Created From Lead Convert</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Has_started_pumping_true</fullName>
        <field>Has_started_pumping__c</field>
        <literalValue>1</literalValue>
        <name>set Has Started Pumping to TRUE</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Next_Contact_Blank</fullName>
        <field>Next_Contact__c</field>
        <name>Next Contact = Blank</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Next_Contact_Today</fullName>
        <field>Next_Contact__c</field>
        <formula>Today()</formula>
        <name>Next Contact - Today</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_3rd_call</fullName>
        <field>Call_Stage__c</field>
        <literalValue>3rd Call</literalValue>
        <name>Update 3rd call</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_4th_Call</fullName>
        <field>Call_Stage__c</field>
        <literalValue>4th Call</literalValue>
        <name>Update 4th Call</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_5th_Call</fullName>
        <field>Call_Stage__c</field>
        <literalValue>5th Call</literalValue>
        <name>Update 5th Call</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Call_Cycle_2</fullName>
        <field>Call_Stage__c</field>
        <literalValue>2nd Call</literalValue>
        <name>Update Call Cycle 2</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Call_Stage_6</fullName>
        <field>Call_Stage__c</field>
        <literalValue>6th Call</literalValue>
        <name>Update Call Stage 6</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Call_Stage_Null</fullName>
        <field>Call_Stage__c</field>
        <name>Update Call Stage: Null</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Last_Contact</fullName>
        <field>Last_Contact__c</field>
        <formula>Today()</formula>
        <name>Update Last Contact</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Last_Contact_c</fullName>
        <field>Last_Contact__c</field>
        <formula>Today()</formula>
        <name>Update Last Contact</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Next_Contact_7_days</fullName>
        <field>Next_Contact__c</field>
        <formula>Last_Contact__c +7</formula>
        <name>Update Next Contact +7 days</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Outcome</fullName>
        <field>Call_Outcome__c</field>
        <name>Update Outcome</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Act On Contact Activity</fullName>
        <actions>
            <name>Follow_Up_Call_After_Email_Campaign_Action</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Contact.Act_On_Behavior_Score__c</field>
            <operation>greaterOrEqual</operation>
            <value>150</value>
        </criteriaItems>
        <description>If Act On Behavior Score reaches 150&gt;= then create an open task for the sales person to contact the record.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Contact 1st Call Stage</fullName>
        <actions>
            <name>Next_Contact_Today</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Place_1st_Call</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Contact.Call_Stage__c</field>
            <operation>equals</operation>
            <value>1st Call</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.Call_Outcome__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <description>Creates tasks and updates contact qualification process</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Contact 2nd Call Stage</fullName>
        <actions>
            <name>Update_Call_Cycle_2</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Last_Contact</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Next_Contact_7_days</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Outcome</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Place_2nd_Call</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Contact.Call_Stage__c</field>
            <operation>equals</operation>
            <value>1st Call</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.Call_Outcome__c</field>
            <operation>startsWith</operation>
            <value>No Answer,Left Voicemail (F/U Task &amp; EM)</value>
        </criteriaItems>
        <description>Creates tasks and updates to begin contact qualification process</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Contact 3rd Call Stage</fullName>
        <actions>
            <name>Update_3rd_call</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Last_Contact</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Next_Contact_7_days</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Outcome</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Place_3rd_Call</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Contact.Call_Stage__c</field>
            <operation>equals</operation>
            <value>2nd Call</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.Call_Outcome__c</field>
            <operation>startsWith</operation>
            <value>No Answer,Left Voicemail (F/U Task &amp; EM)</value>
        </criteriaItems>
        <description>Creates tasks and updates contact qualification process</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Contact 4th Call Stage</fullName>
        <actions>
            <name>Update_4th_Call</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Last_Contact</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Next_Contact_7_days</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Outcome</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Place_4th_Call</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Contact.Call_Stage__c</field>
            <operation>equals</operation>
            <value>3rd Call</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.Call_Outcome__c</field>
            <operation>startsWith</operation>
            <value>No Answer,Left Voicemail (F/U Task &amp; EM)</value>
        </criteriaItems>
        <description>Creates tasks and updates contact qualification process</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Contact 5th Call Stage</fullName>
        <actions>
            <name>Update_5th_Call</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Last_Contact</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Next_Contact_7_days</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Outcome</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Place_5th_Call</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Contact.Call_Stage__c</field>
            <operation>equals</operation>
            <value>4th Call</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.Call_Outcome__c</field>
            <operation>startsWith</operation>
            <value>No Answer,Left Voicemail (F/U Task &amp; EM)</value>
        </criteriaItems>
        <description>Creates tasks and updates contact qualification process</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Contact 6th Call Stage</fullName>
        <actions>
            <name>Update_Call_Stage_6</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Last_Contact</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Next_Contact_7_days</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Outcome</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Place_6th_Call</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Contact.Call_Stage__c</field>
            <operation>equals</operation>
            <value>5th Call</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.Call_Outcome__c</field>
            <operation>startsWith</operation>
            <value>No Answer,Left Voicemail (F/U Task &amp; EM)</value>
        </criteriaItems>
        <description>Creates tasks and updates contact qualification process</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Contact Email After VM</fullName>
        <actions>
            <name>Contact_voice_mail_follow_up_email</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Contact.Call_Outcome__c</field>
            <operation>equals</operation>
            <value>Left Voicemail (F/U Task &amp; EM)</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.HasOptedOutOfEmail</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <description>Auto sends an intro email when Call Outcome = Left Voicemail (F/U Task &amp; EM)</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Contact End Call Stages</fullName>
        <actions>
            <name>Update_Call_Stage_Null</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Last_Contact</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Outcome</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Contact.Call_Stage__c</field>
            <operation>equals</operation>
            <value>6th Call</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.Call_Outcome__c</field>
            <operation>startsWith</operation>
            <value>No Answer,Left Voicemail (F/U Task &amp; EM)</value>
        </criteriaItems>
        <description>On the 6th call, if there&apos;s still no answer or VM is reached, set the Call Stage back to blank.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Contact Populate 18 digit ID</fullName>
        <active>true</active>
        <formula>True</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Contact Reached Decision Maker</fullName>
        <actions>
            <name>Next_Contact_Blank</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Last_Contact_c</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Contact.Call_Outcome__c</field>
            <operation>startsWith</operation>
            <value>Reached Decisionmaker</value>
        </criteriaItems>
        <description>Updates Last Contact date and deletes Next Contact date when Call Outcome = Reached Decision Maker.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Contact%3A Fax No Email</fullName>
        <actions>
            <name>Contact_FaxViaEmail</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Contact.RecordTypeId</field>
            <operation>equals</operation>
            <value>Truckers - Contacts</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.Email</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.Fax</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>A contact has a fax number, but no email address from Truckers</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Contact%3A Referred and Started Pumping</fullName>
        <actions>
            <name>Has_started_pumping_true</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Contact.Is_this_contacted_referred__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Gallons_YTD__c</field>
            <operation>greaterThan</operation>
            <value>0</value>
        </criteriaItems>
        <description>If Account has Gallons  and Contact is referred then set Is Pumping field.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Lead Converted - After Contact Creation</fullName>
        <actions>
            <name>Contact_Not_Created_From_Lead_Convert</name>
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
        <fullName>New Pardot Activity</fullName>
        <actions>
            <name>New_Pardot_Activity_Notification_Contact</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>AND(
  /* CorporatePay */
  RecordTypeId = &apos;012700000005qh5&apos;,

  /* Contact owner still at the business */
  Owner.IsActive = TRUE,

  /*
  Contact owner is not an RM (to prevent notifications being sent whenever a customer visits the website to login to the portal
  */
  NOT(Owner.UserRole.DeveloperName = &apos;CorporatePay_Relationship_Manager&apos;),

  /* new Pardot activity */
  ISCHANGED(pi__last_activity__c),

  /* prevent multiple notifications from being sent on the same day */
  NOT(DATEVALUE(PRIORVALUE(pi__last_activity__c)) = TODAY())
)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update Last Contact</fullName>
        <actions>
            <name>Update_Last_Contact_c</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Contact.Call_Outcome__c</field>
            <operation>startsWith</operation>
            <value>No Answer,Left Voicemail (F/U Task &amp; EM)</value>
        </criteriaItems>
        <description>Updates last contact when user inputs the outcome of the existing call attempt.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <tasks>
        <fullName>Follow_Up_Call_After_Email_Campaign_Action</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>1</dueDateOffset>
        <notifyAssignee>true</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Follow Up Call After Email Campaign Action</subject>
    </tasks>
    <tasks>
        <fullName>Place_1st_Call</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Place 1st Call</subject>
    </tasks>
    <tasks>
        <fullName>Place_2nd_Call</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>7</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Place 2nd Call</subject>
    </tasks>
    <tasks>
        <fullName>Place_3rd_Call</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>7</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Place 3rd Call</subject>
    </tasks>
    <tasks>
        <fullName>Place_3rd_Call_c</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>7</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Place 3rd Call</subject>
    </tasks>
    <tasks>
        <fullName>Place_4th_Call</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>7</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Place 4th Call</subject>
    </tasks>
    <tasks>
        <fullName>Place_5th_Call</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>7</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Place 5th Call</subject>
    </tasks>
    <tasks>
        <fullName>Place_6th_Call</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>7</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Place 6th Call</subject>
    </tasks>
</Workflow>
