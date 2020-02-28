global class FullCalendarCtrl {
    
    Static String dtFormat = 'yyyy-MM-dd HH:mm:ss+0000';
    /*
    public List<CalEvent> events {get;set;}
    
    

    public FullCalendarCtrl(){
        Integer THIS_YEAR = 2016;
        LIst<prishan__Bill__c> bills = [Select id, prishan__Payee__r.Name, prishan__Due_Date__c, prishan__Amount__c from prishan__Bill__c where CALENDAR_YEAR(prishan__Due_Date__c) =:THIS_YEAR];
         events = new list<calEvent>();
        //Get Contact's Birthdays
        for(prishan__Bill__c bill : bills){
            //here we need to replace the birth year with the current year so that it will show up on this years calendar
          	DateTime startDT = bill.prishan__Due_Date__c;
            DateTime endDT = bill.prishan__Due_Date__c;
            
            calEvent campEvent = new calEvent();
            campEvent.title = bill.prishan__Payee__r.Name;
            campEvent.amount = bill.prishan__Amount__c;
            campEvent.allDay = false;
            campEvent.startString = startDT.format(dtFormat);
            campEvent.endString = endDT.format(dtFormat);
            campEvent.url = '/' + bill.Id;
            campEvent.className = 'event-campaign';
            events.add(campEvent);
        }
    }
*/    
    @RemoteAction
    public static List<CalEvent> getEvents(String stDate,String edDate) {
        Date startDate = Date.parse(stDate);
        Date endDate =  Date.parse(edDate);
        System.debug('stDate ' + stDate);
         System.debug('edDate ' + edDate);
        List<CalEvent> events = new List<CalEvent>();
        LIst<prishan__Bill__c> bills = [Select id, prishan__Payee__r.Name, prishan__Due_Date__c, prishan__Amount__c from prishan__Bill__c where prishan__Due_Date__c >=:startDate AND prishan__Due_Date__c <= :endDate];
         System.debug('bills ' + bills); 
        events = new list<calEvent>();
        //Get Contact's Birthdays
        for(prishan__Bill__c bill : bills){
            //here we need to replace the birth year with the current year so that it will show up on this years calendar
          	DateTime startDT = bill.prishan__Due_Date__c;
            DateTime endDT = bill.prishan__Due_Date__c;
            
            calEvent campEvent = new calEvent();
            campEvent.title = bill.prishan__Payee__r.Name + ' - '+ bill.prishan__Amount__c;
            campEvent.amount = bill.prishan__Amount__c;
            campEvent.allDay = false;
            campEvent.startString = startDT.format(dtFormat);
            campEvent.endString = endDT.format(dtFormat);
            campEvent.url = '/' + bill.Id;
            campEvent.className = 'event-campaign';
            events.add(campEvent);
        }
        return events;
    }

    
    //Class to hold calendar event data
    global class CalEvent{
        public String title {get;set;}
        public Boolean allDay {get;set;}
        public String startString {get;set;}
        public String endString {get;set;}
        public String url {get;set;}
        public Decimal amount {get;set;}
        public String className {get;set;}
    }    
}