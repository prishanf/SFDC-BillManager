public class DataTableWrapperCtrl {
    public List<Object> flds {get;set;}
    public String objectName {get;set;}
    public String fldSetName {get;set;}
       
    public String getData(){
        String query = 'SELECT {0} from {1}';
        String field = String.join(new List<String>(getFields().keySet()), ',');
        query = String.format(query, new List<String>{field,objectName});
        
        System.debug(LoggingLevel.ERROR,'query ' + query);
            List<Sobject> data = Database.query(query);
        return JSON.serialize(data);
        
    }
    
    public String getTableId(){
        return 'DataTable'+ Datetime.now().millisecond();
    }
    
    public String getColumJSON(){
        Map<String,String> fldMap = getFields();
        List<Map<String,String>> columns = new List<Map<String,String>>();
        for(String f : fldMap.keyset()){
           columns.add(new Map<String,String>{'data'=>f,'title'=>fldMap.get(f)});
             
        }
        return JSON.serialize(columns);
    }
    
    public static List<Schema.SObjectField> fields = new List<Schema.SObjectField>{
        prishan__Bill__c.Id,
        prishan__Bill__c.Name,
        prishan__Bill__c.bill_date__c,
        prishan__Payee__c.Name
    };
    
	/*@RemoteAction
    public static Map<String,List<Object>> getBills(){
        
        Map<String,List<Object>> result= new Map<String,List<Object>>();
        Map<String,String> fldMap = getFieldMap();
        List<Map<String,String>> columns = new List<Map<String,String>>();
        for(String f : fldMap.keyset()){
           columns.add(new Map<String,String>{'data'=>f,'title'=>fldMap.get(f)});
             
        }
        result.put('cols',columns);
        result.put('data',[select id, name, bill_date__c, payee__r.name, amount__c from Bill__c]);  
		return result;	       

    	//return [select id, name, bill_date__c, payee__r.name, amount__c from Bill__c];
    }*/
    
    public static Map<String,String> getFieldMap(){
        Map<String,String> flds = new Map<String,String>();
        for(Schema.SObjectField f :fields){
           flds.put(f.getDescribe().getName(),f.getDescribe().getLabel());
        }
        return flds;
    }
    
    public Map<String,String> getFields(){
        System.debug(LoggingLevel.ERROR,' fldSetName ' + fldSetName);
        Map<String,String> fldsM = new Map<String,String>();
        if(fldSetName!= null && fldSetName ==''){
            
            List<Schema.FieldSetMember> fieldset  = getFieldSetFieldsObjs(objectName,fldSetName);
            List<String> items = new List<String>();
            for(Schema.FieldSetMember f : fieldset) {
                fldsM.put(f.getFieldPath(),f.getLabel());
            }
        }
        System.debug(LoggingLevel.ERROR,' flds ' + flds);
        if(flds != null && !flds.isEmpty()){
             for(Object f :flds){
                 if(f instanceof Schema.SObjectField){
                     Schema.SObjectField fs = (Schema.SObjectField)f;
                     fldsM.put(fs.getDescribe().getName(),fs.getDescribe().getLabel());
                 }else if(f instanceof Map<String,String>){
                     Map<String,String> fm = (Map<String,String>)f;
                     fldsM.put(fm.get('Name'),fm.get('Label'));
             	}
             }
        }
        return fldsM;
    }
    
    public static Schema.DescribeSObjectResult getObjectTypeDescribe(String object_name){
        System.debug(object_name);
        Type t = Type.forName(object_name);
        return ((Sobject)t.newInstance()).getSObjectType().getDescribe();
    }
    
     public static List<String> getFieldSetFields(String object_name,String fsetName){
      	List<Schema.FieldSetMember> fieldset  = getFieldSetFieldsObjs(object_name,fsetName);
    	List<String> items = new List<String>();
        for(Schema.FieldSetMember f : fieldset) {
           	items.add(f.getFieldPath());    
        }
        return items;
	}
    
     public static List<Schema.FieldSetMember> getFieldSetFieldsObjs(String object_name,String fsetName){
       return getObjectTypeDescribe(object_name).FieldSets.getMap().get(fsetName).getFields();
	}
    
    
}