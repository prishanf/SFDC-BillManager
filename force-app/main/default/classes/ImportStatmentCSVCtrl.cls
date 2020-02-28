public class ImportStatmentCSVCtrl {
        
    public String  nameFile {get;set;}
    public Blob fileContent {get;set;}
    String [] fileLines = new String[]{};
    public Set<String> actions {get;set;}
	public Set<String> payees {get;set;}
    public List<Home_Expenses__c> expList {get;set;}
    public Map<String,List<Home_Expenses__c>> groupByCategory {get;set;}
    public String output {get; set;}
    
    
    public List<OfxParserUtil.OfxTransaction> items {get;set;}
    
    public Map<String, List<OfxParserUtil.OfxTransaction>> groupByMemo {get;set;}
    
    public Map<String, List<OfxParserUtil.OfxTransaction>> groupByMonth {get;set;}
    
    

    public ImportStatmentCSVCtrl(){
        expList = new List<Home_Expenses__c>();
        payees = new Set<String>();
        actions = new Set<String>();
        groupByCategory = new Map<String,List<Home_Expenses__c>>();
    }
    
    public PageReference upload(){
       //String[] lines  = getCVSLines();
       //coastCapitalLineParser(lines); 
        groupByMemo = new Map<String, List<OfxParserUtil.OfxTransaction>>();
        groupByMonth = new Map<String, List<OfxParserUtil.OfxTransaction>>();
        
        OfxParserUtil p = new OfxParserUtil();
        items =  p.parse(fileContent.toString());
        for(OfxParserUtil.OfxTransaction item : items){
            String key = item.name +'-'+ item.memo;
            if(groupByMemo.containsKey(key)){
                groupByMemo.get(key).add(item);
            }else{
                groupByMemo.put(key, new List<OfxParserUtil.OfxTransaction>{item});
            }
            DateTime d = item.tdate;
            String mkey = d.format('MMM');
            if(groupByMonth.containsKey(mkey)){
               groupByMonth.get(mkey).add(item);
            }else{
               groupByMonth.put(mkey, new List<OfxParserUtil.OfxTransaction>{item});
            }
        }
       /* OfxParserUtil p = new OfxParserUtil();
        //output = p.getOFXTransatinSting(fileContent.toString());
        items= p.parseOfx(fileContent.toString());
        
        for(OfxParserUtil.OfxTransaction item : items){
            String key = item.name +'-'+ item.memo;
            system.debug(key);
            system.debug(item.amount);
            system.debug(item.name);
            system.debug(item.tdate);
            system.debug('=================');
            
            if(groupByMemo.containsKey(key)){
                groupByMemo.get(key).add(item);
            }else{
                groupByMemo.put(key, new List<OfxParserUtil.OfxTransaction>{item});
            }
            DateTime d = item.tdate;
            String mkey = d.format('MMM');
            if(groupByMonth.containsKey(mkey)){
               groupByMonth.get(mkey).add(item);
            }else{
               groupByMonth.put(mkey, new List<OfxParserUtil.OfxTransaction>{item});
            }
        }*/
       return null;
    }

	public String[] getCVSLines(){
        String[] lines = fileContent.toString().split('\n');
        system.debug('Line num i s'+lines.size());
		return lines;
    } 
    
    private void coastCapitalLineParser(String [] lines){
        for(String line :lines){
           String [] parts = line.split(',');
           String externalId = parts[0];
           Date expDate = parseDate(parts[1]);
           String Payee =  parseBillPayee(parts[2]).get('payee');
           String action =  parseBillPayee(parts[2]).get('action');
          
           Decimal amt= 0.0; 
           if(parts[3]!=''){ 
           		amt = Decimal.valueOf(parts[3]);
           }else{
               amt = Decimal.valueOf(parts[4]);
           }
           String cat = getCategory(action,Payee); 
           String ttype = getType(action);
           if(!('Skip'.equals(ttype))){
               Home_Expenses__c he= new Home_Expenses__c(); 
               he.prishan__ExternalId__c = externalId;
               he.prishan__Date__c = expDate;
               he.prishan__Bill_Payee__c = Payee;
               he.prishan__Amount__c = amt;
               he.prishan__type__c = ttype;
               he.prishan__Category__c = cat;
               expList.add(he);
               payees.add(Payee);
               actions.add(action);
               
               if(groupByCategory.containsKey(cat)){
                   groupByCategory.get(cat).add(he);
               }else{
                   List<Home_Expenses__c> expList = new List<Home_Expenses__c>();
                   expList.add(he);
                   groupByCategory.put(cat,expList);
               }
               
           } 
         }
        
    }
    
    public Static Date parseDate(String dateval){
       String [] dparts= dateval.split('-');
       Date myDate = Date.newInstance(Integer.valueOf(dparts[2]), 
                                      Integer.valueOf(dparts[0]),Integer.valueOf(dparts[1]));
	   return myDate;
    }
    
    public Static Map<String,String> parseBillPayee(String val){
       //COAS CAPITAL PAYEE PARSER
       Map<String,String> trans =new Map<String,String>();
       System.debug('val '+ val);
       System.debug('val length'+ val.length()); 
       String action = val.substring(0,29).trim();
       System.debug('action:'+ action);
       String payee =''; 
       if(val.length()>86){
       	   payee = val.substring(29,87).trim();
           if(payee==''){
               payee = action;
           }
       }else{
           payee = val.substring(29).trim();
           if(payee==''){
               payee = action;
           }
       } 
       System.debug('payee:'+ payee);   
       if(payee.indexOf('#')>0){
            payee.substring(0,payee.indexOf('#'));
       }
       trans.put('action', action);
       trans.put('payee',payee); 
	   return trans;
    }
    
    private static String getType(String action){
        if('Online Bill Payment'.equals(action) || 'Purchase'.equals(action)){
            return 'Expense';
        }else if('Payroll Deposit'.equals(action) || 'Interac e-Transfer Credit'.equals(action)){
            return  'Income';    
         }else{
             return 'Skip';
         }
    }
    private Static string getCategory(String action, String payee){
        Set<String> creditCards = new Set<String>{'HSBC Mastercard','Presidents Choice M/C','American Express Cards/LOC P'};
        if('Online Bill Payment'.equals(action) && 
           (payee.indexOf('Mastercard')>0 || payee.indexOf('M/C')>0 || payee.indexOf('American Express')>=0 )){
            return 'Credit Card';
        }else if('Online Bill Payment'.equals(action)){
            return 'Utility';
        }else if(payee.indexOf('Interac e-Transfer Credit')>=0 || payee.indexOf('3777 KINGSWAY')>=0 ){
            return 'Income';
        }else{
            return 'other Expense'; 
        }
    }
     
}