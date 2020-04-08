/**
 * Created by lhowland on 8/8/2018.
 */

@isTest
public class CreditWS_Test {

    @testSetup
    static void setup(){
        UtilityTestLoader.setAutomation(false);
    }

    static testMethod void testLexisNexisBridgerPasswordReset() {

        Test.startTest();

        TestUtils.enable_isRunningTest = true;

        Integer daysUntilPasswordReset = CreditWS_LexisNexisBridger.checkPasswordExpiration();

        System.assert(daysUntilPasswordReset == -1);

        Test.stopTest();

    }

    static testMethod void testLexisNexisBridgerWSUtil() {

        Test.startTest();

        new CreditWSUtil_LexisNexisBridger.AddAttachment_element();
        new CreditWSUtil_LexisNexisBridger.AddAttachmentResponse_element();
        new CreditWSUtil_LexisNexisBridger.AddList_element();
        new CreditWSUtil_LexisNexisBridger.AddListResponse_element();
        new CreditWSUtil_LexisNexisBridger.AddRecordResult();
        new CreditWSUtil_LexisNexisBridger.AddRecords_element();
        new CreditWSUtil_LexisNexisBridger.AddRecordsResponse_element();
        new CreditWSUtil_LexisNexisBridger.AddResultRecord_element();
        new CreditWSUtil_LexisNexisBridger.AddResultRecordResponse_element();
        new CreditWSUtil_LexisNexisBridger.ArrayOfAddRecordResult();
        new CreditWSUtil_LexisNexisBridger.ArrayOfAuditItem();
        new CreditWSUtil_LexisNexisBridger.ArrayOfCountryAKA();
        new CreditWSUtil_LexisNexisBridger.ArrayOfCountryLocation();
        new CreditWSUtil_LexisNexisBridger.ArrayOfDataFileInfo();
        new CreditWSUtil_LexisNexisBridger.ArrayOfEntityAdditionalInfo();
        new CreditWSUtil_LexisNexisBridger.ArrayOfEntityAddress();
        new CreditWSUtil_LexisNexisBridger.ArrayOfEntityAKA();
        new CreditWSUtil_LexisNexisBridger.ArrayOfEntityID();
        new CreditWSUtil_LexisNexisBridger.ArrayOfEntityMatchInfo();
        new CreditWSUtil_LexisNexisBridger.ArrayOfEntityPhone();
        new CreditWSUtil_LexisNexisBridger.ArrayOfFPRedFlag();
        new CreditWSUtil_LexisNexisBridger.ArrayOfFPResultCriteriaRedFlag();
        new CreditWSUtil_LexisNexisBridger.ArrayOfFPRiskIndicator();
        new CreditWSUtil_LexisNexisBridger.ArrayOfIIDAddressHistory();
        new CreditWSUtil_LexisNexisBridger.ArrayOfIIDAlternateName();
        new CreditWSUtil_LexisNexisBridger.ArrayOfIIDFEINMatch();
        new CreditWSUtil_LexisNexisBridger.ArrayOfIIDIDataSource();
        new CreditWSUtil_LexisNexisBridger.ArrayOfIIDIDataSourceVerification();
        new CreditWSUtil_LexisNexisBridger.ArrayOfIIDIException_x();
        new CreditWSUtil_LexisNexisBridger.ArrayOfIIDIRiskIndicator();
        new CreditWSUtil_LexisNexisBridger.ArrayOfIIDIVerificationResult();
        new CreditWSUtil_LexisNexisBridger.ArrayOfIIDRedFlag();
        new CreditWSUtil_LexisNexisBridger.ArrayOfIIDResultCriteriaRedFlag();
        new CreditWSUtil_LexisNexisBridger.ArrayOfIIDRiskIndicator();
        new CreditWSUtil_LexisNexisBridger.ArrayOfInputAdditionalInfo();
        new CreditWSUtil_LexisNexisBridger.ArrayOfInputAddress();
        new CreditWSUtil_LexisNexisBridger.ArrayOfInputID();
        new CreditWSUtil_LexisNexisBridger.ArrayOfInputPhone();
        new CreditWSUtil_LexisNexisBridger.ArrayOfInputRecord();
        new CreditWSUtil_LexisNexisBridger.ArrayOfInt();
        new CreditWSUtil_LexisNexisBridger.ArrayOfListInfo();
        new CreditWSUtil_LexisNexisBridger.ArrayOfListRecord();
        new CreditWSUtil_LexisNexisBridger.ArrayOfLong();
        new CreditWSUtil_LexisNexisBridger.ArrayOfOFACInstitutionInfo();
        new CreditWSUtil_LexisNexisBridger.ArrayOfParsedACHAdditionalInfo();
        new CreditWSUtil_LexisNexisBridger.ArrayOfParsedACHAddress();
        new CreditWSUtil_LexisNexisBridger.ArrayOfParsedACHField();
        new CreditWSUtil_LexisNexisBridger.ArrayOfParsedACHID();
        new CreditWSUtil_LexisNexisBridger.ArrayOfParsedACHNote();
        new CreditWSUtil_LexisNexisBridger.ArrayOfParsedACHParty();
        new CreditWSUtil_LexisNexisBridger.ArrayOfParsedFedwireAdditionalInfo();
        new CreditWSUtil_LexisNexisBridger.ArrayOfParsedFedwireAddress();
        new CreditWSUtil_LexisNexisBridger.ArrayOfParsedFedwireField();
        new CreditWSUtil_LexisNexisBridger.ArrayOfParsedFedwireID();
        new CreditWSUtil_LexisNexisBridger.ArrayOfParsedFedwireNote();
        new CreditWSUtil_LexisNexisBridger.ArrayOfParsedFedwireParty();
        new CreditWSUtil_LexisNexisBridger.ArrayOfParsedFedwirePhone();
        new CreditWSUtil_LexisNexisBridger.ArrayOfParsedISO20022AdditionalInfo();
        new CreditWSUtil_LexisNexisBridger.ArrayOfParsedISO20022Address();
        new CreditWSUtil_LexisNexisBridger.ArrayOfParsedISO20022Field();
        new CreditWSUtil_LexisNexisBridger.ArrayOfParsedISO20022ID();
        new CreditWSUtil_LexisNexisBridger.ArrayOfParsedISO20022Note();
        new CreditWSUtil_LexisNexisBridger.ArrayOfParsedISO20022Party();
        new CreditWSUtil_LexisNexisBridger.ArrayOfParsedISO20022Phone();
        new CreditWSUtil_LexisNexisBridger.ArrayOfParsedSWIFTAdditionalInfo();
        new CreditWSUtil_LexisNexisBridger.ArrayOfParsedSWIFTAddress();
        new CreditWSUtil_LexisNexisBridger.ArrayOfParsedSWIFTField();
        new CreditWSUtil_LexisNexisBridger.ArrayOfParsedSWIFTID();
        new CreditWSUtil_LexisNexisBridger.ArrayOfParsedSWIFTNote();
        new CreditWSUtil_LexisNexisBridger.ArrayOfParsedSWIFTParty();
        new CreditWSUtil_LexisNexisBridger.ArrayOfResultError();
        new CreditWSUtil_LexisNexisBridger.ArrayOfResultRecord();
        new CreditWSUtil_LexisNexisBridger.ArrayOfRunInfo();
        new CreditWSUtil_LexisNexisBridger.ArrayOfString();
        new CreditWSUtil_LexisNexisBridger.ArrayOfWatchlistDataFile();
        new CreditWSUtil_LexisNexisBridger.ArrayOfWatchlistMatchState();
        new CreditWSUtil_LexisNexisBridger.ArrayOfWLAddressMatch();
        new CreditWSUtil_LexisNexisBridger.ArrayOfWLCitizenshipMatch();
        new CreditWSUtil_LexisNexisBridger.ArrayOfWLDOBMatch();
        new CreditWSUtil_LexisNexisBridger.ArrayOfWLIDMatch();
        new CreditWSUtil_LexisNexisBridger.ArrayOfWLMatch();
        new CreditWSUtil_LexisNexisBridger.ArrayOfWLMatchSummaryItem();
        new CreditWSUtil_LexisNexisBridger.ArrayOfWLPhoneMatch();
        new CreditWSUtil_LexisNexisBridger.AssignmentInfo();
        new CreditWSUtil_LexisNexisBridger.Attachment();
        new CreditWSUtil_LexisNexisBridger.AuditItem();
        new CreditWSUtil_LexisNexisBridger.BasicHttpBinding_IAccount();
        new CreditWSUtil_LexisNexisBridger.BasicHttpBinding_IListMaintenance();
        new CreditWSUtil_LexisNexisBridger.BasicHttpBinding_IResults();
        new CreditWSUtil_LexisNexisBridger.BasicHttpBinding_ISearch();
        new CreditWSUtil_LexisNexisBridger.ChangePassword_element();
        new CreditWSUtil_LexisNexisBridger.ChangePasswordResponse_element();
        new CreditWSUtil_LexisNexisBridger.ClientContext();
        new CreditWSUtil_LexisNexisBridger.CountryAKA();
        new CreditWSUtil_LexisNexisBridger.CountryCriteria();
        new CreditWSUtil_LexisNexisBridger.CountryInfo();
        new CreditWSUtil_LexisNexisBridger.CountryLocation();
        new CreditWSUtil_LexisNexisBridger.DataFileInfo();
        new CreditWSUtil_LexisNexisBridger.Date_x();
        new CreditWSUtil_LexisNexisBridger.DeleteAttachment_element();
        new CreditWSUtil_LexisNexisBridger.DeleteAttachmentResponse_element();
        new CreditWSUtil_LexisNexisBridger.DeleteList_element();
        new CreditWSUtil_LexisNexisBridger.DeleteListResponse_element();
        new CreditWSUtil_LexisNexisBridger.DeleteRecords_element();
        new CreditWSUtil_LexisNexisBridger.DeleteRecordsResponse_element();
        new CreditWSUtil_LexisNexisBridger.DeleteResultRecords_element();
        new CreditWSUtil_LexisNexisBridger.DeleteResultRecordsResponse_element();
        new CreditWSUtil_LexisNexisBridger.DeleteRuns_element();
        new CreditWSUtil_LexisNexisBridger.DeleteRunsResponse_element();
        new CreditWSUtil_LexisNexisBridger.EntityAdditionalInfo();
        new CreditWSUtil_LexisNexisBridger.EntityAddress();
        new CreditWSUtil_LexisNexisBridger.EntityAKA();
        new CreditWSUtil_LexisNexisBridger.EntityCriteria();
        new CreditWSUtil_LexisNexisBridger.EntityCriteriaAdditionalInfo();
        new CreditWSUtil_LexisNexisBridger.EntityCriteriaAddress();
        new CreditWSUtil_LexisNexisBridger.EntityCriteriaID();
        new CreditWSUtil_LexisNexisBridger.EntityID();
        new CreditWSUtil_LexisNexisBridger.EntityInfo();
        new CreditWSUtil_LexisNexisBridger.EntityMatchInfo();
        new CreditWSUtil_LexisNexisBridger.EntityName();
        new CreditWSUtil_LexisNexisBridger.EntityPhone();
        new CreditWSUtil_LexisNexisBridger.FPAddress();
        new CreditWSUtil_LexisNexisBridger.FPInput();
        new CreditWSUtil_LexisNexisBridger.FPRedFlag();
        new CreditWSUtil_LexisNexisBridger.FPResultCriteriaRedFlag();
        new CreditWSUtil_LexisNexisBridger.FPRiskIndicator();
        new CreditWSUtil_LexisNexisBridger.FraudPointConfiguration();
        new CreditWSUtil_LexisNexisBridger.FraudPointResultCriteria();
        new CreditWSUtil_LexisNexisBridger.FraudPointResults();
        new CreditWSUtil_LexisNexisBridger.GetAttachment_element();
        new CreditWSUtil_LexisNexisBridger.GetAttachmentResponse_element();
        new CreditWSUtil_LexisNexisBridger.GetDataFileList_element();
        new CreditWSUtil_LexisNexisBridger.GetDataFileListResponse_element();
        new CreditWSUtil_LexisNexisBridger.GetDaysUntilPasswordExpires_element();
        new CreditWSUtil_LexisNexisBridger.GetDaysUntilPasswordExpiresResponse_element();
        new CreditWSUtil_LexisNexisBridger.GetList_element();
        new CreditWSUtil_LexisNexisBridger.GetListResponse_element();
        new CreditWSUtil_LexisNexisBridger.GetRecords_element();
        new CreditWSUtil_LexisNexisBridger.GetRecordsResponse_element();
        new CreditWSUtil_LexisNexisBridger.GetResultRecords_element();
        new CreditWSUtil_LexisNexisBridger.GetResultRecordsResponse_element();
        new CreditWSUtil_LexisNexisBridger.GetRunInfo_element();
        new CreditWSUtil_LexisNexisBridger.GetRunInfoResponse_element();
        new CreditWSUtil_LexisNexisBridger.IIDAddress();
        new CreditWSUtil_LexisNexisBridger.IIDAddressHistory();
        new CreditWSUtil_LexisNexisBridger.IIDAlternateName();
        new CreditWSUtil_LexisNexisBridger.IIDFEINMatch();
        new CreditWSUtil_LexisNexisBridger.IIDFiling();
        new CreditWSUtil_LexisNexisBridger.IIDIAddress();
        new CreditWSUtil_LexisNexisBridger.IIDIDataSource();
        new CreditWSUtil_LexisNexisBridger.IIDIDataSourceVerification();
        new CreditWSUtil_LexisNexisBridger.IIDIDate();
        new CreditWSUtil_LexisNexisBridger.IIDIException_x();
        new CreditWSUtil_LexisNexisBridger.IIDIHeader();
        new CreditWSUtil_LexisNexisBridger.IIDIIdentification();
        new CreditWSUtil_LexisNexisBridger.IIDIInput();
        new CreditWSUtil_LexisNexisBridger.IIDInput();
        new CreditWSUtil_LexisNexisBridger.IIDIPassport();
        new CreditWSUtil_LexisNexisBridger.IIDIResult();
        new CreditWSUtil_LexisNexisBridger.IIDIResultCriteriaIndividual();
        new CreditWSUtil_LexisNexisBridger.IIDIRiskIndicator();
        new CreditWSUtil_LexisNexisBridger.IIDIVerificationIndex();
        new CreditWSUtil_LexisNexisBridger.IIDIVerificationResult();
        new CreditWSUtil_LexisNexisBridger.IIDRedFlag();
        new CreditWSUtil_LexisNexisBridger.IIDResultCriteriaBusiness();
        new CreditWSUtil_LexisNexisBridger.IIDResultCriteriaIndividual();
        new CreditWSUtil_LexisNexisBridger.IIDResultCriteriaRedFlag();
        new CreditWSUtil_LexisNexisBridger.IIDReversePhone();
        new CreditWSUtil_LexisNexisBridger.IIDRiskIndicator();
        new CreditWSUtil_LexisNexisBridger.IIDSSNInfo();
        new CreditWSUtil_LexisNexisBridger.IIDVerificationIndicators();
        new CreditWSUtil_LexisNexisBridger.IIDWatchlist();
        new CreditWSUtil_LexisNexisBridger.IndexList_element();
        new CreditWSUtil_LexisNexisBridger.IndexListResponse_element();
        new CreditWSUtil_LexisNexisBridger.InputAdditionalInfo();
        new CreditWSUtil_LexisNexisBridger.InputAddress();
        new CreditWSUtil_LexisNexisBridger.InputBasicID();
        new CreditWSUtil_LexisNexisBridger.InputEFT();
        new CreditWSUtil_LexisNexisBridger.InputEntity();
        new CreditWSUtil_LexisNexisBridger.InputID();
        new CreditWSUtil_LexisNexisBridger.InputName();
        new CreditWSUtil_LexisNexisBridger.InputPhone();
        new CreditWSUtil_LexisNexisBridger.InputRecord();
        new CreditWSUtil_LexisNexisBridger.InputText();
        new CreditWSUtil_LexisNexisBridger.InstantIDBusinessResults();
        new CreditWSUtil_LexisNexisBridger.InstantIDConfiguration();
        new CreditWSUtil_LexisNexisBridger.InstantIDIndividualResults();
        new CreditWSUtil_LexisNexisBridger.InstantIDIntlConfiguration();
        new CreditWSUtil_LexisNexisBridger.InstantIDIntlIndividualResults();
        new CreditWSUtil_LexisNexisBridger.InstantIDIntlResultCriteria();
        new CreditWSUtil_LexisNexisBridger.InstantIDResultCriteria();
        new CreditWSUtil_LexisNexisBridger.ListCriteria();
        new CreditWSUtil_LexisNexisBridger.ListInfo();
        new CreditWSUtil_LexisNexisBridger.ListRecord();
        new CreditWSUtil_LexisNexisBridger.ListRecordCriteria();
        new CreditWSUtil_LexisNexisBridger.MergeDuplicates_element();
        new CreditWSUtil_LexisNexisBridger.MergeDuplicatesResponse_element();
        new CreditWSUtil_LexisNexisBridger.OFACInstitutionInfo();
        new CreditWSUtil_LexisNexisBridger.OFACReportInfo();
        new CreditWSUtil_LexisNexisBridger.ParsedACH();
        new CreditWSUtil_LexisNexisBridger.ParsedACHAdditionalInfo();
        new CreditWSUtil_LexisNexisBridger.ParsedACHAddress();
        new CreditWSUtil_LexisNexisBridger.ParsedACHField();
        new CreditWSUtil_LexisNexisBridger.ParsedACHID();
        new CreditWSUtil_LexisNexisBridger.ParsedACHNote();
        new CreditWSUtil_LexisNexisBridger.ParsedACHParty();
        new CreditWSUtil_LexisNexisBridger.ParsedFedwire();
        new CreditWSUtil_LexisNexisBridger.ParsedFedwireAdditionalInfo();
        new CreditWSUtil_LexisNexisBridger.ParsedFedwireAddress();
        new CreditWSUtil_LexisNexisBridger.ParsedFedwireAmount();
        new CreditWSUtil_LexisNexisBridger.ParsedFedwireField();
        new CreditWSUtil_LexisNexisBridger.ParsedFedwireID();
        new CreditWSUtil_LexisNexisBridger.ParsedFedwireNote();
        new CreditWSUtil_LexisNexisBridger.ParsedFedwireParty();
        new CreditWSUtil_LexisNexisBridger.ParsedFedwirePhone();
        new CreditWSUtil_LexisNexisBridger.ParsedISO20022();
        new CreditWSUtil_LexisNexisBridger.ParsedISO20022AdditionalInfo();
        new CreditWSUtil_LexisNexisBridger.ParsedISO20022Address();
        new CreditWSUtil_LexisNexisBridger.ParsedISO20022Field();
        new CreditWSUtil_LexisNexisBridger.ParsedISO20022ID();
        new CreditWSUtil_LexisNexisBridger.ParsedISO20022Note();
        new CreditWSUtil_LexisNexisBridger.ParsedISO20022Party();
        new CreditWSUtil_LexisNexisBridger.ParsedISO20022Phone();
        new CreditWSUtil_LexisNexisBridger.ParsedSWIFT();
        new CreditWSUtil_LexisNexisBridger.ParsedSWIFTAdditionalInfo();
        new CreditWSUtil_LexisNexisBridger.ParsedSWIFTAddress();
        new CreditWSUtil_LexisNexisBridger.ParsedSWIFTAmount();
        new CreditWSUtil_LexisNexisBridger.ParsedSWIFTField();
        new CreditWSUtil_LexisNexisBridger.ParsedSWIFTID();
        new CreditWSUtil_LexisNexisBridger.ParsedSWIFTNote();
        new CreditWSUtil_LexisNexisBridger.ParsedSWIFTOriginalMessage();
        new CreditWSUtil_LexisNexisBridger.ParsedSWIFTParty();
        new CreditWSUtil_LexisNexisBridger.RecordState();
        new CreditWSUtil_LexisNexisBridger.ResultCriteriaAccount();
        new CreditWSUtil_LexisNexisBridger.ResultCriteriaEFT();
        new CreditWSUtil_LexisNexisBridger.ResultCriteriaRecordState();
        new CreditWSUtil_LexisNexisBridger.ResultError();
        new CreditWSUtil_LexisNexisBridger.ResultInfo();
        new CreditWSUtil_LexisNexisBridger.ResultRecord();
        new CreditWSUtil_LexisNexisBridger.ResultRecordDetails();
        new CreditWSUtil_LexisNexisBridger.ResultsCriteria();
        new CreditWSUtil_LexisNexisBridger.RunInfo();
        new CreditWSUtil_LexisNexisBridger.RunsCriteria();
        new CreditWSUtil_LexisNexisBridger.Search_x_element();
        new CreditWSUtil_LexisNexisBridger.SearchConfiguration();
        new CreditWSUtil_LexisNexisBridger.SearchInput();
        new CreditWSUtil_LexisNexisBridger.SearchListRecords_element();
        new CreditWSUtil_LexisNexisBridger.SearchListRecordsResponse_element();
        new CreditWSUtil_LexisNexisBridger.SearchLists_element();
        new CreditWSUtil_LexisNexisBridger.SearchListsResponse_element();
        new CreditWSUtil_LexisNexisBridger.SearchRecordResults();
        new CreditWSUtil_LexisNexisBridger.SearchResponse_element();
        new CreditWSUtil_LexisNexisBridger.SearchResultRecords_element();
        new CreditWSUtil_LexisNexisBridger.SearchResultRecordsResponse_element();
        new CreditWSUtil_LexisNexisBridger.SearchResults();
        new CreditWSUtil_LexisNexisBridger.SearchRuns_element();
        new CreditWSUtil_LexisNexisBridger.SearchRunsResponse_element();
        new CreditWSUtil_LexisNexisBridger.ServiceFault();
        new CreditWSUtil_LexisNexisBridger.SetRecordState_element();
        new CreditWSUtil_LexisNexisBridger.SetRecordStateResponse_element();
        new CreditWSUtil_LexisNexisBridger.Time_x();
        new CreditWSUtil_LexisNexisBridger.UpdateList_element();
        new CreditWSUtil_LexisNexisBridger.UpdateListResponse_element();
        new CreditWSUtil_LexisNexisBridger.UpdateRecord_element();
        new CreditWSUtil_LexisNexisBridger.UpdateRecordResponse_element();
        new CreditWSUtil_LexisNexisBridger.WatchlistAutomaticFalsePositiveRules();
        new CreditWSUtil_LexisNexisBridger.WatchlistConfiguration();
        new CreditWSUtil_LexisNexisBridger.WatchlistDataFile();
        new CreditWSUtil_LexisNexisBridger.WatchlistEFTMatchOptions();
        new CreditWSUtil_LexisNexisBridger.WatchlistGeneralOptions();
        new CreditWSUtil_LexisNexisBridger.WatchlistMatchDispositionRules();
        new CreditWSUtil_LexisNexisBridger.WatchlistMatchOptions();
        new CreditWSUtil_LexisNexisBridger.WatchlistMatchState();
        new CreditWSUtil_LexisNexisBridger.WatchlistPaymentScreeningOptions();
        new CreditWSUtil_LexisNexisBridger.WatchlistResultCriteria();
        new CreditWSUtil_LexisNexisBridger.WatchlistResults();
        new CreditWSUtil_LexisNexisBridger.WLAddressMatch();
        new CreditWSUtil_LexisNexisBridger.WLCitizenshipMatch();
        new CreditWSUtil_LexisNexisBridger.WLCountryDetails();
        new CreditWSUtil_LexisNexisBridger.WLDOBMatch();
        new CreditWSUtil_LexisNexisBridger.WLEntityDetails();
        new CreditWSUtil_LexisNexisBridger.WLIDMatch();
        new CreditWSUtil_LexisNexisBridger.WLMatch();
        new CreditWSUtil_LexisNexisBridger.WLMatchConflicts();
        new CreditWSUtil_LexisNexisBridger.WLMatchFile();
        new CreditWSUtil_LexisNexisBridger.WLMatchSummary();
        new CreditWSUtil_LexisNexisBridger.WLMatchSummaryItem();
        new CreditWSUtil_LexisNexisBridger.WLPhoneMatch();

        Test.stopTest();

    }

