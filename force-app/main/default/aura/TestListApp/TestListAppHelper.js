({
	 showList : function(component,data) {
        $A.createComponent(
            "c:TestList",
            {
               "ExpenseList" : data
            },
            function(newComponent){
                console.log('showDetails com created');
                component.set("v.body",newComponent);
            }
        )    
    },
    
    
    showFieldList : function(component,data) {
        var toJason = JSON.parse(data);
        $A.createComponent(
            "c:TestList",
            {
               "FieldListJSON" : toJason
            },
            function(newComponent){
                console.log('showDetails com created' , toJason);
                component.set("v.body",newComponent);
            }
        )    
    },
    
    showDetails : function(component,data){
        $A.createComponent(
            "c:TestDetails",
            {
                "Expense" : data,
                "Title" : 'component.get("{!v.Title}")'
            },
            function(newComponent){
                console.log('showDetails com created');
                component.set("v.body",newComponent);
            }
        )
    },
    
    getExpenseList : function(component,helper) {
        var action  = component.get("c.getExpenses");
        var self = this;
        action.setCallback(self,function(actionResult){
            component.set("v.ExpenseList", actionResult.getReturnValue());
    		helper.showList(component, actionResult.getReturnValue());
           
        })
        $A.enqueueAction(action);
	},
    
    getFields : function(component,helper) {
        var action  = component.get("c.getObjectFields");
        action.setParams({"objectName" : 'prishan__Expense__c'});
        var self = this;
        action.setCallback(self,function(actionResult){
            component.set("v.FieldListJSON", actionResult.getReturnValue());
            console.log('resp'+ actionResult)
    		helper.showFieldList(component, actionResult.getReturnValue());
           
        })
        $A.enqueueAction(action);
	},
    
    getDetails : function(component, event, helper){
        var action = component.get("c.getDetails");
        action.setParams({"rid" : event.getParam("recId")});
        
        console.log('recId'+event.getParam("recId"));
        
        action.setCallback(this,function(response){
                if (response.getState() === "SUCCESS"){
                    helper.showDetails(component, response.getReturnValue());
                }
            }
        );
        $A.enqueueAction(action);
    },
})