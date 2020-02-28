@isTest
public class TriggerHandlerTest {

    @isTest(SeeAllData=true)
    public static void testHandle(){
        TriggerHandler handlerBI = new TriggerHandlerImp(true,true,false,false);
        TriggerHandler handlerBU = new TriggerHandlerImp(true,false,true,false);
        TriggerHandler handlerBD = new TriggerHandlerImp(true,false,false,true);
        TriggerHandler handlerAI = new TriggerHandlerImp(false,true,false,false);
        TriggerHandler handlerAU = new TriggerHandlerImp(false,false,true,false);
        TriggerHandler handlerAD = new TriggerHandlerImp(false,false,false,true);
        
        handlerBI.handle();
         handlerBU.handle();
         handlerBD.handle();
        handlerAI.handle();
         handlerAU.handle();
         handlerAD.handle();
        
    }
    
    public class TriggerHandlerImp extends TriggerHandler{
        
        public TriggerHandlerImp(Boolean isBefore,boolean isInsert,boolean isUpdate, boolean isDelete ){
            super(isBefore,isInsert,isUpdate,isDelete);
            Logger.log('TriggerHandlerImp handleBeforeInsert const');
        }
        
        public override void handleBeforeInsert(){
            Logger.error('TriggerHandlerImp handleBeforeInsert');
            Logger.info('Thisis an Info Message');
        }
    }
}