/*
* VF page controller for Shell CPQ template rebate section
*
* Revision History:
* 03/Oct/2019 CJackson    PSOBACKLOG-258   Original
* 19/Nov/2019 CJackson    PSOBACKLOG-304   Sorted quote lines and adjusted show/hide options
* 26/Nov/2019 CJackson    PSOBACKLOG-310   Added logic to remove 1 from Discount Tier Maximum
*/

public with sharing class DiscountSchedulePrintControllerShell {
    public List<SBQQ__DiscountTier__c> tiers {get; private set;}
    public List<SBQQ__QuoteLine__c> lines {get; private set;}
    public List<printableLine> linesWithTiers {get; set;}
    public SBQQ__Quote__c quote {get; set;}
    public Decimal upperBound { get ; set; }

    public DiscountSchedulePrintControllerShell () {
        linesWithTiers = new List<printableLine>();
        Id quoteId = (Id)ApexPages.currentPage().getParameters().get('qid');
        quote = [SELECT Early_Pay_Selection__c FROM SBQQ__Quote__c WHERE Id = :quoteId];

        lines = [SELECT SBQQ__NetPrice__c, Id, SBQQ__Product__c, SBQQ__ListPrice__c, SBQQ__Product__r.Name FROM SBQQ__QuoteLine__c where SBQQ__Quote__c =: quoteId ORDER BY SBQQ__Number__c];

        for(SBQQ__QuoteLine__c line : lines) {
            tiers = [SELECT Name, SBQQ__Discount__c, SBQQ__Number__c, SBQQ__LowerBound__c, SBQQ__UpperBound__c, SBQQ__Schedule__c, Cents_Per_Gallon__c, Election__c, Payment_Timing_Options__c, Basis_Points__c, Basis_Points_Rebate__c, Payment_Timing__c, Bonus_Rebate__c FROM SBQQ__DiscountTier__c where CurrencyIsoCode = 'USD' and SBQQ__Schedule__c in (select sbqq__discountschedule__c from sbqq__quoteline__c where id =: line.Id)
            ORDER BY SBQQ__Number__c DESC];
            if(tiers.size() >= 1) {
                printableLine pLine = new printableLine();
                pLine.name = line.SBQQ__Product__r.Name;
                pLine.displayColumns = new Boolean[] {false, false, false, false, false, false, false, false, false};
                for(SBQQ__DiscountTier__c tier : tiers) {
                    upperBound = tier.SBQQ__UpperBound__c;
                    pLine.tiers.add(new printableTier(tier.SBQQ__LowerBound__c,
                            (tier.SBQQ__UpperBound__c!=null) ? (upperBound -= 1 ): tier.SBQQ__UpperBound__c,
                            tier.Cents_Per_Gallon__c,
                            (quote.Early_Pay_Selection__c!=null && quote.Early_Pay_Selection__c==tier.Election__c) ? 'X' : '',
                            tier.Payment_Timing_Options__c, tier.Basis_Points_Rebate__c, tier.Payment_Timing__c, tier.Bonus_Rebate__c,
                            tier.SBQQ__Number__c));
                    if (tier.SBQQ__LowerBound__c!=null) pLine.displayColumns[0] = true;
                    if (tier.SBQQ__UpperBound__c!=null) pLine.displayColumns[1] = true;
                    if (tier.Cents_Per_Gallon__c!=null) pLine.displayColumns[2] = true;
                    if (quote.Early_Pay_Selection__c!=null && quote.Early_Pay_Selection__c==tier.Election__c) pLine.displayColumns[3] = true;
                    if (tier.Payment_Timing_Options__c!=null) pLine.displayColumns[4] = true;
                    //if (tier.Basis_Points_Rebate__c!=null) pLine.displayColumns[5] = true;
                    if (tier.Basis_Points_Rebate__c!='0 basis points') pLine.displayColumns[5] = true;
                    if (tier.Payment_Timing__c!=null) pLine.displayColumns[6] = true;
                    if (tier.Bonus_Rebate__c!=null) pLine.displayColumns[7] = true;
                    if (tier.SBQQ__Number__c!=null) pLine.displayColumns[8] = true;
                }

                if (pLine.displayColumns[6] == true) { //when payment timing is populated, don't display number, lower bound, upper bound
                    pLine.displayColumns[0] = false;
                    pLine.displayColumns[1] = false;
                    pLine.displayColumns[8] = false;
                }

                if (pLine.displayColumns[7] == true) { //when bonus rebate is populated, don't display number, lower bound, upper bound
                    pLine.displayColumns[0] = false;
                    pLine.displayColumns[1] = false;
                    pLine.displayColumns[8] = false;
                    //pLine.displayColumns[5] = false;
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
        public String bonusRebate {get; set;}
        public Decimal tierNumber {get; set;}

        public printableTier(Decimal l, Decimal u, Decimal cents, String ele, String ptimOpt, String rebate, String ptim, String brebate , Decimal tnumber) {
            lowerBound = l;
            upperBound = u;
            centsPerGallon = cents;
            election = ele;
            paymentTimingOptions = ptimOpt;
            basisPointsRebate = rebate;
            paymentTiming = ptim;
            bonusRebate = brebate;
            tierNumber = tnumber;
        }
    }
}