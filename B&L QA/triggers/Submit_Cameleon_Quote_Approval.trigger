/**
* 
*  
*  Author                      |Author-Email              |Date          |Comment
*  ----------------------------|--------------------------|--------------|------------------------------------------------------------------
*  Kuldeep               | kuldeep.rathore@bausch.com | Sept 5, 2013 | First Draft
*  
*  Test Class :Test_Submit_Cameleon_QuoteApproval   
*/

trigger Submit_Cameleon_Quote_Approval on CameleonCPQ__Quote__c (After update) 
{

      id currentuser=UserInfo.getUserId();
      list<User>usermanger=new list<User>([select id,DelegatedApproverid,Managerid from User where id= :currentuser ]);
      System.debug('-----------usermanger--------'+usermanger[0].DelegatedApproverid);
      System.debug('-----------usermanger--------'+usermanger);      
      for(CameleonCPQ__Quote__c o: trigger.new)
      { 
          
              if(o.Approval_Level__c > 0 && o.CameleonCPQ__Status__c <> 'SubmittedforApproval')
              {
                  if(usermanger[0].Managerid== null )
                  {
                      
                      o.adderror('You must have a manager defined on your user record for the approval to be processed.  Please contact your administrator for assistance');
                      
                  }
                  else
                  {                      
                      Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
                      req1.setComments('Submitting Cameleon Quote for approval.');
                      req1.setObjectId(o.id);
                      Approval.ProcessResult result = Approval.process(req1);
                          System.assert(result.isSuccess());
                          System.assertEquals('Pending', result.getInstanceStatus(), 
                      'Instance Status'+result.getInstanceStatus());
                  }
             }
          
              
        }  
}