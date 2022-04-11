import { LightningElement, track, wire, api } from 'lwc';
import { createRecord } from 'lightning/uiRecordApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import ACCOUNT_OBJECT from '@salesforce/schema/Account';
import NAME_FIELD from '@salesforce/schema/Account.Name';
import createAccount from '@salesforce/apex/accountcreate.createAccount';
const DELAY = 300;

const columnsName = [
{
    label: 'Name',
    fieldName: 'Name'
},
{
    label: 'Email',
    fieldName: 'Email'
},
{
    label: 'Level',
    fieldName: 'Level__c'
},
{
    label: 'Secret Key',
    fieldName: 'Secret_Key__c'
},
{
    label: 'Number Of Business',
    fieldName: 'Number_of_Business__c'
},

{
    type: 'action', typeAttributes: {
    rowActions: [
        { label: 'Add', name: 'add' }
        ]
    }
} 
];

const selcolumnsName = [
    {
        label: 'Name',
        fieldName: 'Name'
    },
    {
        label: 'Email',
        fieldName: 'Email'
    },
    {
        label: 'Level',
        fieldName: 'Level__c'
    },
    {
        label: 'Secret Key',
        fieldName: 'Secret_Key__c'
    },
    {
        label: 'Number Of Business',
        fieldName: 'Number_of_Business__c'
    },
    {
        type: 'action', typeAttributes: {
        rowActions: [
            { label: 'Remove', name: 'remove' }
            ]
        }
    } 
    ];

export default class HelloWorld extends LightningElement {
    @track columns = columnsName;
    @track Selectedcolumns = selcolumnsName;
    @track record = {};
    @track oppName='';
    @track oppAmt='';
    @track contacts = [];
    @track selectedcontacts = [];
    

    /*@wire(createAccount, { accName: '$oppName' })
    accounts;*/

    handleopp(event){
        window.console.log(event.target.value); 
        window.console.log(event.detail.value); 
        this.oppName=  event.target.value; 
    }

    addContact(event) {
        const row = event.detail.row;
        this.record = row;
        //window.console.log('selected contact'+JSON.stringify(this.record)); 
        this.selectedcontacts.push(this.record);
        this.selectedcontacts = JSON.parse(JSON.stringify(this.selectedcontacts));
        window.console.log('selected contactList'+JSON.stringify(this.selectedcontacts)); 
        //this.bShowModal = true; // display modal window
    }

    removeContact(event){
        const row = event.detail.row;
        const rows = this.selectedcontacts;
        window.console.log('rows---'+JSON.stringify(event.detail));

        var filtered = rows.filter(function(value, index, arr){
            window.console.log('rows8---'+value.Id+'---'+row.Id);
            return(value.Id != row.Id) 
        });

        window.console.log('rows2---'+JSON.stringify(filtered));
        this.selectedcontacts = JSON.parse(JSON.stringify(filtered));
        
    }

    sendContact(event){
        const selectedEvent = new CustomEvent("progressvaluechange", {
            detail: this.selectedcontacts
          });

        this.dispatchEvent(selectedEvent);  
        //showmodel = true;
    }

    searchContact(event){
        window.console.log('test---'+this.oppName);
        createAccount({ accName: this.oppName })
            .then(result => {
                this.contacts = result;
                this.error = undefined;
                window.console.log('data---'+JSON.stringify(this.contacts));
            })
            .catch(error => {
                this.error = error;
                this.contacts = undefined;
            });
    
       /* window.clearTimeout(this.delayTimeout);
        const searchKey = this.oppName;
        this.delayTimeout = setTimeout(() =>{
            this.searchKey = searchKey;
        }, DELAY);*/
        /*const fields = {};
        fields[NAME_FIELD.fieldApiName] = this.oppName;
        const recordInput = { apiName: ACCOUNT_OBJECT.objectApiName, fields };
        createRecord(recordInput)
            .then(account => {
                //this.accountId = account.id;
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Success',
                        message: 'Account created',
                        variant: 'success',
                    }),
                );
            })
            .catch(error => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error creating record',
                        message: error.body.message,
                        variant: 'error',
                    }),
                );
            });*/

    }
}