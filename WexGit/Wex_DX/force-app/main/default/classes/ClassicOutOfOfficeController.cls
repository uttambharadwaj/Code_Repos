public class ClassicOutOfOfficeController {

    public OutOfOffice outOfOffice { get; set; }

    public void init() {

        try {
            outOfOffice = [SELECT Id, Message, StartDate, EndDate, UserId FROM OutOfOffice WHERE UserId = :UserInfo.getUserId()];
        } catch (Exception e) {

            outOfOffice = new OutOfOffice();
            outOfOffice.Message = '';
            outOfOffice.StartDate = System.Today();
            outOfOffice.EndDate = System.Today();
            outOfOffice.UserId = UserInfo.getUserId();


        }
    }

    public void saveOutOfOffice() {

        try {

            upsert outOfOffice;
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM, Label.OutOfOffice_Success));


        } catch (Exception e) {
            //ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL, e.getMessage()));
        }
    }
}