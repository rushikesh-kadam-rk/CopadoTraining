public class SOQL {
    public static void meth(){
                /************************************************************
         ************************INSERT******************************
        */
        Position__c p = new Position__c();
        p.name = 'Position51';
        p.Job_Description__c = 'p51 Knowledge';
        insert p;
        System.debug(p.id);
        /********************UPDATE**********************************
         ****************System.SObjectException*********************
        */
        Position__c p1 = [select Id, Name, Status__c, Sub_Status__c
                            from Position__c
                            where Name='Position51'];
        p1.status__c = 'New';
        p1.sub_status__c = 'Pending';
        update p1;
        System.debug(p1.Job_Description__c);
        /**********************************************************
         ***System.QueryException:List has no rows for assignment**
        */
        Position__c p0 = [select Id, Name from Position__c
                            where Name='XYZ'];
        /***************************************************************
         *System.QueryException: List has more than 1 row for assignment
        */
        Position__c p10 = [select Id, Name from Position__c
                            where Department__c='IT'];
        /***************************************************************/
        List<Position__c> lp = [select Id, Name from Position__c
                            where Department__c='IT'];
        /************************FOR LOOP*******************************/
        List<Position__c> pList = [select Id, Name from Position__c];
        System.debug(pList);
        System.debug('');
        for(Position__c pos: pList){
            System.debug(pos.Id+'------------'+pos.Name);
        }
        /*************************DELETE*********************************/
        List<Position__c> pList0 = [select Id, Name from Position__c
                                    where Name='Position51'];
        delete pList0;
        /*************************UPSERT*********************************/
        List<Position__c> pList10 = new List<Position__c>();
        Position__c p11 = [Select Name, Status__C, Sub_Status__C
                            from Position__c
                            where Name='Java Developer'];
        p1.Status__C = 'Closed';
        p1.Sub_Status__C = 'Filled';
        
        Position__c p2 = new Position__c(Name='P52', Job_Description__c='P52 Knowledge');
        pList10.add(p11);
        PList10.add(p2);
        upsert pList10;
        /*********************TRANSACTIONS**********************************/
        /*********************Atomocity ==> All or None********************/
        /***System.DmlException: Upsert failed.: REQUIRED_FIELD_MISSING***/
        List<Position__c> pList11 = new List<Position__c>();
        Position__c p3 = [Select Name, Status__C, Sub_Status__C
                            from Position__c
                            where Name='Java Developer'];
        p3.Status__C = 'Open';
        p3.Sub_Status__C = 'Approved';
        
        Position__c p4 = new Position__c(Name='P53');
        pList11.add(p3);
        PList11.add(p4);
        //upsert pList;
        
        Database.upsert(pList, false);		//No Rollback
        /*********************Exception Handling***************************/
        try{
            List<Position__c> pList12 = new List<Position__c>();
            /*Position__c p3 = [Select Name, Status__C, Sub_Status__C
                                from Position__c
                                where Name='XYZ'];*/
            Position__c p32 = [Select Name, Status__C, Sub_Status__C
                                from Position__c
                                where Department__c='IT'];
        
            p32.Status__C = 'Open';
            p32.Sub_Status__C = 'Approved';
            
            Position__c p04 = new Position__c(Name='P53');
            pList.add(p32);
            PList.add(p04);
            //upsert pList;
            
            Database.upsert(pList12, false);
        }catch(System.QueryException qe){
            System.debug(qe.getMessage());
        }
        /**********************************************************/
        try{
            List<Position__c> pList15 = new List<Position__c>();
            Position__c p03 = [Select Name, Status__C, Sub_Status__C
                                from Position__c
                                where Name='Java Developer'];
        
            p03.Status__C = 'Open';
            p03.Sub_Status__C = 'Approved';
            
            Position__c p04 = new Position__c(Name='P53');
            pList15.add(p3);
            PList15.add(p04);
            //upsert pList;
            
            Database.upsert(pList, true);
        }catch(System.QueryException qe){
            System.debug(qe.getMessage());
        }catch(System.DMLException de){
            System.debug(de.getMessage());
        }catch(System.Exception e){
            System.debug(e.getMessage());
        }
        /********************Bind Variable****************************/
        String dname='IT';
        List<Position__c> pList16 = [Select Name
                                    from Position__c
                                    where Department__c=:dname];
        System.debug(pList16);
        /************************************************************/
    }
}