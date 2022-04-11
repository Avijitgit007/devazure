import { LightningElement } from 'lwc';

export default class QuipRestAPI extends LightningElement {
    receivedMessage;
    hasRendered = false;
    
    getTheJoke() {
        const calloutURI = 'https://platform.quip.com/1/oauth/login?client_id=FdTAcAEC45v-dd2d86f5a5eb48eca26ba8ff046c30f7&redirect_uri=https://www.google.com';
        // requires whitelisting of calloutURI in CSP Trusted Sites
        console.log('Test--23------');
        fetch(calloutURI, {
            method: "GET"
        }).then(
            (response) => {
                if (response.ok) {
                    console.log('Test----2-----');
                    return response.json();
                } 
            }
        ).then(responseJSON => {
            this.receivedMessage = responseJSON.joke;
            console.log(this.receivedMessage);
        });
    }

    renderedCallback() {
        if(this.hasRendered == false) {
            this.getTheJoke();
            this.hasRendered = true;
        }
    }

}