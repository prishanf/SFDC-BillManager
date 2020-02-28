@isTest
global class MockHttpResponseGenerator implements HttpCalloutMock {
    global HTTPResponse respond(HTTPRequest req) {
        String endPoint =  req.getEndpoint();
        System.assertEquals('GET', req.getMethod());
        HttpResponse res = new HttpResponse();
        
        res.setHeader('Content-Type', 'application/json');
        if(endPoint.indexOf('tooling')>0){
             res.setBody(getResponse(getToolingURLs(endPoint)));
        }
        res.setStatusCode(200);
        return res;
    }
    
    
    private String getToolingURLs(String endPoint){
        String[] parts = endPoint.split('tooling/');
        return 'tooling-'+parts[0];
    }
        
    public String getResponse(String key){
        System.debug('key: ' + key);
        Map<String,String>  resonses = new Map<String,String>{ 
            'tooling-sobjects' =>'{"encoding" : "UTF-8","maxBatchSize" : 200,"sobjects" : [ {"label" : "Apex Class","label" : "Apex Classes", "name" : "ApexClass",}]}',
            'tooling-sobjects/apexclass/describe' =>'{"encoding" : "UTF-8","maxBatchSize" : 200,"fields" : [ {"label" : "Apex Class","label" : "Apex Classes", "name" : "ApexClass",}]}'
        };
        return resonses.get(key.toLowerCase());
    }
}