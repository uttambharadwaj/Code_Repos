<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>AU_Opportunity_Pricing_Approval</fullName>
        <description>AU Opportunity Pricing Approved</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>AU_Email_Templates/AU_Fuel_Application_Pricing_Approved</template>
    </alerts>
    <alerts>
        <fullName>AU_Opportunity_Pricing_Rejected</fullName>
        <description>AU Opportunity Pricing Rejected</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>AU_Email_Templates/AU_Fuel_Application_Pricing_Rejected</template>
    </alerts>
    <alerts>
        <fullName>After_App_Request_76_successful_email_App_Signer_with_Data_Form</fullName>
        <description>After App Request 76 is successful, email App Signer with Data Form</description>
        <protected>false</protected>
        <recipients>
            <field>Application_Signer__c</field>
            <type>contactLookup</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>noreply@wexinc.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Inside_Sales/IS_76_App_Received</template>
    </alerts>
    <alerts>
        <fullName>After_App_Request_7Eleven_successful_email_App_Signer_with_Data_Form</fullName>
        <description>After App Request 7-Eleven is successful, email App Signer with Data Form</description>
        <protected>false</protected>
        <recipients>
            <field>Application_Signer__c</field>
            <type>contactLookup</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>noreply@wexinc.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Inside_Sales/X7_Eleven_App_Recieved</template>
    </alerts>
    <alerts>
        <fullName>After_App_Request_CITGO</fullName>
        <description>After App Request CITGO is successful, email App Signer with Data Form</description>
        <protected>false</protected>
        <recipients>
            <field>Application_Signer__c</field>
            <type>contactLookup</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>noreply@wexinc.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Inside_Sales/CITGO_App_Received</template>
    </alerts>
    <alerts>
        <fullName>After_App_Request_CircleK_successful_email_App_Signer_with_Data_Form</fullName>
        <description>After App Request Circle K is successful, email App Signer with Data Form</description>
        <protected>false</protected>
        <recipients>
            <field>Application_Signer__c</field>
            <type>contactLookup</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>noreply@wexinc.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Inside_Sales/Circle_K_App_Received</template>
    </alerts>
    <alerts>
        <fullName>After_App_Request_Conoco_successful_email_App_Signer_with_Data_Form</fullName>
        <description>After App Request Conoco is successful, email App Signer with Data Form</description>
        <protected>false</protected>
        <recipients>
            <field>Application_Signer__c</field>
            <type>contactLookup</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>noreply@wexinc.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Inside_Sales/Conoco_App_Received</template>
    </alerts>
    <alerts>
        <fullName>After_App_Request_Conoco_successful_email_App_Signer_with_Data_Form_Excel</fullName>
        <description>After App Request Conoco is successful, email App Signer with Data Form (Excel)</description>
        <protected>false</protected>
        <recipients>
            <field>Application_Signer__c</field>
            <type>contactLookup</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>noreply@wexinc.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Conoco/Conoco_App_Received2</template>
    </alerts>
    <alerts>
        <fullName>After_App_Request_Ent_Truck_Rental_Tribrand_successful_email_App_Signer_with_Dat</fullName>
        <description>After App Request Enterprise Truck Rental Tribrand is successful, email App Signer with Data Form</description>
        <protected>false</protected>
        <recipients>
            <field>Application_Signer__c</field>
            <type>contactLookup</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>no-reply.enterprisefleetmanagement@fleetservicesonline.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Inside_Sales/Enterprise_Truck_Rental_App_Request_Successful</template>
    </alerts>
    <alerts>
        <fullName>After_App_Request_Enterprise_successful_email_App_Signer_with_Data_Form2</fullName>
        <description>After App Request Enterprise Fleet is successful, email App Signer with Data Form</description>
        <protected>false</protected>
        <recipients>
            <field>Application_Signer__c</field>
            <type>contactLookup</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>noreply@wexinc.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Inside_Sales/Enterprise_App_Request_Successful</template>
    </alerts>
    <alerts>
        <fullName>After_App_Request_ExxonMobil</fullName>
        <description>After App Request ExxonMobil Fleet Natl is successful, email App Signer with Data Form</description>
        <protected>false</protected>
        <recipients>
            <field>Application_Signer__c</field>
            <type>contactLookup</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>noreply@wexinc.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Inside_Sales/ExxonMobil_FN_App_Received</template>
    </alerts>
    <alerts>
        <fullName>After_App_Request_ExxonMobil_BizUnite</fullName>
        <description>After App Request ExxonMobil BizUnite is successful, email App Signer with Data Form</description>
        <protected>false</protected>
        <recipients>
            <field>Application_Signer__c</field>
            <type>contactLookup</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>noreply@wexinc.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Inside_Sales/ExxonMobil_BizUnite_App_Received</template>
    </alerts>
    <alerts>
        <fullName>After_App_Request_ExxonMobil_biz</fullName>
        <description>After App Request ExxonMobil Business Fleet is successful, email App Signer with Data Form</description>
        <protected>false</protected>
        <recipients>
            <field>Application_Signer__c</field>
            <type>contactLookup</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>noreply@wexinc.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Inside_Sales/ExxonMobil_Biz_App_Received</template>
    </alerts>
    <alerts>
        <fullName>After_App_Request_GetGo_successful_email_App_Signer_with_Data_Form</fullName>
        <description>After App Request GetGo is successful, email App Signer with Data Form</description>
        <protected>false</protected>
        <recipients>
            <field>Application_Signer__c</field>
            <type>contactLookup</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>noreply@wexinc.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Inside_Sales/GetGo_App_Received</template>
    </alerts>
    <alerts>
        <fullName>After_App_Request_Gulf</fullName>
        <description>After App Request Gulf is successful, email App Signer with Data Form</description>
        <protected>false</protected>
        <recipients>
            <field>Application_Signer__c</field>
            <type>contactLookup</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>noreply@wexinc.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Inside_Sales/Gulf_App_Received</template>
    </alerts>
    <alerts>
        <fullName>After_App_Request_KumGo</fullName>
        <description>After App Request Kum &amp; Go is successful, email App Signer with Data Form</description>
        <protected>false</protected>
        <recipients>
            <field>Application_Signer__c</field>
            <type>contactLookup</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>noreply@wexinc.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Inside_Sales/Kum_Go_App_Received</template>
    </alerts>
    <alerts>
        <fullName>After_App_Request_LukOil_successful_email_App_Signer_with_Data_Form</fullName>
        <description>After App Request LukOil is successful, email App Signer with Data Form</description>
        <protected>false</protected>
        <recipients>
            <field>Application_Signer__c</field>
            <type>contactLookup</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>noreply@wexinc.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Inside_Sales/LukOil_App_Received</template>
    </alerts>
    <alerts>
        <fullName>After_App_Request_Mapco_successful_email_App_Signer_with_Data_Form</fullName>
        <description>After App Request Mapco is successful, email App Signer with Data Form</description>
        <protected>false</protected>
        <recipients>
            <field>Application_Signer__c</field>
            <type>contactLookup</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>noreply@wexinc.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Inside_Sales/Mapco_App_Received</template>
    </alerts>
    <alerts>
        <fullName>After_App_Request_Marathon</fullName>
        <description>After App Request Marathon is successful, email App Signer with Data Form</description>
        <protected>false</protected>
        <recipients>
            <field>Application_Signer__c</field>
            <type>contactLookup</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>noreply@wexinc.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Inside_Sales/Marathon_App_Received</template>
    </alerts>
    <alerts>
        <fullName>After_App_Request_Meijer_successful_email_App_Signer_with_Data_Form</fullName>
        <description>After App Request Meijer is successful, email App Signer with Data Form</description>
        <protected>false</protected>
        <recipients>
            <field>Application_Signer__c</field>
            <type>contactLookup</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>noreply@wexinc.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Inside_Sales/Meijer_App_Received</template>
    </alerts>
    <alerts>
        <fullName>After_App_Request_Murphy</fullName>
        <description>After App Request Murphy is successful, email App Signer with Data Form</description>
        <protected>false</protected>
        <recipients>
            <field>Application_Signer__c</field>
            <type>contactLookup</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>noreply@wexinc.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Inside_Sales/Murphy_App_received</template>
    </alerts>
    <alerts>
        <fullName>After_App_Request_P66_BizUnite</fullName>
        <description>After App Request P66 BizUnite is successful, email App Signer with Data Form</description>
        <protected>false</protected>
        <recipients>
            <field>Application_Signer__c</field>
            <type>contactLookup</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>noreply@wexinc.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Inside_Sales/P66_BizUnite_NFIB_App_Received</template>
    </alerts>
    <alerts>
        <fullName>After_App_Request_P66_NFIB</fullName>
        <description>After App Request P66 NFIB is successful, email App Signer with Data Form</description>
        <protected>false</protected>
        <recipients>
            <field>Application_Signer__c</field>
            <type>contactLookup</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>noreply@wexinc.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Inside_Sales/P66_BizUnite_NFIB_App_Received</template>
    </alerts>
    <alerts>
        <fullName>After_App_Request_Phillips66_successful_email_App_Signer_with_Data_Form</fullName>
        <description>After App Request Phillips 66 is successful, email App Signer with Data Form</description>
        <protected>false</protected>
        <recipients>
            <field>Application_Signer__c</field>
            <type>contactLookup</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>noreply@wexinc.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Inside_Sales/Phillips_66_App_Received</template>
    </alerts>
    <alerts>
        <fullName>After_App_Request_QuikTrip</fullName>
        <description>After App Request QuikTrip is successful, email App Signer with Data Form</description>
        <protected>false</protected>
        <recipients>
            <field>Application_Signer__c</field>
            <type>contactLookup</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>noreply@wexinc.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Inside_Sales/QuikTrip_App_Received</template>
    </alerts>
    <alerts>
        <fullName>After_App_Request_RaceTrac</fullName>
        <description>After App Request RaceTrac is successful, email App Signer with Data Form</description>
        <protected>false</protected>
        <recipients>
            <field>Application_Signer__c</field>
            <type>contactLookup</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>noreply@wexinc.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Inside_Sales/RaceTrac_App_Received</template>
    </alerts>
    <alerts>
        <fullName>After_App_Request_Royal_Farms</fullName>
        <description>After App Request Royal Farms is successful, email App Signer with Data Form</description>
        <protected>false</protected>
        <recipients>
            <field>Application_Signer__c</field>
            <type>contactLookup</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>noreply@wexinc.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Inside_Sales/Royal_Farms_App_Recieved</template>
    </alerts>
    <alerts>
        <fullName>After_App_Request_Sheetz</fullName>
        <description>After App Request Sheetz is successful, email App Signer with Data Form</description>
        <protected>false</protected>
        <recipients>
            <field>Application_Signer__c</field>
            <type>contactLookup</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>noreply@wexinc.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Inside_Sales/Sheetz_App_Received</template>
    </alerts>
    <alerts>
        <fullName>After_App_Request_Stripes</fullName>
        <description>After App Request Stripes is successful, email App Signer with Data Form</description>
        <protected>false</protected>
        <recipients>
            <field>Application_Signer__c</field>
            <type>contactLookup</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Inside_Sales/Stripes_App_Received</template>
    </alerts>
    <alerts>
        <fullName>After_App_Request_Sunoco_successful_email_App_Signer_with_Data_Form</fullName>
        <description>After App Request Sunoco/Suntrak is successful, email App Signer with Data Form</description>
        <protected>false</protected>
        <recipients>
            <field>Application_Signer__c</field>
            <type>contactLookup</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>noreply@wexinc.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Inside_Sales/Sunoco_App_Received</template>
    </alerts>
    <alerts>
        <fullName>After_App_Request_Tesoro_successful_email_App_Signer_with_Data_Form</fullName>
        <description>After App Request Tesoro is successful, email App Signer with Data Form</description>
        <protected>false</protected>
        <recipients>
            <field>Application_Signer__c</field>
            <type>contactLookup</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>noreply@wexinc.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Inside_Sales/Tesoro_App_Received</template>
    </alerts>
    <alerts>
        <fullName>After_App_Request_WEX_STARTER_is_successful_email_App_Signer_with_Data_Form</fullName>
        <description>After App Request WEX Starter is successful, email App Signer with Data Form</description>
        <protected>false</protected>
        <recipients>
            <field>Application_Signer__c</field>
            <type>contactLookup</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>noreply@wexinc.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Inside_Sales/IS_App_Received_Fleet_Data_Form</template>
    </alerts>
    <alerts>
        <fullName>After_App_Request_WEX_STARTER_is_successful_email_App_Signer_with_Data_Form_Exce</fullName>
        <description>After App Request WEX Starter is successful, email App Signer with Data Form (Excel)</description>
        <protected>false</protected>
        <recipients>
            <field>Application_Signer__c</field>
            <type>contactLookup</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>noreply@wexinc.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Inside_Sales/IS_App_Received_Fleet_Data_Form_Excel</template>
    </alerts>
    <alerts>
        <fullName>After_App_Request_WEX_Universal_is_successful_email_App_Signer_with_Data_Form</fullName>
        <description>After App Request WEX Univeral is successful, email App Signer with Data Form (Excel)</description>
        <protected>false</protected>
        <recipients>
            <field>Application_Signer__c</field>
            <type>contactLookup</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>noreply@wexinc.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Inside_Sales/IS_App_Received_Fleet_Data_Form_Excel</template>
    </alerts>
    <alerts>
        <fullName>After_App_Request_Wawa</fullName>
        <description>After App Request Wawa is successful, email App Signer with Data Form</description>
        <protected>false</protected>
        <recipients>
            <field>Application_Signer__c</field>
            <type>contactLookup</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>noreply@wexinc.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Inside_Sales/Wawa_App_Received</template>
    </alerts>
    <alerts>
        <fullName>After_App_Request_is_successful_email_App_Signer_with_Data_Form</fullName>
        <description>After App Request WEX Univeral is successful, email App Signer with Data Form</description>
        <protected>false</protected>
        <recipients>
            <field>Application_Signer__c</field>
            <type>contactLookup</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>noreply@wexinc.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Inside_Sales/IS_App_Received_Fleet_Data_Form</template>
    </alerts>
    <alerts>
        <fullName>After_App_Request_is_successful_email_App_Signer_with_Data_Form2</fullName>
        <description>After App Request Wright Express Universal is successful, email App Signer with Data Form</description>
        <protected>false</protected>
        <recipients>
            <field>Application_Signer__c</field>
            <type>contactLookup</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>noreply@wexinc.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Inside_Sales/IS_App_Received_Fleet_Data_Form</template>
    </alerts>
    <alerts>
        <fullName>After_App_Request_is_successful_email_App_Signer_with_Data_Form3</fullName>
        <description>After App Request WEX BizUnite is successful, email App Signer with Data Form</description>
        <protected>false</protected>
        <recipients>
            <field>Application_Signer__c</field>
            <type>contactLookup</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>noreply@wexinc.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Inside_Sales/IS_App_Received_Fleet_Data_Form</template>
    </alerts>
    <alerts>
        <fullName>After_App_Request_is_successful_email_App_Signer_with_Data_Form_Excel</fullName>
        <description>After App Request Wright Express Universal is successful, email App Signer with Data Form (Excel)</description>
        <protected>false</protected>
        <recipients>
            <field>Application_Signer__c</field>
            <type>contactLookup</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>noreply@wexinc.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Inside_Sales/IS_App_Received_Fleet_Data_Form_Excel</template>
    </alerts>
    <alerts>
        <fullName>After_Holiday_App_Request_is_successful_email_App_Signer_with_Data_Form</fullName>
        <description>After App Request Holiday Univeral is successful, email App Signer with Data Form</description>
        <protected>false</protected>
        <recipients>
            <field>Application_Signer__c</field>
            <type>contactLookup</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>noreply@wexinc.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Inside_Sales/Holiday_Application_Received</template>
    </alerts>
    <alerts>
        <fullName>After_WEX_BizUnite_App_Request_is_successful_email_App_Signer_with_Data_Form_Exc</fullName>
        <description>After App Request WEX BizUnite is successful, email App Signer with Data Form (Excel)</description>
        <protected>false</protected>
        <recipients>
            <field>Application_Signer__c</field>
            <type>contactLookup</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>noreply@wexinc.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Inside_Sales/IS_App_Received_Fleet_Data_Form_Excel</template>
    </alerts>
    <alerts>
        <fullName>Community_Notify_partner_community_user_that_lead_has_been_converted_to_oppty</fullName>
        <description>Community: Notify partner community user that lead has been converted to oppty</description>
        <protected>false</protected>
        <recipients>
            <field>External_Referred_By__c</field>
            <type>contactLookup</type>
        </recipients>
        <senderAddress>noreply@wexinc.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>WEX_Partner_Community_Templates/Communities_Lead_Converted_Notification</template>
    </alerts>
    <alerts>
        <fullName>Corporate_Payments_Opportunity_Stage_4_EU_Team</fullName>
        <description>Corporate Payments Opportunity Stage 4 - EU Team</description>
        <protected>false</protected>
        <recipients>
            <recipient>bonnie.macarthur@wexeurope.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>clare.murphy@wexeurope.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>clinton.vormawah@wexeurope.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>daniele.caneschi@wexeurope.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>hubertus.aps@wexinc.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>justin.waters@wexeurope.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>maria.brzozowska@wexeurope.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>paul.batchelor@wexeurope.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>spyridon.papadakis@wexeurope.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>stephen.poynton@wexeurope.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>sunita.atwal@wexeurope.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Corporate_Payments_Templates/Corporate_Payments_Opportunity_Stage_4</template>
    </alerts>
    <alerts>
        <fullName>Corporate_Payments_Opportunity_Stage_4_NA_Implementation_Team</fullName>
        <description>Corporate Payments Opportunity Stage 4 - NA Implementation Team</description>
        <protected>false</protected>
        <recipients>
            <recipient>jessica.cook@wexinc.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>molly.steele@wexinc.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>timothy.bruce@wexinc.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Corporate_Payments_Templates/Corporate_Payments_Opportunity_Stage_4</template>
    </alerts>
    <alerts>
        <fullName>Corporate_Payments_Opportunity_Stage_4_NA_Onboarding_Team</fullName>
        <description>Corporate Payments Opportunity Stage 4 - NA Onboarding Team</description>
        <protected>false</protected>
        <recipients>
            <recipient>melinda.gauthier@wexinc.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Corporate_Payments_Templates/Corporate_Payments_Opportunity_Stage_4</template>
    </alerts>
    <alerts>
        <fullName>Corporate_Payments_Opportunity_Stage_4_NA_Team</fullName>
        <description>Corporate Payments Opportunity Stage 4 - NA Team</description>
        <protected>false</protected>
        <recipients>
            <recipient>james.peterson@wexinc.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Corporate_Payments_Templates/Corporate_Payments_Opportunity_Stage_4</template>
    </alerts>
    <alerts>
        <fullName>Corporate_Payments_Opportunity_Stage_4_Onboarding_Notification</fullName>
        <description>Corporate Payments Opportunity Stage 4 - Onboarding Notification</description>
        <protected>false</protected>
        <recipients>
            <recipient>Corporate_Payments_Account_Management_Leadership</recipient>
            <type>role</type>
        </recipients>
        <recipients>
            <recipient>justin.waters@wexeurope.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>melinda.gauthier@wexinc.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>stephen.poynton@wexeurope.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>sunita.atwal@wexeurope.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Corporate_Payments_Templates/Corporate_Payments_Opportunity_Stage_4</template>
    </alerts>
    <alerts>
        <fullName>EU_Virtual_Opportunity_Won</fullName>
        <description>Virtual EU Opportunity Won</description>
        <protected>false</protected>
        <recipients>
            <recipient>CorporatePay_Implementation_Manager</recipient>
            <type>role</type>
        </recipients>
        <recipients>
            <recipient>Head_Of_Travel_Sales_EU</recipient>
            <type>role</type>
        </recipients>
        <recipients>
            <recipient>ServiceDeliveryTLMC</recipient>
            <type>role</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Virtual_EU_Templates/CorporatePay_Opportunity_Stage_Change</template>
    </alerts>
    <alerts>
        <fullName>Email_to_Internal_Referral</fullName>
        <description>Email to Internal Referral</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Internal_Referral_Notification</template>
    </alerts>
    <alerts>
        <fullName>Email_to_rep_on_BOCA_submit</fullName>
        <description>Email to rep on BOCA submit</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>BOCA/Email_to_rep_on_BOCA_submit</template>
    </alerts>
    <alerts>
        <fullName>Fuel_Enrollment_Issues</fullName>
        <description>Fuel Enrollment Issues</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Admin_Templates/Fuel_Enrollment_Issue_Warning</template>
    </alerts>
    <alerts>
        <fullName>Gold_Program_Attention_Getter</fullName>
        <ccEmails>dvidaurre@truckersb2b.com</ccEmails>
        <description>Gold Program Attention Getter</description>
        <protected>false</protected>
        <recipients>
            <field>Primary_Contact__c</field>
            <type>contactLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Gold_Program/Gold_Program_Attention_Getter</template>
    </alerts>
    <alerts>
        <fullName>MC_Negotiation_Notification</fullName>
        <description>MC Negotiation Notification</description>
        <protected>false</protected>
        <recipients>
            <recipient>rbeattie@wrightexpress.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/RM_Negotiation_Notification</template>
    </alerts>
    <alerts>
        <fullName>New_Sale_Finance</fullName>
        <ccEmails>Vishesh.Mehta@wexeurope.com</ccEmails>
        <description>New Sale - Finance</description>
        <protected>false</protected>
        <senderType>CurrentUser</senderType>
        <template>Virtual_EU_Templates/CorporatePay_New_Sale_Finance</template>
    </alerts>
    <alerts>
        <fullName>New_Sale_Manual_Billing_Required_Notification</fullName>
        <ccEmails>siqi.li@wexeurope.com, Aiste.Paulik@wexeurope.com</ccEmails>
        <description>New Sale - Manual Billing Required Notification</description>
        <protected>false</protected>
        <senderType>CurrentUser</senderType>
        <template>Virtual_EU_Templates/CorporatePay_New_Sale_Manual_Billing_Required</template>
    </alerts>
    <alerts>
        <fullName>New_Sale_RM</fullName>
        <ccEmails>relationship.management@wexeurope.com</ccEmails>
        <description>New Sale - RM &amp; Implementation</description>
        <protected>false</protected>
        <recipients>
            <recipient>CorporatePay_Head_Of_RM</recipient>
            <type>role</type>
        </recipients>
        <recipients>
            <recipient>CorporatePay_Implementation_Manager</recipient>
            <type>roleSubordinatesInternal</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Virtual_EU_Templates/CorporatePay_New_Sale_RM</template>
    </alerts>
    <alerts>
        <fullName>Opportunity_Fuel_Qualification_Opp</fullName>
        <description>Opportunity: Fuel Qualification Opp</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <recipient>danielle.vidaurre@wexinc.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Opportunity/Opportunity_FUEL_Qualification_Oppty</template>
    </alerts>
    <alerts>
        <fullName>Opportunity_Fuel_Sent_Program_Detached</fullName>
        <description>Opportunity: Fuel Sent Program Detached</description>
        <protected>false</protected>
        <recipients>
            <field>Primary_Contact__c</field>
            <type>contactLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Opportunity/Fuel_Info_Sent_detached</template>
    </alerts>
    <alerts>
        <fullName>Opportunity_Fuel_Sent_Program_Info</fullName>
        <description>Opportunity: Fuel Sent Program Info</description>
        <protected>false</protected>
        <recipients>
            <field>Primary_Contact__c</field>
            <type>contactLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Opportunity/Fuel_Info_Sent</template>
    </alerts>
    <alerts>
        <fullName>Opportunity_Fuelclosedwon_Savings</fullName>
        <ccEmails>dvidaurre@truckersB2B.com</ccEmails>
        <description>Opportunity: Fuelclosedwon Savings</description>
        <protected>false</protected>
        <recipients>
            <field>Primary_Contact__c</field>
            <type>contactLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Opportunity/Fuel_Savings</template>
    </alerts>
    <alerts>
        <fullName>Opportunity_Gold_ClosedWon</fullName>
        <description>Opportunity: Gold ClosedWon</description>
        <protected>false</protected>
        <recipients>
            <field>Primary_Contact__c</field>
            <type>contactLookup</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Gold_Program/Gold_Closed_Won</template>
    </alerts>
    <alerts>
        <fullName>Opportunity_Gold_ClosedWon60day</fullName>
        <description>Opportunity: Gold ClosedWon60day</description>
        <protected>false</protected>
        <recipients>
            <field>Primary_Contact__c</field>
            <type>contactLookup</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Gold_Program/Gold_PostSale_Email</template>
    </alerts>
    <alerts>
        <fullName>Opportunity_Gold_Credit_Approved</fullName>
        <description>Opportunity: Gold Credit Approved</description>
        <protected>false</protected>
        <recipients>
            <field>Primary_Contact__c</field>
            <type>contactLookup</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Gold_Program/Gold_Enrollment_Welcome</template>
    </alerts>
    <alerts>
        <fullName>Opportunity_Gold_Credit_card_on_file</fullName>
        <description>Opportunity: Gold Credit card on file</description>
        <protected>false</protected>
        <recipients>
            <field>Primary_Contact__c</field>
            <type>contactLookup</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Gold_Program/Credit_Card_Stored_welcome</template>
    </alerts>
    <alerts>
        <fullName>Opportunity_Gold_New_Opps</fullName>
        <ccEmails>dvidaurre@truckersb2b.com</ccEmails>
        <description>Opportunity: Gold New Opps</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Admin_Templates/New_Gold_Opps_Notification</template>
    </alerts>
    <alerts>
        <fullName>Opportunity_Gold_Pricing_Followup</fullName>
        <description>Opportunity: Gold Pricing Followup</description>
        <protected>false</protected>
        <recipients>
            <field>Primary_Contact__c</field>
            <type>contactLookup</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Admin_Templates/Gold_Pricing_FollowUP</template>
    </alerts>
    <alerts>
        <fullName>Opportunity_OCC</fullName>
        <ccEmails>twaller@occfactor.com</ccEmails>
        <ccEmails>tcawthorn@occfactor.com</ccEmails>
        <description>Opportunity: OCC</description>
        <protected>false</protected>
        <recipients>
            <recipient>danielle.vidaurre@wexinc.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>will.bowen@guest.efsllc.com.wex</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Opportunity/OCC_Opportunity</template>
    </alerts>
    <alerts>
        <fullName>Opportunity_Qualification_stage</fullName>
        <description>Opportunity: Qualification stage</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Admin_Templates/Qualification_Opps</template>
    </alerts>
    <alerts>
        <fullName>Opportunity_Revenue_Approved</fullName>
        <description>Opportunity Revenue Approved</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Virtual_EU_Templates/CorporatePay_Revenue_Approved</template>
    </alerts>
    <alerts>
        <fullName>Opportunity_Revenue_Rejected</fullName>
        <description>Opportunity Revenue Rejected</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Virtual_EU_Templates/CorporatePay_Revenue_Rejected</template>
    </alerts>
    <alerts>
        <fullName>Opportunity_Send_Fuel_Enrollment_Welcome</fullName>
        <description>Opportunity:Send Fuel Enrollment Welcome</description>
        <protected>false</protected>
        <recipients>
            <field>Primary_Contact__c</field>
            <type>contactLookup</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Admin_Templates/Fuel_Enrollment_Welcome</template>
    </alerts>
    <alerts>
        <fullName>Opportunity_Send_Fuel_Enrollment_WelcomeInterstate</fullName>
        <ccEmails>swilliams@interstatecapital.com</ccEmails>
        <description>Opportunity:Send Fuel Enrollment WelcomeInterstate</description>
        <protected>false</protected>
        <recipients>
            <field>Primary_Contact__c</field>
            <type>contactLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Admin_Templates/InterstateFuel_Enrollment_Welcome</template>
    </alerts>
    <alerts>
        <fullName>Opportunity_Send_ITG_Opportunity</fullName>
        <ccEmails>jcampbell@agentra.com; lweaver@agentra.com</ccEmails>
        <description>Opportunity: Send ITG Opportunity</description>
        <protected>false</protected>
        <recipients>
            <recipient>danielle.vidaurre@wexinc.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>will.bowen@guest.efsllc.com.wex</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Opportunity/ITG_Opportunity</template>
    </alerts>
    <alerts>
        <fullName>Opportunity_Send_To_Marquette</fullName>
        <ccEmails>rich.voreis@marquette.com</ccEmails>
        <ccEmails>diane.reed@marquette.com</ccEmails>
        <ccEmails>Scott.Franzen@marquette.com</ccEmails>
        <ccEmails>sam.peterson@marquette.com</ccEmails>
        <ccEmails>roger.moore@marquette.com</ccEmails>
        <description>Opportunity:Send To Marquette</description>
        <protected>false</protected>
        <recipients>
            <recipient>danielle.vidaurre@wexinc.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Opportunity/Marquette_Opportunity</template>
    </alerts>
    <alerts>
        <fullName>Opportunity_Send_to_AT_T</fullName>
        <ccEmails>matthew.krukin@fleetcomplete.com</ccEmails>
        <ccEmails>JB1070@att.com</ccEmails>
        <ccEmails>Andre.Agha@fleetcomplete.com</ccEmails>
        <description>Opportunity:Send to AT&amp;T</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <recipient>danielle.vidaurre@wexinc.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Opportunity/ATT_Opportunity</template>
    </alerts>
    <alerts>
        <fullName>Opportunity_Send_to_AT_T_Wireless</fullName>
        <ccEmails>JB1070@att.com</ccEmails>
        <description>Opportunity:Send to AT&amp;T Wireless</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <recipient>danielle.vidaurre@wexinc.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Opportunity/ATTwireless_Opportunity</template>
    </alerts>
    <alerts>
        <fullName>Opportunity_Send_to_BestPass</fullName>
        <ccEmails>sales@bestpass.com</ccEmails>
        <description>Opportunity:Send to BestPass</description>
        <protected>false</protected>
        <recipients>
            <recipient>danielle.vidaurre@wexinc.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Opportunity/BestPass_Opportunity</template>
    </alerts>
    <alerts>
        <fullName>Opportunity_Send_to_Castrol</fullName>
        <ccEmails>ian.fisher@bp.com</ccEmails>
        <ccEmails>gene.logan@bp.com</ccEmails>
        <ccEmails>joe.bennick@castrol.com</ccEmails>
        <ccEmails>scott.thomas@bp.com</ccEmails>
        <ccEmails>john.frauenhoffer@castrol.com</ccEmails>
        <description>Opportunity:Send to Castrol</description>
        <protected>false</protected>
        <recipients>
            <recipient>danielle.vidaurre@wexinc.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Opportunity/Castrol_Opportunity</template>
    </alerts>
    <alerts>
        <fullName>Opportunity_Send_to_DAT_FTS</fullName>
        <ccEmails>marti.watson@efsllc.com</ccEmails>
        <description>Opportunity: Send to DAT/FTS</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <recipient>danielle.vidaurre@wexinc.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Opportunity/DATFTS_Opportunity</template>
    </alerts>
    <alerts>
        <fullName>Opportunity_Send_to_EFS_FleetOne_Edge</fullName>
        <ccEmails>eric.hunter@efsllc.com</ccEmails>
        <ccEmails>hedwards@fleetone.com</ccEmails>
        <description>Opportunity:Send to EFS/FleetOne/Edge</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <recipient>danielle.vidaurre@wexinc.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Opportunity/EFS_Opportunity</template>
    </alerts>
    <alerts>
        <fullName>Opportunity_Send_to_EcoFlaps</fullName>
        <ccEmails>AHazelwood@ecoflaps.com</ccEmails>
        <description>Opportunity: Send to EcoFlaps</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <recipient>danielle.vidaurre@wexinc.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>will.bowen@guest.efsllc.com.wex</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Opportunity/EcoFlaps_Opportunity</template>
    </alerts>
    <alerts>
        <fullName>Opportunity_Send_to_FTS</fullName>
        <ccEmails>amber.white@efsllc.com</ccEmails>
        <ccEmails>kathy.scroggins@efsllc.com</ccEmails>
        <ccEmails>renee.high@efsllc.com</ccEmails>
        <ccEmails>marti.watson@efsllc.com</ccEmails>
        <description>Opportunity: Send to FTS</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <recipient>danielle.vidaurre@wexinc.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Opportunity/FTS_Opportunity</template>
    </alerts>
    <alerts>
        <fullName>Opportunity_Send_to_Imperial_Supplies</fullName>
        <ccEmails>schraves@imperialsupplies.com</ccEmails>
        <ccEmails>B2B_Leads@imperialsupplies.com</ccEmails>
        <description>Opportunity: Send to Imperial Supplies</description>
        <protected>false</protected>
        <recipients>
            <recipient>danielle.vidaurre@wexinc.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>will.bowen@guest.efsllc.com.wex</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Opportunity/Imperial_Supplies_Opportunity</template>
    </alerts>
    <alerts>
        <fullName>Opportunity_Send_to_InTouch</fullName>
        <ccEmails>jjarrell@intouchgps.com</ccEmails>
        <ccEmails>astivers@intouchgps.com</ccEmails>
        <ccEmails>DBurnham@intouchgps.com</ccEmails>
        <description>Opportunity:Send to In-Touch ELD</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Opportunity/InTouch_ELD_Opportunity</template>
    </alerts>
    <alerts>
        <fullName>Opportunity_Send_to_International</fullName>
        <description>Opportunity: Send to International</description>
        <protected>false</protected>
        <recipients>
            <recipient>danielle.vidaurre@wexinc.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>will.bowen@guest.efsllc.com.wex</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Opportunity/International_Truck_Opportunity</template>
    </alerts>
    <alerts>
        <fullName>Opportunity_Send_to_International_Used_Trucks</fullName>
        <ccEmails>Brock.Frederick@navistar.com</ccEmails>
        <ccEmails>Kevin.Stevens@navistar.com</ccEmails>
        <description>Opportunity: Send to International Used Trucks</description>
        <protected>false</protected>
        <recipients>
            <recipient>danielle.vidaurre@wexinc.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>will.bowen@guest.efsllc.com.wex</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Opportunity/International_Used_Truck_Opportunity</template>
    </alerts>
    <alerts>
        <fullName>Opportunity_Send_to_Loves_Factoring</fullName>
        <ccEmails>Jeremy.tilton@loves.com</ccEmails>
        <ccEmails>lovesfinancialsales@loves.com</ccEmails>
        <description>Opportunity: Send to Loves Factoring</description>
        <protected>false</protected>
        <recipients>
            <recipient>danielle.vidaurre@wexinc.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>will.bowen@guest.efsllc.com.wex</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Opportunity/Loves_Factoring_Opportunity</template>
    </alerts>
    <alerts>
        <fullName>Opportunity_Send_to_Pegasus</fullName>
        <ccEmails>Truckersb2beldreferral@transflo.com</ccEmails>
        <description>Opportunity:Send to Pegasus ELD</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Opportunity/Pegasus_ELD_Opportunity</template>
    </alerts>
    <alerts>
        <fullName>Opportunity_Send_to_Peoplenet</fullName>
        <description>Opportunity:Send to Peoplenet</description>
        <protected>false</protected>
        <recipients>
            <field>Primary_Contact__c</field>
            <type>contactLookup</type>
        </recipients>
        <recipients>
            <recipient>danielle.vidaurre@wexinc.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>B2B_Technology/PeopleNet</template>
    </alerts>
    <alerts>
        <fullName>Opportunity_Send_to_Pilot</fullName>
        <description>Opportunity:Send to Pilot</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <recipient>danielle.vidaurre@wexinc.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Opportunity/Pilot_Opportunity</template>
    </alerts>
    <alerts>
        <fullName>Opportunity_Send_to_Prophesy</fullName>
        <ccEmails>washburn@mile.com</ccEmails>
        <ccEmails>kpasternack@mile.com</ccEmails>
        <ccEmails>sales@mile.com</ccEmails>
        <description>Opportunity:Send to Prophesy</description>
        <protected>false</protected>
        <recipients>
            <recipient>danielle.vidaurre@wexinc.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>jrussell@truckersb2b.com.wex</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Opportunity/Prophesy_Opportunity</template>
    </alerts>
    <alerts>
        <fullName>Opportunity_Send_to_Roadside_Masters</fullName>
        <ccEmails>jcohen@roadsidemasters.com</ccEmails>
        <description>Opportunity:Send to Roadside Masters</description>
        <protected>false</protected>
        <recipients>
            <recipient>danielle.vidaurre@wexinc.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>will.bowen@guest.efsllc.com.wex</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Opportunity/Roadside_Masters_Opportunity</template>
    </alerts>
    <alerts>
        <fullName>Opportunity_Send_to_Sprint</fullName>
        <ccEmails>truckersb2b@sprint.com</ccEmails>
        <ccEmails>melanie.wilt@sprint.com</ccEmails>
        <ccEmails>nancy.backstrom@sprint.com</ccEmails>
        <description>Opportunity:Send to Sprint</description>
        <protected>false</protected>
        <recipients>
            <recipient>danielle.vidaurre@wexinc.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Opportunity/Sprint_Opportunity</template>
    </alerts>
    <alerts>
        <fullName>Opportunity_Send_to_TransFlo</fullName>
        <ccEmails>sales@transflo.com</ccEmails>
        <description>Opportunity:Send to TransFlo</description>
        <protected>false</protected>
        <recipients>
            <recipient>danielle.vidaurre@wexinc.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Opportunity/TransFlo_Opportunity</template>
    </alerts>
    <alerts>
        <fullName>Opportunity_Sent_Info_Only_Non_Fuel_Tires</fullName>
        <description>Opportunity: Sent Info Only Non-Fuel &amp; Tires</description>
        <protected>false</protected>
        <recipients>
            <field>Primary_Contact__c</field>
            <type>contactLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Admin_Templates/SentInfoOpportunity_Follow_UP</template>
    </alerts>
    <alerts>
        <fullName>Opportunity_Sent_Opps_Follow_up</fullName>
        <description>Opportunity: Sent Opps Follow up</description>
        <protected>false</protected>
        <recipients>
            <field>Primary_Contact__c</field>
            <type>contactLookup</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <recipient>danielle.vidaurre@wexinc.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Admin_Templates/Opportunity_Follow_UP</template>
    </alerts>
    <alerts>
        <fullName>Opportunity_Stage_4_Alert</fullName>
        <ccEmails>relationship.management@wexeurope.com</ccEmails>
        <description>Opportunity @ Stage 4 Alert</description>
        <protected>false</protected>
        <recipients>
            <recipient>CorporatePay_Implementation_Manager</recipient>
            <type>roleSubordinatesInternal</type>
        </recipients>
        <recipients>
            <recipient>bonnie.macarthur@wexeurope.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Virtual_EU_Templates/CorporatePay_Opportunity_Stage_4</template>
    </alerts>
    <alerts>
        <fullName>RM_Negotiation_Notification</fullName>
        <description>RM Negotiation Notification</description>
        <protected>false</protected>
        <recipients>
            <field>RM__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/RM_Negotiation_Notification</template>
    </alerts>
    <alerts>
        <fullName>Send_Closed_Lost_Survey</fullName>
        <description>Send Closed/Lost Survey</description>
        <protected>false</protected>
        <recipients>
            <field>Primary_Contact__c</field>
            <type>contactLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Survey_Closed_Lost</template>
    </alerts>
    <alerts>
        <fullName>Sends_Email_Notification_For_RoadSquad_Opportunity</fullName>
        <ccEmails>gwearsch@ta-petro.com</ccEmails>
        <description>Sends Email Notification For RoadSquad Opportunity</description>
        <protected>false</protected>
        <recipients>
            <recipient>danielle.vidaurre@wexinc.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>will.bowen@guest.efsllc.com.wex</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Opportunity/RoadSquad_Opportunity</template>
    </alerts>
    <alerts>
        <fullName>Sent_Gold_Info_Only_for_NOw</fullName>
        <description>Sent Gold Info Only for NOw</description>
        <protected>false</protected>
        <recipients>
            <field>Primary_Contact__c</field>
            <type>contactLookup</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Admin_Templates/SentInfoGold_Follow_UP</template>
    </alerts>
    <alerts>
        <fullName>TB2B_Fuel_Form_Received</fullName>
        <ccEmails>fueladmin@truckersb2b.com</ccEmails>
        <description>TB2B Fuel Form Received</description>
        <protected>false</protected>
        <senderType>CurrentUser</senderType>
        <template>Admin_Templates/Fuel_Form_Received</template>
    </alerts>
    <alerts>
        <fullName>Virtual_All_New_Sale_Survey</fullName>
        <description>Virtual All New Sale Survey</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Virtual_All_Templates/Virtual_All_New_Sale_Survey</template>
    </alerts>
    <alerts>
        <fullName>Virtual_EU_Opportunity_Moved_To_Stage_7</fullName>
        <description>Virtual EU Opportunity Moved To Stage 7</description>
        <protected>false</protected>
        <recipients>
            <recipient>justin.waters@wexeurope.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Virtual_EU_Templates/CorporatePay_Opportunity_Moved_To_Stage_7</template>
    </alerts>
    <alerts>
        <fullName>Virtual_NA_Opportunity_Stage_4</fullName>
        <description>Virtual NA Opportunity - Stage 4</description>
        <protected>false</protected>
        <recipients>
            <recipient>Director_Global_Strategic_Accounts</recipient>
            <type>role</type>
        </recipients>
        <recipients>
            <recipient>ServiceDeliveryTLMC</recipient>
            <type>role</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Virtual_Templates/Virtual_NA_Opportunity_Stage_4</template>
    </alerts>
    <alerts>
        <fullName>Virtual_NA_Opportunity_Won</fullName>
        <description>Virtual NA Opportunity - Won</description>
        <protected>false</protected>
        <recipients>
            <recipient>Director_Global_Strategic_Accounts</recipient>
            <type>role</type>
        </recipients>
        <recipients>
            <recipient>ServiceDeliveryTLMC</recipient>
            <type>role</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Virtual_Templates/Virtual_NA_Opportunity_Won</template>
    </alerts>
    <alerts>
        <fullName>Virtual_Opportunity_Stage_4_Onboarding_Notification</fullName>
        <description>Virtual Opportunity Stage 4 - Onboarding Notification</description>
        <protected>false</protected>
        <recipients>
            <recipient>Onboarding_Manager_EU</recipient>
            <type>role</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Virtual_EU_Templates/CorporatePay_Opportunity_Stage_4_Onboarding_Notification</template>
    </alerts>
    <alerts>
        <fullName>Virtual_Opportunity_Stage_Change_5_or_Won</fullName>
        <description>Virtual Opportunity Won</description>
        <protected>false</protected>
        <recipients>
            <recipient>Director_Virtual_Payments_NA</recipient>
            <type>role</type>
        </recipients>
        <recipients>
            <recipient>anton.truhan@wexeurope.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>timothy.bruce@wexinc.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Virtual_EU_Templates/CorporatePay_Opportunity_Stage_Change</template>
    </alerts>
    <alerts>
        <fullName>Win_Loss_Survey_Email</fullName>
        <description>Win / Loss Survey Email</description>
        <protected>false</protected>
        <recipients>
            <recipient>rbeattie@wrightexpress.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Survey_Monkey_Test_Template</template>
    </alerts>
    <fieldUpdates>
        <fullName>AU_Opportunity_Approved_Final_Status</fullName>
        <description>Updates the Opportunity Application Status to &quot;Approved Final&quot;</description>
        <field>Application_Status__c</field>
        <literalValue>Approved Final</literalValue>
        <name>AU Opportunity: Approved Final Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>AU_Opportunity_Approved_Initial_Status</fullName>
        <description>Updates the Opportunity Application Status to &quot;Approved Initial&quot;</description>
        <field>Application_Status__c</field>
        <literalValue>Approved Initial</literalValue>
        <name>AU Opportunity: Approved Initial Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>AU_Opportunity_Awaiting_1st_Approval</fullName>
        <description>Updates the Application Status to &quot;Awaiting 1st Approval&quot;</description>
        <field>Application_Status__c</field>
        <literalValue>Awaiting 1st Approval</literalValue>
        <name>AU Opportunity: Awaiting 1st Approval</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>AU_Opportunity_Awaiting_2nd_Approval</fullName>
        <description>Updates the Opportunity Application Status to &quot;Awaiting 2nd Approval&quot;</description>
        <field>Application_Status__c</field>
        <literalValue>Awaiting 2nd Approval</literalValue>
        <name>AU Opportunity: Awaiting 2nd Approval</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>AU_Opportunity_Close_Date</fullName>
        <field>CloseDate</field>
        <formula>Today()</formula>
        <name>AU Opportunity: Close Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>AU_Opportunity_Customer_Commitment_Gain</fullName>
        <description>Sets the Stage to 5.) Customer Commitment Gained</description>
        <field>StageName</field>
        <literalValue>5) Customer Commitment Gained</literalValue>
        <name>AU Opportunity: Customer Commitment Gain</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>AU_Opportunity_Declined_Status</fullName>
        <description>Updates the Opportunity Application Status to &quot;Declined&quot;</description>
        <field>Application_Status__c</field>
        <literalValue>Declined</literalValue>
        <name>AU Opportunity: Declined Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>AU_Opportunity_Proposal_Submitted</fullName>
        <description>Sets Stage to 4.) Proposal Submitted</description>
        <field>StageName</field>
        <literalValue>4) Proposal Submitted</literalValue>
        <name>AU Opportunity: Proposal Submitted</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>AU_Opportunity_Stage_Closed</fullName>
        <field>StageName</field>
        <literalValue>7) Closed/Won</literalValue>
        <name>AU Opportunity: Stage Closed</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>AU_Opportunity_Status_to_In_Progress</fullName>
        <description>Set the Opportunity Status to &quot;In Progress&quot;</description>
        <field>Opportunity_Status__c</field>
        <literalValue>In Progress</literalValue>
        <name>AU Opportunity Status to In Progress</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>AU_Pricing_Approval_Received_to_FALSE</fullName>
        <description>Set Opportunity Pricing Approval Received to false</description>
        <field>Pricing_Approval_Received__c</field>
        <literalValue>0</literalValue>
        <name>AU Pricing Approval Received to FALSE</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>AU_Pricing_Approval_Received_to_TRUE</fullName>
        <description>Set the Opportunity Pricing Approval Received checkbox to true</description>
        <field>Pricing_Approval_Received__c</field>
        <literalValue>1</literalValue>
        <name>AU Pricing Approval Received to TRUE</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>AU_Update_Close_Date1</fullName>
        <field>CloseDate</field>
        <formula>TODAY()</formula>
        <name>AU Update Close Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>AU_Update_Opp_Record_Type</fullName>
        <field>RecordTypeId</field>
        <lookupValue>AU_Fuel_Card_Business</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>AU Update Opp Record Type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Account_Asset_Project_Completed</fullName>
        <description>Account Asset has been completed and Project is now completed</description>
        <field>StageName</field>
        <literalValue>9) Project Completed</literalValue>
        <name>Account Asset Project Completed</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Account_Billing_City_to_Opp</fullName>
        <field>Billing_City__c</field>
        <formula>Account.BillingCity</formula>
        <name>Account Billing City to Opp</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Account_Billing_State_to_Opp</fullName>
        <field>Billing_State__c</field>
        <formula>Account.BillingState</formula>
        <name>Account Billing State to Opp</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Account_Billing_Street_to_Opp</fullName>
        <field>Billing_Street__c</field>
        <formula>Account.BillingStreet</formula>
        <name>Account Billing Street to Opp</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Account_Billing_Zip_to_Opp</fullName>
        <field>Billing_Zip_Postal_Code__c</field>
        <formula>Account.BillingPostalCode</formula>
        <name>Account Billing Zip to Opp</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Account_Country_to_Opp</fullName>
        <field>Physical_Country__c</field>
        <formula>Account.ShippingCountry</formula>
        <name>Account Country to Opp</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Account_Name_Program_Coupon_Code</fullName>
        <field>Account_Name_Program_Coupon_Code__c</field>
        <formula>Account.Name &amp; &quot; &quot; &amp;Campaign.Coupon_Code__c &amp; &quot; &quot;&amp;  Campaign_Program__r.Name&amp;&quot; &quot;&amp; Prospect_ID__c &amp;&quot; &quot;&amp;Searchable_info_from_Lead__c</formula>
        <name>Account Name, Program, Coupon Code</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Account_Shipping_City_to_Opp</fullName>
        <field>Physical_City__c</field>
        <formula>Account.ShippingCity</formula>
        <name>Account Shipping City to Opp</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Account_Shipping_State_to_Opp</fullName>
        <field>Physical_State__c</field>
        <formula>Account.ShippingState</formula>
        <name>Account Shipping State to Opp</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Account_Shipping_Street_to_Opp</fullName>
        <field>Physical_Street__c</field>
        <formula>Account.ShippingStreet</formula>
        <name>Account Shipping Street to Opp</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Account_Shipping_Zip_to_Opp</fullName>
        <field>Physical_Zip_Postal_Code__c</field>
        <formula>Account.ShippingPostalCode</formula>
        <name>Account Shipping Zip to Opp</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Adjust_Close_Date</fullName>
        <field>CloseDate</field>
        <formula>TODAY() + 15</formula>
        <name>Adjust Close Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>B2B_Fuel_Card_Rev_Calc</fullName>
        <description>when a co-branded card gets sold, calculates potential revenue from transaction fees.</description>
        <field>Amount</field>
        <formula>Fleet_Size__c*8</formula>
        <name>B2B Fuel Card Rev Calc</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Billing_Country_to_Opp</fullName>
        <field>Billing_Country__c</field>
        <formula>Account.BillingCountry</formula>
        <name>Billing Country to Opp</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Billing_to_Physical_City</fullName>
        <field>Physical_City__c</field>
        <formula>Billing_City__c</formula>
        <name>Billing to Physical City</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Billing_to_Physical_Country</fullName>
        <field>Physical_Country__c</field>
        <formula>Billing_Country__c</formula>
        <name>Billing to Physical Country</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Billing_to_Physical_State</fullName>
        <field>Physical_State__c</field>
        <formula>Billing_State__c</formula>
        <name>Billing to Physical State</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Billing_to_Physical_Street</fullName>
        <field>Physical_Street__c</field>
        <formula>Billing_Street__c</formula>
        <name>Billing to Physical Street</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Billing_to_Physical_Zip</fullName>
        <field>Physical_Zip_Postal_Code__c</field>
        <formula>Billing_Zip_Postal_Code__c</formula>
        <name>Billing to Physical Zip</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CP_Stage_Workflow</fullName>
        <description>Changing Stage once</description>
        <field>StageName</field>
        <literalValue>9) Project Completed</literalValue>
        <name>CP Stage Workflow</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Calculate_Commission</fullName>
        <field>Commission__c</field>
        <formula>IF(
  AND(
    Annual_Settlement_Value__c &gt; 0,
    Annual_Settlement_Value__c &lt;= 5000000
    ),
  /* 0.0175 estimated gross interchange minus estimated rebate */
  (Annual_Settlement_Value__c * 0.0175) * 0.07,
  IF(
    AND(
      Annual_Settlement_Value__c &gt; 5000000,
      Annual_Settlement_Value__c &lt;= 12000000
      ),
    (Annual_Settlement_Value__c * 0.0147) * 0.07,
    IF(
      AND(
        Annual_Settlement_Value__c &gt; 12000000,
        Annual_Settlement_Value__c &lt;= 50000000
        ),
        (Annual_Settlement_Value__c * 0.0128) * 0.07,
        IF(
          AND(
            Annual_Settlement_Value__c &gt; 50000000,
            Annual_Settlement_Value__c &lt;= 100000000
            ),
            (Annual_Settlement_Value__c * 0.00113) * 0.07,
            null
))))</formula>
        <name>Calculate Commission</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Capture_Original_1st_Contract_Year_Rev</fullName>
        <field>Original_1st_Contract_Year_Revenue__c</field>
        <formula>X1st_Contract_Year_Revenue__c</formula>
        <name>Capture Original 1st Contract Year Rev</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Capture_Revenue_In_Year</fullName>
        <field>Revenue_In_Year__c</field>
        <formula>Revenue_In_Year__c</formula>
        <name>Capture Revenue In Year</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Change_Oppt_Rec_Type_to_Channel</fullName>
        <description>Change Oppt Record Type to Channel Product</description>
        <field>RecordTypeId</field>
        <lookupValue>Channel_Product</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Change Oppt Rec Type to Channel</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Change_Oppt_Rec_Type_to_Fleet</fullName>
        <description>Change the Oppt Record Type to &quot;Fleet Card&quot;</description>
        <field>RecordTypeId</field>
        <lookupValue>Fleet_Card</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Change Oppt Rec Type to Fleet</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Close_Date_Update</fullName>
        <field>CloseDate</field>
        <formula>NOW()</formula>
        <name>Close Date Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Cross_Sell_Referral_Date</fullName>
        <description>Update the Referral Date with Todays Date</description>
        <field>Referral_Date__c</field>
        <formula>TODAY()</formula>
        <name>Cross Sell Referral Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Customer_Workflow</fullName>
        <description>CP Workflow Update Type &quot;Customer&quot;</description>
        <field>Type</field>
        <literalValue>Customer</literalValue>
        <name>Customer Workflow</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>AccountId</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Date_of_Signature_update</fullName>
        <field>Date_of_Signature__c</field>
        <formula>NOW()</formula>
        <name>Date of Signature update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Fleet_Card_opportunity_record_types</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Fleet_Card</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Set RecType to Fleet Card</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Fuel_Card_Record_Type</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Fuel_Card</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Fuel Card Record Type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Increment_Push_Counter_Field</fullName>
        <description>Increment the Push Counter by 1</description>
        <field>Push_Counter__c</field>
        <formula>IF( 
ISNULL( Push_Counter__c ), 
1, 
Push_Counter__c + 1 
)</formula>
        <name>Increment Push Counter Field</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>MasterCard</fullName>
        <field>RecordTypeId</field>
        <lookupValue>MasterCard</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>MasterCard</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Monthly_Revenue_Update</fullName>
        <description>Set the Monthly Revenue for Factoring Opps to be 2% of the Monthly Receivable Amount.</description>
        <field>Monthly_Revenue__c</field>
        <formula>(Monthly_Receivable_Amount__c / 100) * 2</formula>
        <name>Monthly Revenue Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>New_Oppty_Stage_Date</fullName>
        <field>Stage_Change_Date__c</field>
        <formula>NOW()</formula>
        <name>New Oppty Stage Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>OTR_Record_Type</fullName>
        <field>RecordTypeId</field>
        <lookupValue>OTR</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>OTR Record Type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Opp_Close_Date_Update</fullName>
        <description>Sets closed date to 28 days from creation date on newly created opportunites.</description>
        <field>CloseDate</field>
        <formula>Date(year(datevalue(CreatedDate)), MONTH(datevalue( CreatedDate)) +1,28)</formula>
        <name>Opp Close Date Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Opp_Close_Date_Update_PL</fullName>
        <description>Sets closed date to 30 days from creation date on newly created opportunites. Original field update created by Patrick Lewis. This rule worked until 5/31, then it broke, probably b/c there&apos;s only 30 days in June.</description>
        <field>CloseDate</field>
        <formula>DATE( YEAR(TODAY()) , (MONTH(TODAY()) + 1), DAY(TODAY()))</formula>
        <name>Opp Close Date Update - PL</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Opportunity_Assign_Adam_Aurich</fullName>
        <field>OwnerId</field>
        <lookupValue>aaurich@truckersb2b.com.wex</lookupValue>
        <lookupValueType>User</lookupValueType>
        <name>Opportunity:Assign Adam Aurich</name>
        <notifyAssignee>true</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Opportunity_Assign_Dawna_Cole</fullName>
        <field>OwnerId</field>
        <lookupValue>dcole@truckersb2b.com.wex</lookupValue>
        <lookupValueType>User</lookupValueType>
        <name>Opportunity:Assign Dawna Cole</name>
        <notifyAssignee>true</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Opportunity_Assign_Denise_Lockwood</fullName>
        <field>OwnerId</field>
        <lookupValue>dlockwood@truckersb2b.com.wex</lookupValue>
        <lookupValueType>User</lookupValueType>
        <name>Opportunity:Assign Denise Lockwood</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Opportunity_Assign_Ian_Wilkinson</fullName>
        <field>OwnerId</field>
        <lookupValue>ian.wilkinson@efsllc.com.wex</lookupValue>
        <lookupValueType>User</lookupValueType>
        <name>Opportunity:Assign Ian Wilkinson</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Opportunity_Assign_Jennifer_Nelson</fullName>
        <field>OwnerId</field>
        <lookupValue>jnelson@truckersb2b.com.wex</lookupValue>
        <lookupValueType>User</lookupValueType>
        <name>Opportunity:Assign Jennifer Nelson</name>
        <notifyAssignee>true</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Opportunity_Assign_Jessica_Rivera</fullName>
        <field>OwnerId</field>
        <lookupValue>jrivera@truckersb2b.com.wex</lookupValue>
        <lookupValueType>User</lookupValueType>
        <name>Opportunity: Assign Jessica Rivera</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Opportunity_Assign_Jonathan_Cosman</fullName>
        <field>OwnerId</field>
        <lookupValue>johnathan.cosman@truckersb2b.com</lookupValue>
        <lookupValueType>User</lookupValueType>
        <name>Opportunity: Assign Jonathan Cosman</name>
        <notifyAssignee>true</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Opportunity_Assign_Ross_Murray</fullName>
        <field>OwnerId</field>
        <lookupValue>rmurray@truckersb2b.com.wex</lookupValue>
        <lookupValueType>User</lookupValueType>
        <name>Opportunity:Assign Ross Murray</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Opportunity_Assign_Shawn_Galliett</fullName>
        <field>OwnerId</field>
        <lookupValue>sgalliett@truckersb2b.com.wex</lookupValue>
        <lookupValueType>User</lookupValueType>
        <name>Opportunity:Assign Shawn Galliett</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Opportunity_Assign_Tyler_Douglass</fullName>
        <field>OwnerId</field>
        <lookupValue>tdouglass@truckersb2b.com.wex</lookupValue>
        <lookupValueType>User</lookupValueType>
        <name>Opportunity:Assign Tyler Douglass</name>
        <notifyAssignee>true</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Opportunity_Assign_brian_Loveland</fullName>
        <description>This is for TB2B</description>
        <field>OwnerId</field>
        <lookupValue>brian.loveland@truckersb2b.com</lookupValue>
        <lookupValueType>User</lookupValueType>
        <name>Opportunity: Assign Brian Loveland</name>
        <notifyAssignee>true</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Opportunity_Card_Issue_Fee_Per_Card</fullName>
        <description>AU sales processes.
