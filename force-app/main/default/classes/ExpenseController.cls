public class ExpenseController {
    @AuraEnabled
    public static List<Expense__c> getExpenses() {
        return [SELECT id, name, prishan__amount__c, createdDate FROM prishan__Expense__c Limit 10];
    }
    
    @AuraEnabled
    public static Expense__c saveExpense(Expense__c expense) {
        upsert expense;
        return expense;
    }
    
     @AuraEnabled
    public static Expense__c getDetails(String rid){
         return [SELECT id, name, prishan__amount__c, createdDate FROM prishan__Expense__c where id =:rid];
    }
    
    @AuraEnabled
    public static String getObjectFields(String objectName){
        List<Schema.DescribeFieldResult> fieldDes = new  List<Schema.DescribeFieldResult>();
        List<String> fields = Util.getUpdatableFields(objectName);	
        for(String field: fields){
           fieldDes.add(Util.getFieldDescribe(objectName, field));
        }
        return  JSON.serializePretty(fieldDes);
    }
}