import { LightningElement } from 'lwc';

export default class AccountModal extends LightningElement {
    isModalOpen = false;
    isOptionNotSelected = true;
    isNextClicked = false;

    handleModal(){
        this.isModalOpen = true;
    }

    closeModal(){
        this.isModalOpen = false;
    }

    handleOptionSelected(event){
        console.log(event);
        this.isOptionNotSelected = false;
    }
    openNextModal(){
        //this.isModalOpen = false;
        this.isNextClicked = true;
    }

}