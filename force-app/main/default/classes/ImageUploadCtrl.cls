public class ImageUploadCtrl {
    public Attachment att {get;set;}
    public String imageName {get;set;}
    public static Integer count = 0;
    public ImageUploadCtrl(){
        imageName = 'Test ' + count;   
        att= new Attachment();
        att.ParentId = 'a00o000000iN1IQ';
    }
    
    public void uploadFile(){
        system.debug('name ' + att.name);
        system.debug('body length' + att.BodyLength);
        count++;
        count++;
        insert att;
    }

}