<!--
 - Created by dgilbert on 2019-09-23.
 -->

<aura:application description="AccountMaintenanceScreens" access="GLOBAL" extends="ltng:outApp" implements="ltng:allowGuestAccess">
    <aura:attribute name="recordId" type="String" />
    <aura:attribute name="didLength" type="String" />
    <aura:attribute name="onlineUrl" type="String" />
    <aura:handler name="init" value="{!this}" action="{!c.doInit}" />
    <aura:dependency resource="c:AccountMaintenance" />
</aura:application>