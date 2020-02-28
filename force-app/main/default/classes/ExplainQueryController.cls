public with sharing class ExplainQueryController {

    private String instance;
    transient public String soql { get; set; }
    public String retJSON { get; set; }
    transient public String explain { get; set; }
    transient public String error { get; set; }
    Map<String, Object> respMap {get;set;}
    public List<Map<String,object>> tableData {get;set;}
    public List<String> tableDataH  {get;set;}
    
    public List<Plan> plans { get; set; }

    //determine what URL prefix we're removing, c for unmanaged, soql-explain for managed.
    private static String currentPrefix{
        get{
            String prefix = ExplainQueryController.class.getName().substringBefore('ExplainQueryController');
            if(prefix.endsWith('.'))
                prefix = prefix.removeEnd('.');
            if(String.isEmpty(prefix)){
                return 'c';
            }else{
                return prefix.replaceAll('_','-'); //underscores in namespaces are converted to hypens in domain names
            }
        }
    }
    
    //visualforce domains aren't API-enabled, so we need to figure out what the proper endpoint
    public ExplainQueryController() {
        soql = 'select Id, DeveloperName, LastModifiedDate from CustomObject';
        // retrieve the instance used to create endpoint URL
        instance = URL.getSalesforceBaseUrl().getHost();
        
        // check for my domain
        if (instance.contains('--'+currentPrefix+'.') && !instance.startsWith(currentPrefix+'.')) {
            instance = instance.substring(0, instance.indexOf('--'+currentPrefix+'.')) + '.my.salesforce.com';
        }
        else {
            // strip out the starting 'c.' values
            instance = instance.removeStart(currentPrefix+'.');
            instance = instance.replace('.visual.force.com', '.salesforce.com');
        }
        instance = 'https://' + instance;
    }    
    
    public PageReference showExplainPlan() {
        HTTPRequest req = new HTTPRequest();
        req.setHeader('Authorization','Bearer ' + UserInfo.getSessionID());
        req.setHeader('Content-Type','application/json');
        
        req.setEndpoint(instance + '/services/data/v30.0/query/?explain=' + EncodingUtil.urlEncode(soql, 'UTF-8'));
        req.setMethod('GET');
        
        Http h = new Http();
        HttpResponse res = h.send(req);
        String status = res.getStatus();
        Integer statusCode = res.getStatusCode();
        retJSON = res.getBody();
        
        plans = new List<Plan>();
        String text = '';
      
        // check if we had an error
        if (statusCode != 200) {
            for(ExplainErrorResponse error : (List<ExplainErrorResponse>) JSON.deserialize(retJSON, List<ExplainErrorResponse>.class)){ 
                String err = error.errorCode +' '+ error.message;
                
                ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, status + ' - ' + err);
                ApexPages.addMessage(msg);
            }
        }
        else {           
            ExplainResponse response = (ExplainResponse) JSON.deserialize(retJSON, ExplainResponse.class);
            plans = response.plans;     
        }    
               
        return null;
    }
    
     public PageReference showResponse() {
        HTTPRequest req = new HTTPRequest();
        req.setHeader('Authorization','Bearer ' + UserInfo.getSessionID());
        req.setHeader('Content-Type','application/json');
        
        //req.setEndpoint(instance+'/services/data/v36.0/tooling/query/?q=Select+id,+DeveloperName,LastModifiedDate+from+CustomObject');
        req.setEndpoint(instance+'/services/data/v36.0/tooling/query/?q='+ EncodingUtil.urlEncode(soql, 'UTF-8'));
        
        req.setMethod('GET');
        
        Http h = new Http();
        HttpResponse res = h.send(req);
        String status = res.getStatus();
        Integer statusCode = res.getStatusCode();
        retJSON = res.getBody();
        System.debug('retJSON' + retJSON);
        respMap = (Map<String, Object>) JSON.deserializeUntyped(retJSON);
        tableDataH = new List<String>(); 
        System.debug('retJSON' + respMap.get('records')); 
        List<Object> dataList = (List<Object>)respMap.get('records');
        tableData =  new List<Map<String,object>>();
        for(Object obj: dataList) {
            Map<String,object> s =(Map<String,object>) obj;
            System.debug('s' + s); 
            
            tableData.add(s);
        }
        tableDataH.addAll(tableData.get(0).keySet()); 
        System.debug('tableData' + tableData);
        
        //respMap = (Map<String, Object>) JSON.deserializeUntyped((String)respMap.get('records'));
        /*tableData = respMap.values();
        Set<String> keys =  respMap.keySet();
        tableDataH = new List<String>();
        tableDataH.addAll(keys);*/
        return null;
    }

    public class ExplainErrorResponse{
        String errorCode {get; set;}
        String message {get; set;}
    }
    
    public class ExplainResponse{
        public List<Plan> plans {get; set;}
    }
    
    public class Plan {
        public Double cardinality { get; set; }
        public List<String> fields { get; set; }
        public String leadingOperationType { get; set; }
        public Double relativeCost { get; set; }
        public Double sObjectCardinality { get; set; }
        public String sObjectType { get; set;}
    }
        
}