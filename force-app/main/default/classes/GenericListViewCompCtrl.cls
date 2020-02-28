public virtual class GenericListViewCompCtrl {
    
    public List<String> ColFields {get;set;}
    
    public String ObjName {get;set;}
    
    public String FFields {get;set;}
    
    public Integer pageSize {get;set;}
    
    public GenericPagination paginator {get;set;}
    
    public List<String> filter {get;set;}
    
    public GenericListViewCompCtrl(){
       
    }
     
    public List<SObject> getRecords(){
        if(paginator==null){
            List<Sobject> items = new List<Sobject>();
            String query = Util.queryBuilder(ObjName, ColFields, new List<String>());
            System.debug(LoggingLevel.Error,'query :' + query);
            if(pageSize==null){
                pageSize=10;
            }
            try{
          	 paginator = new GenericPagination(query,pageSize); 
            }catch(Exception e){
                 System.debug(LoggingLevel.ERROR, e);
            }
        }
        System.debug('getRecords ' + paginator);
        List<SObject> objs = new List<Sobject>();
        if(paginator != null && paginator.getRecords() != null){
            objs.addAll(paginator.getRecords());
        }
        
        return objs;
    }
    
    public List<Field> getFieldsList(){
        List<Field> fields = new List<Field>();
        for(String f : ColFields){
            fields.add(new Field(f,Util.getFieldDescribe(ObjName,f).isSortable()));
        }
        return fields; 
    }
   
    public class Field{
        public String name {get;set;}
        public boolean sortable {get;set;}
        public Field(String name, boolean sortable){
            this.name= name;
            this.sortable = sortable;
        }
    }
    
    public boolean getShowEdit(){
        return Util.getObjectTypeDescribe(ObjName).isUpdateable();
    }
  
}