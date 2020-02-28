global class PropertyManagementDashboardCtrl {

    public String accountName { get; set; }
    public static List<prishan__Expense__c> expenses { get; set; }
    public PropertyManagementDashboardCtrl() { }
    
    @RemoteAction
     global static LIst<prishan__Expense__c> getExpenses(String accountName) {
        expenses = [select id, name, prishan__date__c, prishan__Expense_Type__c, prishan__Payee__c,prishan__Month_Year__c,prishan__Amount__c, prishan__Expense_Account__c 
                   from prishan__Expense__c 
                   where prishan__Expense_Account__r.Name =:accountName and date__c <= 2014-12-31 order by date__c];
        return expenses;
    }
}