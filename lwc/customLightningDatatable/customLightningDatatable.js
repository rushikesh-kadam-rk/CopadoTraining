import { LightningElement } from 'lwc';
import LightningDatatable from "lightning/datatable";
import inputNumber from "./inputNumber.html";
export default class CustomLightningDatatable extends LightningDatatable {

    static customTypes = {
    inputNumber: {
      template: inputNumber,
      standardCellLayout: false,
      typeAttributes: ["rebateQuantity"],
    },
    // Other types here
  };
}