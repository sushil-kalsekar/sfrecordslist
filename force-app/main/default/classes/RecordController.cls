public with sharing class RecordController {
    @AuraEnabled
    public static RecordWrapper getRecordsByName(String objectName, String name) {
        RecordWrapper result = new RecordWrapper();
        if(objectName==null || objectName == '') { 
            result.errorMessage = 'No Object Selected.';     
            return result;
        }
        String fieldSetName = 'BasicFields';
                                                                               
        try{
            result.fieldNames = RecordSelector.getFields(objectName, fieldSetName); 
            List<SObject> records = RecordSelector.queryRecords(objectName, 
                                        new Map<String,String>{'Name'=>name}, 
                                        result.fieldNames);
            result.records = UserAccessController.getRecordsWithAccess(UserInfo.getUserId(), records);
        }
        catch(Exception exceptionInstance){
            //Going with a generic exception handling for now
            System.debug('Error occurred: ' + exceptionInstance.getMessage());
            result.errorMessage = 'Error occurred: ' + exceptionInstance.getMessage();
        }
        return result;
    }
    public class RecordWrapper {
        @AuraEnabled
        public List<UserAccessController.RecordWrapper> records { get; set; }
        @AuraEnabled
        public List<String> fieldNames { get; set; }
        @AuraEnabled
        public String errorMessage { get; set; }
    }
}
