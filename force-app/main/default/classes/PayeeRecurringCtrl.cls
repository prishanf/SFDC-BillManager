public class PayeeRecurringCtrl {
    
    public Date StartDate {get;set;}
    public String Frequency {get;set;}
    public Decimal Amount {get;set;}
    public integer numberofTrans {get;set;}
    
    public List<Bill__c> toInsert {get;set;}
    
    private Payee__c payee;
    
    public PayeeRecurringCtrl(ApexPages.StandardController ctrl){
        toInsert = new List<Bill__c>();
        ctrl.addFields(new List<String>{'prishan__Category__c'});
        payee = (Payee__c) ctrl.getRecord();
    }
    
    public PageReference AddBills(){
        toInsert = new LIst<Bill__C>();
        Date duedate = payee.prishan__Due_Date__c;
        Date billdate = payee.prishan__bill_Date__c;
        for(integer i=0;i<numberofTrans;i++){
            Bill__c bill = new Bill__c();
            bill.prishan__bill_date__c = billdate;
            bill.prishan__due_date__c = duedate;
            bill.prishan__amount__c = Amount;
            bill.prishan__payee__c = payee.id;
            bill.prishan__Bill_Category__c = payee.prishan__Category__c;
            duedate = getNextDate(payee.prishan__Frequency__c,duedate);
            billdate = getNextDate(payee.prishan__Frequency__c,billdate);
            
            toInsert.add(bill);
         }
        return null;
    }
    
    public Date getNextDate(String fq,Date dt){
        if(fq.equals('Weekly')){
            return dt.addDays(7);
        }else if(fq.equals('Bi-Weekly')){
            return dt.addDays(14);
        }else if(fq.equals('Monthly')){
            return dt.Addmonths(1);
        }else if(fq.equals('Every 2 Months')){
            return dt.Addmonths(2);
        }else if(fq.equals('Every 3 Months')){
            return dt.Addmonths(3);
        }else if(fq.equals('Yearly')){
            return dt.addyears(1);
        }
        return dt;
    }
    
	public PageReference SaveAll(){
        insert toInsert;
        return new PageReference('/'+ payee.id);
    }
        
    public PageReference Cancel(){
        return new PageReference('/'+ payee.id);
    }

}