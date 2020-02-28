public class CustomObjectHelperCtrl {

    public CustomObject newObject {get;set;}
    
    public LIst<String> errorLIst {get;set;}
    public MapWrapper errormap {get;set;}
    
    public CustomObjectHelperCtrl(){
        newObject = new CustomObject();
        errorLIst = new List<String>();
        errormap = new MapWrapper();
        errormap.put('label', 'true');
        errorLIst.add('label');
        
    }
    
    public PageReference save(){
        return null; 
    }
    
    public PageReference cancel(){
        return null;
    }
   public class CustomObject {
        public String fullname {get;set;}
        public String label {get;set;}
        public String pluralLabel {get;set;}
        public String nameFieldType {get;set;}
        public String nameFieldFormat {get;set;}
        public String nameFieldlabel {get;set;}
        public boolean deploymentStatus {get;set;}
    }
    
   
    
}