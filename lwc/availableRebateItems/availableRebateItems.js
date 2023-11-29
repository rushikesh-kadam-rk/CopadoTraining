import { LightningElement, wire, api, track } from "lwc";
import { getRecord } from "lightning/uiRecordApi";
import { CloseActionScreenEvent } from "lightning/actions";
/**This is specific to override Modal Width CSS*/
import rebateSubmissionQuickActionCSS from "@salesforce/resourceUrl/rebateSubmissionQuickActionCSS";
import { loadStyle } from "lightning/platformResourceLoader";
/**Apex Methods */
import fetchRelevantCampaigns from "@salesforce/apex/RebateSubmissionService.fetchRelevantCampaigns";
import fetchRebateItemsByCampaignIds from "@salesforce/apex/RebateSubmissionService.fetchRebateItemsByCampaignIds";
import createCaseWithCRP from "@salesforce/apex/RebateSubmissionService.createCaseWithCRP";
/**Custom Labels */
import REBATES_LIST from "@salesforce/label/c.REBATES_LIST";
import SELECT_REBATE from "@salesforce/label/c.SELECT_REBATE";
import NO_REBATE_ITEMS_MESSAGE from "@salesforce/label/c.NO_REBATE_ITEMS_MESSAGE";
import NO_RELATED_RI_MESSAGE from "@salesforce/label/c.NO_RELATED_RI_MESSAGE";
import NEXT_BUTTON from "@salesforce/label/c.NEXT_BUTTON";
import CANCEL_BUTTON from "@salesforce/label/c.CANCEL_BUTTON";
import CLOSE_BUTTON from "@salesforce/label/c.CLOSE_BUTTON";
import BACK_BUTTON from "@salesforce/label/c.BACK_BUTTON";
import SUBMIT_BUTTON from "@salesforce/label/c.SUBMIT_BUTTON";
import SUBMISSION_COMPLETED from "@salesforce/label/c.SUBMISSION_COMPLETED";
import SUBMISSION_FAILED from "@salesforce/label/c.SUBMISSION_FAILED";
import SUBMISSION_INPROGRESS from "@salesforce/label/c.SUBMISSION_INPROGRESS";

const ACCOUNT_FIELDS = [
  "Account.Id",
  "Account.Name",
  "Account.Buying_Group_Member__c"
];
export default class AvailableRebateItems extends LightningElement {
  @api recordId;
  existingCampaignId;
  @track selectedCampaign = [];
  @track confirmedRebateItems = [];
  totalEstimatedRebateCredit;
  isInitiazed = false;
  currentAccountRecord;
  relatedCampaigns;
  @track campaignCardData = [];
  relatedRebateItems;
  rebateItemsAvailable = false;
  showRelatedCampaigns = false;
  showRebateItemsSelection = false;
  noRebateItemMessage = false;
  isRIQuantityValidated = true;
  isRebateItemsSubmitted = false;
  isSubmissionCompleted = false;
  isSubmissionFailed = false;
  submissionError = "";
  labels = {
    REBATES_LIST,
    SELECT_REBATE,
    NO_REBATE_ITEMS_MESSAGE,
    NO_RELATED_RI_MESSAGE,
    NEXT_BUTTON,
    CANCEL_BUTTON,
    BACK_BUTTON,
    CLOSE_BUTTON,
    SUBMIT_BUTTON,
    SUBMISSION_COMPLETED,
    SUBMISSION_FAILED,
    SUBMISSION_INPROGRESS
  };

  /**This is specific to override Modal Width CSS */
  connectedCallback() {
    Promise.all([loadStyle(this, rebateSubmissionQuickActionCSS)]);
  }

  /**This getter will return a Rebate Submission Popup Header */
  get rebateSubmissionHeader() {
    return this.labels.REBATES_LIST;
  }

  /**This getter will return whether Rebate Item is selected or not */
  get isCampaignSelected() {
    return this.selectedCampaign.length ? false : true;
  }

  /**This getter will check conditions to disable next button */
  get isNextButtonDisabled() {
    if (this.showRelatedCampaigns) {
      return this.selectedCampaign.length ? false : true;
    } else if (this.showRebateItemsSelection) {
      return this.confirmedRebateItems.length && this.isRIQuantityValidated
        ? false
        : true;
    } else {
      return true;
    }
  }

  /**This getter will check conditions to disable close button */
  get isCloseButtonDisabled() {
    return this.isSubmissionCompleted || this.isSubmissionFailed ? false : true;
  }

  /**This getter will control Next Button visibility */
  get nextButtonVisibility() {
    return this.showRelatedCampaigns || this.showRebateItemsSelection;
  }

  /**This getter will control Back Button visibility */
  get backButtonVisibility() {
    return (
      this.showRebateItemsSelection ||
      this.noRebateItemMessage ||
      this.showRebateConfirmation
    );
  }

  /**This wire call will get current Account Record Details */
  @wire(getRecord, { recordId: "$recordId", fields: ACCOUNT_FIELDS })
  getAccountDetails({ error, data }) {
    if (data) {
      this.currentAccountRecord = data.fields;
      this.getMatchingCampaigns();
    } else {
      this.error = error;
    }
  }