    static testMethod void testDNBSBRIWSDL() {

        new CreditWSUtil_DNBSBRI.SBRI_GUARANTORNAMEGRP();
        new CreditWSUtil_DNBSBRI.ArrayOfSBRI_TOTALS();
        new CreditWSUtil_DNBSBRI.SBRIResponse();
        new CreditWSUtil_DNBSBRI.USDS_FEIN_CTR();
        new CreditWSUtil_DNBSBRI.ArrayOfSBRI_GUARANTORACCTGRP2();
        new CreditWSUtil_DNBSBRI.ArrayOfUSDS_SIC_NAICS_SECT();
        new CreditWSUtil_DNBSBRI.ArrayOfSBRI_PMTSUMM2();
        new CreditWSUtil_DNBSBRI.ArrayOfSBRI_PMTHIST2();
        new CreditWSUtil_DNBSBRI.customProduct8_Response();
        new CreditWSUtil_DNBSBRI.SBRI_MISC();
        new CreditWSUtil_DNBSBRI.SECTION2();
        new CreditWSUtil_DNBSBRI.ArrayOfUSDS_SCDY_SIC_GRP();
        new CreditWSUtil_DNBSBRI.SBRI_GUARANTOR2();
        new CreditWSUtil_DNBSBRI.USDS_SIC_NAICS_SECT();
        new CreditWSUtil_DNBSBRI.DGX();
        new CreditWSUtil_DNBSBRI.SBRI_TOTALS();
        new CreditWSUtil_DNBSBRI.STATUS4();
        new CreditWSUtil_DNBSBRI.ArrayOfSBRI_ACCTDETAILTOTGRP();
        new CreditWSUtil_DNBSBRI.STATUS3();
        new CreditWSUtil_DNBSBRI.STATUS2();
        new CreditWSUtil_DNBSBRI.Immediate_Delivery();
        new CreditWSUtil_DNBSBRI.SBRI_GUARANTORACCTGRP2();
        new CreditWSUtil_DNBSBRI.SBRI_PMTSUMM2();
        new CreditWSUtil_DNBSBRI.Orders();
        new CreditWSUtil_DNBSBRI.ArrayOfSBRI_PMTHISTTOT2();
        new CreditWSUtil_DNBSBRI.ArrayOfSBRI_GUARANTORACCTGRP();
        new CreditWSUtil_DNBSBRI.SBRI_MISCGRP();
        new CreditWSUtil_DNBSBRI.ArrayOfSBRI_ACCTDETAILTOTGRP2();
        new CreditWSUtil_DNBSBRI.prodOrderRequest_2();
        new CreditWSUtil_DNBSBRI.SBRI_PMTEXPR2();
        new CreditWSUtil_DNBSBRI.SBRI_ACCTDETAILTOTGRP2();
        new CreditWSUtil_DNBSBRI.SBRI_ACCTDETAILS();
        new CreditWSUtil_DNBSBRI.SBRI_ACCTDETAILS2();
        new CreditWSUtil_DNBSBRI.SBRI_PMTHISTTOT();
        new CreditWSUtil_DNBSBRI.ArrayOfSBRI_PMTHISTTOT();
        new CreditWSUtil_DNBSBRI.SBRI_PMTHIST();
        new CreditWSUtil_DNBSBRI.ArrayOfSBRI_TOTALS2();
        new CreditWSUtil_DNBSBRI.ArrayOfSBRI_MISCGRP2();
        new CreditWSUtil_DNBSBRI.AdditionalFields();
        new CreditWSUtil_DNBSBRI.SBRI_CURRSNAPSHOTGRP2();
        new CreditWSUtil_DNBSBRI.ArrayOfUSDS_PAYD_NORM_QRTL_GRP();
        new CreditWSUtil_DNBSBRI.ArrayOfstring();
        new CreditWSUtil_DNBSBRI.SBRI_CURRSNAPSHOT2();
        new CreditWSUtil_DNBSBRI.SBRI_CURRSNAPSHOTTOTGRP2();
        new CreditWSUtil_DNBSBRI.Investigation();
        new CreditWSUtil_DNBSBRI.socCode();
        new CreditWSUtil_DNBSBRI.SBRI_CURRSNAPSHOTGRP();
        new CreditWSUtil_DNBSBRI.SONRS2();
        new CreditWSUtil_DNBSBRI.SBRI_IDENTIFICATION2();
        new CreditWSUtil_DNBSBRI.ArrayOfSBRI_CURRSNAPSHOTGRP();
        new CreditWSUtil_DNBSBRI.DGX2();
        new CreditWSUtil_DNBSBRI.SBRI_GUARANTORNAMEGRP2();
        new CreditWSUtil_DNBSBRI.SONRS();
        new CreditWSUtil_DNBSBRI.SBRI_SBRIDATA();
        new CreditWSUtil_DNBSBRI.ArrayOfAdditionalFields();
        new CreditWSUtil_DNBSBRI.ArrayOfSBRI_GUARANTORNAMEGRP2();
        new CreditWSUtil_DNBSBRI.CREDITMSGSRSV22();
        new CreditWSUtil_DNBSBRI.STATUS();
        new CreditWSUtil_DNBSBRI.DATATRNRS2();
        new CreditWSUtil_DNBSBRI.SBRI_GUARANTOR();
        new CreditWSUtil_DNBSBRI.SBRI_CURRSNAPSHOT();
        new CreditWSUtil_DNBSBRI.SBRI_PMTHISTTOT2();
        new CreditWSUtil_DNBSBRI.SBRI_CURRSNAPSHOTTOTGRP();
        new CreditWSUtil_DNBSBRI.SBRI_TOTALS2();
        new CreditWSUtil_DNBSBRI.ArrayOfSBRI_CURRSNAPSHOTGRP2();
        new CreditWSUtil_DNBSBRI.DATARS();
        new CreditWSUtil_DNBSBRI.ArrayOfSBRI_PMTHIST();
        new CreditWSUtil_DNBSBRI.SBRI_PMTEXPR();
        new CreditWSUtil_DNBSBRI.ArrayOfSBRI_PMTSUMM();
        new CreditWSUtil_DNBSBRI.SBRI_MISC2();
        new CreditWSUtil_DNBSBRI.USDS_PAYD_GRP();
        new CreditWSUtil_DNBSBRI.ArrayOfUSDS_FEIN_CTR();
        new CreditWSUtil_DNBSBRI.SBRI_GUARANTORACCTGRP();
        new CreditWSUtil_DNBSBRI.ArrayOfSBRI_CURRSNAPSHOTTOTGRP2();
        new CreditWSUtil_DNBSBRI.ws_SBRIResponse();
        new CreditWSUtil_DNBSBRI.USDS_PAYD_NORM_QRTL_GRP();
        new CreditWSUtil_DNBSBRI.SBRI_PMTSUMM();
        new CreditWSUtil_DNBSBRI.SBRI_IDENTIFICATION();
        new CreditWSUtil_DNBSBRI.USDS_SCDY_SIC_GRP();
        new CreditWSUtil_DNBSBRI.SBRI_ACCTDETAILSGRP();
        new CreditWSUtil_DNBSBRI.SBRI_ACCTDETAILTOTGRP();
        new CreditWSUtil_DNBSBRI.ws_CustomProduct8();
        new CreditWSUtil_DNBSBRI.ArrayOfSBRI_CURRSNAPSHOTTOTGRP();
        new CreditWSUtil_DNBSBRI.ArrayOfUSDS_PAYD_GRP();
        new CreditWSUtil_DNBSBRI.CREDITMSGSRSV2();
        new CreditWSUtil_DNBSBRI.SIGNONMSGSRSV12();
        new CreditWSUtil_DNBSBRI.NotificationDelivery();
        new CreditWSUtil_DNBSBRI.SBRI_MISCGRP2();
        new CreditWSUtil_DNBSBRI.ws_SBRI();
        new CreditWSUtil_DNBSBRI.ArrayOfSBRI_ACCTDETAILSGRP();
        new CreditWSUtil_DNBSBRI.ArrayOfSBRI_ACCTDETAILSGRP2();
        new CreditWSUtil_DNBSBRI.DATATRNRS();
        new CreditWSUtil_DNBSBRI.SBRI_SBRIDATA2();
        new CreditWSUtil_DNBSBRI.InvestigationDelivery();
        new CreditWSUtil_DNBSBRI.SIGNONMSGSRSV1();
        new CreditWSUtil_DNBSBRI.DATARS2();
        new CreditWSUtil_DNBSBRI.ws_CustomProduct8Response();
        new CreditWSUtil_DNBSBRI.ArrayOfSBRI_GUARANTORNAMEGRP();
        new CreditWSUtil_DNBSBRI.ArrayOfSBRI_MISCGRP();
        new CreditWSUtil_DNBSBRI.SBRI_ACCTDETAILSGRP2();
        new CreditWSUtil_DNBSBRI.SECTION();
        new CreditWSUtil_DNBSBRI.SBRI_PMTHIST2();
        new CreditWSUtil_DNBSBRI.DNB_WebServices_Providers_OrderAndInvestigations_OtherProducts_wsp_SBRI_V6_Port();

    }

