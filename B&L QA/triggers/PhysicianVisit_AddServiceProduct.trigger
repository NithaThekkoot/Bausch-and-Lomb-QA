trigger PhysicianVisit_AddServiceProduct on Physician_Visit__c (after insert) 
{
        List<Physician_Visit__c> NewPhysicianVisit=new List<Physician_Visit__c>();
        List<Service_Product__c> NewServicePro=new List<Service_Product__c>();
        List<Physician_Visit__c> PhysicianVisit_Toupdate=new List<Physician_Visit__c>();
        
        NewPhysicianVisit=[select Id ,Approval_Stage__c,Status__c,RecordType.Name from Physician_Visit__c where Id in:Trigger.new  and RecordType.name in('APACSU Technical Service','APACSU Service Engineer')];
//check if user is other than KOREA SOLTA or not
 // list<UserRole> lstroleName=[SELECT Id, Name FROM UserRole WHERE Id =: UserInfo.getUserRoleId() LIMIT 1];  
   string lstroleName = UserInfo.getLocale();
    if(!lstroleName.contains('ko_KR')){      

        if(Trigger.isInsert)
        {
             if(NewPhysicianVisit.Size()>0)
            for(Physician_Visit__c  Phy:NewPhysicianVisit)
            {
                if(Phy.RecordType.Name=='APACSU Technical Service')
                {
                    RecordType TechnicalServiceType=[select Id from RecordType where name='APACSU Service Rep Product' and SobjectType='Service_Product__c'  limit 1];
                    if(TechnicalServiceType!=null)
                    {
                        Service_Product__c newpro=new Service_Product__c(Physician_Visit__c=Phy.Id,RecordTypeId=TechnicalServiceType.Id);
                    
                        NewServicePro.Add(newpro);
                    }
                    
                                    
                }
                if(Phy.RecordType.Name=='APACSU Service Engineer')
                {
                    Phy.Status__c='Completed';
                    Phy.Reporting_Time__c=System.Now();
                    Phy.Approval_Stage__c='Draft';
                    PhysicianVisit_Toupdate.Add(Phy);
                    System.debug('STATUS COMPLETE' + Phy.Status__c);
                     
                }
                
                
                                
            }                   
            
            if(NewServicePro.Size()>0)              
                insert NewServicePro;
            if(PhysicianVisit_Toupdate.Size()>0)
            {
                
                update PhysicianVisit_Toupdate;
            }   
            
            
                
        }
    }//!KOR
    
    else{
system.debug('Trigger Name: PhysicianVisit_AddServiceProduct------->No Need for KOR SOLAT USers');    
        }
        
}//tirgger