@RestResource(urlMapping='/Contacts/*')
global class RESTGetContact{
    @HttpGet
    global static  list<Contact> getCOntactByMobile(){
        List<Contact> conList = new List<Contact>();
        Restrequest request = RestContext.request;
        
        String mobile = request.requestURI.substring(
                            request.requestURI.lastIndexOf('/')+1);
                            
        conList = [SELECT id, name, email, mobilephone
                    from COntact
                    WHERE mobilephone=:mobile];
                    
        return conList;
    }
}