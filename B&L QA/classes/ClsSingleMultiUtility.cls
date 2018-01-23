/**
* 
*   Also contains methods for Call Planning.
*
*    Author           |Author-Email                              |Date       |Comment
*    -----------------|------------------------------------------|-----------|---------------------------------
*    Sourav Mitra     |sourav.mitra@listertechnologies.com       |11.10.2010 |First draft
*    Raviteja Vakity  |raviteja.vakity@bausch.com                |29.Nov.2012|Populating the strEnd based on dtEnd
*   Venkateswara Reddy.C|venkateswara.reddy2@bausch.com          |2.Nov.2015|Added code for KOR SOLTA Users.
*    Test Class : Test_ClsSingleMultiUtility
*/
public Class ClsSingleMultiUtility{
  
  /*************************************************************************
    **  Define variables and properties
    *************************************************************************/
    
    /*Static Boolean to control Single call plan update validations on the call plan update(callPlan_BIU_validateCallPlanWeek) 
      originating from Approve() in ctrlProductObjective*/
      
    public static Boolean blnIsUpdateFromApproveReject {get; set;}
  
    public static final String CALL_TYPE_SINGLE = 's'; 
    public static final String CALL_TYPE_MULTIPLE = 'm'; 
    public static final String ACTIVE_CUSTOM_SETTING = 'Current'; 

    public static Set<Id> listofParent = new Set<Id>();
    public static Map<Id,Set<ID>> mapParentRolewithChild = new Map<Id,Set<ID>>();
    public static List<Call_Plan_Detail__c> list_callPlanDetail = new List<Call_Plan_Detail__c>();
    public static Map<Id,List<Contact_Profile__c>> map_accIdAndConProfile = new Map<Id,List<Contact_Profile__c>>();
    public static Map<String,List<Contact_Profile__c>> map_accNameAndConProfile = new Map<String,List<Contact_Profile__c>>();
    
    public static Set<String> set_PhysicianId = new Set<String>();
    public static Map<Integer,String> map_MonthNo_MonthName = new Map<Integer,String>();
    public static Map<String,Integer> map_conId_MTDCalls = new Map<String,Integer>();
    
    public static Set<String> set_sections = new Set<String>();
    
    static 
    {
        blnIsUpdateFromApproveReject = false;
        
        map_MonthNo_MonthName.put(1,'Jan');
        map_MonthNo_MonthName.put(2,'Feb');
        map_MonthNo_MonthName.put(3,'Mar');
        map_MonthNo_MonthName.put(4,'Apr');
        map_MonthNo_MonthName.put(5,'May');
        map_MonthNo_MonthName.put(6,'Jun');
        map_MonthNo_MonthName.put(7,'Jul');
        map_MonthNo_MonthName.put(8,'Aug');
        map_MonthNo_MonthName.put(9,'Sep');
        map_MonthNo_MonthName.put(10,'Oct');
        map_MonthNo_MonthName.put(11,'Nov');
        map_MonthNo_MonthName.put(12,'Dec');
    }
    public class ContactDetails {
    public Contact objContact {get; set;} 
    public Contact_Profile__c objContProfile {get; set;} 

    public ContactDetails(){
      objContact = new Contact();
      objContProfile = new Contact_Profile__c();
    }
    }

    public class WeekDetails 
    {
        public Date startDate{get;set;}
        public Date endDate{get;set;}
        public String weekLabel{get;set;}

        public WeekDetails()
        {
            startDate = system.today();
            endDate = system.today().addDays(7);
            weekLabel = '';
        }   
    }

  
  
  /*************************************************************************
    **  get parent role ids for a given user role
    *************************************************************************/
  
  public static Set<Id> getParents(Id roleId){
    
        listofParent = new Set<Id>();
        mapParentRolewithChild = new Map<Id,Set<ID>>();
        
        for(UserRole ur : [  SELECT 
                    Id,name,parentroleId 
                FROM userrole ])   {
            if(ur.parentRoleId != null){
                if(!mapParentRolewithChild.containsKey(ur.Id)) {
                    mapParentRolewithChild.put(ur.Id,new Set<Id>{ur.parentRoleId});
                }
                else {
                    mapParentRolewithChild.get(ur.Id).add(ur.parentRoleId);
                }
            }
        }
        system.debug('>>>>2' + mapParentRolewithChild);
        Set<Id> prnt = new Set<Id>();
        prnt.add(roleId);
        
        system.debug('!!!!!2' + listofParent);    
        
        return getParentRoles(prnt);
    }
    
    /*************************************************************************
    **  method to get the parent role ids based on list of child ids 
    **  (used internally)
    *************************************************************************/
    public static Set<Id> getParentRoles(Set<Id> childList)  {
        for(Id childId : childList)  {
            if(mapParentRolewithChild.containsKey(childId)) {
                listofParent.addAll(mapParentRolewithChild.get(childId));
                system.debug('!!!!!1' + listofParent);
                getParentRoles(mapParentRolewithChild.get(childId));
            }
        }        
        return listofParent;
    }
    
     /*******************************************************************************************
    **  method to return the week based on the custom setting for number of weeks for CALL PLAN
    *******************************************************************************************/
    public static List<WeekDetails> getWeek(Datetime dtmParameter)
    {
        List<WeekDetails> list_weekDetailsToReturn = new List<WeekDetails>();
        Integer intNumberOfWeeks = CHNSU_Call_Plan__c.getValues(ACTIVE_CUSTOM_SETTING).CallPlanWeeks__c.intValue();
        String str_MonthStart = '';
        String str_MonthEnd = '';
        String str_weekStart = '';
        String str_weekEnd = '';
        Date dt_weekStart;
        Date dt_weekEnd;       
        
        system.debug('Datetime.now().format>>>>'+Datetime.now().format('EEE'));
        
        if(dtmParameter.format('EEE')=='Mon')
        {
            dt_weekStart = dtmParameter.date().addDays(7);
            dt_weekEnd = dt_weekStart.addDays(6);
        }
        else if(dtmParameter.format('EEE')=='Tue')
        {
            dt_weekStart = dtmParameter.date().addDays(6);
            dt_weekEnd = dt_weekStart.addDays(6);
        }
        else if(dtmParameter.format('EEE')=='Wed')
        {
            dt_weekStart = dtmParameter.date().addDays(5);
            dt_weekEnd = dt_weekStart.addDays(6);
        }
        else if(dtmParameter.format('EEE')=='Thu')
        {
            dt_weekStart = dtmParameter.date().addDays(4);
            dt_weekEnd = dt_weekStart.addDays(6);
        }
        else if(dtmParameter.format('EEE')=='Fri')
        {
            dt_weekStart = dtmParameter.date().addDays(3);
            dt_weekEnd = dt_weekStart.addDays(6);
        }
        else if(dtmParameter.format('EEE')=='Sat')
        {
            dt_weekStart = dtmParameter.date().addDays(2);
            dt_weekEnd = dt_weekStart.addDays(6);
        }       
        else
        {
            system.debug('ELSE>>>');
            dt_weekStart = dtmParameter.date().addDays(1);
            dt_weekEnd = dt_weekStart.addDays(6);
        }
        
        str_MonthStart = map_MonthNo_MonthName.get(dt_weekStart.Month());
        str_weekStart = dt_weekStart.day()+' '+str_MonthStart;
        
        system.debug('dt_weekEnd>>>>'+dt_weekEnd);        
        str_MonthEnd = map_MonthNo_MonthName.get(dt_weekEnd.Month());
        str_weekEnd = dt_weekEnd.day()+' '+str_MonthEnd;
        system.debug('str_weekEnd>>>>'+str_weekEnd);
        
        for(Integer i = 0;i< intNumberOfWeeks;i++)
        {
            WeekDetails objWeekDetails = new WeekDetails();
            if(i==0)
            {
                objWeekDetails.startDate = dt_weekStart;
                objWeekDetails.endDate = dt_weekEnd;
                objWeekDetails.weekLabel = Label.week_label + '('+str_weekStart+ ' ' + String.valueOf(dt_weekStart.year()) + ' - ' + str_weekEnd + + ' ' + String.valueOf(dt_weekEnd.year()) + ')';
                
                list_weekDetailsToReturn.add(objWeekDetails);
            }
            else
            {
                dt_weekStart = dt_weekEnd+1;
                dt_weekEnd = dt_weekStart.adddays(6);
                
                str_MonthStart = map_MonthNo_MonthName.get(dt_weekStart.Month());
                str_weekStart = dt_weekStart.day()+' '+str_MonthStart;                
                system.debug('dt_weekStart>>>>'+dt_weekStart);        
                
                str_MonthEnd = map_MonthNo_MonthName.get(dt_weekEnd.Month());
                str_weekEnd = dt_weekEnd.day()+' '+str_MonthEnd;
                system.debug('str_weekEnd>>>>'+str_weekEnd);
                
                objWeekDetails.startDate = dt_weekStart;
                objWeekDetails.endDate = dt_weekEnd;
                objWeekDetails.weekLabel = Label.week_label + '('+str_weekStart+ ' ' + String.valueOf(dt_weekStart.year()) + ' - ' + str_weekEnd + + ' ' + String.valueOf(dt_weekEnd.year()) + ')';
                
                list_weekDetailsToReturn.add(objWeekDetails);
            }
        }
        system.debug('list_weekDetailsToReturn>>>>'+list_weekDetailsToReturn);
        return list_weekDetailsToReturn;
    }
    
     /*************************************************************************
    **  method to display the date in format:16-Aug to 22-Aug for CALL PLAN
    *************************************************************************/
    public static String getDisplayWeek(Date dtStart, Date dtEnd)
    {
        String strWeekToDisplay = '';
        String strStart = '';
        String strEnd = '';
        strStart = dtStart.day()+'-'+map_MonthNo_MonthName.get(dtStart.month()) + ' ' + dtStart.year() + ' ' + Label.to_label + ' ';
       // strEnd = dtEnd.day()+'-'+map_MonthNo_MonthName.get(dtStart.month()) + ' ' + dtEnd.year(); //commented by Raviteja 
        strEnd = dtEnd.day()+'-'+map_MonthNo_MonthName.get(dtEnd.month()) + ' ' + dtEnd.year(); // Populating the strEnd based on dtEnd
        strWeekToDisplay = strStart+strEnd;
        system.debug('strWeekToDisplay>>>>>>>'+strWeekToDisplay);
        return strWeekToDisplay;        
    }
    
     /*************************************************************************
    **  method to display the date in format:16-Aug for CALL PLAN
    *************************************************************************/
    public static String getDisplayDate(Date dtInput)
    {
        String strDateToDiaplay = '';
        strDateToDiaplay = dtInput.day()+'-'+map_MonthNo_MonthName.get(dtInput.month());
        system.debug('strDateToDiaplay>>>>>>>'+strDateToDiaplay);
        return strDateToDiaplay;
    }
    
     /*********************************************************************************************
    **  method to return the list of dates in between the given start and end dates for CALL PLAN
    *********************************************************************************************/
    public static List<Date> getListOfDays(Date dtStart, Date dtEnd)
    {
        List<Date> list_daysInWeek = new List<Date>();
        Integer intNumOfDays = dtStart.daysBetween(dtEnd);
        for(Integer i=0;i<=intNumOfDays;i++)
        {
            list_daysInWeek.add(dtStart+i);
        }
        system.debug('list_daysInWeek>>>>'+list_daysInWeek);
        return list_daysInWeek;
    }
    

     /************************************************************************************************************************************
    **  method to return a map of week string and week date(start and end) based on the custom setting for number of weeks for CALL PLAN
    ************************************************************************************************************************************/
    public static Map<String,List<Date>> getWeekStringAndWeekDateMap()
    {
        List<WeekDetails> list_weekDetailsToReturn = new List<WeekDetails>();
        List<Date> list_dates = new List<Date>();
        Map<String,List<Date>> map_WeekStringAndWeekDate = new Map<String,List<Date>>();
        Integer intNumberOfWeeks = CHNSU_Call_Plan__c.getValues(ACTIVE_CUSTOM_SETTING).CallPlanWeeks__c.intValue();
        String str_MonthStart = '';
        String str_MonthEnd = '';
        String str_weekStart = '';
        String str_weekEnd = '';
        Date dt_weekStart;
        Date dt_weekEnd;       
        
        system.debug('Datetime.now().format>>>>'+Datetime.now().format('EEE'));
        
        if(Datetime.now().format('EEE')=='Mon')
        {
            dt_weekStart = Date.Today().addDays(7);
            dt_weekEnd = dt_weekStart.addDays(6);
        }
        else if(Datetime.now().format('EEE')=='Tue')
        {
            dt_weekStart = Date.Today().addDays(6);
            dt_weekEnd = dt_weekStart.addDays(6);
        }
        else if(Datetime.now().format('EEE')=='Wed')
        {
            dt_weekStart = Date.Today().addDays(5);
            dt_weekEnd = dt_weekStart.addDays(6);
        }
        else if(Datetime.now().format('EEE')=='Thu')
        {
            dt_weekStart = Date.Today().addDays(4);
            dt_weekEnd = dt_weekStart.addDays(6);
        }
        else if(Datetime.now().format('EEE')=='Fri')
        {
            dt_weekStart = Date.Today().addDays(3);
            dt_weekEnd = dt_weekStart.addDays(6);
        }
        else if(Datetime.now().format('EEE')=='Sat')
        {
            dt_weekStart = Date.Today().addDays(2);
            dt_weekEnd = dt_weekStart.addDays(6);
        }       
        else
        {
            system.debug('ELSE>>>');
            dt_weekStart = Date.Today().addDays(1);
            dt_weekEnd = dt_weekStart.addDays(6);
        }
        
        str_MonthStart = map_MonthNo_MonthName.get(dt_weekStart.Month());
        str_weekStart = dt_weekStart.day()+' '+str_MonthStart;
        
        system.debug('dt_weekEnd>>>>'+dt_weekEnd);        
        str_MonthEnd = map_MonthNo_MonthName.get(dt_weekEnd.Month());
        str_weekEnd = dt_weekEnd.day()+' '+str_MonthEnd;
        system.debug('str_weekEnd>>>>'+str_weekEnd);
        
        for(Integer i = 0;i<=intNumberOfWeeks;i++)
        {
            WeekDetails objWeekDetails = new WeekDetails();
            if(i==0)
            {
                objWeekDetails.startDate = dt_weekStart;
                objWeekDetails.endDate = dt_weekEnd;
                list_dates.clear();
                list_dates.add(dt_weekStart);
                list_dates.add(dt_weekEnd);
                objWeekDetails.weekLabel = 'Week('+str_weekStart+'-'+str_weekEnd+')';
                
                for(Date dtTemp : list_dates)
                {
                    if(map_WeekStringAndWeekDate.get(objWeekDetails.weekLabel)==NULL)
                            map_WeekStringAndWeekDate.put(objWeekDetails.weekLabel,new List<Date>());
                    map_WeekStringAndWeekDate.get(objWeekDetails.weekLabel).add(dtTemp);
                }
                list_weekDetailsToReturn.add(objWeekDetails);
                
            }
            else
            {
                dt_weekStart = dt_weekEnd+1;
                dt_weekEnd = dt_weekStart.adddays(6);
                
                str_MonthStart = map_MonthNo_MonthName.get(dt_weekStart.Month());
                str_weekStart = dt_weekStart.day()+' '+str_MonthStart;                
                system.debug('dt_weekStart>>>>'+dt_weekStart);        
                
                str_MonthEnd = map_MonthNo_MonthName.get(dt_weekEnd.Month());
                str_weekEnd = dt_weekEnd.day()+' '+str_MonthEnd;
                system.debug('str_weekEnd>>>>'+str_weekEnd);
                
                objWeekDetails.startDate = dt_weekStart;
                objWeekDetails.endDate = dt_weekEnd;
                list_dates.clear();
                list_dates.add(dt_weekStart);
                list_dates.add(dt_weekEnd);
                objWeekDetails.weekLabel = 'Week('+str_weekStart+'-'+str_weekEnd+')';
                
                for(Date dtTemp : list_dates)
                {
                    if(map_WeekStringAndWeekDate.get(objWeekDetails.weekLabel)==NULL)
                            map_WeekStringAndWeekDate.put(objWeekDetails.weekLabel,new List<Date>());
                    map_WeekStringAndWeekDate.get(objWeekDetails.weekLabel).add(dtTemp);
                }
                list_weekDetailsToReturn.add(objWeekDetails);
            }
        }
        system.debug('list_weekDetailsToReturn>>>>'+list_weekDetailsToReturn);
        system.debug('map_WeekStringAndWeekDate>>>>'+map_WeekStringAndWeekDate);
        return map_WeekStringAndWeekDate;
    }
    
      /************************************************************************************************************************************
      ** For KOREA SOLTA --added by VEnkateswara Reddy. Date: 11/2/2015
    **  method to return the week format to be used for the given role
    ************************************************************************************************************************************/
     public static Integer getWeekFormat(Id userRoleId){ //12.Jan.2010
        
        Integer nDisplayFormat = 1;
        //Taking the profile names for weekly call plan from the custom setting
        Map<String,Weekly_Call_Plan_Profiles__c> mapOfRoleNames = new Map<String,Weekly_Call_Plan_Profiles__c>();
        
        if(Weekly_Call_Plan_Profiles__c.getAll() != NULL && UserInfo.getUserRoleId()!=NULL){
            
            mapOfRoleNames = Weekly_Call_Plan_Profiles__c.getAll();
                        
            UserRole objCurrentRole = [SELECT Id, Name FROM UserRole WHERE Id =: userRoleId LIMIT 1];
            
            System.Debug('Week Format Current Role Name: ' + objCurrentRole.Name);
            
            for(String roleName : mapOfRoleNames.keySet())
            {
                System.Debug('Week Format Role Name: ' + roleName);
                String strRoleName = mapOfRoleNames.get(roleName).Profile_Name__c;
                
               if(objCurrentRole.Name != null && strRoleName != NULL && objCurrentRole.Name.startsWith(strRoleName)){        
                    String strWeekFormat = mapOfRoleNames.get(roleName).Week_Format__c;                 
                    System.Debug('Week Format: ' + strWeekFormat);
                    if(strWeekFormat.equalsIgnoreCase('YYYY-MM-DD')){ 
                        nDisplayFormat = 0;
                        break;
                    }
                }
            }
        }
        
        return nDisplayFormat;
    } 
    
   /*******************************************************************************************
    ** For KOREA SALTA ---Added by Venkateswara Reddy Date: 11/2/2015
    **  method to return the week based on the custom setting for number of weeks for CALL PLAN
    *******************************************************************************************/
   public static List<WeekDetails> getWeekInDifferentFormat(Datetime dtmParameter, Integer nWeekFormat)

    {
        System.debug('dtmParameter: ' + dtmParameter);
        List<WeekDetails> list_weekDetailsToReturn = new List<WeekDetails>();
        
        Integer intNumberOfWeeksKor = 0;
        
        //Get the user details
        //User objUser = [SELECT UserRoleId,ProfileId,UserRole.Name,Profile.Name FROM User WHERE Id = :UserInfo.getUserId()];
        User objUser = [SELECT UserRole.Name,Profile.Name FROM User WHERE Id = :UserInfo.getUserId()];
        //System.debug('User Role: ' + String.valueOf(objUser.Profile.Name));
        
        intNumberOfWeeksKor = KOR_SOLTA_Call_Plan__c.getValues(ACTIVE_CUSTOM_SETTING).Call_Plan_Weeks__c.intValue();
        System.debug('intNumberOfWeeks Before: ' + intNumberOfWeeksKor);      
                
        //Show current week if country is Korea
       // if(String.valueOf(objUser.Profile.Name).toLowerCase().contains('kor')){
        if(String.valueOf(objUser.Profile.Name).contains('KOR SOLTA') || String.valueOf(objUser.Profile.Name).contains('BL') ){
            System.debug('~~~~~~~~KOREA USER FOUND~~~~~~~~~~');
            intNumberOfWeeksKor = intNumberOfWeeksKor + 1;
        }
        System.debug('intNumberOfWeeks after: ' + intNumberOfWeeksKor);      
        
        String str_MonthStart = '';
        String str_MonthEnd = '';
        String str_weekStart = '';
        String str_weekEnd = '';
        Date dt_weekStart;
        Date dt_weekEnd;       
        
        system.debug('Datetime.now().format>>>>'+Datetime.now().format('EEE'));
        
        if(dtmParameter.format('EEE')=='Mon')
        {
        
               if(String.valueOf(objUser.Profile.Name).contains('KOR SOLTA')){
                dt_weekStart = dtmParameter.date();//.addDays(-7);
            }
            else{
                dt_weekStart = dtmParameter.date().addDays(7);
            }
            dt_weekEnd = dt_weekStart.addDays(6);
        }
        else if(dtmParameter.format('EEE')=='Tue')
        {
             if(String.valueOf(objUser.Profile.Name).contains('KOR SOLTA')){
                dt_weekStart = dtmParameter.date().addDays(-1);
            }
            else{
                dt_weekStart = dtmParameter.date().addDays(6);
            }
            dt_weekEnd = dt_weekStart.addDays(6);
        }
        else if(dtmParameter.format('EEE')=='Wed')
        {
             if(String.valueOf(objUser.Profile.Name).contains('KOR SOLTA')){
                dt_weekStart = dtmParameter.date().addDays(-2);
            }
            else{
                dt_weekStart = dtmParameter.date().addDays(5);
            }
            dt_weekEnd = dt_weekStart.addDays(6);
        }
        else if(dtmParameter.format('EEE')=='Thu')
        {
              if(String.valueOf(objUser.Profile.Name).contains('KOR SOLTA')){
                dt_weekStart = dtmParameter.date().addDays(-3);
            }
            else{
                dt_weekStart = dtmParameter.date().addDays(4);
            }
            dt_weekEnd = dt_weekStart.addDays(6);
        }
        else if(dtmParameter.format('EEE')=='Fri')
        {
             if(String.valueOf(objUser.Profile.Name).contains('KOR SOLTA')){
                dt_weekStart = dtmParameter.date().addDays(-4);
            }
            else{
                dt_weekStart = dtmParameter.date().addDays(3);
            }
            dt_weekEnd = dt_weekStart.addDays(6);
        }
        else if(dtmParameter.format('EEE')=='Sat')
        {
            if(String.valueOf(objUser.Profile.Name).contains('KOR SOLTA')){
                dt_weekStart = dtmParameter.date().addDays(-5);
            }
            else{
                dt_weekStart = dtmParameter.date().addDays(2);
            }
            dt_weekEnd = dt_weekStart.addDays(6);
        }       
        else
        {
            system.debug('ELSE>>>');
            dt_weekStart = dtmParameter.date().addDays(1);
            dt_weekEnd = dt_weekStart.addDays(6);
        }
        
        if(nWeekFormat==0){ //YYYY-MM-DD
            str_MonthStart  = map_MonthNo_MonthName.get(dt_weekStart.Month());
            str_weekStart   = String.valueOf(dt_weekStart.Month()) + '-' + dt_weekStart.day();        
            str_MonthEnd    = map_MonthNo_MonthName.get(dt_weekEnd.Month());
            str_weekEnd     = String.valueOf(dt_weekEnd.Month()) + '-' + dt_weekEnd.day();
        }
        else{ //DD-Month-YYYY
            str_MonthStart  = map_MonthNo_MonthName.get(dt_weekStart.Month());
            str_weekStart   = dt_weekStart.day()+' '+str_MonthStart;
            str_MonthEnd    = map_MonthNo_MonthName.get(dt_weekEnd.Month());
            str_weekEnd     = dt_weekEnd.day()+' '+str_MonthEnd;        
        }
        
        for(Integer i = 0;i< intNumberOfWeeksKor;i++)
        {
            WeekDetails objWeekDetails = new WeekDetails();
            if(i==0)
            {
                objWeekDetails.startDate = dt_weekStart;
                objWeekDetails.endDate = dt_weekEnd;
                if(nWeekFormat==0)  //YYYY-MM-DD
                    objWeekDetails.weekLabel = Label.week_label + '('+String.valueOf(dt_weekStart.year()) + '-' + str_weekStart + ' ' + Label.to_label + ' ' + String.valueOf(dt_weekEnd.year()) + '-' + str_weekEnd + ')';
                else    //DD-Month-YYYY
                    objWeekDetails.weekLabel = Label.week_label + '('+str_weekStart+ ' ' + String.valueOf(dt_weekStart.year()) + ' - ' + str_weekEnd + + ' ' + String.valueOf(dt_weekEnd.year()) + ')';
                
                list_weekDetailsToReturn.add(objWeekDetails);
            }
            else
            {
                dt_weekStart = dt_weekEnd+1;
                dt_weekEnd = dt_weekStart.adddays(6);
                
                if(nWeekFormat==0){//YYYY-MM-DD
                    str_MonthStart = map_MonthNo_MonthName.get(dt_weekStart.Month());
                    str_weekStart = String.valueOf(dt_weekStart.Month()) + '-' + dt_weekStart.day();
                    str_MonthEnd = map_MonthNo_MonthName.get(dt_weekEnd.Month());
                    str_weekEnd = String.valueOf(dt_weekEnd.Month()) + '-' + dt_weekEnd.day();
                }
                else{//DD-Month-YYYY
                    str_MonthStart = map_MonthNo_MonthName.get(dt_weekStart.Month());
                    str_weekStart = dt_weekStart.day()+' '+str_MonthStart;                
                    str_MonthEnd = map_MonthNo_MonthName.get(dt_weekEnd.Month());
                    str_weekEnd = dt_weekEnd.day()+' '+str_MonthEnd;
                }
                
                objWeekDetails.startDate= dt_weekStart;
                objWeekDetails.endDate  = dt_weekEnd;
                
                if(nWeekFormat==0)
                    objWeekDetails.weekLabel= Label.week_label + '('+String.valueOf(dt_weekStart.year()) + '-' + str_weekStart + ' ' + Label.to_label + ' ' + String.valueOf(dt_weekEnd.year()) + '-' + str_weekEnd + ')';
                else
                    objWeekDetails.weekLabel = Label.week_label + '('+str_weekStart+ ' ' + String.valueOf(dt_weekStart.year()) + ' - ' + str_weekEnd + + ' ' + String.valueOf(dt_weekEnd.year()) + ')';
                
                list_weekDetailsToReturn.add(objWeekDetails);
            }
        }
        system.debug('list_weekDetailsToReturn>>>>'+list_weekDetailsToReturn);
        return list_weekDetailsToReturn;
    }  
    
    
    /*************************************************************************
    ** For KOREA SOLTA---- Added by venkateswara reddy: Date:2015-11-4
    **  method to display the date in format:YYYY-MM-DD to YYYY-MM-DD for CALL PLAN
    *************************************************************************/
    public static String getDisplayWeekInDifferentFormat(Date dtStart, Date dtEnd, Integer styleType){
        
        String strWeekToDisplay = '';
        String strStart = '';
        String strEnd = '';
        //strStart = dtStart.day()+'-'+map_MonthNo_MonthName.get(dtStart.month()) + ' ' + dtStart.year() + ' ' + Label.to_label + ' ';
        if(styleType==0){
            strStart = dtStart.year() + '-' + dtStart.month() + '-' + dtStart.day() + ' ' + Label.to_label + ' ';
            strEnd = dtEnd.year() + '-' + dtEnd.month() + '-' + dtEnd.day();
            strWeekToDisplay = strStart+strEnd;
        }
        else{
            strStart = dtStart.day()+'-'+map_MonthNo_MonthName.get(dtStart.month()) + ' ' + dtStart.year() + ' ' + Label.to_label + ' ';
            strEnd = dtEnd.day()+'-'+map_MonthNo_MonthName.get(dtEnd.month()) + ' ' + dtEnd.year();
            strWeekToDisplay = strStart+strEnd;
        }
        system.debug('strWeekToDisplay>>>>>>>'+strWeekToDisplay);
        return strWeekToDisplay;        
    }
    
}