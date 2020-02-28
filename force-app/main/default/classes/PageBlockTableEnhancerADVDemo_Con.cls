public class PageBlockTableEnhancerADVDemo_Con {
    public List<sObject> getContacts(){
        //return [SELECT Id,FirstName,LastName,Account.Name,Email,BirthDate,LastModifiedDate FROM Contact ORDER BY FirstName];
        return [SELECT Id,payee__c, amount__c,LastModifiedDate  from Bill__c order by Bill_date__c];
    }
}