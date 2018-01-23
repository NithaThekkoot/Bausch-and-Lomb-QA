/**
* 
*   This test class covers trigger enforceSingleRecordTypeForAccountPreviousYear. 
*
*   Author           |Author-Email                        |Date       |Comment
*   -----------------|------------------------------------|-----------|--------------------------------------------------
*   Sourav Mitra     |sourav.mitra@listertechnologies.com |25.09.2010 |First Draft
*
*/
@isTest
private class enforceSingleRTForAccountPrevYear_Test
{
    private static testmethod void test1()
    {
        Account objTestAccount1 = new Account();
        objTestAccount1.name = 'Test name2';
        objTestAccount1.Status__c = 'A – Active';
        insert objTestAccount1;
        
        Id idRecType = [SELECT Id FROM RecordType WHERE SObjectType = 'Account_Previous_Year_Info__c' AND Name = 'APACSU Account Previous Year Info' LIMIT 1].Id;
        Account_Previous_Year_Info__c objAccPrevYearInfo1 = new Account_Previous_Year_Info__c();
        objAccPrevYearInfo1.RecordTypeId = idRecType;
        objAccPrevYearInfo1.Account__c = objTestAccount1.Id;
        insert objAccPrevYearInfo1;
        
        Account_Previous_Year_Info__c objAccPrevYearInfo2 = new Account_Previous_Year_Info__c();
        objAccPrevYearInfo2.RecordTypeId = idRecType;
        objAccPrevYearInfo2.Account__c = objTestAccount1.Id;
        try
        {
            insert objAccPrevYearInfo2;
        }
        catch(Exception e)
        {
            System.debug('<<<<<< Exception : ' + e.getMessage());
        }
    }
}