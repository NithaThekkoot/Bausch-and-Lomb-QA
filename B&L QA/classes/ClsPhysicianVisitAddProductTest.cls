@isTest
private class ClsPhysicianVisitAddProductTest {

    static testMethod void myUnitTest() {
                RecordType ServiceRepType=[select name,Id from RecordType where name='APACSU Technical Service' And SobjectType='Physician_Visit__c' limit 1];
                RecordType EngineerType=[select name,Id from RecordType where name='APACSU Service Engineer' And SobjectType='Physician_Visit__c' limit 1];
                RecordType PhysicianType=[select Id,name from RecordType where SobjectType='Contact' and name='APACSU Contact' limit 1];
                RecordType AccType=[select Id from RecordType where SobjectType='Account' and name='APACSU Direct'];
                
                Account    TestAcc=new Account(RecordTypeId=AccType.Id,name='Test Acc');
                
                Contact Myphy=new Contact(RecordTypeId=PhysicianType.Id,FirstName='Test',LastName='GG',AccountId=TestAcc.Id);
                
                User objUser = [Select Id, Name from User where User.UserRole.Name  like 'INDSU Sales %' and isactive=: true Limit 1];
                
                System.runAs(objuser) {
                     if(ServiceRepType!=null && PhysicianType!=null)
                        {
                            Test.startTest();
                            insert Myphy;
                            
                            List<Physician_Visit__c> listPhysicianVisit = new List<Physician_Visit__c>();
                            
                            Physician_Visit__c testPhyVisit1=new Physician_Visit__c(RecordTypeId=ServiceRepType.Id,Physician__c=Myphy.Id,
                            Activity_Date__c=System.Today()+30,Call_Duration_Mns__c='5mins',Times_in_Surgery__c='3',Status__c='Open');
                            
                            listPhysicianVisit.add(testPhyVisit1);
                            
                            Physician_Visit__c testPhyVisit2=new Physician_Visit__c(RecordTypeId=EngineerType.Id,Status__c='Open',
                            Activity_Date__c=System.Today()+30,Contact__c='Test',Call_Duration_Mns__c='5mins',Service_No__c='111',  Contact_Tel__c='111');
                            listPhysicianVisit.add(testPhyVisit2);

                            insert listPhysicianVisit;
                            
                            Service_Product__c SP=[select Id from Service_Product__c where Physician_Visit__c=:TestPhyVisit1.Id limit 1];
                            system.assertNotEquals(SP,null);    
                            
                            SP.Product1__c='CX1000';SP.Experiences1__c='abc';
                            SP.X1_8mm_Alcon__c=1;SP.X2_2mm_Alcon__c=1;SP.X2_8mm_Alcon__c=1;
                            SP.X1_8mm_AMO__c=2;SP.X2_2mm_AMO__c=2;SP.X2_8mm_AMO__c=2;
                            SP.X1_8mm_B_L__c=3;SP.X2_2mm_B_L__c=3;SP.X2_8mm_B_L__c=3;
                            SP.X1_8mm_HumanOptics__c=4;SP.X2_2mm_HumanOptics__c=4;SP.X2_8mm_HumanOptics__c=4;
                            SP.X1_8mm_Zeiss__c=5;SP.X2_2mm_Zeiss__c=5;SP.X2_8mm_Zeiss__c=5;
                            SP.Call_Result1__c='need follow up';SP.Call_Objective1__c='Bidding support';                
                            update SP;
                            
                            Physician_Visit__c PV1=[select Id,Times_in_Surgery__c,Status__c from Physician_Visit__c where Id=:TestPhyVisit1.Id limit 1];
                            Physician_Visit__c PV2=[select Id,Status__c from Physician_Visit__c where Id=:TestPhyVisit2.Id limit 1];
                            
                            
                            
                            system.assertEquals(PV2.Status__c,'Completed');
                            system.assertEquals(PV1.Status__c,'Completed');
                            
                            PV1.Times_in_Surgery__c='2';
                            update PV1;
                            
                            
                            SP.X1_8mm_Alcon__c=11;SP.X2_2mm_Alcon__c=11;SP.X2_8mm_Alcon__c=11;
                            SP.X1_8mm_AMO__c=22;SP.X2_2mm_AMO__c=22;SP.X2_8mm_AMO__c=22;
                            SP.X1_8mm_B_L__c=33;SP.X2_2mm_B_L__c=33;SP.X2_8mm_B_L__c=33;
                            SP.X1_8mm_HumanOptics__c=44;SP.X2_2mm_HumanOptics__c=44;SP.X2_8mm_HumanOptics__c=44;
                            SP.X1_8mm_Zeiss__c=55;SP.X2_2mm_Zeiss__c=55;SP.X2_8mm_Zeiss__c=55;
                            
                            update SP;   
                            
                            Test.stopTest();                         
                        }
                }
                
    }
}