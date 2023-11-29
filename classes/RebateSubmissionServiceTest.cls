/*
 * @Class		: RebateSubmissionServiceTest
 * @Author		:
 * @Description	: Test Class for RebateSubmissionService
 * @CreatedDate  : 08/29/2023
 */
@isTest(SeeAllData=false)
private class RebateSubmissionServiceTest {
  /**This test method will cover fetchRelevantCampaignsPositive for positive scenario*/
  @isTest
  static void testFetchRelevantCampaignsPositive() {
    String buyingGroupMember = 'BrandSource';
    Campaign testCampaignOne = TestDataFactory.createCampaign(
      buyingGroupMember
    );
    Campaign testCampaignTwo = TestDataFactory.createCampaign(
      buyingGroupMember
    );
    Campaign testCampaignThree = TestDataFactory.createCampaign(
      buyingGroupMember
    );
    List<Campaign> testCampaignList = new List<Campaign>();
    testCampaignList.add(testCampaignOne);
    testCampaignList.add(testCampaignTwo);
    testCampaignList.add(testCampaignThree);
    insert testCampaignList;

    Test.startTest();
    List<RebateSubmissionService.CampaignListWrapper> relevantCampaigns = RebateSubmissionService.fetchRelevantCampaigns(
      buyingGroupMember
    );
    List<RebateSubmissionService.CampaignListWrapper> relevantEmptyCampaigns = RebateSubmissionService.fetchRelevantCampaigns(
      'Cantrex'
    );
    Test.stopTest();

    System.assertEquals(3, relevantCampaigns.size());
    System.assertEquals(
      testCampaignOne.Buying_Group_Member__c,
      buyingGroupMember
    );
    System.assertEquals(null, relevantEmptyCampaigns);
  }

  /**This test method will cover fetchRelevantCampaignsPositive for exception*/
  @isTest
  static void testFetchRelevantCampaignsNegative() {
    String buyingGroupMember = 'BrandSource';
    Campaign testCampaign = TestDataFactory.createCampaign(buyingGroupMember);
    insert testCampaign;

    Test.startTest();
    try {
      List<RebateSubmissionService.CampaignListWrapper> relevantCampaigns = RebateSubmissionService.fetchRelevantCampaigns(
        null
      );
    } catch (AuraHandledException ex) {
      System.assertEquals('Script-thrown exception', ex.getMessage());
    }
    Test.stopTest();
  }

  /**This test method will cover fetchRebateItemsByCampaignIds for positive scenario*/
  @isTest
  static void testFetchRebateItemsByCampaignIds() {
    String buyingGroupMember = 'BrandSource';
    Campaign testCampaign = TestDataFactory.createCampaign(buyingGroupMember);
    insert testCampaign;

    Rebate_Item__c testRebateItemOne = TestDataFactory.createRebateItemWithoutCampaign();
    testRebateItemOne.Campaign__c = testCampaign.Id;
    Rebate_Item__c testRebateItemTwo = TestDataFactory.createRebateItemWithoutCampaign();
    testRebateItemTwo.Campaign__c = testCampaign.Id;
    Rebate_Item__c testRebateItemThree = TestDataFactory.createRebateItemWithoutCampaign();
    testRebateItemThree.Campaign__c = testCampaign.Id;
    Rebate_Item__c testRebateItemFour = TestDataFactory.createRebateItemWithoutCampaign();
    testRebateItemFour.Campaign__c = testCampaign.Id;

    List<Rebate_Item__c> testRebateItemList = new List<Rebate_Item__c>();
    testRebateItemList.add(testRebateItemOne);
    testRebateItemList.add(testRebateItemTwo);
    testRebateItemList.add(testRebateItemThree);
    testRebateItemList.add(testRebateItemFour);
    insert testRebateItemList;

    Test.startTest();
    List<RebateSubmissionService.RebateItemListWrapper> rebateItems = RebateSubmissionService.fetchRebateItemsByCampaignIds(
      new List<Id>{ testCampaign.Id }
    );
    Test.stopTest();

    System.assertEquals(4, rebateItems.size());
  }

