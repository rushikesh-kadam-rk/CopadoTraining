public with sharing class VeriPhoneController {
    
    @AuraEnabled
    public static VeriPhoneDescriptor verifyPhone(String phone){
        //I am having my API Key in custom label. You can use the key directly in code itself !!
        string endpoint='https://api.veriphone.io/v2/verify?phone='+phone+'&key='+System.Label.APIKey;
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(endPoint);
        request.setMethod('GET');
        system.debug(request);
        HttpResponse response = http.send(request);
        System.debug('===>Response : '+response.getBody());
        return new VeriPhoneDescriptor().parseJSON(response.getBody());
    }
}