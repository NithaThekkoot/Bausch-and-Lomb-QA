/**
* 
*   This test class covers trigger enforceSingleRecordTypeForContactPreviousYear. 
*
*   Author           |Author-Email                        |Date       |Comment
*   -----------------|------------------------------------|-----------|--------------------------------------------------
*   Sourav Mitra     |sourav.mitra@listertechnologies.com |25.09.2010 |First Draft
*
*/
@isTest
private class enforceSingleRTForContactPrevYear_Test
{
    private static testmethod void test1()
    {
        Account objTestAccount1 = new Account();
        objTestAccount1.name = 'Test name2';
        objTestAccount1.Status__c = 'A – Active';
        insert objTestAccount1;
        
        Contact objTestContact1 = new Contact();
        objTestContact1.LastName = 'Test name2';
        objTestContact1.AccountId = objTestAccount1.Id;
        insert objTestContact1;
        
        Id idRecType = [SELECT Id FROM RecordType WHERE SObjectType = 'Contact_Previous_Year_Info__c' AND Name = 'APACSU Contact Previous Year Info' LIMIT 1].Id;
        Contact_Previous_Year_Info__c objConPrevYearInfo1 = new Contact_Previous_Year_Info__c();
        objConPrevYearInfo1.RecordTypeId = idRecType;
        objConPrevYearInfo1.Contact__c = objTestContact1.Id;
        insert objConPrevYearInfo1;
        
        Contact_Previous_Year_Info__c objConPrevYearInfo2 = new Contact_Previous_Year_Info__c();
        objConPrevYearInfo2.RecordTypeId = idRecType;
        objConPrevYearInfo2.Contact__c = objTestContact1.Id;
        try
        {
            insert objConPrevYearInfo2;
        }
        catch(Exception e)
        {
            System.debug('<<<<<< Exception : ' + e.getMessage());
        }
    }
}