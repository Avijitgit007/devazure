import { LightningElement, track } from 'lwc';

export default class Allinone extends LightningElement {
    @track recordPage = true;
    @track contactPage = false;
   
    handlerecordtypeselection(event)
    {
        window.console.log('selected'+JSON.stringify(event.detail.selected));
        if(event.detail.selected.label === 'Personal Account'){
            this.recordPage = false;
            this.contactPage = true;
        }
        
    }
    handleclosemodal(event)
    {
        window.console.log('closed');
        const closeModal = new CustomEvent('closemodal');
        this.dispatchEvent(closeModal);
    }

}