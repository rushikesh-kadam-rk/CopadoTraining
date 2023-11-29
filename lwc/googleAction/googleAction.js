import { api, LightningElement } from 'lwc';

export default class GoogleAction extends LightningElement {
    @api recordId;
    @api invoke(){
        console.log('Invoked', this.recordId);
        window.open("https://google.com", "_blank")
    }
}