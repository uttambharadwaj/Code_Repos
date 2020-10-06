@isTest
public class Calabrio_DataImportProcessorTest {
    
        @testSetup static void methodName() {
            UtilityTestLoader.setAutomation(false);

                      List<User> testUsers = createUsers(1);

              Calabrio_Integration_Setting__c setting = new Calabrio_Integration_Setting__c(Name = 'Calabrio_TestEnvironment',
                                                                                            API_Endpoint__c = 'https://calabriocloud.com/api/rest/scheduling/agentStateHistorical/polling',
                                                                                            API_AuthenticationEndpoint__c ='https://calabriocloud.com/api/rest/authorize',
                                                                                            API_AuthenticationUserId__c = 'CalabrioAPI.User@xwex.com',
                                                                                            API_AuthenticationPassword__c = 'WEX12345!',
                                                                                            Chat_Queue_ID__c = '90011',
                                                                                            Email_Queue_ID__c = '90013',
                                                                                            SMS_Queue_ID__c = '0');
              insert setting;
            
              DateTime scheduledTime = DateTime.now();
              DateTime chatOfferedTime = scheduledTime.addMinutes(-25);
              DateTime chatStartedTime = chatOfferedTime.addMinutes(1);
              DateTime chatEndedTime = chatOfferedTime.addMinutes(5);

              LiveChatVisitor visitor = new LiveChatVisitor();
              insert visitor;
              LiveChatTranscript chat = new LiveChatTranscript(LiveChatVisitorId = visitor.Id,
                                                               OwnerId = testUsers[0].Id,
                                                               RequestTime = chatOfferedTime,
                                                               StartTime = chatStartedTime,
                                                               EndTime = chatEndedTime);
              insert chat;
            
              Case testCase = createCase(testUsers[0].Id);
            
        }

    
    
        private static testMethod void testRunImport() {
              DateTime scheduledTime = DateTime.now();
              scheduledTime = scheduledTime.addMinutes(-scheduledTime.Minute() + 15); // Set minute to be 15 after the hour so it gets the previous interval before that.
              List<Calabrio_CaseHistoryWrapper> caseHistories = new List<Calabrio_CaseHistoryWrapper>();
              User testUser = [select Id from User where Username = 'calTestUser0@wex.com'];
              Case testCase = [select Id, Origin from Case where OwnerId = :testUser.Id LIMIT 1];
              caseHistories.add(new Calabrio_CaseHistoryWrapper('Status','closed','foo', testUser.Id, testCase.Origin, testCase.Id,'Other'));
              
              Test.startTest();
              Calabrio_ScheduledDataImport testImport = new Calabrio_ScheduledDataImport(scheduledTime, caseHistories);
              testImport.Execute(null);
              Test.stopTest();
        }
    
    private static testMethod void testScheduledApiCall() {
       Test.startTest();
       Calabrio_ScheduledApiCall testApiCall = new Calabrio_ScheduledApiCall(4, 2, 'testendpoint', 'agentProductivityFileName', 
                                       Blob.valueOf('test1'), 'serviceHistoricalFileName', 
                                       Blob.valueOf('test2'), 'apiAuthenticationEndpoint',
                                       'apiUserId', 'apiPassword', DateTime.now(), DateTime.now(), 'Calabrio_ScheduledApiCall');
       Calabrio_ScheduledApiCall.scheduleApiCallDelayed(4, 2, 'testendpoint', 'agentProductivityFileName', 
                                       Blob.valueOf('test1'), 'serviceHistoricalFileName', 
                                       Blob.valueOf('test2'), 'apiAuthenticationEndpoint',
                                       'apiUserId', 'apiPassword', DateTime.now(), DateTime.now());
       testApiCall.Execute(null);
       Test.stopTest();
    }
    
    private static testMethod void testBatchRunImport() {
            DateTime startTime = DateTime.newInstance(2018,3,19,14,30,00);
            DateTime endTime = DateTime.newInstance(2018,3,19,15,00,00);
            Test.startTest();
            Calabrio_DataImportBatch importBatch = new Calabrio_DataImportBatch(startTime, endTime);
            Id batchId = Database.executeBatch(importBatch, 2);
            Test.stopTest();
    }
    
    private static Case createCase(Id ownerId){
        // Case needs a contactId or a CaseTrigger will fail.
        //Contact contact = new Contact();
        //insert contact;
        
        Case c = new Case(OwnerId = ownerId, Origin = 'Email');
        insert c;
        return c;
    }
    
    private static List<User> createUsers(Integer num){
        List<User> users = new List<User>();
        for(Integer i=0; i<num; i++){
              //Integer random = Math.mod(Math.round(Math.random() * 1000), 100);
              string userName = 'calTestUser' + i + '@wex.com';
              string lastName = 'Last' + num;
              User newUser = new User(Username = userName,
                                     LastName = lastName,
                                     Email = userName,
                                     Alias = 'user' + num,
                                     CommunityNickname = 'First.' + LastName,
                                     TimeZoneSidKey = 'America/Los_Angeles',
                                     LocaleSidKey = 'en_US',
                                     EmailEncodingKey = 'ISO-8859-1',
                                     ProfileId = [SELECT Id FROM Profile WHERE Name = 'Service Operations Agent'].Id,
                                     LanguageLocaleKey = 'en_US',
                                     ACD_Id__c = 'calTestUser' + i); 
              users.add(newUser);
        }
        insert users;
        return users;
    }
    
}