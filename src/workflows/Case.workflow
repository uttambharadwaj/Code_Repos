<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Implementation_Case_Closed</fullName>
        <description>Implementation Case Closed</description>
        <protected>false</protected>
        <recipients>
            <recipient>Opportunity Owner</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Implementation_Case_Closed_Cards</template>
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
</Workflow>
