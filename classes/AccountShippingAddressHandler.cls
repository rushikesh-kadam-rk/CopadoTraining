public class AccountShippingAddressHandler {

    //map billing address to shipping address of Account
    public static void updateShippingAddress(List<Account> oldList, List<Account> newList){
        //for insert
        for(Account acc: newList){
            if(acc.BillingStreet != null){
                acc.ShippingStreet = acc.BillingStreet;
            }
            if(acc.BillingCity != null){
                acc.ShippingCity = acc.BillingCity;
            }
            if(acc.BillingState != null){
                acc.ShippingState = acc.BillingState;
            }
            if(acc.BillingPostalCode != null){
                acc.ShippingPostalCode = acc.BillingPostalCode;
            }
            if(acc.BillingCountry != null){
                acc.ShippingCountry = acc.BillingCountry;
            }
        }
    }
}