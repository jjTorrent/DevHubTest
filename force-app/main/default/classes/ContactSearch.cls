public class ContactSearch {
    
    public static List<Contact> searchForContacts (String lastName, String zip) {
        List<Contact> matches = new List<Contact>();
        matches = [SELECT Id, Name FROM Contact WHERE LastName = :lastName AND MailingPostalCode = :zip];
        return matches;
    }

}