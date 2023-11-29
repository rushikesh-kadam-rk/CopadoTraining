public class OPP_TH {
    public static void afterInsert(List<Opportunity> newList){
        Set<Id> accIdSet = new Set<Id>();
        List<Account> accToBeUpdated = new List<Account>();
        
        for(Opportunity opp: newList){
            if(opp.AccountId != NULL){
                accIdSet.add(opp.AccountId);
            }
        }
        if(!accIdSet.isEmpty()){
            accToBeUpdated = calAnnualRevenue(accIdSet);
        }
        if(!accToBeUpdated.isEmpty()){
            Database.update(accToBeUpdated);
        }
    }
    
    public static void afterUpdate(List<Opportunity> newList, Map<Id, Opportunity> oldMap){
        Set<Id> accIdSet = new Set<Id>();
        List<Account> accToBeUpdated = new List<Account>();
        
        for(Opportunity opp: newList){
            if(opp.AccountId != NULL && opp.Amount != oldMap.get(opp.Id).Amount){
                accIdSet.add(opp.AccountId);
            }
        }
        if(!accIdSet.isEmpty()){
            accToBeUpdated = calAnnualRevenue(accIdSet);
        }
        if(!accToBeUpdated.isEmpty()){
            Database.update(accToBeUpdated);
        }
    }
    
    public static void afterUpdateClosedWon(List<Opportunity> newList, Map<Id, Opportunity> oldMap){
        Set<Id> accIdSet = new Set<Id>();
        List<Account> accToBeUpdated = new List<Account>();
        
        for(Opportunity opp: newList){
            if(opp.AccountId != NULL && opp.StageName != oldMap.get(opp.Id).StageName && opp.StageName  == 'Closed Won'){
                accIdSet.add(opp.AccountId);
            }
        }
        if(!accIdSet.isEmpty()){
            accToBeUpdated = calCOE(accIdSet);
        }
        if(!accToBeUpdated.isEmpty()){
            Database.update(accToBeUpdated);
        }
    }
    
    public static void afterDelete(List<Opportunity> oldList){
        Set<Id> accIdSet = new Set<Id>();
        List<Account> accToBeUpdated = new List<Account>();
        
        for(Opportunity opp: oldList){
            if(opp.AccountId != NULL){
                accIdSet.add(opp.AccountId);
            }
        }
        if(!accIdSet.isEmpty()){
            accToBeUpdated = calAnnualRevenue(accIdSet);
        }
        if(!accToBeUpdated.isEmpty()){
            Database.update(accToBeUpdated);
        }
    }
    public static List<Account> calAnnualRevenue(Set<Id> accIdSet){
        List<Account> accToBeUpdated = new List<Account>();
        
        Map<Id, Decimal> accIdRevenueMap = new Map<Id, Decimal>();
        
        for(Opportunity opp: [SELECT Id, Amount, AccountId FROM Opportunity WHERE AccountId IN: accIdSet]){
            Decimal total = 0;
            if(accIdRevenueMap.containsKey(opp.AccountId)){
                total = accIdRevenueMap.get(opp.AccountId);
            }
            if(opp.AccountId!=NULL){
                total = total + opp.Amount;
            }
            
            accIdRevenueMap.put(opp.AccountId, total);
        }
        
        if(!accIdRevenueMap.isEmpty()){
            for(Id accId: accIdRevenueMap.keySet()){
                Account acc = new Account();
                acc.Id = accId;
                acc.AnnualRevenue = accIdRevenueMap.get(accId);
                accToBeUpdated.add(acc);
            }
        }
        return accToBeUpdated;
    }
    
    public static List<Account> calCOE(Set<Id> accIdSet){
        List<Account> accToBeUpdated = new List<Account>();
        
        for(Id accountId : accIdSet){
            Account acc = new Account();
            acc.Id = accountId;
            acc.NumberOfEmployees = 200;
            accToBeUpdated.add(acc);
        }
        
        return accToBeUpdated;
    }
    
    public static void calculateOppCount(List<Opportunity> oldList, List<Opportunity> newList, Map<Id, Opportunity> oldMap){
        Set<Id> accIdSet = new Set<Id>();
        //insert, undelete
        if(oldList == null && newList != NULL){
            for(Opportunity opp: newList){
                if(opp.AccountId != null){
                    accIdSet.add(opp.AccountId);
                }
            }
        }else if(oldList != null && newList != NULL){
            //update
            for(Opportunity opp: newList){
                if(opp.AccountId != null && opp.AccountId != oldMap.get(opp.Id).AccountId){
                    accIdSet.add(opp.AccountId);
                }
            }
        }else if(oldList != null && newList == NULL){
            //delete
            for(Opportunity opp: oldList){
                if(opp.AccountId != null && opp.AccountId != oldMap.get(opp.Id).AccountId){
                    accIdSet.add(opp.AccountId);
                }
            }
        }
        
        AggregateResult[] groupedResults = [SELECT Count(Id) OppCount , AccountId AcctId 
                                            FROM Opportunity 
                                            GROUP BY AccountId 
                                            HAVING AccountId IN: accIdSet];
        
        Map<Id, Integer> accountWithOppMap = new Map<Id, Integer>();
        List<Account> acctsToRollup = new List<Account>();
        for(AggregateResult ar : groupedResults){
            Account a = new Account();
            a.Id = (Id)ar.get('AcctId');
            //a.No_of_Opportunities__c = (Integer) ar.get('OppCount');
            acctsToRollup.add(a);
        }
        
    }
    
    public static void calculateOppAmount(List<Opportunity> oppList, Map<Id, Opportunity> newOppMap){
        Set<Id> accountIdSet = newOppMap.keySet();
        
        AggregateResult[] oppARList = [SELECT SUM(ExpectedRevenue) oppAmount, AccountId accId FROM Opportunity
                                    GROUP BY AccountId HAVING AccountId IN: accountIdSet];
        List<Account> accToBeUpdateList = new List<Account>();
        for(AggregateResult ar : oppARList){
            Account acc = new Account();
            acc.Id = (Id) ar.get('accId');
            acc.AnnualRevenue = (Double) ar.get('oppAmount');
            accToBeUpdateList.add(acc);
        }
        
        Database.update(accToBeUpdateList);
    }
}