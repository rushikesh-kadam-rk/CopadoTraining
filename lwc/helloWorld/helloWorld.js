import { api, LightningElement, track, wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getContactList from '@salesforce/apex/BenchEmploymentController.getContactList';

export default class HelloWorld extends LightningElement {
    @track greeting = 'World';
    isThirdModalOpen = false;
    @api recordId;
    firstCheckedValue;
    selecetdCheckedList = [];
    changeHandler(event) {
        this.greeting = event.target.value;
    }

    onButtonCLicked(){
        this.isThirdModalOpen = true;
        console.log(this.recordId);
    }

    @wire(getContactList)
    contacts;

    handleChangeEvent(event){
        const checkbox = this.template.querySelector('lightning-input[data-value="'+event.target.dataset.value+'"]');
        if(checkbox.checked){
            if(this.selecetdCheckedList.length==0){
                this.selecetdCheckedList = [...this.selecetdCheckedList, event.target.dataset.value];
                this.firstCheckedValue = event.target.dataset.value;
                checkbox.checked=true;
            }else if(this.selecetdCheckedList.length==1){
                this.selecetdCheckedList = [...this.selecetdCheckedList, event.target.dataset.value];
                checkbox.checked=true;
            }else if(this.selecetdCheckedList.length==2){
                const checkbox2 = this.template.querySelector('lightning-input[data-value="'+this.firstCheckedValue+'"]');
                checkbox2.checked=false;
                const index = this.selecetdCheckedList.indexOf(this.firstCheckedValue);
                if (index > -1) {
                    this.selecetdCheckedList.splice(index, 1); // 2nd parameter means remove one item only
                    this.selecetdCheckedList = [...this.selecetdCheckedList, event.target.dataset.value];
                    this.firstCheckedValue = this.selecetdCheckedList[0];
                }
                
            }
        }else if(!checkbox.checkbox){
            checkbox.checked = false;
            const index = this.selecetdCheckedList.indexOf(event.target.dataset.value);
            if (index > -1) {
                this.selecetdCheckedList.splice(index, 1); // 2nd parameter means remove one item only
                if(this.selecetdCheckedList.length==1){
                    this.firstCheckedValue = this.selecetdCheckedList[0];
                }else{
                    this.firstCheckedValue = undefined;
                }
                
            }
        }
        
        // let checkedCount = 0;
        // Array.from(this.template.querySelectorAll('lightning-input'))
        // .forEach(element => {
        //     if(element.checked){
        //         if(checkedCount==0){
        //             this.firstCheckedValue = element.dataset.value;
        //         }
        //         checkedCount++;
        //     }
        // });

        // const checkbox = this.template.querySelector('lightning-input[data-value="'+event.target.dataset.value+'"]');
        // checkbox.checked=true;

        // if(checkedCount>2){
        //     const checkbox1 = this.template.querySelector('lightning-input[data-value="'+this.firstCheckedValue+'"]');
        //     checkbox1.checked=false;
        // }
        
    }

    showToastMessage() {
        const event = new ShowToastEvent({
            variant: 'error',
            title: 'Get Help',
            mode:'sticky',
            message:
                'Salesforce documentation is available in \nTestthe app. Click ? in the upper-right corner.',
        });
        this.dispatchEvent(event);
    }
}