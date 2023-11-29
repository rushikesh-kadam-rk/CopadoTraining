public class HttpCalloutControl {

    @AuraEnabled(cacheable=true)
    public static Map<String, Object> getCalloutResponseContent(String url){
        Http httpObject = new Http();
        HttpRequest httpReq = new HttpRequest();
        httpReq.setEndPoint(url);
        httpReq.setMethod('GET');

        HttpResponse httpRes = httpObject.send(httpReq);
        System.debug('response---->'+httpRes.getBody());
        Map<String, Object> resultsMap = (Map<String, Object>)JSON.deserializeUntyped(httpRes.getBody());
        return resultsMap;

    }
}