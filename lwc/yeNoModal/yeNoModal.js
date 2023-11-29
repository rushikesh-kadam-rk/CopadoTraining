import { api, LightningElement } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import publishBenchEmployment from '@salesforce/apex/BenchEmploymentController.publishBenchEmployment';

export default class YeNoModal extends NavigationMixin(LightningElement) {
    
    conRecordId;
    @api isModalOpen = false;

    @api
    get contactRecordId(){
        return this.conRecordId;
    }
    set contactRecordId(data){
        this.conRecordId = data;
    }
    
    navigateToRecordPage() {
        this.isModalOpen = false;
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: this.conRecordId,
                objectApiName: 'Contact',
                actionName: 'view'
            }
        });
    }

    publishBenchEmployment(){
        publishBenchEmployment({conID:this.conRecordId})
        .then(result=>{
            console.log('success:', result);
            this.isModalOpen = false;
            this.navigateToRecordPage();
        }).catch(error=>{
            console.log(error);
        })
    }

}