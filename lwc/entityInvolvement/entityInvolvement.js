import { api, LightningElement, wire } from 'lwc';
import getContacts from '@salesforce/apex/ContactController.getContacts';
import getEntityInvolvment from '@salesforce/apex/ContactController.getEntityInvolvment';
const COLS = [
    {label:'Relationship Name', fieldName:'nameUrl', type: 'url', typeAttributes: {label: { fieldName: 'Name'}, target: '_blank'}, cellAttributes: { iconName: 'utility:connected_apps', iconPosition: 'right'}},
    {label:'Relationship Type', fieldName:'Id'},
    {label:'SS#', fieldName:'Name'},
    {label:'Tax Identification Number', fieldName:'Name', editable:true},
    {label:'Relationship Phone', fieldName:'Name', editable:true}
];
const EICOLS = [
    {label:'Relationship Name', fieldName:'nameUrl', type: 'url', typeAttributes: {label: { fieldName: 'accName'}, target: '_blank'}, cellAttributes: { iconName: 'utility:connected_apps', iconPosition: 'right'}, cellAttributes:{iconName:'standard:account', iconPosition: 'left'}},
    {label:'Borrower Type', fieldName:'LLC_BI__Borrower_Type__c'},
    {label:'Contigent Type', fieldName:'LLC_BI__Contingent_Type__c'},
    {label:'Contigent Amount', fieldName:'LLC_BI__Contingent_Amount__c'},
    {label:'Contigent Percentage', fieldName:'LLC_BI__Ownership__c'}
];
export default class EntityInvolvement extends LightningElement {
    @api recordId;
    isModalOpen = false;
    showCreateContact = false;
    isThirdModalOpen = false;
    isNotSearchable = true;
    searchBtnClicked = false;
    addAccount = true;
    columns = COLS;
    eicoulumns = EICOLS;
    searchKey = '';
    contactList = [];
    eiList = [];
    selectedRows = [];
    selectedContacts = [];

    renderedCallback(){
    }

    //'$this.recordId'
    @wire(getEntityInvolvment,{ loanId: '$recordId'})
    getEIList({data, error}){
        if(data){
            
            let nameUrl;
            let accName;
            this.eiList = data;
            this.eiList = data.map(row => { 
                nameUrl = `/${row.LLC_BI__Account__c}`;
                accName = row.LLC_BI__Account__r["Name"];
                return {...row , nameUrl, accName} 
            });
        }
        if(error){
            console.error('in error', error);
        }
    }
    openModal() {
        // to open modal set isModalOpen tarck value as true
        this.isModalOpen = true;
    }
    closeModal() {
        // to close modal set isModalOpen tarck value as false
        console.log('in closeModal')
        this.isModalOpen = false;
        this.contactList = [];
        this.addAccount = true;
        this.searchBtnClicked = false;
        this.isNotSearchable = true;
    }
    submitDetails() {
        // to close modal set isModalOpen tarck value as false
        //Add your code to call apex method or do some processing
        this.isModalOpen = false;
    }
    searchContacts(event){
        
        if(event.target.value && event.target.value.length>2){
            console.log('in searchContacts: ', event);
            this.isNotSearchable = false;
            this.searchKey = event.target.value;
        }else{
            this.isNotSearchable = true;
        }
    }
    handleSearch(){
        //find contacts with matching name
        //imperative apex call
        getContacts({searchKey:this.searchKey})
        .then(result=>{
            let nameUrl;
            this.contactList = result;
            this.contactList = result.map(row => { 
                nameUrl = `/${row.Id}`;
                return {...row , nameUrl} 
            });
            console.log(this.contactList);
            this.searchBtnClicked = true;
            

            // const convertArrayToObject = (array, key) => {
            //     const initialValue = {};
            //     return array.reduce((obj, item) => {
            //       return {
            //         ...obj,
            //         [item[key]]: item,
            //       };
            //     }, initialValue);
            // };
            //console.log(convertArrayToObject(result, 'Id'));
        }).catch(error=>{
            console.log(error);
        })
    }
    
    addNewAccount(){
        console.log('start of addNewAccount');
        this.isModalOpen = false;
        this.showCreateContact = true;
        console.log('end of addNewAccount')
    }
    closeSecondModal() {
        this.showCreateContact = false;
        //this.isModalOpen = true;
    }
    handleBack(){
        this.showCreateContact = false;
        this.isModalOpen = true;
    }
    addSelectedAccount(){
        this.isModalOpen = false;
        this.showCreateContact = false;
        this.isThirdModalOpen = true;
    }
    handleRowSelection(){
        var selectedRecords =  this.template.querySelector('.contactLDT').getSelectedRows();  
        //console.log('selectedRecords are ',JSON.parse(JSON.stringify(selectedRecords[0].Id)));
        if(this.selectedRows && selectedRecords.length>0){
            this.addAccount = false;
            this.selectedContacts = JSON.parse(JSON.stringify(selectedRecords))
        }else{
            this.addAccount = true;
        }
        
    }
}