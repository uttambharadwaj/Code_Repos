/**
 * Created by lhowland on 12/13/2019.
 */

@IsTest
public class CreditWS_CLCreateEntityResponseTest {

    static testMethod void testParseResponse() {
        String json = '{'+
                '    \"payLoad\": ['+
                '        {'+
                '            \"disableCreate\": {},'+
                '            \"EntityType\": \"CORP\",'+
                '            \"LongName\": \"Test Company\",'+
                '            \"ShortName\": \"Test\",'+
                '            \"EntityId\": 245,'+
                '            \"SystemId\": \"Application-123\",'+
                '            \"LegalEntity\": \"Text\",'+
                '            \"WexAccountNumber\": \"1234435\",'+
                '            \"TaxId\": \"12344556\",'+
                '            \"WexDunsNumber\": \"1233343\",'+
                '            \"CustomerSince\": null,'+
                '            \"CountryOfInc\": \"USA\",'+
                '            \"ProvinceStateOfIncorporation\": \"USME\",'+
                '            \"WexYearIncorporated\": \"2000\",'+
                '            \"EstablishmentDate\": \"2000\",'+
                '            \"RegistrationNumber\": \"TEST\",'+
                '            \"OnList\": null,'+
                '            \"WexYearEst\": null,'+
                '            \"WexYearControl\": null,'+
                '            \"Descriptions\": null,'+
                '            \"Gc23\": null,'+
                '            \"Gc22\": null,'+
                '            \"ExternalDataSources\": null,'+
                '            \"WexFsAvlblDate\": null,'+
                '            \"WexYearEstablished\": \"2000\",'+
                '            \"BusinessPortfolio\": \"CAN\",'+
                '            \"Division\": \"SingleSelect\",'+
                '            \"CreditPortfolio\": \"WexBank\",'+
                '            \"WexBusinessUnit\": \"CorpPay\",'+
                '            \"WexProgram\": \"Divvy\",'+
                '            \"PrimaryBankingOfficer\": \"Salesforce Integration\",'+
                '            \"PrimaryCreditOfficer\": \"Leela Howland\",'+
                '            \"t_\": \"Entity\",'+
                '            \"IsValid_\": true,'+
                '            \"IsDeleted_\": false,'+
                '            \"Access_\": 5,'+
                '            \"BaseVersionId_\": 0,'+
                '            \"VersionId_\": 1,'+
                '            \"Inapplicable_\": [],'+
                '            \"Associations_\": ['+
                '                \"EntityHierarchy\",'+
                '                \"EntityReOrgHistory\",'+
                '                \"EntityIndustry\",'+
                '                \"EntityOfficers\",'+
                '                \"Contact\",'+
                '                \"Address\",'+
                '                \"DirectorAndCompanyOfficer\",'+
                '                \"Document\",'+
                '                \"EntityGroup\",'+
                '                \"BusinessProposal\",'+
                '                \"EntityGroupEntityLink\",'+
                '                \"EntityDocumentLink\",'+
                '                \"MapInstance\",'+
                '                \"Financial\",'+
                '                \"EntityRating\",'+
                '                \"RatingScenario\",'+
                '                \"RiskGradingSettings\",'+
                '                \"RiskGradingCeSettings\",'+
                '                \"ProductBorrower\",'+
                '                \"Collateral\",'+
                '                \"EntityDealInfo\",'+
                '                \"AssetBorrower\",'+
                '                \"AssetOwner\",'+
                '                \"AuthorizedEntity\",'+
                '                \"CollateralProvider\",'+
                '                \"AssetEntityLink\",'+
                '                \"CovenantAdvanced\",'+
                '                \"CovenantTrackingProposal\",'+
                '                \"CovenantTrackingTask\",'+
                '                \"EntityCovenantStatistic\",'+
                '                \"ActiveTesting\",'+
                '                \"HistoryTesting\",'+
                '                \"StatementSelection\",'+
                '                \"Covenant\",'+
                '                \"CovenantAdvancedEntityLink\",'+
                '                \"EntityCreditMemo\",'+
                '                \"SpreadDocument\",'+
                '                \"SpreadProposal\",'+
                '                \"MarqAttribute\",'+
                '                \"Product\",'+
                '                \"Asset\",'+
                '                \"BvdAttribute\"'+
                '            ],'+
                '            \"FirmType\": \"PUB\",'+
                '            \"CountryOfRisk\": \"USA\",'+
                '            \"Currency\": \"USD\",'+
                '            \"ListingDate\": null,'+
                '            \"CountryOfListing\": \"CAN\",'+
                '            \"StockExchange\": \"TSE\",'+
                '            \"StockCode\": \"TSE\",'+
                '            \"IndClassification\": \"SIC\",'+
                '            \"WexLastReviewDate\": null,'+
                '            \"WexReviewDate\": null,'+
                '            \"WexReviewType\": \"Test\",'+
                '            \"WexRequestCurrency\": \"USD\",'+
                '            \"WexExistingCreditLineAmt\": \"200000\",'+
                '            \"WexRequestCreditLineAmount\": \"200000\",'+
                '            \"WexCreditInformationOn\": null,'+
                '            \"WexPaymentHistory\": null,'+
                '            \"WexProejctedMonthlySpend\": \"20000\",'+
                '            \"WexHighCycleSpend\": null,'+
                '            \"BillingCycle\": null,'+
                '            \"DaysToPay\": null,'+
                '            \"WexBillingCycle1\": null,'+
                '            \"WexDaysToPay1\": null,'+
                '            \"WexBillingCycle2\": null,'+
                '            \"WexDaysToPay2\": null,'+
                '            \"WexBillingCycle3\": null,'+
                '            \"WexDaysToPay3\": null,'+
                '            \"WexPaymentType\": null,'+
                '            \"CollateralSecurity\": null,'+
                '            \"CollateralSecuringEntity\": \"Text\",'+
                '            \"WexCollateralAmt\": null,'+
                '            \"WexPrimaryRiskGrade\": null,'+
                '            \"WexPrimaryRiskGradeSource\": null,'+
                '            \"WexSecondaryRiskGrade\": null,'+
                '            \"WexSecondaryRiskGradeSource\": null,'+
                '            \"WexCreditExtended\": null,'+
                '            \"WexNumberOfCreditExperiences\": null,'+
                '            \"WexPaydexScore\": \"Test\",'+
                '            \"WexOriginationModelRecommendat\": null,'+
                '            \"RequestedCreditLineDl\": null,'+
                '            \"CollateralExpirationDate\": null,'+
                '            \"CollateralAmt\": null,'+
                '            \"ExisitingCreditLineDl\": null,'+
                '            \"WexApprovedCreditLine\": \"test\",'+
                '            \"WexCreditLineCurrency\": \"Test\",'+
                '            \"NextReviewDate\": null,'+
                '            \"WexFinancialsRequestedDate\": null,'+
                '            \"WexFinancialsRequestedDate2\": null,'+
                '            \"WexFinancialsReceivedDate\": null,'+
                '            \"EntityOfficers\": [],'+
                '            \"EntityContactCreateAndEdit\": [],'+
                '            \"EntityAddress\": ['+
                '                {'+
                '                    \"AddressId\": 14,'+
                '                    \"AddressType\": \"MAILING\",'+
                '                    \"Address1\": \"700 Main St\",'+
                '                    \"Address2\": null,'+
                '                    \"Country\": \"USA\",'+
                '                    \"State\": \"USNE\",'+
                '                    \"City\": \"Omaha\",'+
                '                    \"Zip\": \"68114\",'+
                '                    \"ExternalDataSource\": null,'+
                '                    \"t_\": \"Address\",'+
                '                    \"IsValid_\": true,'+
                '                    \"IsDeleted_\": false,'+
                '                    \"Access_\": 5,'+
                '                    \"BaseVersionId_\": 0,'+
                '                    \"VersionId_\": 1,'+
                '                    \"Inapplicable_\": []'+
                '                }'+
                '            ],'+
                '            \"EntityGroupGrid\": [],'+
                '            \"IndustrySelection\": ['+
                '                {'+
                '                    \"IndustryId\": 8,'+
                '                    \"IndustryCode\": {'+
                '                        \"Code\": \"1311\",'+
                '                        \"Description\": \"Crude petroleum and natural gas\",'+
                '                        \"Keys\": ['+
                '                            \"B\",'+
                '                            \"13\",'+
                '                            \"1311\"'+
                '                        ]'+
                '                    },'+
                '                    \"Percentage\": 1.0,'+
                '                    \"IsPrimary\": true,'+
                '                    \"EntityId\": 245,'+
                '                    \"Classification\": \"SIC\",'+
                '                    \"ExternalDataSource\": null,'+
                '                    \"t_\": \"EntityIndustry\",'+
                '                    \"IsValid_\": true,'+
                '                    \"IsDeleted_\": false,'+
                '                    \"Access_\": 5,'+
                '                    \"BaseVersionId_\": 0,'+
                '                    \"VersionId_\": 1,'+
                '                    \"Inapplicable_\": []'+
                '                }'+
                '            ],'+
                '            \"DirectorAndCompanyOfficer\": [],'+
                '            \"EntityHierarchy\": [],'+
                '            \"EntityReOrgHistory\": [],'+
                '            \"EntityDocumentLinkVm\": [],'+
                '            \"UpdatedBy_\": null'+
                '        }'+
                '    ],'+
                '    \"status\": {}'+
                '}';


        CreditWS_CLCreateEntityResponse obj = CreditWS_CLCreateEntityResponse.parse(json);
        System.assert(obj != null);
    }
}