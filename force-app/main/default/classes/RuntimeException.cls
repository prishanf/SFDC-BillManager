/*
 * @Author Prishan Fernando
 * Custom Exception Class to throw exception in Apex code.
 * This Class Depends on Logger class to logs the error message at Error Level
 * 
 */ 
 
global class RuntimeException extends Exception {
 
    public RuntimeException(String errorMessage,sObject obj){
           this(errorMessage);
           obj.addError(errorMessage);
           Logger.error( obj + ' '+errorMessage);	
    }
    
    public RuntimeException(String code, String errorMessage){
           this(code +' '+errorMessage);
           Logger.error( code + ' '+errorMessage);
    }
    
    public RuntimeException(String errorMessage,sObject obj, Exception e){
           this(errorMessage);
           obj.addError(errorMessage);
           Logger.error(errorMessage + ' ' + e.getStackTraceString() +' -> '+ e.getMessage() +' -> ' +e.getTypeName());
    }
   
    public RuntimeException(Exception e, String errorMessage){
           this(e, errorMessage);
           Logger.error(errorMessage + ' ' + e.getStackTraceString() +' '+ e.getMessage());
    }
}