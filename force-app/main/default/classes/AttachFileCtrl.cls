public class AttachFileCtrl {
    
    public String  nameFile {get;set;}
    public Blob fileContent {get;set;}
    String [] fileLines = new String[]{};
    public Expense__c newRec {get;set;}  
        
 
    private ApexPages.StandardController sc;
    
    public AttachFileCtrl(ApexPages.StandardController sc) {
        this.sc = sc;
        newRec = (Expense__c) sc.getRecord();
    }
    
    public PageReference saveMe() {
        System.debug('newRec' + newRec); 
        //PageReference detailPage = sc.save();
        /*
        if (detailPage != null) {
            // Construct URL of edit page or whatever other page you want
            PageReference editPage = new PageReference(detailPage.getUrl() + '/e');
            return editPage;
        } else {
            return detailPage;
        }*/
        return null;
    }
    
    
	public void reset()
	{
		System.debug('newRec' + newRec); 
	}
    
    public PageReference saveTest()
	{
		System.debug('newRec' + newRec);
        System.debug('fileContent size ' + fileContent.size()); 
        System.debug('fileContent size ' + fileContent); 
        System.debug('nameFile ' + nameFile);
        
     	PageReference detailPage = sc.save();
        
         newRec = (Expense__c) sc.getRecord();
   
        
        
        Attachment a = new Attachment();
        a.parentId = newRec.id;
        a.Body = fileContent;
        a.Name = nameFile;
		
        try {
     	 insert a;
         System.debug('attached Sucess' + a.id); 
         String requestURL = '/apex/ImagePreviewPage?id='+newRec;

         BloB  asPDF= new PageReference(requestURL).getContentAsPDF();
   
        Attachment a1 = new Attachment();
        a1.parentId = newRec.id;
        a1.Body = asPDF;
        a1.Name = nameFile; 
        insert a1;   
        
        if (detailPage != null) {
            // Construct URL of edit page or whatever other page you want
            PageReference editPage = new PageReference(detailPage.getUrl() + '/e');
            return editPage;
        } else {
            return detailPage;
        }   
            
    	} catch (DMLException e) {
      		ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error uploading attachment'));
      		return null;
    	}
  	}
  
}