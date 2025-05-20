@IsTest
public class RecordControllerTest {
    @TestSetup
    static void setup() {
        // Create test data
        Account account1 = new Account(Name = 'Test Account 1');
        Account account2 = new Account(Name = 'Test Account 2');
        insert new List<Account>{account1, account2};

        Contact contact1 = new Contact(FirstName = 'John', LastName = 'Doe', AccountId = account1.Id);
        Contact contact2 = new Contact(FirstName = 'Jane', LastName = 'Doe', AccountId = account2.Id);
        insert new List<Contact>{contact1, contact2};
    }

    @IsTest
    static void testGetRecords() {
        // Query test data
        List<Account> accounts = [SELECT Id FROM Account];
        List<Contact> contacts = [SELECT Id FROM Contact];

        // Prepare input parameters
        String objectType = 'Account';
        String nameFieldValue = 'Test Account 1';

        // Call the method being tested
        Test.startTest(); 
        RecordController.RecordWrapper recordWrapperObj = RecordController.getRecordsByName(objectType, nameFieldValue);
        Test.stopTest();

        // Assertions
        System.assertEquals(2, recordWrapperObj.records.size(), 'Expected two record wrappers');

        for (UserAccessController.RecordWrapper wrapper : recordWrapperObj.records) {
            System.assertNotEquals(null, wrapper.Record, 'Record should not be null');
            System.assertNotEquals(null, wrapper.IsAccessible, 'Accessible should not be null');
        }
    }
}
