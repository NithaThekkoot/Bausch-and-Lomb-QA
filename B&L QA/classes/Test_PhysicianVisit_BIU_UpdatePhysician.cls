@isTest(seealldata=true)
private class Test_PhysicianVisit_BIU_UpdatePhysician {

 public static testMethod void PhysicianVisit_BIU_Update(){
     test.startTest();
     account a=new account(name='Test_account',phone='123456');
     insert a;
     contact c=new contact(lastname='test_contact',accountid=a.id);
     insert c;
 
    
     Physician_Visit__c phy=new Physician_Visit__c();
    // phy.Account_ID__c=account_id;
     phy.Activity_Date__c=system.today();
     phy.Hospital__c=a.id;
     phy.Status__c='complete';
     phy.Session__c='AM'; 
     phy.Physician__c=c.id;
    
    // phy.Account_Profile__c=[select id from account_profile__c where account__c=:account_id].id;
     insert phy;
    // phy.Account_Profile__c=[select id from account_profile__c where account__c=:account_id].id;
    
    phy.Status__c='open';
     update phy;
     test.stopTest();
  
 }

}