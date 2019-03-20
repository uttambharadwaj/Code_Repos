public class WEXBrandUtility {
   
    public Program__c setProgramFromURL(String brandUrlParam, String url){
        
        List<Program__C> programs;
 		
        system.debug('brandUrlParam in wexbrandutility is: ' + brandUrlParam);
        if (brandUrlParam != null){
        	programs = [select Name, Brand_Short_Name__c, Brand_Folder_Name__c, Brand_Long_Name__c, T_C__c, SideBar__c, Analytics_Body_Block__c, Analytics_Head_Block__c, Brand_Heading__c, Custom_Email_Header_URL__c,
                         Brand_Tagline__c, Brand_Color_1__c, Brand_Color_2__c, Peoplesoft_rel_code__c, Upload_Pricing_Data_Flag__c, Publish_BOCA__c, Confirmation_Info__c, Inside_Sales_Phone_Number__c,
                         Live_Person_Code__c, form_template__c,  Side_Panel_Title__c, toLabel(Section_Titles__c), BOCA_Type__c
                         from program__c 
                         where Brand_Short_Name__c = :brandUrlParam ];    
        }
        
        if (programs == null || programs.size() == 0 || programs[0].Brand_Short_Name__c == ''){
            programs = [select Name, Brand_Short_Name__c, Brand_Folder_Name__c, Brand_Long_Name__c, T_C__c, SideBar__c, Analytics_Body_Block__c, Analytics_Head_Block__c, Brand_Heading__c, Custom_Email_Header_URL__c,
                         Brand_Tagline__c, Brand_Color_1__c, Brand_Color_2__c, Peoplesoft_rel_code__c, Upload_Pricing_Data_Flag__c, Publish_BOCA__c, Confirmation_Info__c, Inside_Sales_Phone_Number__c,
                         Live_Person_Code__c, form_template__c, Side_Panel_Title__c, toLabel(Section_Titles__c), BOCA_Type__c
                          from program__c 
                         where url__c = :url ];   
        }  
        
        if (programs == null || programs.size() == 0 || programs[0].Brand_Short_Name__c == ''){
        	//error - no program found
        }
        
		if (programs != null && programs.size() > 0)        
        	return programs[0];  
        else 
            return null;
    }
    
    public Campaign_Program__c getCampaignProgram(Program__c pgm, Campaign camp){
        
        List<Campaign_Program__c> cpList = [
            select id, Default__c, Terms_and_Conditions__c, campaign__c
        	from Campaign_Program__c
            where program__c = :pgm.Id
            and campaign__c = :camp.Id
        ];
        
        //If both the program and campaign are valid but aren't tied to each other
        //then get the default one for the program
        if (cpList.size() == 0){
        	return getDefaultCampaignProgram(pgm);
        }
        
        return cpList[0];
    }
    public Campaign_Program__c getDefaultCampaignProgram(Program__c pgm){
        List<Campaign_Program__c> cpList = [
            select id, Default__c, Terms_and_Conditions__c, campaign__c
        	from Campaign_Program__c
            where program__c = :pgm.Id
            and Default__c = true
        ];
        return cpList[0];
    }
    /*
    public Terms_and_Conditions__c getTermsAndConditions(String couponCodeUrlParam, Program__c pgm){

        List<Terms_and_Conditions__c> tAndC;
        List<Campaign> camp = new List<Campaign>();
         
        //If we come in with a coupon code then get use that to get the campaign program
        if (couponCodeUrlParam != '' && couponCodeUrlParam != null){
            
            camp = [select id from campaign where Coupon_Code__c = :couponCodeUrlParam];
            
            SYSTEM.debug('CAMPAIGN: ' + camp + 'for this one: ' + couponCodeUrlParam);
            
            if (camp != null && camp.size() > 0){
                tAndC = [
                    select id, T_C_Text__c, Campaign__c 
                    from Terms_and_Conditions__c
                    where Campaign__c = :camp[0].id
                    and Program__c = :pgm.id
                ];
            }
        } 

        //if no coupon code came in .. or the coupon code isnt set up for the specific program, 
        //then get the default campaign_program for the program
        if (couponCodeUrlParam == '' || couponCodeUrlParam == null || tAndC == null || tAndC.size() == 0){
          	//get the default campaign_program for the program
        	tAndC = [
                select id, Campaign__c , T_C_Text__c 
                from Terms_and_Conditions__c 
                where Program__c = :pgm.id
                and Is_Default__c = true
            ];  
            
        }            
        
        if (tAndC.size() > 0)
        	return tAndC[0];
        else 
            return null;
        
	}
    */ 
    public String getCouponCode(Campaign_Program__c cp){
        if (cp == null) return null;
        
        List<Campaign> camp = [select Coupon_Code__c from campaign where id = :cp.Campaign__c];
        
        if (camp == null || camp.size() == 0) return null;
        
        return camp[0].Coupon_Code__c;        
    }
  
  public boolean isValidTemplateForProgram(String url, Program__c pgm){
		system.debug('template is: ' + pgm.Form_Template__c);
        system.debug('url is: ' + url);
        
        //TODO - figure out a better way of querying the url... possibly
        String template = pgm.Form_Template__c;
      	if(template == null){template = pgm.Template__c;}
            
            if (url.containsIgnoreCase(template)){
                return true;
            }
   
         
        return false;
    }

    public String getValidCouponCode(String ProgramId, String couponCode){
        if (ProgramId == null) return null;

		//Does this campaign exist?        
        List<Campaign> camp = [select Id, Coupon_Code__c from campaign where Coupon_Code__c = :couponCode];
        
        //Does this campaign exist for the program in focus?
        if (camp != null && camp.size() > 0){
            List<Campaign_Program__c> cp = [
                select campaign__c
                from Campaign_Program__c
                where program__c = :ProgramId
                and campaign__c = :camp[0].Id
            ];         
            
            if (cp.size() > 0){
                return camp[0].Coupon_Code__c;
            }
        }
        
        //else get the default coupon code for the program
        List<Campaign_Program__c> cp1 = [
            select campaign__c
            from Campaign_Program__c
            where program__c = :ProgramId
            and Default__c = true
        ]; 
        system.debug('cp1 Id: ' + cp1[0].Id );
        camp = [select Coupon_Code__c from campaign where Id = :cp1[0].campaign__c];
            
        return camp[0].Coupon_Code__c;
        
    } 
    
    public String getDefault(String ProgramId){
        Campaign_Program__c cp =  [select campaign__c from Campaign_Program__c where program__c =: ProgramId and Default__c = true];
        Campaign c = [select Coupon_Code__c from campaign where Id =: cp.Campaign__c];
        String code = c.Coupon_Code__c;
        return code;
    }
    
    public List<Campaign_Pricing__c> getPricing(String peoplesoft_rel_code, String couponCode){

        List<Campaign_Pricing__c> pricingList = [
            select 
                nbr_billing_cyles__c,contract_rate_pct__c,
                contract_margin__c, Contract_Rate_Type__c,
                coup_code__c, Coupon_Status__c,
                days_to_pay__c, fixed_late_fee__c,
                is_Active__c, late_fee_type__c,
                minimum_payment_percentage__c,over_limit_fee__c,
                paper_delivery_fee__c,pct_late_fee__c,
                pen_rate_pct__c, penalty_margin__c,
                penalty_rate_ceiling__c, Penalty_Rate_Type__c,
                prime_rate__c,prime_rate_effective_date__c,
                promo_add_prime__c, promo_periods__c,
                promotional_rate__c, Peoplesoft_rel_code__c,
                return_payment_fee__c, risk_code__c
            from Campaign_Pricing__c
            where Peoplesoft_rel_code__c = :peoplesoft_rel_code
        	and coup_code__c = :couponCode];
 		if(pricingList.size() > 0)return pricingList;
  		else return null;
    }
    
 
}