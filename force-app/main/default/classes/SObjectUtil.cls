public class SObjectUtil {
    
    public static String getObjectNameById(Id objId){
        return objId.getSobjectType().getDescribe().getName();
    }
    
    public static id getRecordTypeIdByName(String object_name, String recordTypeName){
        List<String> pList = new List<String>();
    	Type t = Type.forName(object_name);
        Schema.sObjectType sobject_type = ((Sobject)t.newInstance()).getSObjectType();
     	return sobject_type.getDescribe().
       		getRecordTypeInfosByName().get(recordTypeName).getRecordTypeId();
	}
    
    public static id getRecordTypeNameById(String object_name, String recordTypeId){
        List<String> pList = new List<String>();
    	Type t = Type.forName(object_name);
        Schema.sObjectType sobject_type = ((Sobject)t.newInstance()).getSObjectType();
     	return sobject_type.getDescribe().
       		getRecordTypeInfosById().get(recordTypeId).getName();
	}
    
    public static id getRecordTypeIdByDeveloperName(String object_name, String recordTypeDeveloperName){
        RecordType rcdType = [Select Id From RecordType where SobjectType = :object_name and DeveloperName = :recordTypeDeveloperName];
        return rcdType.id;
    }
    
    public static List<String> getALLRecordTypeNames(String object_name){
        List<String> pList = new List<String>();
    	Type t = Type.forName(object_name);
        Schema.sObjectType sobject_type = ((Sobject)t.newInstance()).getSObjectType();
        pList.addAll(sobject_type.getDescribe().getRecordTypeInfosByName().keySet());
    	pList.sort();
        return pList;
    }
    
    public List<String> getAllFields(String object_name){
        List<String> pList = new List<String>();
    	Type t = Type.forName(object_name);
        Schema.sObjectType sobject_type = ((Sobject)t.newInstance()).getSObjectType();
        pList.addAll(sobject_type.getDescribe().fields.getMap().keySet());
    	pList.sort();
    	return pList;
   }
   
    public static List<String> getFieldSets(String object_name){
        List<String> pList = new List<String>();
    	Type t = Type.forName(object_name);
        Schema.sObjectType sobject_type = ((Sobject)t.newInstance()).getSObjectType();
        List<String> fieldset  = new List<String>(sobject_type.getDescribe().FieldSets.getMap().keySet());
        return fieldset;
	}
    
    public static List<Schema.FieldSetMember> getFieldSetFields(String object_name,String fsetName){
        List<Schema.FieldSetMember> pList = new List<Schema.FieldSetMember>();
    	Type t = Type.forName(object_name);
        Schema.sObjectType sobject_type = ((Sobject)t.newInstance()).getSObjectType();
        pList= sobject_type.getDescribe().FieldSets.getMap().get(fsetName).getFields();
    	return pList;
    }
    
    public static List<Schema.DescribeFieldResult> getFields(String object_name){
        return getFields(object_name,true);
    }
    
    public static List<Schema.DescribeFieldResult> getFields(String object_name,boolean sortByname){
        List<Schema.DescribeFieldResult> pList = new List<Schema.DescribeFieldResult>();
    	Type t = Type.forName(object_name);
        Schema.sObjectType sobject_type = ((Sobject)t.newInstance()).getSObjectType();
        if(sortByname){
       		List<String> l = new List<String>();
        	l.addAll(sobject_type.getDescribe().fields.getMap().keySet());
        	l.sort();
           	for( String key: l){
                SObjectField f = sobject_type.getDescribe().fields.getMap().get(key);
                Schema.DescribeFieldResult fd = f.getDescribe();
                if(fd.isCustom()){
                   pList.add(fd);
                }    
           }
        }else{
             for(SObjectField f: sobject_type.getDescribe().fields.getMap().values()){
                Schema.DescribeFieldResult fd = f.getDescribe();
                if(fd.isCustom()){
                   pList.add(fd);
                }    
             }
        }     
       return pList;
    }
    
    public static List<String> getFields(Sobject object_name, boolean onlyEditable){
       List<String> fList = new List<String>();
       for( SObjectField f: object_name.getSObjectType().getDescribe().fields.getMap().values()){
            Schema.DescribeFieldResult field = f.getDescribe();
            if(onlyEditable){
                if(field.isUpdateable())
                	fList.add(field.name);
            }else{
                fList.add(field.name);
            }    
       }
       return fList;
    }
    
    public static List<String> getFieldSetFields(String object_name,String fsetName,boolean api){
        List<String> pList = new List<String>();
    	Type t = Type.forName(object_name);
        Schema.sObjectType sobject_type = ((Sobject)t.newInstance()).getSObjectType();
		List<Schema.FieldSetMember> fieldset  = sobject_type.getDescribe().FieldSets.getMap().get(fsetName).getFields();
    	String fields='';
    	List<String> items = new List<String>();
        for(Schema.FieldSetMember f : fieldset) {
            if(api){
            	items.add(f.getFieldPath());    
            }else{
                items.add(getFieldLabel(object_name, f.getFieldPath()));    
            }
        }
        return pList;
	}
    
    public static String getFieldLabel(String objectName, String fieldApiName){
        List<Schema.DescribeSObjectResult> describeSobjectsResult = Schema.describeSObjects(new List<String>{objectName}); // this can accept list of strings, we describe only one object here
        String objectLabel = describeSobjectsResult[0].getLabel();
        Map<String, Schema.SObjectField> allFields = describeSobjectsResult[0].fields.getMap();
        return allFields.get(fieldApiName).getDescribe().getLabel();
    }
    

}