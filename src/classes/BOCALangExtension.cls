public class BOCALangExtension {
  
//
//    public BOCALangExtension(BOCAController ctrl){}
//
//    public String pgm = ApexPages.CurrentPage().getParameters().get('pgm');
//    //page language
//    public String lang{get{
//        String langID = ApexPages.CurrentPage().getParameters().get('lang');
//
//        //if there is no param or a bad one, set to default 'en_us'
//        //for now the only other option is French
//        if(langID == null || langID != 'fr'){langID = 'en_us';}
//        return langID;
//    }
//                       }
//
//    public String currentPageName { get {
//        String strurl = ApexPages.currentPage().getUrl();
//        strurl = strurl.replaceFirst('/apex/','');
//        strurl = EncodingUtil.urlEncode(strurl, 'UTF-8');
//        string[] strurlExtra = strurl.split('%3F',0);
//        strurl = strurlExtra[0];
//
//        return strurl;
//    }}
//
//
//    //related list containg assets for BOCA
//    public BOCA_res__c BOCA {get{
//         BOCA_res__c tag;
//        try{
//            //get the language branding for this program from the url params lang and pgm
//            tag = [SELECT ISO_code__c, Brand_Tagline__c, Brand_Heading__c, Email_Template_ID__c, sidebar__c, Side_Panel_Title__c, Program_Name__c, Name FROM BOCA_res__c WHERE ISO_code__c =: lang
//               AND program__r.Brand_Short_Name__c =: pgm LIMIT 1];
//
//        }
//        catch(DmlException ex){
//            SYSTEM.debug('exemption: '+ ex);
//        }
//        return tag;
//
//    }
//                            }
//    public MAP<string, string> BOCAText{get{
//        MAP<string, string> text = new MAP<string, string>();
//        list<String> auth = new List<String>();
//        if(lang == 'fr'){
//            text.put('html1', 'En cliquant sur "Soumettre la demande", vous déclarez et garantissez que vous êtes propriétaire, dirigeant ou associé de la société avec le pouvoir de lier la société aux termes de cette offre. Vous reconnaissez ( i ) '+
//                     'que vous avez lu dans l\'ensemble de nos Divulgation <a href="#disc"> de crédit </a> et <a href="#terms"> Termes &amp; Conditions </a> ci-dessous et conviennent que ces termes régiront votre compte,'+
//                     '( ii ) vous déclarez et garantissez que les renseignements fournis sont exacts et que vous êtes autorisé à conclure cet accord au nom de la '+
//                     'Société, et (iii ) le cas échéant, émetteur de la carte peut honorer les demandes de tenue de compte et d\'autres instructions du commanditaire de votre carte '+
//                     'programme qui sont faites en votre nom.');
//
//
//            text.put('html2', 'Sélectionnez "Oui" pour ligne seulement vue.  <br/>'+
//                     '<br/>'+
//                     'Sélectionnez "Non" à la fois vue et du papier livraison en ligne '+
//                     '(pour plus d\'informations sur les coûts de livraison de papier , se il vous plaît se référer aux Termes et Conditions ci-dessous) .');
//
//            text.put('button1', 'Présenter Une Demande');
//
//          	text.put('message1', 'en cours');
//
//            text.put('helptext1', 'Votre carburant et/ou d\'un service mensuel estimé les dépenses pour tous les véhicules à l\'intérieur de ce programme. Si vous faites une demande pour une carte sans restriction, se il vous plaît estimer votre carburant et/ou des dépenses de services. Si vous postulez pour un carburant, fluides, lavage Seulement, carte ne, se il vous plaît estimer que vos carburants et fluides (y compris les frais lavages).');
//
//            text.put('helptext2', 'Entrez le TIN, FEIN ou SSN de votre entreprise');
//
//            text.put('helptext3', '(sans tiret)');
//
//            text.put('helptext4', '(aucune boîte postale)');
//            return text;
//        }
//        else{
//            if(currentPageName.contains('CreditApp_Revolver')) {
//                text.put('html1', 'By clicking “Submit Application”, you represent and warrant that you are an owner, officer, or partner of the company with the authority to bind the company to the terms of this offer. You understand ' +
//					 'that your personal credit will be used in making a credit decision and authorize Card Issuer to obtain a consumer report. In the event your application is denied based on information in your credit report, ' +
//					 'you authorize the Card Issuer to report the reason for denial to you. You acknowledge (i) that you have read in full our <a href="#disc">Credit Disclosure</a> and <a href="#terms">Terms &amp; Conditions</a> ' +
//					 'below and agree that these terms shall govern your account, (ii) you represent and warrant that the information provided is correct and that you are authorized to enter into this agreement on behalf of ' +
//					 'Company, and (iii) if applicable, Card Issuer may honor account maintenance requests and other instructions from the sponsor of your card program which are made on your behalf.');
//            }
//            else {
//            	text.put('html1', ' By clicking “Submit Application”, you represent and warrant that you are an owner, officer, or partner of the company with the authority to bind the company to the terms of this offer. You acknowledge (i) '+
//                     'that you have read in full our <a href="#disc"> Credit Disclosure</a> and <a href="#terms">Terms &amp; Conditions </a>below and agree that these terms shall govern your account, '+
//                     '(ii) you represent and warrant that the information provided is correct and that you are authorized to enter into this agreement on behalf of '+
//                     'Company, and (iii) if applicable, Card Issuer may honor account maintenance requests and other instructions from the sponsor of your card '+
//                     'program which are made on your behalf.');
//            }
//
//            text.put('html2', 'Select “Yes” for online only view.   <br/>'+
//                     '<br/>'+
//                     'Select “No” for both online view and paper delivery   <br/>'+
//                     '(for more information on paper delivery costs, please refer to the Terms and Conditions below). ');
//
//            text.put('button1','Submit Application');
//
//            text.put('message1', 'processing');
//
//            text.put('helptext1', 'Your estimated monthly fuel and/or service expenditures for all vehicles within this program. If you are applying for an unrestricted card, please estimate your fuel and/or service expenditures.'+
//                                                                                                                'If you are applying for a Fuel, Fluids, Wash Only, card only, please estimate only your fuels and fluids (including washes) expenses.');
//            text.put('helptext2','Enter your company\'s TIN, FEIN, or SSN');
//
//            text.put('helptext3', '(no dashes)');
//
//            text.put('helptext4', '(no PO Boxes)');
//
//            return text;
//
//        }
//    }}
//
//    public String disclosure {
//        get{
//            StaticResource sr = [
//                select Body
//                from StaticResource
//                where Name = 'Disclosure'
//            ];
//            return sr.Body.toString();
//        }
//    }
//
//    public String termandcondition {
//        get{
//            StaticResource sr = [
//                select Body
//                from StaticResource
//                where Name = 'BOCA_TC'
//            ];
//            return sr.Body.toString();
//        }
//    }
//
//    public list<String> call{get{
//        List<String> call = new List<String>();
//        if(lang == 'fr'){
//            call.add('Avez des Questions?');
//            call.add('Appel ');
//            return call;
//        }
//        else{
//            call.add('Have Questions?');
//            call.add('Call ');
//            return call;
//        }
//    }
//                            }
//    public String displayName {
//        get{
//            return BOCA.Program_Name__c;
//        }
//    }
//    public String tagline{
//        get{
//            return BOCA.Brand_Tagline__c;
//        }
//    }
//    public String heading{
//        get{
//            return BOCA.Brand_Heading__c;
//        }
//    }
//    public String sidebar{
//        get{
//            return BOCA.SideBar__c;
//        }
//    }
//    public String sidebarTitle{
//
//        get{
//            if(BOCA.Side_Panel_Title__c == null){
//				sidebarTitle = null;
//            }
//            else{
//                sidebarTitle = BOCA.Side_Panel_Title__c;
//            }
//             return sidebarTitle;
//        }
//        set;
//    }
//    public String emailTemplate{
//        get{
//            return BOCA.Email_Template_ID__c;
//        }
//    }
//
//
//    public Map<String, String> sections{get{
//        Map<String,String>sections2 = new Map<String,String>();
//        Schema.DescribeFieldResult f = program__c.section_titles__c.getDescribe();
//        List<Schema.PicklistEntry> p = f.getpicklistvalues();
//        for(Schema.PicklistEntry r : p){
//
//            sections2.put(r.getValue(), r.getLabel());
//        }
//
//
//        return sections2;
//    }
//                                }
//
//
//
//
//
}