trigger deleteConsignmentData on Consignment_Search_Data__c (before insert) { 
   
    system.debug('UserInfo.getUserId()-----------'+UserInfo.getUserId());  
    system.debug('UserInfo.getUserId()-----------'+trigger.new[0].Search_ID__c);  
    List<Consignment_Search_Data__c> lstConsignmentData = [select Id from Consignment_Search_Data__c  where User_ID__c=:trigger.new[0].User_ID__c AND Search_ID__c !=:trigger.new[0].Search_ID__c limit 10000];
    system.debug('&&&&&&&&&&&'+lstConsignmentData.size());
    if(lstConsignmentData.size()>0){
        delete lstConsignmentData ;
    }
    
}