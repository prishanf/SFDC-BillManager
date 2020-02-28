trigger TestTrigger on prishan__Test__c (after insert ,before update) {
	if(Trigger.isAfter && Trigger.isInsert){
         TestTriggerHandler.onAfterInsert(Trigger.newMap);
   	}
    else if(Trigger.isBefore && Trigger.isUpdate){
       	 TestTriggerHandler.onbeforeUpdate(Trigger.newMap);
   	}
    
}