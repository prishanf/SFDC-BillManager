public class OfxParserUtil {
    
    public List<OfxTransaction> parse(String file) {
        return parseFile(file);
    }
    
    public String getOFXTransatinSting(String content){
        Integer transStartIndex = content.indexOf('<BANKTRANLIST>');
        Integer transEndIndex = content.indexOf('</BANKTRANLIST>');
        String statment = content.substring(transStartIndex,transEndIndex+15);
        return statment;
    }
    
    public List<OfxTransaction> parseOfx(String content){
        String cleanData = getOFXTransatinSting(content);
        XmlStreamReader reader = new XmlStreamReader(cleanData);
        boolean isSafeToGetNextXmlElement = true;
        List<OfxTransaction> transactions= new List<OfxTransaction>();
        Dom.Document doc = new Dom.Document();
        doc.load(cleanData);
        Dom.XmlNode root = doc.getRootElement();
        Dom.XmlNode[] children = root.getChildren();
        for(Dom.XmlNode child : children){
           Dom.XmlNode[] chel= child.getChildElements();
            for(Dom.XmlNode ele : chel){
                system.debug(ele.getName());
            }
        }
            
       /* while(isSafeToGetNextXmlElement) {
            if (reader.getEventType() == XmlTag.START_ELEMENT) {
                System.debug(reader.getEventType());
         
                if ('STMTTRN' == reader.getLocalName() ) {
           // Pass the transation to the parseTransaction method (below) 
                    OfxTransaction trans = parseTransaction(reader);
                    transactions.add(trans);
                }
            }
            // Always use hasNext() before calling next() to confirm 
            // that we have not reached the end of the stream
            if (reader.hasNext()) {
                reader.next();
            } else {
                isSafeToGetNextXmlElement = false;
                break;
            }
        }*/
       return transactions;
	}
    private OfxTransaction parseTransaction(XmlStreamReader reader){
        OfxTransaction trans = new OfxTransaction();
        boolean isSafeToGetNextXmlElement = true;
        while(isSafeToGetNextXmlElement) {
             system.debug('EventType :' + reader.getEventType());
             system.debug('LocalName :' +reader.getLocalName());
           
            if (reader.getEventType() == XmlTag.END_ELEMENT) {
                break;
            } else if (reader.getEventType() == XmlTag.CHARACTERS) {
                system.debug('CHARACTERS > LocalName :' +reader.getText());
                if ('TRNTYPE' == reader.getLocalName()) {
                    if(reader.getText() =='DEBIT')
                    	trans.transType =  TransctionType.DEBIT;
                    else  
                        trans.transType =  TransctionType.CREDIT;
                }
                if ('DTPOSTED' == reader.getLocalName()) {
                    system.debug('DTPOSTED :' + reader.getText());
                    trans.tdate =  getDate(reader.getText());
                }
                if ('TRNAMT' == reader.getLocalName()) {
                }
                if ('MEMO' == reader.getLocalName()) {
                    trans.memo = reader.getText();
                }
            }
            // Always use hasNext() before calling next() to confirm 
            // that we have not reached the end of the stream
            if (reader.hasNext()) {
                reader.next();
            } else {
                isSafeToGetNextXmlElement = false;
                break;
            }
        }
        return trans;
    }
    private List<OfxTransaction> parseFile(String content){
   
       List<String> lines = readAll(content);
	   List<OfxTransaction> trans = new List<OfxTransaction>();
	   Boolean inTransaction =false;
	   for(String line : lines){
		   
		   if(line.contains('<STMTTRN>')){
			   trans.add(new OfxTransaction());
			   inTransaction=true;
		   }
		   if(line.contains('</STMTTRN>')){
			   inTransaction=false;
		   }
		   if(inTransaction){
			   OfxTransaction t = trans.get(trans.size()-1);
			   updateTransaction(line, t);
		   }
	   }
       System.debug(lines.size());
       System.debug(trans.size());
        return trans;
    }
    
    private void updateTransaction(String line, OfxTransaction t) {
		
		if(line.contains('<TRNAMT>')){
               String newString =  line.replace('</TRNAMT>','');	
			   String text = newString.split('<TRNAMT>')[1];
			   if (text.startsWith('-')) {
				   t.transType = TransctionType.DEBIT ;
				   t.Amount = Decimal.valueOf(text.substring(1));
			   }else{
				   t.transType = TransctionType.CREDIT;
				   t.Amount = Decimal.valueOf(text);
			   }
			   
		}else if(line.contains('<NAME>')){
           String newString =  line.replace('</NAME>','');	
		   String text =newString.split('<NAME>')[1];
		 	   t.Name = text;
		   
	   }else if(line.contains('MEMO')){
           String newString =  line.replace('</MEMO>','');	
		   String text =newString.split('<MEMO>')[1];
           if(text.contains('Confirmation')){
               t.Memo = text.split('Confirmation')[0];
           }else{
               t.Memo = text;
           }
		   
		   
	   } else if (line.contains('DTPOSTED')) {
		   String newString =  line.replace('</DTPOSTED>','');	
           String text =newString.split('<DTPOSTED>')[1];
	        t.tDate = getDate(text);
	   }
	}
    
    private Date getDate(String dateText){
        Integer year = Integer.valueOf(dateText.substring(0,4));
        Integer month = Integer.valueOf(dateText.substring(4,6));
        Integer day = Integer.valueOf(dateText.substring(6,8));
        return Date.newInstance(year, month, day);
    }
    
    private List<String> readAll(String content){
        	List<String> initalSplit= content.split('\n');
        	List<String> lines= new List<String>();
        	
            for(String line :initalSplit){
            	if(line.endsWith('</STMTTRN>')){
            		lines.add(line.substring(0,line.indexOf('</STMTTRN>')));
            		lines.add(line.substring(line.indexOf('</STMTTRN>'),line.length()));
            	}else{
            		lines.add(line);
            	}
            	
            }
            return lines;
    }
    
    
    public enum TransctionType {
        	CREDIT,
        	DEBIT
   }
    
    public class OfxTransaction{
        
        public TransctionType transType {get;set;}
        public Decimal amount {get;set;}
        public String name {get;set;}
        public String memo {get;set;}
        public Date tdate {get;set;}
        public String fitid {get;set;}
    }

}