  /**This test method will cover fetchRebateItemsByCampaignIds when there are no related rebate items */
  @isTest
  static void testFetchRebateItemsByCampaignIdsNegativeOne() {
    String buyingGroupMember = 'BrandSource';
    Campaign testCampaignOne = TestDataFactory.createCampaign(
      buyingGroupMember
    );
    insert testCampaignOne;
    Campaign testCampaignTwo = TestDataFactory.createCampaign(
      buyingGroupMember
    );
    insert testCampaignTwo;

    Rebate_Item__c testRebateItem = TestDataFactory.createRebateItemWithoutCampaign();
    testRebateItem.Campaign__c = testCampaignOne.Id;
    insert testRebateItem;

    Test.startTest();
    List<RebateSubmissionService.RebateItemListWrapper> rebateItems = RebateSubmissionService.fetchRebateItemsByCampaignIds(
      new List<Id>{ testCampaignTwo.Id }
    );
    Test.stopTest();

    System.assertEquals(null, rebateItems);
  }

  /**This test method will cover fetchRebateItemsByCampaignIds for exception*/
  @isTest
  static void testFetchRebateItemsByCampaignIdsNegativeTwo() {
    String buyingGroupMember = 'BrandSource';
    Campaign testCampaignOne = TestDataFactory.createCampaign(
      buyingGroupMember
    );
    insert testCampaignOne;
    Campaign testCampaignTwo = TestDataFactory.createCampaign(
      buyingGroupMember
    );
    insert testCampaignTwo;

    Rebate_Item__c testRebateItem = TestDataFactory.createRebateItemWithoutCampaign();
    testRebateItem.Campaign__c = testCampaignOne.Id;
    insert testRebateItem;

    Test.startTest();
    try {
      List<RebateSubmissionService.RebateItemListWrapper> rebateItems = RebateSubmissionService.fetchRebateItemsByCampaignIds(
        null
      );
    } catch (AuraHandledException ex) {
      System.assertEquals('Script-thrown exception', ex.getMessage());
    }
    Test.stopTest();
  }

  /**This test method will cover createCaseWithCRP for positive scenario*/
  @isTest
  static void testcreateCaseWithCRPPositive() {
    Account testAccount = new Account();

    String buyingGroupMember = 'BrandSource';
    Campaign testCampaign = TestDataFactory.createCampaign(buyingGroupMember);
    insert testCampaign;

    Rebate_Item__c testRebateItemOne = TestDataFactory.createRebateItemWithoutCampaign();
    testRebateItemOne.Campaign__c = testCampaign.Id;
    Rebate_Item__c testRebateItemTwo = TestDataFactory.createRebateItemWithoutCampaign();
    testRebateItemTwo.Campaign__c = testCampaign.Id;
    Rebate_Item__c testRebateItemThree = TestDataFactory.createRebateItemWithoutCampaign();
    testRebateItemThree.Campaign__c = testCampaign.Id;
    Rebate_Item__c testRebateItemFour = TestDataFactory.createRebateItemWithoutCampaign();
    testRebateItemFour.Campaign__c = testCampaign.Id;

    List<Rebate_Item__c> testRebateItemList = new List<Rebate_Item__c>();
    testRebateItemList.add(testRebateItemOne);
    testRebateItemList.add(testRebateItemTwo);
    testRebateItemList.add(testRebateItemThree);
    testRebateItemList.add(testRebateItemFour);
    insert testRebateItemList;

    Test.startTest();
    List<RebateSubmissionService.CampaignListWrapper> relevantCampaigns = RebateSubmissionService.fetchRelevantCampaigns(
      buyingGroupMember
    );
    List<RebateSubmissionService.RebateItemListWrapper> rebateItems = RebateSubmissionService.fetchRebateItemsByCampaignIds(
      new List<Id>{ testCampaign.Id }
    );
    Boolean isCaseCRPCreated = RebateSubmissionService.createCaseWithCRP(
      testAccount.Id,
      testAccount.Name,
      relevantCampaigns,
      rebateItems,
      1800
    );
    Test.stopTest();

    System.assertEquals(true, isCaseCRPCreated);
  }

