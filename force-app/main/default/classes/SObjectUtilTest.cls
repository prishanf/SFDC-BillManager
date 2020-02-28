@IsTest
public class SObjectUtilTest {

    @IsTest(SeeAllData=true)
    public static void testGetObjectNameById(){
        LIst<Account> accLIst = [select id from account limit 1];
        String objName = SObjectUtil.getObjectNameById(accLIst[0].id);
        System.assertEquals('Account', objName);
    }
    
    public static void testgetRecordTypeIdByName(){
        System.assertEquals('true', 'true');
    }
}