    static testMethod void testDNBDirectAuth() {

        Test.startTest();

        TestUtils.enable_isRunningTest = true;

        Test.setMock(HttpCalloutMock.class, new DNBDirectAuthCalloutMock());

        CreditWS_DNB.dnbDirectAuthentication();

        Test.stopTest();

    }

    static testMethod void testDNBDirectMatch() {

        Test.startTest();

        TestUtils.enable_isRunningTest = true;

        Test.setMock(HttpCalloutMock.class, new DNBDirectMatchCalloutMock());

        CreditWS_DNB.DNBDirect_MatchRequest dnbDirectMatchRequest = new CreditWS_DNB.DNBDirect_MatchRequest();

        dnbDirectMatchRequest.SingleResolution = true;
        dnbDirectMatchRequest.SubjectName = 'APEX DEVELOPING LLC';
        dnbDirectMatchRequest.StreetAddressLine1 = '7089 W BURLEIGH BLVD';
        dnbDirectMatchRequest.PrimaryTownName = 'TAVARES';
        dnbDirectMatchRequest.TerritoryName = 'FL';
        dnbDirectMatchRequest.FullPostalCode = '32778';
        dnbDirectMatchRequest.CountryISOAlpha2Code = 'US';
        dnbDirectMatchRequest.DUNSNumber = '015691399';

        CreditWS_DNB.dnbDirectClenseAndMatch(dnbDirectMatchRequest);

        Test.stopTest();

    }

