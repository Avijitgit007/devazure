import { LightningElement, track, wire} from 'lwc';
import getAllRecordType from '@salesforce/apex/accountcreate.recordtypedetails';


export default class RecordTypePage extends LightningElement {
    @track  options;
    @track rtNamevalue;
    @track errorMsg;
    @track recordtypeMap;

    @wire(getAllRecordType)
    saveRt({error,data})
    {
        if(data)
        {
            this.options = [];
            window.console.log('data'+JSON.stringify(data));
            var RTMap = JSON.parse(data);
            for(var key in RTMap)
            {
                this.options.push({label:RTMap[key], value:key});
            }        
            this.recordtypeMap = RTMap;    
        }
        else if(error)
        {
            window.console.log(error);
            this.errorMsg = error;           
        }
    }

    handleChange(event) {
        this.rtNamevalue = event.detail.value;

        window.console.log(JSON.stringify(event.detail));
    }

    recordselection(event)
    {
        event.preventDefault();
        window.console.log('value'+this.rtNamevalue);
        this.dispatchEvent(new CustomEvent('recordtypeselection', {detail:{selected:{value:this.rtNamevalue,label:this.recordtypeMap[this.rtNamevalue]}}}));
        window.console.log('event fired');
    }

    cancel(event)
    {
        event.preventDefault();
        const closeModal = new CustomEvent('closemodal');
        this.dispatchEvent(closeModal);
        //this.dispatchEvent(new CustomEvent('closemodal'));
    }
}