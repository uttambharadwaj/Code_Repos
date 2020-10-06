public class ExcelController{
    public string xmlheader {get;set;}
    public ExcelDataModel dModel {get;set;}
    public string endfile{get;set;}
    public ExcelController(){
        //VF page gives some issues directly using the below code there, so wrap up in variable
        xmlheader ='<?xml version="1.0"?><?mso-application progid="Excel.Sheet"?>';
        //Dont know why i did this :) , But xml was not generating without it.
        //endfile = '</Workbook>';
        endfile = '';
    }

    public static testmethod void test1() {
        ExcelController c = new ExcelController();
        System.assertEquals( '<?xml version="1.0"?><?mso-application progid="Excel.Sheet"?>', c.xmlHeader );
        System.assertEquals( '', c.endFile );
        System.assertEquals( null, c.dModel );
    }

}