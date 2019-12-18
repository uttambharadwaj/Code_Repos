/*
* VF page controller for CPQ template rebate section
*
* Revision History:
* 03/Oct/2019 Gears       CPQ Upgrade      Original
* 26/Nov/2019 CJackson    PSOBACKLOG-310   Added logic to remove 1 from Discount Tier Maximum
* 09/Dec/2019 CJackson    PSOBACKLOG-319   Modified logic to remove 1 from Discount Tier Maximum (using new formula field).
*/

public with sharing class DiscountSchedulePrintController {
    public List<SBQQ__DiscountTier__c> tiers {get; private set;}
    public List<SBQQ__QuoteLine__c> lines {get; private set;}
    public List<printableLine> linesWithTiers {get; set;}
    public SBQQ__Quote__c quote {get; set;}

    public DiscountSchedulePrintController() {
        linesWithTiers = new List<printableLine>();
        Id quoteId = (Id)ApexPages.currentPage().getParameters().get('qid');
        quote = [SELECT Early_Pay_Selection__c FROM SBQQ__Quote__c WHERE Id = :quoteId];

        lines = [SELECT SBQQ__NetPrice__c, Id, SBQQ__Product__c, SBQQ__ListPrice__c, SBQQ__Product__r.Name FROM SBQQ__QuoteLine__c where SBQQ__Quote__c =: quoteId];

        for(SBQQ__QuoteLine__c line : lines) {
            tiers = [SELECT Name, SBQQ__Discount__c,SBQQ__Number__c, SBQQ__LowerBound__c, Max_Spend_WEX__c, SBQQ__Schedule__c, Cents_Per_Gallon__c, Election__c, Payment_Timing_Options__c, Basis_Points_Rebate__c, Basis_Points__c, Payment_Timing__c FROM SBQQ__DiscountTier__c where CurrencyIsoCode = 'USD' and SBQQ__Schedule__c in (select sbqq__discountschedule__c from sbqq__quoteline__c where id =: line.Id)
            ORDER BY SBQQ__LowerBound__c ASC];
            if(tiers.size() >= 1) {
                printableLine pLine = new printableLine();
                pLine.name = line.SBQQ__Product__r.Name;
                pLine.displayColumns = new Boolean[] {false, false, false, false, false, false, false};
                for(SBQQ__DiscountTier__c tier : tiers) {
                    pLine.tiers.add(new printableTier(tier.SBQQ__LowerBound__c, tier.Max_Spend_WEX__c, tier.Cents_Per_Gallon__c,
                            (quote.Early_Pay_Selection__c!=null && quote.Early_Pay_Selection__c==tier.Election__c) ? 'X' : '',
                            tier.Payment_Timing_Options__c, tier.Basis_Points_Rebate__c, tier.Payment_Timing__c));
                    if (tier.SBQQ__LowerBound__c!=null) pLine.displayColumns[0] = true;
                    if (tier.SBQQ__UpperBound__c!=null) pLine.displayColumns[1] = true;
                    if (tier.Cents_Per_Gallon__c!=null && tier.Cents_Per_Gallon__c!=0) pLine.displayColumns[2] = true;
                    if (quote.Early_Pay_Selection__c!=null && quote.Early_Pay_Selection__c==tier.Election__c) pLine.displayColumns[3] = true;
                    if (tier.Payment_Timing_Options__c!=null) pLine.displayColumns[4] = true;
                    if (tier.Basis_Points__c!=null && tier.Basis_Points__c!=0) pLine.displayColumns[5] = true;
                    if (tier.Payment_Timing__c!=null) pLine.displayColumns[6] = true;
                }

                if (pLine.displayColumns[6] == true) { //when payment timing is populated, don't display lower bound, upper bound
                    pLine.displayColumns[0] = false;
                    pLine.displayColumns[1] = false;
                }

                linesWithTiers.add(pLine);
            }
        }
    }

    public class printableLine {
        public String name {get; set;}
        public List<printableTier> tiers {get; set;}
        public Boolean[] displayColumns {get; set;}

        public Decimal dataColumnWidth {
            get{
                Integer width = 0;
                for (Integer i=0; i<displayColumns.size(); i++) {
                    if (displayColumns[i]==true) {
                        width++;
                    }
                }
                if (width==0) width = 1;
                return 100.00/width;
            }
            private set;
        }

        public printableLine() {
            tiers = new List<printableTier>();
        }
    }

    public class printableTier {
        public Decimal lowerBound {get; set;}
        public Decimal upperBound {get; set;}
        public Decimal centsPerGallon {get; set;}
        public String election {get; set;}
        public String paymentTimingOptions {get; set;}
        public String basisPointsRebate {get; set;}
        public String paymentTiming {get; set;}

        public printableTier(Decimal l, Decimal u, Decimal cents, String ele, String ptimOpt, String rebate, String ptim) {
            lowerBound = l;
            upperBound = u;
            centsPerGallon = cents;
            election = ele;
            paymentTimingOptions = ptimOpt;
            basisPointsRebate = rebate;
            paymentTiming = ptim;
        }
    }
}