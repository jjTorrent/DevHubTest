public class RandomContactFactory {
    
    public static List<Contact> generateRandomContacts(Integer numContacts, String last) {
        List<Contact> contacts = new List<Contact>();
        for (Integer i=0; i<numContacts; i++) {
            Contact c = new Contact(firstName = 'Test ' + i, lastName = last);
            contacts.add(c);
        }
        return contacts;
    }
    
}