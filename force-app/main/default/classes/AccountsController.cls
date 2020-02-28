public class AccountsController {
    @AuraEnabled
    public static List<prishan__Account__c> getAccounts(){
        return [select id, name, prishan__Type__c, prishan__Current_Year_Expense_Total__c , prishan__Expense_Total__c from prishan__Account__c ORDER BY createdDate ASC];
    }
}