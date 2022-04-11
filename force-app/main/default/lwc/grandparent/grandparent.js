import { LightningElement } from 'lwc';

export default class Grandparent extends LightningElement {

    handleparentClick(event)
    {
        console.log('grant parent2');
        this.parentMsg = 'Event handled in Parent template2';
    }
}