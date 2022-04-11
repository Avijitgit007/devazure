import { LightningElement, track } from 'lwc';

const columnsName = [
    {
        label: 'Name',
        fieldName: 'Name'
    },
    {
        label: 'Email',
        fieldName: 'Email'
    }   
    ];

export default class ParentRecord extends LightningElement {
    @track showmodel = false;
    @track passedcontacts = [];
    @track columns = columnsName;
    @track mergedontacts = [];
    @track contactTableFields = [];

    //@track get = [];

    openmodel(){
        window.console.log('--clicked--');
        
        this.showmodel = true;
    }

    closemodel(){
        this.showmodel  = false;
    }

    handleChange(){
        //this.showmodel  = false;
        window.console.log('----Test--');
    }

    catchContact(event){
        window.console.log('----Parent--'+JSON.stringify(event.detail)); 
        this.passedcontacts = JSON.parse(JSON.stringify(event.detail));
        if (event.detail) {
            //mapData = [];

            this.contactTableFields = [                
                { label: 'Name', required: 'true', type: 'STRING', name: 'Name' },
                { label: 'Email', required: 'true', type: 'STRING', name: 'Email' },
                { label: 'Level', required: 'true', type: 'PICKLIST', name: 'Level__c', picklistvalues: 'Primary,Secondary,Tertiary' },
                { label: 'Secret Key', required: 'true', type: 'STRING', name: 'Secret_Key__c' },                
                { label: 'No. of Business', required: 'true', type: 'NUMBER', name: 'Number_of_Business__c' }
            ];

            var varconts = event.detail;
            var serial = 1;
            for(var key in varconts){
                //var singlerow = {"slnp":"" ,"Id":"","Name":"","AccountId":""};    

                var singlerow = {"Name":"","Email":"","Level__c":"","Secret_Key__c":"","Number_of_Business__c":"","slnp":""};
                                
                singlerow.Name = varconts[key].Name;
                //singlerow.AccountId = varconts[key].AccountId;
                singlerow.Email = varconts[key].Email__c;
                singlerow.Level__c = varconts[key].Level__c;
                singlerow.Secret_Key__c = varconts[key].Secret_Key__c;
                singlerow.Number_of_Business__c = varconts[key].Number_of_Business__c;
                singlerow.slnp = serial;

                this.mergedontacts.push(singlerow);
                serial++;

                window.console.log('----mergedontacts--'+JSON.stringify(this.mergedontacts)+'--'+serial); 
            }
        }    

        this.showmodel  = false;
    }

    afterchangeinchildcomponent(event){
        window.console.log('tested----'+JSON.stringify(event.detail));   
    }

}