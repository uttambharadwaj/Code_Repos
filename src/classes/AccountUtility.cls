public with sharing class AccountUtility {

    public static void removeCarriageReturnsFromAccount(Account[] accounts){
        
       	String[] badValues = new String[]{'\r','\n'};       
        String newVal = '  ';

        for (Account act:accounts){
           act.BillingStreet= WEXHelper.replaceChar((String)act.BillingStreet, badValues, newVal );           
           act.ShippingStreet = WEXHelper.replaceChar((String)act.ShippingStreet, badValues,newVal );

        }
    }
       
}