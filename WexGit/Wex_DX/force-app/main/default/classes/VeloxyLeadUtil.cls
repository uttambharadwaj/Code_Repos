@RestResource(urlMapping='/VeloxyLeadUtil/*')
global with sharing class VeloxyLeadUtil {
  
  @HttpPost
    global static Map<String,String> doPost() {
            RestRequest req = RestContext.request;
            RestResponse res = RestContext.response;
        
            String leadId = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
            Lead myLead = [SELECT Id,Company,Email FROM Lead WHERE Id=:leadId Limit 1];
            
            String company = myLead.Company;
            String email = myLead.Email;
            
            Account acc = getAccount(company);
            
            Contact con = getContact(acc, email);
            
            Database.LeadConvert lc = new Database.LeadConvert();
            lc.setLeadId(myLead.id);
            lc.setAccountId(acc.id);
            if(acc.id != null){
                lc.setContactId(con.id);
            }
            
            LeadStatus convertStatus = [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted=true LIMIT 1];
            lc.setConvertedStatus(convertStatus.MasterLabel);
            
            Database.LeadConvertResult lcr = Database.convertLead(lc);
            System.assert(lcr.isSuccess());
            Map<String,String> mp = new Map<String,String>();
            mp.put('id',lcr.getOpportunityId());
            mp.put('success',''+lcr.isSuccess());
            
            return mp;
    }
    
    private static Account getAccount(String company){
        Account account;
        List<Account> accList = [SELECT Id FROM Account WHERE Name=:company Limit 1];
        if(!accList.isEmpty())
            account=accList[0];
        else
            account = new Account();
        return account;
    }

    private static Contact getContact(Account acc, String email){
        Contact account;
        List<Contact> accList = new List<Contact>();
        if(email != null){
            accList = [SELECT Id FROM Contact WHERE Email=:email and Account.Id=:acc.id Limit 1];           
        }
        if(!accList.isEmpty())
            account=accList[0];
        else
            account = new Contact();
        return account;
    }

}