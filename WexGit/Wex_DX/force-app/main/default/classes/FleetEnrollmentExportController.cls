public class FleetEnrollmentExportController {

    public Integer exportLimit {
        get {
            Fleet_Enrollment_Settings__c FES = Fleet_Enrollment_Settings__c.getOrgDefaults();
            
            Integer exportLimit = 200;
            
            if(FES.Mass_Export_Limit__c != null) {
                exportLimit = Integer.valueOf(FES.Mass_Export_Limit__c);
            }
            
            return exportLimit;
        }
    }
    
    public List<FleetEnrollment__c> fleetEnrollments { 
        get {
            
            System.debug('### Export Limit Is: ' + exportLimit);
            
            List<FleetEnrollment__c> fleetEnrollments = [SELECT Id, Name, Opportunity_Number__c, Application_Status__c, Status__c FROM FleetEnrollment__c WHERE Status__c = 'New' and Opportunity_Number__c != null LIMIT :exportLimit];
            
            System.debug(fleetEnrollments);
            
            return fleetEnrollments;
        }
    }
    
    public String fleetEnrollmentsToDownload { 
        get {
            return String.valueOf(fleetEnrollments.size());
        }
    }
    
    public Integer fleetEnrollmentsToDownloadInt { 
        get {
            return fleetEnrollments.size();
        }
    }
    
    private ApexPages.StandardSetController standardController;
    
    public FleetEnrollmentExportController(ApexPages.StandardSetController standardController)
    {
        this.standardController = standardController;
    }
    
    public PageReference downloadAttachments() {
        
        PageReference zipFile = null;
        
        List<Attachment> attachments = new List<Attachment>();
        
        List<FleetEnrollment__c> fleetEnrollments = [SELECT Id, Opportunity_Number__c FROM FleetEnrollment__c WHERE Status__c = 'New' and Opportunity_Number__c != null LIMIT :exportLimit];
        
        System.debug(fleetEnrollments);
        
        if(!fleetEnrollments.isEmpty()) {
            
            for(FleetEnrollment__c fleetEnrollment : fleetEnrollments) {
                
                PageReference xlsGenerator = Page.FleetEnrollmentXLS;
                
                xlsGenerator.getParameters().put('id', fleetEnrollment.Id);
                
                if(xlsGenerator != null) {
                    
                    Attachment xlsAttachment = new Attachment();
                    
                    xlsAttachment.ParentId = fleetEnrollment.Id;
                    
                    xlsAttachment.Name = fleetEnrollment.Opportunity_Number__c + '.xls';
                    
                    if(Test.isRunningTest()) {
                        xlsAttachment.Body = Blob.valueOf('UNIT.TEST');
                    }
                    else { 
                    	xlsAttachment.Body = xlsGenerator.getContent();
                    }
                    
                    xlsAttachment.contentType = 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet';
                    
                    attachments.add(xlsAttachment);
                    
                }
                
            }
            
            insert attachments;
            
            Zippex xlsZipFile = new Zippex();
            
            for(Attachment xlsAttachment : attachments) {
                
                xlsZipFile.addFile('enrollments/' + xlsAttachment.Name, xlsAttachment.Body, null);
                
            }
            
            try {
                
                Document doc = new Document();
                
                doc.FolderId = UserInfo.getUserId();
                doc.Name = 'FleetEnrollmentExport.zip';
                doc.Body = xlsZipFile.getZipArchive();
                
                insert doc;
                
                for(FleetEnrollment__c fleetEnrollment : fleetEnrollments) {
                    
                    fleetEnrollment.Status__c = 'Completed';
                    
                }
                
				upsert fleetEnrollments;                
                
                return new PageReference('/servlet/servlet.FileDownload?file=' + doc.Id);
                
            } catch ( Exception ex ) {
                System.debug('>>> ERROR ' + ex);
            }
            
        }

        return zipFile;
        
    }
    
}