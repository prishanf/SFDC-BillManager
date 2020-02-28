public class MetaTrackerController {

    private String instance;
    transient public String soql { get; set; }
    public String retJSON { get; set; }
    transient public String explain { get; set; }
    transient public String error { get; set; }
    Map<String, Object> respMap {get;set;}
    public List<Map<String,object>> tableData {get;set;}
    public List<String> tableDataH  {get;set;}
    public Date datename {get;set;}
    public Pagination paginator {get;set;}
    public prishan__Bill__c temform {get;set;}
    
    public LIst<SelectOption> ToolingObjects {get;set;}
    public String selectedToolingOBj {get;set;}
    
    public List<String> fileds {get;set;}
    public String displayQuery {get;set;}
    
    public integer psize {get;set;}
    
    
    
    public MetaTrackerController(){
        temform = new prishan__Bill__c();
        soql = 'select Id, DeveloperName, LastModifiedDate from CustomObject';
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
        paginator = new Pagination(soql,true);
        initToolongObjects();
        
        
    }
    
    private void initToolongObjects(){
        ToolingObjects = new List<SelectOption>();
        for(Object rec : MetaDataUtil.getInstance().toolingSobjects()){
       		  Map<String,Object> item  = (Map<String,Object>) rec; 
              ToolingObjects.add(new SelectOption((String)item.get('name'),(String)item.get('label')));	
        }
    }
    
     private static String currentPrefix{
        get{
            String prefix = MetaTrackerController.class.getName().substringBefore('MetaTrackerController');
            if(prefix.endsWith('.'))
                prefix = prefix.removeEnd('.');
            if(String.isEmpty(prefix)){
                return 'c';
            }else{
                return prefix.replaceAll('_','-'); //underscores in namespaces are converted to hypens in domain names
            }
        }
    }
    
     public PageReference showResponse() {
         Date d = temform.prishan__bill_date__c;
         Datetime dt = DateTime.newInstance(d.year(), d.month(), d.day(), 0, 0, 0);
		//2016-02-19T02:52:40.000+0000
         System.debug('dt' +  dt.format('YYYY-MM-dd'));
		paginator.addFilter(new List<String>{'LastModifiedDate > '+ dt.format('YYYY-MM-dd') +'T00:00:00.000+0000' });
         
        /*HTTPRequest req = new HTTPRequest();
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
        // check if we had an error
        if (statusCode != 200) {
            for(ExplainErrorResponse error : (List<ExplainErrorResponse>) JSON.deserialize(retJSON, List<ExplainErrorResponse>.class)){ 
                String err = error.errorCode +' '+ error.message;
                ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, status + ' - ' + err);
                ApexPages.addMessage(msg);
            }
        }
        else {           
            respMap = (Map<String, Object>) JSON.deserializeUntyped(retJSON);
            tableDataH = new List<String>(); 
            List<Object> dataList = (List<Object>)respMap.get('records');
            tableData =  new List<Map<String,object>>();
            for(Object obj: dataList) {
                Map<String,object> s =(Map<String,object>) obj;
                tableData.add(s);
            }
            Set<String> heading = tableData.get(0).keySet();
            heading.remove('attributes');
            tableDataH.addAll(heading);    
        }  */
        return null;
    }

    public void RefreshFields(){
        fileds = new LIst<String>();
        for(Object rec : MetaDataUtil.getInstance().toolingSobjectFields(selectedToolingOBj)){
            Map<String,Object> item = (Map<String,Object>) rec;
            if((boolean )item.get('sortable')==true){
            	fileds.add((String) item.get('name'));
            }
        }
       String query= Util.queryBuilder(selectedToolingOBj, fileds,null);
        displayQuery = query;
        paginator.updateQuery(query);
        
    }
    
    public void updatePageSize(){
        //paginator.updatePageSize();
    }
    
    public class ExplainErrorResponse{
        String errorCode {get; set;}
        String message {get; set;}
    }
    
    
    
}