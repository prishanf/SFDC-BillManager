public class HirarchyDataImportCtrl {
    
    public String  nameFile {get;set;}
    public Blob fileContent {get;set;}
    String [] fileLines = new String[]{};
        
    private Map<String,String> allNodes = new Map<String,String>();
    private Map<String,String> finalNodes = new Map<String,String>();
    private Map<String,Id> insertMap = new Map<String,Id>();
    
    private Set<String> nodeSet =new Set<String>();
    private Map<Integer,Map<String,Set<Integer>>> LevelMap = new  Map<Integer,Map<String,Set<Integer>>>(); 
    private Integer maxLevel =0;
        
    public HirarchyDataImportCtrl(){
        
    }
    
    public PageReference upload(){
        System.debug('fileContent size ' + fileContent.size()); 
        System.debug('nameFile ' + nameFile);
        String[] lines = getCVSLines(fileContent.toString());
        processData(lines);
        integer start= 1;
        /*for(integer i= start ; i<lines.size(); i++) {
            String [] parts=lines[i].split(',');
        }*/
        return null;
    }
    
     public static String[] getCVSLines(String content){
        String[] lines = content.split('\n');
        system.debug('Line num i s'+lines.size());
		return lines;
    }
    
    public void processData(String[] lines){
        System.debug(allNodes);
        for(integer i= 1 ; i<lines.size(); i++) {
            String[] columns=lines[i].split(',');
            maxLevel = columns.size()-1;
            for(Integer level= 0 ; level<columns.size(); level++){
               String node =  columns[level].trim()+'^'+level;
               allNodes.put(node,String.valueOf(i));
                if(LevelMap.containsKey(level)){
                    Map<String,Set<Integer>> lmap = LevelMap.get(level);
                    if(lmap.containsKey(node)){
                        lmap.get(node).add(i);
                    }else{
                        lmap.put(node,new Set<Integer>{i});
                    }
                	
                }else{
                    Map<String,Set<Integer>> tempMap = new Map<String,Set<Integer>>();
                    tempMap.put(node,new Set<Integer>{i});
                    levelMap.put(level,tempMap);
                }
            }
        }
        List<prishan__Product_Category__c> toInsert = new List<prishan__Product_Category__c>();
       
        for(String nodename :allNodes.keySet()){
           toInsert.add(new prishan__Product_Category__c(Name=nodename)); 
        }
        System.debug('toInsert ' + toInsert.size());
        System.debug('toInsert ' + toInsert);// toInsert;
        insert toInsert;
        for(prishan__Product_Category__c rec :toInsert){
            insertMap.put(rec.Name,rec.id);
        }
        //udpateParents(maxLevel);
    }
    
    
    public void udpateParents(Integer maxLevel){
        List<prishan__Product_Category__c> toUpdate = new List<prishan__Product_Category__c>();
        System.debug(levelMap);
        for(Integer level= maxLevel ; level>0; level--){
            for(String key: levelMap.get(level).keyset()){
               // System.debug('key' + key);
                List<Integer> setList = new List<Integer>();
                setList.addAll(levelMap.get(level).get(key));
                Integer ParentRow = setList.get(0);
                //System.debug('ParentRow' + ParentRow);
                for(String aboveKey: levelMap.get(level-1).keyset()){
                    //System.debug('aboveKey' + aboveKey);
                    //System.debug('Above set' + levelMap.get(level-1).get(aboveKey));
                    if(levelMap.get(level-1).get(aboveKey).contains(ParentRow)){
                        Id pcId = insertMap.get(key);
                        Id ParentId = insertMap.get(aboveKey); 
                        toUpdate.add(new Product_Category__c (id =pcId, Name=key.substringBefore('^'), Parent_Product_Category__c = ParentId,Level__c=(level+1)));
                        continue;
                    }
                }
                   
                
            }
        }
       update toUpdate; 
    }
    
    public void deleteAll(){
        List<prishan__Product_Category__c> toDelete =[select id from prishan__Product_Category__c  ];
        delete toDelete;
        
    }
    
        
    public void UpdateData(){
        udpateParents(maxLevel);
    }
    
    
    public Set<String> getNodes(){
        
        return nodeSet;//new Set<String>{'Asdas','ppp'};
    }
    
    public String getJSON(){
        	return JSON.serialize(finalNodes.size());
    }
    
    


}