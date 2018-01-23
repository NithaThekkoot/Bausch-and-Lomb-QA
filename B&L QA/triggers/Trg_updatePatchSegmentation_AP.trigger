/**
* 
*   This trigger is used for Thailand to update Segmentation based on values of patch.
*
*   Author           |Author-Email                        |Date       |Comment
*   -----------------|------------------------------------|-----------|--------------------------------------------------
*   Neha Jain        |neha.jain@bausch.com               |17.02.2014 |First draft
*   Neha Jain        |neha.jain@bausch.com               |25.03.2014 |Modified code to excecute only for thailand
* 
* Test Class -- Trg_updatePatchSegmentation_AP_Test
*/
trigger Trg_updatePatchSegmentation_AP on Account_Profile__c (after insert, after update) {
    //Logic:
    //1. Get list of account profiles to be updated on the basis of Trigger.New
    //2. Set the value of Segmentation__c based on the value of Patch__c
    //3. Update the account profile
    
    
    //check if the user role exists
    if(UserInfo.getProfileId() == null)
        return;
    //check for the profile of user, should be excecuted only for Thailand
    Profile userProfile = [Select name from profile where Id =: UserInfo.getProfileId()];
    if(userProfile.Name.contains('THA')){
       
    
    //Map for respectative values of segmentation__c on the basis of patch__c
    Map<String, string> mapPatchSegmentationValues = new Map<String, String>();
    mapPatchSegmentationValues.put('P1', 'Tier 1');
    mapPatchSegmentationValues.put('P2', 'Tier 2');
    mapPatchSegmentationValues.put('P3', 'Tier 3');
    mapPatchSegmentationValues.put('1', 'Tier 4');
    
    integer count = 0;
    boolean isChanged = false;
   
    //Fetch the list of Account Profiles on the basis of Trigger.New, as updation directly on Trigger.New is not allowed.
    List<Account_profile__c> listAccountProfile = [Select Patch__c, Segmentation__c from Account_profile__c where Id IN: Trigger.New];
    
    //Iterate over the Account_Profile__c list to update Segmentation
    for(Account_profile__c accountProfile :listAccountProfile){

    if(Trigger.Old ==null)
    {
          accountProfile.Segmentation__c = mapPatchSegmentationValues.get(accountProfile.Patch__c);
          isChanged = true;
    }
    else
    {
        if(accountProfile.Patch__c !=  Trigger.Old[count].Patch__c)
        {
          accountProfile.Segmentation__c = mapPatchSegmentationValues.get(accountProfile.Patch__c);
          isChanged = true;
        }
     }       
        count++;
    }
    //Updates only if values are changed.
    if(isChanged){
        update listAccountProfile ;
    }
}
}