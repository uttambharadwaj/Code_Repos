/**
 * Created by dgilbert on 6/26/20.
 */

@isTest
public with sharing class InvoicePDFViewerTest {

    static testMethod void testInvoicePDFViewer() {

        Test.setMock(WebServiceMock.class, new CustomerDetailsWSUtilv2_Mock());

        Test.startTest();

        TestUtils.enable_isRunningTest = true;

        InvoicePDFViewerController invoicePDFViewerController = new InvoicePDFViewerController();

        PageReference invoicePDFViewer = Page.InvoicePDFViewer;
        invoicePDFViewer.getParameters().put('recordId', '123456789');

        Test.setCurrentPage(invoicePDFViewer);

        invoicePDFViewerController.init();

        System.assert(!String.isEmpty(invoicePDFViewerController.pdfContent));

        Test.stopTest();

    }

    static testMethod void testInvoicePDFViewerError() {

        Test.setMock(WebServiceMock.class, new CustomerDetailsWSUtilv2_Mock());

        Test.startTest();

        TestUtils.enable_isRunningTest = true;

        InvoicePDFViewerController invoicePDFViewerController = new InvoicePDFViewerController();

        PageReference invoicePDFViewer = Page.InvoicePDFViewer;
        invoicePDFViewer.getParameters().put('recordId', null);

        Test.setCurrentPage(invoicePDFViewer);

        invoicePDFViewerController.init();

        System.assert(String.isEmpty(invoicePDFViewerController.pdfContent));
        System.assert(!String.isEmpty(invoicePDFViewerController.errorMessage));
        
        invoicePDFViewerController.testBypass();

        Test.stopTest();

    }
    
    static testMethod void jasonTest() {
        
new CustomerDetailsWSUtilv2.getOtrContractsResponse();
new CustomerDetailsWSUtilv2.getOtrContractResponse();
new CustomerDetailsWSUtilv2.entry_element();
new CustomerDetailsWSUtilv2.otrContracts_element();
new CustomerDetailsWSUtilv2.contracts_element();
new CustomerDetailsWSUtilv2.otrContract();
new CustomerDetailsWSUtilv2.getOtrContracts();
new CustomerDetailsWSUtilv2.otrContractsResponse();
new CustomerDetailsWSUtilv2.accountSearchRequest();
new CustomerDetailsWSUtilv2.payments();
new CustomerDetailsWSUtilv2.getContactsResponse();
new CustomerDetailsWSUtilv2.getContacts();
new CustomerDetailsWSUtilv2.getInvoices();
new CustomerDetailsWSUtilv2.agingHistory();
new CustomerDetailsWSUtilv2.invoices();
new CustomerDetailsWSUtilv2.contact();
new CustomerDetailsWSUtilv2.getPaymentsResponse();
new CustomerDetailsWSUtilv2.getRefundAdjustmentTotalsResponse();
new CustomerDetailsWSUtilv2.paymentDetailEntry();
new CustomerDetailsWSUtilv2.authSearchResult();
new CustomerDetailsWSUtilv2.customerDetails();
new CustomerDetailsWSUtilv2.getRecentDeclinedAuthsResponse();
new CustomerDetailsWSUtilv2.authLogRecord();
new CustomerDetailsWSUtilv2.invoiceEntry();
new CustomerDetailsWSUtilv2.address();
new CustomerDetailsWSUtilv2.accountSearchResponse();
new CustomerDetailsWSUtilv2.getRecentDeclinedAuths();
new CustomerDetailsWSUtilv2.customerDetailsRequest();
new CustomerDetailsWSUtilv2.getPayments();
new CustomerDetailsWSUtilv2.getInvoicesResponse();
new CustomerDetailsWSUtilv2.updateSalesforceID();
new CustomerDetailsWSUtilv2.accountSearch();
new CustomerDetailsWSUtilv2.refundAdjustmentAggregateDTO();
new CustomerDetailsWSUtilv2.getCustomerDetailsResponse();
new CustomerDetailsWSUtilv2.getAgingHistory();
new CustomerDetailsWSUtilv2.getAgingHistoryResponse();
new CustomerDetailsWSUtilv2.pdAsset();
new CustomerDetailsWSUtilv2.getRefundAdjustmentTotals();
new CustomerDetailsWSUtilv2.accountSearchDTO();
new CustomerDetailsWSUtilv2.getCustomerDetails();
new CustomerDetailsWSUtilv2.updateSalesforceIDResponse();
new CustomerDetailsWSUtilv2.contacts();
new CustomerDetailsWSUtilv2.paymentHistoryEntry();
new CustomerDetailsWSUtilv2.pendingPaymentEntry();
new CustomerDetailsWSUtilv2.accountSearchResult();
new CustomerDetailsWSUtilv2.getRefunds();
new CustomerDetailsWSUtilv2.getAdjustments();
new CustomerDetailsWSUtilv2.getRefundsResponse();
new CustomerDetailsWSUtilv2.getAdjustmentsResponse();
new CustomerDetailsWSUtilv2.refundAdjustmentDTO();
new CustomerDetailsWSUtilv2.refundAdjustment();
new CustomerDetailsWSUtilv2.getOtrContract();
new CustomerDetailsWSUtilv2.getOtrInvoiceList();
new CustomerDetailsWSUtilv2.otrInvoiceEntry();
new CustomerDetailsWSUtilv2.otrInvoices();
new CustomerDetailsWSUtilv2.getOtrInvoicePdfResponse();
new CustomerDetailsWSUtilv2.getOtrInvoicePdf();
new CustomerDetailsWSUtilv2.otrInvoiceResponse();
new CustomerDetailsWSUtilv2.getOtrInvoiceListResponse();
new CustomerDetailsWSUtilv2.CustomerDetailsSOAPQSPort();
        
    }

}