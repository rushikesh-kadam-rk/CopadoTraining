/*
 * @Class		: RebateSubmissionService
 * @Author		:
 * @Description	:
 * @CreatedDate  :
 */

public with sharing class RebateSubmissionService {
  public static final String DEALER_REBATE_CAMPAIGN = 'Dealer_Rebate';
  public static final String SALES_OPS_QUEUE = 'Sales_Ops';

  /*
    **********************************************************************************
    @Method Name    : fetchRelevantCampaigns
    @author         : 
    @description    : Method is used to fetch the relevant campaigns for the given Buying Group Member.
    @param          : buyingGroupMember
    @return         : List of Relevant Campaigns 
    **********************************************************************************
    */
  @AuraEnabled(cacheable=true)
  public static List<CampaignListWrapper> fetchRelevantCampaigns(
    String buyingGroupMembers
  ) {
    try {
      Date currentDate = Date.today();
      /**Creating a List of Buying Group Members*/
      List<String> buyingGroupMembersList = buyingGroupMembers.split(';');
      List<CampaignListWrapper> campaignWrapperList = new List<CampaignListWrapper>();
      List<Campaign> campaignList = [
        SELECT
          Id,
          Name,
          StartDate,
          EndDate,
          CurrencyISOCode,
          Submission_Start_Date__c,
          Submission_End_Date__c
        FROM Campaign
        WHERE
          RecordType.DeveloperName = :DEALER_REBATE_CAMPAIGN
          AND Buying_Group_Member__c IN :buyingGroupMembersList
          AND Submission_Start_Date__c <= :currentDate
          AND Submission_End_Date__c >= :currentDate
        ORDER BY Submission_Start_Date__c
      ];

      if (!campaignList.isEmpty()) {
        for (Campaign campaignItem : campaignList) {
          CampaignListWrapper campaignWrapper = new CampaignListWrapper();
          campaignWrapper.campaignId = campaignItem.Id;
          campaignWrapper.campaignName = campaignItem.Name;
          campaignWrapper.campaignStartDate = campaignItem.StartDate;
          campaignWrapper.campaignEndDate = campaignItem.EndDate;
          campaignWrapper.campaignSubmissionStartDate = campaignItem.Submission_Start_Date__c;
          campaignWrapper.campaignSubmissionEndDate = campaignItem.Submission_End_Date__c;
          campaignWrapperList.add(campaignWrapper);
        }
        return campaignWrapperList;
      }
      return null;
    } catch (Exception e) {
      throw new AuraHandledException('Error: ' + e.getMessage());
    }
  }

  /*
    **********************************************************************************
    @Method Name    : fetchRebateItemsByCampaignIds
    @author         : 
    @description    : Method is used to fetch rebate items associated with the given campaigns.
    @param          : campaignIdList
    @return         : List of Relevant Rebate Items with Campaign Record Values 
    **********************************************************************************
    */
  /**This method will be used for next screens*/
  @AuraEnabled(cacheable=true)
  public static List<RebateItemListWrapper> fetchRebateItemsByCampaignIds(
    List<Id> campaignIdList
  ) {
    try {
      //this query can be modified based on required fields we need to retrieve
      List<RebateItemListWrapper> rebateItemWrapperList = new List<RebateItemListWrapper>();
      List<Rebate_Item__c> rebateItemList = [
        SELECT
          Id,
          Name,
          Product__c,
          Product__r.Name,
          Product_Description__c,
          Maximum_Rebate_Quantity__c,
          Rebate_Amount__c,
          Campaign__r.CurrencyISOCode
        FROM Rebate_Item__c
        WHERE Campaign__c IN :campaignIdList
      ];
      if (!rebateItemList.isEmpty()) {
        for (Rebate_Item__c rebateItem : rebateItemList) {
          RebateItemListWrapper rebateItemWrapper = new RebateItemListWrapper();
          rebateItemWrapper.rebateItemId = rebateItem.Id;
          rebateItemWrapper.productId = rebateItem.Product__c;
          rebateItemWrapper.rebateItemSKU = rebateItem.Product__r?.Name;
          rebateItemWrapper.rebateItemDescription = rebateItem.Product_Description__c;
          rebateItemWrapper.maximumRebateQuantity = Integer.valueOf(
            rebateItem.Maximum_Rebate_Quantity__c
          );
          rebateItemWrapper.rebateAmount = rebateItem.Rebate_Amount__c;
          rebateItemWrapper.rebateQuantity = 0;
          rebateItemWrapper.campaignCurrency = rebateItem.Campaign__r.CurrencyISOCode;
          rebateItemWrapper.rebateItemProductId = rebateItem.Product__c;
          rebateItemWrapperList.add(rebateItemWrapper);
        }
        return rebateItemWrapperList;
      }
      return null;
    } catch (Exception e) {
      throw new AuraHandledException(e.getMessage());
    }
  }

  /*
    **********************************************************************************
    @Method Name    : createCaseWithCRP
    @author         : 
    @description    : Method is used to create RFC Case with Case Replacement Products.
    @param          : accId, accName, selectedCampaign, confirmedRI, finalRefundAmount
    @return         : 
    **********************************************************************************
    */
  /**This method will be used for next screens*/
  @AuraEnabled
  public static Boolean createCaseWithCRP(
    String accId,
    String accName,
    List<CampaignListWrapper> selectedCampaign,
    List<RebateItemListWrapper> confirmedRI,
    Decimal finalRefundAmount
  ) {
    try {
      Group salesOpsQueue = getSalesOpsQueue(SALES_OPS_QUEUE);
      /**Creating RFC Case Record */
      Case rFCCase = new Case();
      rFCCase.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName()
        .get('RFC')
        .getRecordTypeId();
      rFCCase.Subject = selectedCampaign[0]?.campaignName + ' - ' + accName;
      if (salesOpsQueue != null) {
        rFCCase.OwnerId = salesOpsQueue.Id;
      }
      rFCCase.AccountId = accId;
      rFCCase.Status = 'AR Review';
      rFCCase.Refund_Request_Date__c = System.today();
      rFCCase.Type = 'Discount';
      rFCCase.Final_Refund_Amount__c = finalRefundAmount;
      rFCCase.CurrencyIsoCode = confirmedRI != null
        ? confirmedRI[0].campaignCurrency
        : 'USD';
      Database.insert(rFCCase);
      /**Creating Related CRP Records */
      List<CaseReplacementProduct__c> cRPToBeInserted = new List<CaseReplacementProduct__c>();
      if (confirmedRI != null) {
        for (RebateItemListWrapper ri : confirmedRI) {
          CaseReplacementProduct__c cRP = new CaseReplacementProduct__c();
          cRP.Product__c = ri.productId;
          cRP.Unit_Price__c = ri.rebateAmount;
          cRP.Quantity__c = ri.rebateQuantity;
          cRP.Product_Description__c = ri.rebateItemDescription;
          //cRP.Total_Amount__c = ri.rebateAmount*ri.rebateQuantity;
          cRP.Case__c = rFCCase.Id;
          cRP.CurrencyISOCode = ri.campaignCurrency;
          cRPToBeInserted.add(cRP);
        }
        if (!cRPToBeInserted.isEmpty()) {
          Database.insert(cRPToBeInserted);
          return true;
        }
      }

      return null;
    } catch (Exception e) {
      throw new AuraHandledException('Error: ' + e.getMessage());
    }
  }

  /*
    **********************************************************************************
    @Method Name    : getSalesOpsQueue
    @author         : 
    @description    : Method is used to fetch the Sales_Ops Queue.
    @param          : queueName
    @return         : Sales_Ops Queue is present
    **********************************************************************************
    */
  public static Group getSalesOpsQueue(String queueName) {
    List<Group> salesOpsQueue = [
      SELECT Id, DeveloperName
      FROM Group
      WHERE Type = 'Queue' AND DeveloperName = :queueName
    ];
    if (salesOpsQueue != null && !salesOpsQueue.isEmpty()) {
      return salesOpsQueue[0];
    }
    return null;
  }

  /**This wrapper class will store field values related to Rebate Items*/
  public class CampaignListWrapper {
    @AuraEnabled
    public String campaignId { get; set; }
    @AuraEnabled
    public String campaignName { get; set; }
    @AuraEnabled
    public Date campaignStartDate { get; set; }
    @AuraEnabled
    public Date campaignEndDate { get; set; }
    @AuraEnabled
    public Date campaignSubmissionStartDate { get; set; }
    @AuraEnabled
    public Date campaignSubmissionEndDate { get; set; }
  }

  /**This wrapper class will store field values related to Rebate Items*/
  public class RebateItemListWrapper {
    @AuraEnabled
    public Id rebateItemId { get; set; }
    @AuraEnabled
    public Id productId { get; set; }
    @AuraEnabled
    public String rebateItemSKU { get; set; }
    @AuraEnabled
    public String rebateItemDescription { get; set; }
    @AuraEnabled
    public Integer maximumRebateQuantity { get; set; }
    @AuraEnabled
    public Double rebateAmount { get; set; }
    @AuraEnabled
    public Integer rebateQuantity { get; set; }
    @AuraEnabled
    public String campaignCurrency { get; set; }
    @AuraEnabled
    public Id rebateItemProductId { get; set; }
  }
}