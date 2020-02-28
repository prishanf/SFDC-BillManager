public class Util {
    
    public static String STANDARD_OBJ ='SOBJ';
    public static String CUSTOM_OBJ ='COBJ';
	/**
	 * Tests specified new and old records for changes in specified set of fields.
	 * 
	 * @return <code>true</code> if changed; <code>false</code> otherwise.
	 */
	public static Boolean hasChanges(Set<String> fieldNames, SObject oldRecord, SObject newRecord) {
		if (oldRecord == null) {
			return true;
		}
		Boolean changed = false;
		for (String field : fieldNames) {
			changed = (oldRecord.get(field) != newRecord.get(field));
			if (changed) break;
		}
		return changed;
	}
	
    /**
	 * Return List of Pick list values for the given object and the picklist filed name
	 */
    public static List<String> getPickListValues(Sobject object_name, String field_name)
    {
        List<String> pList = new List<String>();
        Schema.sObjectType sobject_type = object_name.getSObjectType(); //grab the sobject that was passed
        Schema.DescribeSObjectResult sobject_describe = sobject_type.getDescribe(); //describe the sobject
        Map<String, Schema.SObjectField> field_map = sobject_describe.fields.getMap(); //get a map of fields for the passed sobject
        List<Schema.PicklistEntry> pick_list_values = field_map.get(field_name).getDescribe().getPickListValues(); //grab the list of picklist values for the passed field on the sobject
        for (Schema.PicklistEntry ple : pick_list_values){//for all values in the picklist list
            pList.add(ple.getLabel()); //add the value and label to our final list
        }  
        return pList;
    }

    public static string printGovernorLimits(){
        string printout='CPU Time:'+limits.getcputime()+'/'+limits.getlimitcputime()+'\n'+
            'SOQL:'+limits.getqueries()+'/'+limits.getlimitqueries()+'\n'+
            'SOSL:'+limits.getsoslqueries()+'/'+limits.getlimitsoslqueries()+'\n'+
            'Aggregate Queries:'+limits.getaggregatequeries()+'/'+limits.getlimitaggregatequeries()+'\n'+
            'Query Rows:'+limits.getqueryRows()+'/'+limits.getlimitqueryrows()+'\n'+
            'DML:'+limits.getdmlstatements()+'/'+limits.getlimitdmlstatements()+'\n'+
            'DML Rows:'+limits.getdmlrows()+'/'+limits.getlimitdmlrows()+'\n'+
            'Callouts:'+limits.getcallouts()+'/'+limits.getlimitcallouts()+'\n'+
            'Emails:'+limits.getemailinvocations()+'/'+limits.getlimitemailinvocations()+'\n'+
            'Futures:'+limits.getfuturecalls()+'/'+limits.getlimitfuturecalls()+'\n'+
            'Heap:'+limits.getheapsize()+'/'+limits.getlimitheapsize()+'\n'+
            'Queueable Jobs:'+limits.getqueueablejobs()+'/'+limits.getlimitqueueablejobs()+'\n';
        return printout;
    }
	
	/**Start New Util Methods added By Prishan on July 07 2015**/
    
    /**
     * Helper Method to get Record Type Id by Name
	 * @param String Object API Name
	 * @param String RecordType Name
	 * @return Id Id of the record type.
	 */
	public static id getRecordTypeIdByName(String object_name, String recordTypeName){
       	return getObjectTypeDescribe(object_name).getRecordTypeInfosByName().get(recordTypeName).getRecordTypeId();
	}
	/**
     * Helper Method to get the Record Type Id for the Given Record Type Name Defined under given sObject instance.
     * @param String objectInstance :Instance of the object 
     * @param String recordTypeName : Record Type Name.
     * @return Id RecordTypeId 
     * Usage: for(Account a : trigger.New){
    			Id recTypeid = Util.getRecordTypeIdByName(a,'ABC');
               }  
     */
    public static id getRecordTypeIdByName(Sobject objectInstance, String recordTypeName){
        return objectInstance.getSObjectType().getDescribe().getRecordTypeInfosByName().get(recordTypeName).getRecordTypeId();
    }
    
    /**
     * Helper Method to get the Record Type Name by Id
     * @param String objectName :API Name of the Sobject Example: Account, Product, Test__c
     * @param String recordTypeName : Record Type Name.
     * @return String Name of the record type 
     * 
     */
    public static String getRecordTypeNameById(String object_name, String recordTypeId){
       return getObjectTypeDescribe(object_name).getRecordTypeInfosById().get(recordTypeId).getName(); 
	}
    
    /**
     * Helper Method to get the Record Type Nmae for the Given Record Type Id Defined under given sObject instance.
     * @param String objectInstance :Instance of the object 
     * @param String recordTypeName : Record Type Name.
     * @return Id RecordTypeId 
     * Usage: for(Account a : trigger.New){
    			Id recTypeid = Util.getRecordTypeNameById(a,'ABC');
               }  
     */
    public static String getRecordTypeNameById(Sobject objectInstance, String recordTypeId){
       return objectInstance.getSObjectType().getDescribe().getRecordTypeInfosById().get(recordTypeId).getName(); 
	}
    
    /**
     * Helper method to Buitl Dynamic Query for the given sObject and FieldsSet Name
     * @param String objectName :API Name of the Sobject Example: Account, Product, Test__c
     * @param String fieldSetName : Fieldset name(API name) which avilabe under provied Sobject 
	 * @param List<String> filter : items under where clause join by 'And' Example: {'id=:varId'}
     * @return String SOQL query string
	 * Usage :  
	 *    String q = Util.queryBuilder('Product2', 'Rate_Show', new List<String>{'RecordType.Name= :recname'}); 
     */ 
    public static String queryBuilder(String objectName, String fieldSetName, List<String> filter){
        String query = 'select ';
        List<String> fieldList = getFieldSetFields(objectName, fieldSetName);
        return queryBuilder(objectName,fieldList,filter);
	}
    /**
     * Helper method to Buitl Dynamic Query for the given sObject and List of Fields
     * @param String objectName :API Name of the Sobject Example: Account, Product, Test__c
     * @param List<String> fields : List of Field name to be included in the query 
	 * @param List<String> filter : items under where clause join by 'And' Example: {'id=:varId'}
     * @return String SOQL query string
	 * Usage :  
     * String q = Util.queryBuilder('Product2', new List<String>{'id','Name'}, new List<String>{'RecordType.Name= :recname'}); 
     */
    public static String queryBuilder(String objectName, List<String> fields, List<String> filter){
        return queryBuilder(objectName,fields,filter,null);
	}
    
    /**
     * Helper method to Buitl Dynamic Query for the given sObject and List of Fields
     * @param String objectName :API Name of the Sobject Example: Account, Product, Test__c
     * @param List<String> fields : List of Field name to be included in the query 
	 * @param List<String> filter : items under where clause join by 'And' Example: {'id=:varId'}
	 * @param List<String> orbderBy Example: {'Name ASC'}
     * @return String SOQL query string
	 * Usage :  
     * String q = Util.queryBuilder('Product2', new List<String>{'id','Name'}, new List<String>{'RecordType.Name= :recname'},new List<String>{Name}); 
     */
    public static String queryBuilder(String objectName, List<String> fields, List<String> filter,List<string> orderBy){
        String query = 'SELECT ';
        query += String.join(fields,', ');
        query +=' FROM ' + objectName;
        if(filter!=null && filter.size()>0){
           query +=' WHERE ' + String.join(filter,' and '); 
    	}
        if(orderBy!=null && orderBy.size()>0){
            query +=' ORDER BY ' + String.join(orderBy,','); 
        }
       return query;
	}
    /**
     * Helper Method to get Fields Defined under given sObject and Field Set Name.
     * @param String objectName :API Name of the Sobject Example: Account, Product, Test__c
     * @param String fieldSetName : Field set name(API name) which avilabe under provied Sobject
     * @return List<String> return list of FieldNames  
     */
    public static List<String> getFieldSetFields(String object_name,String fsetName){
      	List<Schema.FieldSetMember> fieldset  = getFieldSetFieldsObjs(object_name,fsetName);
    	List<String> items = new List<String>();
        for(Schema.FieldSetMember f : fieldset) {
           	items.add(f.getFieldPath());    
        }
        return items;
	}
    /**
     * Helper Method to get Fields Objects Defined under given sObject and Field Set Name.
     * @param String objectName :API Name of the Sobject Example: Account, Product, Test__c
     * @param String fieldSetName : Field set name(API name) which avilabe under provied Sobject
     * @return List<Schema.FieldSetMember> return list of FieldObjects 
     */
    public static List<Schema.FieldSetMember> getFieldSetFieldsObjs(String object_name,String fsetName){
       return getObjectTypeDescribe(object_name).FieldSets.getMap().get(fsetName).getFields();
	}
    
    /**
     * Helper Method to get RecordTypes As Select Options for a given sObject
     * @param String objectName :API Name of the Sobject Example: Account, Product, Test__c
     * @return  List<SelectOption> return list of recodtypes  
     */
    public static List<SelectOption> getRecordTypesAsSelectOptions(String objectName){
        List<SelectOption> rtList = new List<SelectOption>();
        for(Schema.RecordTypeInfo rtypInfo : getObjectTypeDescribe(objectName).getRecordTypeInfosByName().values()){
           if(rtypInfo.getName()=='Master')
              continue;
           rtList.add(new SelectOption(rtypInfo.getRecordTypeId(),rtypInfo.getName()));
        }
        rtList.sort();
        return rtList;
    }
    
    /**
     * Helper Method to get the Index(position) of the sobject on a List compare by sobject Id 
     * @param List<sObject> Object List
     * @param sObject sObj : Sobject to search for.
     * @return Integer retrun the poistion of the list. if not found return -1 
     */
    public static Integer indexOf(List<sObject> items, sObject sObj){
       integer index =0;
        for(SObject item : items){
            if(item.id == sObj.id){
                return index;
            }
          index++;  
       }
       return -1;
    }
    
    public static Integer indexOf(List<String> items, String look,boolean ignoreCase){
       integer index =0;
        for(String item : items){
            if(ignoreCase){
                if(item.equalsignorecase(look)){
                	return index;
            	} 
            }else{
            	if(item.equals(look)){
                	return index;
            	}    
            }
            
          index++;  
       }
       return -1;
    }
    
    public static Schema.DescribeSObjectResult getObjectTypeDescribe(String object_name){
        Type t = Type.forName(object_name);
        return ((Sobject)t.newInstance()).getSObjectType().getDescribe();
    }
    
    
    /**End New Util Methods added By Prishan on July 07 2015**/
    
    /**Start New Util Methods added By Prishan on Jan 03 2016**/
     /**
     * Helper Method to get the updatable Field for the sobjectect
     * @param String objectname
     * @return List<String> list of updatable field Names 
     */
   /* public static List<String> getUpdatableFields(String object_name){
       Map<String, Schema.SObjectField> fieldMap = getObjectTypeDescribe(object_name).fields.getMap();
       List<String> updatableFields = new List<String>(); 
        for(Schema.SObjectField f : fieldMap.values()) {
            String fieldName = f.getDescribe().Name;
            if( f.getDescribe().isUpdateable() && !(fieldName=='OwnerId'))
				updatableFields.add(f.getDescribe().Name);
        }
        return updatableFields;
    }*/
    
    public static List<String> getUpdatableFields(String object_name){
       Map<String, Schema.SObjectField> fieldMap = getObjectTypeDescribe(object_name).fields.getMap();
       List<String> updatableFields = new List<String>(); 
        for(Schema.SObjectField f : fieldMap.values()) {
            String fieldName = f.getDescribe().Name;
            if(f.getDescribe().isCreateable()&& !(fieldName=='OwnerId'))
				updatableFields.add(f.getDescribe().Name);
        }
        return updatableFields;
    }
    
    public static List<Schema.DescribeFieldResult> getUpdatableDescribeFields(String object_name){
       Map<String, Schema.SObjectField> fieldMap = getObjectTypeDescribe(object_name).fields.getMap();
       List<Schema.DescribeFieldResult> updatableFields = new List<Schema.DescribeFieldResult>(); 
        for(Schema.SObjectField f : fieldMap.values()) {
            Schema.DescribeFieldResult fDes = f.getDescribe();
            String fieldName = fDes.Name;
            if(fDes.isCreateable()&& !(fieldName=='OwnerId'))
				updatableFields.add(fDes);
        }
        return updatableFields;
    }
    
    /**
     * Helper Method to get the Field Describer for a given object and field name
     * @param String objectname
     * @param String FieldName
     * @return List<String> list of updatable field Names 
     */
    public static Schema.DescribeFieldResult getFieldDescribe(String objectname,String fieldName){
       Map<String, Schema.SObjectField> fieldMap = getObjectTypeDescribe(objectname).fields.getMap();
       return fieldMap.get(fieldName).getDescribe();
    }
    /**End New Util Methods added By Prishan on Jan 03 2016**/
    
    public static Map<String, Schema.DescribeSObjectResult> getGlobalObjectMap(String objtype){
        Map<String, Schema.DescribeSObjectResult> filterMap = new Map<String, Schema.DescribeSObjectResult>();
        Map<String, Schema.SObjectType> objList  =  Schema.getGlobalDescribe();
        boolean isCustom =false;
        if(objtype.equals(Util.CUSTOM_OBJ)){
            isCustom = true;
        }
        for(SObjectType obj : objList.values())
        {
            Schema.DescribeSObjectResult objDes = obj.getDescribe();
            if(isCustom==objDes.isCustom() && objDes.isUpdateable()){
               filterMap.put(objDes.getName(),objDes);
            }
            
        }
    	return filterMap;
    } 

    public static List<SelectOption> getObjectAsSelectOptions(String objType){
        List<SelectOption>  selList = new List<SelectOption>();
        Map<String, Schema.DescribeSObjectResult> objMap = getGlobalObjectMap(objType);
        for(String key :objMap.keyset()){
        	selList.add(new SelectOption(key,objMap.get(key).getLabel()));
        }
        return selList;
    }
    
    public static List<SelectOption> getFiedlAsSelectOptions(String object_name){
      	List<SelectOption>  selList = new List<SelectOption>();
        List<Schema.DescribeFieldResult>  fieldList = getUpdatableDescribeFields(object_name);
        for(Schema.DescribeFieldResult f :fieldList){
        	selList.add(new SelectOption(f.getName(),f.getLabel()));
        }
        return selList;
    }
}