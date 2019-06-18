/*
** change bocatoprospect to class object
** do some querying and mapping to go from bocatoprospect to class object OR partnerbocatoprospect to class object
*/

public class OTRBOCAToProspectComponentController {

    public Boolean initialized { get; set; }

    public String bocaToProspectId {
        get;
        set {
            bocaToProspectId = value;
            if(!initialized) {
                init();
                initialized = true;
            }
        }
    }

    public BOCAWrapper bocaToProspect {get;set; }

    public String primaryBrandingCard { get; set; }

    public String pgValue {
        get {
            if(bocaToProspect.disablePG) {
                return 'n';
            }
            else if(bocaToProspect.requirePG) {
                return 'a';
            }
            else {
                return 'c';
            }
        }
    }

    public BOCA_res__c primaryBrandingUtility { get; set; }

    public OTRBOCAToProspectComponentController() {
        initialized = false;
    }

    public void init() {
        if (bocaToProspectId != null) {
            //bocaToProspectId could be boca to prospect, or partner boca to prospect. figure it out.
            bocaToProspect = new BOCAWrapper(bocaToProspectId);

            System.debug('### ' + bocaToProspect);

            if (bocaToProspect != null && bocaToProspect.program != null) {

                primaryBrandingUtility = WexBrandingController.getBrandingUtility(WexBrandingController.getBrandingUtilityByProgramId(bocaToProspect.program, 'en_us'));

                primaryBrandingCard = WexBrandingController.getCreditCardImageId(bocaToProspect.program);

            }
        }
    }

    //using a wrapper class thingy specifically for this controller
    public class BOCAWrapper {
        public String contactFirstName {get;set;}
        public String customMessage {get;set;}
        public String externalAppURL {get;set;}
        public String program {get;set;}
        public Boolean disablePG {get;set;}
        public Boolean requirePG {get;set;}
        public String repName {get;set;}
        public String repTitle {get;set;}
        public String repEmail {get;set;}
        public String repPhone {get;set;}
        public String repFax {get;set;}
        public String repTerritory {get;set;}

        //constructor takes in id
        public BOCAWrapper(String myBOCAId){
            system.debug(myBOCAId);
            if(myBOCAId.length()>3) {
                String myBOCAType = UtilityClass.getObjName(myBOCAId);
                if (myBOCAType == 'BOCA_To_Prospect__c') {
                    List<BOCA_To_Prospect__c> myBOCAList = [SELECT Id, Online_Application__r.Program__c, Opportunity__r.OwnerId, Online_Application_Offer__c, Always_Require_PG__c, Disable_PG__c, WeFormObject__c, WeFormObject__r.Program__c, WeFormObject__r.Program__r.BOCA_Type__c, Additional_Programs__c, Custom_Message__c, Contact__r.FirstName, Opportunity__r.Owner.FirstName, Online_Application__r.External_Application_URL__c FROM BOCA_To_Prospect__c WHERE Id = :myBOCAId LIMIT 1];
                    if (myBOCAList.size() > 0) {
                        BOCA_To_Prospect__c myBOCA = myBOCAList[0];
                        User myRep;
                        List<User> myRepList = [SELECT Id, Name, Title, Email, Phone, Fax, Territory_Code__c FROM USER WHERE Id = :myBOCA.Opportunity__r.OwnerId];
                        if (myRepList.size() > 0) myRep = myRepList[0];
                        setBOCAFields(myBOCA, myRep);
                    }
                } else if (myBOCAType == 'Partner_BOCA_To_Prospect__c') {
                    List<Partner_BOCA_To_Prospect__c> myBOCAList = [SELECT Id, First_Name__c, External_Application_URL__c, Program__c, Sales_Rep_First_Name__c, Sales_Rep_Last_Name__c, Sales_Rep_Email__c, Sales_Rep_Phone__c FROM Partner_BOCA_To_Prospect__c WHERE Id = :myBOCAId LIMIT 1];
                    if (myBOCAList.size() > 0) {
                        Partner_BOCA_To_Prospect__c myBOCA = myBOCAList[0];
                        setBOCAFields(myBOCA);
                    }
                }
            }
        }

        //set wrapper fields when we have boca to prospect and a rep
        private void setBOCAFields(BOCA_To_Prospect__c btp, User rep){
            this.contactFirstName = btp.Contact__r.FirstName;
            this.customMessage = btp.Custom_Message__c;
            this.externalAppURL = btp.Online_Application__r.External_Application_URL__c;
            this.program = btp.Online_Application__r.Program__c;
            this.disablePG = btp.Disable_PG__c;
            this.requirePG = btp.Always_Require_PG__c;
            if(rep!=null){
                this.repName = rep.Name;
                this.repTitle = rep.Title;
                this.repEmail = rep.Email;
                this.repPhone = rep.Phone;
                this.repFax = rep.Fax;
                this.repTerritory = rep.Territory_Code__c;
            }
        }

        //set wrapper fields when we have partner boca to prospect
        private void setBOCAFields(Partner_BOCA_To_Prospect__c pbtp){
            this.contactFirstName = pbtp.First_Name__c;
            this.externalAppURL = pbtp.External_Application_URL__c;
            this.program = pbtp.Program__c;
            this.repName = pbtp.Sales_Rep_First_Name__c + ' ' + pbtp.Sales_Rep_Last_Name__c;
            this.repEmail = pbtp.Sales_Rep_Email__c;
            this.repPhone = pbtp.Sales_Rep_Phone__c;
        }

        //custom get method bc inner classes don't support standard get. boo!
        private Object get(String myVariable){
            return UtilityClass.get(myVariable, (Object)this);
        }

    }

}
