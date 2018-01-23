/**     
    
    Developer       Email                       Date
    Vijay Singh     vijay.singh@aequor.com      28/03/2013
    
 */
@isTest
private class deleteConsignmentData_Test {

    static testMethod void deleteConsignmentData() {
        
            Consignment_Search_Data__c obj = new Consignment_Search_Data__c();
            obj.User_ID__c = UserInfo.getUserId();
            obj.Search_ID__c  = 'test search id';
            insert obj;
            
            Consignment_Search_Data__c obj1 = new Consignment_Search_Data__c();
            obj1.User_ID__c = UserInfo.getUserId();
            obj1.Search_ID__c  = 'different test search id';
            insert obj1;
    }
}