/**
 * Created by lhowland on 12/6/2019.
 */

    @IsTest
    public class CreditWS_CLAuthResponseTest {

    static testMethod void testParse() {

            String json = '{'+
            '    \"payLoad\": {'+
            '        \"user\": {'+
            '            \"UserId\": \"SFintegration\",'+
            '            \"UserName\": \"Salesforce Integration\",'+
            '            \"TenantId\": \"Tenant\",'+
            '            \"IsSuperAdministrator\": true,'+
            '            \"ConfigID\": 1,'+
            '            \"UserAuthorization\": ['+
            '                {'+
            '                    \"Id\": 37,'+
            '                    \"BusinessPortfolio\": ['+
            '                        \"AMER\"'+
            '                    ],'+
            '                    \"CreditPortfolio\": \"WexBank\",'+
            '                    \"Role\": \"CA\",'+
            '                    \"UserId\": \"SFintegration\",'+
            '                    \"Inapplicable_\": [],'+
            '                    \"WFId_\": \"00000000-0000-0000-0000-000000000000\",'+
            '                    \"TaskId_\": \"00000000-0000-0000-0000-000000000000\",'+
            '                    \"VersionId_\": 1,'+
            '                    \"BaseVersionId_\": 0,'+
            '                    \"IsLatestVersion_\": true,'+
            '                    \"IsDeleted_\": false,'+
            '                    \"StatusId_\": 1,'+
            '                    \"CreatedBy_\": \"lhowland\",'+
            '                    \"CreatedDate_\": \"2019-11-25T17:44:56.108652Z\",'+
            '                    \"t_\": \"UserAuthorization\",'+
            '                    \"ContextUserId_\": \"lhowland\",'+
            '                    \"IsValid_\": true,'+
            '                    \"IsVisible_\": true,'+
            '                    \"SnapshotId_\": 0'+
            '                },'+
            '                {'+
            '                    \"Id\": 38,'+
            '                    \"BusinessPortfolio\": null,'+
            '                    \"CreditPortfolio\": null,'+
            '                    \"Role\": \"BA\",'+
            '                    \"UserId\": \"SFintegration\",'+
            '                    \"Inapplicable_\": [],'+
            '                    \"WFId_\": \"00000000-0000-0000-0000-000000000000\",'+
            '                    \"TaskId_\": \"00000000-0000-0000-0000-000000000000\",'+
            '                    \"VersionId_\": 1,'+
            '                    \"BaseVersionId_\": 0,'+
            '                    \"IsLatestVersion_\": true,'+
            '                    \"IsDeleted_\": false,'+
            '                    \"StatusId_\": 1,'+
            '                    \"CreatedBy_\": \"lhowland\",'+
            '                    \"CreatedDate_\": \"2019-11-25T19:49:58.826337Z\",'+
            '                    \"t_\": \"UserAuthorization\",'+
            '                    \"ContextUserId_\": \"lhowland\",'+
            '                    \"IsValid_\": true,'+
            '                    \"IsVisible_\": true,'+
            '                    \"SnapshotId_\": 0'+
            '                }'+
            '            ]'+
            '        },'+
            '        \"token\": \"0a3dfbe5-7947-47e0-8460-cf508c348d91\",'+
            '        \"devMode\": false'+
            '    },'+
            '    \"status\": null'+
            '}';

            CreditWS_CLAuthResponse obj = CreditWS_CLAuthResponse.parse(json);
            System.assert(obj != null);
    }
}

