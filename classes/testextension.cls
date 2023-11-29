public class testextension{

       public Account a {get;set;}

        public testextension(apexPages.standardController con){
            a = (Account)con.getRecord();
        }

        public void save(){
            system.debug(a.Name); //Should be whatever you entered on the page
        }

    }