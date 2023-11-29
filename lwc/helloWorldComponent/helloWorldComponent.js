import { api, LightningElement } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';

export default class HelloWorldComponent extends NavigationMixin(LightningElement) {
    @api messageList;

    lwctovf = 'Data from LWC to VF';

    connectedCallback(){
        
    }
    passData(){
        this.dispatchEvent(new CustomEvent(
            'dosearch', 
            {
                detail: { conId:  this.lwctovf, accId:'0012w000003F4LhAAK'},
                bubbles: true,
                composed: true,
            }
        ))
    }
    redirectToAcc(){
        console.log('1')
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: '0012w000003F4LhAAK',
                objectApiName: 'Account',
                actionName: 'view'
            }
        });
    }

    isModalOpen = true;
    openModal() {
        // to open modal set isModalOpen tarck value as true
        this.isModalOpen = true;
    }
    closeModal() {
        // to close modal set isModalOpen tarck value as false
        this.isModalOpen = false;
    }
    submitDetails() {
        // to close modal set isModalOpen tarck value as false
        //Add your code to call apex method or do some processing
        this.isModalOpen = false;
    }
}