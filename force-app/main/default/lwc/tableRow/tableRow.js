import { LightningElement, track, api } from 'lwc';

export default class StaffAugResourceTableRow extends LightningElement {
    @api field;
    @api record;
    @track selectedVal = '';
    @track jsonData={};
    
    renderedCallback() {
        this.selectedVal = this.record[this.field.name];
    }

    get isPICKLIST() {
        if(this.field.type == 'PICKLIST'){
            return true;
        }
    }

    get options() {
        if(this.field.type == 'PICKLIST'){
            
            var listOptions = this.field.picklistvalues.split(',');
            var returnoption =[];
            var i;
            for(i = 0; i < listOptions.length; i++){
                var returnoptionItm = [];
                returnoptionItm.label = listOptions[i];
                returnoptionItm.value = listOptions[i];
                returnoption.push(returnoptionItm);
            }
            return returnoption;
        }
    }


    get isSTRING() {
        if(this.field.type == 'STRING')
            return true;
    }
    get isNUMBER() {
        if(this.field.type == 'NUMBER')
            return true;
    }
    get isREFERENCE() {
        if(this.field.type == 'REFERENCE')
            return true;
    }

    handleChange(event){
        var columnName = '';
        window.console.log('@@@before '+JSON.stringify(this.record)+'---'+event.detail.slnp);
        this.jsonData["columnName"] = this.field.name;
        this.jsonData['Index'] = this.record.slnp;
        if(this.field.type == 'REFERENCE'){
            this.jsonData['Value'] = event.detail.Id;
        }else{
            this.jsonData['Value'] = event.detail.value;
        }
        window.console.log('@@@this.newVal '+JSON.stringify(this.jsonData));
        this.dispatchEvent(new CustomEvent('changeprodval', { detail: this.jsonData }));
    }
}