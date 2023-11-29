public without sharing class CreditMemoService {
    
    public static void createOnlyCreditMemo(){
    try {
        CreditMemo credit = new CreditMemo();
        //credit.BillingAccountId = '0012w000003F4LkAAK';
        //credit.Status = 'Pending';
        //credit.CreditDate = Date.Today();
        insert credit;
        System.debug('Message:::');
    }catch (Exception e) {
          // Log the exception and handle it appropriately
          System.debug('Error creating CreditMemo: ' + e.getMessage());
          // Depending on the use case, you might want to rethrow the exception or handle it differently
          throw e;
        }
	}

}