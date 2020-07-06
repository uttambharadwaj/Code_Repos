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

        Test.stopTest();

    }

}