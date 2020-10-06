public class CommonReportsController {
                
        public List<reportsWrapper> reports {get;set;}
        public Integer compheight{get;set;}
        public Integer compwidth{get;set;}
        public String comptitle{get;set;}

        public CommonReportsController() {
                loadData();
                //comptitle = '';
                //compwidth = 25;
                //compheight = 100;
        }

        private void loadData()
        {
                CommHomePageSettings__c comsettings = CommHomePageSettings__c.getorgdefaults();
                comptitle = comsettings.common_reports_title__c;
                compheight = integer.valueof(comsettings.common_reports_height__c);
                compwidth = integer.valueof(comsettings.common_reports_width__c);

                reports = new List<reportsWrapper>();
                for(CommonReports__c cr : CommonReports__c.getall().values())
                {
                                if(cr.Active__c != true) continue;
                                reports.add(new reportsWrapper(cr));
                }

                reports.sort();                   
        }

        public class reportsWrapper implements Comparable
        {
                public String reportname{get;set;}
                public String reportURL{get;set;}
                private Integer sortOrder{get;set;}

                public reportsWrapper(CommonReports__c cr)
                {
                        reportname = cr.Report_Title__c;
                        reportURL = cr.Report_URL__c;
                        sortOrder = Integer.valueOf(cr.Sort__c);

                }

                public Integer compareTo(object compareTo)
                {
                        reportsWrapper rw = (reportsWrapper)compareTo;
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