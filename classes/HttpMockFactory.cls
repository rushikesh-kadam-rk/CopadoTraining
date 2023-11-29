@isTest
global class HttpMockFactory implements HttpCalloutMock {
    protected Integer code;
    protected String status;
    protected String body;
    protected String endpoint;
    protected String method;
    protected Map<String, String> responseHeaders;

    public HttpMockFactory(Integer code, String status, String body, String endpoint, 
                           String method) {
        this.code = code;
        this.status = status;
        this.body = body;
        this.endpoint = endpoint;
        this.method = method;
    }

    public HttpResponse respond(HttpRequest mockRequest){
        HttpResponse response = new HttpResponse();
        response.setBody(this.body);
        response.setStatus(this.status);
        response.setStatusCode(this.code);
        return response;
    }
}