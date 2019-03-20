public with sharing class ContactUtility {
 
    public static void removeCarriageReturnsFromContact(Contact[] contacts){

        String[] badValues = new String[]{'\r','\n'};
        String newVal = '  ';
        
        for (Contact contact:contacts){        	
           contact.MailingStreet= WEXHelper.replaceChar((String)contact.MailingStreet,badValues,newVal );           
           contact.OtherStreet = WEXHelper.replaceChar((String)contact.OtherStreet ,badValues,newVal );
        }
    }
       
}