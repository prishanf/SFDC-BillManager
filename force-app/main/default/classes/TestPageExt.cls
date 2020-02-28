public class TestPageExt {
    public date startdate {get;set;}
    public String freq  {get;set;}
    public Integer  numtimes {get;set;}    
    public sObject inst {get;set;}
    public String out {get;set;} 
    
    public TestPageExt(ApexPages.StandardController ctrl){
        out ='Creating';
        inst = ctrl.getRecord();
    }
    
    public List<SelectOption> getFreqOptsion(){
        List<SelectOption> ops = new List<SelectOption>();
        ops.add(new SelectOption('Bi-Weekly','Bi-Weekly'));
        ops.add(new SelectOption('Monthly','Monthly'));
        ops.add(new SelectOption('Yearly','Yearly'));
        return ops;
    }
    
    public void createRecs(){
        out ='';
        Date nextdate = (Date) inst.get('Date__c');
        startdate = (Date) inst.get('Date__c');
        out =String.valueOf(nextdate);
        for(Integer i=0;i<numtimes;i++){
            if('Bi-Weekly'.equals(freq)){ 
           		nextdate = nextdate.addDays(14);
            }else if('Monthly'.equals(freq)){
                nextdate = nextdate.addMonths(1);
            }else if('Yearly'.equals(freq)){
                nextdate = nextdate.addYears(1);
            }     
           out +='<li>' +i +' - '+ nextdate +'</li>'; 
        }
    }
    
    

}