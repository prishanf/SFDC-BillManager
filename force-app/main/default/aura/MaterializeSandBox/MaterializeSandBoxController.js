({
	doInit : function(component, event, helper) {
		if (typeof require !== "undefined") {
            var evt = $A.get("e.forcelogic2:BlogRequireJSEvent");
            evt.fire();
        } else {
            var head = document.getElementsByTagName('head')[0];
            var script = document.createElement('script');
             
            script.src = "/resource/materialize/js/require.js"; 
            script.type = 'text/javascript';
            script.key = "/resource/RequireJS"; 
            script.helper = this;
            script.id = "script_" + component.getGlobalId();
            var hlp = helper;
            script.onload = function scriptLoaded(){
                var evt = $A.get("e.c:RequireJSEvent");
                evt.fire();
            };
            head.appendChild(script);
        }
        
	},
    initJS : function(component, event, helper){
        require.config({
            paths: {
                "jquery": "/resource/materialize/js/jquery.min.js?",
                "materialize": "/resource/materialize/js/materialize.js?",
               // "hammer": "/resource/materialize/js/hammer.min.js?",
            }
        });
        console.log("RequiresJS has been loaded? "+(require !== "undefined"));
        //loading libraries sequentially
        require(["jquery"], function($) {
            console.log("jQuery has been loaded? "+($ !== "undefined"));
            require(["materialize"], function(materialize) {
                console.log("materialize has been loaded? "+(materialize !== "undefined"));
                $("#afterLoad").html("VALUE CHANGED!!!");
                //$('.button-collapse').sideNav();
                //console.log($('.datepicker'));
            });//require end
           
          
        });//require end
    }
})