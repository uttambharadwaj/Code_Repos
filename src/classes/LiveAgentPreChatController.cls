global without sharing class LiveAgentPreChatController {

    public String liveagentAPIEndpoint { get; set; }
    public String liveagentJSEndpoint { get; set; }
    public String caseDepartment { get; set; }
    public Map<String, String> reasonPicklistMap { get; set; }
    public String reasonOtherMapStr { get; set; }

    public LiveAgentPreChatController() {
        reasonPicklistMap = new Map<String, String>();
        Map<String, Boolean> reasonOtherMap = new Map<String, Boolean>();
        for (Service_Operations_Chat_Reasons__mdt reason : [SELECT MasterLabel, Department__c, Require_Other_Reason__c FROM Service_Operations_Chat_Reasons__mdt WHERE Chat_Button__c = 'Service_Operations_WOLNP' ORDER BY MasterLabel ASC]) {
            reasonPicklistMap.put(reason.MasterLabel, reason.MasterLabel);
            reasonOtherMap.put(reason.MasterLabel, reason.Require_Other_Reason__c);
            if (String.isEmpty(caseDepartment)) {
                caseDepartment = reason.Department__c;
            }
        }

        reasonOtherMapStr = JSON.serialize(reasonOtherMap);

        List<Live_Agent_Settings__mdt> laSettings = [SELECT API_Endpoint__c, JS_Endpoint__c FROM Live_Agent_Settings__mdt WHERE DeveloperName = 'Live_Agent' LIMIT 1];
        if (!laSettings.isEmpty()) {
            liveagentAPIEndpoint = laSettings[0].API_Endpoint__c;
            liveagentJSEndpoint = laSettings[0].JS_Endpoint__c;
        }
    }

    @RemoteAction
    global static Contact lookupContact(String firstName, String lastName, String email) {
        Support_Operation_Settings__c soSettings = Support_Operation_Settings__c.getOrgDefaults();
        String rectypeid = soSettings.PilotContactRecordTypeID__c;

        List<Contact> ctList = [SELECT
                                Id,
                                AccountId
                                FROM
                                Contact
                                WHERE
                                FirstName =:firstName AND LastName = :lastName AND Email = :email AND RecordTypeId = :rectypeid LIMIT 1
                               ];

        if (!ctList.isEmpty()) {
            return ctList[0];
        } else {
            return null;
        }
    }

    @RemoteAction
    global static Account lookupAccount(String wexAccount) {
        List<Account> acctList = [SELECT
                                  Id
                                  FROM
                                  Account
                                  WHERE
                                  Wex_Account__c =: wexAccount LIMIT 2
                                 ];

        if (acctList.size()==1) {
            return acctList[0];
        } else {
            return null;
        }
    }
}