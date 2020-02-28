/**
 * This is Controller class for the BankTransactionsCSVPage.
 * This Controller will handle uplaod of CVS format of the transaction for Below list of Banks
 * Coast Capital
 * PC Bank 
 */ 

public class BankTransactionsCSVCtrl {


    public String  fileName {get;set;}
    public Blob fileContent {get;set;}
    String [] fileLines = new String[]{};
    public String   infoMsg  {get;set;}      
    public String selectedbank {get; set;}
        
    public List<TransactionInfo> transactionList = new List<TransactionInfo>(); 
    public List<String> payeeList = new List<String>();
    
    public BankTransactionsCSVCtrl(){
        infoMsg ='';
        
    }
    
    public List<SelectOption> getSupportedBanks() {
            List<SelectOption> options = new List<SelectOption>();
            options.add(new SelectOption('Coast Capital','Coast Capital'));
            options.add(new SelectOption('PC Bank','PC Bank'));
            return options;
        } 
    
    public PageReference upload(){
        Set<String> payeeSet = new Set<String>();
        System.debug('fileContent size ' + fileContent.size()); 
        System.debug('fileName ' + fileName);
        infoMsg = 'FileName: ' + fileName +  ', fileContent size: ' + fileContent.size();
        String[] lines = getCVSLines(fileContent.toString());
        integer start= 1;
        for(integer i= start ; i<lines.size(); i++) {
            String [] parts=lines[i].split(',');
            String payee = getPayee(parts[1]);
            System.debug('parts' + parts +' payee ' + payee);
            
         	TransactionInfo trans = new TransactionInfo(parts[0],payee,parts[2],parts[3]);
            transactionList.add(trans);
            payeeSet.add(payee);
         }
        payeeList.addAll(payeeSet);
        payeeList.sort();
        
        List<Payee_Map__c> payeeMap = new List<Payee_Map__c>();
        for(String payee : payeeList){
            if(Payee_Map__c.getValues(payee)==null){
        		payeeMap.add(new Payee_Map__c(Name=payee, Payee_Name__c = payee));
            }
        }
        
        insert payeeMap;
        return null;
    }
    
    public List<TransactionInfo> getTransactionList(){
        return transactionList;
    }
    
    public List<String> getPayeeList(){
        return payeeList;
    }
    Public static String[] getCVSLines(String content){
        String[] lines = content.split('\n');
        system.debug('Line num i s'+lines.size());
		return lines;
    }
    
    public static String getPayee(String data){
		if(data.startsWith('ATM Deposit'))
			return 'ATM Deposit';
		else if(data.startsWith('ATM Wdrl'))
			return 'ATM Wdrl';
		else if(data.startsWith('Online Transfer In')){
			return 'Online Transfer In';
		}
		else if(data.startsWith('Online Transfer Out')){
			return 'Online Transfer Out';
        }else if(data.startsWith('MORTGAGE TD')){
            return 'MORTGAGE TD';
        }
		String payee = '';
		payee = data.replaceAll('  ', '');
		Integer  endIndex = payee.indexOf('#');
		if(endIndex>0){
			return cleanPayee(payee.substring(0,endIndex-1).trim());
		}
		return cleanPayee(payee.trim());
		
	}
	
	private static String cleanPayee(String payee){
		payee= payee.replaceAll('Online Bill Payment', '');
		payee= payee.replaceAll('INTERNET BILL PAYMENT', '');
		payee= payee.replaceAll('POS MERCHANDISE', '');
		payee= payee.replaceAll('Purchase', '');
		payee= payee.replaceAll('Confirmation', '');
        payee= payee.replaceAll('PAYROLL DEPOSIT', '');
        
		
		return payee.trim();
	}
    
    public class TransactionInfo{
        public String TransactionDate {get;set;}
        public String Payee {get;set;}
        public Double CashIn {get;set;}
        public String Cashout {get;set;}
       
        
        public TransactionInfo( String transactionDate,String payee,String cashIn, String cashout){
            this.TransactionDate =  transactionDate;
            this.Payee = payee;
            cashIn=cashIn.replaceAll(' ', '');
            system.debug(LoggingLevel.INFO, cashIn +'  ' + cashIn.length());
            this.CashIn =  Double.valueOf(cashIn==''?'0':cashIn);    
            
            this.CashOut = cashOut;
        }
    }
}