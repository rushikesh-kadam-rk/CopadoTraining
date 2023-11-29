import { LightningElement, api } from 'lwc';
import createAccounts from '@salesforce/apex/ContactController.createAccounts';
import createEI from '@salesforce/apex/ContactController.createEI';
export default class AddEIScreen extends LightningElement {
    @api loanRecordId;
    isModalOpen;
    entityList;
    accountist;
    isBTSelected = false;
    isPct = false;
    isAmt = false;
    isAmtReq = true;
    isPctReq = true;
    addEI = true;

    ctgAmt;
    ctgPct;
    borrowerType;
    ctgType;

    get optionsBT() {
        return [
            { label: 'Borrower', value: 'Borrower' },
            { label: 'Guarantor', value: 'Guarantor' }
        ];
    }
    get optionsCT() {
        return [
            { label: 'Joint & Several', value: 'Joint & Several' },
            { label: 'Pro Rata', value: 'Pro Rata' }
        ];
    }

    @api
    get modalOpen(){
        return this.isModalOpen;
    }
    set modalOpen(data){
        this.isModalOpen = data;
    }

    @api
    get contactList(){
        return this.entityList;
    }

    set contactList(data){
        console.log(data);
        this.entityList = data;  
    }

    closeThirdModal(){
        this.isModalOpen = false;
    }
    handleChangeBT(event){
        if(event.target.value){
            let borrowerType;
            this.isBTSelected = true;
            let itemId = event.target.dataset.id;
            let itemName = event.target.dataset.name;
            console.log(itemId, ':', itemName);
            console.log(JSON.parse(JSON.stringify(this.entityList)));
            this.entityList = this.entityList.map(row=>{
                if(row.Id===itemId){
                    borrowerType = event.target.value;
                    return {...row, borrowerType}
                }
            });
            console.log(JSON.parse(JSON.stringify(this.entityList)));
        }
    }
    handleChangeCT(event){
        if(event.target.value){
            let contigentType;
            let itemId = event.target.dataset.id;
            this.entityList = this.entityList.map(row=>{
                if(row.Id===itemId){
                    contigentType = event.target.value;
                    return {...row, contigentType}
                }
            });
            console.log(JSON.parse(JSON.stringify(this.entityList)));
        }
    }
    handleAmt(event){
        console.log(event)
        //event.preventDefault();
        //this.enableAddEI();
        this.addEI = true;
        console.log('handleAmt', JSON.parse(JSON.stringify(event.target.dataset.id)));
        if(event.target.value.length){
            //this.ctgAmt = event.target.value;
            this.isPct = true;
            this.isAmtReq = false;
            this.addEI = false;

            let itemId = event.target.dataset.id;
            let contigentAmount;
            this.entityList = this.entityList.map(row=>{
                if(row.Id===itemId){
                    contigentAmount = event.target.value;
                    return {...row, contigentAmount}
                }
            });
            console.log(JSON.parse(JSON.stringify(this.entityList)));
        }else{
            //inputCmp.setCustomValidity("");
            //this.ctgAmt = null;
            this.isPct = false;
            this.isAmtReq = true;

            let itemId = event.target.dataset.id;
            let contigentAmount;
            this.entityList = this.entityList.map(row=>{
                if(row.Id===itemId){
                    contigentAmount = null;
                    return {...row, contigentAmount}
                }
            });
            console.log(JSON.parse(JSON.stringify(this.entityList)));
        }
    }
    handlePct(event){
        //this.enableAddEI();
        this.addEI = true;
        console.log('handlePct', JSON.parse(JSON.stringify(event.target.dataset.id)));
        if(event.target.value.length){
            //this.ctgPct = event.target.value;
            this.isAmt = true;
            this.isPctReq = false;
            this.addEI = false;

            let itemId = event.target.dataset.id;
            let contigentPercentage;
            this.entityList = this.entityList.map(row=>{
                if(row.Id===itemId){
                    contigentPercentage = event.target.value;
                    return {...row, contigentPercentage}
                }
            });
            console.log(JSON.parse(JSON.stringify(this.entityList)));
        }else{
            //this.ctgPct = null;
            this.isAmt = false;
            this.isPctReq = true;

            let itemId = event.target.dataset.id;
            let contigentPercentage;
            this.entityList = this.entityList.map(row=>{
                if(row.Id===itemId){
                    contigentPercentage = null;
                    return {...row, contigentPercentage}
                }
            });
            console.log(JSON.parse(JSON.stringify(this.entityList)));
        }
        
    }
    enableAddEI(){
        this.template.querySelectorAll("lightning-input").forEach(item => {
            let fieldValue=item.value;
            let fieldLabel=item.label;
            console.log('fieldLabel', fieldLabel);
            console.log('fieldValue', fieldValue);
            if(!fieldValue){   
                item.setCustomValidity("");
                //item.setCustomValidity(fieldErrorMsg+' '+fieldLabel);
            }else{
                item.setCustomValidity("");
                //this.addEI = false;
            }
            //item.reportValidity();
		});
    }
    addSelectedAccount(){
        console.log(JSON.parse(JSON.stringify(this.entityList)));
        //create a individual account and entity relationship
        let conList1 = JSON.parse(JSON.stringify(this.entityList));
        createAccounts({conList: conList1})
        .then(result=>{
            console.log('success:', result);
            this.accountist = JSON.parse(JSON.stringify(result));
            this.addSelectedEI();
        }).catch(error=>{
            console.log(error);
        })
    }

    addSelectedEI(){
        createEI({accList:this.accountist, loanId: this.loanRecordId})
        .then(result=>{
            console.log('success:', result);
            this.isModalOpen = false;
        }).catch(error=>{
            console.log(error);
        })
    }
    closeModal(){
        this.isModalOpen = false;
        const custEvent = new CustomEvent('close',{
            bubbles : true,
            detail : {
                msg:"Data Passed from Child Using Detail Attribute"
            }
        });
        this.dispatchEvent(custEvent);
    }
    
}