public with sharing class SurveyManagerController {

	public sObject mysObject {get;set;}

    public List<Survey_Question__c> questions {get;set;}

    public Survey_Question__c question {get;set;}

    public Map<String,List<Survey_Question__c>> questionBySection {get;set;}

    public String currentCategory {get;set;}

    public List<SelectOption> categories {get;set;}

    public String newcategoryName {get;set;}

    // The extension constructor initializes the private member
    // variable mysObject by using the getRecord method from the standard
    // controller.
    public SurveyManagerController(ApexPages.StandardController stdController) {
        this.mysObject = (sObject)stdController.getRecord();
        if(mysObject!=null){
            this.questions = [select name, prishan__Question_Text__c,prishan__Choises__c,prishan__Type__c ,prishan__Section__c, prishan__Survey_Category__r.Name  from Survey_Question__c 
            where prishan__Survey_Category__c = :mysObject.id ];
            loadQuestions();
        }
        question = new Survey_Question__c();

        categories = new List<SelectOption>();
        for(Survey_Category__c cat :[select id, Name from Survey_Category__c]){
           categories.add(new SelectOption(cat.id, cat.Name));
        }

    }

    public String getRecordName() {
        return 'Hello ' + (String)mysObject.get('name') + ' (' + (Id)mysObject.get('Id') + ')';
    }
    public void addQuestion(){

    }

    public void saveInline(){
       update questions;
    }
    public void saveQuestion(){
       insert question;
       
       if(question.prishan__Question_Text__c.length()>50){
            question.Name = question.prishan__Question_Text__c.substring(0, 50) ;
            question.Name +='...';
       }else{
             question.Name = question.prishan__Question_Text__c;
       }
       question.prishan__Survey_Category__c = mysObject.id;
       this.questions.add(question);
       loadQuestions();

    }

    public void saveCategory(){
       Survey_Category__c cat  = new Survey_Category__c(Name=newcategoryName);
       insert cat;
       this.questions = [select name, prishan__Question_Text__c,prishan__Choises__c,prishan__Type__c,prishan__Section__c,prishan__Survey_Category__r.Name  from Survey_Question__c 
       where prishan__Survey_Category__c = :cat.id];
       categories.add(new SelectOption(cat.id, newcategoryName));
       currentCategory = cat.id;
       loadQuestions();
    }

    public void changeCategory(){
        this.questions = [select name, prishan__Question_Text__c,prishan__Choises__c,prishan__Type__c,prishan__Section__c,prishan__Survey_Category__r.Name  from Survey_Question__c 
         where prishan__Survey_Category__c = :currentCategory];
         loadQuestions();
    }

    private void loadQuestions(){
        questionBySection = new  Map<String,List<Survey_Question__c>>();
        for(Survey_Question__c q : this.questions){
            String sec = q.prishan__Section__c;
            if(questionBySection.containsKey(sec)){
                questionBySection.get(sec).add(q);
            }else{
                questionBySection.put(sec,new List<Survey_Question__c>{q});
            }
        }
        
    }

    
}