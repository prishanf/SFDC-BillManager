public class EventViewCtrl {
    public String [] Headings {get;set;}
    public List<String[]>  Rows {get;set;}
    
    public String  selectedlog {get;set;}
    
    public Map<String,Blob> eventLogMap = new Map<String,Blob>();
	public Map<String,integer> headingIndex = new Map<String,integer>();
    
    public String  rowData {get;set;}
    
    public List<Map<String,String>> datarows = new List<Map<String,String>>();
    
    public List<String> userIdList {get;set;} 
    
    public EventViewCtrl(){
        Rows =new List<String[]>();
        List<EventLogFile> elfList = [SELECT EventType, LogDate, LogFile FROM EventLogFile];
        for(EventLogFile elf : elfList){
             eventLogMap.put(elf.EventType +'-' +String.valueOf(elf.LogDate) , elf.LogFile);
        }
        
        /*ToolingAPILight tapi = new ToolingAPILight();
        HttpResponse resp = tapi.submitServiceRestCall('/services/data/v33.0/sobjects/EventLogFile/0ATe000000005PAGAY/LogFile','GET',null);
        String logfile = resp.getBodyAsBlob().toString();
        String [] lines = logfile.split('\n');
        String headingRow = lines[0];
        
        headings= headingRow.replace('"','').split(',');
		
        for(integer i=1;i<lines.size();i++){
            rows = lines[i].split(',');
        }
       
      */
    }
    
    public List<Map<String,String>> getDatarows(){
        return datarows;
    }
    
     public List<SelectOption> getEventItems() {
            
           List<SelectOption> options = new List<SelectOption>();
         	for(String elog : eventLogMap.keySet()){
             options.add(new SelectOption(elog,elog));
         	}
            return options;
        }
    public PageReference test() {
        rows.clear();
        String logfile = eventLogMap.get(selectedlog).toString();
       // rowData=logfile;
        String [] lines = logfile.split('\n');
        String headingRow = lines[0];
        
        headings= headingRow.replace('"','').split(',');
		initHeadingIndex(headings);
        Integer usernIdIndex = headingIndex.get('USER_ID');
        userIdList = new List<String>();
        for(integer i=1;i<lines.size();i++){
            userIdList.add(getUserId(lines[i]));
            //rows.add(lines[i].split('","'));
        }
        List<User> users = [select id,Name from User where id in :userIdList];
        rowData =String.valueOf(users.size()) + '\n';
        for(User user : users){
            rowData += String.valueOf(user.id).SubString(0,15) + '<->' +user.Name;
            logfile = logfile.replaceAll(String.valueOf(user.id).SubString(0,15), user.Name);
        }
        lines = logfile.split('\n');
        headingRow = lines[0];
        headings= headingRow.replace('"','').split(',');
        for(integer i=1;i<lines.size();i++){
            rows.add(lines[i].split('","'));
        }
        
        
        return null;
    }
    
    private void initHeadingIndex(String [] headings){
        for(integer i=0; i<headings.size();i++){
            headingIndex.put(headings[i],i);
        }
    }
    private String getUserId(String line){
        return line.substring(line.indexOf('"005')+1, line.indexOf('"005')+ 16);
    }
}