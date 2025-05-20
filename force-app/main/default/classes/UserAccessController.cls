public without sharing class UserAccessController {
    public class RecordWrapper {
        @AuraEnabled
        public SObject Record { get; set; }
        @AuraEnabled
        public Boolean IsAccessible { get; set; }
    }

    public static List<RecordWrapper> getRecordsWithAccess(Id userId, List<SObject> records) {
        List<RecordWrapper> recordWrappers = new List<RecordWrapper>();
        List<Id> recordIds = new List<Id>();
        for (SObject record : records) {
            recordIds.add(record.Id);
        }
        Map<Id,Boolean> accessMap = getMapOfRecordAccess(userId, recordIds);
        for (SObject record : records) {
            RecordWrapper wrapper = new RecordWrapper();
            
            wrapper.IsAccessible = accessMap.get(record.Id);
            if(wrapper.IsAccessible){
                wrapper.Record = record;
            }
            else{
                wrapper.Record = record.getSObjectType().newSObject();
                wrapper.Record.put('Id', record.Id);
                wrapper.Record.put('Name', record.get('Name'));
            }
            recordWrappers.add(wrapper);
        }
        return recordWrappers;
    }

    private static Map<Id,Boolean> getMapOfRecordAccess(Id userId, List<Id> recordIds) {
        Map<Id,Boolean> accessMap = new Map<Id,Boolean>();
        for(UserRecordAccess accessRecord : [
            SELECT RecordId, HasReadAccess 
            FROM UserRecordAccess 
            WHERE UserId = :userId 
            AND RecordId IN :recordIds]){
                accessMap.put(accessRecord.RecordId, accessRecord.HasReadAccess);
        }
        return accessMap;
    }
}
