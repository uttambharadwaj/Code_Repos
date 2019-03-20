public without sharing class BOCAemailController {

    public Program__c program{get;set;}
    public List<Attachment> Atts = new List<Attachment>();
    
    public List<BOCA_res__c> res = new List<BOCA_res__c>();

    public BOCAemailController(){    
       // SYSTEM.debug('Program in Controller ' + program.id);
      /*  if(program != null){
        	Atts = [SELECT Id, Name, Body FROM Attachment where ParentId =: program.Id AND Name=:'ui-credit-card.png'];   
         	res = [SELECT Program_Sell_Sheets__c FROM BOCA_res__c WHERE Program__r.Id =: program.id];
        }
*/
    }
    
    public List<Attachment> getAtts(){
        Atts = [SELECT Id, Name, Body FROM Attachment where ParentId =: program.Id AND Name=:'ui-credit-card.png'];   
        return Atts;
    }
    public List<BOCA_res__c> getRes(){
        res = [SELECT Program_Sell_Sheets__c FROM BOCA_res__c WHERE Program__r.Id =: program.id];
        return res;
    }
    
    
}