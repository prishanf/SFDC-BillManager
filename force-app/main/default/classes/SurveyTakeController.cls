public with sharing class SurveyTakeController {

	private final sObject mysObject;

    public List<Survey_Question_Response__c> questionResponse = new List<Survey_Question_Response__c>();

    public Map<String, List<Survey_Question_Response__c>> questionMap { get;set;}

    public List<String> sectionNames {get;set;}

    private String surveyId = 'a0bo0000007o0vn';

    // The extension constructor initializes the private member
    // variable mysObject by using the getRecord method from the standard
    // controller.
    public SurveyTakeController(ApexPages.StandardController stdController) {
        this.mysObject = (sObject)stdController.getRecord();
        sectionNames = new List<String>();
        questionMap = new Map<String, List<Survey_Question_Response__c>>();
        loadQuestions();
    }

    public String getRecordName() {
        return 'Hello ' + (String)mysObject.get('name') + ' (' + (Id)mysObject.get('Id') + ')';
    }


    public  List<Survey_Question_Response__c> getQuestions(){
        return [SELECT id, prishan__Survey_Question__r.prishan__Question_Text__c, prishan__Survey_Question__r.prishan__Section__c, 
            prishan__Response__c, prishan__Survey_Question__r.prishan__Type__c , prishan__Survey_Question__r.prishan__Section_Order__c, 
            prishan__Survey_Question__r.prishan__Order__c  
            FROM prishan__Survey_Question_Response__c 
            where prishan__Survey__c='a0bo0000007o0vn' 
            order by prishan__Survey_Question__r.prishan__Section_Order__c, prishan__Survey_Question__r.prishan__Order__c];
    }

   /* public  List<Survey_Question_Response__c> getQuestions(){
        List<prishan__Survey_Question_Response__c> SQRList =  [SELECT prishan__Survey_Question__c
            FROM prishan__Survey_Question_Response__c 
            where prishan__Survey__c='a0bo0000007o0vn' 
            ];
        List<String> questionIds = new LIst<String>();
        for(prishan__Survey_Question_Response__c SQR :SQRList){
            questionIds.add(SQR.prishan__Survey_Question__c);
        } 

        return [SELECT id, prishan__Survey_Question__r.prishan__Question_Text__c, prishan__Survey_Question__r.prishan__Section__c, 
            prishan__Response__c, prishan__Survey_Question__r.prishan__Type__c , prishan__Survey_Question__r.prishan__Section_Order__c, 
            prishan__Survey_Question__r.prishan__Order__c  
            FROM prishan__Survey_Question_Response__c 
            where prishan__Survey__c='a0bo0000007o0vn' 
            order by prishan__Survey_Question__r.prishan__Section_Order__c, prishan__Survey_Question__r.prishan__Order__c]

    }*/

    private void loadQuestions(){
        
        for(Survey_Question_Response__c q : getQuestions()){
            String sec = q.prishan__Survey_Question__r.prishan__Section__c;
            if(questionMap.containsKey(sec)){
                questionMap.get(sec).add(q);
            }else{
                questionMap.put(sec,new List<Survey_Question_Response__c>{q});
                sectionNames.add(sec);
            }
        }
        
    }

    public String getQuestionsJSON(){
       return JSON.serialize(getQuestions());
    }
}