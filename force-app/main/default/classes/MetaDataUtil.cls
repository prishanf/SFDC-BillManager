public class MetaDataUtil {
    
    private static MetaDataUtil instance = null;
    public HTTPRequest req {get; private set;}
    private Http h {get;set;}
    private static String baseURL = 'https://'+URL.getSalesforceBaseUrl().getHost() + '/services/data/v36.0/';
   
    // The constructor is private and initializes the id of the record type
    private MetaDataUtil(){
        req = new HTTPRequest();
        req.setHeader('Authorization','Bearer ' + UserInfo.getSessionID());
        req.setHeader('Content-Type','application/json');
        req.setMethod('GET');
        h = new Http();
    }

    public static MetaDataUtil getInstance(){
        if(instance == null) instance = new MetaDataUtil();
        return instance;
    }
    // /services/data/v36.0/tooling/query/?q=------
    public List<Object> toolingQuery(String soql){
        req.setEndpoint(baseURL+'tooling/query/?q='+ EncodingUtil.urlEncode(soql, 'UTF-8'));
        return sendRequest('records');
    }
    
    //  /services/data/v36.0/tooling/sobjects/toolingObjectName/describe
    public List<Object> toolingSobjectFields(String toolingObjectName){
        req.setEndpoint(baseURL+'tooling/sobjects/'+toolingObjectName+'/describe');
        return sendRequest('fields');
    }
    
    // /services/data/v36.0/tooling/sobjects
	 public List<Object> toolingSobjects(){
        req.setEndpoint(baseURL+'tooling/sobjects');
        return sendRequest('sobjects');
    }
    
    private List<Object> sendRequest(String getType){
        System.debug('Request End point :'+req.getEndpoint());
        HttpResponse res = h.send(req);
        String status = res.getStatus();
        Integer statusCode = res.getStatusCode();
        System.debug(res.getBody());
        if (statusCode != 200) {
            for(RESTErrorResponse error : (List<RESTErrorResponse>) JSON.deserialize(res.getBody(), List<RESTErrorResponse>.class)){ 
                String err = error.errorCode +' '+ error.message;
                ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, status + ' - ' + err);
                throw new RestCallException(err);
                return null;
            }
        }
        else {           
             Map<String, Object> respMap  = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
             return (List<Object>) respMap.get(getType);     
        } 
        return null;
    }
    
    public class RESTErrorResponse{
        String errorCode {get; set;}
        String message {get; set;}
    }
    
    public class RestCallException extends Exception{
        
    }
    
   
}