({
	doInit : function(component, event, helper) {
        console.log("BillsController.doInit : entered");
        helper.getBills(component);
        console.log("BillsController.doInit : exit");
        
	},
    onUpdateBillEvent : function(component, event, helper){
        console.log("BillsController.onUpdateBillEvent : entered");
        console.log(event.getParam("bill"));
        helper.saveBill(component,event.getParam("bill"));
        console.log("BillsController.onUpdateBillEvent : exit");
    }
})