  /**This function will make an apex call to retrieve Campaings matching  Buying_Group_Member__c */
  getMatchingCampaigns() {
    if (
      this.currentAccountRecord.Buying_Group_Member__c &&
      this.currentAccountRecord.Buying_Group_Member__c.value
    ) {
      fetchRelevantCampaigns({
        buyingGroupMembers:
          this.currentAccountRecord.Buying_Group_Member__c.value
      })
        .then((result) => {
          if (result && result.length) {
            this.relatedCampaigns = result;
            this.rebateItemsAvailable = true;
            this.showRelatedCampaigns = true;
            this.isInitiazed = true;
          } else {
            this.rebateItemsAvailable = false;
            this.isInitiazed = true;
          }
        })
        .catch((error) => {
          console.error(error);
        });
    } else {
      this.rebateItemsAvailable = false;
      this.isInitiazed = true;
    }
  }

  /**This function will retrieve related Rebate Items along with data */
  getRelatedRebateItems() {
    this.isInitiazed = false;
    let campaignIdList = this.selectedCampaign.map((val) => {
      return val.campaignId;
    });
    fetchRebateItemsByCampaignIds({ campaignIdList: campaignIdList })
      .then((result) => {
        if (result && result.length) {
          this.relatedRebateItems = result;
          this.showRelatedCampaigns = false;
          this.showRebateItemsSelection = true;
          this.noRebateItemMessage = false;
        } else {
          this.showRelatedCampaigns = false;
          this.showRebateItemsSelection = false;
          this.noRebateItemMessage = true;
        }
        this.isInitiazed = true;
      })
      .catch((error) => {
        console.error(error);
        this.isInitiazed = true;
      });
  }

  /**This function will store the selected Campaign */
  handleSelectedCampaign(event) {
    if (!event.detail.selectedCampaignId) {
      this.selectedCampaign = [];
    } else {
      this.selectedCampaign = this.relatedCampaigns.filter(
        (selectedCampaign) => {
          return selectedCampaign.campaignId == event.detail.selectedCampaignId;
        }
      );
    }
  }

  handleSelRIQuantityValidation(event) {
    this.isRIQuantityValidated = event.detail.isRIQuantityValidated;
  }

  /**This function will store selected rebate items from rebate items list screen */
  handleSelectedRebateItems(event) {
    let rebateItems = event.detail.selectedRebateItems;
    if (!rebateItems) {
      this.confirmedRebateItems = [];
      this.totalEstimatedRebateCredit = 0;
    } else {
      this.confirmedRebateItems = rebateItems.map((selectedRebateItem) => ({
        ...selectedRebateItem,
        estimatedRebateCredit:
          selectedRebateItem.rebateAmount * selectedRebateItem.rebateQuantity
      }));
      this.calculateTotalEstimatedRebateCredit();
    }
  }

  /**This function will handle Next button navigation */
  handleNextScreen() {
    if (this.showRelatedCampaigns) {
      if (this.existingCampaignId != this.selectedCampaign[0].campaignId) {
        this.confirmedRebateItems = [];
        this.totalEstimatedRebateCredit = 0;
      }
      this.getRelatedRebateItems();
    } else if (this.showRebateItemsSelection) {
      this.showRebateItemsSelection = false;
      this.showRebateConfirmation = true;
    }
  }

  /**This function will handle Back button navigation */
  handleBackScreen() {
    if (this.showRebateItemsSelection || this.noRebateItemMessage) {
      this.existingCampaignId = this.selectedCampaign[0].campaignId;
      this.showRebateItemsSelection = false;
      this.showRelatedCampaigns = true;
      this.noRebateItemMessage = false;
    } else if (this.showRebateConfirmation) {
      this.showRebateConfirmation = false;
      this.getRelatedRebateItems();
    }
  }

  /**This function will handle Submit button action */
  handleSubmitRebateItems() {
    //create case
    this.showRelatedCampaigns = false;
    this.showRebateItemsSelection = false;
    this.noRebateItemMessage = false;
    this.showRebateConfirmation = false;
    this.isRebateItemsSubmitted = true;

    createCaseWithCRP({
      accId: this.recordId,
      accName: this.currentAccountRecord.Name.value,
      selectedCampaign: this.selectedCampaign,
      confirmedRI: this.confirmedRebateItems,
      finalRefundAmount: this.totalEstimatedRebateCredit
    })
      .then((result) => {
        if (result) {
          this.isSubmissionCompleted = true;
        }
      })
      .catch((error) => {
        this.isSubmissionFailed = true;
        this.submissionError = error.body.message;
        console.error(error);
      });
  }

  /**This function will calculate Total Estimated Rebate Credit */
  calculateTotalEstimatedRebateCredit() {
    this.totalEstimatedRebateCredit = this.confirmedRebateItems.reduce(
      (totalERC, confirmedRebateItem) => {
        return totalERC + confirmedRebateItem.estimatedRebateCredit;
      },
      0
    );
  }

  /**This function will close the Modal */
  closeModal() {
    this.dispatchEvent(new CloseActionScreenEvent());
  }
}