Populate the Opportunity Card Issue Per Card with the related Campaign.Card Issue Fee ($)</description>
        <field>Card_Issue_Revenue__c</field>
        <formula>Campaign__r.Card_Issue_Fee__c</formula>
        <name>Opportunity Card Issue Fee Per Card</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Opportunity_Close_Date_Changed</fullName>
        <field>Opportunity_Close_Date_Changed__c</field>
        <formula>IF(ischanged( CloseDate ),&quot;TRUE&quot;,&quot;&quot;)</formula>
        <name>Opportunity Close Date Changed</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Opportunity_FTS_Calculate_Amount</fullName>
        <description>this will calculate amount of margin for an FTS opp. Assuming 500gl/truck at $.03/gal margin</description>
        <field>Amount</field>
        <formula>(Account.Fleet_Size__c * 500) * 0.03</formula>
        <name>Opportunity:FTS Calculate Amount</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Opportunity_FUEL_calc_Gal_Qty</fullName>
        <description>Calculate how many expected NEW gal we&apos;ll obtain on this new oppty.</description>
        <field>TotalOpportunityQuantity</field>
        <formula>(Account.Fleet_Size__c* 420)</formula>
        <name>Opportunity: FUEL calc Gal Qty</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Opportunity_Falloff</fullName>
        <field>TB2B_Stage__c</field>
        <literalValue>Open Opportunity Fall Off</literalValue>
        <name>Opportunity Falloff</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Opportunity_Fuel_Calculate_Amount</fullName>
        <description>This will calculate the sale amount for a fuel opportunity (using 35% of 1200 gal/truck)</description>
        <field>Amount</field>
        <formula>(Account.Truck_Count__c * 420) * 0.02</formula>
        <name>Opportunity:Fuel Calculate Amount</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Opportunity_Gold_Calculate_Amount</fullName>
        <description>Calculates the opportunity amount when it is a Gold opportunity</description>
        <field>Amount</field>
        <formula>(Account.Truck_Count__c *0.50) * 30</formula>
        <name>Opportunity:Gold Calculate Amount</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Opportunity_Group_Code</fullName>
        <description>Set the Opportunity Group Code with the Campaign Group Code field value.</description>
        <field>Group_Code__c</field>
        <formula>Campaign__r.Group_Code__c</formula>
        <name>Opportunity Group Code</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Opportunity_Joining_Fee_Override</fullName>
        <description>Set the Opportunity Joining Fee Override with the value from the Campaign Joining Fee ($)</description>
        <field>AU_Joining_Fee_Override__c</field>
        <formula>Campaign__r.Joining_Fee__c</formula>
        <name>Opportunity Joining Fee Override</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Opportunity_Monthly_Card_Fee_Override</fullName>
        <description>Set the Opportunity Monthly Card Fee Override with the Campaign&apos;s Total Fee value.</description>
        <field>AU_Monthly_Card_Fee__c</field>
        <formula>Campaign__r.Total_Fee__c</formula>
        <name>Opportunity Monthly Card Fee Override</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Opportunity_Move_To_Sent_To_Vendor</fullName>
        <description>Move a TB2B opportunity to sent to vendor</description>
        <field>TB2B_Stage__c</field>
        <literalValue>Sent to Vendor</literalValue>
        <name>Opportunity:Move To Sent To Vendor</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Opportunity_Naming_Convention</fullName>
        <description>Append account name with the opportunity name</description>
        <field>Name</field>
        <formula>Account.Name &amp; &quot; - &quot; &amp; Name</formula>
        <name>Opportunity Naming Convention</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Opportunity_Payment_Terms</fullName>
        <description>AU Sales processes.
