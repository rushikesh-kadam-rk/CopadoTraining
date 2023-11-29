import { LightningElement, track } from 'lwc';
import convert from '@salesforce/apex/CurrencyConverterService.convert';

export default class CurrencyConvertor extends LightningElement {

  sourceCurrency = 'CAD';
  targetCurrency = 'USD';
  amount = '';
  @track convertedAmount;
		@track convertedAmountHistory = [{}];
		isLoading = false;

  get options() {
    return [
        { label: 'US Dollar', value: 'USD' },
        { label: 'Euros', value: 'EUR' }
    ];
  }

  handleSourceChange(event) {
    this.sourceCurrency = event.detail.value;
  }

  handleTargetChange(event) {
    this.targetCurrency = event.detail.value;
  }
		
		get isValidAmount(){
				return this.amount && this.amount > 0? false : true;
		}

  handleAmountChange(event) {
    this.amount = event.detail.value;
  }
  
  handleConvert(event) {
			this.isLoading = true;
    convert({sourceCurrency:this.sourceCurrency, 
              targetCurrency:this.targetCurrency, 
              amount: this.amount}).then(result => {
        this.convertedAmount = result;
				let convertedAmountObject = {
						sourceCurency: 'CAD',
						targetCurrency: this.targetCurrency,
						sourceAmount: this.amount,
						convertedAmount: result,
						label: this.amount + 'CAD'+' = ' + result + this.targetCurrency
				};
				
				this.convertedAmountHistory = [...this.convertedAmountHistory, convertedAmountObject];
				this.isLoading = false;
    }).catch(error=>{
				console.log(error.message);
		});
  }

}