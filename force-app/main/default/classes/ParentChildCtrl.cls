public class ParentChildCtrl {
    public List<prishan__Product_Category__c> items{get;set;}
    
    public ParentChildCtrl(){
      Map<Id,Object> m= new Map<id,Object>();
      //items = [ SELECT Name, prishan__pid__r.Name from prishan__test__c];
      items = [select id,Name, prishan__Parent_Product_Category__c, prishan__Parent_Product_Category__R.Name from prishan__Product_Category__c] ; 
     }
    
    public String getJSON(){
        return JSON.serialize(items);
    }
    
   

}