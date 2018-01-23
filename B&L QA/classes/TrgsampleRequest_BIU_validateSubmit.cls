/**
* 
*   Test class for trigger "sampleRequest_BIU_validateSubmit"
* 
*    Author         |Author-Email                   |Date       |Comment
*    ---------------|-------------------------------|-----------|--------------------------------------------------
*    S Cardinali    |samantha.cardinali@bausch.com  |03.08.2010 |First draft
*
*/
@isTest
private class TrgsampleRequest_BIU_validateSubmit {
  static testMethod void testsampleRequest_BIU_validateSubmit() {
  
        RecordType rtAccount = [SELECT Id FROM RecordType WHERE Name = 'Ship To Account' AND SObjectType='Account' Limit 1];
        Profile pUserProfile = [SELECT Id From Profile Where Name = 'EMEASU Territory Manager' Limit 1];
      RecordType rtSampleRequest = [SELECT Id FROM RecordType WHERE DeveloperName = 'EMEA_SU_Sample_Request' AND SObjectType='Sample_Request__c' Limit 1];

        //create account
        Account oTestAccount = new Account(
            Name = 'SC Test Account 1',
            RecordTypeId = rtAccount.Id,
            Legacy_system_id__c = 'UNKGD12345678'  
        );
        try {
            insert oTestAccount;
        } catch(exception e) {
            system.debug('ERROR -- could not create test account.');
        }

        //create user -- with ref to account
        User oTestUser = new User(
            FirstName = 'SCTest123',
            LastName = 'User1',
            Personal_account__c = oTestAccount.Legacy_system_id__c,
            ProfileId = pUserProfile.Id,
            Username = 'sctest123@aplace.com.dev1',
            Email = 'samantha.cardinali@bausch.com',
            Alias = 'sctst123',
            CommunityNickname = 'sctestfromaplacedev1',
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            LanguageLocaleKey = 'en_US',
            EmailEncodingKey = 'UTF-8'
        );
        try {
            insert oTestUser;
        } catch(exception e) {
            system.debug('ERROR -- could not create test user.');
        }
    
    system.runas(oTestUser) {
    
            //create sample request (should fail)
            Sample_request__c oTestFailSampleRequest = new Sample_request__c(
                RecordTypeId = rtSampleRequest.Id,
                Frequency__c = 'Weekly',
                Request_status__c = 'New',
                Courier__c = 'ParcelForce',
                Submit_for_approval__c = True
            );
            try {
                insert oTestFailSampleRequest;
            } catch(exception e) {
                system.debug('ERROR -- could not create test sample request.');
            }

            //create sample request (should create)
            Sample_request__c oTestSampleRequest = new Sample_request__c(
                RecordTypeId = rtSampleRequest.Id,
                Frequency__c = 'Weekly',
                Request_status__c = 'New',
                Courier__c = 'ParcelForce',
                Submit_for_approval__c = False
            );
            try {
                insert oTestSampleRequest;
            } catch(exception e) {
                system.debug('ERROR -- could not create test sample request.');
            }

            //update sample request
            oTestSampleRequest.Frequency__c = 'One Time';
            oTestSampleRequest.Submit_for_approval__c = True;
            try {
                update oTestSampleRequest;
            } catch(exception e) {
                system.debug('ERROR -- could not create update sample request.');
            }

            //add product
            Sample_product__c oTestSampleProduct = new Sample_product__c(
                Sample_Request__c = oTestSampleRequest.Id,
                Product_group__c = 'Viscoelastic',
                Sub_Product_Group__c = 'Ocucoat',
                SKU__c = 'CC100S - Ocucoat 2ml',
                Quantity_requested__c = 1.0
            );
            try {
                insert oTestSampleProduct;
            } catch(exception e) {
                system.debug('ERROR -- could not create test sample product.');
            }

            //update sample request
            oTestSampleRequest.Submit_for_approval__c = True;
            try {
                update oTestSampleRequest;
            } catch(exception e) {
                system.debug('ERROR -- could not update test sample request.');
            }
  
    }
  
  }
}