  /**This test method will cover createCaseWithCRP for negative scenario*/
  @isTest
  static void testcreateCaseWithCRPNegativeOne() {
    Account testAccount = new Account();

    String buyingGroupMember = 'BrandSource';
    Campaign testCampaign = TestDataFactory.createCampaign(buyingGroupMember);
    insert testCampaign;

    Rebate_Item__c testRebateItemOne = TestDataFactory.createRebateItemWithoutCampaign();
    testRebateItemOne.Campaign__c = testCampaign.Id;
    Rebate_Item__c testRebateItemTwo = TestDataFactory.createRebateItemWithoutCampaign();
    testRebateItemTwo.Campaign__c = testCampaign.Id;
    Rebate_Item__c testRebateItemThree = TestDataFactory.createRebateItemWithoutCampaign();
    testRebateItemThree.Campaign__c = testCampaign.Id;
    Rebate_Item__c testRebateItemFour = TestDataFactory.createRebateItemWithoutCampaign();
    testRebateItemFour.Campaign__c = testCampaign.Id;

    List<Rebate_Item__c> testRebateItemList = new List<Rebate_Item__c>();
    testRebateItemList.add(testRebateItemOne);
    testRebateItemList.add(testRebateItemTwo);
    testRebateItemList.add(testRebateItemThree);
    testRebateItemList.add(testRebateItemFour);
    insert testRebateItemList;

    Test.startTest();
    List<RebateSubmissionService.CampaignListWrapper> relevantCampaigns = RebateSubmissionService.fetchRelevantCampaigns(
      buyingGroupMember
    );
    List<RebateSubmissionService.RebateItemListWrapper> rebateItems = RebateSubmissionService.fetchRebateItemsByCampaignIds(
      new List<Id>{ testCampaign.Id }
    );
    try {
      Boolean isCaseCRPCreated = RebateSubmissionService.createCaseWithCRP(
        'testErrorId',
        testAccount.Name,
        relevantCampaigns,
        rebateItems,
        1800
      );
    } catch (AuraHandledException ex) {
      System.assertEquals('Script-thrown exception', ex.getMessage());
    }
    Test.stopTest();
  }

  /**This test method will cover createCaseWithCRP for negative scenario*/
  @isTest
  static void testcreateCaseWithCRPNegativeTwo() {
    Account testAccount = new Account();

    String buyingGroupMember = 'BrandSource';
    Campaign testCampaign = TestDataFactory.createCampaign(buyingGroupMember);
    insert testCampaign;

    Rebate_Item__c testRebateItemOne = TestDataFactory.createRebateItemWithoutCampaign();
    testRebateItemOne.Campaign__c = testCampaign.Id;
    Rebate_Item__c testRebateItemTwo = TestDataFactory.createRebateItemWithoutCampaign();
    testRebateItemTwo.Campaign__c = testCampaign.Id;
    Rebate_Item__c testRebateItemThree = TestDataFactory.createRebateItemWithoutCampaign();
    testRebateItemThree.Campaign__c = testCampaign.Id;
    Rebate_Item__c testRebateItemFour = TestDataFactory.createRebateItemWithoutCampaign();
    testRebateItemFour.Campaign__c = testCampaign.Id;

    List<Rebate_Item__c> testRebateItemList = new List<Rebate_Item__c>();
    testRebateItemList.add(testRebateItemOne);
    testRebateItemList.add(testRebateItemTwo);
    testRebateItemList.add(testRebateItemThree);
    testRebateItemList.add(testRebateItemFour);
    insert testRebateItemList;

    Test.startTest();
    List<RebateSubmissionService.CampaignListWrapper> relevantCampaigns = RebateSubmissionService.fetchRelevantCampaigns(
      buyingGroupMember
    );
    List<RebateSubmissionService.RebateItemListWrapper> rebateItems = RebateSubmissionService.fetchRebateItemsByCampaignIds(
      new List<Id>{ testCampaign.Id }
    );
    Boolean isCaseCRPCreated = RebateSubmissionService.createCaseWithCRP(
      testAccount.Id,
      testAccount.Name,
      relevantCampaigns,
      null,
      1800
    );
    Test.stopTest();
    System.assertEquals(null, isCaseCRPCreated);
  }

  @isTest
  static void testGetSalesOpsQueueNegative() {
    Test.startTest();
    Group salesQueue = RebateSubmissionService.getSalesOpsQueue('testQueue');
    Test.stopTest();

    System.assertEquals(null, salesQueue);
  }
}