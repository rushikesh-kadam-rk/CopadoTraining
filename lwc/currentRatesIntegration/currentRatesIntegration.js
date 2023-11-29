import { LightningElement, track } from 'lwc';
import getCalloutResponseContent from '@salesforce/apex/HttpCalloutControl.getCalloutResponseContent';
export default class CurrentRatesIntegration extends LightningElement {

    @track response;
    @track listOfCurrency = [];

    handleShowExchangeRates() {
        getCalloutResponseContent({ url: 'http://data.fixer.io/api/latest?access_key=251b34414b13692e8347b70775218fad' }).then(response => {
            this.response = response;
            console.log(response);
            for(let key in this.response.rates){
                this.listOfCurrency.push(key+'='+this.response.rates[key]);
            }
        }).catch(error => {
            console.error(error);
        })
    }
}