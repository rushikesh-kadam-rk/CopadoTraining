import { LightningElement, api, track } from "lwc";
/**Custom Labels */
import SELECTED_REBATE_ITEMS from "@salesforce/label/c.SELECTED_REBATE_ITEMS";
import AVAILABLE_REBATE_ITEMS from "@salesforce/label/c.AVAILABLE_REBATE_ITEMS";
import REBATE_SKU from "@salesforce/label/c.REBATE_SKU";
import REBATE_DESCRIPTION from "@salesforce/label/c.REBATE_DESCRIPTION";
import REBATE_MAX_QUANTITY from "@salesforce/label/c.REBATE_MAX_QUANTITY";
import REBATE_AMOUNT from "@salesforce/label/c.REBATE_AMOUNT";
import REBATE_QUANTITY from "@salesforce/label/c.REBATE_QUANTITY";
import REBATE_ACTION from "@salesforce/label/c.REBATE_ACTION";
import REBATE_ADD_ACTION from "@salesforce/label/c.REBATE_ADD_ACTION";
import REBATE_REMOVE_ACTION from "@salesforce/label/c.REBATE_REMOVE_ACTION";
import QUANTITY_ERRROR_MESSAGE from "@salesforce/label/c.QUANTITY_ERRROR_MESSAGE";
import MAX_QUANTITY_ERRROR_MESSAGE from "@salesforce/label/c.MAX_QUANTITY_ERRROR_MESSAGE";

export default class RebateItemSelection extends LightningElement {
  @api selectedCampaign;
  @api relatedRebateItems;
  @track availableRebateItems = [];
  @track selectedRebateItems = [];
  @api existingSelectedRebateItems;

  isRendered = false;

  labels = {
    SELECTED_REBATE_ITEMS,
    AVAILABLE_REBATE_ITEMS,
    REBATE_SKU,
    REBATE_DESCRIPTION,
    REBATE_MAX_QUANTITY,
    REBATE_AMOUNT,
    REBATE_QUANTITY,
    REBATE_ACTION,
    REBATE_ADD_ACTION,
    REBATE_REMOVE_ACTION,
    QUANTITY_ERRROR_MESSAGE,
    MAX_QUANTITY_ERRROR_MESSAGE
  };

  connectedCallback() {
    this.availableRebateItems = JSON.parse(
      JSON.stringify(this.relatedRebateItems)
    );
    for (let availableRebateItem of this.availableRebateItems) {
      availableRebateItem.isQuantityDisabled = false;
    }
  }

  /**This function will handle Back button action from Rebate Items Confirmation Screen*/
  renderedCallback() {
    if (
      this.existingSelectedRebateItems &&
      this.existingSelectedRebateItems.length > 0 &&
      !this.isRendered
    ) {
      this.isRendered = true;
      this.selectedRebateItems = JSON.parse(
        JSON.stringify(this.existingSelectedRebateItems)
      );
      this.handleAddButton();
      this.handleSelectedRIQuantityValid();
    }
  }

  /**This function will handle quantity change based on user input*/
  handleQuantityChange(event) {
    let rebateItemId = event.currentTarget.dataset.rebateitemid;
    let rebateItemRow = this.template.querySelector(
      '[data-rebateitemid="' + rebateItemId + '"]'
    );
    this.removeCustomError(rebateItemRow);
  }

  /**This function will handle Add action for selected rebate item*/
  handleAddRebateItem(event) {
    let rebateItemId = event.currentTarget.dataset.rebateid;
    let rebateItemRow = this.template.querySelector(
      '[data-rebateitemid="' + rebateItemId + '"]'
    );
    this.handleRebateItemValidation(rebateItemId, rebateItemRow, false);
  }

  /**This function will handle updates of rebate item quantity*/
  handleRebateItemValidation(
    rebateItemId,
    rebateItemRow,
    isEditFromSelectedRI
  ) {
    if (rebateItemRow) {
      /**Quantity 0 or empty check */
      if (!rebateItemRow.value || rebateItemRow.value == 0) {
        this.setCustomError(rebateItemRow, this.labels.QUANTITY_ERRROR_MESSAGE);
      } else if (rebateItemRow.value) {
        /**Checking in already selected rebate items list*/
        if (this.selectedRebateItems.length > 0) {
          let rebateItem = this.selectedRebateItems.find((rI) => {
            return rI.rebateItemId == rebateItemId;
          });
          let rebateItemtoBeUpdated = rebateItem
            ? JSON.parse(JSON.stringify(rebateItem))
            : null;
          if (rebateItemtoBeUpdated) {
            let updatedRebateItemQuantity;
            if (isEditFromSelectedRI) {
              updatedRebateItemQuantity = parseInt(rebateItemRow.value);
            } else {
              updatedRebateItemQuantity =
                parseInt(rebateItemRow.value) +
                parseInt(rebateItemtoBeUpdated.rebateQuantity);
            }

            if (
              rebateItemtoBeUpdated.maximumRebateQuantity <
              updatedRebateItemQuantity
            ) {
              this.setCustomError(
                rebateItemRow,
                this.labels.MAX_QUANTITY_ERRROR_MESSAGE +
                  rebateItemtoBeUpdated.maximumRebateQuantity
              );
            } else {
              for (let selectedRebateItem of this.selectedRebateItems) {
                if (selectedRebateItem.rebateItemId == rebateItemId) {
                  selectedRebateItem.rebateQuantity = updatedRebateItemQuantity;
                  selectedRebateItem.editSelectedQuantity = false;
                  break;
                }
              }
              this.removeCustomError(rebateItemRow);
              this.handleSelectedRebateItemsToParent();
            }
          } else {
            this.handleSelectedRebateItem(rebateItemId, rebateItemRow);
          }
        } else {
          this.handleSelectedRebateItem(rebateItemId, rebateItemRow);
        }
      }
    }
  }

