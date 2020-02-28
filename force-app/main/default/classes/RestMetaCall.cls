public class RestMetaCall {

    
    
    public static void sendNotification() {
  
        Map<String,List<Object>> sectionFieldsMap= new Map<String,List<Object>>();
        HttpRequest req = new HttpRequest();
        HttpResponse res = new HttpResponse();
        Http http = new Http();

        req.setEndpoint('https://na17.salesforce.com/services/data/v34.0/sobjects/prishan__Bill_Category__c/describe/layouts/');
        req.setMethod('GET');
        req.setHeader('Authorization', 'Bearer ' + UserInfo.getSessionId());
        //req.setBody('name='+EncodingUtil.urlEncode(name, 'UTF-8')+'&city='+EncodingUtil.urlEncode(city, 'UTF-8'));
        req.setCompressed(true); // otherwise we hit a limit of 32000

        try {
            res = http.send(req);
            System.debug(LoggingLevel.ERROR, res.getBody());
            for(String k : res.getHeaderKeys()){
                if(k!=null)
                System.debug(LoggingLevel.ERROR, k+' : '+res.getHeader(k));
            }
            
            Map<String,Object> data = (Map<String,Object>)JSON.deserializeUntyped(res.getBody());
        	List<object> keys= (List<object>) data.get('layouts');
            Map<String,Object> layout = (Map<String,Object>) keys[0];
            List<object> detailLayoutSections=(List<object> ) layout.get('detailLayoutSections');
            for(Object obj : detailLayoutSections){
				Map<String,Object> section = (Map<String,Object>) obj;  
                String heading = (String) section.get('heading');
                List<object> layoutRows = (List<object>)section.get('layoutRows');
                    for(Object row :layoutRows){
                        Map<String,Object> layoutRow = (Map<String,Object>) row; 
                        List<object> layoutItems = (List<object>) layoutRow.get('layoutItems');
                        for( Object layoutItem : layoutItems){
                            Map<String,Object> field = (Map<String,Object>) layoutItem; 
                             if(sectionFieldsMap.containsKey(heading)){
                                sectionFieldsMap.get(heading).add(field);
                           	 }else{
                                List<Object> f= new List<Object>();
                                 f.add(field);
                                sectionFieldsMap.put(heading, f);
                              }
                        }
                    }
               
              
            }
            System.debug(LoggingLevel.ERROR, sectionFieldsMap);
            
            for(String secs : sectionFieldsMap.keySet()){
               System.debug(LoggingLevel.ERROR, secs);
                for(object fls : sectionFieldsMap.get(secs)){
                    Map<String,Object> fieldInfo = (Map<String,Object>) fls; 
                    List<object> layoutComponents = (List<object> ) fieldInfo.get('layoutComponents');
                    if(layoutComponents.size()>0){
                        Map<String,Object> layoutComponent  = (Map<String,Object>) layoutComponents.get(0);
                        if(layoutComponent.get('type')=='Field'){
                           Map<String,Object> fieldDetails = (Map<String,Object>) layoutComponent.get('details');
                            System.debug(LoggingLevel.ERROR, fieldDetails.get('name') +':' +fieldDetails.get('label') );
                        }else{
                        	System.debug(LoggingLevel.ERROR, layoutComponent.get('type'));    
                        }
                    	
                    }    
                } 
                 System.debug(LoggingLevel.ERROR, '===============================');
            }
            
        } catch(System.CalloutException e) {
            System.debug('Callout error: '+ e);
            System.debug(res.toString());
        }

    }

}