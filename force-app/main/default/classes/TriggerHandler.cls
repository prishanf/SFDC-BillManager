virtual global class TriggerHandler {

  private  boolean isBefore;
  private  boolean isInsert;
  private  boolean isUpdate;
  private  boolean isDelete;
 
  
  public  TriggerHandler(Boolean isBefore,boolean isInsert,boolean isUpdate, boolean isDelete ){
      this.isBefore = isBefore;
      this.isInsert = isInsert;
      this.isUpdate = isUpdate;
      this.isDelete = isDelete;
  }
    
  public void handle(){
      if(this.isBefore){
         if(this.isInsert) {
     	 	handleBeforeInsert();
         }else if(this.isUpdate) {
          	handleBeforeUpdate();
         }else if(this.isDelete){
            handleBeforeDelete(); 
         } 
      }else{
         if(this.isInsert) {
          	handleAfterUpdate();
         }else if(this.isUpdate) {
             handleAfterInsert(); 
         }else if(this.isDelete){
             handleAfterDelete(); 
         } 
      }	
        
    }
    virtual protected void handleBeforeInsert(){}
    virtual protected void handleBeforeUpdate(){}
    virtual protected void handleBeforeDelete(){} 
    virtual protected void handleAfterUpdate(){} 
    virtual protected void handleAfterInsert(){}
    virtual protected void handleAfterDelete(){} 
}