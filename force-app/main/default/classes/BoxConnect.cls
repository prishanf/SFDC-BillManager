public class BoxConnect {

   public string valueToShow{get;set;}
    public string outHttpHeader{get;set;}
    private final string boxClientID = 'x684wh8eba69radlkgik03j7mn2r6zux';
    private final string boxSecretCode = 'UYvriiWAINQXGvTwZGEhr7pONmGFQwTW';
    private final string redirectURI = 'https://prishan.na17.visual.force.com/apex/boxConnect';
    private string codeFromBox;
    private string accessToken;
    private string refreshToken;
    public boolean showConntect {get;set;}
    public String queryString {get;set;}
     
    public BoxConnect(){
        valueToShow = 'Start';
        //Check if we received the authorization code from Box because the redirectUI
        // URI points to this page.  It will look like this…
        //https://c.na9.visual.force.com/apex/boxconnect?state=&code=RETURNED_AUTH_CODE
        codeFromBox = System.currentPageReference().getParameters().get('code');
        if(codeFromBox == null || codeFromBox == ''){
             showConntect =true;
        }else{
            //Try to get a token and then make an API call to Box
            getBoxToken();         
        }
    }
     
    public pageReference boxConnect(){
        //Redirect to the OAuth page at Box so the login credentials can be entered.       
        PageReference pr = new PageReference('https://www.box.com/api/oauth2/authorize?' +
            'response_type=code' +
            '&client_id=' + boxClientID +
            '&redirect_uri=' + redirectURI);
        return pr;
    }  
     
    private void getBoxToken(){
    Http h = new Http();
        HttpRequest req = new HttpRequest();
        string endPointValue = 'https://www.box.com/api/oauth2/token';
        req.setEndpoint(endPointValue);
        req.setBody('Content-Type=' + EncodingUtil.urlEncode('application/x-www-form-urlencoded', 'UTF-8') +
                    '&charset=' + EncodingUtil.urlEncode('UTF-8', 'UTF-8') +
                    '&grant_type=' + EncodingUtil.urlEncode('authorization_code', 'UTF-8') +
                    '&code=' + EncodingUtil.urlEncode(codeFromBox, 'UTF-8') +
                    '&client_id=' + EncodingUtil.urlEncode(boxClientID, 'UTF-8') +
                    '&client_secret=' + EncodingUtil.urlEncode(boxSecretCode, 'UTF-8') +
                    '&redirect_uri=' + EncodingUtil.urlEncode(redirectURI, 'UTF-8'));
        req.setMethod('POST');
        HttpResponse res = h.send(req);
        //Get back this… {"access_token":"RETURNED_ACCESS_TOKEN",
        //                   "expires_in":3600,
        //                   "refresh_token":"RETURNED_REFRESH_TOKEN",
        //                   "token_type":"bearer"}
        parseAuthJSON(res.getBody());
        if(accessToken != null & accessToken != ''){
            //Try to get items from a folder in Box
            //getBoxFolder();
            showConntect =false;
        }else{
            //Just some debug lines to see the request and response
            valuetoShow = 'Get Authorization Code Return: ' + res.getBody() + ' end point value: ' + endPointValue + 'request: ' +
                req.toString() + 'request headers: ' + req.getHeader('Content-Type') + '; ' + req.getHeader('charset') +
                'request body: ' + req.getBody();
        }      
    }
    
    public pageReference doQuery(){
        valuetoShow = queryString;
        Http h = new Http();
        HttpRequest req = new HttpRequest();
        string endPointValue = 'https://api.box.com/2.0/'+queryString;
        req.setEndpoint(endPointValue);
        req.setHeader('Authorization', 'Bearer ' + accessToken);
        req.setHeader('Accept-Encoding', 'gzip');
        req.setMethod('GET');
        HttpResponse res = h.send(req);
        //Now we could parse through the JSON again and get the values that we want
        valuetoShow = valuetoShow + '<br/> Get Folder: ' + res.getBody();
        outHttpHeader ='';
        for(String key :res.getHeaderKeys()){
            if(key!=null && key!='' ){
            outHttpHeader = outHttpHeader + ' , ' +key + ':'+res.getHeader(key);    
            }
            
        }
        
        if(res.getHeader('Location')!=null){
           PageReference pr =new PageReference(res.getHeader('Location'));
            pr.setRedirect(true);
           return pr;
        }
        
        
        
        
        return null;
    }
    
    public pageReference getBoxFolder(){
        Http h = new Http();
        HttpRequest req = new HttpRequest();
        string endPointValue = 'https://api.box.com/2.0/folders/2739190110/items'; //?limit=5&offset=0
        //Returns this: {"total_count":2,"entries":[
        //    {"type":"file","id":"8308841816","sequence_id":"0","etag":"0","sha1":"6dce26ad1a3578a00a40722ec4472abc143313cf",
        //       "name":"Luschen Quote for West Fargo Property.pdf"},
        //    {"type":"file","id":"8308878690","sequence_id":"1","etag":"1","sha1":"5b595457a86396ddf45318d1ab9ddd6aa3b7bc1e",
        //       "name":"New Google Doc 1.gdoc"}
        //    ],"offset":0,"limit":100,"order":[{"by":"type","direction":"ASC"},{"by":"name","direction":"ASC"}]}
         
        //This one works to get the properties for a specific file     
        //endPointValue = 'https://api.box.com/2.0/files/8308878690?fields=modified_at,path_collection,name';
        //Returns this {"type":"file","id":"8308878690","etag":"1","modified_at":"2013-05-25T16:08:52-07:00",
        //    "path_collection":{"total_count":2,"entries":[
        //    {"type":"folder","id":"0","sequence_id":null,"etag":null,"name":"All Files"},
        //    {"type":"folder","id":"904543862","sequence_id":"1","etag":"1","name":"Buy Fargo Home"}
        //    ]},"name":"New Google Doc 1.gdoc"}
        req.setEndpoint(endPointValue);
        req.setHeader('Authorization', 'Bearer ' + accessToken);
        req.setMethod('GET');
        HttpResponse res = h.send(req);
        //Now we could parse through the JSON again and get the values that we want
        valuetoShow = 'Get Folder: ' + res.getBody();  
        return null;
    }
     
    private void parseAuthJSON(string JSONValue){
        JSONParser parser = JSON.createParser(JSONValue);
        accessToken = '';
        refreshToken = '';
        while (parser.nextToken() != null) {
            if(parser.getCurrentToken() == JSONToken.FIELD_NAME){
                if(parser.getText() == 'access_token'){
                    parser.nextToken();
                    accessToken = parser.getText();
                }
                if(parser.getText() == 'refresh_token'){
                    parser.nextToken();
                    refreshToken = parser.getText();
                }
            }
            if(accessToken != '' && refreshToken != ''){
                break;
            }
        }
    }
}