import { LightningElement, wire } from 'lwc';
import {NavigationMixin} from 'lightning/navigation';

import CAR_OBJECT from '@salesforce/schema/Car__c'
import NAME_FIELD from '@salesforce/schema/Car__c.Name';
import PICTURE_URL_FIELD from '@salesforce/schema/Car__c.Picture_URL__c';
import CATEGORY_FIELD from '@salesforce/schema/Car__c.Category__c';
import MAKE_FIELD from '@salesforce/schema/Car__c.Make__c';
import MSRP_FIELD from '@salesforce/schema/Car__c.MSRP__c';
import FUEL_FIELD from '@salesforce/schema/Car__c.Fuel_Type__c';
import SEATS_FIELD from '@salesforce/schema/Car__c.Number_of_Seats__c';
import CONTROL_FIELD from '@salesforce/schema/Car__c.Control__c';

import CAR_SELECTED_MESSAGE from '@salesforce/messageChannel/CarSelected__c';
import { subscribe, MessageContext, unsubscribe } from 'lightning/messageService';

import { getFieldValue } from 'lightning/uiRecordApi';

export default class CarCard extends NavigationMixin(LightningElement) {
    /**Exposing fields to make them available in the template */
    categoryField = CATEGORY_FIELD;
    makeField = MAKE_FIELD;
    msrpField = MSRP_FIELD;
    fuelField = FUEL_FIELD;
    seatsField = SEATS_FIELD;
    controlField = CONTROL_FIELD;

    recordId;

    /**Car fields display with specific format */
    carName;
    carPictureUrl;

    carSelectionSubscription;
    /**Load Context for LMS */
    @wire(MessageContext)
    messageContext

    handleRecordLoaded(event){
        const {records} = event.detail;
        const recordData = records[this.recordId];
        this.carName = getFieldValue(recordData, NAME_FIELD);
        this.carPictureUrl = getFieldValue(recordData, PICTURE_URL_FIELD);
    }

    connectedCallback(){
        this.subscribeHandler();
    }

    subscribeHandler(){
        console.log('1: ')
        this.carSelectionSubscription = subscribe(this.messageContext, CAR_SELECTED_MESSAGE, (message=>this.handleCarSelected(message)))
    }

    handleCarSelected(message){
        
        this.recordId = message.carId;
        
    }

    disconnectedCallback(){
        unsubscribe(this.carSelectionSubscription);
        this.carSelectionSubscription = null;
    }

    handleNavigateToRecord(){
        this[NavigationMixin.Navigate]({
            type:'standard__recordPage',
            attributes: {
                recordId: this.recordId,
                objectApiName: CAR_OBJECT.objectApiName,
                actionName: 'view'
            }
        })
    }
}