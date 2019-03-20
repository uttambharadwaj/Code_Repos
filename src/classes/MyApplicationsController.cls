/*

    Name: MyApplicationsController
    Created By: Phillip Southern (GearsCRM)
    Created Date: 
    Description: 
    
    Modified By: 
    Modified Date: 
    Description: 

*/

public class MyApplicationsController {

  private User userRecord;
  public List<Application_Request__c> Records {get; private set;}
   
    public MyApplicationsController()
    {
      loadUserRecord();
      loadRecords();
    }    
    
    private void loadUserRecord()
    {
      List<User> users = [select 
                    Id,
                    UserType,
                    ContactId,
                    UserRoleId
                  from 
                    User
                  where
                    Id = :UserInfo.getUserId() and 
                    IsActive = true];
                    
    if(users.size() == 1)
    {
      this.userRecord = users[0];

      system.debug('--AR user info: ' + userRecord.Id + ' ' + userRecord.ContactId);
    }
    else
    {
      if(users.size() == 0)
      {
        throw new CustomException('MyApplicationsController.loadUserRecord - No active user found with a Id: ' + 
          UserInfo.getUserId());  
      }
      else
      {
        throw new CustomException('MyApplicationsController.loadUserRecord - More than one active user found with a Id: ' + 
          UserInfo.getUserId());
      }
    }                    
    }
    
    private void loadRecords()
    {

      Records = new List<Application_Request__c>();
      if(!UGears.UUser.isPortalUser(userRecord)) return;

      Set<Id> subOrdContactIds = new Set<Id>();

      for(User subU : [Select ContactId from User 
                      Where UserRole.ParentRoleId = :userRecord.UserroleId
                      AND ContactId != null])
      {
        subOrdContactIds.add(subU.ContactId);
      }

      String soqlQuery = 'Select Name, Opportunity__c, App_Submitted_Date__c, Program__c, CreatedDate, Sales_Stage__c ' +
        'from Application_Request__c Where External_Referring_Contact__c  = \'' + String.escapeSingleQuotes(userRecord.ContactId) + '\' ';

      if(!subOrdContactIds.isEmpty())
      {
        soqlQuery += ' OR External_Referring_Contact__c IN :subOrdContactIds ';
      }

      soqlQuery += 'order by CreatedDate desc ';

                  
    /*
    if(UGears.UUser.isPortalUser(userRecord))
    {
      //soqlQuery += 'ContactId = \'' + String.escapeSingleQuotes(userRecord.ContactId) + '\' ';
      //soqlQuery += 'CreatedById = \'' + String.escapeSingleQuotes(userRecord.ContactId) + '\' ';
      soqlQuery += 'External_Referring_Contact__c  = \'' + String.escapeSingleQuotes(userRecord.ContactId) + '\' ';
    }
    else
    {
      //soqlQuery += 'OwnerId = \'' + String.escapeSingleQuotes(userRecord.Id) + '\' ';
      //soqlQuery += 'CreatedById = \'' + String.escapeSingleQuotes(userRecord.Id) + '\' ';
      soqlQuery += 'External_Referring_Contact__c  = \'' + String.escapeSingleQuotes(userRecord.Id) + '\' ';
    }  
                       
                   
    soqlQuery += 'order by ' + 
              'CreatedDate desc ';
    */
              
      UGears.UDebug.printDebug('MyApplicationsController.loadRecords - SOQL QUERY: ' + soqlQuery);
                    
      this.Records = Database.query(soqlQuery);


    }
    
    public class CustomException extends Exception {} 

}