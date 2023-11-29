import { LightningElement, track } from 'lwc';

import retrieveCurrencyConversionRates from '@salesforce/apex/CurrencyConversionController.retrieveCurrencyConversionRates';

const options = [
    {label : 'USD', value : 'USD'},
    {label : 'EUR', value : 'EUR'},
    {label : 'CAD', value : 'CAD'},
    {label : 'GBP', value : 'GBP'},
    {label : 'INR', value : 'INR'},
]

export default class HTTPCalloutLWC extends LightningElement {

    @track fromCurrencyOptions = options;
    @track toCurrencyOptions = options;
    fromCurrencyValue;
    toCurrencyValue;

    @track conversionData

    handleFromCurrencyChange(event){
        this.fromCurrencyValue = event.detail.value;
    }

    get conversionButton(){
        return this.fromCurrencyValue && this.toCurrencyValue ? false : true;
    }

    handleToCurrencyChange(event){
        this.toCurrencyValue = event.detail.value;
    }

    handleCurrencyConversionWithApex(){
        let callbackEndpointURL = 'https://www.alphavantage.co/query?function=CURRENCY_EXCHANGE_RATE&from_currency='+this.fromCurrencyValue+'&to_currency='+this.toCurrencyValue+'&apikey=QS83OQH7XS7F1H0J';

        retrieveCurrencyConversionRates({endpointURL : callbackEndpointURL}).then(response=>{
            let objData = {
                From_Currency_Name : '',
                From_Currency_Code : '',
                To_Currency_Name : '',
                To_Currency_Code : '',
                Last_Refreshed : '',
                Exchange_Rate : '',

            };
            let exchangeData = response['Realtime Currency Exchange Rate'];
            objData.From_Currency_Name = exchangeData['2. From_Currency Name'];
            objData.From_Currency_Code = exchangeData['1. From_Currency Code'];
            objData.To_Currency_Name = exchangeData['4. To_Currency Name'];
            objData.To_Currency_Code = exchangeData['3. To_Currency Code'];
            objData.Last_Refreshed = exchangeData['6. Last Refreshed'];
            objData.Exchange_Rate = exchangeData['5. Exchange Rate'];

            this.conversionData = objData;
        }).catch(error=>{
            console.error('CALLOUT ERROR===>', JSON.stringify(error))
        })
    }

    handleCurrencyConversion(){
        fetch('https://www.alphavantage.co/query?function=CURRENCY_EXCHANGE_RATE&from_currency='+this.fromCurrencyValue+'&to_currency='+this.toCurrencyValue+'&apikey=QS83OQH7XS7F1H0J',{
            method : "GET",
            headers : {
                "Content-type" : "application/json",
                "Authorization" : "OAuth 00D2w000001Na7n!ARQAQKRJ7uNBkeDK6dUDdAb2h4kFr1e9V2sf3d53TAWzcFST9SJ5.xprUWu9zgzy99u0NBo.VKF3vsZcCMzoPnWLly1_NOLT"
            }
        }).then((response)=>{
            return response.json();
        }).then((jsonResponse)=>{
            let objData = {
                From_Currency_Name : '',
                From_Currency_Code : '',
                To_Currency_Name : '',
                To_Currency_Code : '',
                Last_Refreshed : '',
                Exchange_Rate : '',

            };
            let exchangeData = jsonResponse['Realtime Currency Exchange Rate'];
            objData.From_Currency_Name = exchangeData['2. From_Currency Name'];
            objData.From_Currency_Code = exchangeData['1. From_Currency Code'];
            objData.To_Currency_Name = exchangeData['4. To_Currency Name'];
            objData.To_Currency_Code = exchangeData['3. To_Currency Code'];
            objData.Last_Refreshed = exchangeData['6. Last Refreshed'];
            objData.Exchange_Rate = exchangeData['5. Exchange Rate'];

            this.conversionData = objData;
        }).catch(error=>{
            console.error('CALLOUT ERROR===>', JSON.stringify(error))
        });
    }
}