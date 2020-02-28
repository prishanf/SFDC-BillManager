public class BillDashBoardController {

    public Integer billYear {get;set;}
    
    public Integer selectedYear {get;set;}
        
    public BillDashBoardController(){
        this.billYear = System.Today().year();
        this.selectedYear =  System.Today().year();
    }
    
    public PageReference test() {
        System.debug(LoggingLevel.INFO,'test');
        this.billYear = this.selectedYear;
        System.debug(LoggingLevel.INFO,'this.selectedYear' + this.selectedYear);
            return null;
        }
    
    public List<SelectOption> getItems() {
            List<SelectOption> options = new List<SelectOption>();
        Integer currentYear =  System.Today().year();
            options.add(new SelectOption(String.valueOf(currentYear-2),String.valueOf(currentYear-2)));
            options.add(new SelectOption(String.valueOf(currentYear-1),String.valueOf(currentYear-1)));
            options.add(new SelectOption(String.valueOf(currentYear),String.valueOf(currentYear)));
            return options;
        }
            
       
    
    public List<CategorySummary> getBillsGroupedByCategory(){
       Integer currentYear = this.billYear;//System.Today().year();
       List<CategorySummary> reusltList = new List<CategorySummary>(); 
       List<AggregateResult>  groupedResults = [select  Bill_Category__R.Name, sum(amount__c) billsum from Bill__c where CALENDAR_YEAR(bill_date__c) = :currentYear  group by Bill_Category__R.Name];

	    for (AggregateResult ar : groupedResults)  {
            CategorySummary resultItem = new CategorySummary((String)ar.get('Name'),(Decimal)ar.get('billsum'));
			reusltList.add(resultItem) ;              
		} 
        return reusltList;
    }
    @RemoteAction
    public static List<CategorySummary> billsGroupedByCategory(){
       Integer currentYear =System.Today().year();
       List<CategorySummary> reusltList = new List<CategorySummary>(); 
       List<AggregateResult>  groupedResults = [select Bill_Category__R.Name, sum(amount__c) billsum from Bill__c where CALENDAR_YEAR(bill_date__c) = :currentYear  group by Bill_Category__R.Name];

	    for (AggregateResult ar : groupedResults)  {
            CategorySummary resultItem = new CategorySummary((String)ar.get('Name'),(Decimal)ar.get('billsum'));
			reusltList.add(resultItem) ;              
		} 
        return reusltList;
    }
    
    public List<PayeeSummary> getBillsGroupedByPayee(){
       Integer currentYear = this.billYear;//System.Today().year(); System.Today().year();
       List<PayeeSummary> reusltList = new List<PayeeSummary>(); 
       List<AggregateResult>  groupedResults = [select Payee__R.Name, sum(amount__c) billsum from Bill__c where CALENDAR_YEAR(bill_date__c) = :currentYear  group by Payee__R.Name];

	    for (AggregateResult ar : groupedResults)  {
            PayeeSummary resultItem = new PayeeSummary((String)ar.get('Name'),(Decimal)ar.get('billsum'));
			reusltList.add(resultItem) ;              
		} 
        return reusltList;
    }
    
     public List<MonthSummary> getBillsGroupedByMonth(){
       Integer currentYear = this.billYear;//System.Today().year(); System.Today().year();
       List<MonthSummary> reusltList = new List<MonthSummary>(); 
       List<AggregateResult>  groupedResults = [select CALENDAR_Month(bill_date__c) month, sum(amount__c) billsum from Bill__c where CALENDAR_YEAR(bill_date__c) = :currentYear  group by CALENDAR_Month(bill_date__c) order by CALENDAR_Month(bill_date__c)];

	    for (AggregateResult ar : groupedResults)  {
            MonthSummary resultItem = new MonthSummary((Integer)ar.get('month'),(Decimal)ar.get('billsum'));
			reusltList.add(resultItem) ;              
		} 
        return reusltList;
    }
    
    
    public List<Bill__c> getOutstaingBills(){
       Integer currentYear = this.billYear;//System.Today().year(); System.Today().year();
       List<MonthSummary> reusltList = new List<MonthSummary>(); 
       List<Bill__c>  outStandingBills = [select Name, Payee__R.Name, Bill_Category__R.Name, Due_Date__c, Amount__c,Bill_Month__c from Bill__c where /*CALENDAR_YEAR(Due_Date__c) = :currentYear AND */ Paid__c=false order by Due_Date__c];
	  return outStandingBills;
    }
    
    public Double getOutstaingTotal(){
       AggregateResult [] groupedResults = [select Sum (Amount__c) total from Bill__c where Paid__c=false];
	   return (Double)groupedResults[0].get('total');
    }
    
    
    public Decimal  getTotalCost(){
       Integer currentYear = this.billYear;//System.Today().year(); System.Today().year();
       AggregateResult  groupedResult = [select sum(amount__c) billsum from Bill__c where CALENDAR_YEAR(bill_date__c) = :currentYear];
	   Decimal resultItem = (decimal) groupedResult.get('billsum');
	   return resultItem;
    }
    public Integer getCurrentMonth(){
        return System.Today().Month();
    }
    
    public class CategorySummary{
        public String category {get;set;}
        public Decimal total {get;set;}
        public CategorySummary(String category,Decimal total){
            this.category = category;
            this.total = total;
        }
    }
    
    public class PayeeSummary{
        public String payee {get;set;}
        public Decimal total {get;set;}
        public PayeeSummary(String payee,Decimal total){
            this.payee = payee;
            this.total = total;
        }
    }
    
     public class MonthSummary{
        private String [] months = new String[]{'Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'}; 
        public Integer month {get;set;}
        public Decimal total;
        public MonthSummary(Integer month,Decimal total){
            this.month = month;
            this.total = total;
        }
         public String getMonthName(){
             return months[this.month-1];
         }
         public String getTotal(){
             return currency(String.valueOf(this.total));
         }
    }
    
    public static String currency(String input){
        if(input == null){return '0.00';}
        if(input.indexOf('.') == -1){input = input+'.00';}
        if(input.length() == 5){return input+'0';}
        String newValue = input.substring(input.indexOf('.'));
        newValue = String.valueOf(Decimal.valueOf(newValue).setScale(2));
        newValue = newValue.substring(newValue.indexOf('.'));
        input = input.substring(0,input.indexOf('.'));
        Integer sz = input.length();
        Integer n=0;
        for(Integer i = sz - 1;i > -1;i--){
            if(n!= 0 && math.mod(n,3) == 0)
                newValue = input.substring(i,i+1)+','+newValue;
            else
                newValue = input.substring(i,i+1)+newValue;
            n++; 
        }
        return newValue;
}
    
}