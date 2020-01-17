/*******************************************************************************
*   Author: Jonathan James / Torrent Consulting
*   Company Contact: Development@TorrentConsulting.com
*   Purpose: Provides response information for a Redox service call.
*
*   Date of Change	Author					Change Summary
*   --------------	---------------------	------------------------------------
*   2019-09-10		Jonathan James			Initial development.
*******************************************************************************/

public class RedoxServiceResponse {
	public Boolean success {get; set;}
	public String errorMessage {get; set;}
	public Object coreData {get; set;}

	public RedoxServiceResponse(Boolean success) {
		this.success = success;
	}

	public RedoxServiceResponse(Boolean success, String errorMessage) {
		this.success = success;
		this.errorMessage = errorMessage;
	}

	public RedoxServiceResponse(Boolean success, String errorMessage, Object coreData) {
		this.success = success;
		this.errorMessage = errorMessage;
		this.coreData = coreData;
	}
}