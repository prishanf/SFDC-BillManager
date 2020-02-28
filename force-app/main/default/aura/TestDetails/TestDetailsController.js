({
    doInit : function(component, event, helper){
        console.log('doInit');
        component.set("{!v.Title}","Prishan");
        console.log(component);
        //setTimeout(goBack,4000);
        //setInterval(myFunction, 2000);
        
        $A.createComponent(
            "ui:button",
            {
                "aura:id": "findableAuraId",
                "label": "Press Me"
                
            },
            function(newButton){
                //Add the new button to the body array
                component.set("v.body",newButton);
            }
        )
       
        function myFunction(){
            component.set("{!v.Title}","Prishan" + new Date());
        }
        function goBack(){
            var action = $A.get("e.c:NavigateToList");
           console.log(action);
           action.fire();
        }
    },
    
    gotToList : function(component, event, helper) {
	   var action = $A.get("e.c:NavigateToList");
       console.log(action);
       action.fire();
	}
})