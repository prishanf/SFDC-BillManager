({
	getBills : function(component) {
		console.log("BillsHelper.getBills : entered");
        var action  = component.get("c.getBills");
        console.log("action: "+ action);
        var self = this;
        action.setCallback(this,function(actionResult){
            component.set("v.bills",actionResult.getReturnValue());
            console.log("actionResult ",actionResult);
            console.log("component.get : ", component.get("v.bills"));
        });
         //Enque the action
        $A.enqueueAction(action);
        
        console.log("BillsHelper.getBills : exit");
	},
    
    //update a record via Apex Controller
    saveBill : function(component, bill, callback) {
		console.log("BillsHelper.saveBill : entered");
        console.log("bill: ", bill);
        
        var action  = component.get("c.saveBill");
        
        //Load the parm with the updated record 
        action.setParams({
            "bill": bill
        });
        
        //Set the callback if any
        if (callback) {
            action.setCallback(this, callback);
        }
         //Enque the action
        $A.enqueueAction(action);
        
        console.log("BillsHelper.saveBill : exit");
	}
})