public with sharing class SurveyCreateController {

	public Survey__c mysObject {get;set;}

    public String currentCategory {get;set;}

    public List<SelectOption> categories {get;set;}

    private String accId;

    // The extension constructor initializes the private member
    // variable mysObject by using the getRecord method from the standard
    // controller.
    public SurveyCreateController(ApexPages.StandardController stdController) {
        this.mysObject = new Survey__c();
        accId = ApexPages.currentPage().getParameters().get('retURL');
        accId = accId.substring(1);
        System.debug('Acc ' + AccId);
        Map<string,String> mp = ApexPages.currentPage().getParameters();
        for(String k : mp.keySet()){
            System.debug(k +'  '+ mp.get(k));
        }
        categories = new List<SelectOption>();
        for(Survey_Category__c cat :[select id, Name from Survey_Category__c]){
           categories.add(new SelectOption(cat.id, cat.Name));
        }
    }

    public String getRecordName() {
        return 'Hello ' + (String)mysObject.get('name') + ' (' + (Id)mysObject.get('Id') + ')';
    }

    public void create(){
        mysObject.prishan__Survey_Category__c = currentCategory;
        mysObject.prishan__Account__c = accId;
        insert mysObject;
        List<prishan__Survey_Question_Response__c> resp = new List<prishan__Survey_Question_Response__c>();
        List<Survey_Question__c> question = [select name, prishan__Question_Text__c,prishan__Choises__c,prishan__Type__c,prishan__Section__c,prishan__Survey_Category__r.Name  from Survey_Question__c 
         where prishan__Survey_Category__c = :currentCategory];
         for(Survey_Question__c q  :question){
            resp.add(new prishan__Survey_Question_Response__c(prishan__Survey__c=mysObject.id,prishan__Survey_Question__c=q.id));
         }
         insert resp;
    }
}