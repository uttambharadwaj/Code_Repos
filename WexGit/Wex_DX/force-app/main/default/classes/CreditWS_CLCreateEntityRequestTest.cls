/**
 * Created by lhowland on 12/6/2019.
 */

    @IsTest
public class CreditWS_CLCreateEntityRequestTest {

		static testMethod void testParse() {
			String json = '{'+
					'        \"EntityType\": \"CORP\",'+
					'        \"SystemId\": \"Application-2019120000\",'+
					'        \"LongName\": \"Stock Exchange Test\",'+
					'        \"ShortName\": \"Exchange\",'+
					'        \"WexBusinessUnit\": \"CorpPay\",'+
					'        \"BusinessPortfolio\": \"CAN\",'+
					'        \"CreditPortfolio\": \"WexBank\",'+
					'        \"PrimaryBankingOfficer\": \"Salesforce Integration\",'+
					'        \"PrimaryCreditOfficer\": \"Leela Howland\",'+
					'        \"CountryOfRisk\": \"USA\",'+
					'        \"Currency\": \"USD\",'+
					'        \"IndClassification\": \"SIC\",'+
					'        \"StockCode\": \"TSE\",'+
					'        \"TaxID\": \"666666666\",'+
					'        \"WexDunsNumber\": \"111111111\",'+
					'        \"WexControlYear\": \"2000\",'+
					'        \"CountryOfListing\": \"CAN\",'+
					'        \"StockExchange\": \"TSE\",'+
					'        \"FirmType\": \"PUB\",'+
					'        \"EntityAddress\": ['+
					'            {'+
					'                \"$new\": true,'+
					'                \"OperationType\": \"Create\",'+
					'                \"AddressId\": -1,'+
					'                \"$initialRulesExecuted\": true,'+
					'                \"AddressType\": \"MAILING\",'+
					'                \"Address1\": \"700 Main St\",'+
					'                \"Country\": \"USA\",'+
					'                \"State\": \"USNE\",'+
					'                \"City\": \"Omaha\",'+
					'                \"Zip\": \"68114\",'+
					'                \"t_\": \"Address\"'+
					'            }'+
					'        ],'+
					'      \"IndustrySelection\": ['+
					'            {'+
					'                \"$new\": true,'+
					'                \"Percentage\": 1,'+
					'                \"OperationType\": \"Create\",'+
					'                \"IndustryId\": -1,'+
					'                \"Classification\": \"SIC\",'+
					'                \"IsPrimary\": true,'+
					'                \"$initialRulesExecuted\": true,'+
					'                \"IndustryCode\": {'+
					'                    \"Code\": \"1311\",'+
					'                    \"Description\": \"Crude petroleum and natural gas\",'+
					'                    \"Keys\": ['+
					'                        \"B\",'+
					'                        \"13\",'+
					'                        \"1311\"'+
					'                    ]'+
					'                }'+
					'            }'+
					'                ]'+
					''+
					'    }';

        CreditWS_CLCreateEntityRequest obj = CreditWS_CLCreateEntityRequest.parse(json);
		System.assert(obj != null);
		System.assert(obj.LongName.equalsIgnoreCase('Stock Exchange Test'));
		System.assert(obj.SystemId.equalsIgnoreCase('Application-2019120000'));
	}
}