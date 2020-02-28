public class PuppyDetail {

    public Puppy__c puppy{get;set;}
    public List<String> fields {get;set;}
    public PuppyWrapper pp {get;set;}
    
    
   public PuppyDetail(){
        puppy = [select name from puppy__c limit 1];
        pp= new PuppyWrapper('Name');
        fields = new List<String>{'Name'};
    }	    
    
    
}