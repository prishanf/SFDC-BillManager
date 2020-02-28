public class AddAttachmentCtrl {
    public BLOB fileContent {get;set;}
    public String nameFile {get;set;}
    public Expense__c expense {get; set;}
    //public static String rootFolder = '0B7eA6VMmrKVTdGlBZ2tudERaWk0';
    public AddAttachmentCtrl(){
        
        String recId =  ApexPages.currentPage().getParameters().get('id');
        expense =[select id, name, prishan__Expense_Account__c, prishan__Expense_Account__r.Name, prishan__Expense_Account__r.prishan__Google_Folder_Id__c from Expense__c where id=:recId];
    }
    
    public PageReference saveTest(){
        PageReference pr = new PageReference('/'+expense.id);
        if(expense.prishan__Expense_Account__r.prishan__Google_Folder_Id__c == null){
            GoogleDriveAPI googeDrive = new GoogleDriveAPI();
            String rootFolder = prishan__KeyValueTable__c.getValues('RootFolderIdForGoogleDrive').prishan__value__c;
            String folderId = googeDrive.createFolder(expense.prishan__Expense_Account__r.Name, rootFolder);
            prishan__Account__c acc = new prishan__Account__c(id=expense.prishan__Expense_Account__c);
            acc.prishan__Google_Folder_Id__c = folderId;
            update acc;
            handleUpload(expense.id, expense.name, 'pdf', acc.prishan__Google_Folder_Id__c,fileContent);
        }else{
            handleUpload(expense.id, expense.name, 'pdf', expense.prishan__Expense_Account__r.prishan__Google_Folder_Id__c,fileContent);
        }
        return pr;
    }
    
    @Future(callout=true)
    public static void handleUpload(id recId, String fileName,String fileType,String folderId, BLOB fileBody){
        GoogleDriveAPI googeDrive = new GoogleDriveAPI();
        Map<String,Object> resp = googeDrive.uploadFile(fileName, fileType, folderId, fileBody);
        GoogleDoc gdoc = new GoogleDoc(name=fileName);
        gdoc.ParentId = recId;
        gdoc.Url = 'https://drive.google.com/open?id='+resp.get('id');  
        insert gdoc;
    }
    
    public PageReference cancel(){
        return null;
    }

}