Populate the Opportunity Payment Terms (Days) with the related Campaign.Payment Terms (Days)</description>
        <field>Payment_Terms_Days__c</field>
        <formula>Campaign__r.Payment_Terms_Days__c</formula>
        <name>Opportunity Payment Terms</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Opportunity_Promotional_Code</fullName>
        <description>Set the Opportunity Promotional Code with the related Campaign Promo Code value.</description>
        <field>Promotional_Code__c</field>
        <formula>Campaign__r.Promo_Code__c</formula>
        <name>Opportunity Promotional Code</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Opportunity_Status_to_Pricing_Approved</fullName>
        <description>Change the Opportunity Status to Pricing Approved</description>
        <field>Opportunity_Status__c</field>
        <literalValue>Pricing Approved</literalValue>
        <name>Opportunity Status to Pricing Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Opportunity_Status_to_Pricing_Declined</fullName>
        <description>Change the Opportunity Status field to Pricing Declined</description>
        <field>Opportunity_Status__c</field>
        <literalValue>Pricing Declined</literalValue>
        <name>Opportunity Status to Pricing Declined</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Opportunity_Submitted_Assessment_to_Now</fullName>
        <description>Set the Opportunity field &quot;Submitted For Assessment Date/Time&quot; to the current time.</description>
        <field>Submitted_For_Assessment_Date_Time__c</field>
        <formula>Now()</formula>
        <name>Opportunity Submitted Assessment to Now</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Opportunity_Telematics_Record_Type</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Telamatics</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Opportunity: Telematics Record Type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Opportunity_Transaction_Fee</fullName>
        <description>AU Sales processes.
