public class WEXPricingHelper {

    
    Public Map<String, String> getPricing(Campaign_Pricing__c cp){
        Map<String, String> pricing = new Map<String, String>();
        String rate = ' ';
        String penRate = ' ';
        String primeDate = ' ';
        String lateFee = ' ';
        String retFee = ' ';
        String paperFee = ' ';
        String ovrLimFee = ' ';
    
        
        
        //test condition for rate 
        if((cp.risk_code__c.equalsIgnoreCase('No')) && (cp.contract_margin__c.equalsIgnoreCase('Y')) && (cp.Contract_Rate_Type__c.equalsIgnoreCase('Variable'))){
            rate = 'Prime + ' + cp.contract_rate_pct__c + '%';
        }
        if((cp.risk_code__c.equalsIgnoreCase('No')) && (cp.contract_margin__c.equalsIgnoreCase('N')) && (cp.Contract_Rate_Type__c.equalsIgnoreCase('Fixed'))){
            rate = cp.contract_rate_pct__c + '%';
        }
        if((cp.risk_code__c.equalsIgnoreCase('7')) && (cp.contract_margin__c.equalsIgnoreCase('Y')) && (cp.Contract_Rate_Type__c.equalsIgnoreCase('Variable'))){
            rate = 'Up to Prime + ' + cp.contract_rate_pct__c + '%';
        }
        if((cp.risk_code__c.equalsIgnoreCase('7')) && (cp.contract_margin__c.equalsIgnoreCase('N')) && (cp.Contract_Rate_Type__c.equalsIgnoreCase('Fixed'))){
            rate = 'Up to ' + cp.contract_rate_pct__c + '%';
        }
        
        //test condition for penalty
        if((cp.risk_code__c.equalsIgnoreCase('No')) && (cp.penalty_margin__c.equalsIgnoreCase('Y')) && (cp.Penalty_Rate_Type__c.equalsIgnoreCase('Variable'))){
            penRate = 'Prime + ' + cp.pen_rate_pct__c + '%';
        }
        if((cp.risk_code__c.equalsIgnoreCase('No')) && (cp.penalty_margin__c.equalsIgnoreCase('N')) && (cp.Penalty_Rate_Type__c.equalsIgnoreCase('Fixed'))){
            penRate = cp.pen_rate_pct__c + '%';
        }
        if((cp.risk_code__c.equalsIgnoreCase('7')) && (cp.penalty_margin__c.equalsIgnoreCase('Y')) && (cp.Penalty_Rate_Type__c.equalsIgnoreCase('Variable'))){
            penRate = 'Up to Prime + ' + cp.pen_rate_pct__c + '%';
        }
        if((cp.risk_code__c.equalsIgnoreCase('7')) && (cp.penalty_margin__c.equalsIgnoreCase('N')) && (cp.Penalty_Rate_Type__c.equalsIgnoreCase('Fixed'))){
            penRate = 'Up to ' + cp.pen_rate_pct__c + '%';
        }
        
       //Test condition for Prime Rate Effective Date
        if((cp.contract_margin__c.equalsIgnoreCase('Y')) && (cp.Contract_Rate_Type__c.equalsIgnoreCase('Variable')) && (cp.penalty_margin__c.equalsIgnoreCase('Y')) && 
           cp.Penalty_Rate_Type__c.equalsIgnoreCase('Variable')){
            primeDate = 'Variable rates are based on the Prime Rate as of ' + cp.prime_rate_effective_date__c.format();
        }
         if((cp.contract_margin__c.equalsIgnoreCase('Y')) && (cp.Contract_Rate_Type__c.equalsIgnoreCase('Variable')) && (cp.penalty_margin__c.equalsIgnoreCase('N')) && 
           cp.Penalty_Rate_Type__c.equalsIgnoreCase('Fixed')){
            primeDate = 'Variable rates are based on the Prime Rate as of ' + cp.prime_rate_effective_date__c.format();
        }
         if((cp.contract_margin__c.equalsIgnoreCase('N')) && (cp.Contract_Rate_Type__c.equalsIgnoreCase('Fixed')) && (cp.penalty_margin__c.equalsIgnoreCase('Y')) && 
           cp.Penalty_Rate_Type__c.equalsIgnoreCase('Variable')){
            primeDate = 'Variable rates are based on the Prime Rate as of  ' + cp.prime_rate_effective_date__c.format();
        }
         if((cp.contract_margin__c.equalsIgnoreCase('N')) && (cp.Contract_Rate_Type__c.equalsIgnoreCase('Fixed')) && (cp.penalty_margin__c.equalsIgnoreCase('N')) && 
           cp.Penalty_Rate_Type__c.equalsIgnoreCase('Fixed')){
            primeDate = 'N/A';
        }
        
        //Test Condition For Fixed Late Fee
        if((cp.risk_code__c.equalsIgnoreCase('No')) && (cp.late_fee_type__c.equalsIgnoreCase('P'))){
            lateFee = cp.pct_late_fee__c + '% of the account balance';
        }
        if((cp.risk_code__c.equalsIgnoreCase('No')) && (cp.late_fee_type__c.equalsIgnoreCase('F'))){
            lateFee = '$' + cp.fixed_late_fee__c;
        }
        if((cp.risk_code__c.equalsIgnoreCase('7')) && (cp.late_fee_type__c.equalsIgnoreCase('P'))){
            lateFee = 'Up to '+ cp.pct_late_fee__c + '% of the account balance';
        }
        if((cp.risk_code__c.equalsIgnoreCase('7')) && (cp.late_fee_type__c.equalsIgnoreCase('F'))){
            lateFee = 'Up to $'+ cp.fixed_late_fee__c;
        }
        
        //Test for retFee, paperFee, and ovrLimFee
        if(cp.risk_code__c.equalsIgnoreCase('No')){
            retFee = '$' + cp.return_payment_fee__c + ' per occurrence';
            paperFee = '$' + cp.paper_delivery_fee__c + ' per month for paper statement and reporting';
            ovrLimFee = '$' + cp.over_limit_fee__c + ' per occurrence';
        }
        if(cp.risk_code__c.equalsIgnoreCase('7')){
            retFee = 'Up to $' + cp.return_payment_fee__c + ' per occurrence';
            paperFee = 'Up to $' + cp.paper_delivery_fee__c + ' per month for paper statement and reporting';
            ovrLimFee = 'Up to $' + cp.over_limit_fee__c + ' per occurrence';
        }
        //Add Key/Value pairs
        pricing.put('Annual Percentage Rate (APR) for Purchases: ', rate);
        if(cp.promo_periods__c != 0){
        pricing.put('Introductory APR for Purchases: ', cp.promotional_rate__c + '% introductory APR for ' + cp.nbr_billing_cyles__c + '  cycles after account opening.');
        }
        pricing.put('Penalty APR: ', penRate);
        //check for N/A on Prime
        if(primeDate != 'N/A'){
            pricing.put('Prime Rate: ', primeDate);
        }
        pricing.put('Paper Delivery Fee: ', paperFee);
        pricing.put('Late Payment Fee: ', lateFee);
        pricing.put('Overlimit Fee: ', ovrLimFee);
        pricing.put('Returned Payment Fee: ', retFee);


        
        
        
        
        
        return pricing;
    }
}