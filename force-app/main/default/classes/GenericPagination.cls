public class GenericPagination {

    public ApexPages.StandardSetController con {get;set;}
    private Integer size =20;
    public static Integer DEFAULT_LIMIT = 1000;
    private String currentQuery;
    
    public GenericPagination(String query){
       init(query,size);
    }
    
    public GenericPagination(String query, integer pageSize){
       init(query,pageSize);
    }
     
    private void init(String query, integer pageSize){
        currentQuery = query;
        if(query.toUpperCase().indexOf('LIMIT')<0){
           query+=' LIMIT '+ DEFAULT_LIMIT;   
        }
        
        try{
        	con = new ApexPages.StandardSetController(Database.getQueryLocator(query));
        }catch(Exception e){
            addErrorMessage(e,'SQL: ' + query);
           	throw new PaginationException(e);     
        }
        setPageSize(pageSize);
    }
    
     public Boolean hasNext {
        get {return con.getHasNext();}
        set;
    }

    // indicates whether there are more records before the current page set.
    public Boolean hasPrevious {
        get {return con.getHasPrevious();}
        set;
    }

    // returns the page number of the current page set
    public Integer pageNumber {
        get {return con.getPageNumber();}
        set;
    }

    // returns the first page of records
     public void first() {
         con.first();
     }

     // returns the last page of recordsok
     public void last() {
         con.last();
     }

     // returns the previous page of records
    public void previous() {
        con.previous();
    }

     // returns the next page of records
    public void next() {
        con.next();
    }
    public Integer getSize(){
        return con.getPageSize();
    }
    
    public void setPageSize(integer pagesize){
        con.setPageSize(pagesize);
    }
    
    public List<Sobject> getRecords(){
       	return con.getRecords();
    }
    
    public Integer getNoOfRecords(){
       	return con.getResultSize();
    }
    
    public boolean getShowPaginationButtons(){
        return getNoOfRecords() > getSize();
    }
        
    
    public String getInfo(){
        String info = '';
        if(con != null){
           info += ((pageNumber * getSize())+1-getSize()) + ' - ';
            info += (pageNumber * getSize())>getNoOfRecords()?getNoOfRecords():(pageNumber * getSize());
            info += ' of ' +getNoOfRecords();
        }
        return info;
    }
    
    public void doSort(){ 
        List<String> orderBy =  new List<string>();
        Integer currentPagesize = con.getPageSize();
        orderBy.add(sortExpression + '  ' + getSortDirection());
        String sortQuery = currentQuery + ' ORDER BY ' + String.join(orderBy,','); 
        System.debug(LoggingLevel.Info,'sortQuery' + sortQuery);
        try{
        	con = new ApexPages.StandardSetController(Database.getQueryLocator(sortQuery));
        }catch(Exception e){
           addErrorMessage(e,'SQL: ' + sortQuery);
        }
        con.setPageSize(currentPagesize);
    }
  
   private String sortExp = 'name';
   private String sortDirection = 'ASC';
     
   public String sortExpression{
     get{
        return sortExp;
     }
     set{
         if (value == sortExp){
     	    sortDirection = (sortDirection == 'ASC')? 'DESC' : 'ASC';
         }else{
         	sortDirection = 'ASC';
         }
       sortExp = value;
     }
   }
    
   public String getSortDirection(){
    //if no column is selected 
    if (sortExpression == null || sortExpression == '')
    	  return 'ASC';
    else
     	return sortDirection;
 	}

	public void setSortDirection(String value){  
   		sortDirection = value;
 	}
    
    private void addErrorMessage(Exception e,String infomsg){
            System.debug(LoggingLevel.ERROR,e);
        	System.debug(LoggingLevel.ERROR,infomsg);
            String errmsg= 'There might be an issue with SOQL. Please validate the SQLThis is a Developer Error! ' + infomsg;
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.FATAL,errmsg);
            ApexPages.addMessage(msg);
    }
    
    public class PaginationException extends Exception {
    }
}