    static testMethod void testGiactVerify() {

        Test.startTest();

        TestUtils.enable_isRunningTest = true;

        Test.setMock(HttpCalloutMock.class, new GiactMockCallout());

        CreditWS_Giact.GiactVerifyRequest giactVerifyRequest = new CreditWS_Giact.GiactVerifyRequest();

        giactVerifyRequest.RoutingNumber = '12345678';
        giactVerifyRequest.AccountNumber = '1234567890';
        giactVerifyRequest.BusinessName = 'WEX Inc';
        giactVerifyRequest.FederalTaxId = '123456789';

        CreditWS_Giact.GiactVerifyResponse giactVerifyResponse = CreditWS_Giact.giactVerify(giactVerifyRequest);

        System.debug('### GIACT RESPONSE: ' + giactVerifyResponse);

        Test.stopTest();

    }

    static testMethod void testLexisNexisConsumerInstantID() {

        Test.startTest();

        TestUtils.enable_isRunningTest = true;

        Test.setMock(HttpCalloutMock.class, new LexisNexisIIDCalloutMock());

        CreditWS_LexisNexisRDP.LexisNexisIIDRequest lexisNexisIIDRequest = new CreditWS_LexisNexisRDP.LexisNexisIIDRequest();

        LexisNexisIIDRequest.applicationId = '123456';
        lexisNexisIIDRequest.firstName = 'MICHAEL';
        lexisNexisIIDRequest.lastName = 'CARRATALA';
        lexisNexisIIDRequest.postalCode = '50313';
        lexisNexisIIDRequest.phoneNumber = '2095243588';
        lexisNexisIIDRequest.socialSecurityNumber = '003882722';

        CreditWS_LexisNexisRDP.LexisNexisIIDResponse lexisNexisIIDResponse = CreditWS_LexisNexisRDP.lexisNexisConsumerInstantId(LexisNexisIIDRequest);

        // This should be parsed out of the mock response successfully
        System.assert(lexisNexisIIDResponse.fraudPointScore == 0);

        Test.stopTest();

    }

    static testMethod void testLexisNexisBusinessInstantID() {

        Test.startTest();

        Test.setMock(HttpCalloutMock.class, new LexisNexisBIIDCalloutMock());

        CreditWS_LexisNexisRDP.LexisNexisBIIDRequest lexisNexisBIIDRequest = new CreditWS_LexisNexisRDP.LexisNexisBIIDRequest();

        lexisNexisBIIDRequest.applicationId = '123456';
        lexisNexisBIIDRequest.businessName = 'RB TROUT';
        lexisNexisBIIDRequest.streetAddress = '6902 COMPANY STREET RD';
        lexisNexisBIIDRequest.city = 'Modesto';
        lexisNexisBIIDRequest.state = 'CA';
        lexisNexisBIIDRequest.postalCode = '95357';
        lexisNexisBIIDRequest.phoneNumber = '8014927556';
        lexisNexisBIIDRequest.federalTaxId = '264428636';

        System.debug(CreditWS_LexisNexisRDP.lexisNexisBusinessInstantID(lexisNexisBIIDRequest));

        Test.stopTest();

    }

    static testMethod void testLexisNexisSmallBusinessAnalytics() {

        Test.startTest();

        Test.setMock(WebServiceMock.class, new CreditWSUtil_Mock());

        CreditWS_LexisNexisRDP.LexisNexisSBARequest lexisNexisSBARequest = new CreditWS_LexisNexisRDP.LexisNexisSBARequest();

        lexisNexisSBARequest.companyName = 'Test Company';
        lexisNexisSBARequest.streetAddress = '123 Test St';
        lexisNexisSBARequest.postalCode = '12345';
        lexisNexisSBARequest.phoneNumber = '207-523-6969';
        lexisNexisSBARequest.federalTaxId = '12-3456789';

        CreditWS_LexisNexisRDP.LexisNexisAuthorizedRepresenative lexisNexisAuthorizedRepresenative = new CreditWS_LexisNexisRDP.LexisNexisAuthorizedRepresenative();

        lexisNexisAuthorizedRepresenative.firstName = 'Test';
        lexisNexisAuthorizedRepresenative.lastName = 'Test';
        lexisNexisAuthorizedRepresenative.streetAddress = '123 Test Street';
        lexisNexisAuthorizedRepresenative.city = 'Test';
        lexisNexisAuthorizedRepresenative.state = 'ME';
        lexisNexisAuthorizedRepresenative.postalCode = '04074';
        lexisNexisAuthorizedRepresenative.phoneNumber = '207-523-6969';
        lexisNexisAuthorizedRepresenative.dateOfBirth = Date.Today();
        lexisNexisAuthorizedRepresenative.socialSecurityNumber = '111-11-1111';

        lexisNexisSBARequest.lexisNexisAuthorizedRepresenatives = new List<CreditWS_LexisNexisRDP.LexisNexisAuthorizedRepresenative>();

        lexisNexisSBARequest.lexisNexisAuthorizedRepresenatives.add(lexisNexisAuthorizedRepresenative);

        CreditWS_LexisNexisRDP.LexisNexisSBAResponse response = CreditWS_LexisNexisRDP.lexisNexisSmallBusinessAnalytics(lexisNexisSBARequest);

        System.assert(response.fraudScore != -1);

        Test.stopTest();

    }

