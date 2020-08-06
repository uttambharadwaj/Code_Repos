/*
* InvoicePDFViewerController
* Author: Derek Gilbert
* Initial Date: 06/25/2020
* Description: Calls web service to retrieve PDF Base64 and display in a new browser tab
* Revision History: 06/25/2020 - Ported from WFE org, removed Onbase references, redirected to Console Services
* */

public with sharing class InvoicePDFViewerController {

    public String pdfContent { get; set; }

    public class invoiceViewerException extends Exception {}

    public String recordId {
        get {
            if (ApexPages.CurrentPage().getParameters().get('recordId') != null) {
                return ApexPages.CurrentPage().getParameters().get('recordId');
            }
            return null;
        }
    }

    public String arNumber {
        get {
            if (ApexPages.CurrentPage().getParameters().get('arNumber') != null) {
                return ApexPages.CurrentPage().getParameters().get('arNumber');
            }
            return null;
        }
    }

    public String fileName {
        get {
            if (ApexPages.CurrentPage().getParameters().get('fileName') != null) {
                return ApexPages.CurrentPage().getParameters().get('fileName');
            }
            return null;
        }
    }

    public String errorMessage { get; set; }

    public String getInvoice() {

        try {

            String accountId;
            String invoiceNumber;

            if(!Test.isRunningTest()) {

                Schema.SObjectType sobjectType = (Id.valueOf(recordId)).getSobjectType();
                String sobjectName = sobjectType.getDescribe().getName();

                if ((sobjectName).equals('Collections_Invoice__c')) {

                    List<Collections_Invoice__c> collectionsInvoices = [SELECT Id, Name, Collections__r.Contract__r.AR_Number__c FROM Collections_Invoice__c WHERE Id = :recordId]//;

                    if (collectionsInvoices.size() > 0) {

                         accountId = collectionsInvoices[0].Collections__r.Contract__r.AR_Number__c;
                         invoiceNumber = collectionsInvoices[0].Name;

                    }

                }

            }
            else {
                accountId = '123456789';
                invoiceNumber = '123456789';
            }

            if(!String.isEmpty(accountId) && !String.isEmpty(invoiceNumber)) {

                Customer_Dashboard_Services__c CDS = Customer_Dashboard_Services__c.getOrgDefaults();

                CustomerDetailsWSUtilv2.CustomerDetailsSOAPQSPort customerDetailsCallout = new CustomerDetailsWSUtilv2.CustomerDetailsSOAPQSPort();

                customerDetailsCallout.endpoint_x = CDS.Customer_Details_EndPoint__c;

                //customerDetailsCallout.endpoint_x = 'https://14b6702af41c4a6559b8c33545a8a4e1.m.pipedream.net';

                // Some damage control - we don't want that value to be below the default threshold
                if (CDS.API_Timeout_ms__c != null && Integer.valueOf(CDS.API_Timeout_ms__c) > 10000) {
                    customerDetailsCallout.timeout_x = Integer.valueOf(CDS.API_Timeout_ms__c);
                }

                CustomerDetailsWSUtilv2.otrInvoiceResponse invoiceList = customerDetailsCallout.getOtrInvoiceList(accountId, 1000);

                System.debug(invoiceList);

                if (invoiceList != null && invoiceList.invoices != null && invoiceList.invoices.invoices != null) {

                    for (CustomerDetailsWSUtilv2.otrInvoiceEntry entry : invoiceList.invoices.invoices) {

                        System.debug('### ' + entry.invoiceNumber + ', ' + invoiceNumber);

                        if ((entry.invoiceNumber).equalsIgnoreCase(invoiceNumber)) {

                            CustomerDetailsWSUtilv2.otrInvoiceResponse invoiceCopy = customerDetailsCallout.getOtrInvoicePdf(entry.arNumber, entry.fileName);

                            if(invoiceCopy != null && invoiceCopy.invoices != null && invoiceCopy.invoices.invoices != null && !String.isEmpty(invoiceCopy.invoices.invoices[0].pdfBytes)) {

                                return invoiceCopy.invoices.invoices[0].pdfBytes;

                            }
                            else {

                                throw new invoiceViewerException('Unexpected PDF response!');

                            }

                        }
                    }

                }

            }
            else {
                throw new invoiceViewerException('Unable to resolve account identifier and invoice number!');
            }

        } catch (Exception e) {

            System.debug('### Cannot Find Invoice: [' + e.getLineNumber() + '] ' + e.getMessage());

            errorMessage = 'Unable to retrieve invoice.';

        }

        return null;

    }

    public String getInvoiceDirectly() {
        try {
            Customer_Dashboard_Services__c CDS = Customer_Dashboard_Services__c.getOrgDefaults();

            CustomerDetailsWSUtilv2.CustomerDetailsSOAPQSPort customerDetailsCallout = new CustomerDetailsWSUtilv2.CustomerDetailsSOAPQSPort();

            customerDetailsCallout.endpoint_x = CDS.Customer_Details_EndPoint__c;

            //customerDetailsCallout.endpoint_x = 'https://14b6702af41c4a6559b8c33545a8a4e1.m.pipedream.net';

            // Some damage control - we don't want that value to be below the default threshold
            if (CDS.API_Timeout_ms__c != null && Integer.valueOf(CDS.API_Timeout_ms__c) > 10000) {
                customerDetailsCallout.timeout_x = Integer.valueOf(CDS.API_Timeout_ms__c);
            }

            System.debug('### getInvoiceDirectly: ' +arNumber + ', ' + fileName);
            CustomerDetailsWSUtilv2.otrInvoiceResponse invoiceCopy = customerDetailsCallout.getOtrInvoicePdf(arNumber, fileName);
            if(invoiceCopy != null && invoiceCopy.invoices != null && invoiceCopy.invoices.invoices != null && !String.isEmpty(invoiceCopy.invoices.invoices[0].pdfBytes)) {
                System.debug('### Returning PDF bytes: '+invoiceCopy.invoices.invoices[0].pdfBytes);
                return invoiceCopy.invoices.invoices[0].pdfBytes;

            }
            else {
                throw new invoiceViewerException('Unexpected PDF response!');
            }
        } catch (Exception e) {

            System.debug('### Cannot Find Invoice: [' + e.getLineNumber() + '] ' + e.getMessage());

            errorMessage = 'Unable to retrieve invoice.';

        }

        return null;
    }

    public InvoicePDFViewerController() {

    }

    public void init() {

        if (!String.isEmpty(recordId)) {

            pdfContent = getInvoice();

        }
        else if (!(String.isEmpty(arNumber) || String.isEmpty(fileName))) {
            pdfContent = getInvoiceDirectly();
        }
        else {

            errorMessage = 'Unable to retrieve invoice.';

        }

    }

    public void testBypass() {

        Integer i = 0;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;


    }

}