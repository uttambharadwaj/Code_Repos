/**
 * Created by lhowland on 1/14/2020.
 */

@IsTest
public with sharing class CreditWS_CLDocToEntityRequestTest {

    static testMethod void testParse() {

        String json = '{'+
                '    \"context\": {'+
                '        \"wfId\": \"00000000-0000-0000-0000-000000000000\",'+
                '        \"taskId\": \"00000000-0000-0000-0000-000000000000\"'+
                '    },'+
                '    \"payLoad\": {'+
                '        \"multi\": ['+
                '            {'+
                '                \"viewModelId\": \"SpreadDocumentUpload\",'+
                '                \"behavior\": \"Save\",'+
                '                \"payLoad\": {'+
                '                    \"SpreadDocumentId\": \"00000000-0000-0000-0000-000000000000\",'+
                '                    \"EntityId\": 258,'+
                '                   \"DocumentId\": \"fcf1c8ad-d7a4-4167-abb5-f92e72e8175b\",'+
                '                    \"FinancialTemplateId\": \"6\",'+
                '                    \"DocumentStatus\": \"SUBMITTED\",'+
                '                    \"StatementDate\": \"2020-01-14 12:00:00\",'+
                '                    \"SpreadStatementCount\": \"1\",'+
                '                    \"SpreadDocumentType\": \"FINANCIAL_DOCUMENT\",'+
                '                    \"FilterOutForUI\": false,'+
                '                    \"SpreadStatement\": ['+
                '                        {'+
                '                            \"StatementPeriod\": 12,'+
                '                            \"StatementType\": \"ANNUAL\",'+
                '                            \"StatementDate\": \"2020-01-14T18:00:00.000Z\",'+
                '                            \"OperationType\": \"Create\"'+
                '                        }'+
                '                    ],'+
                '                    \"OperationType\": \"Create\",'+
                '                    \"Status\": 1,'+
                '                    \"t_\": \"SpreadDocument\"'+
                '                }'+
                '            },'+
                '            {'+
                '                \"viewModelId\": \"DocumentEdit\",'+
                '                \"behavior\": \"Save\",'+
                '                \"payLoad\": {'+
                '                    \"DocumentId\": \"fcf1c8ad-d7a4-4167-abb5-f92e72e8175b\",'+
                '                    \"Description\": null,'+
                '                    \"Title\": \"TestFinancialsExcel.xlsxf\",'+
                '                    \"Category\": \"4.7\",'+
                '                    \"OperationType\": \"Update\"'+
                '                }'+
                '            }'+
                '        ]'+
                '    }'+
                '}';

        CreditWS_CLDocToEntityRequest obj = CreditWS_CLDocToEntityRequest.parse(json);
        System.assert(obj != null);
}

}