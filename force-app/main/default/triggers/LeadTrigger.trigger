trigger LeadTrigger on Lead (before update) {

    List<id> toConvertIds = new List<id>();
    for(Lead l : Trigger.New){
        if(l.prishan__Exigo_Status_Id__c  == '1'){
            l.Status = 'Closed - Converted';
            l.IsConverted = true;
            /*Database.LeadConvert lc = new Database.LeadConvert();
    		lc.setLeadId(l.id);
            lc.setConvertedStatus();
            Database.convertLead(lc);*/
        }
    }
}