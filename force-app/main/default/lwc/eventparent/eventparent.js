import { LightningElement } from 'lwc';

export default class Eventparent extends LightningElement {
    parentMsg;
    handleparentClick(event)
    {
        console.log('parent');
        this.parentMsg = 'Event handled in Parent template2';
    }
}