Populate the Opportunity.Transaction Fee ($) with the related Campaign.Transaction Fee ($)</description>
        <field>Transaction_Fee__c</field>
        <formula>Campaign__r.Transaction_Fee__c</formula>
        <name>Opportunity Transaction Fee</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Oppty_Remove_Pricing_Approval_Received</fullName>
        <description>Set the Opportunity Pricing Approval Received to false.</description>
        <field>Pricing_Approval_Received__c</field>
        <literalValue>0</literalValue>
        <name>Oppty Remove Pricing Approval Received</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Oppty_Remove_Pricing_Approval_to_False</fullName>
        <description>Set the Opportunity Remove Pricing Approval checkbox to false.</description>
        <field>Remove_Pricing_Approval__c</field>
        <literalValue>0</literalValue>
        <name>Oppty Remove Pricing Approval to False</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Populate_Card_Program_WF_TXT_Oppt</fullName>
        <description>When there&apos;s a value in the oppt Card Program field, copy it to oppt Card Program WF TXT.</description>
        <field>Card_Program_WF_TXT__c</field>
        <formula>Card_Program__r.Name</formula>
        <name>Populate Card Program WF TXT Oppt</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Populate_FSR_Commencement_Date</fullName>
        <field>Forecast_Full_Service_Revenue_Date__c</field>
        <formula>IF(

TEXT(Ramp_Profile__c) = &apos;Extended&apos;,
CloseDate + 450,

IF(
TEXT(Ramp_Profile__c) = &apos;Medium&apos;,
CloseDate + 270,

IF(
TEXT(Ramp_Profile__c) = &apos;Standard&apos;,
CloseDate + 180,

CloseDate + 105

)))</formula>
        <name>Populate FSR Commencement Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Populate_Imp_Rev_Commencement_Date</fullName>
        <field>Implementation_Revenue__c</field>
        <formula>IF(
TEXT(Ramp_Profile__c) = &apos;Immediate&apos;,
CloseDate + 15,
CloseDate + 90
)</formula>
        <name>Populate Imp Rev Commencement Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Populate_Implementation_Rev_FSR</fullName>
        <description>Move back to Opportunity Created [only] workflow rule once forecasts have been regenerated?</description>
        <field>Implementation_Revenue_as_a_of_FSR__c</field>
        <formula>IF(
TEXT(Ramp_Profile__c) = &apos;Extended&apos;,
0.2,

IF(
TEXT(Ramp_Profile__c) = &apos;Medium&apos;,
0.25,

0.375

))</formula>
        <name>Populate Implementation Rev % FSR</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Populate_Interchange_Rate</fullName>
        <description>Product list returns 1 for Corporate, 2 for Credit, 3 for Consumer, 4 for Virtual Debit, 5 for Visa Prepaid / AIO &amp; 6 for Asia &amp; AU Credit. Currency list returns 1 for GBP, 2 for EUR, 3 for USD, 4 for SEK, 5 for Rest Of World. 0 is error.</description>
        <field>Interchange_Rate_Revenue_as_a_percentag__c</field>
        <formula>IF(
  AND(
    OR(
      Product_List__c = 1,
      Product_List__c = 2
    ),
    CONTAINS(TEXT(Sales_Group__c), &quot;Travel&quot;),
    CloseDate &gt;= DATE(2016, 4, 1)
  ),
  0.02,
  
  IF(
    AND(
      Product_List__c = 1,
      Currency_List__c = 1
    ),
    0.0155,
    
    IF(
      AND(
        Product_List__c = 1,
        Currency_List__c = 2
      ),
      0.015,
      
      IF(
        AND(
          Product_List__c = 1,
          OR(
            Currency_List__c = 3,
            Currency_List__c = 4,
            Currency_List__c = 5
          )
        ),
        0.0175,
        
        IF(
          AND(
            Product_List__c = 2,
            OR(
              Currency_List__c = 1,
              Currency_List__c = 2
            )
          ),
          0.0175,
          
          
          IF(
            AND(
              Product_List__c = 2,
              OR(
                Currency_List__c = 3,
                Currency_List__c = 4,
                Currency_List__c = 5
              )
            ),
            0.0179,
            
            IF(
              AND(
                Product_List__c = 3,
                Currency_List__c = 1
              ),
              0.0085,
              
              IF(
                AND(
                  Product_List__c = 3,
                  Currency_List__c = 2
                ),
                0.016,
                
                IF(
                  AND(
                    Product_List__c = 3,
                    OR(
                      Currency_List__c = 3,
                      Currency_List__c = 4,
                      Currency_List__c = 5
                    )
                  ),
                  0.0117,
                  
                  IF(
                    AND(
                      Product_List__c = 4,
                      Currency_List__c = 1
                    ),
                    0.0155,
                    
                    IF(
                      AND(
                        Product_List__c = 4,
                        Currency_List__c = 4
                      ),
                      0.016,
                      
                      IF(
                        AND(
                          Product_List__c = 5,
                          OR(
                            Currency_List__c = 1,
                            Currency_List__c = 2,
                            Currency_List__c = 3,
                            Currency_List__c = 4,
                            Currency_List__c = 5
                          )
                        ),
                        0,
                        
                        /* Asia Opportunities */
                        IF(
                          AND(
                            Product_List__c = 6,
                            Currency_List__c = 3
                          ),
                          0.02,
                          0
                        )
                      )
                    )
                  )
                )
              )
            )
          )
        )
      )
    )
  )
)</formula>
        <name>Populate Interchange Rate</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Populate_Transaction_Fee</fullName>
        <field>Monthly_Txn_Revenue_POS__c</field>
        <formula>1</formula>
        <name>Populate Transaction Fee</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Price_Risk_Management_Record_Type</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Price_Risk_Management</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Price Risk Management Record Type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Pricing_Approval_Requested</fullName>
        <field>Approval_Process_Stage__c</field>
        <literalValue>Pricing Approval Requested</literalValue>
        <name>Pricing Approval Requested</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Pricing_Approved</fullName>
        <field>Approval_Process_Stage__c</field>
        <literalValue>Pricing Approved</literalValue>
        <name>Pricing Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Program_Row_Id_Update</fullName>
        <field>Program_Row_Id_Update__c</field>
        <formula>Siebel_Program_Row_id__c</formula>
        <name>Program Row Id Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Referral_Date_Update</fullName>
        <field>Referral_Date__c</field>
        <formula>TODAY()</formula>
        <name>Referral Date Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Reset_Internal_Blockers_Notes</fullName>
        <field>Internal_Blocker_Notes__c</field>
        <name>Reset Internal Blockers Notes</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Reset_Internal_Blockers_Picklist</fullName>
        <field>Internal_Blocker__c</field>
        <name>Reset Internal Blockers Picklist</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Revenue_Approval_Pending</fullName>
        <field>Approval_Process_Stage__c</field>
        <literalValue>Revenue Approval Pending</literalValue>
        <name>Revenue Approval Pending</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Revenue_Approval_Requested</fullName>
        <field>Approval_Process_Stage__c</field>
        <literalValue>Revenue Approval Requested</literalValue>
        <name>Revenue Approval Requested</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Revenue_Approved</fullName>
        <field>Approval_Process_Stage__c</field>
        <literalValue>Client Revenue Approved</literalValue>
        <name>Revenue Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Virtual_Product_to_AP_Direct</fullName>
        <description>Set &quot;Virtual Product&quot; to &quot;AP Direct&quot;</description>
        <field>MC_Product__c</field>
        <literalValue>AP Direct</literalValue>
        <name>Set Virtual Product to AP Direct</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Virtual_Product_to_SUGA</fullName>
        <description>Set &quot;Virtual Product&quot; to &quot;SUGA&quot;</description>
        <field>MC_Product__c</field>
        <literalValue>SUGA</literalValue>
        <name>Set Virtual Product to SUGA</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Source_System</fullName>
        <field>SourceSystem__c</field>
        <formula>&quot;Salesforce&quot;</formula>
        <name>Source System</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Stage_Change_Date</fullName>
        <field>Stage_Change_Date__c</field>
        <formula>NOW()</formula>
        <name>Stage Change Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Telapoint_Amount_Update</fullName>
        <field>Amount</field>
        <formula>IF( Text(Revenue_Schedule_Type__c) =&quot;Gallons&quot;, (((Sales_Price__c * Gallons_Per_Month__c ))),IF(text(Revenue_Schedule_Type__c) =&quot;Transactions&quot;, ((Sales_Price__c *  Transactions_per_month__c )),IF(Text(Revenue_Schedule_Type__c) =&quot;Sites&quot;, ((Sales_Price__c *   Number_of_Sites__c )),Value(&quot;&quot;))))</formula>
        <name>Telapoint Amount Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Telapoint_Record_Type</fullName>
        <field>RecordTypeId</field>
        <lookupValue>WEX_Fuel_Management</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Telapoint Record Type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Telematics_Record_Type</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Telamatics</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Telematics Record Type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_CP_Project_Approved_Date</fullName>
        <field>CP_Project_Approved__c</field>
        <formula>TODAY()</formula>
        <name>Update CP Project Approved Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_FSR_Commencement_Date</fullName>
        <field>Forecast_Full_Service_Revenue_Date__c</field>
        <formula>Forecast_Full_Service_Revenue_Date__c + (CloseDate - PRIORVALUE(CloseDate))</formula>
        <name>Update FSR Commencement Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Imp_Rev_Commencement_Date</fullName>
        <field>Implementation_Revenue__c</field>
        <formula>Implementation_Revenue__c  + (CloseDate - PRIORVALUE(CloseDate))</formula>
        <name>Update Imp Rev Commencement Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Opportunity_Amount_Net_FSR</fullName>
        <description>Copy Net FSR into Amount field for Campaign hierarchy roll up</description>
        <field>Amount</field>
        <formula>Net_Full_Service_Revenue__c</formula>
        <name>Update Opportunity Amount (Net FSR)</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Oppt_Stage</fullName>
        <description>Update Oppt Stage to 4) Negotiating</description>
        <field>StageName</field>
        <literalValue>4) Negotiating</literalValue>
        <name>Update Oppt Stage</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Product_Type_to_Trade</fullName>
        <description>Updates the product type field to &quot;Trade Card&quot;</description>
        <field>Product_Type__c</field>
        <literalValue>Trade_Card</literalValue>
        <name>Update Product Type to Trade</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Record_Type_to_WAA</fullName>
        <description>Updates the record type to AU WAA</description>
        <field>RecordTypeId</field>
        <lookupValue>AU_WAA</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Update Record Type to WAA</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Sales_Channel_to_BDM</fullName>
        <description>Sets the Sales Channel field to &quot;BDM&quot;</description>
        <field>AU_Sales_Channel__c</field>
        <literalValue>BDM</literalValue>
        <name>Update Sales Channel to BDM</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_stage_1st_gallon_pumped</fullName>
        <field>StageName</field>
        <literalValue>Pumped 1st gallon</literalValue>
        <name>Update stage- 1st gallon pumped</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>WESN_Record_Type</fullName>
        <field>RecordTypeId</field>
        <lookupValue>WESN</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>WESN Record Type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>WES_Change_Record_Type</fullName>
        <field>RecordTypeId</field>
        <lookupValue>WES_Opportunity</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>WES - Change Record Type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>WEXPay</fullName>
        <field>RecordTypeId</field>
        <lookupValue>WEXPay</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>WEXPay</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Wholesaler_Discount_Code_1</fullName>
        <description>Update Wholesaler Discount Code 1 when campaign is selected (AU record types)</description>
        <field>Wholesaler_Discount_Code_1__c</field>
        <formula>Campaign__r.Wholesaler_Discount_Code1__c</formula>
        <name>Wholesaler Discount Code 1</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Wholesaler_Discount_Code_2</fullName>
        <description>Update Wholesaler Discount Code 2 when a Campaign is selected (AU record types only)</description>
        <field>Wholesaler_Discount_Code_2__c</field>
        <formula>Campaign__r.Wholesaler_Discount_Code_2__c</formula>
        <name>Wholesaler Discount Code 2</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>udpate_Oppty_Name</fullName>
        <description>Update Opportunity Name to include &quot; Fleet One - BSA Received&quot;</description>
        <field>Name</field>
        <formula>Account_Name__c + &quot; Fleet One - BSA received&quot;</formula>
        <name>udpate Oppty Name</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>update_Close_Date</fullName>
        <field>CloseDate</field>
        <formula>Today()</formula>
        <name>update Close Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <outboundMessages>
        <fullName>Opportunity_to_HUB</fullName>
        <apiVersion>28.0</apiVersion>
        <endpointUrl>https://wexfleet.wexapi.com/salesforceopportunity</endpointUrl>
        <fields>AccountId</fields>
        <fields>Account_Name__c</fields>
        <fields>Annual_Gross_Revenue__c</fields>
        <fields>Application_Filename__c</fields>
        <fields>Average_Monthly_Fueling__c</fields>
        <fields>Billing_City__c</fields>
        <fields>Billing_Contact_Email__c</fields>
        <fields>Billing_Contact_Fax__c</fields>
        <fields>Billing_Contact_First_Name__c</fields>
        <fields>Billing_Contact_Last_Name__c</fields>
        <fields>Billing_Contact_Middle_Name__c</fields>
        <fields>Billing_Contact_Phone__c</fields>
        <fields>Billing_Contact__c</fields>
        <fields>Billing_Country__c</fields>
        <fields>Billing_State__c</fields>
        <fields>Billing_Street_Line_2__c</fields>
        <fields>Billing_Street__c</fields>
        <fields>Billing_Zip_Postal_Code__c</fields>
        <fields>CampaignId</fields>
        <fields>Campaign_Name__c</fields>
        <fields>Campaign_Program__c</fields>
        <fields>Campaign__c</fields>
        <fields>Card_Production_Complete__c</fields>
        <fields>Cash_Back_Flag__c</fields>
        <fields>Cash_Back_Limit__c</fields>
        <fields>CloseDate</fields>
        <fields>Company_Website__c</fields>
        <fields>Coupon_Code__c</fields>
        <fields>CreatedById</fields>
        <fields>CreatedDate</fields>
        <fields>Credit_National_Id__c</fields>
        <fields>CurrencyIsoCode</fields>
        <fields>DOT__c</fields>
        <fields>DUNS_IS__c</fields>
        <fields>Description</fields>
        <fields>Doing_Business_As__c</fields>
        <fields>Exempt_from_Motor_Fuels_Tax__c</fields>
        <fields>Expected_Monthly_Vehicle_Expense__c</fields>
        <fields>External_Referred_By_Account_Name__c</fields>
        <fields>Fiscal_Year_Starts__c</fields>
        <fields>Fleet_Size__c</fields>
        <fields>Fueling_Methos__c</fields>
        <fields>Gallons_Per_Month__c</fields>
        <fields>Guarantor_Annual_Income__c</fields>
        <fields>Guarantor_City__c</fields>
        <fields>Guarantor_Country__c</fields>
        <fields>Guarantor_Email__c</fields>
        <fields>Guarantor_Last_Name__c</fields>
        <fields>Guarantor_Middle_Name__c</fields>
        <fields>Guarantor_Name__c</fields>
        <fields>Guarantor_Position__c</fields>
        <fields>Guarantor_Social_Security_Number__c</fields>
        <fields>Guarantor_State__c</fields>
        <fields>Guarantor_Zip_code__c</fields>
        <fields>Guarantor_address_line_1__c</fields>
        <fields>Guarantor_address_line_2__c</fields>
        <fields>Guarantor_date_of_birth__c</fields>
        <fields>Guarantor_fax__c</fields>
        <fields>Guarantor_home_phone__c</fields>
        <fields>Guarantor_work_phone__c</fields>
        <fields>How_did_you_hear_about_this_offer__c</fields>
        <fields>How_did_you_hear_about_us__c</fields>
        <fields>IP_Address__c</fields>
        <fields>Id</fields>
        <fields>LastModifiedById</fields>
        <fields>LastModifiedDate</fields>
        <fields>LeadSource</fields>
        <fields>Legal_Structure__c</fields>
        <fields>Location_Code__c</fields>
        <fields>Maintenance_Spend_per_Month__c</fields>
        <fields>Name</fields>
        <fields>Number_of_Diesel_Vehicles__c</fields>
        <fields>Opportunity_Number__c</fields>
        <fields>Opportunity_Owner_Role__c</fields>
        <fields>Opportunity_Owner_Title__c</fields>
        <fields>OwnerId</fields>
        <fields>Owner_First_Name__c</fields>
        <fields>Owner_Last_Name__c</fields>
        <fields>Partner_Code__c</fields>
        <fields>Physical_City__c</fields>
        <fields>Physical_Country__c</fields>
        <fields>Physical_State__c</fields>
        <fields>Physical_Street_Line_2__c</fields>
        <fields>Physical_Street__c</fields>
        <fields>Physical_Zip_Postal_Code__c</fields>
        <fields>Primary_Contact_City__c</fields>
        <fields>Primary_Contact_Country__c</fields>
        <fields>Primary_Contact_Email__c</fields>
        <fields>Primary_Contact_Fax__c</fields>
        <fields>Primary_Contact_First_Name__c</fields>
        <fields>Primary_Contact_Last_Name__c</fields>
        <fields>Primary_Contact_Middle_Name__c</fields>
        <fields>Primary_Contact_State__c</fields>
        <fields>Primary_Contact_Street_Address_Line_2__c</fields>
        <fields>Primary_Contact_Street_Address__c</fields>
        <fields>Primary_Contact_Work_Phone__c</fields>
        <fields>Primary_Contact_ZIP_Code__c</fields>
        <fields>Primary_Contact__c</fields>
        <fields>Product_Interest__c</fields>
        <fields>Program_ID__c</fields>
        <fields>Program_Name__c</fields>
        <fields>Record_Type_Name__c</fields>
        <fields>Referring_Sales_Rep__c</fields>
        <fields>Requested_Credit_Limit__c</fields>
        <fields>Sales_Code__c</fields>
        <fields>Sales_Rep_Last_Name__c</fields>
        <fields>Sales_Rep_Name__c</fields>
        <fields>Sales_Stage_Id__c</fields>
        <fields>Siebel_Campaign_Row_id__c</fields>
        <fields>Siebel_Login_Id__c</fields>
        <fields>Siebel_Program_Row_id__c</fields>
        <fields>StageName</fields>
        <fields>Stage_Change_Date__c</fields>
        <fields>Tax_Id__c</fields>
        <fields>Years_In_Business__c</fields>
        <includeSessionId>true</includeSessionId>
        <integrationUser>salesforce@wrightexpress.com</integrationUser>
        <name>Opportunity to HUB</name>
        <protected>false</protected>
        <useDeadLetterQueue>true</useDeadLetterQueue>
    </outboundMessages>
    <outboundMessages>
        <fullName>Oppty_to_RDW</fullName>
        <apiVersion>24.0</apiVersion>
        <endpointUrl>https://webservices.wrightexpress.com/gateway/services/SalesforceHTTPOpportunity</endpointUrl>
        <fields>Account_Name__c</fields>
        <fields>Average_Monthly_Fueling__c</fields>
        <fields>Billing_City__c</fields>
        <fields>Billing_Contact_Email__c</fields>
        <fields>Billing_Contact_First_Name__c</fields>
        <fields>Billing_Contact_Last_Name__c</fields>
        <fields>Billing_Contact_Phone__c</fields>
        <fields>Billing_Country__c</fields>
        <fields>Billing_State__c</fields>
        <fields>Billing_Street__c</fields>
        <fields>Billing_Zip_Postal_Code__c</fields>
        <fields>Campaign_Name__c</fields>
        <fields>Coupon_Code2__c</fields>
        <fields>CreatedById</fields>
        <fields>CreatedDate</fields>
        <fields>Fleet_Size__c</fields>
        <fields>Gallons_Per_Month__c</fields>
        <fields>Guarantor_Social_Security_Number__c</fields>
        <fields>Guarantor_date_of_birth__c</fields>
        <fields>Id</fields>
        <fields>LastModifiedDate</fields>
        <fields>Maintenance_Spend_per_Month__c</fields>
        <fields>Name</fields>
        <fields>Number_of_Diesel_Vehicles__c</fields>
        <fields>Opportunity_Owner_Role__c</fields>
        <fields>Opportunity_Owner_Title__c</fields>
        <fields>Owner_First_Name__c</fields>
        <fields>Owner_Last_Name__c</fields>
        <fields>Partner_Code__c</fields>
        <fields>Physical_City__c</fields>
        <fields>Physical_Country__c</fields>
        <fields>Physical_State__c</fields>
        <fields>Physical_Street__c</fields>
        <fields>Physical_Zip_Postal_Code__c</fields>
        <fields>Program_Name__c</fields>
        <fields>Requested_Credit_Limit__c</fields>
        <fields>Sales_Code_old__c</fields>
        <fields>Sales_Rep_Alias__c</fields>
        <fields>Siebel_Campaign_Row_id__c</fields>
        <fields>Siebel_Login_Id__c</fields>
        <fields>Siebel_Program_Row_id__c</fields>
        <fields>StageName</fields>
        <fields>Stage_Change_Date__c</fields>
        <fields>Tax_Id__c</fields>
        <includeSessionId>true</includeSessionId>
        <integrationUser>salesforce@wrightexpress.com</integrationUser>
        <name>Oppty to RDW</name>
        <protected>false</protected>
        <useDeadLetterQueue>true</useDeadLetterQueue>
    </outboundMessages>
    <rules>
        <fullName>7-11 App Request Successful</fullName>
        <actions>
            <name>After_App_Request_7Eleven_successful_email_App_Signer_with_Data_Form</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Fleet_Data_Form_Sent</name>
            <type>Task</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Opportunity.Error_Log__c</field>
            <operation>startsWith</operation>
            <value>Success</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.SourceSystem__c</field>
            <operation>equals</operation>
            <value>Echosigned</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Program_Name__c</field>
            <operation>startsWith</operation>
            <value>7-</value>
        </criteriaItems>
        <description>When Error Log from Siebel indicates &quot;Success&quot; and created from Echosign and 7-11, sends Fleet Data Form to signer and completes a task.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>76 App Request Successful</fullName>
        <actions>
            <name>After_App_Request_76_successful_email_App_Signer_with_Data_Form</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Fleet_Data_Form_Sent</name>
            <type>Task</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Opportunity.Error_Log__c</field>
            <operation>startsWith</operation>
            <value>Success</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.SourceSystem__c</field>
            <operation>equals</operation>
            <value>Echosigned</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Program_Name__c</field>
            <operation>startsWith</operation>
            <value>76</value>
        </criteriaItems>
        <description>When Error Log from Siebel indicates &quot;Success&quot; and created from Echosign and 76, sends Fleet Data Form to signer and completes a task.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>AU Opportunity Remove Pricing Approval</fullName>
        <actions>
            <name>Oppty_Remove_Pricing_Approval_Received</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Oppty_Remove_Pricing_Approval_to_False</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Remove_Pricing_Approval__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>When &quot;Remove Pricing Approval&quot; is true, set the &quot;Pricing Approval Received&quot; to false AND then set &quot;Remove Pricing Approval&quot; back to false.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>AU Opportunity%3A Approved Final</fullName>
        <actions>
            <name>AU_Opportunity_Customer_Commitment_Gain</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Opportunity.Application_Status__c</field>
            <operation>equals</operation>
            <value>Approved Final</value>
        </criteriaItems>
        <description>Updates the relevant fields when the Application Status is Approved Final</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>AU Opportunity%3A Proposal Submitted</fullName>
        <actions>
            <name>AU_Opportunity_Proposal_Submitted</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>AU Fuel Card - Business,AU Fuel Card - Individual</value>
        </criteriaItems>
        <description>Updates the Stage to Proposal Submitted when first created</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>AU Opportunity%3A Ready for Export</fullName>
        <actions>
            <name>AU_Opportunity_Close_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>AU_Opportunity_Stage_Closed</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Opportunity.Application_Status__c</field>
            <operation>equals</operation>
            <value>Ready for Export</value>
        </criteriaItems>
        <description>Updates the relevant fields when the Application Status is Ready for Export</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>AU Opportunity%3A Update Credit Queue Ownership</fullName>
        <active>false</active>
        <criteriaItems>
            <field>Opportunity.Application_Status__c</field>
            <operation>equals</operation>
            <value>Ready for Assessment</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>AU Fuel Card - Business,AU Fuel Card - Individual,AU Fuel Merchant,AU VCC,AU Prepaid Customer</value>
        </criteriaItems>
        <description>Updates Opportunity Owner to AU Credit Queue if Ready for Assessment</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>AU Trade Partner record type updates</fullName>
        <actions>
            <name>Update_Product_Type_to_Trade</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Sales_Channel_to_BDM</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>AU Trade Partner</value>
        </criteriaItems>
        <description>Triggers various field updates when the opportunity record type = AU Trade Partner</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>AU WAA Approval Override</fullName>
        <actions>
            <name>AU_Pricing_Approval_Received_to_TRUE</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>AU WAA</value>
        </criteriaItems>
        <description>AU Workflow: Overrides the Opportunity pricing approval process where the record type = &quot;AU WAA&quot;</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>AU%3A Record type update when product type %3D WAA</fullName>
        <actions>
            <name>Update_Record_Type_to_WAA</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Product_Type__c</field>
            <operation>equals</operation>
            <value>WEX Accident Assist</value>
        </criteriaItems>
        <description>Updates the record type of an opportunity to AU WAA when the product type = WEX Accident Assist</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Billing to Physical Address</fullName>
        <actions>
            <name>Billing_to_Physical_City</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Billing_to_Physical_Country</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Billing_to_Physical_State</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Billing_to_Physical_Street</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Billing_to_Physical_Zip</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Same_as_Billing__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Bulk and Mobil Record Type Update</fullName>
        <actions>
            <name>Fuel_Card_Record_Type</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Product_Interest__c</field>
            <operation>equals</operation>
            <value>Bulk and Mobil</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>CITGO App Request Successful</fullName>
        <actions>
            <name>After_App_Request_CITGO</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Fleet_Data_Form_Sent</name>
            <type>Task</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Opportunity.Error_Log__c</field>
            <operation>startsWith</operation>
            <value>Success</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.SourceSystem__c</field>
            <operation>equals</operation>
            <value>Echosigned</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Program_Name__c</field>
            <operation>startsWith</operation>
            <value>CITGO</value>
        </criteriaItems>
        <description>When Error Log from Siebel indicates &quot;Success&quot; and created from Echosign and CITGO, sends Fleet Data Form to signer and completes a task.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Calculate Credit Limit</fullName>
        <active>false</active>
        <description>Wex Europe Virtual Credit opportunities only</description>
        <formula>RecordTypeId = &apos;012700000005qie&apos;</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Campaign Offer Chosen %28AU Fuel Direct%29</fullName>
        <actions>
            <name>Opportunity_Card_Issue_Fee_Per_Card</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Opportunity_Group_Code</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Opportunity_Joining_Fee_Override</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Opportunity_Monthly_Card_Fee_Override</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Opportunity_Payment_Terms</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Opportunity_Promotional_Code</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Opportunity_Transaction_Fee</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Wholesaler_Discount_Code_1</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Wholesaler_Discount_Code_2</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>AU Fuel Direct.
If Campaign lookup has a value, populate Opportunity fields with Campaign values.

