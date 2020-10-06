public with sharing class TopOpportunityController {
    
    public List<OppWrapper> opps {get;set;}
    public Integer compheight{get;set;}
    public Integer compwidth{get;set;}
    public String comptitle{get;set;}

    public TopOpportunityController() {
        loadData();
    }

    private void loadData()
    {
    
        CommHomePageSettings__c comsettings = CommHomePageSettings__c.getorgdefaults();
        comptitle = comsettings.top_opportunities_title__c;
        compheight = integer.valueof(comsettings.top_opportunities_height__c);
        compwidth = integer.valueof(comsettings.top_opportunities_width__c);
        
        opps = new List<OppWrapper>();
        Map<Id,Integer> idAndSort = new Map<Id,Integer>();

        
        for(TopOpportunities__c tt : TopOpportunities__c.getall().values())
        {
            //if(tt.Opportunity_Id__c==null || tt.Opportunity_Id__c.length()!=18) continue;

            if(tt.Opportunity_Id__c==null || !(tt.Opportunity_Id__c InstanceOf Id)) continue;

            idAndSort.put((Id)tt.Opportunity_Id__c, (Integer)tt.Sort__c);
        }
        
        Set<Id> idSet = idAndSort.keySet();
        

        for(Opportunity o : [Select Id, Name, Fleet_Size__c from Opportunity Where Id IN :idSet])
        {
            opps.add(new OppWrapper(o, idAndSort.get(o.Id)));
        }

        opps.sort();
        
        for(integer x = 0; x<opps.size(); x++)
        {
            opps[x].setcounter(x+1);
        }
    }

    public class OppWrapper implements Comparable
    {
        public Opportunity opp{get;set;}
        public String oppLink{get;set;}
        private Integer sortOrder{get;set;}
        public integer counter{get;set;}

        public OppWrapper(Opportunity o, Integer sortOrd)
        {
            opp = o;
            oppLink = '/' + o.Id;
            sortOrder = sortOrd;
            counter = 0;

        }
        public void setcounter(Integer i)
        {
            counter = i;
        }

        public Integer compareTo(object compareTo)
        {
            OppWrapper rw = (OppWrapper)compareTo;
            if(sortOrder == rw.sortOrder)
            {
                return 0;
            }
            else if(sortOrder > rw.SortOrder || rw.SortOrder==null)
            {
                return 1;
            }

            return -1;
        }
    }
}