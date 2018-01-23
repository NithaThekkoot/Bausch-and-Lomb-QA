/**
 * 
 *   Test class for trigger "account_AI_addTeamAndShare"
 * 
 *    Author             |Author-Email                           |Date       |Comment
 *    -------------------|---------------------------------------|-----------|--------------------------------------------------
 *    Samantha Cardinali |samantha.cardinali@bausch.com          |23.05.2011 |First draft
 *    Samantha Cardinali |samantha.cardinali@bausch.com          |06.09.2011 |Implement for Surgical
 *
 */
@isTest
private class TrgAccount_AI_addTeamAndShare {
    static testMethod void testAccount_AI_addTeamAndShare() {
    
        ID rtBillToAcct = ClsUtility.getRecordTypeId('Account','Bill To Account');
        List<Account> list_Accounts = new List<Account>();
        Account a = new Account(Name='SCTest12345A',SETID__c='UNKGD',Ship_to_id__c='15794601',Legacy_system_id__c='UNKGD15794601',RecordtypeId=rtBillToAcct);
        list_Accounts.add(a);
        Account b = new Account(Name='SCTest12345B',SETID__c='NETPR',Ship_to_id__c='15794601',Legacy_system_id__c='NETPR15794601',RecordtypeId=rtBillToAcct);
        list_Accounts.add(b);
        insert list_Accounts;
    
    }
}