@isTest
private class clsUpdateFuturePhysicianVisits_Test {

    static testMethod void myUnitTest() {
        User objOwner = [Select Id from User where Profile.Name = 'BL: Integration User' and isactive = true Limit 1];
        
        User objSalesRep = [Select Id from User where Profile.Name = 'INDSU Sales Rep' and isactive = true Limit 1];
        
         Map<string,String> map_RecordType = new Map<string,String>();
        for(RecordType rt : [Select Id, Name from RecordType where Name in ('INDSU Indirect','INDSU Contact','INDSU Sales Unplanned','INDSU Sales Planned','INDSU Monthly Implantation Detail') and sObjectType in ('Physician_Visit__c','Account','Contact','Monthly_Implantation_Detail__c')])
        {
            map_RecordType.put(rt.Name,rt.Id);
        }
       
         /**********Account **************/
        Account oAccount = new Account();       
        oAccount.OwnerId = objOwner.Id;            
        oAccount.Name = 'Test'; 
        oAccount.recordTypeId = map_RecordType.get('INDSU Indirect');  
        
        /**********Contact **************/
        Contact oContact = new Contact(); 
        oContact.AccountId = oAccount.Id;                        
        oContact.LastName = 'Test Contact';
        oContact.recordTypeId = map_RecordType.get('INDSU Contact');   
                
        Contact_Profile__c objContactProfileA = new Contact_Profile__c();
        system.runAs(objOwner){
                     
                insert oAccount;
                insert oContact;
                
               
                objContactProfileA.Contact__c = oContact.Id ;
                objContactProfileA.Doctor_Segmentation__c = 'A';
                insert objContactProfileA;
                
                AccountTeamMember oATM = new AccountTeamMember();
                oATM.AccountId = oAccount.Id;
                oATM.TeamMemberRole = 'Sales Rep';
                oATM.UserId = objSalesRep.Id;
                insert oATM;
                
                
        }
        
        List<Physician_Visit__c> pvListPlanned = new List<Physician_Visit__c>();
        //List<Physician_Visit__c> pvListPlannedUpdate = new List<Physician_Visit__c>();
        List<Physician_Visit__c> pvListUnPlanned = new List<Physician_Visit__c>();
        
        Physician_Visit__c oPhysicianVisit1 = new Physician_Visit__c();
        oPhysicianVisit1.Activity_Date__c = Date.today();
        oPhysicianVisit1.Physician__c = oContact.Id;
        oPhysicianVisit1.Status__c = 'Open';
        oPhysicianVisit1.Session__c = 'AM';
        oPhysicianVisit1.Planned_Call__c = false;
        oPhysicianVisit1.Start_Time__c = Datetime.Now();
        oPhysicianVisit1.End_Time__c = Datetime.Now().addMinutes(30);
        oPhysicianVisit1.Joint_Call_With_ASM__c = False;           
        oPhysicianVisit1.Last_Activity__c=null;
        oPhysicianVisit1.OwnerId = objSalesRep.Id;
        oPhysicianVisit1.Call_Objective_Achieved__c = true;
        oPhysicianVisit1.OT_Hours__c = true;
        oPhysicianVisit1.RecordTypeId = map_RecordType.get('INDSU Sales Unplanned');
        oPhysicianVisit1.Planned_Call__c = false;
        oPhysicianVisit1.Hours_in_Surgery__c = '2';
        
        Physician_Visit__c oPhysicianVisit2 = new Physician_Visit__c();
        oPhysicianVisit2.Activity_Date__c = Date.today().addDays(-2);
        oPhysicianVisit2.Physician__c = oContact.Id;
        oPhysicianVisit2.Status__c = 'Open';
        oPhysicianVisit2.Session__c = 'AM';
        oPhysicianVisit2.Planned_Call__c = false;
        oPhysicianVisit2.Start_Time__c = Datetime.Now();
        oPhysicianVisit2.End_Time__c = Datetime.Now().addMinutes(30);
        oPhysicianVisit2.Joint_Call_With_ASM__c = False;           
        oPhysicianVisit2.Last_Activity__c=null;
        oPhysicianVisit2.OwnerId = objSalesRep.Id;
        oPhysicianVisit2.Call_Objective_Achieved__c = true;
        oPhysicianVisit2.OT_Hours__c = true;
        oPhysicianVisit2.RecordTypeId = map_RecordType.get('INDSU Sales Unplanned');
        oPhysicianVisit2.Planned_Call__c = false;
        oPhysicianVisit2.Hours_in_Surgery__c = '2';
        
        List<Physician_Visit__c> listPhysicianVisit = new List<Physician_Visit__c>();
        listPhysicianVisit.add(oPhysicianVisit2);
        
        
        for(Integer i=0;i<10;i++){
            Physician_Visit__c oPhysicianVisit = new Physician_Visit__c();
            //oPhysicianVisit.Name = 'Test : ' + i;
            
            //oPhysicianVisit.Activity_Date__c = date.newInstance(system.today().year(),system.today().month(),1);
            oPhysicianVisit.Activity_Date__c = System.today().addDays(-3);
            oPhysicianVisit.Physician__c = oContact.Id;
            oPhysicianVisit.Status__c = 'Open';
            oPhysicianVisit.Session__c = 'AM';
            oPhysicianVisit.Planned_Call__c = false;
            oPhysicianVisit.Start_Time__c = Datetime.Now();
            oPhysicianVisit.End_Time__c = Datetime.Now().addMinutes(30);
            oPhysicianVisit.Joint_Call_With_ASM__c = False;           
            oPhysicianVisit.Last_Activity__c=null;
            oPhysicianVisit.OwnerId = objSalesRep.Id;
            oPhysicianVisit.Call_Objective_Achieved__c = true;
            oPhysicianVisit.OT_Hours__c = true;
            
            if((i/2)==0){
                oPhysicianVisit.RecordTypeId = map_RecordType.get('INDSU Sales Unplanned');
                oPhysicianVisit.Planned_Call__c = false;
                oPhysicianVisit.Hours_in_Surgery__c = '2';
                pvListUnPlanned.add(oPhysicianVisit);  
            }
            else{
                oPhysicianVisit.RecordTypeId = map_RecordType.get('INDSU Sales Planned');  
                oPhysicianVisit.Planned_Call__c = true;
                pvListPlanned.add(oPhysicianVisit);
            }
            
        }
         system.debug('Planned Physician Visit List : '+ pvListPlanned);
         system.debug('Unplanned Physician Visit List : '+ pvListUnPlanned);
         
         system.runAs(objSalesRep){
              insert listPhysicianVisit;
              clsUpdateFuturePhysicianVisits pvUpdate1 = new clsUpdateFuturePhysicianVisits();
              pvUpdate1.updateFuturePhysicianVisits(pvListUnPlanned,'insert');
              pvUpdate1.updateFuturePhysicianVisits(pvListUnPlanned,'update');
              pvUpdate1.updateFuturePhysicianVisits(pvListPlanned,'insert');
              pvUpdate1.updateFuturePhysicianVisits(pvListPlanned,'update');
            //insert pvListPlanned;
            //insert pvListUnPlanned;
            update listPhysicianVisit;
           for(Physician_Visit__c pv:pvListPlanned){
                pv.Status__c = 'Completed';
                
            }
            
            for(Physician_Visit__c pv:pvListUnPlanned){
                pv.Status__c = 'Completed';
                
            }
           
            //clsPhysicianVisitUpdate.isExecute = false;
            //clsPhysicianVisitUpdate.isInsert = false;
            clsPhysicianVisitUpdate.blnIsTriggerFiredAlreadyForJntFldWrk = false; 
            //update pvListUnPlanned;
            //update pvListPlanned;
            
            update listPhysicianVisit;
         }
         
        List<Physician_Visit__c> pvListPhyscianVisits = new List<Physician_Visit__c>();
        List<Effectiveness_Summary__c> listEffect = new List<Effectiveness_Summary__c>();
        
        for(Integer i=0;i<10;i++){
           
            
            Physician_Visit__c oPhysicianVisit = new Physician_Visit__c();
            //oPhysicianVisit.Name = 'Test : ' + i;
            
            //oPhysicianVisit.Activity_Date__c = date.newInstance(system.today().year(),system.today().month(),1);
            oPhysicianVisit.Activity_Date__c = System.today().addDays(-1);
            oPhysicianVisit.Physician__c = oContact.Id;
            oPhysicianVisit.Status__c = 'Open';
            oPhysicianVisit.Session__c = 'AM';
            oPhysicianVisit.Start_Time__c = Datetime.Now();
            oPhysicianVisit.End_Time__c = Datetime.Now();
            oPhysicianVisit.Joint_Call_With_ASM__c = False;           
            oPhysicianVisit.Last_Activity__c=null;
            oPhysicianVisit.OwnerId = objSalesRep.Id;
            oPhysicianVisit.Call_Objective_Achieved__c = true;
            if((i/2)==0){
                oPhysicianVisit.RecordTypeId = map_RecordType.get('INDSU Sales Unplanned');
                oPhysicianVisit.Planned_Call__c = false;
                pvListPhyscianVisits.add(oPhysicianVisit);  
            }
            else{
                oPhysicianVisit.RecordTypeId = map_RecordType.get('INDSU Sales Planned');  
                oPhysicianVisit.Planned_Call__c = true;
                pvListPhyscianVisits.add(oPhysicianVisit);
            }
            
            Effectiveness_Summary__c effectivenessSummary = new Effectiveness_Summary__c();
            effectivenessSummary.Date__c = oPhysicianVisit.Activity_Date__c;
            effectivenessSummary.ownerId = oPhysicianVisit.OwnerId;
            effectivenessSummary.OT_Hours__c = 0;
            listEffect.add(effectivenessSummary);
            
        }
        system.runAs(objOwner){
            objContactProfileA.Doctor_Segmentation__c = 'B';
            update objContactProfileA;
        }
                
        system.runAs(objSalesRep){
            insert listEffect;
            
            clsUpdateFuturePhysicianVisits pvUpdate = new clsUpdateFuturePhysicianVisits();
            pvUpdate.updateFuturePhysicianVisits(pvListPhyscianVisits,'insert');
            pvUpdate.updateFuturePhysicianVisits(pvListPhyscianVisits,'update');
            
            for(Physician_Visit__c pv :pvListPhyscianVisits){
                pv.Status__c = 'Completed';
            }
            
            //pvUpdate.updateFuturePhysicianVisits(pvListPhyscianVisits,'insert');
            //pvUpdate.updateFuturePhysicianVisits(pvListPhyscianVisits,'update');
            
            clsPhysicianVisitUpdate.isExecute = false;
            clsPhysicianVisitUpdate.isInsert = false;
            clsPhysicianVisitUpdate.blnIsTriggerFiredAlreadyForJntFldWrk = false;
            pvUpdate.updateFuturePhysicianVisits(pvListPhyscianVisits,'update');
            //update pvListPlanned;
        }
        
        system.runAs(objOwner){
            objContactProfileA.Doctor_Segmentation__c = 'C';
            update objContactProfileA;
        }
                
        system.runAs(objSalesRep){
            
             clsPhysicianVisitUpdate.blnIsTriggerFiredAlreadyForJntFldWrk = false;
            clsUpdateFuturePhysicianVisits pvUpdate = new clsUpdateFuturePhysicianVisits();
            //pvUpdate.updateFuturePhysicianVisits(pvListPhyscianVisits,'insert');
            pvUpdate.updateFuturePhysicianVisits(pvListPhyscianVisits,'update');
            
            for(Physician_Visit__c pv :pvListPhyscianVisits){
                pv.Status__c = 'Completed';
            }
            
            //pvUpdate.updateFuturePhysicianVisits(pvListPhyscianVisits,'insert');
            //pvUpdate.updateFuturePhysicianVisits(pvListPhyscianVisits,'update');
            
            clsPhysicianVisitUpdate.isExecute = false;
            clsPhysicianVisitUpdate.isInsert = false;
            clsPhysicianVisitUpdate.blnIsTriggerFiredAlreadyForJntFldWrk = false;
            pvUpdate.updateFuturePhysicianVisits(pvListPhyscianVisits,'update');
          
        }
        
        
      
        
         
         
    }
}