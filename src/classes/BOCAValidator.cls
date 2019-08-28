public class BOCAValidator {
    
    
//    public static List<apexPages.Message> errorList{get; set;}
//    public static Map <Integer, String> debug = new Map<Integer, String>();
//
//    public static Boolean validateEmail(String email) {
//        Boolean res = true;
//        String emailRegex = '^[a-zA-Z0-9._|\\\\%#~`=?&/$^*!}{+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,4}$';
//        Pattern MyPattern = Pattern.compile(emailRegex);
//        Matcher MyMatcher = MyPattern.matcher(email);
//
//        if (!MyMatcher.matches())
//            res = false;
//        SYSTEM.debug('email '+ res);
//        return res;
//    }
//    public static Boolean validateSSN(String ssn){
//        String ssnRegex = '[0-9]{3}-[0-9]{2}-[0-9]{4}';
//        Boolean res = true;
//        Pattern MyPattern = Pattern.compile(ssnRegex);
//        Matcher MyMatcher = MyPattern.matcher(ssn);
//
//        if (!MyMatcher.matches())
//            res = false;
//        SYSTEM.debug('ssn ' + res);
//        return res;
//    }
//    public static Boolean validateDate(String datepatt) {
//        Boolean res = true;
//        //date format (dd/mm/yyyy)
//        String dateRegex = '(0?[1-9]|1[012])/(0?[1-9]|[12][0-9]|3[01])/((19|20)\\d\\d)';
//        Pattern MyPattern = Pattern.compile(dateRegex);
//        Matcher MyMatcher = MyPattern.matcher(datepatt);
//
//        if (!MyMatcher.matches())
//            res = false;
//        SYSTEM.debug('date ' + res);
//        return res;
//    }
//
//    public static Boolean validatePhone(String phone){
//        system.debug('THE PHONE IN THE VALIDATOR IS: ' + phone);
//        String phoneRegex = '^\\(\\d{3}\\) ?\\d{3}( |-)?\\d{4}|^\\d{3}( |-)?\\d{3}( |-)?\\d{4}';
//        Boolean res = true;
//        Pattern MyPattern = Pattern.compile(phoneRegex);
//        Matcher MyMatcher = MyPattern.matcher(phone);
//
//        if (!MyMatcher.matches())
//            res = false;
//        SYSTEM.debug('phone ' + res);
//        return res;
//    }
//    public static Boolean validatePostal(String postCode, String state){
//        Boolean po = true;
//
//        postcode = postcode.removeStartIgnoreCase('0');
//
//        try{
//            Postcode__c pcode = [SELECT State__c, Postcode__c FROM Postcode__c where Postcode__c =: postCode LIMIT 1];
//            SYSTEM.debug('result' + pcode);
//
//            if(pcode == null){
//                po = false;
//            }
//        }
//        catch(Exception e){
//            po = false;
//            SYSTEM.debug('ex' + e + 'po' + po);
//
//        }
//
//        SYSTEM.debug('po on return'+po);
//        return po;
//    }
//    public static Boolean validatePoBox(String address){
//        Boolean po = true;
//
//
//
//        try{
//            List<po_box_validation__c> codes = [SELECT id, po_box_formats__c FROM po_box_validation__c];
//            for(po_box_validation__c p : codes){
//                if(address.containsIgnoreCase(p.po_box_formats__c)){
//                    po = false;
//                }
//            }
//            SYSTEM.debug('result' + codes);
//
//
//        }
//        catch(Exception e){
//
//            SYSTEM.debug('ex' + e + 'po' + po);
//
//        }
//
//        SYSTEM.debug('po on return'+po);
//        return po;
//    }
//    //multi-language validation terms
//    public static Map<String, String> getvalidations(String lng){
//        Map<String, String> terms = new Map<String, String>();
//        if(lng == 'fr'){
//            terms.put('req', '  Requis');
//            terms.put('phoneFormat', 'Entrez un numéro de téléphone valide');
//            terms.put('pcFormat','Entrez un code postal valide');
//            terms.put('email','Entrez un email valide');
//            terms.put('dateError','Entrez une date valide');
//            terms.put('moneyFormat','Entrez une valeur supérieure à zéro');
//            terms.put('addressFormat', 'Entrez une adresse moins de 40 caractères');
//            terms.put('street','Entrez une adresse physique');
//            terms.put('streetform', 'Entrez une adresse physique de moins de 40 caractères');
//            terms.put('fax','Entrez un numéro de télécopieur valide');
//            terms.put('taxID', 'Entrez un contribuable d\'identité valide');
//            terms.put('duns','Entrez un numéro DUNS valide');
//            terms.put('ssn', 'Entrez un numéro valide de la sécurité sociale');
//            terms.put('dob','Entrez une date de naissance valide');
//
//        }
//        else{
//            terms.put('req', '  Required');
//            terms.put('phoneFormat', 'Enter a valid phone number');
//            terms.put('pcFormat','Enter a valid postal code');
//            terms.put('email','Enter a valid email');
//            terms.put('dateError','Enter a valid date');
//            terms.put('moneyFormat','Enter a value greater than zero');
//            terms.put('addressFormat', 'Enter an address less than 40 characters');
//            terms.put('street','Enter a physical address');
//            terms.put('streetform', 'Enter a physical address less than 40 characters');
//            terms.put('fax','Enter a valid fax number');
//            terms.put('taxID', 'Enter a valid taxpayer id');
//            terms.put('duns', 'Enter a valid DUNS number');
//            terms.put('ssn', 'Enter a valid social security number');
//            terms.put('dob','Enter a valid date of birth');
//            terms.put('ABA','Enter a valid 9-digit ABA routing number');
//            terms.put('check', 'Enter a valid checking account number');
//
//        }
//
//        return terms;
//    }
//    //Check the input values against these validation rules and
//    //either pass back error message or send to submit
//    public static boolean validateFields(WeFormObject__c form, String lang, boolean isPG, boolean bank, boolean rev){
//        //check page language for validation
//
//        Map<String, String>err = getValidations(lang);
//
//        Decimal num = 0.00;
//
//        SYSTEM.debug('bank= '+ bank);
//        SYSTEM.debug('pg= '+ isPG);
//        boolean errors = true;
//        Integer count = 0;
//        //**Tell us about your business**//
//        if(form.First_Name__c == null){
//            form.First_Name__c.addError(err.get('req'));
//            count ++; debug.put(count, 'form.First_Name__c');
//        }
//        if(form.Last_Name__c == null){
//            form.Last_Name__c.addError(err.get('req'));
//            count ++;  debug.put(count, 'form.Last_Name__c');
//        }
//
//        if(form.Company_Name__c == null){
//            form.Company_Name__c.addError(err.get('req'));
//            count ++; debug.put(count, 'form.Company_Name__c');
//        }
//        if(form.Business_Street_Address__c == null){
//            form.Business_Street_Address__c.addError(err.get('req'));
//            count ++; debug.put(count, 'form.Business_Street_Address__c');
//            //validate against po box
//        }
//        if(form.Business_Street_Address__c != null){
//            if(!validatePoBox(form.Business_Street_Address__c)){
//                form.Business_Street_Address__c.addError(err.get('street'));
//                count++; debug.put(count, 'form.Business_Street_Address__c');
//            }
//            if(form.Business_Street_Address__c.length() > 40){
//                form.Business_Street_Address__c.addError(err.get('streetform'));
//                count++; debug.put(count, 'form.Business_Street_Address__c');
//            }
//        }
//        if(form.City__c == null){
//            form.City__c.addError(err.get('req'));
//            count ++; debug.put(count, 'form.City__c');
//        }
//        if(form.State__c == null){
//            form.State__c.addError(err.get('req'));
//            count ++; debug.put(count, 'form.State__c');
//        }
//        if(form.Zip_code__c == null){
//            form.Zip_code__c.addError(err.get('req'));
//            count ++; debug.put(count, 'form.Zip_code__c');
//        }
//        if(form.Zip_code__c != null){
//
//            if(!validatePostal(form.Zip_code__c, form.State__c)){
//                form.Zip_code__c.addError(err.get('pcFormat'));
//                count ++; debug.put(count, 'form.Zip_code__c');
//            }
//
//        }
//
//        if(form.Business_Phone__c == null){
//            form.Business_Phone__c.addError(err.get('req'));
//            count ++; debug.put(count, 'form.Business_Phone__c');
//            //validate phone
//        }
//        if(form.Business_Phone__c!=null){
//            if(!validatePhone(form.Business_Phone__c)){
//                form.Business_Phone__c.addError(err.get('phoneFormat'));
//                count ++; debug.put(count, 'form.Business_Phone__c');
//            }
//
//        }
//
//        if(form.Business_Fax__c != null){
//            if(!validatePhone(form.Business_fax__c)){
//                form.Business_fax__c.addError(err.get('fax'));
//                count++; debug.put(count, 'form.Business_fax__c');
//            }
//
//        }
//        if(form.Taxpayer_ID__c == null){
//            form.Taxpayer_ID__c.addError(err.get('req'));
//            count ++; debug.put(count, 'form.Taxpayer_ID__c');
//            //validate tax id
//        }
//        if(form.Taxpayer_ID__c != null){
//
//            if(!form.Taxpayer_ID__c.isNumeric()){
//                form.Taxpayer_ID__c.addError(err.get('taxID'));
//                count++; debug.put(count, 'form.Taxpayer_ID__c');
//            }
//            if(form.Taxpayer_ID__c.length() != 9){
//                form.Taxpayer_ID__c.addError(err.get('taxID'));
//                count++; debug.put(count, 'form.Taxpayer_ID__c');
//            }
//
//
//        }
//        if(form.Years_in_Business__c == null){
//            form.Years_in_Business__c.addError(err.get('req'));
//            count ++; debug.put(count, 'form.Years_in_Business__c');
//        }
//        if(form.Legal_Structure__c == null){
//            form.Legal_Structure__c.addError(err.get('req'));
//            count ++; debug.put(count, 'form.Legal_Structure__c');
//        }
//        //validate duns number
//        if(form.DUNS_Number__c != null){
//            if(form.DUNS_Number__c.length() != 9){
//                form.DUNS_Number__c.addError(err.get('duns'));
//                count++;  debug.put(count, 'form.DUNS_Number__c');
//            }
//            if(!form.DUNS_Number__c.isNumeric()){
//                form.DUNS_Number__c.addError(err.get('duns'));
//                count++; debug.put(count, 'form.DUNS_Number__c');
//            }
//
//        }
//
//        if(form.Fleet_Size__c == null){
//            form.Fleet_Size__c.addError(err.get('req'));
//            count ++; debug.put(count, 'form.Fleet_Size__c');
//        }
//        if(form.Estimated_Monthly_Vehicle_Expenses__c == null && form.Avg_Monthly_Fuel_Service_Expenses__c == null ){
//            form.Estimated_Monthly_Vehicle_Expenses__c.addError(err.get('req'));  debug.put(count, 'form.Estimated_Monthly_Vehicle_Expenses__c');
//            form.Avg_Monthly_Fuel_Service_Expenses__c.addError(err.get('req')); debug.put(count, 'form.Avg_Monthly_Fuel_Service_Expenses__c');
//            count ++;
//        }
//        if(form.Estimated_Monthly_Vehicle_Expenses__c != null || form.Avg_Monthly_Fuel_Service_Expenses__c != null){
//            if(form.Estimated_Monthly_Vehicle_Expenses__c <= 0 || form.Avg_Monthly_Fuel_Service_Expenses__c <= 0){
//                form.Estimated_Monthly_Vehicle_Expenses__c.addError(err.get('moneyFormat')); debug.put(count, 'form.Estimated_Monthly_Vehicle_Expenses__c');
//                form.Avg_Monthly_Fuel_Service_Expenses__c.addError(err.get('moneyFormat')); debug.put(count, 'form.Avg_Monthly_Fuel_Service_Expenses__c');
//                count ++;
//            }
//        }
//        if(form.Is_business_exempt_from_Motor_Fuels_Tax__c == null){
//            form.Is_business_exempt_from_Motor_Fuels_Tax__c.addError(err.get('req'));
//            count ++; debug.put(count, 'form.Is_business_exempt_from_Motor_Fuels_Tax__c');
//        }
//
//        //***Billing Information***//
//        if(form.Billing_Contact_First_Name__c==null){
//            form.Billing_Contact_First_Name__c.addError(err.get('req'));
//            count ++; debug.put(count, 'form.Billing_Contact_First_Name__c');
//        }
//        if(form.Billing_Contact_Last_Name__c==null){
//            form.Billing_Contact_Last_Name__c.addError(err.get('req'));
//            count ++;  debug.put(count, 'form.Billing_Contact_Last_Name__c');
//        }
//        if(form.Billing_Email__c == null){
//            form.Billing_Email__c.addError(err.get('req'));
//            count ++;  debug.put(count, 'form.Billing_Email__c');
//            //validate email
//
//        }
//        if(form.Billing_Email__c != null){
//            if(!validateEmail(form.Billing_Email__c)){
//                form.Billing_Email__c.addError(err.get('Email'));
//                count ++;  debug.put(count, 'form.Billing_Email__c');
//            }
//
//        }
//        if(form.Billing_Street_Address__c == null){
//            form.Billing_Street_Address__c.addError(err.get('req'));
//            count ++; debug.put(count, 'Billing_Street_Address__c');
//        }
//        if(form.Billing_Street_Address__c != null){
//            if(form.Billing_Street_Address__c.length() > 40){
//                form.Billing_Street_Address__c.addError(err.get('addressFormat'));
//                count++; debug.put(count, 'Billing_Street_Address__c');
//            }
//        }
//        if(form.Billing_City__c == null){
//            form.Billing_City__c.addError(err.get('req'));
//            count ++; debug.put(count, 'Billing_City__c');
//        }
//        if(form.Billing_State__c == null){
//            form.Billing_State__c.addError(err.get('req'));
//            count ++; debug.put(count, 'Billing_State__c');
//        }
//        if(form.Billing_Zip_Code__c == null){
//            form.Billing_Zip_Code__c.addError(err.get('req'));
//            count ++; debug.put(count, 'Billing_Zip_Code__c');
//        }
//        if(form.Billing_Zip_Code__c  != null){
//            if(!validatePostal(form.Billing_Zip_Code__c , form.Billing_State__c)){
//                form.Billing_Zip_Code__c.addError(err.get('pcFormat'));
//                count ++; debug.put(count, 'Billing_Zip_Code__c');
//            }
//
//        }
//
//        if(form.Billing_Phone__c == null){
//            form.Billing_Phone__c.addError(err.get('req'));
//            count ++; debug.put(count, 'Billing_Phone__c');
//            //validate phone
//        }
//        if(form.Billing_Phone__c!=null){
//            if(!validatePhone(form.Billing_Phone__c)){
//                form.Billing_Phone__c.addError(err.get('phoneFormat'));
//                count ++; debug.put(count, 'Billing_Phone__c');
//            }
//
//        }
//        //Billing Mobile
//        if(form.Billing_Mobile_Phone__c != null){
//            if(!validatePhone(form.Billing_Mobile_Phone__c)){
//                form.Billing_Mobile_Phone__c.addError(err.get('phoneFormat'));
//                count++; debug.put(count, 'Billing_Mobile_Phone__c');
//            }
//        }
//        //validate fax
//        if(form.Billing_Fax__c != null){
//            if(!validatePhone(form.Billing_Fax__c)){
//                form.Billing_Fax__c.addError(err.get('fax'));
//                count++; debug.put(count, 'Billing_Fax__c');
//            }
//        }
//        if(form.Email__c == null){
//            form.Email__c.addError(err.get('req'));
//            count ++; debug.put(count, 'Email__c');
//            //validate email
//        }
//        if(form.Email__c != null){
//            if(!validateEmail(form.Email__c)){
//                form.Email__c.addError(err.get('Email'));
//                count ++; debug.put(count, 'Email__c');
//            }
//        }
//
//        //only validate these if isPG
//        if(isPG){
//            //**Personal Guarantor Info**//
//
//            if(!bank){
//                //the next section is for Revolver/Flex only
//                if(Rev){
//                    if(form.PG_Residential_Phone__c== null){
//                        form.PG_Residential_Phone__c.addError(err.get('req'));
//                        count ++; debug.put(count, 'PG_Residential_Phone__c');
//
//                    }
//                    if(form.PG_Residential_Phone__c != null){
//                        if(!validatePhone(form.PG_Residential_Phone__c)){
//                            form.PG_Residential_Phone__c.addError(err.get('phoneFormat'));
//                            count++; debug.put(count, 'PG_Residential_Phone__c');
//                        }
//                    }
//                    if(form.Mobile_Phone__c == null){
//                        form.Mobile_Phone__c.addError(err.get('req'));
//                        count ++; debug.put(count, 'Mobile_Phone__c');
//
//                    }
//
//                    if(form.Mobile_Phone__c != null){
//                        if(!validatePhone(form.Mobile_Phone__c)){
//                            form.Mobile_Phone__c.addError(err.get('phoneFormat'));
//                        }
//
//                    }
//
//                    if(form.Paperless_Flag__c == null){
//                        form.Paperless_Flag__c.addError(err.get('req'));
//                        count ++; debug.put(count, 'Paperless_Flag__c');
//                    }
//
//                    if(form.Annual_Gross_Revenue__c == null){
//                        form.Annual_Gross_Revenue__c.addError(err.get('req'));
//                        count ++;  debug.put(count, 'Annual_Gross_Revenue__c');
//                    }
//
//                    if(form.Annual_Gross_Revenue__c != null){
//                        if(form.Annual_Gross_Revenue__c <= 0){
//                            form.Annual_Gross_Revenue__c.addError(err.get('moneyFormat'));
//                            count ++; debug.put(count, 'Annual_Gross_Revenue__c');
//                        }
//                    }
//                }
//            }//end revolver only validations
//            if(form.PG_Residential_Street_Address__c == null){
//                form.PG_Residential_Street_Address__c.addError(err.get('req'));
//                count ++; debug.put(count, 'PG_Residential_Street_Address__c');
//            }
//
//            if(form.PG_Residential_Street_Address__c != null){
//                if(!validatePoBox(form.PG_Residential_Street_Address__c)){
//                    form.PG_Residential_Street_Address__c.addError(err.get('street'));
//                    count++; debug.put(count, 'PG_Residential_Street_Address__c');
//                }
//                if(form.PG_Residential_Street_Address__c.length() > 40){
//                    form.PG_Residential_Street_Address__c.addError(err.get('addressFormat'));
//                    count++; debug.put(count, 'PG_Residential_Street_Address__c');
//                }
//            }
//            if(form.PG_Residential_City__c == null){
//                form.PG_Residential_City__c.addError(err.get('req'));
//                count ++; debug.put(count, 'PG_Residential_City__c');
//            }
//            if(form.PG_Residential_State__c == null){
//                form.PG_Residential_State__c.addError(err.get('req'));
//                count ++; debug.put(count, 'PG_Residential_State__c');
//            }
//            if(form.PG_Residential_Zip__c == null){
//                form.PG_Residential_Zip__c.addError(err.get('req'));
//                count ++; debug.put(count, 'PG_Residential_Zip__c');
//            }
//
//            if(form.PG_Residential_Zip__c   != null){
//                if(!validatePostal(form.PG_Residential_Zip__c  ,  form.PG_Residential_State__c)){
//                    form.PG_Residential_Zip__c.addError(err.get('pcFormat'));
//                    count ++; debug.put(count, 'PG_Residential_Zip__c');
//                }
//
//            }
//
//
//            if(form.PG_SSN__c == null){
//                form.PG_SSN__c.addError(err.get('req'));
//                count ++; debug.put(count, 'PG_SSN__c');
//
//            }
//            if(form.PG_SSN__c != null){
//                if(!validateSSN(form.PG_SSN__c)){
//                    form.PG_SSN__c.addError(err.get('ssn'));
//                    count ++; debug.put(count, 'PG_SSN__c');
//                }
//
//            }
//            if(form.Date_of_Birth__c == null){
//                form.Date_of_Birth__c.addError(err.get('req'));
//                count ++; debug.put(count, 'Date_of_Birth__c');
//            }
//            if(form.Date_of_Birth__c != null){
//                if(!validateDate(form.Date_of_Birth__c)){
//                    form.Date_of_Birth__c.addError(err.get('dob'));
//                    count ++; debug.put(count, 'Date_of_Birth__c');
//                }
//
//            }
//            if(form.Guarantor_Annual_Income__c == null){
//                form.Guarantor_Annual_Income__c.addError(err.get('req'));
//                count ++; debug.put(count, 'Guarantor_Annual_Income__c');
//            }
//            if(form.Guarantor_Annual_Income__c != null){
//                if(form.Guarantor_Annual_Income__c <= 0){
//                    form.Guarantor_Annual_Income__c.addError(err.get('moneyFormat'));
//                    count ++; debug.put(count, 'Guarantor_Annual_Income__c');
//                }
//
//            }
//
//            if(form.Estimated_Monthly_Vehicle_Expenses__c == null){
//                form.Estimated_Monthly_Vehicle_Expenses__c.addError(err.get('req'));
//                count ++;  debug.put(count, 'Estimated_Monthly_Vehicle_Expenses__c');
//            }
//            if(form.Estimated_Monthly_Vehicle_Expenses__c != null){
//                if(form.Estimated_Monthly_Vehicle_Expenses__c <= 0){
//                    form.Estimated_Monthly_Vehicle_Expenses__c.addError(err.get('moneyFormat'));
//                    count ++; debug.put(count, 'Estimated_Monthly_Vehicle_Expenses__c');
//                }
//            }
//        }
//        //end PG validations
//
//        //OTR/Bank info validations
//        if(bank){
//            if(form.ABA_Routing_Number__c == null){
//                form.ABA_Routing_Number__c.addError(err.get('req'));
//                count++; debug.put(count, 'ABA Routing Number');
//            }
//            if(form.ABA_Routing_Number__c != null){
//                if(form.ABA_Routing_Number__c.length() < 9){
//                    form.ABA_Routing_Number__c.addError(err.get('ABA'));
//                    count++; debug.put(count, 'ABA Routing Number');
//                }
//
//            }
//            if(form.Day_of_Payment__c == null){
//                form.Day_of_Payment__c.addError(err.get('req'));
//                count++; debug.put(count, 'Day of Payment');
//            }
//            if(form.Financial_Institution__c == null){
//                form.Financial_Institution__c.addError(err.get('req'));
//                count++; debug.put(count,'Financial Institution');
//            }
//            if(form.Checking_Account_Number__c == null){
//                form.Checking_Account_Number__c.addError(err.get('req'));
//                count++; debug.put(count, 'Checking Account Number');
//            }
//            if(form.Checking_Account_Number__c != null){
//                if(form.Checking_Account_Number__c.length() < 5){
//                    form.Checking_Account_Number__c.addError(err.get('check'));
//                    count++; debug.put(count, 'Checking Account');
//                }
//            }
//            if(form.Payment_Method__c == null){
//                form.Payment_Method__c.addError(err.get('req'));
//                count++; debug.put(count,'Payment Method');
//            }
//
//
//
//
//        }
//
//        //**Promotional Information**//
//        if(form.How_did_you_hear_about_this_offer__c == null){
//            form.How_did_you_hear_about_this_offer__c.addError(err.get('req'));
//            count ++; debug.put(count, 'How_did_you_hear_about_this_offer__c');
//        }
//
//        //application signer
//        if(form.signer_title__c == null){
//            form.signer_title__c.addError(err.get('req'));
//            count ++; debug.put(count, 'signer_title__c');
//        }
//        if(form.Signer_s_First_Name__c == null){
//            form.Signer_s_First_Name__c.addError(err.get('req'));
//            count ++;  debug.put(count, 'Signer_s_First_Name__c');
//        }
//        if(form.Signer_s_Last_Name__c == null){
//            form.Signer_s_Last_Name__c.addError(err.get('req'));
//            count ++; debug.put(count, 'Signer_s_Last_Name__c');
//        }
//        if(form.Signer_s_Email__c == null){
//            form.Signer_s_Email__c.addError(err.get('req'));
//            count ++; debug.put(count, 'Signer_s_Email__c');
//
//        }
//        if(form.Signer_s_Email__c != null){
//            if(!validateEmail(form.Signer_s_Email__c)){
//                form.Signer_s_Email__c.addError(err.get('Email'));
//                count ++; debug.put(count, 'Signer_s_Email__c');
//            }
//
//        }
//        if(form.Signer_s_Phone__c == null){
//            form.Signer_s_Phone__c.addError(err.get('req'));
//            count ++; debug.put(count, 'Signer_s_Phone__c');
//
//        }
//        if(form.Signer_s_Phone__c != null){
//
//            if(!validatePhone(form.Signer_s_Phone__c)){
//                form.Signer_s_Phone__c.addError(err.get('phoneFormat'));
//                count ++; debug.put(count, 'Signer_s_Phone__c');
//            }
//
//
//        }
//
//        if(count == 0){
//            errors = false;
//        }
//
//        SYSTEM.debug('error is' + errors + 'count: ' + count);
//        SYSTEM.debug('form after errors: ' + form);
//        SYSTEM.debug('errrorMap key: ' + debug.keySet() + 'errorMap values: '+  debug.values());
//        return errors;
//    }
//
//
//
//
    
}