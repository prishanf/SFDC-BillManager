/**
 * this is just a experimental class to crtea a basic function
 */ 

public class AccountExtCtr {

    public List<RecentlyViewed> recentAccounts {get;set;}
    public AccountExtCtr(){
        this.recentAccounts = [SELECT Id, Name, Type FROM RecentlyViewed WHERE Type IN ('Account')
								ORDER BY LastViewedDate DESC];
    }
    
   
}