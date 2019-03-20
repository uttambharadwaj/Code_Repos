public class TriggerSfidToCardidUnitTest{

    static testmethod void SfidToCardidTest(){
     Map <String,Schema.RecordTypeInfo> recordTypes =account.sObjectType.getDescribe().getRecordTypeInfosByName();
    
     account CardProgram = New account();
     CardProgram.recordtypeid  = recordTypes.get('Card Program').getRecordTypeId() ;
     CardProgram.Name= 'Card Program';
     
     insert CardProgram;

      recordTypes =lead.sObjectType.getDescribe().getRecordTypeInfosByName();
 
     Lead L = New Lead ();
     L.recordtypeid  = recordTypes.get('Fleet Lead').getRecordTypeId() ;
     L.LastName= 'Card Program';
     L.Status= 'Working';
     L.Initial_Contact_Method__c =  'Webform';
     L.Card_Program_ID__c =  CardProgram.id;
    
     L.Company= 'test';
     insert l;
    
    }

}