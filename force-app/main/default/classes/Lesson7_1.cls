public class Lesson7_1
{
    public List<Account> acts1{get;set;}
    public List<Account> acts2{get;set;}
    public List<Account> acts3{get;set;}
    public List<Account> acts4{get;set;}
    
    private static final String [] ACCOUNT_TYPES = new String[]{'Customer - Channel','Customer - Direct'};
    
    public Map<String,List<Account>> accountsByType {get;set;}
    public String updateAccType {get;set;}
    
    public Lesson7_1(){
        loadData();
    }
    
    public void loadData()
    {
        accountsByType = new Map<String,List<Account>> ();
        List<Account> acc = [SELECT Name, Type, Industry FROM Account WHERE Type in : ACCOUNT_TYPES];
        for(Account a:  acc){
            String accType = a.type; 
            if(accountsByType.containsKey(accType)){
                accountsByType.get(accType).add(a);
            }else{
                accountsByType.put(accType,new List<Account>{a});
            }
       }
    }
    public void saveacts1()
    {	
        for(String key : ApexPages.currentPage().getParameters().keySet()){
            System.debug(key+' ->' + ApexPages.currentPage().getParameters().get(key));
        }
        System.debug('updateAccType ' +updateAccType);
        for(Account a : accountsByType.get(updateAccType)){
            System.debug('type ' + a.type);
        }
        update accountsByType.get(updateAccType);
        loadData();
    }

}