    public class LexisNexisBIIDCalloutMock implements  HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HTTPResponse retVal = new HTTPResponse();
            retVal.setStatusCode(200);
            retVal.setBody('{"Status":{"ConversationId":"31000205699026","RequestId":"449916996","TransactionStatus":"passed","Reference":"123456"},"Products":[{"ProductType":"BusinessInstantID_2.0","ExecutedStepName":"Business Instant ID","ProductConfigurationName":"Wex.BIID","ProductStatus":"pass","ParameterDetails":[{"Group":"VERIFICATION_INDICATORS","Name":"VerificationIndicator_CompanyName","Values":[{"Value":"0"}]},{"Group":"VERIFICATION_INDICATORS","Name":"VerificationIndicator_StreetAddress","Values":[{"Value":"0"}]},{"Group":"VERIFICATION_INDICATORS","Name":"VerificationIndicator_City","Values":[{"Value":"0"}]},{"Group":"VERIFICATION_INDICATORS","Name":"VerificationIndicator_State","Values":[{"Value":"0"}]},{"Group":"VERIFICATION_INDICATORS","Name":"VerificationIndicator_Zip","Values":[{"Value":"0"}]},{"Group":"VERIFICATION_INDICATORS","Name":"VerificationIndicator_Phone","Values":[{"Value":"0"}]},{"Group":"VERIFICATION_INDICATORS","Name":"VerificationIndicator_FEIN","Values":[{"Value":"0"}]},{"Group":"VERIFICATION_SUMMARIES","Name":"POWID","Values":[{"Value":"0"}]},{"Group":"VERIFICATION_SUMMARIES","Name":"ProxID","Values":[{"Value":"0"}]},{"Group":"VERIFICATION_SUMMARIES","Name":"SeleID","Values":[{"Value":"0"}]},{"Group":"VERIFICATION_SUMMARIES","Name":"OrgID","Values":[{"Value":"0"}]},{"Group":"VERIFICATION_SUMMARIES","Name":"UltID","Values":[{"Value":"0"}]},{"Group":"VERIFICATION_SUMMARIES","Name":"VerificationSummary_PHONESOURCE","Values":[{"Value":"0"}]},{"Group":"VERIFICATION_SUMMARIES","Name":"VerificationSummary_BUREAU","Values":[{"Value":"0"}]},{"Group":"VERIFICATION_SUMMARIES","Name":"VerificationSummary_GOVTREGISTRATIONS","Values":[{"Value":"0"}]},{"Group":"VERIFICATION_SUMMARIES","Name":"VerificationSummary_PUBLICRECORDFILINGS","Values":[{"Value":"0"}]},{"Group":"VERIFICATION_SUMMARIES","Name":"VerificationSummary_BUSDIRECTORIES","Values":[{"Value":"0"}]}]}]}');
            return retVal;
        }
    }

    public class LexisNexisIIDCalloutMock implements  HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HTTPResponse retVal = new HTTPResponse();
            retVal.setStatusCode(200);
            retVal.setBody('{ "Status": { "ConversationId": "31000205378036", "RequestId": "449412256", "TransactionStatus": "passed", "Reference": "123456" }, "Products": [ { "ProductType": "InstantID", "ExecutedStepName": "InstantID", "ProductConfigurationName": "Wex.IID", "ProductStatus": "pass" }, { "ProductType": "FraudPoint", "ExecutedStepName": "FraudPoint", "ProductConfigurationName": "Wex.FP", "ProductStatus": "pass", "ParameterDetails": [ { "Group": "FRAUD_POINT", "Name": "LexID", "Values": [ { "Value": "0" } ] }, { "Group": "FRAUD_POINT", "Name": "Attributes", "Values": [ { "Value": "IdentityRiskLevel" }, { "Value": "IdentityAgeOldest" }, { "Value": "IdentityAgeNewest" }, { "Value": "IdentityRecentUpdate" }, { "Value": "IdentityRecordCount" }, { "Value": "IdentitySourceCount" }, { "Value": "IdentityAgeRiskIndicator" }, { "Value": "IDVerRiskLevel" }, { "Value": "IDVerSSN" }, { "Value": "IDVerName" }, { "Value": "IDVerAddress" }, { "Value": "IDVerAddressNotCurrent" }, { "Value": "IDVerAddressAssocCount" }, { "Value": "IDVerPhone" }, { "Value": "IDVerDriversLicense" }, { "Value": "IDVerDOB" }, { "Value": "IDVerSSNSourceCount" }, { "Value": "IDVerAddressSourceCount" }, { "Value": "IDVerDOBSourceCount" }, { "Value": "IDVerSSNCreditBureauCount" }, { "Value": "IDVerSSNCreditBureauDelete" }, { "Value": "IDVerAddrCreditBureauCount" }, { "Value": "SourceRiskLevel" }, { "Value": "SourceFirstReportingIdentity" }, { "Value": "SourceCreditBureau" }, { "Value": "SourceCreditBureauCount" }, { "Value": "SourceCreditBureauAgeOldest" }, { "Value": "SourceCreditBureauAgeNewest" }, { "Value": "SourceCreditBureauAgeChange" }, { "Value": "SourcePublicRecord" }, { "Value": "SourcePublicRecordCount" }, { "Value": "SourcePublicRecordCountYear" }, { "Value": "SourceEducation" }, { "Value": "SourceOccupationalLicense" }, { "Value": "SourceVoterRegistration" }, { "Value": "SourceOnlineDirectory" }, { "Value": "SourceDoNotMail" }, { "Value": "SourceAccidents" }, { "Value": "SourceBusinessRecords" }, { "Value": "SourceProperty" }, { "Value": "SourceAssets" }, { "Value": "SourcePhoneDirectoryAssistance" }, { "Value": "SourcePhoneNonPublicDirectory" }, { "Value": "VariationRiskLevel" }, { "Value": "VariationIdentityCount" }, { "Value": "VariationSSNCount" }, { "Value": "VariationSSNCountNew" }, { "Value": "VariationMSourcesSSNCount" }, { "Value": "VariationMSourcesSSNUnrelCount" }, { "Value": "VariationLastNameCount" }, { "Value": "VariationLastNameCountNew" }, { "Value": "VariationAddrCountYear" }, { "Value": "VariationAddrCountNew" }, { "Value": "VariationAddrStability" }, { "Value": "VariationAddrChangeAge" }, { "Value": "VariationDOBCount" }, { "Value": "VariationDOBCountNew" }, { "Value": "VariationPhoneCount" }, { "Value": "VariationPhoneCountNew" }, { "Value": "VariationSearchSSNCount" }, { "Value": "VariationSearchAddrCount" }, { "Value": "VariationSearchPhoneCount" }, { "Value": "SearchVelocityRiskLevel" }, { "Value": "SearchCount" }, { "Value": "SearchCountYear" }, { "Value": "SearchCountMonth" }, { "Value": "SearchCountWeek" }, { "Value": "SearchCountDay" }, { "Value": "SearchUnverifiedSSNCountYear" }, { "Value": "SearchUnverifiedAddrCountYear" }, { "Value": "SearchUnverifiedDOBCountYear" }, { "Value": "SearchUnverifiedPhoneCountYear" }, { "Value": "SearchBankingSearchCount" }, { "Value": "SearchBankingSearchCountYear" }, { "Value": "SearchBankingSearchCountMonth" }, { "Value": "SearchBankingSearchCountWeek" }, { "Value": "SearchBankingSearchCountDay" }, { "Value": "SearchHighRiskSearchCount" }, { "Value": "SearchHighRiskSearchCountYear" }, { "Value": "SearchHighRiskSearchCountMonth" }, { "Value": "SearchHighRiskSearchCountWeek" }, { "Value": "SearchHighRiskSearchCountDay" }, { "Value": "SearchFraudSearchCount" }, { "Value": "SearchFraudSearchCountYear" }, { "Value": "SearchFraudSearchCountMonth" }, { "Value": "SearchFraudSearchCountWeek" }, { "Value": "SearchFraudSearchCountDay" }, { "Value": "SearchLocateSearchCount" }, { "Value": "SearchLocateSearchCountYear" }, { "Value": "SearchLocateSearchCountMonth" }, { "Value": "SearchLocateSearchCountWeek" }, { "Value": "SearchLocateSearchCountDay" }, { "Value": "AssocRiskLevel" }, { "Value": "AssocCount" }, { "Value": "AssocDistanceClosest" }, { "Value": "AssocSuspicousIdentitiesCount" }, { "Value": "AssocCreditBureauOnlyCount" }, { "Value": "AssocCreditBureauOnlyCountNew" }, { "Value": "AssocCreditBureauOnlyCountMonth" }, { "Value": "AssocHighRiskTopologyCount" }, { "Value": "ValidationRiskLevel" }, { "Value": "ValidationSSNProblems" }, { "Value": "ValidationAddrProblems" }, { "Value": "ValidationPhoneProblems" }, { "Value": "ValidationDLProblems" }, { "Value": "ValidationIPProblems" }, { "Value": "CorrelationRiskLevel" }, { "Value": "CorrelationSSNNameCount" }, { "Value": "CorrelationSSNAddrCount" }, { "Value": "CorrelationAddrNameCount" }, { "Value": "CorrelationAddrPhoneCount" }, { "Value": "CorrelationPhoneLastNameCount" }, { "Value": "DivRiskLevel" }, { "Value": "DivSSNIdentityCount" }, { "Value": "DivSSNIdentityCountNew" }, { "Value": "DivSSNIdentityMSourceCount" }, { "Value": "DivSSNIdentityMSourceUrelCount" }, { "Value": "DivSSNLNameCount" }, { "Value": "DivSSNLNameCountNew" }, { "Value": "DivSSNAddrCount" }, { "Value": "DivSSNAddrCountNew" }, { "Value": "DivSSNAddrMSourceCount" }, { "Value": "DivAddrIdentityCount" }, { "Value": "DivAddrIdentityCountNew" }, { "Value": "DivAddrIdentityMSourceCount" }, { "Value": "DivAddrSuspIdentityCountNew" }, { "Value": "DivAddrSSNCount" }, { "Value": "DivAddrSSNCountNew" }, { "Value": "DivAddrSSNMSourceCount" }, { "Value": "DivAddrPhoneCount" }, { "Value": "DivAddrPhoneCountNew" }, { "Value": "DivAddrPhoneMSourceCount" }, { "Value": "DivPhoneIdentityCount" }, { "Value": "DivPhoneIdentityCountNew" }, { "Value": "DivPhoneIdentityMSourceCount" }, { "Value": "DivPhoneAddrCount" }, { "Value": "DivPhoneAddrCountNew" }, { "Value": "DivSearchSSNIdentityCount" }, { "Value": "DivSearchAddrIdentityCount" }, { "Value": "DivSearchAddrSuspIdentityCount" }, { "Value": "DivSearchPhoneIdentityCount" }, { "Value": "SearchComponentRiskLevel" }, { "Value": "SearchSSNSearchCount" }, { "Value": "SearchSSNSearchCountYear" }, { "Value": "SearchSSNSearchCountMonth" }, { "Value": "SearchSSNSearchCountWeek" }, { "Value": "SearchSSNSearchCountDay" }, { "Value": "SearchAddrSearchCount" }, { "Value": "SearchAddrSearchCountYear" }, { "Value": "SearchAddrSearchCountMonth" }, { "Value": "SearchAddrSearchCountWeek" }, { "Value": "SearchAddrSearchCountDay" }, { "Value": "SearchPhoneSearchCount" }, { "Value": "SearchPhoneSearchCountYear" }, { "Value": "SearchPhoneSearchCountMonth" }, { "Value": "SearchPhoneSearchCountWeek" }, { "Value": "SearchPhoneSearchCountDay" }, { "Value": "ComponentCharRiskLevel" }, { "Value": "SSNHighIssueAge" }, { "Value": "SSNLowIssueAge" }, { "Value": "SSNIssueState" }, { "Value": "SSNNonUS" }, { "Value": "InputPhoneType" }, { "Value": "IPState" }, { "Value": "IPCountry" }, { "Value": "IPContinent" }, { "Value": "InputAddrAgeOldest" }, { "Value": "InputAddrAgeNewest" }, { "Value": "InputAddrType" }, { "Value": "InputAddrLenOfRes" }, { "Value": "InputAddrDwellType" }, { "Value": "InputAddrDelivery" }, { "Value": "InputAddrActivePhoneList" }, { "Value": "InputAddrOccupantOwned" }, { "Value": "InputAddrBusinessCount" }, { "Value": "InputAddrNBRHDBusinessCount" }, { "Value": "InputAddrNBRHDSingleFamilyCount" }, { "Value": "InputAddrNBRHDMultiFamilyCount" }, { "Value": "InputAddrNBRHDMedianIncome" }, { "Value": "InputAddrNBRHDMedianValue" }, { "Value": "InputAddrNBRHDMurderIndex" }, { "Value": "InputAddrNBRHDCarTheftIndex" }, { "Value": "InputAddrNBRHDBurglaryIndex" }, { "Value": "InputAddrNBRHDCrimeIndex" }, { "Value": "InputAddrNBRHDMobilityIndex" }, { "Value": "InputAddrNBRHDVacantPropCount" }, { "Value": "AddrChangeDistance" }, { "Value": "AddrChangeStateDiff" }, { "Value": "AddrChangeIncomeDiff" }, { "Value": "AddrChangeValueDiff" }, { "Value": "AddrChangeCrimeDiff" }, { "Value": "AddrChangeEconTrajectory" }, { "Value": "AddrChangeEconTrajectoryIndex" }, { "Value": "CurrAddrAgeOldest" }, { "Value": "CurrAddrAgeNewest" }, { "Value": "CurrAddrLenOfRes" }, { "Value": "CurrAddrDwellType" }, { "Value": "CurrAddrStatus" }, { "Value": "CurrAddrActivePhoneList" }, { "Value": "CurrAddrMedianIncome" }, { "Value": "CurrAddrMedianValue" }, { "Value": "CurrAddrMurderIndex" }, { "Value": "CurrAddrCarTheftIndex" }, { "Value": "CurrAddrBurglaryIndex" }, { "Value": "CurrAddrCrimeIndex" }, { "Value": "PrevAddrAgeOldest" }, { "Value": "PrevAddrAgeNewest" }, { "Value": "PrevAddrLenOfRes" }, { "Value": "PrevAddrDwellType" }, { "Value": "PrevAddrStatus" }, { "Value": "PrevAddrOccupantOwned" }, { "Value": "PrevAddrMedianIncome" }, { "Value": "PrevAddrMedianValue" }, { "Value": "PrevAddrMurderIndex" }, { "Value": "PrevAddrCarTheftIndex" }, { "Value": "PrevAddrBurglaryIndex" }, { "Value": "PrevAddrCrimeIndex" } ] } ] } ] }');
            return retVal;
        }
    }

    public class GiactMockCallout implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HTTPResponse retVal = new HTTPResponse();
            retVal.setStatusCode(200);
            retVal.setBody('{ "ItemReferenceId": 1, "CreatedDate": "2019-03-29T09:02:48.4435051-05:00", "ErrorMessage": "sample string 3", "VerificationResponse": 0, "AccountResponseCode": 0, "BankName": "sample string 4", "AccountAddedDate": "2019-03-29T09:02:48.4435051-05:00", "AccountLastUpdatedDate": "2019-03-29T09:02:48.4435051-05:00", "AccountClosedDate": "2019-03-29T09:02:48.4435051-05:00", "BankAccountType": "sample string 5", "VoidedCheckImage": "QEA=", "FundsConfirmationResult": 0, "CustomerResponseCode": 0, "MatchedPersonData": [ { "FirstName": "sample string 1", "MiddleName": "sample string 2", "LastName": "sample string 3", "DateOfBirth": "2019-03-29T09:02:48.4455056-05:00", "IdNumber": "sample string 4", "SsnIssueState": "sample string 5", "SsnIssueStartYear": "sample string 6", "SsnIssueEndYear": "sample string 7", "SsnStatus": "sample string 8", "AddressRecords": [ { "AddressLine1": "sample string 1 sample string 2 sample string 3 sample string 4 sample string 5 sample string 6 sample string 7", "AddressLine2": "sample string 2", "City": "sample string 3", "State": "sample string 4", "ZipCode": "sample string 5", "Status": 0, "DateReported": "2019-03-29T09:02:48.4465046-05:00", "ParsedAddressLine1": { "StreetNumber": "sample string 1", "PreDirectional": "sample string 2", "StreetName": "sample string 3", "StreetSuffix": "sample string 4", "PostDirectional": "sample string 5", "UnitType": "sample string 6", "UnitIdentifier": "sample string 7" } }, { "AddressLine1": "sample string 1 sample string 2 sample string 3 sample string 4 sample string 5 sample string 6 sample string 7", "AddressLine2": "sample string 2", "City": "sample string 3", "State": "sample string 4", "ZipCode": "sample string 5", "Status": 0, "DateReported": "2019-03-29T09:02:48.4465046-05:00", "ParsedAddressLine1": { "StreetNumber": "sample string 1", "PreDirectional": "sample string 2", "StreetName": "sample string 3", "StreetSuffix": "sample string 4", "PostDirectional": "sample string 5", "UnitType": "sample string 6", "UnitIdentifier": "sample string 7" } } ], "PhoneNumbers": [ { "Classification": 0, "NumberType": 0, "AreaCode": "sample string 1", "Exchange": "sample string 2", "Suffix": "sample string 3", "PhoneNumber": "sample string 4" }, { "Classification": 0, "NumberType": 0, "AreaCode": "sample string 1", "Exchange": "sample string 2", "Suffix": "sample string 3", "PhoneNumber": "sample string 4" } ] }, { "FirstName": "sample string 1", "MiddleName": "sample string 2", "LastName": "sample string 3", "DateOfBirth": "2019-03-29T09:02:48.4455056-05:00", "IdNumber": "sample string 4", "SsnIssueState": "sample string 5", "SsnIssueStartYear": "sample string 6", "SsnIssueEndYear": "sample string 7", "SsnStatus": "sample string 8", "AddressRecords": [ { "AddressLine1": "sample string 1 sample string 2 sample string 3 sample string 4 sample string 5 sample string 6 sample string 7", "AddressLine2": "sample string 2", "City": "sample string 3", "State": "sample string 4", "ZipCode": "sample string 5", "Status": 0, "DateReported": "2019-03-29T09:02:48.4465046-05:00", "ParsedAddressLine1": { "StreetNumber": "sample string 1", "PreDirectional": "sample string 2", "StreetName": "sample string 3", "StreetSuffix": "sample string 4", "PostDirectional": "sample string 5", "UnitType": "sample string 6", "UnitIdentifier": "sample string 7" } }, { "AddressLine1": "sample string 1 sample string 2 sample string 3 sample string 4 sample string 5 sample string 6 sample string 7", "AddressLine2": "sample string 2", "City": "sample string 3", "State": "sample string 4", "ZipCode": "sample string 5", "Status": 0, "DateReported": "2019-03-29T09:02:48.4465046-05:00", "ParsedAddressLine1": { "StreetNumber": "sample string 1", "PreDirectional": "sample string 2", "StreetName": "sample string 3", "StreetSuffix": "sample string 4", "PostDirectional": "sample string 5", "UnitType": "sample string 6", "UnitIdentifier": "sample string 7" } } ], "PhoneNumbers": [ { "Classification": 0, "NumberType": 0, "AreaCode": "sample string 1", "Exchange": "sample string 2", "Suffix": "sample string 3", "PhoneNumber": "sample string 4" }, { "Classification": 0, "NumberType": 0, "AreaCode": "sample string 1", "Exchange": "sample string 2", "Suffix": "sample string 3", "PhoneNumber": "sample string 4" } ] } ], "ConsumerAlertMessages": [ { "Code": "sample string 1", "Description": "sample string 2" }, { "Code": "sample string 1", "Description": "sample string 2" } ], "MatchedBusinessData": [ { "NameRecords": [ { "BusinessName": "sample string 1", "BusinessType": "sample string 2" }, { "BusinessName": "sample string 1", "BusinessType": "sample string 2" } ], "MatchingBusinessContactFound": true, "FEIN": "sample string 1", "DunsNumber": "sample string 2", "CorporationType": "sample string 3", "RegistrationType": "sample string 4", "IncorporationState": "sample string 5", "IncorporationDate": "2019-03-29T09:02:48.4485056-05:00", "FilingNumber": "sample string 6", "Industries": [ "sample string 1", "sample string 2" ], "Domains": [ "sample string 1", "sample string 2" ], "AddressRecords": [ { "AddressLine1": "sample string 1 sample string 2 sample string 3 sample string 4 sample string 5 sample string 6 sample string 7", "AddressLine2": "sample string 2", "City": "sample string 3", "State": "sample string 4", "ZipCode": "sample string 5", "ParsedAddressLine1": { "StreetNumber": "sample string 1", "PreDirectional": "sample string 2", "StreetName": "sample string 3", "StreetSuffix": "sample string 4", "PostDirectional": "sample string 5", "UnitType": "sample string 6", "UnitIdentifier": "sample string 7" } }, { "AddressLine1": "sample string 1 sample string 2 sample string 3 sample string 4 sample string 5 sample string 6 sample string 7", "AddressLine2": "sample string 2", "City": "sample string 3", "State": "sample string 4", "ZipCode": "sample string 5", "ParsedAddressLine1": { "StreetNumber": "sample string 1", "PreDirectional": "sample string 2", "StreetName": "sample string 3", "StreetSuffix": "sample string 4", "PostDirectional": "sample string 5", "UnitType": "sample string 6", "UnitIdentifier": "sample string 7" } } ], "PhoneNumbers": [ { "Classification": 0, "NumberType": 0, "AreaCode": "sample string 1", "Exchange": "sample string 2", "Suffix": "sample string 3", "PhoneNumber": "sample string 4" }, { "Classification": 0, "NumberType": 0, "AreaCode": "sample string 1", "Exchange": "sample string 2", "Suffix": "sample string 3", "PhoneNumber": "sample string 4" } ], "BusinessContacts": [ { "FirstName": "sample string 1", "MiddleName": "sample string 2", "LastName": "sample string 3", "Title": "sample string 4" }, { "FirstName": "sample string 1", "MiddleName": "sample string 2", "LastName": "sample string 3", "Title": "sample string 4" } ], "BankruptcySubjectRecordCount": 7, "BankruptcyCreditorRecordCount": 8, "MiscellaneousDetails": "sample string 9", "BusinessReportKey": "sample string 10" }, { "NameRecords": [ { "BusinessName": "sample string 1", "BusinessType": "sample string 2" }, { "BusinessName": "sample string 1", "BusinessType": "sample string 2" } ], "MatchingBusinessContactFound": true, "FEIN": "sample string 1", "DunsNumber": "sample string 2", "CorporationType": "sample string 3", "RegistrationType": "sample string 4", "IncorporationState": "sample string 5", "IncorporationDate": "2019-03-29T09:02:48.4485056-05:00", "FilingNumber": "sample string 6", "Industries": [ "sample string 1", "sample string 2" ], "Domains": [ "sample string 1", "sample string 2" ], "AddressRecords": [ { "AddressLine1": "sample string 1 sample string 2 sample string 3 sample string 4 sample string 5 sample string 6 sample string 7", "AddressLine2": "sample string 2", "City": "sample string 3", "State": "sample string 4", "ZipCode": "sample string 5", "ParsedAddressLine1": { "StreetNumber": "sample string 1", "PreDirectional": "sample string 2", "StreetName": "sample string 3", "StreetSuffix": "sample string 4", "PostDirectional": "sample string 5", "UnitType": "sample string 6", "UnitIdentifier": "sample string 7" } }, { "AddressLine1": "sample string 1 sample string 2 sample string 3 sample string 4 sample string 5 sample string 6 sample string 7", "AddressLine2": "sample string 2", "City": "sample string 3", "State": "sample string 4", "ZipCode": "sample string 5", "ParsedAddressLine1": { "StreetNumber": "sample string 1", "PreDirectional": "sample string 2", "StreetName": "sample string 3", "StreetSuffix": "sample string 4", "PostDirectional": "sample string 5", "UnitType": "sample string 6", "UnitIdentifier": "sample string 7" } } ], "PhoneNumbers": [ { "Classification": 0, "NumberType": 0, "AreaCode": "sample string 1", "Exchange": "sample string 2", "Suffix": "sample string 3", "PhoneNumber": "sample string 4" }, { "Classification": 0, "NumberType": 0, "AreaCode": "sample string 1", "Exchange": "sample string 2", "Suffix": "sample string 3", "PhoneNumber": "sample string 4" } ], "BusinessContacts": [ { "FirstName": "sample string 1", "MiddleName": "sample string 2", "LastName": "sample string 3", "Title": "sample string 4" }, { "FirstName": "sample string 1", "MiddleName": "sample string 2", "LastName": "sample string 3", "Title": "sample string 4" } ], "BankruptcySubjectRecordCount": 7, "BankruptcyCreditorRecordCount": 8, "MiscellaneousDetails": "sample string 9", "BusinessReportKey": "sample string 10" } ], "OfacListPotentialMatches": [ { "EntityId": 1, "Summary": { "PotentialMatchLevel": 0, "PotentialMatchDetails": [ "sample string 1", "sample string 2" ], "PotentialMatchAka": true }, "Name": { "ListItemName": "sample string 1", "FirstName": "sample string 2", "MiddleName": "sample string 3", "LastName": "sample string 4" }, "Title": "sample string 1", "DataSource": "sample string 2", "ProgramNames": [ "sample string 1", "sample string 2" ], "AlsoKnownAs": [ "sample string 1", "sample string 2" ], "Associations": [ "sample string 1", "sample string 2" ], "DateOfBirthListings": [ "sample string 1", "sample string 2" ], "PlaceOfBirthListings": [ "sample string 1", "sample string 2" ], "Nationalities": [ "sample string 1", "sample string 2" ], "NationalIds": [ "sample string 1", "sample string 2" ], "Citizenships": [ "sample string 1", "sample string 2" ], "Passports": [ "sample string 1", "sample string 2" ], "Website": "sample string 3", "TaxIdNumber": "sample string 4", "EmailAddress": "sample string 5", "Addresses": [ { "Address": "sample string 1", "CityStatePost": "sample string 2", "Country": "sample string 3", "Remarks": "sample string 4" }, { "Address": "sample string 1", "CityStatePost": "sample string 2", "Country": "sample string 3", "Remarks": "sample string 4" } ], "Remarks": "sample string 6", "LastUpdatedDate": "2019-03-29T09:02:48.4525055-05:00", "Gender": "sample string 7" }, { "EntityId": 1, "Summary": { "PotentialMatchLevel": 0, "PotentialMatchDetails": [ "sample string 1", "sample string 2" ], "PotentialMatchAka": true }, "Name": { "ListItemName": "sample string 1", "FirstName": "sample string 2", "MiddleName": "sample string 3", "LastName": "sample string 4" }, "Title": "sample string 1", "DataSource": "sample string 2", "ProgramNames": [ "sample string 1", "sample string 2" ], "AlsoKnownAs": [ "sample string 1", "sample string 2" ], "Associations": [ "sample string 1", "sample string 2" ], "DateOfBirthListings": [ "sample string 1", "sample string 2" ], "PlaceOfBirthListings": [ "sample string 1", "sample string 2" ], "Nationalities": [ "sample string 1", "sample string 2" ], "NationalIds": [ "sample string 1", "sample string 2" ], "Citizenships": [ "sample string 1", "sample string 2" ], "Passports": [ "sample string 1", "sample string 2" ], "Website": "sample string 3", "TaxIdNumber": "sample string 4", "EmailAddress": "sample string 5", "Addresses": [ { "Address": "sample string 1", "CityStatePost": "sample string 2", "Country": "sample string 3", "Remarks": "sample string 4" }, { "Address": "sample string 1", "CityStatePost": "sample string 2", "Country": "sample string 3", "Remarks": "sample string 4" } ], "Remarks": "sample string 6", "LastUpdatedDate": "2019-03-29T09:02:48.4525055-05:00", "Gender": "sample string 7" } ], "GIdentifyKbaResult": [ { "Question": "sample string 1", "PossibleAnswers": [ { "Answer": "sample string 1", "IsCorrect": true }, { "Answer": "sample string 1", "IsCorrect": true } ] }, { "Question": "sample string 1", "PossibleAnswers": [ { "Answer": "sample string 1", "IsCorrect": true }, { "Answer": "sample string 1", "IsCorrect": true } ] } ], "EmailAddressInformationResult": { "EmailAddressFound": true, "EmailAddressOwnerName": "sample string 2", "EmailAddressOwnerCompany": "sample string 3", "EmailAddressOwnerTitle": "sample string 4", "EmailAddressOwnerPhoto": "QEA=", "EmailAddressStatus": "sample string 5", "EmailAddressStatusId": 6, "EmailAddressAdvice": 0, "EmailAddressCreatedDate": "2019-03-29T09:02:48.4535055-05:00", "FirstSeen": "2019-03-29T09:02:48.4535055-05:00", "LastSeen": "2019-03-29T09:02:48.4535055-05:00", "Domain": "sample string 7", "DomainExists": true, "DomainCreatedDate": "2019-03-29T09:02:48.4545055-05:00", "DomainCompany": "sample string 9", "DomainCountry": "sample string 10", "DomainCategory": "sample string 11", "DomainRisk": 0, "SocialMediaLinks": [ "sample string 1", "sample string 2" ], "SourceIndustry": "sample string 12", "Fraud": 0, "IsNotDeliverable": true }, "IpAddressInformationResult": { "Location": { "Latitude": 1.1, "Longitude": 2.1, "City": "sample string 3", "StateRegion": "sample string 4", "ZipPostalCode": "sample string 5", "Country": "sample string 6", "AccuracyRadius": 1, "Distance": 1, "ZipCodeMatch": true, "CityMatch": true, "StateMatch": true, "CountryMatch": true }, "UserType": 0, "NetSpeed": 0, "Domain": "sample string 1", "ISP": "sample string 2", "Organization": "sample string 3", "CorporateProxy": true, "AnonymousProxy": true }, "DomainRegistry": { "DomainName": "sample string 1", "CreationDate": "2019-03-29T09:02:48.4565054-05:00", "UpdateDate": "2019-03-29T09:02:48.4565054-05:00", "ExpirationDate": "2019-03-29T09:02:48.4565054-05:00", "Status": [ "sample string 1", "sample string 2" ], "RegistrarName": "sample string 2", "RegistrarWhoisServer": "sample string 3", "NameServers": [ "sample string 1", "sample string 2" ], "RegistrantName": "sample string 4", "RegistrantOrganization": "sample string 5", "RegistrantAddress": { "AddressLine1": "sample string 1 sample string 2 sample string 3 sample string 4 sample string 5 sample string 6 sample string 7", "AddressLine2": "sample string 2", "City": "sample string 3", "State": "sample string 4", "ZipCode": "sample string 5", "ParsedAddressLine1": { "StreetNumber": "sample string 1", "PreDirectional": "sample string 2", "StreetName": "sample string 3", "StreetSuffix": "sample string 4", "PostDirectional": "sample string 5", "UnitType": "sample string 6", "UnitIdentifier": "sample string 7" } }, "RegistrantPhone": { "Classification": 0, "NumberType": 0, "AreaCode": "sample string 1", "Exchange": "sample string 2", "Suffix": "sample string 3", "PhoneNumber": "sample string 4" }, "RegistrantEmailAddress": "sample string 6", "AdminName": "sample string 7", "AdminOrganization": "sample string 8", "AdminAddress": { "AddressLine1": "sample string 1 sample string 2 sample string 3 sample string 4 sample string 5 sample string 6 sample string 7", "AddressLine2": "sample string 2", "City": "sample string 3", "State": "sample string 4", "ZipCode": "sample string 5", "ParsedAddressLine1": { "StreetNumber": "sample string 1", "PreDirectional": "sample string 2", "StreetName": "sample string 3", "StreetSuffix": "sample string 4", "PostDirectional": "sample string 5", "UnitType": "sample string 6", "UnitIdentifier": "sample string 7" } }, "AdminPhone": { "Classification": 0, "NumberType": 0, "AreaCode": "sample string 1", "Exchange": "sample string 2", "Suffix": "sample string 3", "PhoneNumber": "sample string 4" }, "AdminEmailAddress": "sample string 9", "TechnicalName": "sample string 10", "TechnicalOrganization": "sample string 11", "TechnicalAddress": { "AddressLine1": "sample string 1 sample string 2 sample string 3 sample string 4 sample string 5 sample string 6 sample string 7", "AddressLine2": "sample string 2", "City": "sample string 3", "State": "sample string 4", "ZipCode": "sample string 5", "ParsedAddressLine1": { "StreetNumber": "sample string 1", "PreDirectional": "sample string 2", "StreetName": "sample string 3", "StreetSuffix": "sample string 4", "PostDirectional": "sample string 5", "UnitType": "sample string 6", "UnitIdentifier": "sample string 7" } }, "TechnicalPhone": { "Classification": 0, "NumberType": 0, "AreaCode": "sample string 1", "Exchange": "sample string 2", "Suffix": "sample string 3", "PhoneNumber": "sample string 4" }, "TechnicalEmailAddress": "sample string 12" }, "MobileVerifyResult": { "NumberMatch": true, "NumberType": 0, "IsParticipatingMobileNetwork": true, "StatusInformation": { "IdentityAge": 0, "CurrentMNO": 0, "AccountStatus": 0, "AccountPaymentType": 0, "AccountOwnerType": 0, "AccountUserType": 0, "StatusEvents": [ { "EventType": 0, "EventDate": "2019-03-29T09:02:48.4585069-05:00" }, { "EventType": 0, "EventDate": "2019-03-29T09:02:48.4585069-05:00" } ] } }, "MobileIdentifyResult": { "NameMatch": 0, "AddressMatch": 0, "EmailMatch": 0, "MatchSource": 0 }, "MobileLocationResult": { "Latitude": 1.1, "Longitude": 2.1, "City": "sample string 3", "StateRegion": "sample string 4", "ZipPostalCode": "sample string 5", "Country": "sample string 6", "AccuracyRadius": 1, "Distance": 1, "ZipCodeMatch": true, "CityMatch": true, "StateMatch": true, "CountryMatch": true }, "PhoneIntelligenceResult": { "LineType": 0, "Carrier": "sample string 1", "IsCommercial": true, "IsPrepaid": true } }');
            return retVal;
        }
    }

    public class DNBDirectAuthCalloutMock implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HTTPResponse retVal = new HTTPResponse();
            retVal.setStatusCode(200);
            retVal.setBody('{ "TransactionDetail": { "ServiceTransactionID": "Id-afded95b2e25979af164495c", "TransactionTimestamp": "2018-10-31T12:56:15.666", "ApplicationTransactionID": "" }, "TransactionResult": { "SeverityText": "Information", "ResultID": "CM000", "ResultText": "Success", "ResultMessage": { "ResultDescription": "Success" } }, "AuthenticationDetail": { "Token": "BmavuHyBVprxcIxkRgzLSDLyHyFr8zNlXTTJloRKRZxVuZgKKVgiJQxYgbq7682Ot755taWKfqa" } }');
            return retVal;
        }
    }

    public class DNBDirectMatchCalloutMock implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HTTPResponse retVal = new HTTPResponse();
            retVal.setStatusCode(200);
            retVal.setBody('{ "GetCleanseMatchResponse": { "TransactionDetail": { "ServiceTransactionID": "Id-bcded95b0eaced282bf8272c-2", "TransactionTimestamp": "2018-10-31T12:56:28" }, "TransactionResult": { "SeverityText": "Information", "ResultID": "CM000", "ResultText": "Success" }, "GetCleanseMatchResponseDetail": { "InquiryDetail": { "DUNSNumber": "15691399", "Address": { "CountryISOAlpha2Code": "US" } }, "MatchResponseDetail": { "MatchDataCriteriaText": { "$": "DUNS Number Lookup" }, "CandidateMatchedQuantity": 1, "MatchCandidate": [ { "DUNSNumber": "015691399", "OrganizationPrimaryName": { "OrganizationName": { "$": "APEX DEVELOPING LLC" } }, "PrimaryAddress": { "StreetAddressLine": [ { "LineText": "7089 W BURLEIGH BLVD" } ], "PrimaryTownName": "TAVARES", "CountryISOAlpha2Code": "US", "PostalCode": "32778", "TerritoryAbbreviatedName": "FL", "UndeliverableIndicator": true }, "MailingAddress": { "CountryISOAlpha2Code": "US", "UndeliverableIndicator": true }, "OperatingStatusText": { "$": "Active" }, "StandaloneOrganizationIndicator": true, "MatchQualityInformation": { "ConfidenceCodeValue": 10, "MatchGradeText": "AAAAAAAAAAA", "MatchGradeComponentCount": 11, "MatchGradeComponent": [ { "MatchGradeComponentTypeText": { "$": "Name" }, "MatchGradeComponentRating": "A", "MatchGradeComponentScore": 0 }, { "MatchGradeComponentTypeText": { "$": "Street Number" }, "MatchGradeComponentRating": "A", "MatchGradeComponentScore": 0 }, { "MatchGradeComponentTypeText": { "$": "Street Name" }, "MatchGradeComponentRating": "A", "MatchGradeComponentScore": 0 }, { "MatchGradeComponentTypeText": { "$": "City" }, "MatchGradeComponentRating": "A", "MatchGradeComponentScore": 0 }, { "MatchGradeComponentTypeText": { "$": "State" }, "MatchGradeComponentRating": "A", "MatchGradeComponentScore": 0 }, { "MatchGradeComponentTypeText": { "$": "PO Box" }, "MatchGradeComponentRating": "A", "MatchGradeComponentScore": 0 }, { "MatchGradeComponentTypeText": { "$": "Phone" }, "MatchGradeComponentRating": "A", "MatchGradeComponentScore": 0 }, { "MatchGradeComponentTypeText": { "$": "Postal Code" }, "MatchGradeComponentRating": "A", "MatchGradeComponentScore": 0 }, { "MatchGradeComponentTypeText": { "$": "Density" }, "MatchGradeComponentRating": "A", "MatchGradeComponentScore": 0 }, { "MatchGradeComponentTypeText": { "$": "Uniqueness" }, "MatchGradeComponentRating": "A", "MatchGradeComponentScore": 0 }, { "MatchGradeComponentTypeText": { "$": "Sic" }, "MatchGradeComponentRating": "A", "MatchGradeComponentScore": 0 } ], "MatchDataProfileComponentCount": 0 }, "DisplaySequence": 1 } ] } } } }');
            return retVal;
        }
    }

}