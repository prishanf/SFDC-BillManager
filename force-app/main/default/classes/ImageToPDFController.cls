public class ImageToPDFController {

    
    public PageReference doAction(){
    	String  recId = ApexPages.currentPage().getparameters().get('id');
        recId = 'a0Ho000000DsLfU';
        System.debug('recId ' + recId);
        String requestURL = '/apex/ImagePreviewPage?id='+recId;
        BloB  asPDF= new PageReference(requestURL).getContentAsPDF();
        //0B7eA6VMmrKVTWEFxRjFuUDNVV28
        //getCalloutResponseContents(asPDF);
        //UploadFile(asPDF);
        // createFolder();
        //GoogleDriveAPI.folderTest();
        GoogleDriveAPI api = new GoogleDriveAPI();
        api.uploadFile('testfile','pdf', '0B7eA6VMmrKVTWEFxRjFuUDNVV28', asPDF);
        
        //System.debug('asPDF BLOB '+ asPDF);
        /*
        Attachment a1 = new Attachment();
        a1.parentId = recId;
        a1.Body = asPDF;
        a1.Name = 'Converted to PDF.pdf'; 
    
        insert a1;   
        PageReference pr = new PageReference('/recId');
        return pr;
        
        Http h = 
        */
        return null;
    }
    
  

 
  public static void getCalloutResponseContents(BloB body) {
		String accessToken = Auth.AuthToken.getAccessToken('0SOo00000004Cmo', 'Open ID connect');
      
      // String accessToken = 'ya29.CjHZAn1wCWimQhS_APoOPF_CyqF1wmJyAU3MRpeobbC1BB6wZgngB_v0vIo2rjjmhvZy';
     
        // Instantiate a new http object
       
        Http h = new Http();
         // Instantiate a new HTTP request, specify the method (GET) as well as the endpoint
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://www.googleapis.com/upload/drive/v3/files?uploadType=multipart');
        req.setMethod('POST');
        req.setBody('{ "title" : "mypdf" , "name" : "abcd" }');
      
        req.setHeader('Authorization', 'Bearer '+ accessToken);
        req.setHeader('name', 'pdf receipt');
    
        // Send the request, and return a response
        System.debug('req' + req);
        HttpResponse res = h.send(req);
       System.debug('resp' + res);
      System.debug('resp' + res.getBody());
      System.debug('resp' + res.getHeaderKeys());

      /*
      	Http http = new Http();
        HttpRequest req = new HttpRequest();
        req.setMethod('POST');
        req.setEndpoint('https://www.googleapis.com/upload/drive/v2/files?uploadType=media');
        req.setHeader('content-type', 'text/plain');
        req.setHeader('Authorization','Bearer '+ accessToken);
        String messageBody = 'Hi, This message is from Salesforce';
        req.setBody(messageBody);  
        req.setTimeout(60*1000);
        HttpResponse resp = http.send(req); 
       System.debug('resp' + resp);*/
        
 
	}
    
    public  static void UploadFile(BloB bbody){
       String accessToken = Auth.AuthToken.getAccessToken('0SOo00000004Cmo', 'Open ID connect');
       String filename ='textpdf';
       String cfiletype ='application/pdf'; 
       String filetype ='pdf';  
       String boundary = '----------9889464542212';
       String delimiter = '\r\n--' + boundary +'\r\n';
       String close_delim = '\r\n--' + boundary + '--';
       String bodyEncoded = EncodingUtil.base64Encode(bbody);
       String body=delimiter+'Content-Type: application/json\r\n\r\n'
           //+ '{ "title" : "'+ filename+'",'+' "filetype" : "'+ filetype+ '" }'
           + getFileMetadataAsJSON()
           +delimiter+'Content-Type: ' + cfiletype 
           + '\r\n'+'Content-Transfer-Encoding: base64\r\n'+'\r\n'+bodyEncoded+close_delim;
       Http http = new Http();
       HttpRequest req = new HttpRequest();
       req.setEndpoint('https://www.googleapis.com/upload/drive/v2/files?uploadType=multipart');
       req.setHeader('Authorization', 'Bearer ' +accessToken);
       req.setHeader('Content-Type', 'multipart/mixed; boundary="'+boundary+'"');
       req.setHeader('Content-length', String.valueOf(body.length()));
       req.setBody(body);
       req.setMethod('POST');
       req.setTimeout(60*1000);
       HttpResponse resp = http.send(req);
       //System.debug('@@@@@@@---'+resp.getbody());
       Map<String, Object> m = (Map<String, Object>) JSON.deserializeUntyped(resp.getbody());
       for(String k : m.keySet()){
       		system.debug(k +' '+ m.get(k));	     
       }
       
   }
    
    public static String getFileMetadataAsJSON(){
       Map<String,Object> meta = new  Map<String,Object>();
        meta.put('title','testPDFNew');
        meta.put('filetype','pdf');
        Map<String,String> parent = new Map<String,String>();
        parent.put('id','0B7eA6VMmrKVTelc1akVLbmZvVFE');
        parent.put('isRoot','true');
        List<Map<String,String>> parents = new List<Map<String,String>>();
        parents.add(parent);
        meta.put('parents',parents);
        //0B7eA6VMmrKVTX1Z3cTYwaE8tcUE
        return JSON.serializePretty(meta);
        
    } 
    
    public static void createFolder(){
        String accessToken = Auth.AuthToken.getAccessToken('0SOo00000004Cmo', 'Open ID connect');
        
      	Http http = new Http();
        HttpRequest req = new HttpRequest();
        req.setMethod('POST');
        req.setEndpoint('https://www.googleapis.com/drive/v2/files');
        req.setHeader('content-type', 'application/json');
        req.setHeader('Authorization','Bearer '+ accessToken);
        
        Map<String,String> meta = new  Map<String,String>();
        meta.put('name','testFolder');
        //meta.put('mimeType','application/vnd.google-apps.folder');
        string body='{"title": "prishanTest","parents": [{"id":"0B7eA6VMmrKVTX1Z3cTYwaE8tcUE"}],"mimeType": "application/vnd.google-apps.folder"}';
      
        req.setBody(body);  
        req.setTimeout(60*1000);
        HttpResponse resp = http.send(req); 
       
        
    }
    
    
    
    
    public static void printResp(String resp){
       Map<String, Object> m = (Map<String, Object>) JSON.deserializeUntyped(resp);
       for(String k : m.keySet()){
       		system.debug(k +' '+ m.get(k));	     
       }
    }
}