public class BalanceSheetPageController {
    
    public integer taxYear{get;set;}
    
    public decimal totalExp {get;set;}
    
    public prishan__Account__c rec {get;set;}
    
    private List<String> accnts= new List<String>();
    
    public String selectedYear {get;set;}
    
    public String selectedAccount {get;set;}
    
    public List<SelectOption> years {get;set;} 
    
    public List<SelectOption> accounts {get;set;} 
    
    public Map<id,String> accountMap {get;set;} 
    
    public BalanceSheetPageController(){
        System.debug('year' + ApexPages.currentPage().getParameters().get('year'));
    	if(ApexPages.currentPage().getParameters().get('year')==''){
           taxYear = Integer.valueOf(ApexPages.currentPage().getParameters().get('year'));
           accnts.add(ApexPages.currentPage().getParameters().get('acc'));
            
       }
      
       Date currdate = Date.today();
       years = new LIst<SelectOption>{
            new SelectOption(String.valueOf(currdate.year()-2),String.valueOf(currdate.year()-2)),
            new SelectOption(String.valueOf(currdate.year()-1),String.valueOf(currdate.year()-1)),
            new SelectOption(String.valueOf(currdate.year()),String.valueOf(currdate.year()))    
            };
      accounts = new List<SelectOption>();         
      accountMap = new Map<id,String>();
      for(prishan__Account__c acc :[select id,name from prishan__Account__c where RecordType.Name='Property Account']){
           SelectOption so =  new SelectOption(acc.id,acc.name);
           accountMap.put(acc.id,acc.name) ; 
           accounts.add(so);
      }        
        
    }
    
    public decimal getIncome(){
         System.debug('year' + ApexPages.currentPage().getParameters().get('year'));
        System.debug('acc' + ApexPages.currentPage().getParameters().get('acc'));
        AggregateResult rest = [select sum(prishan__Amount__c) total  from prishan__Income__c where prishan__Account__c in :accnts and CALENDAR_YEAR(prishan__Date__c) =:taxYear ];
        return (decimal) rest.get('total');
    }
    
    public List<AggregateResult> getExpenses(){
        //Map<String,decimal> groupByType = new Map<String,decimal>();
        List<AggregateResult> groupByType = [select prishan__Expense_Type__c type, sum(prishan__Amount__c) total  from prishan__Expense__c where prishan__Expense_Account__c in :accnts and CALENDAR_YEAR(prishan__Date__c) =:taxYear group by prishan__Expense_Type__c];
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
    
    public PageReference savePdf() {

    Attachment attach = new Attachment();

    Blob body;
    body =  Page.BalanceSheetPage.getContent();
    attach.Body = body;
    attach.Name = 'Balance Sheet'+ taxYear + '.pdf'; 
    attach.IsPrivate = false;
    attach.ParentId = selectedAccount;
    attach.ContentType = 'application/pdf';
    insert attach;
    return new PageReference('/'+attach.id);    

  }
    
    public PageReference showBalanceSheet(){
        taxYear = Integer.valueOf(selectedYear);
        totalExp = 0;
        accnts.add(selectedAccount);
        PageReference pg = new PageReference('/apex/BalanceSheetPage');
        pg.getParameters().put('acc',selectedAccount);
        pg.getParameters().put('year',selectedYear);
        pg.getParameters().put('accname',accountMap.get(selectedAccount));
        pg.setRedirect(true);
        return pg;
    }

}