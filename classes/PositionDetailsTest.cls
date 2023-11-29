@isTest
public class PositionDetailsTest {
    @isTest
    private static /*testMethod*/ void testFetchAllPositions(){
        Position__c p1 = new Position__c(Name='P11', Job_Description__c='P11 Knowledge');
        insert p1;
        Position__c p2 = new Position__c(Name='P12', Job_Description__c='P12 Knowledge');
        insert p2;
        
        PositionDetails pd = new PositionDetails();
        List<Position__c> pList = pd.fetchAllPositions();
        
        System.assertEquals(2, pList.size());
        //System.debug(pList.size());
    }
    @isTest
    private static void testFetchPosition(){
        Position__c p3 = new Position__c(Name='P13', Job_Description__c='P13 Knowledge');
        insert p3;
        
        ID pid = p3.Id;

        PositionDetails pd1 = new PositionDetails();
        Position__c p = pd1.fetchPosition(pid);
        
        System.assertEquals(pid, p.id);
        //System.assertEquals(pid, '111');
    }
}