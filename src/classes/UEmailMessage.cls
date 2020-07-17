public class UEmailMessage {
    // the filter method to find records we care about
    public static void filterDiscards(list<EmailMessage> emails) {
        list<EmailMessage> discards = new list<EmailMessage>();

        list<Email_Discarded_Terms__mdt>cmdts = [
                SELECT Id, Term__c, Email_Field__c
                FROM Email_Discarded_Terms__mdt
                WHERE Status__c = 'Active'];

        for (EmailMessage em : emails) {
            if (em.Incoming==true) { 
                for (Email_Discarded_Terms__mdt cmdt : cmdts) {
                    try {
                        if (em.get(cmdt.Email_Field__c)!=null && String.valueOf(em.get(cmdt.Email_Field__c)).containsIgnoreCase(cmdt.Term__c)) {
                            discards.add(em);
                            break;
                        }
                    } catch (Exception e) {
                        System.debug('Error - Invalid CMDT entry - ' + e.getMessage());
                    }
                }
            }
        }

        processDiscards(discards);
    }

    // the action method to actually alter the records
    private static void processDiscards(list<EmailMessage> discards) {
        for (EmailMessage email : discards) {
            email.Discard__c = true;
        }
    }

    //find out if this is an email with a relationship to a collections object. if so, do not allow delete.
    public static void DontDeleteCollectionsEmails(List<EmailMessage> records){
        for(EmailMessage emailMessage : records){

            Case parentCase = [Select Type From Case Where Id = :emailMessage.ParentId];

            if(parentCase.Type == 'Collections'){
                emailMessage.addError('Unable to delete Email for Collections Cases');
            }
        }
    }
}