/*******************************************************************************
*   Author: Jonathan James / Torrent Consulting
*   Company Contact: Development@TorrentConsulting.com
*   Purpose: Provide a REST response to the Redox EMR messaging service.
*
*   Date of Change	Author					Change Summary
*   --------------	---------------------	------------------------------------
*   2018-01-25		Cheyne Pierce			Initial development.
*   2019-09-10		Jonathan James			Refactored.
*******************************************************************************/

@RestResource(urlmapping='/redox')
global class Redox {

	@HttpGet
	global static void verify() {
		RestContext.response.addHeader('Content-Type', 'text/plain');
		String challenge = RestContext.request.params.get('challenge');
		RestContext.response.responseBody = Blob.valueOf(challenge);
		RestContext.response.statusCode = 200;
	}

	@HttpPost
	global static void processData() {
		RestContext.response.addHeader('Content-Type', 'text/plain');

		try {
			String jsonString = RestContext.request.requestBody.toString();
			RedoxServiceResponse handlerResponse = RedoxRequestHandler.handleRedoxRequest(
				(Map<String, Object>)JSON.deserializeUntyped(jsonString)
			);
			if (handlerResponse.success == false) {
				System.debug(LoggingLevel.ERROR, handlerResponse.errorMessage);
				System.debug(LoggingLevel.ERROR, jsonString);
			}
		} catch (Exception e) {
			System.debug(LoggingLevel.ERROR, e.getMessage());
		}

		RestContext.response.statusCode = 200;
	}

}