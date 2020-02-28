({
	
    doInit : function(component, event, helper){
        helper.getFields(component,helper); 
    },
    
    showDetails : function(component, event, helper){
        helper.getDetails(component,event, helper);
    },
    showList : function(component, event, helper){
        helper.getExpenseList(component,helper); 
    }
})