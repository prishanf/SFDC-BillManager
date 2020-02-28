public class RentReceiptCtrl {

    public static String subject ='Rent Receipt';
    public static String body ='Please find the attched PDF document of your rent receipt';
	private final Income__c income;
    public String amountInText {get;set;}

   
    
    public RentReceiptCtrl(ApexPages.StandardController stdController) {
        this.income = (Income__c)stdController.getRecord();
        if(this.income.Amount__c != null){
            this.amountInText = StringUtils.convert(Integer.valueOf(this.income.Amount__c )); 
        }else{
            this.amountInText ='Zero';
        }
        

    }
    
    
    public PageReference send() {
        
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage(); 

        PageReference pdf = null;//Replace Page.RentReceiptPDF;
        pdf.getParameters().put('id',(String)this.income.id); 
        pdf.setRedirect(true);

        Blob b = pdf.getContent();
        Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
        efa.setFileName('TM Memebership Receipt.pdf');
        efa.setBody(b);
        String[] toAddresses = new String[]{'prishanf@yahoo.com'};
        String[] bccAddresses = new String[]{'prishanf@gmail.com'};            

        // Sets the paramaters of the email
        email.setSubject( subject);
        email.setToAddresses( toAddresses );
        email.setBccAddresses(bccAddresses); 
        email.setPlainTextBody(body);
      
 		email.setSaveAsActivity(true);
        email.setFileAttachments(new Messaging.EmailFileAttachment[] {efa});

        // Sends the email
        Messaging.SendEmailResult [] r = 
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});   
		//member.Sent_Receipt__c =true;
        //member.Receipt_Sent_Date__c =  DateTime.now();
        //update member;
        return ApexPages.currentPage();
    }
    
    
}