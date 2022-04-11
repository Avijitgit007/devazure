import { LightningElement, track, api} from 'lwc';

export default class StaffAugTable extends LightningElement {
    @api fieldtable;
    @api recordtable;

    handleChange(event){
        window.console.log('table data-- '+JSON.stringify(event.detail));
        this.dispatchEvent(new CustomEvent('changedfinal', { detail: event.detail }));
    }

    handleDel(event){
        console.log('button click-- '+event.currentTarget.dataset.key);
        this.dispatchEvent(new CustomEvent('removedata', { detail: event.currentTarget.dataset.key }));
    }
}