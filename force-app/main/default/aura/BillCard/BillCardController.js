({
	onPaidValueChange : function(component, event, helper) {
		console.log("BillCardController.onPaidValueChange : entered");
        
        var bill = component.get("v.bill");
        
        var updateEvent =  component.getEvent("updateBillEvent");
        
        updateEvent.setParams({
            "bill" : bill
        });
        updateEvent.fire();

        console.log("BillCardController.onPaidValueChange : exit");
	}
})