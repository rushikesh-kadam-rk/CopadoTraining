public class SearchAccountController {
    public String accountnumber { get; set; }
    public String accountid { get; set; }
    
    public void PopulateAccNumber() {
        Account acc = [Select id, Name, AccountNumber from Account where id=:accountid];
    }
}