public class ShowAnyRecordCtrl {
    
    public List<SelectOption> allObjects {get;set;}
    public List<SelectOption> objectFields {get;set;}
    public List<SelectOption> selObjFiledsOptions {get;set;}
    public List<SelectOption> avilableobjectFields {get;set;}
   
    public boolean  displayResult {get;set;}
    public String seletcedOBj {get;set;}
    public List<String> selObjFiledsLabels {get;set;}
    public List<String> selObjFileds {get;set;}
    public List<sOBject> objData; 
    public GenericPagination paginator {get;set;}
    public Integer pageSize {get;set;}
    public List<Field> FieldsList {get;set;}
    
    public List<String> selectedFields {get;set;}
    public transient List<Schema.DescribeFieldResult> selDescribeObjFileds {get;set;}
    
    
    public ShowAnyRecordCtrl(){
        System.debug('ShowAnyRecordCtrl');
        allObjects  =  Util.getObjectAsSelectOptions(Util.CUSTOM_OBJ);
        allObjects.add(0, new SelectOption('','Select'));
        selObjFileds = new List<String> ();
        objData = new List<sOBject>();
        objectFields = new List<SelectOption>();
        selObjFiledsOptions =new List<SelectOption>();
        avilableobjectFields = new List<SelectOption>();
		FieldsList = new List<Field>();
        seletcedOBj = allObjects.get(1).getValue();
        showRecords();
        
       
    }
    
    public void showRecords(){
        System.debug('showRecords');
       selObjFileds.clear();
       objData.clear();
       fieldsList.clear();
       avilableobjectFields.clear();
        selObjFiledsOptions.clear();
       displayResult = true;
       selDescribeObjFileds =  Util.getUpdatableDescribeFields(seletcedOBj);
       for(Schema.DescribeFieldResult f : selDescribeObjFileds ){
            selObjFileds.add(f.getName());
           selObjFiledsOptions.add(new SelectOption(f.getName(), f.getLabel()));
       }
       objectFields = Util.getFiedlAsSelectOptions(seletcedOBj);
       try{
            String query =  Util.queryBuilder(seletcedOBj, selObjFileds,new List<String>()) ;
             paginator = new GenericPagination(query,pageSize); 
          }catch(Exception e){
             System.debug(LoggingLevel.ERROR, e);
        }
        for(String f : selObjFileds){
            fieldsList.add(new Field(f,Util.getFieldDescribe(seletcedOBj,f).isSortable()));
        }
	}
    
    public void updateCols(){
        System.debug('updateCols' + selObjFiledsOptions);
        fieldsList.clear();
        selObjFileds.clear();
        //for(String f : selObjFileds){
        //    fieldsList.add(new Field(f,Util.getFieldDescribe(seletcedOBj,f).isSortable()));
       // }
        for(SelectOption seloptin : selObjFiledsOptions){
            selObjFileds.add(seloptin.getValue());
            fieldsList.add(new Field(seloptin.getValue(),true));
        }
    }
    
    public List<sobject> getobjData(){
        System.debug('getobjData' + selObjFiledsOptions);
       
       if(paginator==null && displayResult == true && !selObjFileds.isEmpty()){
           String query =  Util.queryBuilder(seletcedOBj, selObjFileds,new List<String>()) ;
          if(pageSize==null){
               pageSize=10;
          }
          try{
             paginator = new GenericPagination(query,pageSize); 
          }catch(Exception e){
             System.debug(LoggingLevel.ERROR, e);
          }
    	}
        if(paginator != null && paginator.getRecords() != null ){
             objData.clear();
            objData.addAll(paginator.getRecords());
        }
        return objData;
    }
    
    public boolean getShowEdit(){
        return Util.getObjectTypeDescribe(seletcedOBj).isUpdateable();
    }
    
    public class Field{
        public String name {get;set;}
        public boolean sortable {get;set;}
        public Field(String name, boolean sortable){
            this.name= name;
            this.sortable = sortable;
        }
    }
}