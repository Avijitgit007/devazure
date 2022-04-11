import { LightningElement, track } from 'lwc';
import getObjectRecordTypeName from '@salesforce/apex/recordTypecls.getRecordTypeNameById';


export default class Recordtypeselection extends LightningElement {

    recordTypedevelopername = '';
    isNew = false;
    isExisting = false;
    isFramework = false;

    connectedCallback() {
        var recordtypeId = ((new URL(window.location.href)).searchParams.get("recordTypeId"));
        console.log( 'recortype--- ' +recordtypeId);
        getObjectRecordTypeName({ objectName: 'Account', strRecordTypeId: recordtypeId})
        .then(result=>{            //
            if (result) {                       
                console.log('recordTypename---'+JSON.stringify(result));
                recordTypedevelopername = JSON.stringify(result);
                if(recordTypedevelopername=='New_Business_Opportunity'){
                    isNew = true;        
                }
                else if(recordTypedevelopername=='Existing_Business_Opportunity'){
                    isExisting = true;
                }
                else if(recordTypedevelopername=='Framework_Deal_Opportunity'){
                    isFramework = true;
                }
            }    
        })
        .catch(error => {
            console.log(error);
        });  
    }  

}