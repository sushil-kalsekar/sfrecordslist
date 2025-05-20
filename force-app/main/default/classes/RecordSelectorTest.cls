@IsTest
public class RecordSelectorTest {
    @TestSetup
    public static void setupTestData() {
        // Create a test account
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;

        // Create a test contact
        Contact testContact = new Contact(FirstName = 'John', LastName = 'Doe', AccountId = testAccount.Id);
        insert testContact;
    }

    @IsTest
    public static void testQueryRecords() {
        Account testAccount = [SELECT Id, Name FROM Account WHERE Name = 'Test Account'];
        Contact testContact = [SELECT Id, FirstName, LastName FROM Contact WHERE FirstName = 'John' AND LastName = 'Doe'];

        Map<String, String> nameFieldMap = new Map<String, String>{
            'Name' => testAccount.Name
        };

        Test.startTest();
        List<SObject> result = RecordSelector.queryRecords('Account', nameFieldMap, new List<String>{'Id', 'Name'});
        Test.stopTest();

        System.assertEquals(1, result.size());
        Account queriedAccount = (Account) result[0];
        System.assertEquals(testAccount.Id, queriedAccount.Id);
        System.assertEquals(testAccount.Name, queriedAccount.Name);
    }
}
