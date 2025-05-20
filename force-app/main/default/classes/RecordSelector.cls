public without sharing class RecordSelector {
    public static List<String> getFields(String objectType,String fieldSetName) {
        List<String> fieldSetFields = new List<String>();

        if(objectType==null || objectType == '' || fieldSetName==null || fieldSetName == '') {
            return fieldSetFields;
        }
        Schema.SObjectType objectTypeSchema = Schema.getGlobalDescribe().get(objectType);
        Schema.FieldSet fieldSet = objectTypeSchema.getDescribe().FieldSets.getMap().get(fieldSetName);
        for (Schema.FieldSetMember fieldSetMember : fieldSet.getFields()) {
            fieldSetFields.add(fieldSetMember.getFieldPath());
        }

        return fieldSetFields;
    }
    public static List<SObject> queryRecords(String objectType, Map<String, String> fieldMap, List<String> fieldSetFields) {
        
        String whereClause = '';
        // Build the WHERE clause conditions
        if(fieldMap!=null){
            List<String> whereClauseConditions = new List<String>();
            for (String fieldName : fieldMap.keySet()) {
                String fieldValue = fieldMap.get(fieldName);
                if(fieldValue!=null && fieldValue != '') {
                    whereClauseConditions.add(fieldName + ' Like \'%' + String.escapeSingleQuotes(fieldValue) + '%\'');
                }
            }
            if(whereClauseConditions.size() > 0) {
                whereClause = ' WHERE ' + String.join(whereClauseConditions, ' AND ');

            }
        }
        if(fieldSetFields==null || fieldSetFields.size() == 0) {
            fieldSetFields = new List<String>{'Id'};
        }
        // Build the query
        String query = 'SELECT ' + String.join(fieldSetFields, ', ') +
                       ' FROM ' + objectType +
                       whereClause +
                       ' WITH SECURITY_ENFORCED';

        return Database.query(query);
    }
}