  /**This function will disable Add button once User adds rebate quantity*/
  handleAddButton() {
    for (let availableRebateItem of this.availableRebateItems) {
      let isItemSelected = this.selectedRebateItems.find((sRI) => {
        return sRI.rebateItemId == availableRebateItem.rebateItemId;
      });
      availableRebateItem.isQuantityDisabled = isItemSelected ? true : false;
    }
  }

  /**This function will add selected rebate item to  selectedRebateItems list*/
  handleSelectedRebateItem(rebateItemId, rebateItemRow) {
    let rebateItemtoBeAdded = JSON.parse(
      JSON.stringify(
        this.relatedRebateItems.find((rI) => {
          return rI.rebateItemId == rebateItemId;
        })
      )
    );

    if (
      rebateItemtoBeAdded &&
      rebateItemtoBeAdded.maximumRebateQuantity >= rebateItemRow.value
    ) {
      rebateItemtoBeAdded.rebateQuantity = parseInt(rebateItemRow.value);
      rebateItemtoBeAdded.editSelectedQuantity = false;
      this.selectedRebateItems.push(rebateItemtoBeAdded);
      this.handleAddButton();
      this.handleSelectedRebateItemsToParent();
      rebateItemRow.value = 0;
    } else {
      this.setCustomError(
        rebateItemRow,
        this.labels.MAX_QUANTITY_ERRROR_MESSAGE +
          rebateItemtoBeAdded.maximumRebateQuantity
      );
    }
  }

  /**This function will enable user to edit Rebate Item Quantity of Selected RI*/
  handleEditSelectedQuantity(event) {
    let rebateItemId = event.currentTarget.dataset.editrebateitemid;

    for (let selectedRebateItem of this.selectedRebateItems) {
      if (selectedRebateItem.rebateItemId == rebateItemId) {
        selectedRebateItem.editSelectedQuantity = true;
        break;
      }
    }

    setTimeout(() => {
      let rebateItemRow = this.template.querySelector(
        '[data-selrebateitemid="' + rebateItemId + '"]'
      );
      rebateItemRow?.focus();
    }, 200);
  }

  /**This function will update Rebate Item Quantity of Selected RI after successful validation*/
  handleSelectedQuantityChange(event) {
    let rebateItemId = event.currentTarget.dataset.selrebateitemid;
    let rebateItemRow = this.template.querySelector(
      '[data-selrebateitemid="' + rebateItemId + '"]'
    );
    this.handleRebateItemValidation(rebateItemId, rebateItemRow, true);
    this.handleSelectedRIQuantityValid();
  }

  /**This function will remove current rebate item from  selected rebate items list*/
  handleRemoveRebateItem(event) {
    let rebateItemId = event.currentTarget.dataset.rebateid;
    this.selectedRebateItems = this.selectedRebateItems.filter((rI) => {
      return rI.rebateItemId != rebateItemId;
    });
    this.handleAddButton();
    this.handleSelectedRebateItemsToParent();
  }

  /**This function will add Error Messages of passed cell*/
  setCustomError(rebateItemRow, errorMessage) {
    if (rebateItemRow) {
      rebateItemRow.setCustomValidity(errorMessage);
      rebateItemRow.reportValidity();
    }
  }

  /**This function will remove Error Messages of passed cell*/
  removeCustomError(rebateItemRow) {
    if (rebateItemRow) {
      rebateItemRow.setCustomValidity("");
      rebateItemRow.reportValidity();
    }
  }

  /**This function will fire custom event to pass selected rebate items to parent*/
  handleSelectedRebateItemsToParent() {
    let custEvent = new CustomEvent("selectedrebateitems", {
      detail: {
        selectedRebateItems: this.selectedRebateItems
      }
    });
    this.dispatchEvent(custEvent);
  }

  /*
   *   This method is used to check if all the input RI Quantityfields
   *   that we need to validate are valid or not.
   */
  handleSelectedRIQuantityValid() {
    let isRIQuantityValidated = true;
    let inputFields = this.template.querySelectorAll(".selectedRIQuantity");
    inputFields.forEach((inputField) => {
      if (!inputField.checkValidity()) {
        inputField.reportValidity();
        isRIQuantityValidated = false;
      }
    });

    let custEvent = new CustomEvent("selectedriquantity", {
      detail: {
        isRIQuantityValidated: isRIQuantityValidated
      }
    });
    this.dispatchEvent(custEvent);
  }
}