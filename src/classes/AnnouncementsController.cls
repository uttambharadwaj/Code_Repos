/*

    Name: AnnouncementsController
    Created By: Marc Gartner (GearsCRM)
    Created Date: 4/9/2014
    Description: 
    
    Modified By: 
    Modified Date: 
    Description: 

*/

public with sharing class AnnouncementsController 
{  
  public Integer NumberOfAnnouncements {get; set;}
  public List<announcmentWrapper> Records {get; private set;}
   
    public AnnouncementsController()
    {
      this.NumberOfAnnouncements = 5;
      loadAnnouncements();
    }    
    
    private void loadAnnouncements()
    {
      /*
      this.Records = [select 
                          Id, 
                          Name, 
                          Date_Posted__c, 
                          Summary__c, 
                          URL__c
                        from 
                          Announcements__c 
                        where 
                          End_Date__c >= TODAY AND Active__c = TRUE
                        order by 
                          Date_Posted__c desc 
                        limit :NumberOfAnnouncements];
      */

      Records = new List<announcmentWrapper>();

      
      for(Announcements__c ann : [select 
                                  Id, 
                                  Name, 
                                  Date_Posted__c, 
                                  Summary__c, 
                                  URL__c
                                from 
                                  Announcements__c 
                                where 
                                  End_Date__c >= TODAY AND Active__c = TRUE
                                order by 
                                  Date_Posted__c desc 
                                limit :NumberOfAnnouncements])
      {
        Records.add(new announcmentWrapper(ann));
      }

    }
    
    public class CustomException extends Exception {}

    public class announcmentWrapper
    {
      public Announcements__c a {get;set;}
      public string summary {get;set;}

      public announcmentWrapper(Announcements__c an)
      {
          a = an;
          if(an.Summary__c != null && an.Summary__c.length()>150)
          {
              summary = an.Summary__c.substring(0,149) + '.......';
          }
          else
          {
            summary = (an.Summary__c==null) ? '' : an.Summary__c;
          }
      }
    }
}