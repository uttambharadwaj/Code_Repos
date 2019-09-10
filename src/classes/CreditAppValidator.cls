public with sharing class CreditAppValidator {
//
//    public static List<apexPages.Message> errorList{get; set;}
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
//      public static Boolean validatePoBox(String address){
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
//    //Check the input values against these validation rules and
//    //either pass back error message or send to submit
//    public static boolean validateFields(WeFormObject__c form){
//
//        //String fname = 'First Name Is Required';
//        //String lname = 'Last Name Is Required';
//        //String street = 'Street Address Is Required';
//        //String city = 'City Is Required';
//        //String state = 'State Is Required';
//        //String zip = 'Postal Code Is Required';
//        // String email = 'Email Is Required';
//        //String phone = 'Phone Number Is Required';
//        String req = 'Required';
//        String phoneFormat = 'Enter a valid phone number';
//        String pcFormat = 'Enter a valid postal code';
//        String email = 'Enter a valid email';
//        String dateError = 'Enter a valid date';
//        String moneyFormat = 'Enter a value greater than zero';
//        String addressFormat = 'Enter an address less than 40 characters';
//
//
//        Decimal num = 0.00;
//
//        SYSTEM.debug('form= '+ form);
//        boolean errors = true;
//        Integer count = 0;
//        //**Tell us about your business**//
//        if(form.Company_Name__c == null){
//            form.Company_Name__c.addError(req);
//            count ++;
//        }
//        if(form.Business_Street_Address__c == null){
//            form.Business_Street_Address__c.addError(req);
//            count ++;
//            //validate against po box
//        }
//        if(form.Business_Street_Address__c != null){
//            if(!validatePoBox(form.Business_Street_Address__c)){
//                form.Business_Street_Address__c.addError('Enter a physical address');
//                count++;
//            }
//            if(form.Business_Street_Address__c.length() > 40){
//                form.Business_Street_Address__c.addError('Enter a physical address less than 40 characters');
//                count++;
//            }
//        }
//        if(form.City__c == null){
//            form.City__c.addError(req);
//            count ++;
//        }
//        if(form.State__c == null){
//            form.State__c.addError(req);
//            count ++;
//        }
//        if(form.Zip_code__c == null){
//            form.Zip_code__c.addError(req);
//            count ++;
//        }
//        if(form.Zip_code__c != null){
//
//            if(!validatePostal(form.Zip_code__c, form.State__c)){
//                form.Zip_code__c.addError(pcFormat);
//                count ++;
//            }
//
//        }
//
//
//        if(form.Business_Phone__c == null){
//            form.Business_Phone__c.addError(req);
//            count ++;
//            //validate phone
//        }
//        if(form.Business_Phone__c!=null){
//            if(!validatePhone(form.Business_Phone__c)){
//                form.Business_Phone__c.addError(phoneFormat);
//                count ++;
//            }
//
//        }
//
//        if(form.Business_Fax__c != null){
//            if(!validatePhone(form.Business_fax__c)){
//                form.Business_fax__c.addError('Enter a valid fax number');
//                count++;
//            }
//
//        }
//        if(form.Taxpayer_ID__c == null){
//            form.Taxpayer_ID__c.addError(req);
//            count ++;
//            //validate tax id
//        }
//        if(form.Taxpayer_ID__c != null){
//
//            if(!form.Taxpayer_ID__c.isNumeric()){
//                form.Taxpayer_ID__c.addError('Enter a valid taxpayer id');
//                count++;
//            }
//            if(form.Taxpayer_ID__c.length() != 9){
//                form.Taxpayer_ID__c.addError('Enter a valid taxpayer id');
//                count++;
//            }
//
//
//        }
//        if(form.Years_in_Business__c == null){
//            form.Years_in_Business__c.addError(req);
//            count ++;
//        }
//        if(form.Legal_Structure__c == null){
//            form.Legal_Structure__c.addError(req);
//            count ++;
//        }
//        //validate duns number
//        if(form.DUNS_Number__c != null){
//            if(form.DUNS_Number__c.length() != 9){
//                form.DUNS_Number__c.addError('Enter a valid DUNS number');
//                count++;
//            }
//            if(!form.DUNS_Number__c.isNumeric()){
//  				form.DUNS_Number__c.addError('Enter a valid DUNS number');
//                count++;
//            }
//
//        }
//        if(form.Annual_Gross_Revenue__c == null){
//            form.Annual_Gross_Revenue__c.addError(req);
//            count ++;
//        }
//
//        if(form.Annual_Gross_Revenue__c != null){
//            if(form.Annual_Gross_Revenue__c <= 0){
//                form.Annual_Gross_Revenue__c.addError(moneyFormat);
//                count ++;
//            }
//        }
//        if(form.Fleet_Size__c == null){
//            form.Fleet_Size__c.addError(req);
//            count ++;
//        }
//        if(form.Estimated_Monthly_Vehicle_Expenses__c == null){
//            form.Estimated_Monthly_Vehicle_Expenses__c.addError(req);
//            count ++;
//        }
//        if(form.Estimated_Monthly_Vehicle_Expenses__c != null){
//            if(form.Estimated_Monthly_Vehicle_Expenses__c <= 0){
//                form.Estimated_Monthly_Vehicle_Expenses__c.addError(moneyFormat);
//                count ++;
//            }
//        }
//        if(form.Is_business_exempt_from_Motor_Fuels_Tax__c == null){
//            form.Is_business_exempt_from_Motor_Fuels_Tax__c.addError(req);
//            count ++;
//        }
//
//        //***Billing Information***//
//        if(form.Billing_Contact_First_Name__c==null){
//            form.Billing_Contact_First_Name__c.addError(req);
//            count ++;
//        }
//        if(form.Billing_Contact_Last_Name__c==null){
//            form.Billing_Contact_Last_Name__c.addError(req);
//            count ++;
//        }
//        if(form.Billing_Email__c == null){
//            form.Billing_Email__c.addError(req);
//            count ++;
//            //validate email
//
//        }
//        if(form.Billing_Email__c != null){
//            if(!validateEmail(form.Billing_Email__c)){
//                form.Billing_Email__c.addError(Email);
//                count ++;
//            }
//
//        }
//        if(form.Billing_Street_Address__c == null){
//            form.Billing_Street_Address__c.addError(req);
//            count ++;
//        }
//        if(form.Billing_Street_Address__c != null){
//            if(form.Billing_Street_Address__c.length() > 40){
//                form.Billing_Street_Address__c.addError('addressFormat');
//                count++;
//            }
//        }
//        if(form.Billing_City__c == null){
//            form.Billing_City__c.addError(req);
//            count ++;
//        }
//        if(form.Billing_State__c == null){
//            form.Billing_State__c.addError(req);
//            count ++;
//        }
//        if(form.Billing_Zip_Code__c == null){
//            form.Billing_Zip_Code__c.addError(req);
//            count ++;
//        }
//        if(form.Billing_Zip_Code__c  != null){
//            if(!validatePostal(form.Billing_Zip_Code__c , form.Billing_State__c)){
//                form.Billing_Zip_Code__c.addError(pcFormat);
//                count ++;
//            }
//
//        }
//
//        if(form.Billing_Phone__c == null){
//            form.Billing_Phone__c.addError(req);
//            count ++;
//            //validate phone
//        }
//        if(form.Billing_Phone__c!=null){
//            if(!validatePhone(form.Billing_Phone__c)){
//                form.Billing_Phone__c.addError(phoneFormat);
//                count ++;
//            }
//
//        }
//        //Billing Mobile
//        if(form.Billing_Mobile_Phone__c != null){
//            if(!validatePhone(form.Billing_Mobile_Phone__c)){
//                form.Billing_Mobile_Phone__c.addError(phoneFormat);
//                count++;
//            }
//        }
//        //validate fax
//        if(form.Billing_Fax__c != null){
//            if(!validatePhone(form.Billing_Fax__c)){
//                form.Billing_Fax__c.addError('Enter a valid fax number');
//                count++;
//            }
//        }
//
//        //**Personal Guarantor Info**//
//        if(form.First_Name__c == null){
//            form.First_Name__c.addError(req);
//            count ++;
//        }
//        if(form.Last_Name__c == null){
//            form.Last_Name__c.addError(req);
//            count ++;
//        }
//        if(form.Email__c == null){
//            form.Email__c.addError(req);
//            count ++;
//            //validate email
//        }
//        if(form.Email__c != null){
//            if(!validateEmail(form.Email__c)){
//                form.Email__c.addError(Email);
//                count ++;
//            }
//
//        }
//        if(form.PG_Residential_Phone__c== null){
//            form.PG_Residential_Phone__c.addError(req);
//            count ++;
//            //validate phone
//        }
//        if(form.PG_Residential_Phone__c != null){
//            if(!validatePhone(form.PG_Residential_Phone__c)){
//                form.PG_Residential_Phone__c.addError(phoneFormat);
//                count++;
//            }
//        }
//        if(form.Mobile_Phone__c == null){
//            form.Mobile_Phone__c.addError(req);
//            count ++;
//            //validate phone
//        }
//        if(form.Mobile_Phone__c != null){
//            if(!validatePhone(form.Mobile_Phone__c)){
//                form.Mobile_Phone__c.addError(phoneFormat);
//            }
//
//        }
//        if(form.PG_Residential_Street_Address__c == null){
//            form.PG_Residential_Street_Address__c.addError(req);
//            count ++;
//        }
//        if(form.PG_Residential_Street_Address__c != null){
//            if(form.PG_Residential_Street_Address__c.length() > 40){
//                form.PG_Residential_Street_Address__c.addError(addressFormat);
//                count++;
//            }
//        }
//        if(form.PG_Residential_City__c == null){
//            form.PG_Residential_City__c.addError(req);
//            count ++;
//        }
//        if(form.PG_Residential_State__c == null){
//            form.PG_Residential_State__c.addError(req);
//            count ++;
//        }
//        if(form.PG_Residential_Zip__c == null){
//            form.PG_Residential_Zip__c.addError(req);
//            count ++;
//        }
//        //validate postcode
//        if(form.PG_Residential_Zip__c   != null){
//            if(!validatePostal(form.PG_Residential_Zip__c  ,  form.PG_Residential_State__c)){
//                form.PG_Residential_Zip__c.addError(pcFormat);
//                count ++;
//            }
//
//        }
//
//
//        if(form.PG_SSN__c == null){
//            form.PG_SSN__c.addError(req);
//            count ++;
//            //validate ssn
//        }
//        if(form.PG_SSN__c != null){
//            if(!validateSSN(form.PG_SSN__c)){
//                form.PG_SSN__c.addError('Enter a valid social security number');
//                count ++;
//            }
//
//        }
//        if(form.Date_of_Birth__c == null){
//            form.Date_of_Birth__c.addError(req);
//            count ++;
//        }
//        if(form.Date_of_Birth__c != null){
//            if(!validateDate(form.Date_of_Birth__c)){
//                form.Date_of_Birth__c.addError('Enter a valid date of birth');
//                count ++;
//            }
//
//        }
//        if(form.Guarantor_Annual_Income__c == null){
//            form.Guarantor_Annual_Income__c.addError(req);
//            count ++;
//        }
//        if(form.Guarantor_Annual_Income__c != null){
//            if(form.Guarantor_Annual_Income__c <= 0){
//                form.Guarantor_Annual_Income__c.addError(moneyFormat);
//                count ++;
//            }
//
//        }
//
//        //**Promotional Information**//
//        if(form.How_did_you_hear_about_this_offer__c == null){
//            form.How_did_you_hear_about_this_offer__c.addError(req);
//            count ++;
//        }
//        //**Delivery**//
//        if(form.Paperless_Flag__c == null){
//            form.Paperless_Flag__c.addError(req);
//            count ++;
//        }
//        //application signer
//        if(form.signer_title__c == null){
//            form.signer_title__c.addError(req);
//            count ++;
//        }
//        if(form.Signer_s_First_Name__c == null){
//            form.Signer_s_First_Name__c.addError(req);
//            count ++;
//        }
//        if(form.Signer_s_Last_Name__c == null){
//            form.Signer_s_Last_Name__c.addError(req);
//            count ++;
//        }
//        if(form.Signer_s_Email__c == null){
//            form.Signer_s_Email__c.addError(req);
//            count ++;
//            //validate email
//        }
//        if(form.Signer_s_Email__c != null){
//            if(!validateEmail(form.Signer_s_Email__c)){
//                form.Signer_s_Email__c.addError(Email);
//                count ++;
//            }
//
//        }
//        if(form.Signer_s_Phone__c == null){
//            form.Signer_s_Phone__c.addError(req);
//            count ++;
//            //validate phone
//        }
//        if(form.Signer_s_Phone__c != null){
//
//            if(!validatePhone(form.Signer_s_Phone__c)){
//                form.Signer_s_Phone__c.addError(phoneFormat);
//                count ++;
//            }
//
//
//        }
//
//        if(count == 0){
//            errors = false;
//        }
//
//        SYSTEM.debug('error is' + errors);
//        return errors;
//    }
//
//
//
//
}