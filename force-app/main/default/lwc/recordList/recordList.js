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
        this.objectName = this.currentPageReference.state.objectname;
        this.nameValue = this.currentPageReference.state.name;
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

    fetchRecords()
    {
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
                });
            })
            .catch(error => {
                console.error('Error fetching records:', error);
            });
    }
    extractObjectEntries(record){
        let fieldValues = [];
        for (let key of this.fields) {
            fieldValues.push({ fieldName: key, fieldValue: record.Record[key] });
        }
        return fieldValues;
    }
}
