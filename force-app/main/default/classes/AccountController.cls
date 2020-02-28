public class AccountController {
     @AuraEnabled
        public static List<Account> findAll(){
            return [select id, name, Location__Latitude__s, Location__Longitude__s  from Account 
                    WHERE Location__Latitude__s != NULL AND Location__Longitude__s != NULL LIMIT 50];
        }
}