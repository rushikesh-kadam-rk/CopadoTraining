import { api, LightningElement, track, wire } from 'lwc';
import {getObjectInfo} from 'lightning/uiObjectInfoApi';
import CONTACT_OBJ from '@salesforce/schema/Contact'

export default class AddContact extends LightningElement {
    isModalOpen = false;
    isSecondModalOpen = false;
    objectApiName = 'Contact';
    contactID= null;
    contactInfo;
    contactObj;
    @api loanRecordId;
    @track conRecTypeId;    

    @api
    get showcreateContact(){
        return this.isModalOpen;
    }
    set showcreateContact(data){
        console.log('in modalOpen: ',data)
        this.isModalOpen = data;
    }
    
    connectedCallback(){
        console.log('in addContact connectedCallback');
    }
    renderedCallback(){
        console.log('in addContact renderedCallback');
    }

    @wire(getObjectInfo, { objectApiName: CONTACT_OBJ })
    getContactRecType({error,data}){
       if(data){
         // perform your custom logic here
        //console.log(JSON.stringify(data.recordTypeInfos));
        const recTypes = JSON.parse(JSON.stringify(data.recordTypeInfos));
        this.printValues(recTypes);
        console.log(recTypes);
        // this.recTypeId = recTypes.array.forEach(element => {
            
        // });
        

       }else if(error){
           // perform your logic related to error 
        }
    };
    printValues(obj) {

        for(var k in obj) {
            console.log('0',k);
            let endLoop = false;
            if(obj[k] instanceof Object) {
                //console.log(obj[k].name);
                //console.log('1', obj[k]);
                //console.log('');
                for(var s in obj[k]){
                    if(s==='name' && obj[k][s]==='Business Contact'){
                        //console.log('recType', k);
                        this.conRecTypeId = k;
                        endLoop = true;
                        break;
                    }
                }
                if(endLoop){
                    break;
                }
                //this.printValues(obj[k]);
            } else {
                console.log(k)
            };
        }
    };
    handleSuccess(event){
        this.isModalOpen = false;
        console.log('Contact Created ') 
        this.contactID = event.detail.id;
        console.log( 'ID of new contactID ',this.contactID);
        this.contactRecord = event.detail.fields;
        console.log( 'ID of new contactID ',this.contactRecord);
        this.contactInfo = JSON.parse(JSON.stringify(this.contactRecord));
        console.log('in add Contact: ',this.contactInfo);
        console.log('FirstName ',this.contactInfo.FirstName.value);
        let fName = this.contactInfo.FirstName.value;
        let lName = this.contactInfo.LastName.value;
        this.contactObj = [{
            "Id": this.contactID,
            "Name": fName+' '+lName,
            "nameUrl": `/${this.contactID}`
        }];
        console.log(this.contactObj);
        this.isSecondModalOpen = true;
    }
    handleCancel(){
        this.isModalOpen = false;
        this.isSecondModalOpen = false;
        this.closeModal();
    }
    closeModal(){
        const custEvent = new CustomEvent('close',{
            bubbles : true,
            detail : {
                msg:"Data Passed from Child Using Detail Attribute"
            }
        });
        this.dispatchEvent(custEvent);
    }
}