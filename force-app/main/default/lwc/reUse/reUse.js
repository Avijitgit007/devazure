/*
Name : ReUse
Developer Name : Avijit Das
*/

import { LightningElement, track, wire, api } from 'lwc';
import getObjectRecords from '@salesforce/apex/ReUsecls.getObjectRecords';
import getFieldTypes from '@salesforce/apex/ReUsecls.getFieldTypes';
import { updateRecord } from 'lightning/uiRecordApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { formatcurrentData, columnsortData, formatFieldData} from './reUseHelper';



export default class ReUse extends LightningElement {
    @api related = false;
    @api editable = false;
    @api relatedField="";
    @api recordId;
    @api objName="";
    @api fldShn = "";
    @api whcon="";
    @api title="";
    @api icon="";
    @api rowLimit =10;
    @api rowOffSet=0;
    @api sortBy;
    @api sortDirection;
    @api height = "250";

    _wiredResult;

    maxRows=2000;
    tableElement;
    refreshTrack; 
 //default Id and Name will be assigned if nothing has been given.
    @track columns = [
        { label: 'Id', fieldName: 'Id' },
        { label: 'Name', fieldName: 'Name' } 
    ];
 
 //Passing the default columns
    @track selected = ['Id', 'Name'];
    @track fetchedRecords = [];   
    @track draftValues = [];
    @track infinateloading = true;   

    @track finalTitle = "";
    @track objectprTitle = "";
    @api pageHeight = 'Normal';

    connectedCallback() {
        console.log('connectedCallback------');  
        this.refreshTrack = 'intialLoad';
        getObjectRecords({ selectedFields: this.fldShn, obj: this.objName, whcon: this.whcon, relatedField: this.relatedField, related: this.related, recordId: this.recordId, limitSize: this.rowLimit , offset : this.rowOffSet,countAll : 'All'})
        .then(result=>{
            //
            //this._wiredResult = result;
            if (result) {                       
                //console.log('result------'+formatcurrentData('test'));
                this.fetchedRecords = formatcurrentData(result.allRecords);
                this.finalTitle = this.title+' ('+result.recordCount+')';
                this.objectprTitle = result.objectprlName;
                console.log('result------'+this.finalTitle+'--'+result.recordCount);
                if(this.sortBy!=null && this.sortBy!=''){
                    if(this.sortDirection==null || this.sortDirection==''){
                        this.sortDirection = 'desc';            
                    }
                    //this.sortData(this.sortBy, this.sortDirection);
                    this.fetchedRecords = columnsortData(this.sortBy, this.sortDirection,this.fetchedRecords);
                }
                if(result.recordCount<=10){
                    this.infinateloading = false;                    
                } 
                if(result.recordCount==0){
                    this.pageHeight  ='Small';
                }
                //This will prepare the list of columns
                this.handleFetchFieldTypes();                 
                console.log('--height--'+this.pageHeight);
            }    
        })
        .catch(error => {
            console.log(error);
        });  
    }
    
    
    handleFetchFieldTypes() {        
        var fieldarry  = this.fldShn.split(',');
        this.selected.splice(0, this.selected.length)
  
  //Prepare the input in the form of string array  
        for (var j = 0; j < fieldarry.length; j++) {
            console.log(fieldarry[j]);
            this.selected.push(fieldarry[j]);
        }

  //once the functions has been called it will return Map<String, List<String>>
        getFieldTypes({ selectedFields: this.fldShn, obj: this.objName})
            .then(result => {
                this.columns = this.selected.map(field => {
                    
                //assigning the data type
                const dType = result[field][0];
                
                //assigning the lable
                const dlabel = result[field][1];
                if(dType === 'url'){                   
                    return {
                        label: result[field][2],
                        fieldName: result[field][1],
                        type: 'url', 
                        typeAttributes: { label: {fieldName:field}, target: '_blank' },
                        sortable: "true" 
                    };        
                }
                if (dType === 'STRING' || dType === 'ID') {
                    if(this.editable===true){
                        return { 
                            label: dlabel, 
                            fieldName: field,
                            sortable: "true",editable: true 
                        };
                    }else{
                        return { 
                            label: dlabel, 
                            fieldName: field,
                            sortable: "true"
                        };    
                    }  
                } else if (dType === 'DATE') {                    
                    if(this.editable===true){
                        console.log('-----'+this.editable);
                        return { 
                            label: dlabel, 
                            fieldName: field, 
                            type: 'date',
                            sortable: "true" , editable: true 
                        };
                    }else{
                        return { 
                            label: dlabel, 
                            fieldName: field, 
                            type: 'date',
                            sortable: "true" 
                        };    
                    }
                } else if (dType === 'DATETIME') {                    
                    if(this.editable===true){
                        return {
                            label: dlabel,
                            fieldName: field,
                            type: 'datetime',
                            sortable: "true", editable: true 
                        };
                    }else{
                        return {
                            label: dlabel,
                            fieldName: field,
                            type: 'datetime',
                            sortable: "true" 
                        };    
                    }    
                } else if (dType === 'Integer') {
                    if(this.editable===true){
                        return {
                            label: dlabel,
                            fieldName: field,
                            type: 'Integer',
                            sortable: "true", editable: true 
                        };
                    }else{
                        return {
                            label: dlabel,
                            fieldName: field,
                            type: 'Integer',
                            sortable: "true"
                        };   
                    }
                } else if (dType === 'BOOLEAN') {
                    if(this.editable===true){
                        return {
                            label: dlabel,
                            fieldName: field,
                            type: 'text', editable: true 
                        };
                    }else{
                        return {
                            label: dlabel,
                            fieldName: field,
                            type: 'text'
                        };    
                    }
                } else {
                    if(this.editable===true){
                        return { 
                            label: dlabel, 
                            fieldName: field,
                            sortable: "true", editable: true 
                        };
                    }else{
                        return { 
                            label: dlabel, 
                            fieldName: field,
                            sortable: "true"
                        };    
                    }
                }
            });
        })
        .catch(error => {
            console.log(error);
        });            
    }

