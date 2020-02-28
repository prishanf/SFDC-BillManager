public class TestTriggerHandler {

    
    public static void onAfterInsert(Map<id,Test__c> newMap){
        List<Test__c>  testList = [select Payee__r.Category__r.Name from Test__c where id = :newMap.keySet()];
        for(Test__c t :testList){
            t.Number_1__c = t.Payee__r.Category__r.Name;
        }
        update testList;
    }
    
    public static void onbeforeUpdate(Map<id,Test__c> newMap){
        List<Test__c>  testList = [select id, Payee__r.Category__r.Name from Test__c where id = :newMap.keySet()];
        for(Test__c t :testList){
            Test__c  ct = newMap.get(t.id);
            ct.Number_1__c = t.Payee__r.Category__r.Name;
        }
    }
}