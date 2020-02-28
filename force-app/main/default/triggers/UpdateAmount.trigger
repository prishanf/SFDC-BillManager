trigger UpdateAmount on prishan__Membership__c (before insert,before update) {

    for(Membership__c m : trigger.new){
        m.Amount_Text__c = StringUtils.convert(Integer.valueOf(m.amount__c));
    }
}