    refreshList(event) {
        this.refreshTrack = 'refresh'; 

        this.infinateloading = true;
        this.fetchedRecords = [];
        this.rowLimit =20;
        this.rowOffSet=0;
        console.log('rowLimit------'+this.rowLimit+'--'+this.rowOffSet);
        getObjectRecords({ selectedFields: this.fldShn, obj: this.objName, whcon: this.whcon, relatedField: this.relatedField, related: this.related, recordId: this.recordId, limitSize: this.rowLimit , offset : this.rowOffSet,countAll : 'All'})
        .then(result=>{
            if (result) {
                this.fetchedRecords = formatcurrentData(result.allRecords);
                //this.sortData(this.sortBy, this.sortDirection);
                this.fetchedRecords = columnsortData(this.sortBy, this.sortDirection,this.fetchedRecords);
                this.finalTitle = this.title+' ('+result.recordCount+')';
                console.log('refresh3------'+this.fetchedRecords.length);
                this.handleFetchFieldTypes(); 
            }    
        })
        .catch(error => {
            alert(error.body.message);
        });  
        

    }

    loadMoreData(event) {
        
        //Display a spinner to signal that data is being loaded
        if(this.refreshTrack != 'refresh'){
            if(event.target){
                event.target.isLoading = true;
            }
            this.tableElement = event.target;
            //Display "Loading" when more data is being loaded
            this.loadMoreStatus = 'Loading';
        
            this.rowOffSet = this.rowOffSet + this.rowLimit;
            
            getObjectRecords({ selectedFields: this.fldShn, obj: this.objName, whcon: this.whcon, relatedField: this.relatedField, 		
                                related: this.related, recordId: this.recordId, limitSize: this.rowLimit , offset : this.rowOffSet , countAll : 'None'})        
                .then((data) => {
                    console.log('Load more Call made');  
                        const currentRecord = this.fetchedRecords;
                        var  allRecords = formatcurrentData(data.allRecords);              
                    
                        this.fetchedRecords = this.fetchedRecords.concat(allRecords); 
                        this.loadMoreStatus = '';
                        this.totalRecords = this.fetchedRecords.length; 

                        //this.sortData(this.sortBy, this.sortDirection);
                        this.fetchedRecords = columnsortData(this.sortBy, this.sortDirection,this.fetchedRecords);
                        
                        console.log('allRecords------'+allRecords.length);  
                        if (this.fetchedRecords.length  >= this.maxRows || allRecords.length==0) {
                            //this.tableElement.enableInfiniteLoading = false;
                            this.infinateloading = false;
                            this.loadMoreStatus = 'No more data to load';
                        }
        
                    if(this.tableElement){
                        this.tableElement.isLoading = false;
                    } 
                }
            );
            console.log('loadMore----'+this.tableElement.isLoading+'----'+this.tableElement.enableInfiniteLoading+'---'+this.loadMoreStatus);
        }    
        this.refreshTrack = 'refreshDone';
    }

    handleSortdata(event) {
        // field name
        this.sortBy = event.detail.fieldName;
        // sort direction
        this.sortDirection = event.detail.sortDirection;
        console.log('sortDirection---'+this.sortDirection);
        // calling sortdata function to sort the data based on direction and selected field
        this.fetchedRecords = columnsortData(event.detail.fieldName, event.detail.sortDirection,this.fetchedRecords);
    }
    

    handleSave(event) {
        const recordInputs =  event.detail.draftValues.slice().map(draft => {
            const fields = Object.assign({}, draft);
            return { fields };
        });


        console.log('---recordInputs'+JSON.stringify(recordInputs));
        const promises = recordInputs.map(recordInput => {            
            updateRecord(recordInput)
        });
        console.log('---Done--');
        Promise.all(promises).then(fetchedRecords => {
            
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Success',
                    message: 'Records updated successfully',
                    variant: 'success'
                })
            );
             // Clear all draft values
             this.draftValues = [];
             // Display fresh data in the datatable
             this.fetchedRecords = [];
             //this.rowLimit =20;
             //this.rowOffSet=0;
             getObjectRecords({ selectedFields: this.fldShn, obj: this.objName, whcon: this.whcon, relatedField: this.relatedField, related: this.related, recordId: this.recordId, limitSize: this.rowLimit , offset : this.rowOffSet,countAll : 'All'})
             .then(result=>{
                 if (result) {
                     this.fetchedRecords = formatcurrentData(result.allRecords);
                     console.log('-----'+this.sortBy+'--'+this.sortDirection);
                     //this.sortData(this.sortBy, this.sortDirection);
                     this.fetchedRecords = columnsortData(this.sortBy, this.sortDirection,this.fetchedRecords);
                     this.finalTitle = this.title+' ('+result.recordCount+')';
                     this.handleFetchFieldTypes(); 
                 }    
             })
             .catch(error => {
                 alert(error.body.message);
             });  
        }).catch(error => {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error editing record',
                    message: '',
                    variant: 'error'
                })
            );
        });
    }

}