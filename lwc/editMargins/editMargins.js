import { api, LightningElement, wire } from 'lwc';
import getProductQuotes from '@salesforce/apex/EditMargins.getProductQuotes';
import getSerivceQuotes from '@salesforce/apex/EditMargins.getSerivceQuotes';


const COLS = [
    {label:'Product Cost', fieldName:'Product_Cost__c'},
    {label:'Selling Price', fieldName:'Selling_Price__c'},
    {label:'GP%', fieldName:'Gp__c', editable:true},
    {label:'Product GP', fieldName:'Product_GP__c'},
];
const SQCOLS = [
    {label:'Service Cost', fieldName:'Service_Cost__c'},
    {label:'Selling Price', fieldName:'Selling_Price__c'},
    {label:'GP%', fieldName:'GP__c', editable:true},
    {label:'Service GP', fieldName:'Service_GP__c'},
];

export default class EditMargins extends LightningElement {
    columns = COLS;
    sqcolumns = SQCOLS;
    customFormModal = false;
    @api recordId;
    isEditing = true;
    draftValues = [];
    oppAmount = 0.0;
    totalCost = 0.0;
    oppGP = 0.0;
    oppGPP = 0.0;

    pqList = [];
    sqList = [];

    customShowModalPopup() {            
        this.customFormModal = true;
    }
 
    customHideModalPopup() {    
        this.customFormModal = false;
    }
    handleSave(){

    }

    @wire(getProductQuotes,{ oppId: '$recordId'})
    getPQList({data, error}){
        if(data){
            console.log(data);
            this.pqList = data;
            let serial = 0;
            this.pqList = data.map(row => {
                serial = serial+1;
                return {...row , serial} 
            });
        }
        if(error){
            console.error('in error', error);
        }
    }
    @wire(getSerivceQuotes,{ oppId: '$recordId'})
    getSQList({data, error}){
        if(data){
            console.log(data);
            this.sqList = data;
            let serial = 0;
            this.sqList = data.map(row => {
                serial = serial+1;
                return {...row , serial} 
            });
        }
        if(error){
            console.error('in error', error);
        }
    }

    enableCalcuate(event){
        this.isEditing = false;
        console.log('A::', event.detail.draftValues)
        console.log('before: ', this.pqList);
        /*const recordInputs =  event.detail.draftValues.slice().map(draft => {
            const fields = Object.assign({}, draft);
            console.log(draft.Gp__c);
            console.log(draft.Id);
            let Id = draft.Id;
            let Gp__c = draft.Gp__c;
            this.pqList = {...this.pqList, Id, Gp__c};
            return { fields };
        });*/
        if(this.draftValues.length>0){
            console.log('in if')
            //this.draftValues = [];
        }
        event.detail.draftValues.slice().map(draft => {
            this.pqList = this.pqList.map(pq=>{
                return (draft.Id === pq.Id ? { ...pq, Gp__c:parseFloat(draft.Gp__c).toFixed(2) } : pq);
            });
            this.sqList = this.sqList.map(pq=>{
                return (draft.Id === pq.Id ? { ...pq, GP__c:parseFloat(draft.GP__c).toFixed(2) } : pq);
            });
        });
        console.log('after: ', this.pqList);
    }

    handleCalculate(){
        if(!this.isEditing){
            this.pqList = this.pqList.map(row=>{
                let sp = parseFloat(row.Product_Cost__c/(1-(row.Gp__c/100))).toFixed(2);
                let pgp = parseFloat(sp-row.Product_Cost__c).toFixed(2);
                return {...row, Selling_Price__c: sp, Product_GP__c: pgp};
            });
            this.sqList = this.sqList.map(row=>{
                let sp = parseFloat(row.Service_Cost__c/(1-(row.GP__c/100))).toFixed(2);
                let pgp = parseFloat(sp-row.Service_Cost__c).toFixed(2);
                return {...row, Selling_Price__c: sp, Service_GP__c: pgp};
            });
            console.log('test', this.pqList);
            this.calculateOppValue();
        }else{
            this.calculateDefaultOppValue();
        }
        //calculate sp = pc/(1-gp%)
        //pgp = new sp-pc
        //opp amt = sum of all sp
        //opp gp = sum of all sp - sum of all pc
        //opp gp% = 
        //1-gp% = pc/sp
        //gp=(sp-pc)/sp
    }

    calculateOppValue(){ 
        let oAmt = 0;
        let tCost = 0;
        this.pqList.map(pq=>{
            oAmt = oAmt + parseFloat(pq.Selling_Price__c);
            tCost = tCost + parseFloat(pq.Product_Cost__c);
        });
        this.sqList.map(pq=>{
            oAmt = oAmt + parseFloat(pq.Selling_Price__c);
            tCost = tCost + parseFloat(pq.Service_Cost__c);
        });
        this.oppAmount = parseFloat(oAmt).toFixed(2);
        this.totalCost = parseFloat(tCost).toFixed(2);
        this.oppGP = parseFloat(this.oppAmount - this.totalCost).toFixed(2);
        this.oppGPP = parseFloat(((this.oppAmount-this.totalCost)/this.totalCost)*100).toFixed(2);
    }

    calculateDefaultOppValue(){ 
        let oAmt = 0;
        let tCost = 0;
        this.pqList.map(pq=>{
            oAmt = oAmt + parseFloat(pq.Selling_Price__c);
            tCost = tCost + parseFloat(pq.Product_Cost__c);
        });
        this.sqList.map(pq=>{
            oAmt = oAmt + parseFloat(pq.Selling_Price__c);
            tCost = tCost + parseFloat(pq.Service_Cost__c);
        });
        this.oppAmount = parseFloat(oAmt).toFixed(2);
        this.totalCost = parseFloat(tCost).toFixed(2);
        this.oppGP = parseFloat(this.oppAmount - this.totalCost).toFixed(2);
        this.oppGPP = parseFloat(((this.oppAmount-this.totalCost)/this.totalCost)*100).toFixed(2);
    }
}