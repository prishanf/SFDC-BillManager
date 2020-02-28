/**
 * @Author Prishan Fernando
 * 
 * This is a Logger Helper Class for SFDC Apex Code 
 */ 
global class Logger {
 
    /* Static Variables*/
    private static Logginglevel Log_level = Logginglevel.INFO;
    
    private static Logger_Settings__c  settings;
    
    private static Map<String,Logginglevel> logLevelMap = new Map<String,Logginglevel>
    {
      'DEBUG'=> Logginglevel.DEBUG,
      'INFO'=> Logginglevel.INFO,
      'WARN'=> Logginglevel.WARN,
      'ERROR'=> Logginglevel.ERROR
       
    };
    /* Init Logger Settings from Custom Settings Object*/    
    static {
      settings = Logger_Settings__c.getInstance(UserInfo.getProfileId()); // Logger_Settings__c.getOrgDefaults();
      System.debug(Logginglevel.ERROR, settings.DEBUG__c); 
      System.debug(Logginglevel.ERROR,Logger_Settings__c.getOrgDefaults().Debug__c);  
    }     
    
    public static void log(Object msg){
        System.debug(Log_level, msg);
    }
    
    public static void log(String msg, Object obj){
        System.debug(Log_level, msg +' : ' + obj);
    }
    
    public static void debug(Object msg){
        if(settings.DEBUG__c == true)
        	System.debug(Logginglevel.DEBUG, msg);
    }
    
    public static void info(Object msg){
        if(settings.INFO__c ==true)
        System.debug(Logginglevel.INFO, msg);
    }
    
    public static void error(Object msg){
        if(settings.ERROR__c ==true)
        System.debug(Logginglevel.ERROR, msg);
    }
    
    public static void warn(Object msg){
        if(settings.WARN__c ==true)
        System.debug(Logginglevel.WARN, msg);
    }
    
    public static void setLevel(String level){
        Log_level = logLevelMap.get(level.toUpperCase());
    }
    
}