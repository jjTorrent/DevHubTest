@isTest
private class ParkLocatorTest {

	@isTest
	static void country_TestSupportedCountry() {
		Test.setMock(WebServiceMock.class, new ParkServiceMock());
		List<String> parks = ParkLocator.country('Germany');
		System.assert(!parks.isEmpty());
	}

}