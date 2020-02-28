public class Pagination {
    
    public integer NoOfRecords {get;set;}
    
    public boolean isToolingAPI {get;set;}
    
    public String query {get;set;}
    
    private String UserQuery {get;set;}
    
    private Integer Size =10;
    
    public Integer PageSize {get;set;}
    
    public integer currentPage {get;set;}
    
    public List<Map<String,object>> records {get;set;}
    
    public List<String> headings {get;set;}
    
    private String objname {get;set;}
    
    public Pagination(String query,boolean toolingAPI){
        isToolingAPI = toolingAPI;
        init(query, Size);
    }
    
    public List<String> filter {get;set;}
    
    public List<String> orderBy {get;set;}
    
    private void init(String q, integer pageSize){
        System.debug('pageSize ' + pageSize);
        this.query = q;
        this.UserQuery = q;
        List<String> queryParts= query.split('\\s');
        System.debug('query' + q);
        objname =queryParts.get(Util.indexOf(queryParts,'from',true)+1);
        system.debug('objname ' + objname);
       
        if(isToolingAPI){
        	Map<String,object> r =(Map<String,object>)MetaDataUtil.getInstance().toolingQuery('select count(id) recs from '+ objname).get(0);
        	NoOfRecords = Integer.valueOf(r.get('recs'));
        }
        if(query.toUpperCase().indexOf('LIMIT')<0 && pageSize != null){
           query+=' LIMIT '+ pageSize;  
           this.PageSize = pageSize;
        }else{
            this.PageSize = NoOfRecords;
        }
        currentPage = 0;
        query+=' OFFSET '+ getOffSet();
        updateRecords();
     }
    
    public void addFilter(List<String> filter){
        this.query = this.UserQuery;
        if(filter!=null && filter.size()>0){
           query +=' WHERE ' + String.join(filter,' and '); 
    	}
        if(isToolingAPI){
        	Map<String,object> r =(Map<String,object>)MetaDataUtil.getInstance().toolingQuery('select count(id) recs from '+ objname +' WHERE ' + String.join(filter,' and ') ).get(0);
        	NoOfRecords = Integer.valueOf(r.get('recs'));
            
        }
        query+=' LIMIT '+ pageSize;
        currentPage = 0;
        query+=' OFFSET '+ getOffSet();
        System.debug('query ' + query);
        updateRecords();
        
    }
    
    public void updateQuery(String query){
         init(query, Size);
    }
    
    private Integer getOffSet(){
        return currentPage * PageSize;
    }
    
    // returns the first page of records
     public void first() {
         query = UserQuery+ ' LIMIT '+ pageSize;
         currentPage = 0;
         query+=' OFFSET '+ getOffSet();
         updateRecords();
     }

     // returns the last page of recordsok
     public void last() {
         query = UserQuery+ ' LIMIT '+ pageSize;
         currentPage = (NoOfRecords/pageSize);
         query+=' OFFSET '+ getOffSet();
         updateRecords();
     }

     // returns the previous page of records
    public void previous() {
        query = UserQuery+ ' LIMIT '+ pageSize;
        if(currentPage>0){
        	currentPage--;
            query+=' OFFSET '+ getOffSet();
            updateRecords();
        }else{
            first();
        }
    }

     // returns the next page of records
    public void next() {
       query = UserQuery+ ' LIMIT '+ pageSize;
        if(currentPage<(NoOfRecords/pageSize)){
        	currentPage++;
            query+=' OFFSET '+ getOffSet();
            updateRecords();
        }else{
            last();
        }
    }
    
    public void updatePageSize(){
        init(UserQuery,PageSize);
    }
    
    private void updateRecords(){
        if(isToolingAPI){
            records = new List<Map<String,object>>();
            System.debug('records ' +records.size() );
            System.debug('final Query ' +this.query );
            for(Object obj: MetaDataUtil.getInstance().toolingQuery(this.query)) {
                Map<String,object> s =(Map<String,object>) obj;
                for(String key : s.keySet()){
                    if(s.get(key)==null){
                        s.put(key,'');
                    }
                }
                records.add(s);
            }
            System.debug('records ' +records.size()  ); 
        }
        headings = new List<String>();
        if(records.size()>0){
            Set<String> headingSet = records.get(0).keySet();
            headingSet.remove('attributes');
            headings.addAll(headingSet);
        }    
    }
    
    public boolean getHasPrevious(){
        return currentPage == 0?false: true;
    }
    
    public boolean  getHasNext(){
        return currentPage<(NoOfRecords/pageSize)? true: false;
    }
    
    public String getInfo(){
        String info = '';
           info += (((currentPage+1) * pageSize)+1-pageSize) + ' - ';
           info += ((currentPage+1) * pageSize)>NoOfRecords?NoOfRecords:((currentPage+1) * pageSize);
           info += ' of ' + NoOfRecords;
      
        return info;
    }
}