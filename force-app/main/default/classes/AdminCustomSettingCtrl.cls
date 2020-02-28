public class AdminCustomSettingCtrl {
    
    public List<prishan__Payee_Map__c> customSettings {get;set;}
    
    public AdminCustomSettingCtrl(){
         this.customSettings= [SELECT id, Name,Payee_Name__c from prishan__Payee_Map__c order by name];
    }
}