public class BillListCtrl {
    
	public static List<Schema.SObjectField> fields = new List<Schema.SObjectField>{
        prishan__Bill__c.Id,
        prishan__Bill__c.Name,
        prishan__Bill__c.bill_date__c,
        prishan__Bill__c.prishan__Paid__c,
        prishan__Bill__c.prishan__Payee__c.Name  
    };
        
    public static List<Map<String,String>> Relationfields = new List<Map<String,String>>{
        new Map<String,String>{'Name'=>'prishan__Payee__r.Name','Label'=>'Payee Name'},
        new Map<String,String>{'Name'=>'prishan__Payee__r.Name','Label'=>'Payee Name'},
        new Map<String,String>{'Name'=>'prishan__Payee__r.Name','Label'=>'Payee Name'}    
		
    };
        
   public List<Schema.SObjectField> getField(){
       System.debug(LoggingLevel.ERROR,' fldSetName ' + prishan__Bill__c.prishan__Payee__c.Name.getDescribe()); 
      return fields;
   }
    
   public List<Map<String,String>> getRelationField(){
       System.debug(LoggingLevel.ERROR,' fldSetName ' + prishan__Bill__c.prishan__Payee__c.Name.getDescribe()); 
      return Relationfields;
   } 
    
   public List<Object> getALLFields(){
      List<Object> anyTypeF = new List<Object>();
      anyTypeF.addAll((List<Object>)fields);
      anyTypeF.addAll((List<Object>)Relationfields);
      return anyTypeF;
   }  
}