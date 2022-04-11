import { LightningElement , api} from 'lwc';
import { subscribe, unsubscribe, onError, setDebugFlag, isEmpEnabled } from 'lightning/empApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import Id from '@salesforce/user/Id';

export default class PlatformEvents extends LightningElement {
    @api recordId;
    channelName = '/event/Flying_Fridge_Event__e';
    isSubscribeDisabled = false;
    isUnsubscribeDisabled = !this.isSubscribeDisabled;

    subscription = {};

    // Tracks changes to channelName text field
    handleChannelName(event) {
        this.channelName = event.target.value;
    }

    connectedCallback() {
        this.handleSubscribe();
    }

    // Handles subscribe button click
    handleSubscribe() {
        // Callback invoked whenever a new event message is received
        const messageCallback = (response) => {
            console.log('New message received : ', JSON.stringify(response));
            this.payload = JSON.stringify(response);
            console.log('this.payload--6-: ' + JSON.stringify(this.payload));
            var obj = JSON.parse(this.payload);
            var serNo = obj["data"]["payload"]["serial_no__c"];
            var loggedin = obj["data"]["payload"]["User__c"];
            console.log('Single value---'+serNo);
            //printValues(JSON.parse(this.payload));
            if(this.recordId==serNo && Id!= loggedin){
                this.showSuccessToast();
            }    
            // Response contains the payload of the new message received
        };

        function printValues(obj) {
            for(var k in obj) {
                if(obj[k] instanceof Object) {
                    printValues(obj[k]);
                } else {
                    console.log(obj[k] + "<br>");
                };
            }
        };

        // Invoke subscribe method of empApi. Pass reference to messageCallback
        subscribe(this.channelName, -1, messageCallback).then(response => {
            // Response contains the subscription information on successful subscribe call
            console.log('Successfully subscribed to : ', JSON.stringify(response.channel));
            this.subscription = response;
            this.toggleSubscribeButton(true);
        });
    }

    showSuccessToast() {
        const evt = new ShowToastEvent({
            title: 'Warning',
                message: 'Please refresh the Page, Someone Already edited in-between',
                variant: 'warning',
                mode: 'pester'
        });
        this.dispatchEvent(evt);
    }
    // Handles unsubscribe button click
    handleUnsubscribe() {
        this.toggleSubscribeButton(false);

        // Invoke unsubscribe method of empApi
        unsubscribe(this.subscription, response => {
            console.log('unsubscribe() response: ', JSON.stringify(response));
            // Response is true for successful unsubscribe
        });
    }

    toggleSubscribeButton(enableSubscribe) {
        this.isSubscribeDisabled = enableSubscribe;
        this.isUnsubscribeDisabled = !enableSubscribe;
    }

    registerErrorListener() {
        // Invoke onError empApi method
        onError(error => {
            console.log('Received error from server: ', JSON.stringify(error));
            // Error contains the server-side error
        });
    }
}