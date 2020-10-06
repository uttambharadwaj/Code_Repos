trigger updateCoupon on Campaign_Pricing__c (before insert, before update) {

    // Get the list of incoming codes
    List<String> codes = new List<String>();
    
    // Populate the list with the incoming codes to pass to the SOQL
    for(Campaign_Pricing__c campaignPricing : trigger.new) {
       	codes.add(campaignPricing.coup_code__c);
    }
    
    // Build a map of coupon codes to campaigns
    Map<String, Campaign> couponToCampaignMap = new Map<String, Campaign>();
	
    // Populate the map with a key of the coupon code and the campaign object
	for(Campaign cmp : [SELECT Coupon_Code__c, IsActive FROM Campaign WHERE Coupon_Code__c IN :codes])
		couponToCampaignMap.put(cmp.Coupon_Code__c, cmp);
    
    // Finally iterate over the campaign pricing objects and update them
    for(Campaign_Pricing__c campaignPricing : trigger.new) {
        
		// Get the matching campaign for the campaign pricing coupon code        
		Campaign matchedCampaign = couponToCampaignMap.get(campaignPricing.coup_code__c);
        
        if(matchedCampaign != null && campaignPricing.coup_code__c == matchedCampaign.Coupon_Code__c) {
                       
    		campaignPricing.Coupon_Status__c = 'valid';
	            
	        if (matchedCampaign.IsActive == true) {
	        	campaignPricing.is_Active__c = true;
	        }
			else {
				campaignPricing.is_Active__c = false;
			}
            
            system.debug('Matched ' + campaignPricing.coup_code__c + ' to ' + matchedCampaign.Coupon_Code__c + ' and setting isActive to ' + campaignPricing.is_Active__c + ' and the status to ' + campaignPricing.Coupon_Status__c);
            
        }
        else {
           	campaignPricing.Coupon_Status__c = 'invalid';
			campaignPricing.is_Active__c = false; 
            
            system.debug('No match for ' + campaignPricing.coup_code__c + '! Setting isActive to ' + campaignPricing.is_Active__c + ' and the status to ' + campaignPricing.Coupon_Status__c);
        }
        
    }
    
}