@IsTest
public class UserAccessControllerTest {
    @TestSetup
    static void setupTestData() {
        // Create a test user
        Profile profile = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1];
        User testUser = new User(
            ProfileId = profile.Id,
            Username = 'testuser' + System.currentTimeMillis() + '@example.com',
            Email = 'testuser@example.com',
            LastName = 'Test',
            FirstName = 'User',
            Alias = 'tuser',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            TimeZoneSidKey = 'America/Los_Angeles'
        );
        insert testUser;

        // Create test accounts
        Account account1 = new Account(Name = 'Test Account 1');
        Account account2 = new Account(Name = 'Test Account 2');
        Account account3 = new Account(Name = 'Test Account 3');
        insert new List<Account>{account1, account2, account3};

        // Share account1 with the test user
        AccountShare accountShare = new AccountShare();
        accountShare.AccountId = account1.Id;
        accountShare.UserOrGroupId = testUser.Id;
        accountShare.AccountAccessLevel = 'Read';
        accountShare.OpportunityAccessLevel = 'Read';
        insert accountShare;
    }

    @IsTest
    static void testGetRecordsWithAccess() {
        User testUser = [SELECT Id FROM User WHERE Username = 'sushil.kalsekar@gmail.com.nvm'];
        List<Account> accounts = [SELECT Id, Name FROM Account];

        System.Test.startTest();
        System.runAs(testUser) {
            List<UserAccessController.RecordWrapper> result = UserAccessController.getRecordsWithAccess(testUser.Id, accounts);
            System.assertEquals(3, result.size());
            for (UserAccessController.RecordWrapper wrapper : result) {
                System.assertEquals(false, wrapper.IsAccessible);
            }
        }
        System.Test.stopTest();
    }
}