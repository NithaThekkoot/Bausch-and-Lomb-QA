/**
* 
*   This class is used as the extension for the page which overrides standard edit and detail page for Call Plan
*
*    Author           |Author-Email                              |Date       |Comment
*    -----------------|------------------------------------------|-----------|---------------------------------
*    Sourav Mitra     |sourav.mitra@listertechnologies.com       |11.10.2010 |First draft
*    Santosh Kumar S  |santosh.sriram@listertechnologies.com     |26.11.2010 |Logic : The VF page will override for all Users except INDSU.
*    Santosh Kumar S  |santosh.sriram@listertechnologies.com     |27.01.2011 |Logic to include Manager Call plan creation for all roll outs except China
*    Santosh Kumar S  |santosh.sriram@listertechnologies.com     |14.02.2011 |Changes to fix errors fixed during internal testing
*    Sanjib Mahanta   |sanjib.mahanta@bausch.com                 |29.09.2011  |Updated the class for overriding India User.
*    Raviteja Vakity  |raviteja.vakity@bausch.com                |19.11.2013 | Checked User's Role to hide excecutive/manager comments for India User
*/
public with sharing class ExtCreateCallPlan 
{

    public Call_Plan__c objCallPlan {get; set;}
    public String strOwner {get; set;}
    public String strWeekIndex {get; set;}
    public Boolean blnIsUpdate {get; set;}
    public Boolean blnHasDetails {get; set;}
    //added to check if the Users is India Sales Rep or Manager - to hide excecutive/manager comments 
    public Boolean blnCheckRole{get; set;}
    
    public String strCallId;
    public List<ClsSingleMultiUtility.WeekDetails> list_weeks = new List<ClsSingleMultiUtility.WeekDetails>();
    public List<Date> list_startDates = new List<Date>();
    public List<Date> list_endDates = new List<Date>();
    public Boolean blnIsEditable{get; set;}
    public Boolean blnIsManager {get; set;}
    public Boolean blnIsStatusSubmitted {get; set;}
    public Boolean blnIsChinaManager;
    
    public ExtCreateCallPlan(ApexPages.StandardController controller) 
    {
        strCallId = Apexpages.currentPage().getParameters().get('Id'); 
        blnIsUpdate = true;
        blnHasDetails = false;
        blnIsManager = false;
        blnIsStatusSubmitted = false;
        blnIsChinaManager =false;
        //added to check if the Users is India Sales Rep or Manager
        blnCheckRole = true;
        list<UserRole> lstRoleName = [SELECT Name FROM UserRole WHERE Id = :UserInfo.getUserRoleId()];
        //condition added by Neha Jain on 14th Feb, 2014 for Thailand
        if(lstRoleName[0].Name.contains('INDSU') || lstRoleName[0].Name.contains('INDAES') || lstRoleName[0].Name.contains('THASU')){
             blnCheckRole = false;
        }
              
        if((strCallId == null || strCallId == ''))
        {
            objCallPlan = new Call_Plan__c(Status__c = 'Draft');            
            blnIsUpdate = false;
            strOwner = UserInfo.getName(); // set owner
            
            List<RecordType> list_rt = [SELECT Id FROM RecordType WHERE SObjectType = 'Call_Plan__c' AND Name = 'APACSU Call Plan'];
            if(list_rt.size() > 0)
                objCallPlan.RecordTypeId = list_rt[0].Id;
           
            //condition added by Neha Jain on 17th Feb, 2014 for Thailand    
            //For adding current week
           if(lstRoleName[0].Name.contains('INDSU') || lstRoleName[0].Name.contains('INDAES') || lstRoleName[0].Name.contains('THASU'))
          {             
                    list_weeks = ClsSingleMultiUtility.getWeek(Datetime.now().addDays(-7));  // get list with current weeks    
          }
          else
          {                    
                list_weeks = ClsSingleMultiUtility.getWeek(Datetime.now());  // get weeks
          }
           //list_weeks = ClsSingleMultiUtility.getWeek(Datetime.now());  // get weeks
            
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
            Call_Plan__c[] list_CallPlans = [SELECT Id, Name, 
                                                    Status__c, End_Date__c, 
                                                    Start_Date__c, Owner.Name, 
                                                    OwnerId, 
                                                    Createddate,RecordType.Name,
                                                    Manager_Comments__c,Executive_Comments__c,
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
                System.debug('Who is the owner of this cal plan >>>'+ strOwner );
                System.debug('Who is the present user?'+UserInfo.getName());
                list_weeks = ClsSingleMultiUtility.getWeek(objCallPlan.Createddate);  // get weeks
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
          
        Profile thisProfile = [select Id,Name from Profile where Id =: userInfo.getProfileId()];
    
        if(thisProfile!=NULL && thisProfile.Name.contains(Label.manager_label) &&  strOwner != UserInfo.getName())
          blnIsManager = true;
        else
          blnIsManager = false;
          
         if(thisProfile!=NULL && thisProfile.Name.contains(Label.APACSU_China_Sales_Manager))
         {
            blnIsChinaManager = true;
         }
      
        if(objCallPlan.Status__c == 'Submitted')
            blnIsStatusSubmitted = true;
        else
            blnIsStatusSubmitted = false;
          
        //system.debug('blnIsEditable >>>>'+blnIsEditable );
        
        if(     objCallPlan.Status__c == 'Approved' || 
                objCallPlan.Status__c == 'Rejected' || 
                (objCallPlan.Status__c == 'Draft' && strOwner != UserInfo.getName()) ||
                (objCallPlan.Status__c =='Submitted' &&  strOwner == UserInfo.getName())
                    )
          blnIsEditable = false;
        else
          blnIsEditable = true;
          
          system.debug('The owner of the call plan is >>'+strOwner );
          system.debug('The present user is >>'+UserInfo.getName());
          system.debug('objCallPlan.ownerId+++++++'+objCallPlan.ownerId );
        system.debug('thisProfile.Name.contains(Label.manager_label)  >>>>'+thisProfile.Name.contains(Label.manager_label)  );
        system.debug('blnIsEditable======='+blnIsEditable );
        system.debug('blnIsManager @@@@@ '+blnIsManager );
        
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

        pagRef = new PageReference('/apex/CtrlCallPlanningChinaSU_CallPlan?id=' + objCallPlan.Id);

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
        list_callPlanExisting = [Select Id,Name,Start_Date__c,End_Date__c,Manager_Comments__c,Executive_Comments__c,(Select Id From Call_Plan_Detail__r LIMIT 1)  
                                  From Call_Plan__c 
                                  Where Start_Date__c in : list_startDates And End_Date__c in : list_endDates];                                   
                                       
        system.debug('list_callPlanExisting>>>>'+list_callPlanExisting);
//        system.debug('list_callPlanExisting size>>>>'+list_callPlanExisting[0].call_Plan_Detail__r.size());
        system.debug('list_startDates>>>>'+list_startDates);
        system.debug('list_endDates>>>>'+list_endDates);
        
        
        
        /*if(list_callPlanExisting.size() > 0 && blnIsNoErrorDisplayed)
        {            
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Call plan exists for the selected week'));             
            blnIsNoErrorDisplayed = false;
            blnIsSaved =  false;
        }*/
        
        if((strWeekIndex == null || strWeekIndex == ''))
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,Label.Week_Empty_Error));             
            blnIsNoErrorDisplayed = false;
        }
        else
        {
            try
            {
                // set the start date and end date
                Integer intIndex = Integer.valueOf(strWeekIndex);
                objCallPlan.Start_Date__c =  list_weeks[intIndex].startDate;
                objCallPlan.End_Date__c =  list_weeks[intIndex].endDate;                    
                System.debug('@@@@@@@@@@@@ : ' + objCallPlan.Start_Date__c + ' **** ' + objCallPlan.End_Date__c);

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
        String strRecTypeId = ApexPages.currentPage().getParameters().get('RecordType');
        list<UserRole> lstRoleName = [SELECT Name FROM UserRole WHERE Id = :UserInfo.getUserRoleId()];
        if(strRecTypeId != null && strRecTypeId != '')
        {
            List<RecordType> list_objRTs = [SELECT Name FROM RecordType WHERE Id = :strRecTypeId AND SObjectType = 'Call_Plan__c'];
            if(list_objRTs.size() > 0)
            {
                if(!list_objRTs[0].Name.startsWith('APACSU'))
                {
                    String strObjCode = Call_Plan__c.SObjectType.getDescribe().getKeyPrefix();
                    return (new PageReference('/' + strObjCode + '/e?nooverride=1&retURL=/' + strObjCode + '/o'));
                }
            }
        }
        //The overriding should happen for all users except INDSU users
       /* else if((lstRoleName.get(0).Name.startsWith('IND')))
        {
            String strObjCode = Call_Plan__c.SObjectType.getDescribe().getKeyPrefix();
            return (new PageReference('/' + strObjCode + '/e?nooverride=1&retURL=/' + strObjCode + '/o'));
        }
        */
        if(objCallPlan.Id != null)
        {
             if(!objCallPlan.RecordType.Name.startsWith('APACSU'))
             {
                String strRetURL = ApexPages.currentPage().getParameters().get('retURL');
                return (new PageReference('/' + objCallPlan.Id + '/e?nooverride=1&retURL=' + strRetURL));
             }
        }
        if(blnIsChinaManager)
        {
            return (new PageReference('/' + objCallPlan.Id));
        }
        return null;
    }
   
}