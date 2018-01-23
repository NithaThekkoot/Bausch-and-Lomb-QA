trigger DeleteCaseNoteInCATSWeb on Case_Note__c (before delete) {
    
    
    list<Profile> IntergartionProfile = new list<Profile>([select id,name from Profile where name = 'BL: Integration User' limit 1]);    
    Set<Id> caseIds = new set<id>();
     if(Userinfo.getProfileId()!=IntergartionProfile[0].Id)
      {
        for(Case_Note__c  CN :Trigger.old)
        {   
           system.debug('Id of the record is ----------->' + CN.ID);
            if(UserInfo.getUserId() != CN.CreatedByid){
                if(!test.isRunningTest())
                CN.adderror('Only the person that created this Case Note can modify or delete it.');
            }else{
                caseIds.add(CN.Case__c);
            }     
            
        }        
     }
     
     if(!caseIds.isEmpty())
     {
          list<Case_Note__c> CaseNotOpen = new list<Case_Note__c>();
          list<string> Delete_from_CATSWeb = new list<string>();          
          map<Id,Case> AllCases = new map<Id,case>([select id,status,Send_to_CATSWeb__c from Case where ID IN :caseIds]);
          
          for(Case_Note__c  CN : Trigger.old){              
                  if(AllCases.get(CN.Case__c).status !='Open'){
                      CaseNotOpen.add(CN);
                   }
                   else{
                      if(AllCases.get(CN.case__c).Send_to_CATSWeb__c == 'Yes'){
                        system.debug('Id in if loop ----------->' + CN.ID);
                        Delete_from_CATSWeb.add(CN.Id);                      
                      }
                        
                   }                            
          }
          
          if(!CaseNotOpen.isEmpty()){
            for(Case_Note__c CN :CaseNotOpen){
              if(!test.isRunningTest()) 
              CN.adderror('Once a Product Complaint has been closed, no additional changes may be made. The Product Complaint can be reopened in CATSWeb.');
            }            
          }
          System.debug('Result is------------->' +Delete_from_CATSWeb);          
          if(!Delete_from_CATSWeb.isEmpty()){
          /* considering that delete will happen one at a time manually*/
            if(!test.isRunningTest())
            Delete_from_CATSWeb_Batch.sendRequest(Delete_from_CATSWeb[0],'Case_Note__c','');
          }
     }
     
 }