public class ContactAndLeadSearch {
    
    public static List<List<SObject>> searchContactsAndLeads (String str) {
        List<List<SObject>> matches = [FIND :str IN NAME FIELDS RETURNING Contact(Id, FirstName, LastName), Lead(Id, Name)];
        return matches;
    }

}