Note: filter for Record Type not added due to maximum number of 15 object references on Opportunity reached.</description>
        <formula>OR(  AND(   ISNEW(),   NOT(ISBLANK(Campaign__c))  ),   AND(   ISCHANGED(Campaign__c),   NOT(ISBLANK(Campaign__c))  ) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Card Program Text Field Oppt</fullName>
        <actions>
            <name>Populate_Card_Program_WF_TXT_Oppt</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Card_Program_Txt__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Need a text version of the Card Program lookup field for use in sharing rules. (can&apos;t use lookup field or formula field.)</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Castrol Ready For Vendor</fullName>
        <actions>
            <name>Opportunity_Send_to_Castrol</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Opportunity_Move_To_Sent_To_Vendor</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>Truckers - Opportunity</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.TB2B_Stage__c</field>
            <operation>equals</operation>
            <value>Ready to Send to Vendor</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.TB2B_Product_Interest__c</field>
            <operation>equals</operation>
            <value>Castrol</value>
        </criteriaItems>
        <description>An TB2B Castrol opportunity that is ready for the vendor</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Channel Oppt Rec Type Change</fullName>
        <actions>
            <name>Change_Oppt_Rec_Type_to_Fleet</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Product_Service_Type__c</field>
            <operation>equals</operation>
            <value>Fleet Card - Private Label OTR</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>Channel Product</value>
        </criteriaItems>
        <description>Change the Oppt Record Type from Channel to Fleet if Card Product = OTR and Product/Service Type = Fleet Card - Private Label OTR.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Circle K App Request Successful</fullName>
        <actions>
            <name>After_App_Request_CircleK_successful_email_App_Signer_with_Data_Form</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Fleet_Data_Form_Sent</name>
            <type>Task</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Opportunity.Error_Log__c</field>
            <operation>startsWith</operation>
            <value>Success</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.SourceSystem__c</field>
            <operation>equals</operation>
            <value>Echosigned</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Program_Name__c</field>
            <operation>startsWith</operation>
            <value>Circle</value>
        </criteriaItems>
        <description>When Error Log from Siebel indicates &quot;Success&quot; and created from Echosign and Circle K, sends Fleet Data Form to signer and completes a task.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Close Date Change</fullName>
        <actions>
            <name>Update_FSR_Commencement_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Imp_Rev_Commencement_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>All Wex Europe record types apart from Currency &amp; Expense UTB</description>
        <formula>/* Be aware of Opportunity Created / Edited - Stages 1 &amp; 2 workflow rule &amp; field updates */

AND(

OR( 

/* Bespoke, TourCard, Disbursement */
RecordTypeId = &apos;012700000005qia&apos;, 
RecordTypeId = &apos;012700000005qid&apos;,
RecordTypeId = &apos;012700000005qib&apos;, 

/* Expense - Crew, General, Petty Cash, Platform, Tour, Transport &amp; Haulage */ 
RecordTypeId = &apos;012700000005qic&apos;,
RecordTypeId = &apos;012700000005rA9&apos;,
RecordTypeId = &apos;012700000005rAA&apos;,
RecordTypeId = &apos;012700000005rAB&apos;,
RecordTypeId = &apos;012700000005qzo&apos;,
RecordTypeId = &apos;012700000005rAC&apos;,
RecordTypeId = &apos;012700000005r0I&apos;,

/* Virtual Credit, Virtual Prepaid MC, Virtual Debit MC */ 
RecordTypeId = &apos;012700000005qie&apos;,
RecordTypeId = &apos;012700000005qif&apos;,
RecordTypeId = &apos;012700000005wUG&apos;,

/* Virtual Prepaid VE, Virtual All In One */
RecordTypeId = &apos;012700000005qig&apos;,
RecordTypeId = &apos;012700000005xWw&apos;
),

/* once client revenue projections have been approved, this update should not be applied as the MRF cannot be regenerated */

NOT(TEXT(Approval_Process_Stage__c) = &apos;Client Revenue Approved&apos;),

ISCHANGED(CloseDate),

OR(
TEXT(StageName) = &quot;3) Proposal Submitted&quot;,
TEXT(StageName) = &quot;4) Contract Issued&quot;,
TEXT(StageName) = &quot;5) Negotiate&quot;,
TEXT(StageName) = &quot;6) Signed Contract&quot;,
TEXT(StageName) = &quot;7) Service Implementation&quot;,
TEXT(StageName) = &quot;8) Project Completed&quot;
)

)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Close Date Update</fullName>
        <actions>
            <name>Close_Date_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>7) Closed/Won</value>
        </criteriaItems>
        <description>Close Date is set to today&apos;s date when sales stage is set to Closed/Won</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Closed deals Workflow</fullName>
        <actions>
            <name>CP_Stage_Workflow</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Opportunity.Application_Status__c</field>
            <operation>equals</operation>
            <value>Accepted</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>CorporatePay,CP_Bespoke,CP_Disbursement,CP_Expense,CP_TourCard,CP Virtual Credit,CP Virtual Prepaid MC,CP Virtual Prepaid VE,CP_Expense_Platform,CP_Expense_UTB_Corporate,CP_CurrencyCard_WL_MC,CP_CurrencyCard_MTC_MC,CP_CurrencyCard_WL_Visa,CP_</value>
        </criteriaItems>
        <description>Automated Closed deal to Correct Sales Stage</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Community%3A notify External referring contac that lead has been converted</fullName>
        <actions>
            <name>Community_Notify_partner_community_user_that_lead_has_been_converted_to_oppty</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>5/29/15 PUT ON HOLD FOR NOW PER ERICA.  Notifies the original partner community user that their submitted lead has been converted to an opportunity</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Conoco App Request Successful</fullName>
        <actions>
            <name>After_App_Request_Conoco_successful_email_App_Signer_with_Data_Form</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Fleet_Data_Form_Sent</name>
            <type>Task</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Opportunity.Error_Log__c</field>
            <operation>startsWith</operation>
            <value>Success</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.SourceSystem__c</field>
            <operation>equals</operation>
            <value>Echosigned</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Program_Name__c</field>
            <operation>startsWith</operation>
            <value>Conoco</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Opportunity_Owner_Role__c</field>
            <operation>notEqual</operation>
            <value>CP Regional Sales Manager</value>
        </criteriaItems>
        <description>When Error Log from Siebel indicates &quot;Success&quot; and created from Echosign and Conoco and not CP Regional Sales Manager, sends Fleet Data Form (pdf) to signer and completes a task.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Conoco App Request Successful - Excel</fullName>
        <actions>
            <name>After_App_Request_Conoco_successful_email_App_Signer_with_Data_Form_Excel</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Fleet_Data_Form_Sent</name>
            <type>Task</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Opportunity.Error_Log__c</field>
            <operation>startsWith</operation>
            <value>Success</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.SourceSystem__c</field>
            <operation>equals</operation>
            <value>Echosigned</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Program_Name__c</field>
            <operation>startsWith</operation>
            <value>Conoco</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Opportunity_Owner_Role__c</field>
            <operation>equals</operation>
            <value>CP Regional Sales Manager</value>
        </criteriaItems>
        <description>When Error Log from Siebel indicates &quot;Success&quot; and created from Echosign and Conoco and IS CP Regional Sales Manager, sends Fleet Data Form (excel) to signer and completes a task.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Create Account Asset Reminder</fullName>
        <actions>
            <name>Opportunity_has_Closed_Create_Account_Asset</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2 AND 3</booleanFilter>
        <criteriaItems>
            <field>User.ProfileId</field>
            <operation>startsWith</operation>
            <value>F1</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>7) Closed/Won</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Record_Type_Name__c</field>
            <operation>notEqual</operation>
            <value>Factoring</value>
        </criteriaItems>
        <description>Task to create asset 3 days after Opportunity Closed.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Create followup task for Tony Chellini or Ralph Morales</fullName>
        <actions>
            <name>Call</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Coupon_Code2__c</field>
            <operation>equals</operation>
            <value>X6J,M83,RF3,GBQ</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.OwnerId</field>
            <operation>equals</operation>
            <value>Tony Chellini,Ralph Morales</value>
        </criteriaItems>
        <description>This workflow creates a task for Tony Chellini or Ralph Morales when an opportunity gets assigned to them</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Customer Initiated Credit App</fullName>
        <actions>
            <name>Update_Oppt_Stage</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>udpate_Oppty_Name</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>update_Close_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>notEqual</operation>
            <value>5) Signed,6) Service Implementation,7) Project Completed,Closed/Lost</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Sale_Initiated_By_Credit_Application__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>If the Sale Initiated By Credit Application box is checked, update the Oppt Stage to &quot;4) Negotiating&quot;</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Customer Service Create Asset</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Application_Status__c</field>
            <operation>equals</operation>
            <value>Accepted</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>CorporatePay,CP_Expense,CP_Disbursement,CP_TourCard,CP Virtual Credit,CP Virtual Prepaid MC,CP Virtual Prepaid VE</value>
        </criteriaItems>
        <description>CP Inform Customer service to create a asset</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Customer Workflow</fullName>
        <actions>
            <name>Customer_Workflow</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>9) Project Completed,7) Closed/Won,7) Signed Contract,8) Service Implementation</value>
        </criteriaItems>
        <description>CP Customer Workflow</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Date of Signature update</fullName>
        <actions>
            <name>Date_of_Signature_update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Application_Signature__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Date of signature field is updated with current date when the app signer is populated</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Email Sent for Internal Referral</fullName>
        <actions>
            <name>Email_to_Internal_Referral</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Internal_Referral__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>An email is sent to the Oppty owner when the internal referral field is populated.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Enterprise App Request Successful</fullName>
        <actions>
            <name>After_App_Request_Enterprise_successful_email_App_Signer_with_Data_Form2</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Fleet_Data_Form_Sent</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Error_Log__c</field>
            <operation>startsWith</operation>
            <value>Success</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.SourceSystem__c</field>
            <operation>equals</operation>
            <value>Echosigned</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Program_Name__c</field>
            <operation>startsWith</operation>
            <value>Enterprise Fleet</value>
        </criteriaItems>
        <description>When Error Log from Siebel indicates &quot;Success&quot; and created from Echosign and Enterprise Fleet sends Fleet Data Form to signer and completes a task.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Enterprise Tri Brand App Request Successful</fullName>
        <actions>
            <name>After_App_Request_Enterprise_successful_email_App_Signer_with_Data_Form2</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Fleet_Data_Form_Sent</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Error_Log__c</field>
            <operation>startsWith</operation>
            <value>Success</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.SourceSystem__c</field>
            <operation>equals</operation>
            <value>Echosigned</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Program_Name__c</field>
            <operation>startsWith</operation>
            <value>Enterprise Tri Brand</value>
        </criteriaItems>
        <description>When Error Log from Siebel indicates &quot;Success&quot; and created from Echosign and Enterprise Tri Brand sends Fleet Data Form to signer and completes a task.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Enterprise Truck Rental App Request Successful</fullName>
        <actions>
            <name>After_App_Request_Ent_Truck_Rental_Tribrand_successful_email_App_Signer_with_Dat</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Fleet_Data_Form_Sent</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Error_Log__c</field>
            <operation>startsWith</operation>
            <value>Success</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.SourceSystem__c</field>
            <operation>equals</operation>
            <value>Echosigned</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Program_Name__c</field>
            <operation>startsWith</operation>
            <value>Enterprise Truck Rental</value>
        </criteriaItems>
        <description>When Error Log from Siebel indicates &quot;Success&quot; and created from Echosign and Enterprise  Truck Rental sends Fleet Data Form to signer and completes a task.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Enterprise Truck Rental TriBrand App Request Successful</fullName>
        <actions>
            <name>After_App_Request_Ent_Truck_Rental_Tribrand_successful_email_App_Signer_with_Dat</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Fleet_Data_Form_Sent</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Error_Log__c</field>
            <operation>startsWith</operation>
            <value>Success</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.SourceSystem__c</field>
            <operation>equals</operation>
            <value>Echosigned</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Program_Name__c</field>
            <operation>startsWith</operation>
            <value>Ent Truck Rental</value>
        </criteriaItems>
        <description>When Error Log from Siebel indicates &quot;Success&quot; and created from Echosign and Enterprise Trucks (Tri Brand) sends Fleet Data Form to signer and completes a task.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>ExxonMobil BizUnite App Request Successful</fullName>
        <actions>
            <name>After_App_Request_ExxonMobil_BizUnite</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Fleet_Data_Form_Sent</name>
            <type>Task</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Opportunity.Error_Log__c</field>
            <operation>startsWith</operation>
            <value>Success</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.SourceSystem__c</field>
            <operation>equals</operation>
            <value>Echosigned</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Coupon_Code2__c</field>
            <operation>equals</operation>
            <value>BZF,BZU,E7X,E7W</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Program_Name__c</field>
            <operation>startsWith</operation>
            <value>ExxonMobil</value>
        </criteriaItems>
        <description>When Error Log from Siebel indicates &quot;Success&quot; and created from Echosign and ExxonMobil, sends Fleet Data Form to signer and completes a task.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>ExxonMobil Business Fleet App Request Successful</fullName>
        <actions>
            <name>After_App_Request_ExxonMobil_biz</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Fleet_Data_Form_Sent</name>
            <type>Task</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Opportunity.Error_Log__c</field>
            <operation>startsWith</operation>
            <value>Success</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.SourceSystem__c</field>
            <operation>equals</operation>
            <value>Echosigned</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Program_Name__c</field>
            <operation>startsWith</operation>
            <value>ExxonMobil Business Fleet</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Coupon_Code__c</field>
            <operation>notEqual</operation>
            <value>BZF,BZU,E7X,E7W</value>
        </criteriaItems>
        <description>When Error Log from Siebel indicates &quot;Success&quot; and created from Echosign and ExxonMobil, sends Fleet Data Form to signer and completes a task.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>ExxonMobil Fleet National App Request Successful</fullName>
        <actions>
            <name>After_App_Request_ExxonMobil</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Fleet_Data_Form_Sent</name>
            <type>Task</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Opportunity.Error_Log__c</field>
            <operation>startsWith</operation>
            <value>Success</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.SourceSystem__c</field>
            <operation>equals</operation>
            <value>Echosigned</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Program_Name__c</field>
            <operation>startsWith</operation>
            <value>ExxonMobil Fleet National</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Coupon_Code__c</field>
            <operation>notEqual</operation>
            <value>BZF,BZU,E7X,E7W</value>
        </criteriaItems>
        <description>When Error Log from Siebel indicates &quot;Success&quot; and created from Echosign and ExxonMobil, sends Fleet Data Form to signer and completes a task.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Factoring Revenue Calculation</fullName>
        <actions>
            <name>Monthly_Revenue_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>Factoring</value>
        </criteriaItems>
        <description>This rule will calculate Monthly Revenue for Factoring Opportunities based on 2% of the Monthly Receivables Amount</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Fleet Oppt Rec Type Change</fullName>
        <actions>
            <name>Change_Oppt_Rec_Type_to_Channel</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Product_Service_Type__c</field>
            <operation>equals</operation>
            <value>Fuelbook Basic,Fuel Management Progressive,Fuelbook Premium,Fuel Management Fundamental</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>Fleet Card</value>
        </criteriaItems>
        <description>If the Record Type is Fleet but Product/Service Type = Fuelbook Basic, Fuelbook Premium, Fuel Management Fundamental, Fuel Management Progressive.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Fleet Record Type Update</fullName>
        <actions>
            <name>Fuel_Card_Record_Type</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Product_Interest__c</field>
            <operation>equals</operation>
            <value>Fleet</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Fuel Form Received</fullName>
        <actions>
            <name>TB2B_Fuel_Form_Received</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>Truckers - Opportunity</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.TB2B_Stage__c</field>
            <operation>equals</operation>
            <value>Closed Won</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.TB2B_Product_Interest__c</field>
            <operation>equals</operation>
            <value>Fuel</value>
        </criteriaItems>
        <description>TB2B WFR</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>GetGo App Request Successful</fullName>
        <actions>
            <name>After_App_Request_GetGo_successful_email_App_Signer_with_Data_Form</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Fleet_Data_Form_Sent</name>
            <type>Task</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Opportunity.Error_Log__c</field>
            <operation>startsWith</operation>
            <value>Success</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.SourceSystem__c</field>
            <operation>equals</operation>
            <value>Echosigned</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Program_Name__c</field>
            <operation>startsWith</operation>
            <value>GetFleet</value>
        </criteriaItems>
        <description>When Error Log from Siebel indicates &quot;Success&quot; and created from Echosign and GetGo, sends Fleet Data Form to signer and completes a task.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Gulf App Request Successful</fullName>
        <actions>
            <name>After_App_Request_Gulf</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Fleet_Data_Form_Sent</name>
            <type>Task</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Opportunity.Error_Log__c</field>
            <operation>startsWith</operation>
            <value>Success</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.SourceSystem__c</field>
            <operation>equals</operation>
            <value>Echosigned</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Program_Name__c</field>
            <operation>startsWith</operation>
            <value>Gulf</value>
        </criteriaItems>
        <description>When Error Log from Siebel indicates &quot;Success&quot; and created from Echosign and Gulf, sends Fleet Data Form to signer and completes a task.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Holiday Universal App Request Successful</fullName>
        <actions>
            <name>After_Holiday_App_Request_is_successful_email_App_Signer_with_Data_Form</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Fleet_Data_Form_Sent</name>
            <type>Task</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Opportunity.Error_Log__c</field>
            <operation>startsWith</operation>
            <value>Success</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.SourceSystem__c</field>
            <operation>equals</operation>
            <value>Echosigned</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Program_Name__c</field>
            <operation>startsWith</operation>
            <value>Holiday Universal</value>
        </criteriaItems>
        <description>When Error Log from Siebel indicates &quot;Success&quot; and created from Echosign and HolidayUniversal, sends Fleet Data Form to signer and completes a task.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>INTEGRATION - Oppty To RDW</fullName>
        <actions>
            <name>Oppty_to_RDW</name>
            <type>OutboundMessage</type>
        </actions>
        <active>false</active>
        <formula>RecordTypeId  = &apos;012700000005fz9&apos;</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>INTEGRATION - Oppty to HUB</fullName>
        <actions>
            <name>Opportunity_to_HUB</name>
            <type>OutboundMessage</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Name</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>This workflow sends all opportunities to the WEX Integration HUB</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>KumandGo App Request Successful</fullName>
        <actions>
            <name>After_App_Request_KumGo</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Fleet_Data_Form_Sent</name>
            <type>Task</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Opportunity.Error_Log__c</field>
            <operation>startsWith</operation>
            <value>Success</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.SourceSystem__c</field>
            <operation>equals</operation>
            <value>Echosigned</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Program_Name__c</field>
            <operation>startsWith</operation>
            <value>Kum</value>
        </criteriaItems>
        <description>When Error Log from Siebel indicates &quot;Success&quot; and created from Echosign and Kum &amp; Go, sends Fleet Data Form to signer and completes a task.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>LukOil App Request Successful</fullName>
        <actions>
            <name>After_App_Request_LukOil_successful_email_App_Signer_with_Data_Form</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Fleet_Data_Form_Sent</name>
            <type>Task</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Opportunity.Error_Log__c</field>
            <operation>startsWith</operation>
            <value>Success</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.SourceSystem__c</field>
            <operation>equals</operation>
            <value>Echosigned</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Program_Name__c</field>
            <operation>startsWith</operation>
            <value>LukOil</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Program_Name__c</field>
            <operation>notContain</operation>
            <value>Business</value>
        </criteriaItems>
        <description>When Error Log from Siebel indicates &quot;Success&quot; and created from Echosign and LukOil, sends Fleet Data Form to signer and completes a task.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>LukOil Business App Request Successful</fullName>
        <active>false</active>
        <criteriaItems>
            <field>Opportunity.Error_Log__c</field>
            <operation>startsWith</operation>
            <value>Success</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.SourceSystem__c</field>
            <operation>equals</operation>
            <value>Echosigned</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Program_Name__c</field>
            <operation>startsWith</operation>
            <value>LukOil Business</value>
        </criteriaItems>
        <description>When Error Log from Siebel indicates &quot;Success&quot; and created from Echosign and LukOil Business, completes a task without sending Fleet Data Form.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>MC Negotiation Notification</fullName>
        <actions>
            <name>MC_Negotiation_Notification</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.RM__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>4) Negotiating,5) Signed</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>MasterCard</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>MC Record Type Update</fullName>
        <actions>
            <name>MasterCard</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Product_Interest__c</field>
            <operation>equals</operation>
            <value>MC</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>notEqual</operation>
            <value>International</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Mapco App Request Successful</fullName>
        <actions>
            <name>After_App_Request_Mapco_successful_email_App_Signer_with_Data_Form</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Fleet_Data_Form_Sent</name>
            <type>Task</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Opportunity.Error_Log__c</field>
            <operation>startsWith</operation>
            <value>Success</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.SourceSystem__c</field>
            <operation>equals</operation>
            <value>Echosigned</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Program_Name__c</field>
            <operation>startsWith</operation>
            <value>Mapco</value>
        </criteriaItems>
        <description>When Error Log from Siebel indicates &quot;Success&quot; and created from Echosign and Mapco, sends Fleet Data Form to signer and completes a task.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Marathon App Request Successful</fullName>
        <actions>
            <name>After_App_Request_Marathon</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Fleet_Data_Form_Sent</name>
            <type>Task</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Opportunity.Error_Log__c</field>
            <operation>startsWith</operation>
            <value>Success</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.SourceSystem__c</field>
            <operation>equals</operation>
            <value>Echosigned</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Program_Name__c</field>
            <operation>startsWith</operation>
            <value>Marathon</value>
        </criteriaItems>
        <description>When Error Log from Siebel indicates &quot;Success&quot; and created from Echosign and Marathon, sends Fleet Data Form to signer and completes a task.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Meijer App Request Successful</fullName>
        <actions>
            <name>After_App_Request_Meijer_successful_email_App_Signer_with_Data_Form</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Fleet_Data_Form_Sent</name>
            <type>Task</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Opportunity.Error_Log__c</field>
            <operation>startsWith</operation>
            <value>Success: O</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.SourceSystem__c</field>
            <operation>equals</operation>
            <value>Echosigned</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Program_Name__c</field>
            <operation>startsWith</operation>
            <value>Meijer</value>
        </criteriaItems>
        <description>When Error Log from Siebel indicates &quot;Success&quot; and created from Echosign and Meijer, sends Fleet Data Form to signer and completes a task.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Murphy App Request Successful</fullName>
        <actions>
            <name>After_App_Request_Murphy</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Fleet_Data_Form_Sent</name>
            <type>Task</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Opportunity.Error_Log__c</field>
            <operation>startsWith</operation>
            <value>Success</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.SourceSystem__c</field>
            <operation>equals</operation>
            <value>Echosigned</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Program_Name__c</field>
            <operation>startsWith</operation>
            <value>Murphy</value>
        </criteriaItems>
        <description>When Error Log from Siebel indicates &quot;Success&quot; and created from Echosign and Murphy, sends Fleet Data Form to signer and completes a task.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>NA Sales Opp Settlement Changed</fullName>
        <actions>
            <name>Calculate_Commission</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(
  Record_Type_Name__c = &apos;MasterCard&apos;,
  /*
  have to use Role Name because object reference limits prevent use of Profile Name
  */
  Owner.UserRole.DeveloperName = &apos;Strategic_Sales_Manager_Virtual_NA&apos;,
  OR(
    AND(
      ISNEW(),
      Annual_Settlement_Value__c &gt; 0
      ),
    ISCHANGED(Annual_Settlement_Value__c)
  )
)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>New Opportunity Task</fullName>
        <actions>
            <name>New_Opportunity_Assigned_to_You</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <description>Send a Task to the Opportunity Owner when someone else assigns them an Opportunity.</description>
        <formula>AND(CreatedById &lt;&gt; OwnerId,  CONTAINS(CreatedBy.Profile.Name,&quot;IS Sales&quot; ))</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>New Virtual EU Sale</fullName>
        <actions>
            <name>New_Sale_Finance</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>New_Sale_RM</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>All Wex Europe record types</description>
        <formula>AND(
  OR(
    $RecordType.Name = &apos;CP CurrencyCard MTC MC&apos;,
    $RecordType.Name = &apos;CP CurrencyCard WL MC&apos;,
    $RecordType.Name = &apos;CP CurrencyCard WL Visa&apos;,
    $RecordType.Name = &apos;CP Expense UTB Consumer&apos;, 
    $RecordType.Name = &apos;CP Bespoke&apos;,
    $RecordType.Name = &apos;CorporatePay&apos;,
    $RecordType.Name = &apos;CP Disbursement&apos;,
    $RecordType.Name = &apos;CP Expense Crew&apos;,
    $RecordType.Name = &apos;CP Expense General Expense&apos;,
    $RecordType.Name = &apos;CP Expense Petty Cash&apos;,
    $RecordType.Name = &apos;CP Expense Platform&apos;,
    $RecordType.Name = &apos;CP Expense Tour&apos;,
    $RecordType.Name = &apos;CP Expense Transport and Haulage&apos;,
    $RecordType.Name = &apos;CP Expense UTB Corporate&apos;,
    $RecordType.Name = &apos;CP TourCard&apos;, 
    $RecordType.Name = &apos;CP Virtual Credit&apos;,
    $RecordType.Name = &apos;CP Virtual Prepaid MC&apos;,
    $RecordType.Name = &apos;CP Virtual Prepaid VE&apos;,
    $RecordType.Name = &apos;CP Virtual Debit MC&apos;,
    $RecordType.Name = &apos;CP Virtual All In One&apos;
  ),
  NOT(TEXT(Type) = &apos;Existing Customer - Administration&apos;),
  OR(
    /* Newly created opportunities, which are won */
    AND(
      ISNEW(),
      Probability = 1
    ),
    /* Stage moved from open to won */
    AND(
      PRIORVALUE(Probability) &lt; 1,
      Probability = 1
    )
  )
)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>New Virtual Opportunity</fullName>
        <active>true</active>
        <formula>OR(
$RecordType.Name = &apos;CP_Virtual_Credit&apos;, 
$RecordType.Name = &apos;CP_Virtual_Prepaid_MC&apos;, 
$RecordType.Name = &apos;CP_Virtual_Prepaid_VE&apos;, 
$RecordType.Name = &apos;CP_Virtual_Debit_MC&apos;, 
$RecordType.Name = &apos;CP_Virtual_All_In_One&apos; 
)</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Opp Account Name%2C Program%2C Coupon Code</fullName>
        <actions>
            <name>Account_Name_Program_Coupon_Code</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.CreatedDate</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Captures searchable info from Lead and from opp</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Opportunity - Submitted Assessment DateTime</fullName>
        <actions>
            <name>Opportunity_Submitted_Assessment_to_Now</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Application_Status__c</field>
            <operation>equals</operation>
            <value>Ready for Assessment</value>
        </criteriaItems>
        <description>When the Application Status is changed to &quot;Ready for Assessment&quot;, set the field &quot;Submitted For Assessment Date/Time&quot; to the current time.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Opportunity Close Date Changed</fullName>
        <actions>
            <name>Opportunity_Close_Date_Changed</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.CloseDate</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Opportunity Close Date Set %2F Changed</fullName>
        <active>false</active>
        <description>Virtual Record Types Only</description>
        <formula>AND(

  OR(
    /* uses Record Type Name label not developer name
     */
    $RecordType.Name = &apos;MasterCard&apos;,

    $RecordType.Name = &apos;CP CurrencyCard MTC MC&apos;, 
    $RecordType.Name = &apos;CP CurrencyCard WL MC&apos;, 
    $RecordType.Name = &apos;CP CurrencyCard WL Visa&apos;, 
    $RecordType.Name = &apos;CP Expense UTB Consumer&apos;, 

    $RecordType.Name = &apos;CP Bespoke&apos;,
    $RecordType.Name = &apos;CorporatePay&apos;, 
    $RecordType.Name = &apos;CP Disbursement&apos;, 
    $RecordType.Name = &apos;CP Expense Crew&apos;, 
    $RecordType.Name = &apos;CP Expense General Expense&apos;, 
    $RecordType.Name = &apos;CP Expense Petty Cash&apos;, 
    $RecordType.Name = &apos;CP Expense Platform&apos;, 
    $RecordType.Name = &apos;CP Expense Tour&apos;, 
    $RecordType.Name = &apos;CP Expense Transport and Haulage&apos;, 
    $RecordType.Name = &apos;CP Expense UTB Corporate&apos;, 
    $RecordType.Name = &apos;CP TourCard&apos;, 

    $RecordType.Name = &apos;CP Virtual Credit&apos;,
    $RecordType.Name = &apos;CP Virtual Prepaid MC&apos;, 
    $RecordType.Name = &apos;CP Virtual Prepaid VE&apos;,
    $RecordType.Name = &apos;CP Virtual Debit MC&apos;,
    $RecordType.Name = &apos;CP Virtual All In One&apos; 
  ),

  OR(
    AND(
      ISNEW(),
      NOT(ISBLANK(CloseDate))
      ),
    AND(
      ISCHANGED(CloseDate),
      NOT(ISBLANK(CloseDate))
      )
    )
)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Opportunity Contact Addresses</fullName>
        <actions>
            <name>Account_Billing_City_to_Opp</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Account_Billing_State_to_Opp</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Account_Billing_Street_to_Opp</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Account_Billing_Zip_to_Opp</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Account_Country_to_Opp</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Account_Shipping_City_to_Opp</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Account_Shipping_State_to_Opp</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Account_Shipping_Street_to_Opp</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Account_Shipping_Zip_to_Opp</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Billing_Country_to_Opp</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.CreatedById</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Opportunity Created %2F Edited</fullName>
        <actions>
            <name>Populate_Interchange_Rate</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>All WE record types.</description>
        <formula>OR(
/*Currencies */
RecordTypeId = &apos;012700000005r08&apos;, 
RecordTypeId = &apos;012700000005qzy&apos;, 
RecordTypeId = &apos;012700000005r0D&apos;, 

/* Bespoke, TourCard, Disbursement */
RecordTypeId = &apos;012700000005qia&apos;, 
RecordTypeId = &apos;012700000005qid&apos;,
RecordTypeId = &apos;012700000005qib&apos;, 

/* Expense - Crew, General, Petty Cash, Platform, Tour, Transport &amp; Haulage, UTB Consumer, UTB Corporate */ 
RecordTypeId = &apos;012700000005qic&apos;,
RecordTypeId = &apos;012700000005rA9&apos;,
RecordTypeId = &apos;012700000005rAA&apos;,
RecordTypeId = &apos;012700000005rAB&apos;,
RecordTypeId = &apos;012700000005qzo&apos;,
RecordTypeId = &apos;012700000005rAC&apos;,
RecordTypeId = &apos;012700000005r0I&apos;,
RecordTypeId = &apos;012700000005r0N&apos;,
RecordTypeId = &apos;012700000005qzt&apos;,

/* Virtual Credit, Virtual Prepaid MC, Virtual Debit MC */ 
RecordTypeId = &apos;012700000005qie&apos;,
RecordTypeId = &apos;012700000005qif&apos;,
RecordTypeId = &apos;012700000005wUG&apos;,

/* Virtual Prepaid VE, Virtual All In One */
RecordTypeId = &apos;012700000005qig&apos;,
RecordTypeId = &apos;012700000005xWw&apos;

)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Opportunity Created %2F Edited - Non Debit</fullName>
        <active>false</active>
        <description>All Wex Europe record types apart from Virtual Prepaid VE, Virtual Debit MC, Virtual All In One &amp; Bespoke.</description>
        <formula>/* Virtual Debit calculations triggered by separate workflow */


OR(
RecordTypeId = &apos;012700000005r08&apos;, 
RecordTypeId = &apos;012700000005qzy&apos;, 
RecordTypeId = &apos;012700000005r0D&apos;, 
RecordTypeId = &apos;012700000005r0N&apos;, 
 
RecordTypeId = &apos;012700000005qid&apos;,
RecordTypeId = &apos;012700000005qib&apos;, 
RecordTypeId = &apos;012700000005qic&apos;, 
RecordTypeId = &apos;012700000005rA9&apos;, 
RecordTypeId = &apos;012700000005rAA&apos;, 
RecordTypeId = &apos;012700000005rAB&apos;, 
RecordTypeId = &apos;012700000005qzo&apos;, 
RecordTypeId = &apos;012700000005rAC&apos;, 
RecordTypeId = &apos;012700000005r0I&apos;, 
RecordTypeId = &apos;012700000005qzt&apos;,
RecordTypeId = &apos;012700000005qie&apos;, 
RecordTypeId = &apos;012700000005qif&apos;
)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Opportunity Naming Convention</fullName>
        <actions>
            <name>Opportunity_Naming_Convention</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Opportunity.CreatedDate</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>Acceptance,Channel GPS,Channel Partner,Channel Product,Factoring,Fleet Card,Permits</value>
        </criteriaItems>
        <description>Append the opportunity with the company name</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Opportunity Stage 4</fullName>
        <actions>
            <name>Opportunity_Stage_4_Alert</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>All Wex Europe record types, apart from Currency &amp; Bespoke</description>
        <formula>/* maximum number of object references reached on opportunity so not possible to check owner based on Profile ID */


AND(

AND(
NOT(Owner_Last_Name__c = &quot;Williams&quot;),
NOT(Owner_Last_Name__c = &quot;Frebet&quot;),
NOT(Owner_Last_Name__c = &quot;Sutton&quot;),
NOT(Owner_Last_Name__c = &quot;Sangha&quot;)
),

NOT(TEXT(Type) = &apos;Existing Customer - Administration&apos;),

ISCHANGED(StageName),

OR(
ISPICKVAL(PRIORVALUE(StageName), &quot;1) Qualified&quot;),
ISPICKVAL(PRIORVALUE(StageName), &quot;2) Engaged&quot;),
ISPICKVAL(PRIORVALUE(StageName), &quot;3) Evaluating&quot;),
ISPICKVAL(PRIORVALUE(StageName), &quot;Closed/Lost&quot;)
),

OR(
TEXT(StageName) = &quot;4) Negotiating&quot;,
TEXT(StageName) = &quot;5) Signed&quot;,
TEXT(StageName) = &quot;6) Service Implementation&quot;,
TEXT(StageName) = &quot;7) Project Completed&quot;
),

