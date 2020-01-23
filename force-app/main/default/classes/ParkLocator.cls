public class ParkLocator {

	private static Set<String> supportedCountries = new Set<String>{'Germany', 'India', 'Japan', 'United States'};

    public static List<String> country(String countryName) {
		return new ParkService.ParksImplPort().byCountry(countryName);
	}

}