public class ApexBasics {
    public static void meth(){
        EmailManager em = new EmailManager();
        EmailManager.sendMail('r.dnyaneshwar.kadam@accenture.com', 'Trailhead Tutorial', '123 body');
        /************************************************************
         ************************************************************
        */
        Decimal num1 = 200.54;
        Decimal num2 = 412.54;
        Decimal total = num1+num2;
        
        System.debug('====Total Value: '+total);
        /************************************************************
         ************************************************************
        */
        Date myDate = Date.today();
        System.debug('====Debug2: '+myDate);
        
        DateTime myDateTime = System.Now();
        myDateTime = myDateTime.addHours(5);
        myDateTime = myDateTime.addMinutes(30);
        System.debug('====Debug3: '+myDateTIme);
        /************************************************************
         ************************************************************
        */
        String s1 = 'dasdsa';
        String s2 = 'DASdsa';
        String s3 = '456';
        
        System.debug(s1.contains(s2));
        System.debug(s1.containsIgnoreCase(s2));
        /************************************************************
         ************************************************************
        */
        Integer num = 123;
        System.debug(Integer.valueOf(s3));
        /************************************************************
         ************************************************************
        */
        //List<Data_Type> list_Name = new List<Data_Type>();
        
        //List<String> myList = new List<String>();
        List<Account> accList = new List<Account>();
        List<Candidate__c> canList = new List<Candidate__c>();
        
        List<Integer> myList = new List<Integer>();
        
        System.debug('Content in my list==='+myList);
        System.debug('My list size==='+myList.size());
        myList.add(7);
        System.debug('Content in my list==='+myList);
        System.debug('My list size==='+myList.size());
        myList.add(5);
        System.debug('Content in my list==='+myList);
        System.debug('My list size==='+myList.size());
        myList.add(11);
        System.debug('Content in my list==='+myList);
        System.debug('My list size==='+myList.size());
        myList.add(7);
        System.debug('Content in my list==='+myList);
        System.debug('My list size==='+myList.size());
        myList.add(11);
        System.debug('Content in my list==='+myList);
        System.debug('My list size==='+myList.size());
        
        for(Integer i=0; i<myList.size(); i++){
            System.debug('Content in my list==='+myList.get(i));
        }
        /************************************************************
         ************************************************************
        */
        //Set<Data_Type> set_Name = new Set<Data_Type>();
        
        //Set<String> mySet = new Set<String>();
        Set<Account> accSet = new Set<Account>();
        Set<Candidate__c> canSet = new Set<Candidate__c>();
        
        Set<Integer> mySet = new Set<Integer>();
        
        System.debug('Content in my set==='+mySet);
        System.debug('My set size==='+mySet.size());
        mySet.add(7);
        System.debug('Content in my set==='+mySet);
        System.debug('My set size==='+mySet.size());
        mySet.add(5);
        System.debug('Content in my set==='+mySet);
        System.debug('My set size==='+mySet.size());
        mySet.add(11);
        System.debug('Content in my set==='+mySet);
        System.debug('My set size==='+mySet.size());
        mySet.add(7);
        System.debug('Content in my set==='+mySet);
        System.debug('My set size==='+mySet.size());
        mySet.add(11);
        System.debug('Content in my set==='+mySet);
        System.debug('My set size==='+mySet.size());
        
        /************************************************************
         ************************************************************
        */
        Map<String,Integer> myMap = new Map<String,Integer>();
        //Map<Account> accMap = new Map<Account>();
        Map<ID,Candidate__c> canMap = new Map<ID,Candidate__c>();
        /************************************************************
         ************************************************************
        */
        
        Account[] accts = [SELECT Name,Phone FROM Account 
                           WHERE (Name='SFDC Computing' AND NumberOfEmployees>25)
                           ORDER BY Name
                           LIMIT 10];
        System.debug(accts.size() + ' account(s) returned.');
        // Write all account array info
        System.debug(accts);
        /************************************************************
         ************************************************************
        */
        for(Job_Application__c ja: [select id, name from Job_Application__c]){
            System.debug(ja.id+'       '+ja.name);    
        }
        /************************************************************
         ************************************************************
        */

    }
}