OR(

OR(

/* Virtual Credit, Virtual Prepaid MC, Virtual Debit MC */ 
RecordTypeId = &apos;012700000005qie&apos;,
RecordTypeId = &apos;012700000005qif&apos;,
RecordTypeId = &apos;012700000005wUG&apos;,

/* Virtual Prepaid VE, Virtual All In One */
RecordTypeId = &apos;012700000005qig&apos;,
RecordTypeId = &apos;012700000005xWw&apos;
),

AND(

(Annual_Settlement_Value__c &gt;= 3000000),

OR(
/* Bespoke, TourCard, Disbursement, Expense - Crew, General, Petty Cash, Platform, Tour, Transport &amp; Haulage,  UTB Corporate */
RecordTypeId = &apos;012700000005qia&apos;,
RecordTypeId = &apos;012700000005qid&apos;, 
RecordTypeId = &apos;012700000005qib&apos;, 
RecordTypeId = &apos;012700000005qic&apos;, 
RecordTypeId = &apos;012700000005rA9&apos;, 
RecordTypeId = &apos;012700000005rAA&apos;, 
RecordTypeId = &apos;012700000005rAB&apos;, 
RecordTypeId = &apos;012700000005qzo&apos;, 
RecordTypeId = &apos;012700000005rAC&apos;, 
RecordTypeId = &apos;012700000005r0I&apos;, 
RecordTypeId = &apos;012700000005qzt&apos;)
))

)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Opportunity%3A EcoFlaps Send to vendor</fullName>
        <actions>
            <name>Opportunity_Send_to_EcoFlaps</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Opportunity_Move_To_Sent_To_Vendor</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>Truckers - Opportunity</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.TB2B_Stage__c</field>
            <operation>equals</operation>
            <value>Ready to Send to Vendor</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.TB2B_Product_Interest__c</field>
            <operation>equals</operation>
            <value>EcoFlaps</value>
        </criteriaItems>
        <description>An TB2B EcoFlaps opportunity that is ready for the vendor</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Opportunity%3A FUEL Qualification Oppty</fullName>
        <actions>
            <name>Opportunity_Fuel_Qualification_Opp</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>Truckers - Opportunity</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.TB2B_Stage__c</field>
            <operation>equals</operation>
            <value>New,Sent Fuel Program Info</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.TB2B_Product_Interest__c</field>
            <operation>equals</operation>
            <value>Fuel,DAT/FTS Lead,FTS Fuel,MPG</value>
        </criteriaItems>
        <description>TB2B notify fuel specialist when a new oppty is available.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Opportunity%3A Fuel Incomplete Info stage</fullName>
        <actions>
            <name>Fuel_Enrollment_Issues</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>Truckers - Opportunity</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.TB2B_Stage__c</field>
            <operation>equals</operation>
            <value>Incomplete Fuel Form - Needs Attention</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.TB2B_Product_Interest__c</field>
            <operation>equals</operation>
            <value>Fuel</value>
        </criteriaItems>
        <description>TB2B wfr</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Opportunity%3A Fuel Sent Program Info</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>Truckers - Opportunity</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.TB2B_Stage__c</field>
            <operation>equals</operation>
            <value>Sent Fuel Program Info,Pending Member</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.TB2B_Product_Interest__c</field>
            <operation>equals</operation>
            <value>Fuel</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Private_Label_Program__c</field>
            <operation>notEqual</operation>
            <value>ATA</value>
        </criteriaItems>
        <description>TB2B wfr</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Opportunity_Fuel_Sent_Program_Detached</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Opportunity.CreatedDate</offsetFromField>
            <timeLength>45</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>Opportunity_Fuel_Sent_Program_Info</name>
                <type>Alert</type>
            </actions>
            <actions>
                <name>WF_Rule_Email_Sent</name>
                <type>Task</type>
            </actions>
            <offsetFromField>Opportunity.LastModifiedDate</offsetFromField>
            <timeLength>10</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Opportunity%3A Fuel Sent Program Info OLD Ones</fullName>
        <actions>
            <name>Opportunity_Fuel_Sent_Program_Info</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>WF_Rule_Email_Sent</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>Truckers - Opportunity</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.TB2B_Stage__c</field>
            <operation>equals</operation>
            <value>Sent Fuel Program Info,Pending Member</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.TB2B_Product_Interest__c</field>
            <operation>equals</operation>
            <value>Fuel</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.CreatedDate</field>
            <operation>lessThan</operation>
            <value>1/1/2016</value>
        </criteriaItems>
        <description>TB2B wfr</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Opportunity%3A Gold Credit Approved</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>Truckers - Opportunity</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.TB2B_Stage__c</field>
            <operation>equals</operation>
            <value>Credit Approved</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.TB2B_Product_Interest__c</field>
            <operation>equals</operation>
            <value>Gold</value>
        </criteriaItems>
        <description>TB2B Gold opportunity stage = credit approved.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Gold_Opp_12_week_follow_up</name>
                <type>Task</type>
            </actions>
            <timeLength>90</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>Opportunity_Gold_Credit_Approved</name>
                <type>Alert</type>
            </actions>
            <actions>
                <name>WF_Rule_Email_Sent</name>
                <type>Task</type>
            </actions>
            <timeLength>10</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>Gold_Opp_4_week_follow_up</name>
                <type>Task</type>
            </actions>
            <timeLength>30</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>Gold_Opp_2_week_follow_up</name>
                <type>Task</type>
            </actions>
            <timeLength>14</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Opportunity%3A Gold Credit Card on File</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>Truckers - Opportunity</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.TB2B_Stage__c</field>
            <operation>equals</operation>
            <value>Credit Card Stored/RTB</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.TB2B_Product_Interest__c</field>
            <operation>equals</operation>
            <value>Gold</value>
        </criteriaItems>
        <description>TB2B Gold opportunity stage = credit card stored/RTB.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Gold_Opp_4_week_follow_up</name>
                <type>Task</type>
            </actions>
            <timeLength>30</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>Gold_Opp_12_week_follow_up</name>
                <type>Task</type>
            </actions>
            <timeLength>90</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>Opportunity_Gold_Credit_card_on_file</name>
                <type>Alert</type>
            </actions>
            <actions>
                <name>WF_Rule_Email_Sent</name>
                <type>Task</type>
            </actions>
            <timeLength>10</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>Gold_Opp_2_week_follow_up</name>
                <type>Task</type>
            </actions>
            <timeLength>14</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Opportunity%3A Gold Quote Sent</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>Truckers - Opportunity</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.TB2B_Stage__c</field>
            <operation>equals</operation>
            <value>Quote Sent</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.TB2B_Product_Interest__c</field>
            <operation>equals</operation>
            <value>Gold</value>
        </criteriaItems>
        <description>TB2B Gold opportunity stage = quote sent</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Opportunity_Gold_Pricing_Followup</name>
                <type>Alert</type>
            </actions>
            <actions>
                <name>WF_Rule_Email_Sent</name>
                <type>Task</type>
            </actions>
            <timeLength>7</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>Gold_Quote_Follow_up</name>
                <type>Task</type>
            </actions>
            <timeLength>30</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Opportunity%3A Gold Sent Info Only Followup</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.TB2B_Stage__c</field>
            <operation>equals</operation>
            <value>Sent Info Only for now</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.TB2B_Product_Interest__c</field>
            <operation>equals</operation>
            <value>Gold</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>Truckers - Opportunity</value>
        </criteriaItems>
        <description>TB2B WFR</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Opportunity_Sent_Info_Followup</name>
                <type>Task</type>
            </actions>
            <timeLength>30</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>Opportunity_Falloff</name>
                <type>FieldUpdate</type>
            </actions>
            <timeLength>60</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>Sent_Gold_Info_Only_for_NOw</name>
                <type>Alert</type>
            </actions>
            <actions>
                <name>WF_Rule_Email_Sent</name>
                <type>Task</type>
            </actions>
            <timeLength>3</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Opportunity%3A Gold closed won</fullName>
        <actions>
            <name>Opportunity_Gold_ClosedWon</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>WF_Rule_Email_Sent</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2 AND 3 AND 4 AND 5</booleanFilter>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>Truckers - Opportunity</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>5) Signed</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.TB2B_Product_Interest__c</field>
            <operation>equals</operation>
            <value>Gold</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Fleet_Size__c</field>
            <operation>greaterThan</operation>
            <value>1</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.TB2B_Stage__c</field>
            <operation>equals</operation>
            <value>Closed Won</value>
        </criteriaItems>
        <description>TB2B when a Gold opportunity is closed won</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Gold_6_mo_Post_Sale_follow_up</name>
                <type>Task</type>
            </actions>
            <timeLength>180</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>Opportunity_Gold_ClosedWon60day</name>
                <type>Alert</type>
            </actions>
            <timeLength>60</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>Gold_Post_Sale_follow_up</name>
                <type>Task</type>
            </actions>
            <timeLength>75</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Opportunity%3A Gold closed won1truck</fullName>
        <actions>
            <name>Opportunity_Gold_ClosedWon</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>WF_Rule_Email_Sent</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>Truckers - Opportunity</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>5) Signed</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Fleet_Size__c</field>
            <operation>equals</operation>
            <value>1</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.TB2B_Product_Interest__c</field>
            <operation>equals</operation>
            <value>Gold</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.TB2B_Stage__c</field>
            <operation>equals</operation>
            <value>Closed Won</value>
        </criteriaItems>
        <description>TB2B when a Gold opportunity is closed won</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Gold_6_mo_Post_Sale_follow_up</name>
                <type>Task</type>
            </actions>
            <offsetFromField>Opportunity.CloseDate</offsetFromField>
            <timeLength>180</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Opportunity%3A In-Touch ELD Ready For Vendor</fullName>
        <actions>
            <name>Opportunity_Send_to_InTouch</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Opportunity_Move_To_Sent_To_Vendor</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>Truckers - Opportunity</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.TB2B_Stage__c</field>
            <operation>equals</operation>
            <value>Ready to Send to Vendor</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.TB2B_Product_Interest__c</field>
            <operation>equals</operation>
            <value>In-Touch ELD</value>
        </criteriaItems>
        <description>In-Touch ELD TB2B opportunity that is ready for the vendor</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Opportunity%3A New Gold Opp</fullName>
        <actions>
            <name>Opportunity_Gold_New_Opps</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>Truckers - Opportunity</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.TB2B_Stage__c</field>
            <operation>equals</operation>
            <value>New</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.TB2B_Product_Interest__c</field>
            <operation>equals</operation>
            <value>Gold</value>
        </criteriaItems>
        <description>TB2B wfr when stage is New notice goes to TS.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>X2_week_Opportunity_Follow_up</name>
                <type>Task</type>
            </actions>
            <timeLength>14</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Opportunity%3A OCC send to vendor</fullName>
        <actions>
            <name>Opportunity_OCC</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Opportunity_Move_To_Sent_To_Vendor</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>Truckers - Opportunity</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.TB2B_Product_Interest__c</field>
            <operation>equals</operation>
            <value>OCC Factoring</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.TB2B_Stage__c</field>
            <operation>equals</operation>
            <value>Ready to Send to Vendor</value>
        </criteriaItems>
        <description>Opportunity: TB2B OCC send to vendor</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Opportunity%3A Pegasus ELD Ready For Vendor</fullName>
        <actions>
            <name>Opportunity_Send_to_Pegasus</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Opportunity_Move_To_Sent_To_Vendor</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>Truckers - Opportunity</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.TB2B_Stage__c</field>
            <operation>equals</operation>
            <value>Ready to Send to Vendor</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.TB2B_Product_Interest__c</field>
            <operation>equals</operation>
            <value>Pegasus ELD</value>
        </criteriaItems>
        <description>Pegasus ELD TB2B opportunity that is ready for the vendor</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Opportunity%3A RoadSquad</fullName>
        <actions>
            <name>Sends_Email_Notification_For_RoadSquad_Opportunity</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Opportunity_Move_To_Sent_To_Vendor</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>Truckers - Opportunity</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.TB2B_Stage__c</field>
            <operation>equals</operation>
            <value>Ready to Send to Vendor</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.TB2B_Product_Interest__c</field>
            <operation>equals</operation>
            <value>RoadSquad</value>
        </criteriaItems>
        <description>Tb2b WFR</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Opportunity%3A Roadside Masters Ready For Vendor</fullName>
        <actions>
            <name>Opportunity_Send_to_Roadside_Masters</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Opportunity_Move_To_Sent_To_Vendor</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>Truckers - Opportunity</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.TB2B_Stage__c</field>
            <operation>equals</operation>
            <value>Ready to Send to Vendor</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.TB2B_Product_Interest__c</field>
            <operation>equals</operation>
            <value>Roadside Masters</value>
        </criteriaItems>
        <description>An TB2B Roadside Masters opportunity that is ready for the vendor</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Opportunity%3A Sent Info Only Followup</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.TB2B_Stage__c</field>
            <operation>equals</operation>
            <value>Sent Info Only for now</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.TB2B_Product_Interest__c</field>
            <operation>equals</operation>
            <value>Prophesy,BestPass,Castrol,Sprint,Triumph Business Capital,Marquette Funding,OCC Factoring,AT&amp;T FleetComplete,Office360,Roadside Masters,EcoFlaps</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>Truckers - Opportunity</value>
        </criteriaItems>
        <description>TB2B WFR</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Opportunity_Sent_Info_Only_Non_Fuel_Tires</name>
                <type>Alert</type>
            </actions>
            <actions>
                <name>WF_Rule_Email_Sent</name>
                <type>Task</type>
            </actions>
            <timeLength>3</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>Opportunity_Sent_Info_Followup</name>
                <type>Task</type>
            </actions>
            <timeLength>30</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>Opportunity_Falloff</name>
                <type>FieldUpdate</type>
            </actions>
            <timeLength>45</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Opportunity%3A Sent to Vendor Follow up</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>Truckers - Opportunity</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.TB2B_Stage__c</field>
            <operation>equals</operation>
            <value>Sent to Vendor</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.TB2B_Product_Interest__c</field>
            <operation>notEqual</operation>
            <value>Pilot,EFS/Fleet One/T-Chek/Edge,AT&amp;T FleetComplete,In-Touch ELD,Pegasus ELD,Sprint</value>
        </criteriaItems>
        <description>TB2B emails &amp; tasks to follow up on various opportunities sent to vendors to ensure follow up.</description>
        <triggerType>onCreateOnly</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Opportunity_Sent_Opps_Follow_up</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Opportunity.CreatedDate</offsetFromField>
            <timeLength>7</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>Opportunity_Follow_up</name>
                <type>Task</type>
            </actions>
            <offsetFromField>Opportunity.CreatedDate</offsetFromField>
            <timeLength>45</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>X2_week_Opportunity_Follow_up</name>
                <type>Task</type>
            </actions>
            <offsetFromField>Opportunity.CreatedDate</offsetFromField>
            <timeLength>14</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Opportunity%3AAT%26T Ready For Vendor</fullName>
        <actions>
            <name>Opportunity_Send_to_AT_T</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Opportunity_Move_To_Sent_To_Vendor</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>Truckers - Opportunity</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.TB2B_Stage__c</field>
            <operation>equals</operation>
            <value>Ready to Send to Vendor</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.TB2B_Product_Interest__c</field>
            <operation>equals</operation>
            <value>AT&amp;T FleetComplete</value>
        </criteriaItems>
        <description>An AT&amp;T TB2B opportunity that is ready for the vendor</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Opportunity%3AAT%26T Wireless Ready For Vendor</fullName>
        <actions>
            <name>Opportunity_Send_to_AT_T_Wireless</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Opportunity_Move_To_Sent_To_Vendor</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>Truckers - Opportunity</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.TB2B_Stage__c</field>
            <operation>equals</operation>
            <value>Ready to Send to Vendor</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.TB2B_Product_Interest__c</field>
            <operation>equals</operation>
            <value>AT&amp;T Wireless</value>
        </criteriaItems>
        <description>An AT&amp;T wireless TB2B opportunity that is ready for the vendor</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Opportunity%3AB2B Fuel Card Created</fullName>
        <actions>
            <name>B2B_Fuel_Card_Rev_Calc</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>Truckers - Opportunity</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.TB2B_Stage__c</field>
            <operation>equals</operation>
            <value>New,Qualification,Sent Fuel Program Info,Closed Won</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.TB2B_Product_Interest__c</field>
            <operation>equals</operation>
            <value>B2B Fuel Card</value>
        </criteriaItems>
        <description>TB2B FTS opportunity that is ready for the vendor</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Opportunity%3ABestPass Ready For Vendor</fullName>
        <actions>
            <name>Opportunity_Send_to_BestPass</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Opportunity_Move_To_Sent_To_Vendor</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>Truckers - Opportunity</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.TB2B_Stage__c</field>
            <operation>equals</operation>
            <value>Ready to Send to Vendor</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.TB2B_Product_Interest__c</field>
            <operation>equals</operation>
            <value>BestPass</value>
        </criteriaItems>
        <description>An TB2B Best Pass opportunity that is ready for the vendor</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Opportunity%3ACastrol Sent To Vendor</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>Truckers - Opportunity</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.TB2B_Stage__c</field>
            <operation>equals</operation>
            <value>Ready to Send to Vendor</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.TB2B_Product_Interest__c</field>
            <operation>equals</operation>
            <value>Castrol</value>
        </criteriaItems>
        <description>An TB2B Castrol opportunity that has been sent to the vendor</description>
        <triggerType>onCreateOnly</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>X2_week_Opportunity_Follow_up</name>
                <type>Task</type>
            </actions>
            <offsetFromField>Opportunity.CreatedDate</offsetFromField>
            <timeLength>14</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Opportunity%3ADAT FTS Ready For Vendor</fullName>
        <actions>
            <name>Opportunity_Send_to_DAT_FTS</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Opportunity_FTS_Calculate_Amount</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Opportunity_FUEL_calc_Gal_Qty</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Opportunity_Move_To_Sent_To_Vendor</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>Truckers - Opportunity</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.TB2B_Stage__c</field>
            <operation>equals</operation>
            <value>Ready to Send to Vendor</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.TB2B_Product_Interest__c</field>
            <operation>equals</operation>
            <value>DAT/FTS Lead</value>
        </criteriaItems>
        <description>An TB2B  FTS opportunity that is ready for the vendor</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Opportunity%3AEFS Ready For Vendor</fullName>
        <actions>
            <name>Opportunity_Send_to_EFS_FleetOne_Edge</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Opportunity_Fuel_Calculate_Amount</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Opportunity_Move_To_Sent_To_Vendor</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>Truckers - Opportunity</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.TB2B_Stage__c</field>
            <operation>equals</operation>
            <value>Ready to Send to Vendor</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.TB2B_Product_Interest__c</field>
            <operation>equals</operation>
            <value>EFS/Fleet One/T-Chek/Edge</value>
        </criteriaItems>
        <description>An TB2B EFS opportunity that is ready for the vendor</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Opportunity%3AFTS Ready For Vendor</fullName>
        <actions>
            <name>Opportunity_Send_to_FTS</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Opportunity_FTS_Calculate_Amount</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Opportunity_FUEL_calc_Gal_Qty</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Opportunity_Move_To_Sent_To_Vendor</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>Truckers - Opportunity</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.TB2B_Stage__c</field>
            <operation>equals</operation>
            <value>Ready to Send to Vendor</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.TB2B_Product_Interest__c</field>
            <operation>equals</operation>
            <value>FTS Fuel</value>
        </criteriaItems>
        <description>An TB2B FTS opportunity that is ready for the vendor</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Opportunity%3AFuel Black</fullName>
        <actions>
            <name>Opportunity_Assign_Ian_Wilkinson</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Opportunity_FUEL_calc_Gal_Qty</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Opportunity_Fuel_Calculate_Amount</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>Truckers - Opportunity</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Region__c</field>
            <operation>contains</operation>
            <value>Black</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.TB2B_Product_Interest__c</field>
            <operation>equals</operation>
            <value>Fuel,DAT/FTS Lead,FLIP,FTS Fuel,MPG,My Rewards</value>
        </criteriaItems>
        <description>A TB2B Black region fuel opportunity</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Opportunity%3AFuel Burgundy</fullName>
        <actions>
            <name>Opportunity_Assign_Adam_Aurich</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Opportunity_FUEL_calc_Gal_Qty</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Opportunity_Fuel_Calculate_Amount</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>Truckers - Opportunity</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Region__c</field>
            <operation>contains</operation>
            <value>Burgundy</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.TB2B_Product_Interest__c</field>
            <operation>equals</operation>
            <value>Fuel,DAT/FTS Lead,FLIP,FTS Fuel,MPG,My Rewards</value>
        </criteriaItems>
        <description>A TB2B Burgundy region fuel opportunity</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Opportunity%3AFuel Closed Won</fullName>
        <actions>
            <name>Opportunity_Send_Fuel_Enrollment_Welcome</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2 AND 3 AND 4</booleanFilter>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>Truckers - Opportunity</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.TB2B_Stage__c</field>
            <operation>equals</operation>
            <value>Closed Won</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Private_Label_Program__c</field>
            <operation>notEqual</operation>
            <value>ATA,Interstate Capital,Fleet One EDGE</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.TB2B_Product_Interest__c</field>
            <operation>equals</operation>
            <value>Fuel</value>
        </criteriaItems>
        <description>Whenever a TB2B fuel opportunity is closed.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>X3_Month_Fuel_Check_up</name>
                <type>Task</type>
            </actions>
            <offsetFromField>Opportunity.CloseDate</offsetFromField>
            <timeLength>60</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Opportunity%3AFuel Closed Won6mo</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>Truckers - Opportunity</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.TB2B_Product_Interest__c</field>
            <operation>equals</operation>
            <value>Fuel</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.IsWon</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>Whenever a TB2B fuel opportunity is closed.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>X6_Mo_fuel_followup</name>
                <type>Task</type>
            </actions>
            <offsetFromField>Opportunity.CloseDate</offsetFromField>
            <timeLength>180</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Opportunity%3AFuel Closed WonwithSavings</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>Truckers - Opportunity</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>5) Signed</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.TB2B_Product_Interest__c</field>
            <operation>equals</operation>
            <value>Fuel</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Last_Savings_Amount__c</field>
            <operation>greaterThan</operation>
            <value>USD 4.99</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Private_Label_Program__c</field>
            <operation>notEqual</operation>
            <value>Fleet One EDGE</value>
        </criteriaItems>
        <description>TB2B wfr Whenever a fuel opportunity is closed and they have begun earning discounts</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Opportunity_Fuelclosedwon_Savings</name>
                <type>Alert</type>
            </actions>
            <actions>
                <name>WF_Rule_Email_Sent</name>
                <type>Task</type>
            </actions>
            <offsetFromField>Opportunity.CloseDate</offsetFromField>
            <timeLength>90</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Opportunity%3AFuel Gray</fullName>
        <actions>
            <name>Opportunity_Assign_Tyler_Douglass</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Opportunity_FUEL_calc_Gal_Qty</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Opportunity_Fuel_Calculate_Amount</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>Truckers - Opportunity</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Region__c</field>
            <operation>contains</operation>
            <value>Grey</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.TB2B_Product_Interest__c</field>
            <operation>equals</operation>
            <value>Fuel,DAT/FTS Lead,FLIP,FTS Fuel,MPG,My Rewards</value>
        </criteriaItems>
        <description>A TB2B Gray region fuel opportunity</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Opportunity%3AFuel Red</fullName>
        <actions>
            <name>Opportunity_Assign_Jennifer_Nelson</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Opportunity_FUEL_calc_Gal_Qty</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Opportunity_Fuel_Calculate_Amount</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>Truckers - Opportunity</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Region__c</field>
            <operation>contains</operation>
            <value>Red</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.TB2B_Product_Interest__c</field>
            <operation>equals</operation>
            <value>Fuel,DAT/FTS Lead,FLIP,FTS Fuel,MPG,My Rewards</value>
        </criteriaItems>
        <description>A TB2B Red region fuel opportunity</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Opportunity%3AFuel White</fullName>
        <actions>
            <name>Opportunity_Assign_Dawna_Cole</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Opportunity_FUEL_calc_Gal_Qty</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Opportunity_Fuel_Calculate_Amount</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>Truckers - Opportunity</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Region__c</field>
            <operation>contains</operation>
            <value>White</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.TB2B_Product_Interest__c</field>
            <operation>equals</operation>
            <value>Fuel,DAT/FTS Lead,FLIP,FTS Fuel,MPG,My Rewards</value>
        </criteriaItems>
        <description>A TB2B White region fuel opportunity</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Opportunity%3AGold 1800 Sweeper</fullName>
        <actions>
            <name>Opportunity_Assign_Shawn_Galliett</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Opportunity_Gold_Calculate_Amount</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>Truckers - Opportunity</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Private_Label_Program__c</field>
            <operation>equals</operation>
            <value>1800 Sweeper</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.TB2B_Product_Interest__c</field>
            <operation>equals</operation>
            <value>Gold</value>
        </criteriaItems>
        <description>A TB2B Gold opportunity for 1800 Sweeper</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Opportunity%3AGold Black</fullName>
        <actions>
            <name>Opportunity_Assign_Shawn_Galliett</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Opportunity_Gold_Calculate_Amount</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>Truckers - Opportunity</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Region__c</field>
            <operation>equals</operation>
            <value>Black</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.TB2B_Product_Interest__c</field>
            <operation>equals</operation>
            <value>Gold</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Private_Label_Program__c</field>
            <operation>notEqual</operation>
            <value>,1800 Sweeper</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.TB2B_Stage__c</field>
            <operation>notEqual</operation>
            <value>Qualification</value>
        </criteriaItems>
        <description>A TB2B Black opportunity in the Gray region</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Opportunity%3AGold Burgundy</fullName>
        <actions>
            <name>Opportunity_Assign_brian_Loveland</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Opportunity_Gold_Calculate_Amount</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>Truckers - Opportunity</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Region__c</field>
            <operation>equals</operation>
            <value>Burgundy</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.TB2B_Product_Interest__c</field>
            <operation>equals</operation>
            <value>Gold</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.TB2B_Stage__c</field>
            <operation>notEqual</operation>
            <value>Qualification</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Private_Label_Program__c</field>
            <operation>notEqual</operation>
            <value>FTS Plus</value>
        </criteriaItems>
        <description>A TB2B Gold opportunity in the Burgundy region</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Opportunity%3AGold FTS</fullName>
        <actions>
            <name>Opportunity_Assign_Ian_Wilkinson</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Opportunity_Gold_Calculate_Amount</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>Truckers - Opportunity</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Private_Label_Program__c</field>
            <operation>equals</operation>
            <value>FTS Plus</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.TB2B_Product_Interest__c</field>
            <operation>equals</operation>
            <value>Gold</value>
        </criteriaItems>
        <description>A TB2B Gold opportunity in the FTS region</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Opportunity%3AGold Gray</fullName>
        <actions>
            <name>Opportunity_Assign_Denise_Lockwood</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Opportunity_Gold_Calculate_Amount</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>Truckers - Opportunity</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Region__c</field>
            <operation>equals</operation>
            <value>Grey</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.TB2B_Product_Interest__c</field>
            <operation>equals</operation>
            <value>Gold</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Private_Label_Program__c</field>
            <operation>notEqual</operation>
            <value>1800 Sweeper,FTS Plus</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.TB2B_Stage__c</field>
            <operation>notEqual</operation>
            <value>Qualification</value>
        </criteriaItems>
        <description>A TB2B Gold opportunity in the Gray region</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Opportunity%3AGold Interstate Capital</fullName>
        <actions>
            <name>Opportunity_Assign_Ian_Wilkinson</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>Truckers - Opportunity</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Private_Label_Program__c</field>
            <operation>equals</operation>
            <value>Interstate Capital</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.TB2B_Product_Interest__c</field>
            <operation>equals</operation>
            <value>Gold</value>
        </criteriaItems>
        <description>A TB2B Gold opportunity for Interstate Capital</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Opportunity%3AGold Qualification OPPS</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>Truckers - Opportunity</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.TB2B_Stage__c</field>
            <operation>equals</operation>
            <value>Qualification</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.TB2B_Product_Interest__c</field>
            <operation>equals</operation>
            <value>Gold</value>
        </criteriaItems>
        <description>TB2B Any opportunity that is in Qualification Stage</description>
        <triggerType>onCreateOnly</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Gold_Program_Attention_Getter</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Opportunity.CreatedDate</offsetFromField>
            <timeLength>20</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>Opportunity_Qualification_stage</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Opportunity.CreatedDate</offsetFromField>
            <timeLength>14</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>REASSIGN_OPP_OWNER</name>
                <type>Task</type>
            </actions>
            <offsetFromField>Opportunity.CreatedDate</offsetFromField>
            <timeLength>90</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Opportunity%3AGold Red</fullName>
        <actions>
            <name>Opportunity_Assign_brian_Loveland</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Opportunity_Gold_Calculate_Amount</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>Truckers - Opportunity</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Region__c</field>
            <operation>equals</operation>
            <value>Red</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.TB2B_Product_Interest__c</field>
            <operation>equals</operation>
            <value>Gold</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Private_Label_Program__c</field>
            <operation>notEqual</operation>
            <value>1800 Sweeper,FTS Plus</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.TB2B_Stage__c</field>
            <operation>notEqual</operation>
            <value>Qualification</value>
        </criteriaItems>
        <description>A TB2B Gold opportunity in the Red region</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Opportunity%3AGold White</fullName>
        <actions>
            <name>Opportunity_Assign_Jonathan_Cosman</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Opportunity_Gold_Calculate_Amount</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>Truckers - Opportunity</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Region__c</field>
            <operation>equals</operation>
            <value>White</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.TB2B_Product_Interest__c</field>
            <operation>equals</operation>
            <value>Gold</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Private_Label_Program__c</field>
            <operation>notEqual</operation>
            <value>1800 Sweeper,FTS Plus</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.TB2B_Stage__c</field>
            <operation>notEqual</operation>
            <value>Qualification</value>
        </criteriaItems>
        <description>A TB2B White opportunity in the Gray region</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Opportunity%3AITG Send To Vendor</fullName>
        <actions>
            <name>Opportunity_Send_ITG_Opportunity</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Opportunity_Move_To_Sent_To_Vendor</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>Truckers - Opportunity</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.TB2B_Stage__c</field>
            <operation>equals</operation>
            <value>Ready to Send to Vendor</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.TB2B_Product_Interest__c</field>
            <operation>equals</operation>
            <value>ITG</value>
        </criteriaItems>
        <description>TB2B ITG opportunity that has been sent to the vendor</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Opportunity%3AImperial Supplies Ready For Vendor</fullName>
        <actions>
            <name>Opportunity_Send_to_Imperial_Supplies</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Opportunity_Move_To_Sent_To_Vendor</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>Truckers - Opportunity</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.TB2B_Stage__c</field>
            <operation>equals</operation>
            <value>Ready to Send to Vendor</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.TB2B_Product_Interest__c</field>
            <operation>equals</operation>
            <value>Imperial Supplies</value>
        </criteriaItems>
        <description>An TB2B Imperial Supplies opportunity that is ready for the vendor</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Opportunity%3AInternational Truck Ready For Vendor</fullName>
        <actions>
            <name>Opportunity_Send_to_International</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Opportunity_Move_To_Sent_To_Vendor</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>Truckers - Opportunity</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.TB2B_Stage__c</field>
            <operation>equals</operation>
            <value>Ready to Send to Vendor</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.TB2B_Product_Interest__c</field>
            <operation>equals</operation>
            <value>International Truck</value>
        </criteriaItems>
        <description>An TB2B International truck opportunity that is ready for the vendor</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Opportunity%3AInternational Used Truck Ready For Vendor</fullName>
        <actions>
            <name>Opportunity_Send_to_International_Used_Trucks</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Opportunity_Move_To_Sent_To_Vendor</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>Truckers - Opportunity</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.TB2B_Stage__c</field>
            <operation>equals</operation>
            <value>Ready to Send to Vendor</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.TB2B_Product_Interest__c</field>
            <operation>equals</operation>
            <value>International Used Trucks</value>
        </criteriaItems>
        <description>A TB2B International used truck opportunity that is ready for the vendor</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Opportunity%3AInterstateFuel Closed Won</fullName>
        <actions>
            <name>Opportunity_Send_Fuel_Enrollment_WelcomeInterstate</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>Truckers - Opportunity</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.TB2B_Product_Interest__c</field>
            <operation>equals</operation>
            <value>Fuel</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Private_Label_Program__c</field>
            <operation>equals</operation>
            <value>Interstate Capital</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>5) Signed</value>
        </criteriaItems>
        <description>Whenever a TB2B fuel opportunity is closed.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>X3_Month_Fuel_Check_up</name>
                <type>Task</type>
            </actions>
            <offsetFromField>Opportunity.CloseDate</offsetFromField>
            <timeLength>60</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>X6_Mo_fuel_followup</name>
                <type>Task</type>
            </actions>
            <offsetFromField>Opportunity.CloseDate</offsetFromField>
            <timeLength>120</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Opportunity%3ALoves Factoring Ready For Vendor</fullName>
        <actions>
            <name>Opportunity_Send_to_Loves_Factoring</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Opportunity_Move_To_Sent_To_Vendor</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>Truckers - Opportunity</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.TB2B_Stage__c</field>
            <operation>equals</operation>
            <value>Ready to Send to Vendor</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.TB2B_Product_Interest__c</field>
            <operation>equals</operation>
            <value>Loves Factoring</value>
        </criteriaItems>
        <description>An TB2B Loves Factoring opportunity that is ready for the vendor</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Opportunity%3AMarquette Ready For Vendor</fullName>
        <actions>
            <name>Opportunity_Send_To_Marquette</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Opportunity_Move_To_Sent_To_Vendor</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>Truckers - Opportunity</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.TB2B_Stage__c</field>
            <operation>equals</operation>
            <value>Ready to Send to Vendor</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.TB2B_Product_Interest__c</field>
            <operation>equals</operation>
            <value>Marquette Funding</value>
        </criteriaItems>
        <description>An TB2B Marquette opportunity that is ready for the vendor</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Opportunity%3AOpen Fuel%2CFLIP%2C MPG opps</fullName>
        <active>false</active>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>Truckers - Opportunity</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.TB2B_Stage__c</field>
            <operation>equals</operation>
            <value>Qualification,Sent Fuel Program Info,Pending Member,Sent to Vendor</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.TB2B_Product_Interest__c</field>
            <operation>equals</operation>
            <value>Fuel,FLIP,MPG</value>
        </criteriaItems>
        <description>Any TB2B FLIP, or MPG opportunity that is &quot;open&quot;</description>
        <triggerType>onCreateOnly</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Open_Opp_Follow_up</name>
                <type>Task</type>
            </actions>
            <offsetFromField>Opportunity.CreatedDate</offsetFromField>
            <timeLength>45</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>Open_Opp_Follow_up</name>
                <type>Task</type>
            </actions>
            <offsetFromField>Opportunity.CreatedDate</offsetFromField>
            <timeLength>90</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Opportunity%3APeopleNet Ready For Vendor</fullName>
        <actions>
            <name>Opportunity_Send_to_Peoplenet</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Opportunity_Move_To_Sent_To_Vendor</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>Truckers - Opportunity</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.TB2B_Stage__c</field>
            <operation>equals</operation>
            <value>Ready to Send to Vendor</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.TB2B_Product_Interest__c</field>
            <operation>equals</operation>
            <value>PeopleNet</value>
        </criteriaItems>
        <description>An TB2B PeopleNet opportunity that is ready for the vendor</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Opportunity%3APilot Ready for Vendor</fullName>
        <actions>
            <name>Opportunity_Send_to_Pilot</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Opportunity_Move_To_Sent_To_Vendor</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>Truckers - Opportunity</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.TB2B_Stage__c</field>
            <operation>equals</operation>
            <value>Ready to Send to Vendor</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.TB2B_Product_Interest__c</field>
            <operation>equals</operation>
            <value>Pilot</value>
        </criteriaItems>
        <description>An TB2B Pilot opportunity that is ready for the vendor</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Opportunity%3AProphesy Ready For Vendor</fullName>
        <actions>
            <name>Opportunity_Send_to_Prophesy</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Opportunity_Move_To_Sent_To_Vendor</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>Truckers - Opportunity</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.TB2B_Stage__c</field>
            <operation>equals</operation>
            <value>Ready to Send to Vendor</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.TB2B_Product_Interest__c</field>
            <operation>equals</operation>
            <value>Prophesy</value>
        </criteriaItems>
        <description>An TB2B Prophesy opportunity that is ready to send for the vendor</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Opportunity%3AQualification OPPS</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>Truckers - Opportunity</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.TB2B_Stage__c</field>
            <operation>equals</operation>
            <value>Qualification</value>
        </criteriaItems>
        <description>Any TB2B opportunity that is in Qualification Stage</description>
        <triggerType>onCreateOnly</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Opportunity_Qualification_stage</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Opportunity.CreatedDate</offsetFromField>
            <timeLength>14</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Opportunity%3ASprint Ready For Vendor</fullName>
        <actions>
            <name>Opportunity_Send_to_Sprint</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Opportunity_Move_To_Sent_To_Vendor</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>Truckers - Opportunity</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.TB2B_Stage__c</field>
            <operation>equals</operation>
            <value>Ready to Send to Vendor</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.TB2B_Product_Interest__c</field>
            <operation>equals</operation>
            <value>Sprint</value>
        </criteriaItems>
        <description>An TB2B Sprint opportunity that is ready for the vendor</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Opportunity%3ATransflo Ready For Vendor</fullName>
        <actions>
            <name>Opportunity_Send_to_TransFlo</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Opportunity_Move_To_Sent_To_Vendor</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>Truckers - Opportunity</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.TB2B_Stage__c</field>
            <operation>equals</operation>
            <value>Ready to Send to Vendor</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.TB2B_Product_Interest__c</field>
            <operation>equals</operation>
            <value>Transflo</value>
        </criteriaItems>
        <description>An TB2B Transflo opportunity that is ready for the vendor</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Opportunity%3ATriumph%2FGrangier Ready For Vendor</fullName>
        <actions>
            <name>Opportunity_Move_To_Sent_To_Vendor</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>Truckers - Opportunity</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.TB2B_Stage__c</field>
            <operation>equals</operation>
            <value>Ready to Send to Vendor</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.TB2B_Product_Interest__c</field>
            <operation>equals</operation>
            <value>Triumph Business Capital,Grainger</value>
        </criteriaItems>
        <description>An TB2B Triumph/Grangier opportunity that is ready for the vendor</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Oppty%3A  Reminder to create asset</fullName>
        <actions>
            <name>Create_Asset</name>
            <type>Task</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>7) Closed/Won</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>Fleet Card</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Phillips 66 App Request Successful</fullName>
        <actions>
            <name>After_App_Request_Phillips66_successful_email_App_Signer_with_Data_Form</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Fleet_Data_Form_Sent</name>
            <type>Task</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Opportunity.Error_Log__c</field>
            <operation>startsWith</operation>
            <value>Success</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.SourceSystem__c</field>
            <operation>equals</operation>
            <value>Echosigned</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Program_Name__c</field>
            <operation>startsWith</operation>
            <value>Phillips</value>
        </criteriaItems>
        <description>When Error Log from Siebel indicates &quot;Success&quot; and created from Echosign and Phillips 66, sends Fleet Data Form to signer and completes a task.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Phillips 66 BizUnite App Request Successful</fullName>
        <actions>
            <name>After_App_Request_P66_BizUnite</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Fleet_Data_Form_Sent</name>
            <type>Task</type>
        </actions>
        <active>false</active>
        <booleanFilter>1 AND 2 AND 3 AND (4 or 5 or 6)</booleanFilter>
        <criteriaItems>
            <field>Opportunity.Error_Log__c</field>
            <operation>startsWith</operation>
            <value>Success</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.SourceSystem__c</field>
            <operation>equals</operation>
            <value>Echosigned</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Coupon_Code2__c</field>
            <operation>equals</operation>
            <value>CF3</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Program_Name__c</field>
            <operation>startsWith</operation>
            <value>Phillips 66</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Program_Name__c</field>
            <operation>startsWith</operation>
            <value>Conoco</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Program_Name__c</field>
            <operation>startsWith</operation>
            <value>76</value>
        </criteriaItems>
        <description>When Error Log from Siebel indicates &quot;Success&quot; and created from Echosign and P66 BizUnite sends Fleet Data Form to signer and completes a task.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Phillips 66 NFIB App Request Successful</fullName>
        <actions>
            <name>After_App_Request_P66_NFIB</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Fleet_Data_Form_Sent</name>
            <type>Task</type>
        </actions>
        <active>false</active>
        <booleanFilter>1 AND 2 AND 3 AND (4 or 5 or 6)</booleanFilter>
        <criteriaItems>
            <field>Opportunity.Error_Log__c</field>
            <operation>startsWith</operation>
            <value>Success</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.SourceSystem__c</field>
            <operation>equals</operation>
            <value>Echosigned</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Coupon_Code2__c</field>
            <operation>equals</operation>
            <value>CE9</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Program_Name__c</field>
            <operation>startsWith</operation>
            <value>Phillips 66</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Program_Name__c</field>
            <operation>startsWith</operation>
            <value>Conoco</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Program_Name__c</field>
            <operation>startsWith</operation>
            <value>76</value>
        </criteriaItems>
        <description>When Error Log from Siebel indicates &quot;Success&quot; and created from Echosign and P66 NFIB sends Fleet Data Form to signer and completes a task.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Price Risk Management Record Type Update</fullName>
        <actions>
            <name>Price_Risk_Management_Record_Type</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Product_Interest__c</field>
            <operation>equals</operation>
            <value>Price Risk Management</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Product Type AP Direct</fullName>
        <actions>
            <name>Set_Virtual_Product_to_AP_Direct</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Product_Type__c</field>
            <operation>equals</operation>
            <value>AP Direct</value>
        </criteriaItems>
        <description>If Product Type is equal to &quot;AP Direct&quot; (create or update), set &quot;Virtual Product&quot; to &quot;AP Direct&quot;</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Product Type SUGA</fullName>
        <actions>
            <name>Set_Virtual_Product_to_SUGA</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Product_Type__c</field>
            <operation>equals</operation>
            <value>SUGA</value>
        </criteriaItems>
        <description>If Product Type is equal to &quot;SUGA&quot; (create or update), set &quot;Virtual Product&quot; to &quot;SUGA&quot;</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Push Counter</fullName>
        <actions>
            <name>Increment_Push_Counter_Field</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Increment the Push Counter field by 1</description>
        <formula>IF(  CloseDate &gt; PRIORVALUE( CloseDate ),  IF (MONTH(CloseDate) &lt;&gt; MONTH(PRIORVALUE( CloseDate )) ,  TRUE,  FALSE),  FALSE)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>QuikTrip App Request Successful</fullName>
        <actions>
            <name>After_App_Request_QuikTrip</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Fleet_Data_Form_Sent</name>
            <type>Task</type>
        </actions>
        <active>false</active>
        <booleanFilter>1 AND 2 AND (3 OR 4)</booleanFilter>
        <criteriaItems>
            <field>Opportunity.Error_Log__c</field>
            <operation>startsWith</operation>
            <value>Success</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.SourceSystem__c</field>
            <operation>equals</operation>
            <value>Echosigned</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Program_Name__c</field>
            <operation>equals</operation>
            <value>QuikTrip</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Program_Name__c</field>
            <operation>equals</operation>
            <value>QuikTrip Affinity</value>
        </criteriaItems>
        <description>When Error Log from Siebel indicates &quot;Success&quot; and created from Echosign and QuikTrip, sends Fleet Data Form to signer and completes a task.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>RM Negotiation Notification</fullName>
        <actions>
            <name>RM_Negotiation_Notification</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.RM__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>6) Negotiate,7) Closed/Won,4) Competitive Strategy Established,5) Customer Commitment Gained,3) Compelling Event Identified</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>RaceTrac App Request Successful</fullName>
        <actions>
            <name>After_App_Request_RaceTrac</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Fleet_Data_Form_Sent</name>
            <type>Task</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Opportunity.Error_Log__c</field>
            <operation>startsWith</operation>
            <value>Success</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.SourceSystem__c</field>
            <operation>equals</operation>
            <value>Echosigned</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Program_Name__c</field>
            <operation>startsWith</operation>
            <value>Race</value>
        </criteriaItems>
        <description>When Error Log from Siebel indicates &quot;Success&quot; and created from Echosign and RaceTrac, sends Fleet Data Form to signer and completes a task.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Ramp Profile</fullName>
        <actions>
            <name>Populate_FSR_Commencement_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Populate_Imp_Rev_Commencement_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Populate_Implementation_Rev_FSR</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>All Wex Europe record types</description>
        <formula>/* Be aware of Close Date Change workflow rule &amp; field updates */

