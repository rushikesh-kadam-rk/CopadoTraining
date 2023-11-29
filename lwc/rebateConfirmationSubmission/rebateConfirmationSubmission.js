import { LightningElement, api } from "lwc";
/**Custom Labels */
import REBATE_SKU from "@salesforce/label/c.REBATE_SKU";
import REBATE_DESCRIPTION from "@salesforce/label/c.REBATE_DESCRIPTION";
import REBATE_MAX_QUANTITY from "@salesforce/label/c.REBATE_MAX_QUANTITY";
import REBATE_AMOUNT from "@salesforce/label/c.REBATE_AMOUNT";
import REBATE_QUANTITY from "@salesforce/label/c.REBATE_QUANTITY";
import REBATE_ESTIMATED_CREDIT from "@salesforce/label/c.REBATE_ESTIMATED_CREDIT";
import REBATE_TOTAL_EST_CREDIT from "@salesforce/label/c.REBATE_TOTAL_EST_CREDIT";

export default class RebateConfirmationSubmission extends LightningElement {
  @api confirmedRebateItems;
  isRendered = false;
  totalEstimatedRebateCredit;
  campaignCurrency;

  labels = {
    REBATE_SKU,
    REBATE_DESCRIPTION,
    REBATE_MAX_QUANTITY,
    REBATE_AMOUNT,
    REBATE_QUANTITY,
    REBATE_ESTIMATED_CREDIT,
    REBATE_TOTAL_EST_CREDIT
  };

  renderedCallback() {
    if (
      this.confirmedRebateItems &&
      this.confirmedRebateItems.length > 0 &&
      !this.isRendered
    ) {
      this.isRendered = true;
      this.canculateTotalEstimatedRebateCredit();
    }
  }

  /**This function will calculate Total Estimated Rebate Credit */
  canculateTotalEstimatedRebateCredit() {
    this.totalEstimatedRebateCredit = this.confirmedRebateItems.reduce(
      (totalERC, confirmedRebateItem) => {
        return totalERC + confirmedRebateItem.estimatedRebateCredit;
      },
      0
    );
    this.campaignCurrency = this.confirmedRebateItems[0].campaignCurrency;
  }
}