public class StringArrayTest {
    public static List<String> generateStringArray(Integer num) {
        List<String> listOfStrings = new List<String> ();
        for (Integer i = 0; i < num; i++) {
            String str = 'Test ' + i;
            listOfStrings.add(str);
        }
        return listOfStrings;
    } 
}