AND(

OR(
/*Currencies */ 
RecordTypeId = &apos;012700000005r08&apos;, 
RecordTypeId = &apos;012700000005qzy&apos;, 
RecordTypeId = &apos;012700000005r0D&apos;, 

/* Bespoke, TourCard, Disbursement */ 
RecordTypeId = &apos;012700000005qia&apos;, 
RecordTypeId = &apos;012700000005qid&apos;, 
RecordTypeId = &apos;012700000005qib&apos;, 

/* Expense - Crew, General, Petty Cash, Platform, Tour, Transport &amp; Haulage, UTB Consumer, UTB Corporate */ 
RecordTypeId = &apos;012700000005qic&apos;, 
RecordTypeId = &apos;012700000005rA9&apos;, 
RecordTypeId = &apos;012700000005rAA&apos;, 
RecordTypeId = &apos;012700000005rAB&apos;, 
RecordTypeId = &apos;012700000005qzo&apos;, 
RecordTypeId = &apos;012700000005rAC&apos;, 
RecordTypeId = &apos;012700000005r0I&apos;, 
RecordTypeId = &apos;012700000005r0N&apos;, 
RecordTypeId = &apos;012700000005qzt&apos;, 

/* Virtual Credit, Virtual Prepaid MC, Virtual Debit MC */ 
RecordTypeId = &apos;012700000005qie&apos;,
RecordTypeId = &apos;012700000005qif&apos;,
RecordTypeId = &apos;012700000005wUG&apos;,

/* Virtual Prepaid VE, Virtual All In One */
RecordTypeId = &apos;012700000005qig&apos;,
RecordTypeId = &apos;012700000005xWw&apos;
),

OR(
ISNEW(),
ISCHANGED(Ramp_Profile__c)
)

)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Referral Date Update</fullName>
        <actions>
            <name>Referral_Date_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Telematics_Rep__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Royal Farms App Request Successful</fullName>
        <actions>
            <name>After_App_Request_Royal_Farms</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Fleet_Data_Form_Sent</name>
            <type>Task</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Opportunity.Error_Log__c</field>
            <operation>startsWith</operation>
            <value>Success</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.SourceSystem__c</field>
            <operation>equals</operation>
            <value>Echosigned</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Program_Name__c</field>
            <operation>startsWith</operation>
            <value>Royal</value>
        </criteriaItems>
        <description>When Error Log from Siebel indicates &quot;Success&quot; and created from Echosign and Royal Farms, sends Fleet Data Form to signer and completes a task.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Service Implementation</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>8) Service Implementation</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>CorporatePay,CP_Disbursement,CP Virtual Credit,CP Virtual Prepaid MC,CP Virtual Prepaid VE,CP_Expense_General_Expense,CP_Expense_Petty_Cash,CP_Expense_Tour</value>
        </criteriaItems>
        <description>Alerts the Implementation Managers of deals moving into service implementation.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Set RecordType for PrePass</fullName>
        <actions>
            <name>Fleet_Card_opportunity_record_types</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Card_Program_Txt__c</field>
            <operation>contains</operation>
            <value>PrePass</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Set Referral Date if Cross Sell</fullName>
        <actions>
            <name>Cross_Sell_Referral_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Cross_Sell__c</field>
            <operation>equals</operation>
            <value>Yes</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Referral_Date__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <description>Set the Referral Date value to TODAY when Cross Sell value is changed to &quot;Yes&quot;</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Set Up Account Task</fullName>
        <actions>
            <name>Set_Up_Account</name>
            <type>Task</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Opportunity.Coupon_Code2__c</field>
            <operation>equals</operation>
            <value>NTZ,QFQ,PF5,GP6</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Error_Log__c</field>
            <operation>startsWith</operation>
            <value>Success</value>
        </criteriaItems>
        <description>This WF Rules creates a setup account task when an oppty from these coupon codes is created.  NTZ,QFQ,PF5,GP6</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Sheetz App Request Successful</fullName>
        <actions>
            <name>After_App_Request_Sheetz</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Fleet_Data_Form_Sent</name>
            <type>Task</type>
        </actions>
        <active>false</active>
        <booleanFilter>1 AND 2 AND (3 OR 4 OR 5)</booleanFilter>
        <criteriaItems>
            <field>Opportunity.Error_Log__c</field>
            <operation>startsWith</operation>
            <value>Success</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.SourceSystem__c</field>
            <operation>equals</operation>
            <value>Echosigned</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Program_Name__c</field>
            <operation>equals</operation>
            <value>Sheetz Edge</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Program_Name__c</field>
            <operation>equals</operation>
            <value>Sheetz Universal Edge</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Program_Name__c</field>
            <operation>equals</operation>
            <value>Sheetz Business Edge</value>
        </criteriaItems>
        <description>When Error Log from Siebel indicates &quot;Success&quot; and created from Echosign and Sheetz, sends Fleet Data Form to signer and completes a task.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Siebel Program Row Id Update</fullName>
        <actions>
            <name>Program_Row_Id_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Siebel_Program_Row_id__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>This was created to populate the siebel program row id in a field so a sharing rule could be built based on criteria.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Source System Update</fullName>
        <actions>
            <name>Source_System</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2 AND 3</booleanFilter>
        <criteriaItems>
            <field>Opportunity.SourceSystem__c</field>
            <operation>notEqual</operation>
            <value>BOCA</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.SourceSystem__c</field>
            <operation>notEqual</operation>
            <value>Echosign</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.SourceSystem__c</field>
            <operation>notEqual</operation>
            <value>Echosigned</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Stage Date Change</fullName>
        <actions>
            <name>Stage_Change_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>This captures the Date/Time when the sales stage is changed</description>
        <formula>ISCHANGED(StageName)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Stage Date Change for New Oppty%27s</fullName>
        <actions>
            <name>New_Oppty_Stage_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>This captures the Date/Time when of the sales stage when the oppty is created</description>
        <formula>Id  &lt;&gt; NULL</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Stripes App Request Successful</fullName>
        <actions>
            <name>After_App_Request_Stripes</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Fleet_Data_Form_Sent</name>
            <type>Task</type>
        </actions>
        <active>false</active>
        <booleanFilter>1 AND 2 AND (3 OR 4 OR 5)</booleanFilter>
        <criteriaItems>
            <field>Opportunity.Error_Log__c</field>
            <operation>startsWith</operation>
            <value>Success</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.SourceSystem__c</field>
            <operation>equals</operation>
            <value>Echosigned</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Program_Name__c</field>
            <operation>equals</operation>
            <value>Stripes Fleet Card Program</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Program_Name__c</field>
            <operation>equals</operation>
            <value>Stripes Universal Fleet Card</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Program_Name__c</field>
            <operation>equals</operation>
            <value>Stripes Fleet Card</value>
        </criteriaItems>
        <description>When Error Log from Siebel indicates &quot;Success&quot; and created from Echosign and Stripes, sends Fleet Data Form to signer and completes a task.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Sunoco%2FSuntrak App Request Successful</fullName>
        <actions>
            <name>After_App_Request_Sunoco_successful_email_App_Signer_with_Data_Form</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Fleet_Data_Form_Sent</name>
            <type>Task</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Opportunity.Error_Log__c</field>
            <operation>startsWith</operation>
            <value>Success</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.SourceSystem__c</field>
            <operation>equals</operation>
            <value>Echosigned</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Program_Name__c</field>
            <operation>startsWith</operation>
            <value>Sun</value>
        </criteriaItems>
        <description>When Error Log from Siebel indicates &quot;Success&quot; and created from Echosign and Sunoco/Suntrak, sends Fleet Data Form to signer and completes a task.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>SuperFleet App Request Successful</fullName>
        <actions>
            <name>Fleet_Data_Form_Sent</name>
            <type>Task</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Opportunity.Error_Log__c</field>
            <operation>startsWith</operation>
            <value>Success</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.SourceSystem__c</field>
            <operation>equals</operation>
            <value>Echosigned</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Program_Name__c</field>
            <operation>startsWith</operation>
            <value>SuperFleet</value>
        </criteriaItems>
        <description>When Error Log from Siebel indicates &quot;Success&quot; and created from Echosign and SuperFleet, sends Fleet Data Form to signer and completes a task.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Survey - Closed%2FLost</fullName>
        <actions>
            <name>Send_Closed_Lost_Survey</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>Closed/Lost</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Opportunity_Owner_Role__c</field>
            <operation>equals</operation>
            <value>IS Sales Rep</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Record_Type_Name__c</field>
            <operation>contains</operation>
            <value>Fuel Card</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Program_Name__c</field>
            <operation>contains</operation>
            <value>WEX Small Business,WEX Universal,Wright Express Fleet Universal</value>
        </criteriaItems>
        <description>Send customer survey when an Opportunity Stage is set to Closed/Lost</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Task - Start Implem for AJ Acct Status Changed - pt1</fullName>
        <active>false</active>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>7) Closed/Won</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Projected_Monthly_Gallons__c</field>
            <operation>greaterThan</operation>
            <value>7000</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.F1_Account_Number__c</field>
            <operation>startsWith</operation>
            <value>1</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Card_Program_Type__c</field>
            <operation>equals</operation>
            <value>Direct Local</value>
        </criteriaItems>
        <description>Task for Amanda James to follow up on implementation when an opportunity moves to f1 Account Number Created. proj gall &gt; 7000, acct # begins with 1</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <timeLength>7</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Task - Start Implem for AJ Acct Status Changed - pt2</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>7) Closed/Won</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Projected_Monthly_Gallons__c</field>
            <operation>greaterThan</operation>
            <value>3000</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.F1_Account_old__c</field>
            <operation>startsWith</operation>
            <value>4</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Card_Program_Type__c</field>
            <operation>equals</operation>
            <value>Direct Local</value>
        </criteriaItems>
        <description>Task for Amanda James to follow up on implementation when an opportunity moves to f1 Account Number Created. proj gall &gt; 3000, acct # begins with 4</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <timeLength>7</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Telapoint Amount Update</fullName>
        <actions>
            <name>Telapoint_Amount_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>Telapoint</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Telapoint Record Type Update</fullName>
        <actions>
            <name>Telapoint_Record_Type</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Product_Interest__c</field>
            <operation>equals</operation>
            <value>Telapoint</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Telematics Opportunity</fullName>
        <actions>
            <name>Opportunity_Telematics_Record_Type</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Product_Service_Type__c</field>
            <operation>equals</operation>
            <value>Telematics</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Telematics Record Type Update</fullName>
        <actions>
            <name>Telematics_Record_Type</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Product_Interest__c</field>
            <operation>equals</operation>
            <value>Telematics</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Telt</fullName>
        <active>false</active>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>7) Closed/Won</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Tesoro App Request Successful</fullName>
        <actions>
            <name>After_App_Request_Tesoro_successful_email_App_Signer_with_Data_Form</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Fleet_Data_Form_Sent</name>
            <type>Task</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Opportunity.Error_Log__c</field>
            <operation>startsWith</operation>
            <value>Success</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.SourceSystem__c</field>
            <operation>equals</operation>
            <value>Echosigned</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Program_Name__c</field>
            <operation>startsWith</operation>
            <value>Tesoro</value>
        </criteriaItems>
        <description>When Error Log from Siebel indicates &quot;Success&quot; and created from Echosign and Tesoro, sends Fleet Data Form to signer and completes a task.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Total Fuel Management Record Type Update</fullName>
        <actions>
            <name>Fuel_Card_Record_Type</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Product_Interest__c</field>
            <operation>equals</operation>
            <value>Total Fuel Management</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Transaction Fee</fullName>
        <actions>
            <name>Populate_Transaction_Fee</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>For the stages before the salesperson is expected to know it.</description>
        <formula>AND(

$RecordType.Name = &apos;CP Virtual Prepaid VE&apos;,
ISBLANK(Monthly_Txn_Revenue_POS__c),

OR(
  TEXT(StageName) = &quot;1) Qualified&quot;,
  TEXT(StageName) = &quot;2) Engaged&quot;
)

)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update Opportunity Amount - Net FSR</fullName>
        <actions>
            <name>Update_Opportunity_Amount_Net_FSR</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Figure needed for Campaign hierarchy roll up &amp; Pardot reporting</description>
        <formula>AND(

  OR(
    /*Currencies */
    RecordTypeId = &apos;012700000005r08&apos;, 
    RecordTypeId = &apos;012700000005qzy&apos;, 
    RecordTypeId = &apos;012700000005r0D&apos;, 

    /* Bespoke, TourCard, Disbursement */
    RecordTypeId = &apos;012700000005qia&apos;, 
    RecordTypeId = &apos;012700000005qid&apos;,
    RecordTypeId = &apos;012700000005qib&apos;, 

    /* Expense - Crew, General, Petty Cash, Platform, Tour, Transport &amp; Haulage, UTB Consumer, UTB Corporate */ 
    RecordTypeId = &apos;012700000005qic&apos;,
    RecordTypeId = &apos;012700000005rA9&apos;,
    RecordTypeId = &apos;012700000005rAA&apos;,
    RecordTypeId = &apos;012700000005rAB&apos;,
    RecordTypeId = &apos;012700000005qzo&apos;,
    RecordTypeId = &apos;012700000005rAC&apos;,
    RecordTypeId = &apos;012700000005r0I&apos;,
    RecordTypeId = &apos;012700000005r0N&apos;,
    RecordTypeId = &apos;012700000005qzt&apos;,

    /* Virtual Credit, Virtual Prepaid MC, Virtual Debit MC */ 
    RecordTypeId = &apos;012700000005qie&apos;,
    RecordTypeId = &apos;012700000005qif&apos;,
    RecordTypeId = &apos;012700000005wUG&apos;,

    /* Virtual Prepaid VE, Virtual All In One */
    RecordTypeId = &apos;012700000005qig&apos;,
    RecordTypeId = &apos;012700000005xWw&apos;,

    $RecordType.Name = &apos;MasterCard&apos; 
    ),

  NOT(TEXT(Type) = &apos;Existing Customer - Administration&apos;)
)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update Opportunity Amount - Partnership Potential Spend</fullName>
        <active>true</active>
        <description>Update Opportunity Amount - Net FSR</description>
        <formula>AND(

  $RecordType.Name = &apos;CP Virtual Partnership&apos;,
  /*
  shouldn&apos;t be needed but just in case..
  */
  NOT(TEXT(Type) = &apos;Existing Customer - Administration&apos;)
)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>UpdateEmailAttention</fullName>
        <active>false</active>
        <criteriaItems>
            <field>Opportunity.CloseDate</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Virtual EU Opportunity Won</fullName>
        <actions>
            <name>EU_Virtual_Opportunity_Won</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>/* can be consolidated into a since Process Builder process, along with other &apos;Won&apos; Workflow Rules */

