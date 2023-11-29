import { LightningElement, wire } from 'lwc';
import getContactsList from '@salesforce/apex/GetContacts.getContactsList';
import buttonName from '@salesforce/label/c.Button_Name';

export default class TableModal extends LightningElement {
    isModelOpen = false;
    isContactSelected = true;
    duplicateContactList = [];
    showLoading = false;

    handleModel(){
        //this.showLoading = true;
        this.isModelOpen = true;
        document.querySelector("#modal-container").style.display = 'block';
        document.querySelector("body").style.overflow = 'hidden';
    }
    label = {
        buttonName,

    };
    closeModal(){
        this.isModelOpen = false;
        this.isContactSelected = true;
        //clear selected contact
    }
    handleContactSelected(){
        this.isContactSelected = false;
    }

    @wire(getContactsList)
    getContactsListLWC({data, error}){
        if(data){
            //this.showLoading = false;
            this.duplicateContactList = data;
            console.log('dupes:::::', this.duplicateContactList)
            let formattedDate;
            this.duplicateContactList = this.duplicateContactList.map(aDuplicateContact=>{
                formattedDate = this.dateFormatter(aDuplicateContact.LastModifiedDate)
                return {...aDuplicateContact, formattedDate}
            });
            console.log('dupes after conversion::', this.duplicateContactList)
        }
        
    }

    dateFormatter(dateTime){
        let currentDate = new Date(dateTime);
        let formatter = new Intl.DateTimeFormat('en', {
            year: 'numeric',
            month: 'short',
            day: '2-digit'
        })        
        let formattedDate = formatter.format(currentDate);
        return formattedDate;
    }

}