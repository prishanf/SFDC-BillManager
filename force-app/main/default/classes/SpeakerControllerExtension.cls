public class SpeakerControllerExtension {

    public integer count {get; set;}
    
    private final Speaker__c speaker;
    
    private ApexPages.StandardController stdController;
    
    public blob picture { get; set; }
    
    public String errorMessage { get; set; }
        
    public  SpeakerControllerExtension(ApexPages.StandardController stdController){
       this.speaker = (Speaker__c) stdController.getRecord();
       this.stdController =stdController;
        count = 0;
    } 
    
    public PageReference save() {
        errorMessage = '';
        try {
            upsert speaker;
            if (picture != null) {
                Attachment attachment = new Attachment();
                attachment.body = picture;
                attachment.name = 'speaker_' + speaker.id + '.jpg';
                attachment.parentid = speaker.id;
                attachment.ContentType = 'application/jpg';
                insert attachment;
                speaker.Picture_Path__c = '/servlet/servlet.FileDownload?file='
                                          + attachment.id;
                update speaker;
            }
            return new ApexPages.StandardController(speaker).view();
        } catch(System.Exception ex) {
            errorMessage = ex.getMessage();
            return null;
        }
	}
    public void increment(){
        count++;
    }
}