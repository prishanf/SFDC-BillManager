public class GoogleDriveAPI {

	private String authProvideId = prishan__KeyValueTable__c.getValues('GoogleAuthProvide').prishan__value__c;
	private Http http = new Http(); 
    private String accessToken;
    
    public GoogleDriveAPI(){
        accessToken = Auth.AuthToken.getAccessToken(authProvideId, 'Open ID connect');
        Map<String, String> responseMap = Auth.AuthToken.refreshAccessToken(authProvideId, 'Open ID connect', accessToken);
        accessToken = responseMap.get('AccessToken');
    }
   
    public String createFolder(String folderName,String parentFolderId){
        HttpRequest req = getReuest();
        req.setEndpoint('https://www.googleapis.com/drive/v2/files');
        req.setHeader('content-type', 'application/json');
        String body= getFolderMetadataAsJSON(folderName,parentFolderId);
        req.setBody(body);  
        req.setTimeout(60*1000);
        HttpResponse resp = http.send(req); 
        Map<String, Object> respMap = (Map<String, Object>) JSON.deserializeUntyped(resp.getBody());
        printMap(respMap);
        return (String) respMap.get('id');
    }
    
    private HttpRequest getReuest(){
        HttpRequest req = new HttpRequest();
        req.setMethod('POST');
        req.setHeader('Authorization','Bearer '+ accessToken);
        return req;
    }
    
    public Map<String, Object> uploadFile(String fileName,string filetype ,String FolderId, BLOB filebody){
       String cfiletype ='application/octet-stream'; 
       String boundary = '----------9889464542212';
       String delimiter = '\r\n--' + boundary +'\r\n';
       String close_delim = '\r\n--' + boundary + '--';
       String bodyEncoded = EncodingUtil.base64Encode(filebody);
       String body=delimiter+'Content-Type: application/json\r\n\r\n'
           + getFileMetadataAsJSON(fileName,filetype,FolderId)
           + delimiter+'Content-Type: ' + cfiletype 
           + '\r\n'+'Content-Transfer-Encoding: base64\r\n'+'\r\n'+bodyEncoded+close_delim;
       HttpRequest req = getReuest();
       req.setEndpoint('https://www.googleapis.com/upload/drive/v2/files?uploadType=multipart');
       req.setHeader('Content-Type', 'multipart/mixed; boundary="'+boundary+'"');
       req.setHeader('Content-length', String.valueOf(body.length()));
       req.setBody(body);
       req.setMethod('POST');
       req.setTimeout(60*1000);
       HttpResponse resp = http.send(req);
       Map<String, Object> respMap = (Map<String, Object>) JSON.deserializeUntyped(resp.getBody());
        printMap(respMap);
       return respMap;
        
    }
    
    public static void printMap(Map<String,Object > m){
       for(String k : m.keySet()){
       		system.debug(k +' '+ m.get(k));	     
       }
    }
    
    public static void print(object obj){
        System.debug(obj);
    }

   
    
    public static String getFileMetadataAsJSON(String title,String filetype, String folderId){
       Map<String,Object> meta = new  Map<String,Object>();
       meta.put('title', title);
       meta.put('filetype',filetype);
       if(folderId!=null){
            Map<String,String> parent = new Map<String,String>();
            parent.put('id',folderId);
            parent.put('isRoot','true');
            List<Map<String,String>> parents = new List<Map<String,String>>();
            parents.add(parent);
            meta.put('parents',parents);
        }             
       return JSON.serializePretty(meta);
        
    } 
    
    public static String getFolderMetadataAsJSON(String title,String folderId){
       Map<String,Object> meta = new  Map<String,Object>();
       meta.put('title', title);
       meta.put('mimeType', 'application/vnd.google-apps.folder');
       if(folderId!=null){
            Map<String,String> parent = new Map<String,String>();
            parent.put('id',folderId);
            List<Map<String,String>> parents = new List<Map<String,String>>();
            parents.add(parent);
            meta.put('parents',parents);
        }             
       return JSON.serializePretty(meta);
        
    } 
    
    public static void folderTest(){
        GoogleDriveAPI drive = new GoogleDriveAPI();
        String fldId = drive.createFolder('rootTestFolder', null);
        System.debug('fldId' + fldId);
        String cfldId  = drive.createFolder('ChildTestFolder', fldId);
        System.debug('cfldId' + cfldId);
        
    }
}