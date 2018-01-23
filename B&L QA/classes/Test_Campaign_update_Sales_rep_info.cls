/**
 * First Draft : Kuldeep
 * Test Class for trigger Campaign_update_Sales_rep_info
 *
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class Test_Campaign_update_Sales_rep_info {
     private static final string RECORD_TYPE_NAME_USSUR = 'USSUR Dr Dinners';
    
    static testMethod void Campaign_update_Sales_rep_info_UnitTest() {
        // TO DO: implement unit test
        
        RecordType rt = [select id from recordtype where name =: RECORD_TYPE_NAME_USSUR and sobjecttype ='Campaign'];
        Profile p = [select id from profile where name='Standard User'];
        
        Account objTestAccount1 = new Account();
            objTestAccount1.name = 'Test name';
            objTestAccount1.Status__c = 'Test';
            
            insert objTestAccount1;
         
         User u = new User(
         alias = 'standt', 
         email='standarduser22@testorg.com', 
         emailencodingkey='UTF-8',  
         lastname='Testing', 
         languagelocalekey='en_US', 
         localesidkey='en_US', 
         profileid = p.Id, 
         timezonesidkey='America/Los_Angeles', 
         username='standarduser22@testorg.com');
         
         insert u ;
                         
        Contact objTestcontact = new Contact();
            objTestcontact.lastname = 'Test name';
            objTestcontact.Accountid= objTestAccount1.id;
            
            insert objTestcontact;    
            
        Campaign objtestCampaign =new Campaign();
                 objtestCampaign.name='Test_Campaign';
                 objtestCampaign.OwnerId=u.Id;
                 objtestCampaign.recordtypeid=rt.id;
                 objtestCampaign.Parent_Campaign__c=True;
                 //objtestCampaign.Parentid =objTestcontact.id;
                 insert objtestCampaign;
         
        Campaign objtestCampaign1 =new Campaign();
                 objtestCampaign1.name='Test_Campaign';
                 objtestCampaign1.OwnerId=u.Id;
                 objtestCampaign1.recordtypeid=rt.id;
                 objtestCampaign1.Parentid =objtestCampaign.id;
                 insert objtestCampaign1;         
                 
                 
                          User u1 = new User(
         alias = 'standt1', 
         email='standarduser221@testorg.com', 
         emailencodingkey='UTF-8',  
         lastname='Testing1', 
         languagelocalekey='en_US', 
         localesidkey='en_US', 
         profileid = p.Id, 
         timezonesidkey='America/Los_Angeles', 
         username='standarduser221@testorg.com');
         
         insert u1 ;

                 
                 
                 
                objtestCampaign.OwnerId=u1.ID;
                update objtestCampaign; 
                
                
                
                 //objtestCampaign.Owner=system.currentPageReference(user);
                 
    }
   
}