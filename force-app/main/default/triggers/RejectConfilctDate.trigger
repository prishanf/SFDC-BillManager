trigger RejectConfilctDate on Session__c (before update) {

   for(Session__c session : trigger.new) {
       Map<id,Session__c> oldMap = trigger.oldMap;
	   Session__c oldValue = oldMap.get(session.id);
       if(session.Session_Date__c != oldValue.Session_Date__c){
            // Retrieve SessionSpeaker information including session date and time
            Session_Speaker__c sessionSpeaker = [SELECT speaker__c from Session_Speaker__c where Session__c = :session.id];
            // Retrieve conflicts: other assignments for that speaker at the same time
            
            List<Session_Speaker__c> conflicts = [SELECT id FROM Session_Speaker__c 
                                   WHERE Speaker__c = :sessionSpeaker.Speaker__c 
                                   AND Session__r.Session_Date__c = :session.Session_Date__c];
            // If conflicts exist, add an error (reject the database operation)
            if(!conflicts.isEmpty()){
                session.addError('The speaker is already booked at that time');
            }
       }

    }
}