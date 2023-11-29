public with sharing class CurrencyConversionController {
    
    @AuraEnabled
    public static Map<String, Object> retrieveCurrencyConversionRates(String endpointURL){
        try {
            Map<String, Object> responseJSON = new Map<String, Object>();

            String responseString = null;

            if(String.isNotBlank(endpointURL)){
                HttpRequest httpRequest = new HttpRequest();
                httpRequest.setEndpoint(endpointURL);
                httpRequest.setMethod('GET');
                httpRequest.setHeader('Authorization', 'OAuth '+UserInfo.getSessionId());
                httpRequest.setHeader('Authorization', 'Bearer '+UserInfo.getSessionId());

                Http http = new Http();
                httpResponse httpResponse = http.send(httpRequest);

                if(httpResponse.getStatusCode()==200){
                    responseString = httpResponse.getBody();
                }else{
                    System.debug('RK======>'+httpResponse.getStatusCode());
                    throw new CalloutException(httpResponse.getBody());
                }
            }
            if(String.isNotBlank(responseString)){
                responseJSON = (Map<String, Object>)JSON.deserializeUntyped(responseString);
            }
            return responseJSON;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}