/*
* @Class		: LeadUtilsTest
* @Author		: DLee@Merkle
* @Description	: Test class for LeadUtils
*/

@isTest public class LeadUtilsTest {
    @TestVisible private static String testAppUserId1 = '$RCAnonymousID:12345678-1234-1234-1234-123456789121';
    @TestVisible private static String testFirstName1 = 'JohnTest';
    @TestVisible private static String testLastName1 = 'DoeTest';
    @TestVisible private static String testEmail1 = 'john.doe@merkle.com.invalid';
    @TestVisible private static String testAppUserId2 = '$RCAnonymousID:12345678-1234-1234-1234-123456789122';
    @TestVisible private static String testFirstName2 = 'JaneTest';
    @TestVisible private static String testLastName2 = 'DoeTest';
    @TestVisible private static String testEmail2 = 'jane.doe@merkle.com.invalid';
    
    @testSetup static void setup() {
        Lead testLead = new Lead(
            original_app_user_id__c = testAppUserId1,
            FirstName = testFirstName1,
        	LastName = testLastName1,
        	Email = testEmail1,
            HasOptedOutOfEmail = false
        );
        insert testLead;
    }
    
    @isTest static void testCreateSuccess(){
        Test.startTest();
        String strResult;// = LeadUtils.create(testAppUserId2, testFirstName2, testLastName2, testEmail2, 'no');
        Lead leadCreated = [SELECT Id, FirstName, LastName, Email, HasOptedOutOfEmail FROM Lead WHERE original_app_user_id__c=:testAppUserId2 LIMIT 1];
        Test.stopTest();
        Assert.areEqual('SUCCESS', strResult);
        Assert.areEqual(testFirstName2, leadCreated.FirstName);
        Assert.areEqual(testLastName2, leadCreated.LastName);
        Assert.areEqual(testEmail2, leadCreated.Email);
        Assert.areEqual(true, leadCreated.HasOptedOutOfEmail);
    }
    
    @isTest static void testCreateDuplicate(){
        Test.startTest();
        String strResult;// = LeadUtils.create(testAppUserId1, testFirstName1, testLastName1, testEmail1, 'no');
        Test.stopTest();
        Assert.areNotEqual('SUCCESS', strResult);
    }

    @isTest static void testConvert(){
        Test.startTest();
        LeadUtils.convert(testAppUserId1);
        Account acctCreated = [SELECT Id, FirstName, LastName, PersonEmail, PersonHasOptedOutOfEmail FROM Account WHERE original_app_user_id__c=:testAppUserId1 LIMIT 1];
        Test.stopTest();
        Assert.areEqual(testFirstName1, acctCreated.FirstName);
        Assert.areEqual(testLastName1, acctCreated.LastName);
        Assert.areEqual(testEmail1, acctCreated.PersonEmail);
        Assert.areEqual(false, acctCreated.PersonHasOptedOutOfEmail);
    }    
}