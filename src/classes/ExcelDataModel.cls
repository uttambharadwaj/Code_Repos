public with sharing class ExcelDataModel {
    public list<SingleDataModel> data { get; set; }

    public class SingleDataModel {
        public string sheetname { get; set; }
        public list<string> headers { get; set; }
        public list<map<string,string>> data { get; set; }
    }

}