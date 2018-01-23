//Test Class for Trigger Submit_Cameleon_Quote_Approval
@isTest
private class Test_Submit_Cameleon_QuoteApproval {
  static testMethod void testSubmit_Cameleon_QuoteApproval() {
  /*
      ID rtBillToAccount = ClsUtility.getRecordTypeId('Account','Bill To Account');
      ID rtEMEATender = ClsUtility.getRecordTypeId('Opportunity','EMEASU Tender');
      ID rtEMEAClosedWonTender = ClsUtility.getRecordTypeId('Opportunity','EMEASU Closed-Won Tender');
      UserRole urUKSUBUM = [SELECT Id FROM UserRole WHERE Name = 'UK SU BUM' LIMIT 1];
      Profile pContractMgr = [SELECT Id FROM Profile WHERE Name = 'EMEASU Contracts Manager' LIMIT 1];
      
//      User uDINTE = [SELECT Id From User Where Name = 'Data Integration' Limit 1];
      

      //Create User
      User oUser1 = new User(FirstName = 'SCTest11', 
                    LastName = 'ContractUser1234561',
                    UserRoleId = urUKSUBUM.Id,
                    ProfileId = pContractMgr.Id,
                    alias = 'sctcu9', 
                    username='SCTest1@ContractUser123451.com',
                    email='SCTest1@ContractUser123451.com',
                    Country='GBR', 
                    emailencodingkey='UTF-8', 
                    languagelocalekey='en_US', 
                    localesidkey='en_US', 
                    timezonesidkey='America/Los_Angeles'
                    );
      insert oUser1;
      
            //Create User
      User oUser = new User(FirstName = 'SCTest1', 
                    LastName = 'ContractUser123456',
                    UserRoleId = urUKSUBUM.Id,
                    ProfileId = pContractMgr.Id,
                    alias = 'sctcu9', 
                    username='SCTest1@ContractUser12345.com',
                    email='SCTest1@ContractUser12345.com',
                    Country='GBR',
                    Managerid=oUser1.id,
                    DelegatedApproverid=oUser1.id,
                    emailencodingkey='UTF-8', 
                    languagelocalekey='en_US', 
                    localesidkey='en_US', 
                    timezonesidkey='America/Los_Angeles'
                    );
      insert oUser;
      
      
      System.RunAs(oUser) {
          
          //Create Account
          Account oAccount = new Account(RecordTypeId = rtBillToAccount,
                              Name = 'SCTestBillTo12345',
                              SETID__c = 'UNKGD',
                              Bill_to__c = '98765432',
                              Legacy_System_id__c = 'UNKGD98765432-BT',
                              OwnerId = oUser.Id
                              );
          insert oAccount;
          
          //Create Territory
          Territories__c oTerr = new Territories__c(Name = 'UKTERTest01', SETID__c = 'UNKGD');
          insert oTerr;
    
          //Create EMEA Tenders Opportunity
          Opportunity oTender = new Opportunity(RecordTypeId = rtEMEATender,
                                  Name = 'SC Test Tender 135',
                                  AccountId = oAccount.Id,
                                  Existing_B_L_Account__c = True,
                                  Competitor_Account__c = True,
                                  StageName = 'Negotiation/Review',
                                  CloseDate = System.Today(),
                                  Description = 'SCTestDesc',
                                  Annual_Volume__c = 100,
                                  EOI_Response_Date__c = System.Today(),
                                  Eval_Date__c = System.Today(),
                                  ITT_Reference__c = 'ABC123',
                                  ITT_Release_Date__c = System.Today(),
                                  ITT_Submission_Date__c = System.Today(),
                                  OJEU_Reference__c = '123ABC',
                                  OJEU_Alert_Date__c = System.Today(),
                                  Opportunity_Scope__c = 'BSS',
                                  No_of_Hand_Pieces__c = 6,
                                  Opportunity_Type__c = 'Procurement Agency',
                                  PQQ_Release_Date__c = System.Today(),
                                  PQQ_Response_Date__c = System.Today(),
                                  Procurement_Agency__c = True,
                                  Procurement_Agency_Name__c = 'SCTestAgency1',
                                  RFQ_Reference__c = '567ABC',
                                  RFQ_Date__c = System.Today(),
                                  RFQ_Submission_Date__c = System.Today(),
                                  Status_Summary__c = 'TestSummary',
                                  Territory__c = oTerr.Id,
                                  Type_of_Financing__c = 'Op Lease – Machine Rev',
                                  Volume_Type__c = 'Commitment',
                                  Stellaris_Qty__c = 2,
                                  Stellaris_PC_Qty__c = 4,
                                  Amount = 500.00,
                                  Stellaris_Unit_Price__c = 6000.00,
                                  Stellaris_PC_Unit_Price__c = 5000.00,
                                  Stellaris_Monthly_Procedure_Qty__c = 100,
                                  Stellaris_Procedure_Unit_Price__c = 35.00,
                                  Stellaris_PC_Monthly_Procedure_Qty__c = 50,
                                  Stellaris_PC_Procedure_Unit_Price__c = 45.00
                                  );
          insert oTender;
          
          CameleonCPQ__Quote__c  CameleonCPQ = new CameleonCPQ__Quote__c(name='Test',CameleonCPQ__AccountId__c=oAccount.Id,OpportunityId__c=oTender.id,Contract_Term__c='12'); 
          insert CameleonCPQ; 
          CameleonCPQ.Approval_Level__c=1;
          update CameleonCPQ;
      }
      */
  }
}