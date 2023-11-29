import { LightningElement, api } from 'lwc';
/**Custom Labels */
import CAMPAIGN_START_DATE from '@salesforce/label/c.CAMPAIGN_START_DATE';
import CAMPAIGN_END_DATE from '@salesforce/label/c.CAMPAIGN_END_DATE';
import CAMPAIGN_SUB_START_DATE from '@salesforce/label/c.CAMPAIGN_SUB_START_DATE';
import CAMPAIGN_SUB_END_DATE from '@salesforce/label/c.CAMPAIGN_SUB_END_DATE';

export default class CampaignItemCard extends LightningElement {
    @api cardData;
    selectedCampaignId;
    @api existingCampaignId;
    isRendered = false;

    labels = {
        CAMPAIGN_START_DATE,
        CAMPAIGN_END_DATE,
        CAMPAIGN_SUB_START_DATE,
        CAMPAIGN_SUB_END_DATE
    }

    /**This function will handle Back button action from Rebate Items Selection Screen*/
    renderedCallback(){
        if(this.existingCampaignId && !this.isRendered){
            this.isRendered = true;
            this.handleCampaignCardStyle(this.existingCampaignId);
        }
    }
  
    handleSelectedCampaign(event) {
        this.handleCampaignCardStyle(event.currentTarget.dataset.campid);
    }

    /**This function will update the CSS of selected Campaign Card and calls handleSelectedCampaignToParent()*/
    handleCampaignCardStyle(campaignId) {
        let selectedCard = this.template.querySelector('[data-campid="' + campaignId + '"]');
        let existingSelectedCampaign = this.template.querySelector('.selected-campaign');
        existingSelectedCampaign ? existingSelectedCampaign.classList.remove('selected-campaign') : '';
        if (campaignId && campaignId != this.selectedCampaignId) {
            this.selectedCampaignId = campaignId;
            if (selectedCard) {
                selectedCard.classList.add('selected-campaign');
                this.handleSelectedCampaignToParent();
            }
        } else if (campaignId == this.selectedCampaignId) {
            if (selectedCard) {
                this.selectedCampaignId = null;
                this.handleSelectedCampaignToParent()
            }
        }
    }

    /**This function will fire custom event to pass selected campaign id to parent */
    handleSelectedCampaignToParent() {
        let custEvent = new CustomEvent('selectedcampaign', {
            detail: {
                'selectedCampaignId': this.selectedCampaignId
            }
        });
        this.dispatchEvent(custEvent);
    }
}