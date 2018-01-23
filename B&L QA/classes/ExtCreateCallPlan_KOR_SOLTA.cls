/**
* 
*   This class is used as the extension for the page which overrides standard edit and detail page for Call Plan 
*   Redirects to standard layout for KOREA SU users
*
*    Author                |Author-Email                                       |Date        |Comment
*    ----------------------|---------------------------------------------------|------------|---------------------------------
     Venkateswara Reddy    | venkateswara.reddy2@bausch.com                    |02.Nov.2015 | First draft 
     Test Class : Test_ExtCreateCallPlan_KOR_SOLTA
*    
*/
public with sharing class ExtCreateCallPlan_KOR_SOLTA
{

    public Call_Plan__c objCallPlan {get; set;}
    public String strOwner {get; set;}
    public String strWeekIndex {get; set;}
    public Boolean blnIsUpdate {get; set;}
    public Boolean blnHasDetails {get; set;}
  
    public String strCallId;
    public List<ClsSingleMultiUtility.WeekDetails> list_weeks = new List<ClsSingleMultiUtility.WeekDetails>();
    public List<Date> list_startDates = new List<Date>();
    public List<Date> list_endDates = new List<Date>();
    public Boolean blnIsEditable{get; set;}
    public Boolean blnIsManager {get; set;}
    public Boolean blnIsStatusSubmitted {get; set;}
    public Map<Integer,String> map_monthNumAndmonth = new Map<Integer, String>();
    
    public ExtCreateCallPlan_KOR_SOLTA(ApexPages.StandardController controller) 
    {
        strCallId = Apexpages.currentPage().getParameters().get('Id'); 
        blnIsUpdate = true;
        blnHasDetails = false;
        blnIsManager = false;
        blnIsStatusSubmitted = false;
               
        if((strCallId == null || strCallId == ''))
        {
            objCallPlan = new Call_Plan__c(Status__c = 'Draft');            
            blnIsUpdate = false;
            
            // set the owner
            strOwner = UserInfo.getName(); 
            
            // get weeks in different format based on the roles
            list_weeks = ClsSingleMultiUtility.getWeekInDifferentFormat(Datetime.now(), ClsSingleMultiUtility.getWeekFormat(UserInfo.getUserRoleId()));
           // iterate weeks
            for(Integer i = 0; i< list_weeks.size() ; i++)
            {
                ClsSingleMultiUtility.WeekDetails objWeek = list_weeks[i];
                
                list_startDates.add(objWeek.startDate);
                list_endDates.add(objWeek.endDate);
            }
            system.debug('list_startDates>>>>'+list_startDates);
            system.debug('list_endDates>>>>'+list_endDates);
                
        }
        else
        { 
            blnIsUpdate = true;
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
                                                    (SELECT Id FROM Call_Plan_Detail__r LIMIT 1)
                                                FROM Call_Plan__c  
                                                WHERE Id = :strCallId LIMIT 1];
                                                
            system.debug('strCallId>>>'+strCallId);
            system.debug('list_CallPlans>>>'+list_CallPlans);
            if(list_CallPlans.size() > 0)
            {
                objCallPlan = list_CallPlans[0];
                
                if(objCallPlan.Call_Plan_Detail__r.size() > 0)
                    blnHasDetails = true;
                    
                strOwner = list_CallPlans[0].Owner.Name;
                
                // get week in different format based on the role settings
                list_weeks = ClsSingleMultiUtility.getWeekInDifferentFormat(objCallPlan.Createddate, ClsSingleMultiUtility.getWeekFormat(UserInfo.getUserRoleId()));  
               // list_weeks = ClsSingleMultiUtility.getWeekInDifferentFormat(objCallPlan.Createddate);
                system.debug('list_weeks >>>>'+list_weeks );
                
                // iterate weeks
                for(Integer i = 0; i< list_weeks.size() ; i++)
                {
                    ClsSingleMultiUtility.WeekDetails objWeek = list_weeks[i];
                    if(objWeek.startDate == list_CallPlans[0].Start_Date__c && objWeek.endDate == list_CallPlans[0].End_Date__c)
                    {
                        strWeekIndex = String.valueOf(i);
                        System.Debug('<<<<<< i = ' + i);
                        break;
                    }
                    
                    list_startDates.add(objWeek.startDate);
                    list_endDates.add(objWeek.endDate);
                }
                system.debug('list_startDates>>>>'+list_startDates);
                system.debug('list_endDates>>>>'+list_endDates);

            }
        } 
          if(objCallPlan.Status__c == 'Submitted' || objCallPlan.Status__c == 'Approved' || objCallPlan.Status__c == 'Rejected')
        
          blnIsEditable = false;
        else
          blnIsEditable = true;
        
        system.debug('userInfo.getProfileId()>>>'+userInfo.getProfileId());  
        Profile thisProfile = [select Id,Name from Profile where Id =: userInfo.getProfileId() LIMIT 1];
    
        if(thisProfile !=NULL)
        {
          if(thisProfile.Name.contains(Label.manager_label))
              blnIsManager = true;
        }
        else
          blnIsManager = false;
      
        if(objCallPlan.Status__c == 'Submitted')
            blnIsStatusSubmitted = true;
        else
            blnIsStatusSubmitted = false;
          
        system.debug('blnIsEditable >>>>'+blnIsEditable );
        system.debug('blnIsManager >>>>'+blnIsManager );
        
        map_monthNumAndmonth.put(1,'Jan');
        map_monthNumAndmonth.put(2,'Feb');
        map_monthNumAndmonth.put(3,'Mar');
        map_monthNumAndmonth.put(4,'Apr');
        map_monthNumAndmonth.put(5,'May');
        map_monthNumAndmonth.put(6,'Jun');
        map_monthNumAndmonth.put(7,'Jul');
        map_monthNumAndmonth.put(8,'Aug');
        map_monthNumAndmonth.put(9,'Sep');
        map_monthNumAndmonth.put(10,'Oct');
        map_monthNumAndmonth.put(11,'Nov');
        map_monthNumAndmonth.put(12,'Dec');
    }
    
    public PageReference saveAndSchedule()
    {
        //save();
        //return (schedule());
        PageReference pageRefSave = save();
        PageReference pageRef = null;
        if(pageRefSave == null)
            pageRef = null;
        else
            pageRef = schedule();
        return pageRef;
    }
    public PageReference schedule()
    {
        try{
        upsert objCallPlan;
        update objCallPlan;
        }
        catch(DMLException ex)
        {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,ex.getDMLMessage(0));
            ApexPages.addMessage(myMsg);
            return NULL;
        }
        PageReference pagRef;

        pagRef = new PageReference('/apex/CallPlan_KOR_SOLTA?id=' + objCallPlan.Id);
        return pagRef;
    }
    
    public SelectOption[] getAllWeeks()
    {
        List<SelectOption> list_options = new List<SelectOption>();
        list_options.add(new SelectOption('','--None--'));  
        
        for(Integer i=0; i < list_weeks.size(); i++)
            list_options.add(new SelectOption(String.valueOf(i), list_weeks[i].weekLabel));  
         
        return list_options;
    }
    
    public PageReference save()
    {
        String strRetURL = '/' + Call_Plan__c.SObjectType.getDescribe().getKeyPrefix() + '/o';
        //String strRetURL = '/' + strCallId;
        PageReference pagRef = null;
        if(saveCallPlan())
            pagRef = new PageReference(strRetURL);
        else
            pagRef = null;
        return pagRef;
    }
    
    public Boolean saveCallPlan()
    {    
        Boolean blnIsSaved = false;
        Boolean blnIsNoErrorDisplayed = true;
        List<Call_Plan__c> list_callPlanExisting = new List<Call_Plan__c>();
        list_callPlanExisting = [Select Id,
                                        Name,
                                        Manager_Comments__c,
                                        Executive_Comments__c,
                                        Status__c,
                                        Month__c,
                                        Year__c,
                                        Start_Date__c,
                                        End_Date__c,
                                        (Select Id From Call_Plan_Detail__r LIMIT 1)  
                                  From Call_Plan__c 
                                  Where Start_Date__c in : list_startDates And End_Date__c in : list_endDates];                                   
                                       
        system.debug('list_callPlanExisting>>>>'+list_callPlanExisting);
        system.debug('list_startDates>>>>'+list_startDates);
        system.debug('list_endDates>>>>'+list_endDates);
        
        
        if((strWeekIndex == null || strWeekIndex == ''))
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,Label.KOR_SOLTA_Select_Week));             
            blnIsNoErrorDisplayed = false;
        }
        else
        {
            try
            {
                // set the start date and end date
                Integer intIndex = Integer.valueOf(strWeekIndex);
                objCallPlan.Start_Date__c=  list_weeks[intIndex].startDate;
                objCallPlan.End_Date__c=  list_weeks[intIndex].endDate;                    
                System.debug('@@@@@@@@@@@@ : ' + objCallPlan.Start_Date__c+ ' **** ' + objCallPlan.End_Date__c);

                //Setting the Year and Month fields in call plan 
                objCallPlan.Month__c = map_monthNumAndmonth.get((objCallPlan.Start_Date__c).month());
                objCallPlan.Year__c = String.valueOf((objCallPlan.Start_Date__c).year());
                //added by cvsr
                system.debug('@@@@@@@@@@@@@@@@@month from start date-------->'+objCallPlan.Month__c);
                system.debug('@@@@@@@@@@@@@@@@year from start date--------->'+objCallPlan.Year__c);
                // insert/update Call Plan
                upsert objCallPlan;
  
                blnIsSaved = true;
              
            }
            catch(DmlException ex)
            {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,ex.getDmlMessage(0)));
            }     
        }
        return blnIsSaved;
    }
      
    public PageReference cancel()
    {
        String strRetURL = '/' + Call_Plan__c.SObjectType.getDescribe().getKeyPrefix() + '/o';
        return (new PageReference(strRetURL));
    }    
    
    public PageReference redirectFromNewPage()
    {        
       Boolean blnIsWeeklyPlan = false;
        UserRole objCurrentRole;
        
        //Find the Record type of user start
        String strRecTypeId = ApexPages.currentPage().getParameters().get('RecordType');
        system.debug('@@@@@@@@@@@@@@@@@RECORD TYPE OF USER--------->'+strRecTypeId );
        //Taking the profile names for weekly call plan from the custom setting
        Map<String,Weekly_Call_Plan_Profiles__c> map_ProfileNameFromCustSetting = new Map<String,Weekly_Call_Plan_Profiles__c>();
        
        Map<String,Weekly_Call_Plan_Profiles__c> map_ProfileNames = new Map<String,Weekly_Call_Plan_Profiles__c>();
        
        map_ProfileNameFromCustSetting = Weekly_Call_Plan_Profiles__c.getAll();
        system.debug('map_ProfileNameFromCustSetting>>>'+map_ProfileNameFromCustSetting);
        
        for(Weekly_Call_Plan_Profiles__c objTemp : map_ProfileNameFromCustSetting.values())
        {
            //set_ProfileNames.add(objTemp.Profile_Name__c);
            map_ProfileNames.put(objTemp.Profile_Name__c, objTemp);
        }
        if(UserInfo.getUserRoleId() == null)
            blnIsWeeklyPlan = false; 
        else    
            //Profile objCurrentProfile = [SELECT Id, Name FROM Profile WHERE Id = : userInfo.getProfileId() LIMIT 1];
            objCurrentRole = [SELECT Id, Name FROM UserRole WHERE Id =: UserInfo.getUserRoleId() LIMIT 1];
            
        if(objCurrentRole != null)
        {
            Set<String> set_ProfileNames = map_ProfileNames.keySet();
            //for(String strTempProfName : set_ProfileNames)
            for(String key : set_ProfileNames)
            {
                Weekly_Call_Plan_Profiles__c objWkCpProfs = map_ProfileNames.get(key);
               
               if(objCurrentRole.Name != null && objCurrentRole.Name.startsWith(objWkCpProfs.Profile_Name__c) && (objWkCpProfs.Region__c == 'Korea'))
                 
                    blnIsWeeklyPlan = true;
           }
       } 
        
       if(!blnIsWeeklyPlan)
        {
            String strObjCode = Call_Plan__c.SObjectType.getDescribe().getKeyPrefix();
          
            if(strCallId!=NULL && strCallId!='')
                return (new PageReference('/' + strObjCode + '/e?id=' + strCallId +'&nooverride=1&retURL=/' + strObjCode + '/o'));
               
                
            else
            //This pagereference rediredt to standard page
             //  return (new PageReference('/' + strObjCode + '/e?nooverride=1&retURL=/' + strObjCode + '/o'));
         //Based on Role user is not a KOREA then its redirect to this pagereference VF PAGE:ExtCreateCallPlan_SingleWeek
     return (new PageReference('/apex/ExtCreateCallPlan_SingleWeek'));    
         
              // return pf;
        } 
        return null;
    }
   
}