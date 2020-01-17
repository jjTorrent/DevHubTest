@isTest
public class RedoxRequestMock implements HttpCalloutMock {
	public HTTPResponse respond(HTTPRequest req) {  
		HttpResponse res = new HttpResponse();
		res.setHeader('Content-Type', 'text/plain');
		res.setStatusCode(200);
		return res;
	}
}