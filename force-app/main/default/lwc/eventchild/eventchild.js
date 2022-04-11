import { LightningElement, track } from 'lwc';

export default class Eventchild extends LightningElement {
     childMsg;
    handleClick(event){    
        console.log('Clicked Child3');
        const passEventr = new CustomEvent('btnclick',{ bubbles: true , composed : true });
        this.dispatchEvent(passEventr);  
    }

    handleBtnClick (event)
    {
        this.childMsg = 'Event handled in Child template1';
    }
}