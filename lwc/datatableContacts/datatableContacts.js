import { LightningElement, wire, track, api } from 'lwc';
import getContactsList from '@salesforce/apex/DatatableContactsRemote.getContactsList';
import updateContacts from '@salesforce/apex/DatatableContactsRemote.updateContacts';
import { refreshApex } from '@salesforce/apex';

export default class DatatableContacts extends LightningElement {

    columns = [
        { label: 'Id', fieldName: 'Id' },
        { label: 'Name', fieldName: 'Name', editable: true},
        { label: 'Phone', fieldName: 'Phone', type: 'phone', editable: true }
    ];

    @track contactsList;
    _contactsList;
    saveDraftValues;
    @api recordId;
    _uppercaseItemName;

    @wire(getContactsList, {})
    getContactsList(response){
        console.log('in wire method', response);
        this._contactsList = response;
        this.contactsList = response.data
    };

    connectedCallback(){
        console.log('in connected calllback');
    }

    renderedCallback(){
        console.log('in rendered calllback');
    }

    @api
    get headerAPI(){
        console.log('in api getter');
        return 'RK';
    }

    
    get itemName() {
        return this._uppercaseItemName;
    }

    @api
    set itemName(value) {
        console.log('in api setter');
        this._uppercaseItemName = value.toUpperCase();
    }

    // render(){
    //     console.log('in render');
    // }

    get header(){
        console.log('in getter');
        return 'RK';
    }

    handleSave(event){
        this.saveDraftValues = event.detail.draftValues;
        updateContacts({contactList : this.saveDraftValues}).then(response=>{
            refreshApex(this._contactsList);
            this.saveDraftValues = null;
        }).catch(error=>{
            console.error(error);
        })
    }

    handleClick(){
        getContactsList().then(result=>{
            console.log('call to apex')
        }).catch(error=>{
            console.error('error');
        })
    }
}