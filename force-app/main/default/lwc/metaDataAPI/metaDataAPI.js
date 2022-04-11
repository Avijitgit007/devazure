import { LightningElement, track, api } from 'lwc';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';
import csvFileRead from '@salesforce/apex/MetadataAPIcls.csvFileRead';

const columnsMetaData = [
    { label: 'Component Name', fieldName: 'ruleName' }, 
    { label: 'Object Name', fieldName: 'objectName' },
    { label: 'Component Type', fieldName: 'componentType'}, 
    { label: 'Status', fieldName: 'status'}, 
];

export default class MetaDataAPI extends LightningElement {

    //@api recordId;
    @track error;
    @track columnsMetaData = columnsMetaData;
    @track data;

    // accepted parameters
    get acceptedCSVFormats() {
        return ['.csv'];
    }
    
    uploadFileHandler(event) {
        // Get the list of records from the uploaded files
        const uploadedFiles = event.detail.files;

        // calling apex class csvFileread method
        csvFileRead({contentDocumentId : uploadedFiles[0].documentId})
        .then(result => {
            window.console.log('result ===> '+result);
            this.data = result;
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Success!!',
                    message: 'File Uploaded Successfully!!!',
                    variant: 'Success',
                }),
            );
        })
        .catch(error => {
            this.error = error;
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error!!',
                    message: JSON.stringify(error),
                    variant: 'error',
                }),
            );     
        })

    }
}