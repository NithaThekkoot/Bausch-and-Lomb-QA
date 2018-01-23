/**
* 
*   This class is used as the extension for the page which overrides standard view page for Call Plan 
*   Redirects to standard layout for KOREA SOLTA users
*
*    Author                |Author-Email                                       |Date       |Comment
*    ----------------------|---------------------------------------------------|-----------|---------------------------------
*    Venkateswara Reddy    | venkateswara.reddy2@bausch.com                    |12.Nov.2015| First draft
* Test Class : Test_ExtViewCallPlan_KOR_SOLTA   
*/
public with sharing class ExtViewCallPlan_KOR_SOLTA {

    //Call plan
    public Call_Plan__c objCallPlan {get; set;}
    //Owner of the call
    public String strOwner {get; set;}
    //Has the status about the call plan details
    public Boolean blnHasDetails {get; set;}
    //Week which is selected
    public String strWeek{get;set;}
    
    //Call Id
    public String strCallId;
    public String retURL;
    //Is the call plan editable based on the status
    public Boolean blnIsEditable {get; set;}
        
    //Constructor
    public ExtViewCallPlan_KOR_SOLTA(ApexPages.StandardController controller){
        
        strCallId = Apexpages.currentPage().getParameters().get('Id');
        retURL =  Apexpages.currentPage().getParameters().get('retURL');
        blnHasDetails = false;
        blnIsEditable = true;
        
        if(strCallId!=NULL && strCallId!=''){
             
            Call_Plan__c[] list_CallPlans = [SELECT Id, 
                                                    Name, 
                                                    Status__c, 
                                                    Month__c, 
                                                    Year__c,
                                                    Owner.Name, 
                                                    OwnerId, 
                                                    Createddate,                                                    
                                                    Manager_Comments__c,
                                                    Executive_Comments__c,
                                                    Start_Date__c,
                                                    End_Date__c,
                                                    Week__c,
                                                    (SELECT Id FROM Call_Plan_Detail__r LIMIT 1)
                                                FROM Call_Plan__c  
                                                WHERE Id = :strCallId LIMIT 1];
                                                
            
            if(list_CallPlans.size() > 0){
                objCallPlan = list_CallPlans[0];
                
            if(objCallPlan.Call_Plan_Detail__r.size() > 0)
                blnHasDetails = true;
                    
            strOwner = list_CallPlans[0].Owner.Name;
          
            //Week format will be displayed based on the format available in the custom settings for each role
            if(objCallPlan.Start_Date__c!= null && objCallPlan.End_Date__c!= null)            
                strWeek = ClsSingleMultiUtility.getDisplayWeekInDifferentFormat(objCallPlan.Start_Date__c, objCallPlan.End_Date__c, ClsSingleMultiUtility.getWeekFormat(UserInfo.getUserRoleId())); //12.Jan.2011
                
            if(objCallPlan.Status__c == 'Submitted' || objCallPlan.Status__c == 'Approved')
                blnIsEditable = false;
                
            if(blnIsEditable){  
                    
                Profile thisProfile = [select Id,Name from Profile where Id =: userInfo.getProfileId() LIMIT 1];
        
                if(thisProfile !=NULL && thisProfile.Name.contains(Label.manager_label))
                    blnIsEditable = false;
                    
                if(objCallPlan.Status__c == 'Submitted')
                    blnIsEditable = false;
            }
                
            }
        } 
        
    }
    
    //Schedule the call plan
    public PageReference schedule()
    {
        PageReference pagRef;

        pagRef = new PageReference('/apex/CallPlan_KOR_SOLTA?id=' + objCallPlan.Id);
        return pagRef;
    }
    
    //Cancel the call plan
    public PageReference cancel()
    {
        String strRetURL = '/' + Call_Plan__c.SObjectType.getDescribe().getKeyPrefix() + '/o';
        return (new PageReference(strRetURL));
    }    
    
    //this section will decide about the call plan format(Week or Month) to be displayed
    public PageReference redirectFromNewPage()
    {        
        Boolean blnIsWeeklyPlan = false;
     

        UserRole objCurrentRole;
        
        //Taking the profile names for weekly call plan from the custom setting
        Map<String,Weekly_Call_Plan_Profiles__c> map_ProfileNameFromCustSetting = new Map<String,Weekly_Call_Plan_Profiles__c>();
        //Set<String> set_ProfileNames = new Set<String>();
        Map<String,Weekly_Call_Plan_Profiles__c> map_ProfileNames = new Map<String,Weekly_Call_Plan_Profiles__c>();
        
        map_ProfileNameFromCustSetting = Weekly_Call_Plan_Profiles__c.getAll();
        system.debug('map_ProfileNameFromCustSetting>>>'+map_ProfileNameFromCustSetting);
        
        for(Weekly_Call_Plan_Profiles__c objTemp : map_ProfileNameFromCustSetting.values())
        {
            //set_ProfileNames.add(objTemp.Profile_Name__c);
            map_ProfileNames.put(objTemp.Profile_Name__c, objTemp);
        }
        //system.debug('set_ProfileNames>>'+set_ProfileNames);
        
        if(UserInfo.getUserRoleId() == null)
            blnIsWeeklyPlan = false; 
        else
            //Profile objCurrentProfile = [SELECT Id, Name FROM Profile WHERE Id = : userInfo.getProfileId() LIMIT 1];
            objCurrentRole = [SELECT Id, Name FROM UserRole WHERE Id =: UserInfo.getUserRoleId() LIMIT 1];
        
        if(objCurrentRole != null)
        {
            //for(String strTempProfName : set_ProfileNames)
            Set<String> set_ProfileNames = map_ProfileNames.keySet();
            for(String key : set_ProfileNames)
            {
                Weekly_Call_Plan_Profiles__c objWkCpProfs = map_ProfileNames.get(key);

                if(objCurrentRole.Name != null && objCurrentRole.Name.startsWith(objWkCpProfs.Profile_Name__c) && (objWkCpProfs.Region__c == 'Korea'))
                    blnIsWeeklyPlan = true;                                  

                
            }
        }
        
       
        if(!blnIsWeeklyPlan)        {
            String strObjCode = Call_Plan__c.SObjectType.getDescribe().getKeyPrefix();
            if(retURL!=NULL && retURL!='')
                return (new PageReference('/' + strCallId + '?nooverride=1' + '&retURL=' + retURL));
            return (new PageReference('/' + strCallId + '?nooverride=1'));
        }
        return null;
    }
   
}