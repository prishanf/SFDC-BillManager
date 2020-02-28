public class BulkReceiptCtrl {

    public Date dateSt {get;set;}
    public Date dateEd {get;set;}
    public String startDate {get;set;}
    public String endDate {get;set;}
    private final Tenent__c tenent;
    public List<ItemWrapper> rentPayments {get;set;}
    public String amountInText {get;set;}

   
    
    public BulkReceiptCtrl(ApexPages.StandardController stdController) {
        this.tenent = (Tenent__c)stdController.getRecord();
    
    }
    
    public BulkReceiptCtrl() {
        String stDate = ApexPages.currentPage().getParameters().get('stdate');
        String edDate =  ApexPages.currentPage().getParameters().get('eddate');
        String tId =  ApexPages.currentPage().getParameters().get('id');
        this.tenent = [select id, name from Tenent__c where id = :tId];
        this.dateSt = Date.valueOf(stDate);
        this.dateEd = Date.valueOf(edDate);
        InitRentReconds();

    }
    
    public void showRents(){
     startDate =  String.valueOf(dateSt);
     endDate = String.valueOf(dateEd);
     InitRentReconds();
        
   }
    
    private void InitRentReconds(){
       List<Income__c> incomeList = [Select Name, Account__r.Address__c, Date__c, amount__c, Payment_Type__c, Tenent__r.Name from Income__c 
                     where Tenent__c =: this.tenent.id and date__c >= :dateSt and date__c <= :dateEd order by date__c];
     rentPayments = new List<ItemWrapper>();
     for(Income__c income : incomeList){
            rentPayments.add(new ItemWrapper(income,StringUtils.convert(Integer.valueOf(income.Amount__c ))));
     } 
    }
    
    public PageReference downLoadPDF(){
       PageReference  bulkPDF = Page.BulkReceiptPDF;
       bulkPDF.getParameters().put('stdate',String.valueOf(dateSt)); 
       bulkPDF.getParameters().put('eddate',String.valueOf(dateEd));
       bulkPDF.getParameters().put('id',this.tenent.id);  
       return bulkPDF;
    }
    
    public class ItemWrapper {
        public Income__c income {get;set;}
        public String amountInText {get;set;}
        
        public ItemWrapper(){}
        
        public ItemWrapper (Income__c income , String amountInText){
            this.income = income;
            this.amountInText = amountInText;
        }
    }
}