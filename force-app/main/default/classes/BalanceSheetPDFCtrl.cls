public class BalanceSheetPDFCtrl {

    public integer taxYear{get;set;}
    
    public decimal totalExp {get;set;}
    
    public prishan__Account__c rec {get;set;}
    
    private List<String> accnts= new List<String>();
    
    public String accName {get;set;}
    
    public String selectedYear {get;set;}
    
    public BalanceSheetPDFCtrl(){
      
      totalExp = 0.0;  
      taxYear = Integer.valueOf(ApexPages.currentPage().getParameters().get('year'));
      accnts.add(ApexPages.currentPage().getParameters().get('acc')); 
      accName = ApexPages.currentPage().getParameters().get('accname');
	  Apexpages.currentPage().getHeaders().put( 'content-disposition', 'inline; filename=' +accName +'-Balace Sheet-'+ taxYear );	        
    }
     
     public decimal getIncome(){
         System.debug('year' + ApexPages.currentPage().getParameters().get('year'));
        System.debug('acc' + ApexPages.currentPage().getParameters().get('acc'));
         
        AggregateResult rest = [select sum(prishan__Amount__c) total  from prishan__Income__c where prishan__Account__c in :accnts and CALENDAR_YEAR(prishan__Date__c) =:taxYear ];
        System.debug('rest' + rest);
         return (decimal) rest.get('total');
    }
    
    public List<AggregateResult> getExpenses(){
        //Map<String,decimal> groupByType = new Map<String,decimal>();
        List<AggregateResult> groupByType = [select prishan__Expense_Type__c type, sum(prishan__Amount__c) total  from prishan__Expense__c where prishan__Expense_Account__c in :accnts and CALENDAR_YEAR(prishan__Date__c) =:taxYear group by prishan__Expense_Type__c];
        System.debug('groupByType' + groupByType);
        for(AggregateResult res  :groupByType){
            totalExp += (decimal) res.get('total');
        }

        return groupByType;
    }
    
     public Map<String,List<prishan__Expense__c>> getExpenseLines(){
       	Map<String,List<prishan__Expense__c>> groupByType = new Map<String,List<prishan__Expense__c>>();
        List<prishan__Expense__c> recList = [select id, prishan__Payee__c, prishan__Expense_Type__c, prishan__Comments__c, prishan__Amount__c, prishan__Date__c from prishan__Expense__c where prishan__Expense_Account__c in :accnts and CALENDAR_YEAR(prishan__Date__c) =:taxYear order by prishan__Date__c];
        for(prishan__Expense__c rec  :recList){
            String etype = rec.prishan__Expense_Type__c;
            if(groupByType.containsKey(etype)){
                groupByType.get(etype).add(rec);
            }else{
                List<prishan__Expense__c> recs =  new List<prishan__Expense__c>();
                recs.add(rec);
                groupByType.put(etype,recs);
            }
        }
       
        return groupByType;
    }
    
}