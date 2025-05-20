import { LightningElement, track ,wire } from 'lwc';
import { CurrentPageReference } from 'lightning/navigation';
import getRecordsByName from '@salesforce/apex/RecordController.getRecordsByName';

export default class RecordList extends LightningElement {
    @track 
    records;
    fields;
    nameValue;
    objectName;
    errorMessage;
    detailRecordDetails;

   get displayFields(){
    return ['Access','Name'];
   }

    get objectOptions() {
        return [
            { label: 'Account', value: 'Account' },
            { label: 'Contact', value: 'Contact' },
            { label: 'Opportunity', value: 'Opportunity' }
        ];
    }

    @wire(CurrentPageReference)
    currentPageReference;

    connectedCallback() {
        this.objectName = this.currentPageReference.state.c__objectname;
        this.nameValue = this.currentPageReference.state.c__name;
        this.fetchRecords();
    }
 
    handleNameChange(event) {
        this.errorMessage = 'Input data changed. Click on Submit button to refresh list.';
        this.nameValue = event.detail.value;
    }
    handleObjectChange(event) {
        this.errorMessage = 'Input data changed. Click on Submit button to refresh list.';
        this.objectName = event.detail.value;
    }
    seeDetails(event){
        let targetRecord = this.records.find(record => record.Record.Id === event.target.dataset.id)
        if(targetRecord.IsAccessible){
            this.detailRecordDetails = [...targetRecord.fieldValues];
            this.detailRecordDetails.splice(0,1);
        }
    }
    fetchRecords()
    {
        this.detailRecordDetails = null;
        this.errorMessage = '';
        console.log('Fetching records for:', this.objectName, this.nameValue);
        getRecordsByName({ objectName: this.objectName, name: this.nameValue })
            .then(data => {
                console.log('Data fetched:', data);
                if (data.errorMessage) {
                    this.errorMessage = data.errorMessage;
                    return;
                }
                this.records = data.records;
                this.fields = data.fieldNames;
                this.records.forEach(record => {
                    record.fieldValues = this.extractObjectEntries(record);
                    record.isNotAccessible = !record.IsAccessible;
                });
            })
            .catch(error => {
                console.error('Error fetching records:', error);
            });
    }
    extractObjectEntries(record){
        let fieldValues = [{fieldName:'Access', isNotAccessible: !record.IsAccessible,isAccessCell: true }];
        for (let key of this.fields) {
            if(key!='Id'){
                fieldValues.push({ fieldName: key, fieldValue: record.Record[key] });
            }
        }
        return fieldValues;
    }
}
