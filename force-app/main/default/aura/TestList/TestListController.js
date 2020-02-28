({
	
    showDetails: function(component, event, helper) {
        //Get data via "data-data" attribute from button (button itself or icon's parentNode)
        //var id = event.target.getAttribute("data-data") || event.target.parentNode.getAttribute("data-data")
        var action = $A.get("e.c:NavigateToDetails");
        var param = event.getSource().get("{!v.buttonTitle}");
        console.log('param',param);
        action.setParams({"recId" :param} );
        console.log(action);
       
        
        action.fire();
   },
    formValidate :function () {
         $("#formValidate").validate({
        rules: {
            name: {
                required: true,
                minlength: 5
            }
            			
        },
        //For custom messages
        messages: {
            name:{
                required: "Enter a username",
                minlength: "Enter at least 5 characters"
            },
            curl: "Enter your website",
        },
        errorElement : 'div',
        errorPlacement: function(error, element) {
          var placement = $(element).data('error');
          if (placement) {
            $(placement).append(error)
          } else {
            error.insertAfter(element);
          }
        }
     });
    }
}
})