import { LightningElement, api } from 'lwc';

export default class VaccineSlotFinder extends LightningElement {

    centers = [];
    dates = [];
    accoountId;

    @api
 recordId;

    onOpenAccountClick() {
        console.log('rkrk')
        this.invokeWorkspaceAPI('isConsoleNavigation').then(isConsole => {
          if (isConsole) {
            this.invokeWorkspaceAPI('getFocusedTabInfo').then(focusedTab => {
              this.invokeWorkspaceAPI('openTab', {
                //parentTabId: focusedTab.tabId,
                //recordId: this.accoountId,
                pageReference: {
                    type: 'standard__webPage',
                attributes: {
                    //url: '/lightning/n/Vaccine_Slots?id=test',
                }
                },
                overrideNavRules: false
              }).then(tabId => {
                console.log("Solution #2 - SubTab ID: ", tabId);
              });
            });
          }
        });
      }

      invokeWorkspaceAPI(methodName, methodArgs) {
        return new Promise((resolve, reject) => {
          const apiEvent = new CustomEvent("internalapievent", {
            bubbles: true,
            composed: true,
            cancelable: false,
            detail: {
              category: "workspaceAPI",
              methodName: methodName,
              methodArgs: methodArgs,
              callback: (err, response) => {
                if (err) {
                    return reject(err);
                } else {
                    return resolve(response);
                }
              }
            }
          });
     
          window.dispatchEvent(apiEvent);
        });
      }

      handleAccoountId(event){
          this.accoountId = event.target.value;
      }

    pincodeChangeHandler(event){
        //https://cdn-api.co-vin.in/api/v2/appointment/sessions/public/calendarByPin?pincode=411038&date=04-08-2021
        const pinCode = event.target.value;
        const isEnterKey = event.keyCode === 13;
        if(pinCode.length === 6 && isEnterKey){
            const today = new Date();
            const formattedDate = `${today.getDate()}-${today.getMonth()+1}-${today.getFullYear()}`;
            //const endpoint = `https://cdn-api.co-vin.in/api/v2/appointment/sessions/public/calendarByPin?pincode=${pinCode}&date=${formattedDate}`;
            const endpoint = `https://choudharymanish8585.github.io/cowin-api-sample-response/db.json`;
            this.fetchVaccineSlots(endpoint);
        }
    }

    async fetchVaccineSlots(endpoint){
        const vaccineSlotRes = await fetch(endpoint);
        const slotsData = await vaccineSlotRes.json();
        this.buildColumnsAndRows(slotsData.centers)
    }

    buildColumnsAndRows(data){
        //build columns/dates
        const dates = new Map();
        dates.set("name", {
            label:"Center Name", fieldName:"name", type:"text"
        });
        //build rows/centers
        const centers = new Map();
        for(const center of data){
            !centers.has(center.center_id) && centers.set(center.center_id, {
                name: center.name
            })
            for (const session of center.sessions){
                //destructiring syntax
                const {date, available_capacity, min_age_limit} = session;

                dates.set(date, {
                    label:date, fieldName:date, type:"text", wrapText: true,
                    cellAttribute: {
                        class: {fieldName: "className"}
                    }
                });
                //add column value for the row
                centers.get(center.center_id)[date] = `Available Capacity: ${available_capacity}
                Minimum Age: ${min_age_limit}`;
                centers.get(center.center_id).className = available_capacity > 0 ?"slds-text-color_success":"slds-text-color_error";
            }
        }
        console.log('1',dates);
        console.log('2',centers);
        this.dates = Array.from(dates.values());
        this.centers = Array.from(centers.values());
        
    }

    get hideMessage(){
        return this.centers.length > 0;
    }
}