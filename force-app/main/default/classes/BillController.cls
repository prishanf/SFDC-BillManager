public class BillController {

    public Bill__c bill{get;set;}
    
    public String repeat {get;set;}
    
    public Integer every {get;set;}
    
    public String Frequency {get; set;}
    
    public List<Date> DateList {get;set;}
    
    public boolean isRecurring {get;set;}
    
    public BillController(){
        bill =new Bill__c();
        isRecurring=true;
    }
    
   public BillController(ApexPages.StandardController ctrl){
        
    } 
    
    
    private Integer count = 0;
                        
    public PageReference incrementCounter() {
            count++;
            return null;
    }
                    
    public Integer getCount() {
        return count;
    }
    
    public void showRecuring(){
        System.debug('before : ' +isRecurring);
        /*if(isRecurring){
            isRecurring =false;
        }	else{
            isRecurring =true;
        }*/
         System.debug('after : ' +isRecurring);
      
    }
    
    public List<SelectOption> getFrequencyItems() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('7','Weely'));
        options.add(new SelectOption('14','Bi-Weekly'));
        options.add(new SelectOption('M','Monthly'));
        options.add(new SelectOption('Y','Yearly'));
		return options;
    }
    
    public PageReference saveRecurring(){
        System.debug('repeat ' + repeat);
        System.debug('freq ' + frequency);
        System.debug('billDate ' + bill);
        Date billDate = bill.Bill_Date__c;
        System.debug('billDate ' + billDate);
        DateList = new List<Date>();
        for(integer i=0; i<Integer.valueOf(repeat); i++){
            Date nextDate;
            if(frequency =='M'){
               nextDate = billDate.addMonths(1);
            }else{
           	   nextDate = billDate.addDays(Integer.valueOf(frequency));   
            }
             
            billDate = nextDate;
            DateList.add(nextDate);
            System.debug('Next Bill Date ' + nextDate);
        }
        return null;
    }
    
    //Action method to return the expense list called from client side JavaScript controller
    @AuraEnabled
    public static List<prishan__bill__c> getBills() {

        return [SELECT id
                    ,name
                    ,prishan__amount__c
                    ,prishan__Bill_Date__c
                    ,prishan__Paid__c
                    ,prishan__Paid_Date__c
                	,prishan__Bill_Category__r.Name
                	,prishan__Payee__r.Name
                FROM 
                    prishan__bill__c
                WHERE
                	prishan__Bill_Date__c > 2016-01-01

                ORDER BY 
                    prishan__Bill_Date__c ASC
               ];
    }
    //save method called form client side JavaScript controller
    @AuraEnabled
    public static prishan__Bill__c saveBill(prishan__Bill__c bill) {
		upsert bill;
        return bill;
    } 
}