AND( 


OR( 
    $RecordType.Name = &apos;CP Virtual Credit&apos;,
    $RecordType.Name = &apos;CP Virtual Prepaid MC&apos;, 
    $RecordType.Name = &apos;CP Virtual Prepaid VE&apos;,
    $RecordType.Name = &apos;CP Virtual Debit MC&apos;,
    $RecordType.Name = &apos;CP Virtual All In One&apos; 
), 

NOT(TEXT(Type) = &apos;Existing Customer - Administration&apos;), 

OR( 

/* Newly created opportunities, which have the stage set to 5, 6 or 7 */ 
AND( 

ISNEW(), 

OR( 
TEXT(StageName) = &quot;5) Signed&quot;, 
TEXT(StageName) = &quot;6) Service Implementation&quot;, 
TEXT(StageName) = &quot;7) Project Completed&quot;) 
), /* Close test - newly created opportunities */ 

/* Stage moved from open to negotiate or closed */ 
AND( 

OR( 
ISPICKVAL(PRIORVALUE(StageName), &quot;1) Qualified&quot;), 
ISPICKVAL(PRIORVALUE(StageName), &quot;2) Engaged&quot;), 
ISPICKVAL(PRIORVALUE(StageName), &quot;3) Evaluating&quot;), 
TEXT(StageName) = &quot;4) Negotiating&quot; 
), 

OR( 
TEXT(StageName) = &quot;5) Signed&quot;, 
TEXT(StageName) = &quot;6) Service Implementation&quot;, 
TEXT(StageName) = &quot;7) Project Completed&quot;) 
)), /* Close test - stage moved */ 

/* opportunity stage not downgraded */ 
NOT(ISPICKVAL(PRIORVALUE(StageName),&quot;5) Signed&quot;)) 

)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Virtual Opportunity Stage Change Won</fullName>
        <actions>
            <name>Virtual_Opportunity_Stage_Change_5_or_Won</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Wex Europe Virtual product types only</description>
        <formula>AND(


OR( 

/* Virtual Credit, Virtual Prepaid MC, Virtual Debit MC */ 
RecordTypeId = &apos;012700000005qie&apos;,
RecordTypeId = &apos;012700000005qif&apos;,
RecordTypeId = &apos;012700000005wUG&apos;,

/* Virtual Prepaid VE, Virtual All In One */
RecordTypeId = &apos;012700000005qig&apos;,
RecordTypeId = &apos;012700000005xWw&apos;,

$RecordType.Name = &apos;MasterCard&apos;
),

NOT(TEXT(Type) = &apos;Existing Customer - Administration&apos;), 

OR( 

/* Newly created opportunities, which have the stage set to 5, 6 or 7 */ 
AND( 

ISNEW(), 

OR( 
TEXT(StageName) = &quot;5) Signed&quot;, 
TEXT(StageName) = &quot;6) Service Implementation&quot;, 
TEXT(StageName) = &quot;7) Project Completed&quot;) 
), /* Close test - newly created opportunities */ 

/* Stage moved from open to negotiate or closed */ 
AND( 

OR( 
ISPICKVAL(PRIORVALUE(StageName), &quot;1) Qualified&quot;), 
ISPICKVAL(PRIORVALUE(StageName), &quot;2) Engaged&quot;), 
ISPICKVAL(PRIORVALUE(StageName), &quot;3) Evaluating&quot;),
TEXT(StageName) = &quot;4) Negotiating&quot; 
), 

OR( 
TEXT(StageName) = &quot;5) Signed&quot;, 
TEXT(StageName) = &quot;6) Service Implementation&quot;, 
TEXT(StageName) = &quot;7) Project Completed&quot;) 
)), /* Close test - stage moved */ 

/* opportunity stage not downgraded */
NOT(ISPICKVAL(PRIORVALUE(StageName),&quot;5) Signed&quot;))

)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Virtual Opportunity Won - Manual Billing Required</fullName>
        <actions>
            <name>New_Sale_Manual_Billing_Required_Notification</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <description>Email notification to finance</description>
        <formula>AND(    OR(      $RecordType.Name = &apos;CP Virtual Credit&apos;,     $RecordType.Name = &apos;CP Virtual Prepaid MC&apos;,      $RecordType.Name = &apos;CP Virtual Prepaid VE&apos;,     $RecordType.Name = &apos;CP Virtual Debit MC&apos;,     $RecordType.Name = &apos;CP Virtual All In One&apos;   ),     NOT(TEXT(Type) = &apos;Existing Customer - Administration&apos;),   NOT(TEXT(Manual_Billing_Required__c) = &apos;Not Applicable&apos;),    OR(      /* Newly created opportunities, which are set to won */      AND(        ISNEW(),        Probability = 1     ),            /* Stage moved from open to won */      AND(         PRIORVALUE(Probability) &lt; 1,       Probability = 1     )      )  )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>WES - Opp Record Type Update</fullName>
        <actions>
            <name>WES_Change_Record_Type</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>User.ProfileId</field>
            <operation>startsWith</operation>
            <value>WES</value>
        </criteriaItems>
        <description>Update Opportunity to WES Record Type if created by WES Profile</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>WESN Record Type Update</fullName>
        <actions>
            <name>WESN_Record_Type</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Product_Interest__c</field>
            <operation>equals</operation>
            <value>WESN</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>WEX App Request Successful</fullName>
        <actions>
            <name>After_App_Request_is_successful_email_App_Signer_with_Data_Form</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Fleet_Data_Form_Sent</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Error_Log__c</field>
            <operation>startsWith</operation>
            <value>Success</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.SourceSystem__c</field>
            <operation>equals</operation>
            <value>Echosigned</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Program_Name__c</field>
            <operation>equals</operation>
            <value>WEX Universal,WEX Small Business</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Opportunity_Owner_Role__c</field>
            <operation>notEqual</operation>
            <value>Regional Sales Manager (East)</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Opportunity_Owner_Role__c</field>
            <operation>notEqual</operation>
            <value>Regional Sales Manager (West)</value>
        </criteriaItems>
        <description>When Error Log from Siebel indicates &quot;Success&quot; and created from Echosign and WEX Universal, sends Fleet Data Form to signer and completes a task.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>WEX App Request Successful %28Excel%29</fullName>
        <actions>
            <name>After_App_Request_WEX_Universal_is_successful_email_App_Signer_with_Data_Form</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Fleet_Data_Form_Sent</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Error_Log__c</field>
            <operation>startsWith</operation>
            <value>Success</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.SourceSystem__c</field>
            <operation>equals</operation>
            <value>Echosigned</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Program_Name__c</field>
            <operation>startsWith</operation>
            <value>WEX Universal</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Opportunity_Owner_Role__c</field>
            <operation>startsWith</operation>
            <value>Regional Sales Manager (</value>
        </criteriaItems>
        <description>When Error Log from Siebel indicates &quot;Success&quot; and created from Echosign and WEX program and Owner Role is Regional Sales Manager, sends Fleet Data Form (Excel) to signer and completes a task.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>WEX BizUnite App Request Successful</fullName>
        <actions>
            <name>After_App_Request_is_successful_email_App_Signer_with_Data_Form3</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Fleet_Data_Form_Sent</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Error_Log__c</field>
            <operation>startsWith</operation>
            <value>Success</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.SourceSystem__c</field>
            <operation>equals</operation>
            <value>Echosigned</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Program_Name__c</field>
            <operation>equals</operation>
            <value>WEX Associations</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Opportunity_Owner_Role__c</field>
            <operation>notEqual</operation>
            <value>Regional Sales Manager (East)</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Opportunity_Owner_Role__c</field>
            <operation>notEqual</operation>
            <value>Regional Sales Manager (West)</value>
        </criteriaItems>
        <description>When Error Log from Siebel indicates &quot;Success&quot; and created from Echosign and WEX BizUnite, sends Fleet Data Form to signer and completes a task.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>WEX BizUnite App Request Successful %28Excel%29</fullName>
        <actions>
            <name>After_WEX_BizUnite_App_Request_is_successful_email_App_Signer_with_Data_Form_Exc</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Fleet_Data_Form_Sent</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Error_Log__c</field>
            <operation>startsWith</operation>
            <value>Success</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.SourceSystem__c</field>
            <operation>equals</operation>
            <value>Echosigned</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Program_Name__c</field>
            <operation>equals</operation>
            <value>WEX Associations</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Opportunity_Owner_Role__c</field>
            <operation>startsWith</operation>
            <value>Regional Sales Manager (</value>
        </criteriaItems>
        <description>When Error Log from Siebel indicates &quot;Success&quot; and created from Echosign and WEX BizUnite and Opp Owner Role is Regional Sales Manager (East or West) , sends Fleet Data Form (Excel version) to signer and completes a task</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>WEX Starter App Request Successful</fullName>
        <actions>
            <name>After_App_Request_WEX_STARTER_is_successful_email_App_Signer_with_Data_Form</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Fleet_Data_Form_Sent</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Error_Log__c</field>
            <operation>startsWith</operation>
            <value>Success</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.SourceSystem__c</field>
            <operation>equals</operation>
            <value>Echosigned</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Program_Name__c</field>
            <operation>startsWith</operation>
            <value>Wright Express Small Business</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Opportunity_Owner_Role__c</field>
            <operation>notEqual</operation>
            <value>Regional Sales Manager (East)</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Opportunity_Owner_Role__c</field>
            <operation>notEqual</operation>
            <value>Regional Sales Manager (West)</value>
        </criteriaItems>
        <description>When Error Log from Siebel indicates &quot;Success&quot; and created from Echosign and WEX Starter, sends Fleet Data Form to signer and completes a task.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>WEX Starter App Request Successful %28Excel%29</fullName>
        <actions>
            <name>After_App_Request_WEX_STARTER_is_successful_email_App_Signer_with_Data_Form_Exce</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Fleet_Data_Form_Sent</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Error_Log__c</field>
            <operation>startsWith</operation>
            <value>Success</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.SourceSystem__c</field>
            <operation>equals</operation>
            <value>Echosigned</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Program_Name__c</field>
            <operation>startsWith</operation>
            <value>Wright Express Small Business</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Opportunity_Owner_Role__c</field>
            <operation>startsWith</operation>
            <value>Regional Sales Manager (</value>
        </criteriaItems>
        <description>When Error Log from Siebel indicates &quot;Success&quot; and created from Echosign and WEX Starter, sends Fleet Data Form to signer and completes a task.  Send Excel version for anyone but RSM&apos;s</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Wawa App Request Successful</fullName>
        <actions>
            <name>After_App_Request_Wawa</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Fleet_Data_Form_Sent</name>
            <type>Task</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Opportunity.Error_Log__c</field>
            <operation>startsWith</operation>
            <value>Success</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.SourceSystem__c</field>
            <operation>equals</operation>
            <value>Echosigned</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Program_Name__c</field>
            <operation>startsWith</operation>
            <value>Wawa</value>
        </criteriaItems>
        <description>When Error Log from Siebel indicates &quot;Success&quot; and created from Echosign and Wawa, sends Fleet Data Form to signer and completes a task.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Wright Express App Request Successful %28Excel%29</fullName>
        <actions>
            <name>After_App_Request_is_successful_email_App_Signer_with_Data_Form_Excel</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Fleet_Data_Form_Sent</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Error_Log__c</field>
            <operation>startsWith</operation>
            <value>Success</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.SourceSystem__c</field>
            <operation>equals</operation>
            <value>Echosigned</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Program_Name__c</field>
            <operation>startsWith</operation>
            <value>Wright Express Fleet</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Opportunity_Owner_Role__c</field>
            <operation>startsWith</operation>
            <value>Regional Sales Manager (</value>
        </criteriaItems>
        <description>When Error Log from Siebel indicates &quot;Success&quot; and created from Echosign and Wright Express program and Owner Role is Regional Sales Manager, sends Fleet Data Form (Excel) to signer and completes a task.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Wright Express Fleet Universal App Request Successful</fullName>
        <actions>
            <name>After_App_Request_is_successful_email_App_Signer_with_Data_Form2</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Fleet_Data_Form_Sent</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Error_Log__c</field>
            <operation>startsWith</operation>
            <value>Success</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.SourceSystem__c</field>
            <operation>equals</operation>
            <value>Echosigned</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Program_Name__c</field>
            <operation>equals</operation>
            <value>Wright Express Fleet Universal</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Opportunity_Owner_Role__c</field>
            <operation>notEqual</operation>
            <value>Regional Sales Manager (East)</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Opportunity_Owner_Role__c</field>
            <operation>notEqual</operation>
            <value>Regional Sales Manager (West)</value>
        </criteriaItems>
        <description>When Error Log from Siebel indicates &quot;Success&quot; and created from Echosign and Wright Express Fleet Universal, sends Fleet Data Form to signer and completes a task.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <tasks>
        <fullName>Call</fullName>
        <assignedToType>owner</assignedToType>
        <description>Followup Call</description>
        <dueDateOffset>2</dueDateOffset>
        <notifyAssignee>true</notifyAssignee>
        <priority>4-Medium</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Call</subject>
    </tasks>
    <tasks>
        <fullName>Create_Asset</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>4</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <offsetFromField>Opportunity.CloseDate</offsetFromField>
        <priority>2-High</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Create Asset</subject>
    </tasks>
    <tasks>
        <fullName>Fleet_Data_Form_Sent</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>2-High</priority>
        <protected>false</protected>
        <status>Completed</status>
        <subject>Fleet Data Form Sent</subject>
    </tasks>
    <tasks>
        <fullName>Gold_6_mo_Post_Sale_follow_up</fullName>
        <assignedToType>owner</assignedToType>
        <description>It&apos;s been 6 months since this Gold opportunity marked as Closed Won. Pls follow up to see how customer&apos;s purchases look, do they need contacted yet? What else can we help them with... fuel, oil, more tires?</description>
        <dueDateOffset>180</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <offsetFromField>Opportunity.CloseDate</offsetFromField>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Gold 6 mo Post Sale follow up</subject>
    </tasks>
    <tasks>
        <fullName>Gold_Opp_12_week_follow_up</fullName>
        <assignedToType>owner</assignedToType>
        <description>90 days after gold stage updated, follow up set.</description>
        <dueDateOffset>84</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <offsetFromField>Opportunity.CloseDate</offsetFromField>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Gold Opp 12 week follow up</subject>
    </tasks>
    <tasks>
        <fullName>Gold_Opp_2_week_follow_up</fullName>
        <assignedToType>owner</assignedToType>
        <description>Pls follow up with this customer to see if ready to buy tires yet since it&apos;s been 2 weeks since Credit Approved. Or did they buy already &amp; stage just not updated?</description>
        <dueDateOffset>14</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <offsetFromField>Opportunity.CloseDate</offsetFromField>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Gold Opp 2 week follow up</subject>
    </tasks>
    <tasks>
        <fullName>Gold_Opp_4_week_follow_up</fullName>
        <assignedToType>owner</assignedToType>
        <description>Pls follow up with this customer to see if ready to buy tires yet since it&apos;s been 4 weeks since Credit Approved. Or did they buy already &amp; stage just not updated?</description>
        <dueDateOffset>30</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <offsetFromField>Opportunity.CloseDate</offsetFromField>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Gold Opp 4 week follow up</subject>
    </tasks>
    <tasks>
        <fullName>Gold_Post_Sale_follow_up</fullName>
        <assignedToType>owner</assignedToType>
        <description>It&apos;s been 2.5 months since this Gold opportunity marked as Closed Won. Pls follow up to see how customer&apos;s purchases look, do they need contacted yet?</description>
        <dueDateOffset>75</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <offsetFromField>Opportunity.CloseDate</offsetFromField>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Gold Post Sale follow up</subject>
    </tasks>
    <tasks>
        <fullName>Gold_Quote_Follow_up</fullName>
        <assignedToType>owner</assignedToType>
        <description>Pricing was sent to customer 30 days ago so pls follow up if haven&apos;t yet &amp; see where things stand. If need be update stage.</description>
        <dueDateOffset>2</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Gold Quote Follow up</subject>
    </tasks>
    <tasks>
        <fullName>New_Opportunity_Assigned_to_You</fullName>
        <assignedToType>owner</assignedToType>
        <description>A New Opportunity has been assigned to you for follow up.</description>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>2-High</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>New Opportunity Assigned to You</subject>
    </tasks>
    <tasks>
        <fullName>Open_Opp_Follow_up</fullName>
        <assignedToType>owner</assignedToType>
        <description>Pls follow up on this open opportunity.</description>
        <dueDateOffset>14</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <offsetFromField>Opportunity.CreatedDate</offsetFromField>
        <priority>High</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Open Opp Follow up</subject>
    </tasks>
    <tasks>
        <fullName>Opportunity_Follow_up</fullName>
        <assignedToType>owner</assignedToType>
        <description>how&apos;s this opportunity progressing? If need be, call member, change stage, etc. Go get &apos;em!</description>
        <dueDateOffset>45</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <offsetFromField>Opportunity.CreatedDate</offsetFromField>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Opportunity Follow up</subject>
    </tasks>
    <tasks>
        <fullName>Opportunity_Sent_Info_Followup</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>2</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Opportunity Sent Info Followup</subject>
    </tasks>
    <tasks>
        <fullName>Opportunity_has_Closed_Create_Account_Asset</fullName>
        <assignedToType>owner</assignedToType>
        <description>If you haven&apos;t already done so, create the Account Asset so gallons can be loaded.  From the Opportunity, make sure there is an F1 Account # and then click &quot;New Fuel Card Asset&quot;.</description>
        <dueDateOffset>3</dueDateOffset>
        <notifyAssignee>true</notifyAssignee>
        <priority>2-High</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Opportunity has Closed - Create Account Asset</subject>
    </tasks>
    <tasks>
        <fullName>REASSIGN_OPP_OWNER</fullName>
        <assignedToType>user</assignedToType>
        <description>IF opp is still in qualification stage, time to change owners.</description>
        <dueDateOffset>90</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <offsetFromField>Opportunity.CreatedDate</offsetFromField>
        <priority>High</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>REASSIGN OPP OWNER?</subject>
    </tasks>
    <tasks>
        <fullName>Set_Up_Account</fullName>
        <assignedTo>account@wexinc.com</assignedTo>
        <assignedToType>user</assignedToType>
        <description>GP6 Crius Fuel Fox 5 cents/gallon for lifetime of account at Exxon or Mobil branded stations.</description>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>4-Medium</priority>
        <protected>false</protected>
        <status>In Progress</status>
        <subject>Set Up Account</subject>
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
    <tasks>
        <fullName>X1_Year_Ann</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>true</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>1 Year Anniversary with F1</subject>
    </tasks>
    <tasks>
        <fullName>X2_week_Opportunity_Follow_up</fullName>
        <assignedToType>owner</assignedToType>
        <description>Pls follow up on the oppty you created 2 weeks ago.</description>
        <dueDateOffset>14</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <offsetFromField>Opportunity.CreatedDate</offsetFromField>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>2 week Opportunity Follow up</subject>
    </tasks>
    <tasks>
        <fullName>X3_Month_Fuel_Check_up</fullName>
        <assignedToType>owner</assignedToType>
        <description>Fleet has been on program for a min of 1 full month, max 2 full months so pls review &amp; reach out to member.</description>
        <dueDateOffset>90</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <offsetFromField>Opportunity.CloseDate</offsetFromField>
        <priority>High</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>3 Month Fuel Check up</subject>
    </tasks>
    <tasks>
        <fullName>X6_Mo_fuel_followup</fullName>
        <assignedToType>accountOwner</assignedToType>
        <description>How is fleet doing on fuel? What else can we help with?</description>
        <dueDateOffset>2</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>6 Mo fuel followup</subject>
    </tasks>
</Workflow>
