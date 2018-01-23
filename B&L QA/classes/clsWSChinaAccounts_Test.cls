/*    Author         |Author-Email                  |Date    |Comment
 *    -----------------|----------------------------------|-----------|--------------------------------------------------
 *    Neha Jain        |neha.jain@bausch.com   |23.07.2014 |First draft
 *
 */
 
@isTest
private class clsWSChinaAccounts_Test {

    static testMethod void clsWSChinaAccounts_TestMethod() {
        Test.StartTest();
            clsWSChinaAccounts clsTest = new clsWSChinaAccounts();
            clsWSChinaAccounts.getChinaSUAccountsModifiedToday();
        Test.StopTest();
     }
}