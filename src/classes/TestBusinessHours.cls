@isTest
public class TestBusinessHours
{
//  @testSetup
//    static void setup(){
//        UtilityTestLoader.setAutomation(false);
//    }
//
//     @isTest static void positiveTests()
//  {
//    GlobalSettings__c gs = new GlobalSettings__c();
//    gs.Name = 'test';
//    gs.Virtual_Card_Queue_ID__c = UserInfo.getUserId();
//    insert gs;
//
//    //system.debug('** in test class: ' + gs.Virtual_Card_Queue_ID__c);
//
//    List<Account> a = UTestData.getAccounts(1);
//    insert a;
//
//    Id profileId = [Select Id from Profile Where Name = 'System Administrator' LIMIT 1].Id;
//    User u = UTestData.getUserRecord(profileId);
//    insert u;
//
//    AccountTeamMember atm = new AccountTeamMember();
//    atm.userId = u.Id;
//    atm.AccountId = a[0].Id;
//    atm.TeamMemberRole = 'Account Manager';
//    insert atm;
//
//
//    test.starttest();
//    List<Case> cases = UTestData.getCases(a);
//    insert cases;
//    test.stoptest();
//
//    system.assertEquals([Select OwnerId from Case Where Id = :cases[0].Id].OwnerId, u.Id);
//
//  }
//
//  public static testMethod void businessHoursTestMeth()
//  {
//       //cretae Account...
//           Account acc = new Account();
//           acc.Type = 'GearsCRM Test';
//           acc.Name = 'TestAcc';
//           insert acc;
//
//       //Create Contact..
//            Contact con = new Contact();
//            con.LastName= 'TestCon';
//            con.AccountId = acc.Id;
//            insert con;
//
//       //insert product...
//           Product2 pro = new Product2();
//           pro.Name = 'testproduct';
//           insert Pro;
//
//           BusinessHours bhsDefault=[select id from BusinessHours where IsDefault=true limit 1];
//           BusinessHours bhs=[select id from BusinessHours where IsDefault=false limit 1];
//
//          //Record Type ID
//            recordType rt = new recordType();
//            rt = [SELECT Id,name FROM RecordType WHERE SObjectType = 'Case' and name = 'Virtual Payments'
//                  limit 1];
//
//            Case newCase = new Case();
//            newCase.Status = 'New';
//            newCase.AccountId = acc.Id;
//            newCase.ContactId = con.Id;
//            newCase.BusinessHours = bhsDefault;
//            newCase.Origin = 'Email';
//            newCase.RecordTypeID = rt.id;
//            insert newCase;
//
//            system.debug('businessHours ' + newCase.businessHours);
//            system.debug('SLA response Due ' + newCase.SLA_Response_Due__c);
//  }
}