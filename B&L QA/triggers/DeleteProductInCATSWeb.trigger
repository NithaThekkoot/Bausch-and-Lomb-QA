trigger DeleteProductInCATSWeb on Product_Complaint_Product__c (before delete) {
    
    list<Profile> IntergartionProfile = new list<Profile>([select id,name from Profile where name = 'BL: Integration User' limit 1]);    
    Set<Id> caseIds = new set<id>();
     if(Userinfo.getProfileId()!=IntergartionProfile[0].Id)
      {
        for(Product_Complaint_Product__c Pcp :Trigger.old)
        {  
            if(Pcp.Delete_Trigger__c == false)            
            caseIds.add(Pcp.Case__c);            
        }        
     }
     system.debug('caseIds'+caseIds);
     if(!caseIds.isEmpty())
     {
          list<Product_Complaint_Product__c> CaseNotOpen = new list<Product_Complaint_Product__c>();
          list<string> Delete_from_CATSWeb = new list<string>();
           list<string> Delete_from_CATSWeb_RT = new list<string>();
          map<Id,Case> AllCases = new map<Id,case>([select id,status,Send_to_CATSWeb__c from Case where ID IN :caseIds]);
          
          for(Product_Complaint_Product__c  Pcp : Trigger.old){
              if(AllCases.get(Pcp.Case__c).status !='Open'){
                  CaseNotOpen.add(Pcp);
               }
               else{
                  if(AllCases.get(Pcp.Case__c).Send_to_CATSWeb__c == 'Yes')
                    Delete_from_CATSWeb.add(Pcp.id);
                    Delete_from_CATSWeb_RT.add(Pcp.Record_Type__c);
               }
          }
          
          if(!CaseNotOpen.isEmpty()){
            for(Product_Complaint_Product__c Pcp:CaseNotOpen){
              if(!test.isRunningTest()) 
              Pcp.adderror('Once a Product Complaint has been closed, no additional changes may be made. The Product Complaint can be reopened in CATSWeb.');
            }            
          }
          System.debug('Result is------------->' +Delete_from_CATSWeb);          
          if(!Delete_from_CATSWeb.isEmpty()){
          if(!test.isRunningTest())          
            Delete_from_CATSWeb_Batch.sendRequest(Delete_from_CATSWeb[0],'Product_Complaint_Product__c',Delete_from_CATSWeb_RT[0] );
          }
     }


}