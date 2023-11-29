/*
* @Class		: TestDataFactory
* @Author		: 
* @Description	: This class will serve as a source for other Test Classes to create the data
* @CreatedDate  : 
*/
@isTest(SeeAllData=false)
public without sharing class TestDataFactory {

    /** 
    * ********************************************************
    * This method is to create test data for Campaign
    * ********************************************************
    */
    public static Campaign createCampaign(String buyingGroupMembers){
        Campaign testCampaign = new Campaign();
        testCampaign.Name = 'Test Campaign';
        testCampaign.RecordTypeId = Schema.SObjectType.Campaign.getRecordTypeInfosByDeveloperName().get('Dealer_Rebate').getRecordTypeId();
        testCampaign.Buying_Group_Member__c = buyingGroupMembers;
        testCampaign.Rebate_Period__c = 'Spring';
        testCampaign.StartDate = Date.today();
        testCampaign.EndDate = Date.today().addDays(30);
        testCampaign.Submission_Start_Date__c = Date.today();
        testCampaign.Submission_End_Date__c = Date.today().addDays(30);
        return testCampaign;
    }

    /** 
    * ********************************************************
    * This method is to create test data for Rebate_Item__c
    * ********************************************************
    */
    public static Rebate_Item__c createRebateItemWithoutCampaign(){
        Rebate_Item__c testRebateItem = new Rebate_Item__c();
        //testRebateItem.Name = 'Test Rebate Item';
        testRebateItem.Rebate_Amount__c = 4000;
        testRebateItem.Maximum_Rebate_Quantity__c = 40;
        return testRebateItem;
    }
    
}