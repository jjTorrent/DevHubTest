public class AccountHandler {
    public static Account insertNewAccount (String newName) {
        try {
            Account acct = new Account(Name = newName);
            insert acct;
            ID acctID = acct.ID;
            System.debug('ID' + acctID);
            return acct;
        } catch (DmlException err) {
            System.debug('A DML exception has occurred: ' + 
                         err.getMessage());
            return null;
        }
    }
}