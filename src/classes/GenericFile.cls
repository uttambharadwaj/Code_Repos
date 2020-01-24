/**
 * Created by lhowland on 1/7/2020.
 * The purpose of this object is to house both Attachments and ContentDocuments into a single list.
 */

public class GenericFile {

    public Id id { get; set; }

    public String fileName { get; set; }

    public String fileType { get; set; }    //TEXT, PDF, etc

    public String fileExtension { get; set; }   //txt, pdf, etc

    public String MIMEType { get; set; }  //specifically for http requests. ex: text/plain, application/pdf, etc

    public String objectType { get; set; }  // Attachement, ContentDocument

    public Blob body { get; set; }

    public GenericFile() {
    }

    public String mapFileExtToMIMEType(String fileExtension) {

        switch on fileExtension {

            when 'txt' {
                return 'text/plain';
            }
            when 'doc' {
                return 'application/msword';
            }
            when 'docx' {
                return 'application/vnd.openxmlformats-officedocument.wordprocessingml.document';
            }
            when 'rtf' {
                return 'application/rtf';
            }
            when 'odt' {
                return 'application/vnd.oasis.opendocument.text';
            }
            when 'csv' {
                return 'text/csv';
            }
            when 'xls' {
                return 'application/vnd.ms-excel';
            }
            when 'xlsx' {
                return 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet';
            }
            when 'ods' {
                return 'application/vnd.oasis.opendocument.spreadsheet';
            }
            when 'pdf' {
                return 'application/pdf';
            }

        }
        return null;

    }
}