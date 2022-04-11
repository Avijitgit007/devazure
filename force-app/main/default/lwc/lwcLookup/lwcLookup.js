import { LightningElement, track, wire, api } from "lwc";  
import { NavigationMixin } from 'lightning/navigation';

import findRecords from "@salesforce/apex/LwcLookupController.findRecords";  
import findLookUpRecords from "@salesforce/apex/LwcLookupController.findLookUpRecords";  

 export default class LwcLookup extends NavigationMixin(LightningElement) {  
  @track recordsList;  
  @track searchKey = "";  
  @api selectedValue;  
  @api selectedRecordId;  
  @api placeHolder = "Search...";
  @api newButtonName = "";
  @api objectApiName;  
  @api iconName;  
  @api lookupLabel;  
  @api recordid;
  @api fieldName; 
  @api additionalfieldName; 
  @api additionalFilterCriteria;
  @track message;  
  @track fetchedRecords; 
  @api recordId;
  @track isButtonEnable=false;
  @track isLoading = false;
  fieldTempStore; 
  additionalTempfieldName;
    
  onLeave(event) {  
   setTimeout(() => {  
    this.searchKey = "";  
    this.fetchedRecords = null;  
    this.recordsList = null;  
   }, 300);  
  }  
    
  connectedCallback(){
    
  } 

  onRecordSelection(event) {  
   this.selectedRecordId = event.target.dataset.key;  
   this.selectedValue = event.target.dataset.name;  
   this.searchKey = "";  
   this.onSeletedRecordUpdate();  
  }  
   
  handleKeyChange(event) {  
    if(this.newButtonName!=''){
        this.isButtonEnable = true;
    }   
   const searchKey = event.target.value;  
   this.searchKey = searchKey;  
   this.fieldTempStore = this.fieldName;
   this.additionalTempfieldName = this.additionalfieldName;
   //this.getLookupResult();  
   this.getLookupResult();
  }  
   
  removeRecordOnLookup(event) {  
   this.searchKey = "";  
   this.selectedValue = null;  
   this.selectedRecordId = null;  
   this.fetchedRecords = null;  
   this.recordsList = null;  
   //this.getLookupResult();
   this.onSeletedRecordUpdate();  
 }  
   



 /*getLookupResult() {  
    findLookUpRecords({ searchKey: this.searchKey, objectName : this.objectApiName,serchField : this.fieldName ,recordId : this.recordid })  
    .then((result) => {  
     if (result.length===0) {  
       this.recordsList = [];  
       this.message = "No Records Found";  
      } else {  
      //    console.log('----result----'+JSON.stringify(result));          
       this.recordsList = result;  
       this.message = "";  
      }  
      this.error = undefined;  
    })  
    .catch((error) => {  
     this.error = error;  
     this.recordsList = undefined;  
    });  
  }  */
   
   getLookupResult(){  
         findLookUpRecords({ searchKey: this.searchKey, objectName : this.objectApiName,serchField : this.fieldName ,addFieldname : this.additionalfieldName ,recordId : this.recordid,addfiltercriteria : this.additionalFilterCriteria})  
        .then((result) => {  
            this.isLoading = true;
            if (result.length===0) {  
                this.fetchedRecords = [];  
                this.message = "No Records Found";  
                this.isLoading = false;
            } else {  
                console.log('----resulttest----'+JSON.stringify(result)+'----'+this.fieldName);
                setTimeout(() => {  
                    this.isLoading = false;                    
                }, 500); 
                if(this.fieldName.indexOf('.') !== -1){
                    console.log('----In----');   
                    this.fieldTempStore = this.fieldName.replace(/\./g,' ');  
                }
                if(this.additionalfieldName.indexOf('.') !== -1){
                    this.additionalTempfieldName = this.additionalfieldName.replace(/\./g,' '); 
                }     
                    //this.recordid = 'ContactId';
                //    this.fetchedRecords = this.formatcurrentData(result);
                    //this.fetchedRecords = JSON.parse(JSON.stringify(this.fetchedRecords).replace(res, "fieldName").replace(this.recordid, "recordId"));
                //}else{
                this.fetchedRecords = this.formatcurrentData(result);
                console.log('----321---'+this.isLoading);
                    //this.fetchedRecords = JSON.parse(JSON.stringify(result).replace(this.fieldName, "fieldName").replace(this.recordid, "recordId"));    
                //}
                //console.log('----resulttestdone----'+JSON.stringify(this.fetchedRecords));
                
                
                this.message = "";  
            }  
                this.error = undefined;  
        })  
        .catch((error) => {  
            this.error = error;  
            this.fetchedRecords = undefined;  
            this.isLoading = false;
        });  
    } 


  /*getLookupResulttest() {  
    findRecordstest({ searchKey: this.searchKey, objectName : this.objectApiName,serchField : this.fieldName ,recordId : this.recordid })  
     .then((result) => {  
        
        this.fieldName = "Name";
        this.recordid = "Id";
        console.log('----resulttest----'+JSON.stringify(result)+'----'+this.fieldName);
        if(this.fieldName.indexOf('.') !== -1){
            console.log('----In----');   
            var res = this.fieldName.replace(/\./g,' ');     
            this.recordid = 'ContactId';
            this.fetchedRecords = this.formatcurrentData(result);
            this.fetchedRecords = JSON.parse(JSON.stringify(this.fetchedRecords).replace(res, "fieldName").replace(this.recordid, "recordId"));
        }else{
            this.fetchedRecords = JSON.parse(JSON.stringify(result).replace(this.fieldName, "fieldName").replace(this.recordid, "recordId"));    
        }
        //this.fetchedRecords = this.formatcurrentData(result);
        console.log('----resulttestdone----'+JSON.stringify(this.fetchedRecords));
     })  
     .catch((error) => {  
      this.error = error;  
      this.recordsList = undefined;  
     });  
   }  */

   ontsearchClick(){
       console.log('---');
   }

   navigateToNewRecordPage() {
        console.log('--1-'+this.objectApiName);
        this[NavigationMixin.Navigate]({
            type: 'standard__objectPage',
            attributes: {
                //recordId: this.org.Id,
                objectApiName: this.objectApiName,
                actionName: 'new'
            }
        });
    }

   formatcurrentData(dataForm){
   
    let  dataRecords = JSON.parse(JSON.stringify(dataForm));
    for(var index in dataRecords)
    {
        dataRecords[index].recordLink = '/'+dataRecords[index].Id;
        var currentRec = dataRecords[index];
        //console.log('---1--'+currentRec);
        for(var field in currentRec)
        {
            console.log('---21--'+field);
            if(field == this.recordid){
                currentRec['recordId'] =  currentRec[field];  
            }
            if(field == this.fieldName){
                currentRec['recordName'] =  currentRec[field];  
            }
            if(field == this.additionalfieldName){
                currentRec['recordName'] = currentRec['recordName']+'('+currentRec[field]+')';   
            }    
            if(typeof currentRec[field] == 'object')
            {
                for(var parentField in currentRec[field])
                {
                     var tempField = field+' '+parentField ;
                    if(tempField == this.fieldTempStore){
                        currentRec['recordName'] =  currentRec[field][parentField];  
                    }
                    if(tempField == this.additionalTempfieldName){
                        currentRec['recordName'] =currentRec['recordName']+'('+currentRec[field][parentField]+')'; 
                    }                                     
                }
            }
        }
    }  
    return dataRecords;
}


  onSeletedRecordUpdate(){  
   const passEventr = new CustomEvent('recordselection', {  
     detail: { selectedRecordId: this.selectedRecordId, selectedValue: this.selectedValue }  
    });  
    this.dispatchEvent(passEventr);  
  }  
 }