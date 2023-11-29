@isTest
public class LeadHandlerTest {
    
    @isTest static void createLeadRecordPositiveTest(){
        LeadCreateWrapper leadWrapper = new LeadCreateWrapper();
        Test.startTest();
        String leadId;// = LeadHandler.createLeadRecord(leadWrapper);
        Test.stopTest();
        List<Lead> leadList = [SELECT Id, Name FROM Lead WHERE Email = 'test@testemail.com'];
        System.assertEquals(leadId, leadList[0].Id);
    }

    @isTest static void createLeadRecordWithoutAssesedIncomeTest(){
        LeadCreateWrapper leadWrapper = new LeadCreateWrapper();
        leadWrapper.lastName = '';
        leadWrapper.assessedIncomeProgramValue = false;
        Test.startTest();
        String leadId;// = LeadHandler.createLeadRecord(leadWrapper);
        Test.stopTest();
        List<Lead> leadList = [SELECT Id, Name FROM Lead WHERE Email = 'test@testemail.com'];
        System.assertEquals(leadId, leadList[0].Id);
    }

    @isTest static void createLeadRecordNegativeTest(){
        LeadCreateWrapper leadWrapper = new LeadCreateWrapper();
        Test.startTest();
        try{
            String leadId;// = LeadHandler.createLeadRecord(leadWrapper);
        }catch(Exception ex){
            System.assertEquals('expected text', ex.getCause()+' '+ex.getLineNumber()+' '+ex.getStackTraceString());
        }
        Test.stopTest();
    }
}