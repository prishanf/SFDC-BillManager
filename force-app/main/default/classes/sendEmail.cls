public class sendEmail {
    public static String subject ='TM Membership Receipt';
    public static String body ='Please find the attched PDF document of your Toastmasters Membership Receipt \n\n Prishan Fernando';
	private Membership__c member;
    public sendEmail() {
        this.member = [SELECT Name, Member__r.Name, Amount_Text__C, Member__r.Email__c, Payment_Date__C, Period_Start_Date__C, Period_End_Date__C,Amount__C, Payment_Method__c, Owner.Name
                   FROM Membership__c 
                   WHERE Id = :ApexPages.currentPage().getParameters().get('id')];
    }
    
    public sendEmail(ApexPages.StandardController stdController) {
        this();
    }
    
    public Membership__c getMember() {
        return member;
    }
   

    public PageReference send() {
        
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage(); 

        PageReference pdf =  Page.receiptPDF;
        pdf.getParameters().put('id',(String)member.id); 
        pdf.setRedirect(true);

        Blob b = pdf.getContent();
        Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
        efa.setFileName('TM Memebership Receipt.pdf');
        efa.setBody(b);
        String[] toAddresses = new String[]{member.Member__r.Email__c};
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
		member.Sent_Receipt__c =true;
        member.Receipt_Sent_Date__c =  DateTime.now();
        update member;
        return ApexPages.currentPage();
    }
}