trigger DeleteAddlContactInCATSWeb on Additional_Product_Complaint_Contact__c (before delete) {

  set<String> AllCaseId = new set<String>();
  list<Profile> IntergartionProfile = new list<Profile>([select id,name from Profile where name = 'BL: Integration User' limit 1]);
  if(Userinfo.getProfileId()!=IntergartionProfile[0].Id)
  {
    for(Additional_Product_Complaint_Contact__c ac :Trigger.old)
    {
        
        AllCaseId.add(ac.Case__c);
    }
    if(!AllCaseId.isEmpty())
    {
      list<Additional_Product_Complaint_Contact__c> CaseNotOpen = new list<Additional_Product_Complaint_Contact__c>();
      list<string> Delete_from_CATSWeb = new list<string>();  
        list<string> Delete_from_CATSWeb_RT = new list<string>();      
      map<Id,Case> AllCases = new map<Id,case>([select id,status,Send_to_CATSWeb__c from Case where ID IN :AllCaseId]);
      
      for(Additional_Product_Complaint_Contact__c ac :Trigger.old)
      {
           if(AllCases.get(ac.Case__c).status !='Open')
           {
              CaseNotOpen.add(ac);
           }
           else
           {
              if(AllCases.get(ac.Case__c).Send_to_CATSWeb__c == 'Yes')
                Delete_from_CATSWeb.add(ac.id); 
                 Delete_from_CATSWeb_RT.add(ac.Record_Type__c);                                 
           }
      }
      if(!CaseNotOpen.isEmpty()) 
      {
        for(Additional_Product_Complaint_Contact__c aa :CaseNotOpen)
        {
          if(!test.isRunningTest())
          aa.adderror('Once a Product Complaint has been closed, no additional changes may be made. The Product Complaint can be reopened in CATSWeb.');
        }
      }            
      if(!Delete_from_CATSWeb.isEmpty()){
        /* considering that delete will happen one at a time manually*/ 
        if(!test.isRunningTest())     
        Delete_from_CATSWeb_Batch.sendRequest(Delete_from_CATSWeb[0],'Additional_Product_Complaint_Contact__c',Delete_from_CATSWeb_RT[0]);
      }
      
    }    
  }

}