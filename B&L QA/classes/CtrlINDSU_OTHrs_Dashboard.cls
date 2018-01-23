/*
* Class for Create Dashboard Chart for National OT Hrs
* Author                        |Author-Email                                      |Date        |Comment
* ------------------------------|------------------------------------------------- |------------|----------------------------------------------------
* Tarun Solanki                |Tarun.Solanki@bausch.com     |27.03.2014  |First Draft
* test class-Test_CtrlINDSU_OTHrs_Dashboard
*/


public class CtrlINDSU_OTHrs_Dashboard{

      Public List<Data> data {get;set;}
      Public List<AvgCallsData> lstAvgCallsData {get;set;}
      Public List<avgNatCalls> lstAvgNatCalls {get;set;} 
      Public List<Data1> lstAvgOTHours {get;set;}

    Public CtrlINDSU_OTHrs_Dashboard()
    {
      getChartData();
      getAvgCallsChartData();
      avgNatCallsChart();
      getAvgNatOthours();
    }
     //Average National OT Hours
    public void getAvgNatOthours() 
    {
        lstAvgOTHours = new List<Data1>();
        date currentDate = Date.today();
        Date datMonthStartDate;
        Date datMonthEndDate;
        
        //datMonthStartDate=System.Today().addDays(-1000);
        //datMonthEndDate=System.Today().addDays(26);
         datMonthStartDate=date.newInstance(currentDate.year(), currentDate.month(), 1);
         datMonthEndDate=datMonthStartDate.addMonths(1) - 1;
            
        decimal totalHrs=0;
        decimal ttlusers=0; 
         
        LIST<AggregateResult> lstTtlHrs= [SELECT SUM(Time_Spent_In_OT__c) Days
                                                      FROM Physician_Visit__c 
                                                      WHERE Activity_Date__c >=:datMonthStartDate AND Activity_Date__c <=:datMonthEndDate AND owner.isactive=true
                                                      AND Owner.userrole.name like'%INDSU%'];
                                                      
        system.debug('Check 11 '+lstTtlHrs +' tt '+ lstTtlHrs.size()+' stdate '+ datMonthStartDate + ' enddate '+datMonthEndDate);
        
        LIST<AggregateResult> lstTtlUsers=[Select Count(Id) ttlUser  from user where userrole.name like'%INDSU Sales rep%' and APAC_Region__c !=null and IsActive=true]; 
        
         FOR(AggregateResult MapttlHrs: lstTtlHrs)
            {
              if(double.valueOf(MapttlHrs.get('Days'))!=null)
              {
                totalHrs=double.valueOf(MapttlHrs.get('Days'));
              }
              else
              {
               totalHrs=0;
              }
            }
        
        FOR(AggregateResult MapTtlUsrs: lstTtlUsers)
        {
          ttlusers=double.valueOf(MapTtlUsrs.get('ttlUser'));
        }
              
        data1 objdata1=new data1();
                
        //get rounded decimal value
        Decimal rounded;
        if(totalHrs!=0)
        {
            rounded = (totalHrs/ttlusers);        
        }
        else
        {
            rounded =0;
        }
        system.debug('**## '+rounded);
        //Calculate OT hrs per week per sales rep for the current month
        decimal noofDaysMTD=currentDate.Day();
        Decimal noOfWeekMTD=double.valueOf(noofDaysMTD/7.0);
        Decimal noOfAvgOTHrsPerWeek =double.valueOf(rounded/noOfWeekMTD);
        system.debug('Tarun '+noofDaysMTD +'  ' + noOfWeekMTD +'   '+ noOfAvgOTHrsPerWeek );
        
        objdata1.TtlOTAvg=noOfAvgOTHrsPerWeek.setScale(2);
        //objdata1.TtlOTAvg=rounded.setScale(2);
        objdata1.strRegion1='Avg National OT Hrs '+ '('+objdata1.TtlOTAvg +')';
        objdata1.strValues='';                
        
        lstAvgOTHours.add(objdata1);
  
    }
    //Region wise OT Hours
    public void getChartData() 
    {
        data = new List<Data>();
        date currentDate = Date.today();
        Date datMonthStartDate;
        Date datMonthEndDate;
              
         datMonthStartDate=date.newInstance(currentDate.year(), currentDate.month(), 1);
         datMonthEndDate=datMonthStartDate.addMonths(1) - 1;
         system.debug('Monika '+datMonthStartDate + ' '+ datMonthEndDate);
         
     
          
       /*lstCallSumamry1 = [SELECT RegionINDSU__c region, Sum(OT_Hours__c) Days
                                                      FROM Call_Summary__c 
                                                      WHERE Date__c >=:datMonthStartDate AND Date__c <=:datMonthEndDate 
                                                      AND Owner.userrole.name like'%INDSU%' group by RegionINDSU__c];*/
                                                      
     //New develop
     Map<ID,User> mapUserRegion=new Map<ID,User>([Select ID,Apac_region__c from user where IsActive=true and id in (SELECT OwnerId FROM Physician_Visit__c WHERE Activity_Date__c >=:datMonthStartDate AND Activity_Date__c <=:datMonthEndDate AND Owner.userrole.name like'%INDSU%')]);
                     system.debug('solanki123 '+mapUserRegion);    
                                                                                              
     List<AggregateResult> lstOtHrs =[SELECT OwnerId,SUM(Time_Spent_In_OT__c) hours
                                                      FROM Physician_Visit__c p
                                                       WHERE Activity_Date__c >=:datMonthStartDate AND Activity_Date__c <=:datMonthEndDate AND owner.isactive=true
                                                      AND Owner.userrole.name like'%INDSU%' group by OwnerId ];
     system.debug('solanki1235 '+lstOtHrs );                                                      
      Map<String,Decimal> mapOTRegion=new Map<String,Decimal>();                                                
      mapOTRegion.put('NORTH',0.0);
      mapOTRegion.put('EAST',0.0);
      mapOTRegion.put('WEST',0.0);
      mapOTRegion.put('SOUTH',0.0);
      
      decimal eastOT = 0.0;   
      string regionMap = '';
           
      for(AggregateResult  objAggre: lstOtHrs)
      {
      system.debug('solant '+objAggre.get('OwnerId'));
          string userId = String.ValueOf(objAggre.get('OwnerId'));
          user objUser= mapUserRegion.get(userId);
          eastOT =0.0;
          
          if(objUser.Apac_region__c=='NORTH'){
              eastOT = mapOTRegion.get('NORTH');
              eastOT += double.valueOf(objAggre.get('hours'));
              //eastOT += Integer.valueOf(objAggre.get('hours'));
              mapOTRegion.put('NORTH', eastOT);
          }
          if(objUser.Apac_region__c=='EAST'){
              eastOT = mapOTRegion.get('EAST');
              //eastOT += Integer.valueOf(objAggre.get('hours'));
              eastOT += double.valueOf(string.valueOf(objAggre.get('hours')));
              mapOTRegion.put('EAST', eastOT);
          }
          if(objUser.Apac_region__c=='WEST'){
              eastOT = mapOTRegion.get('WEST');
              //eastOT += Integer.valueOf(objAggre.get('hours'));
              eastOT += double.valueOf(string.valueOf(objAggre.get('hours')));
              mapOTRegion.put('WEST', eastOT);
          }
          if(objUser.Apac_region__c=='SOUTH'){
              eastOT = mapOTRegion.get('SOUTH');
              //eastOT += Integer.valueOf(objAggre.get('hours'));
              eastOT += double.valueOf(objAggre.get('hours'));
              mapOTRegion.put('SOUTH', eastOT);
          }
          
      }                                                                                                      
                       system.debug('solanki '+mapOTRegion);                               
       List<AggregateResult> lstTotalUserEast=[Select APAC_Region__c region,Count(Id) ttlUser  from user where  IsActive=true and userrole.name like'%INDSU Sales rep%' and APAC_Region__c !=null and APAC_Region__c in('East','West','North','south') group by APAC_Region__c]; 

       //Logic for arrange Region in N E W S order-----------------------
       List<ttlUsersData> lstTtlUserArrangeOrder=new List<ttlUsersData>();
       for(integer i=0;i<4;i++)
       {
           ttlUsersData objttlUsersData;
           lstTtlUserArrangeOrder.add(new ttlUsersData());
       }
 
       for(AggregateResult objAgr: lstTotalUserEast)
       {
        ttlUsersData objttlUsersDataNew=new ttlUsersData();
         if(String.valueOf(objAgr.get('region')).trim().toUpperCase()=='NORTH')
         {
             objttlUsersDataNew.strRegion=objAgr.get('region') ==null ? null : String.valueOf(objAgr.get('region')).trim().toUpperCase();
             objttlUsersDataNew.ttlUsers=objAgr.get('ttlUser') ==null ? null : Integer.valueOf(objAgr.get('ttlUser'));
              
             lstTtlUserArrangeOrder[0]=objttlUsersDataNew;

         }
         if(String.valueOf(objAgr.get('region')).trim().toUpperCase()=='EAST')
         {
             objttlUsersDataNew.strRegion=objAgr.get('region') ==null ? null : String.valueOf(objAgr.get('region')).trim().toUpperCase();
             objttlUsersDataNew.ttlUsers=objAgr.get('ttlUser') ==null ? null : Integer.valueOf(objAgr.get('ttlUser'));
              
             lstTtlUserArrangeOrder[1]=objttlUsersDataNew;
         }
         if(String.valueOf(objAgr.get('region')).trim().toUpperCase()=='WEST')
         {
             objttlUsersDataNew.strRegion=objAgr.get('region') ==null ? null : String.valueOf(objAgr.get('region')).trim().toUpperCase();
             objttlUsersDataNew.ttlUsers=objAgr.get('ttlUser') ==null ? null : Integer.valueOf(objAgr.get('ttlUser'));
              
             lstTtlUserArrangeOrder[2]=objttlUsersDataNew;
         }
         if(String.valueOf(objAgr.get('region')).trim().toUpperCase()=='SOUTH')
         {
             objttlUsersDataNew.strRegion=objAgr.get('region') ==null ? null : String.valueOf(objAgr.get('region')).trim().toUpperCase();
             objttlUsersDataNew.ttlUsers=objAgr.get('ttlUser') ==null ? null : Integer.valueOf(objAgr.get('ttlUser'));
              
             lstTtlUserArrangeOrder[3]=objttlUsersDataNew;

         }
       }
       //END Logic here----

        //Calculate OT hrs per week per sales rep for the current month
        decimal noofDaysMTD=currentDate.Day();
        Decimal noOfWeekMTD=double.valueOf(noofDaysMTD/7.0);
        
        
        FOR(ttlUsersData AR: lstTtlUserArrangeOrder)
        {                
            Data objCallSummary=new Data();            
            objCallSummary.strRegion1=AR.strRegion;
            objCallSummary.ttlNoHrs=double.valueOf(mapOTRegion.get(objCallSummary.strRegion1))==null ? 0 : double.valueOf(mapOTRegion.get(objCallSummary.strRegion1));
            objCallSummary.ttlNoUsers=AR.ttlUsers;

            Decimal rounded;
            if(objCallSummary.ttlNoHrs!=0 && objCallSummary.ttlNoUsers!=0)
            {
                rounded = (objCallSummary.ttlNoHrs / objCallSummary.ttlNoUsers);        
            }
            else
            {
                rounded =0;
            }
            
            Decimal noOfAvgOTHrsPerWeek =double.valueOf(rounded/noOfWeekMTD);
            
            objCallSummary.OTAvg= noOfAvgOTHrsPerWeek.setScale(2);

            data.add(objCallSummary);                    
        }                                                   
         system.debug('Hereeee '+data);
        //return data;
    }
    
    //Region wise Average Calls
    public void getAvgCallsChartData() 
    {
        lstAvgCallsData = new List<AvgCallsData>();
        date currentDate = Date.today();
        Date datMonthStartDate;
        Date datMonthEndDate;
        
        //datMonthStartDate=System.Today().addDays(-1000);
        //datMonthEndDate=System.Today().addDays(26);
         datMonthStartDate=date.newInstance(currentDate.year(), currentDate.month(), 1);
          datMonthEndDate=datMonthStartDate.addMonths(1) - 1;
          system.debug('Mon '+datMonthStartDate + ' '+ datMonthEndDate);
          
       lstCallSumamry1 = [SELECT RegionINDSU__c region, Sum(Actual_Calls__c) Calls
                                                      FROM Call_Summary__c 
                                                      WHERE Date__c >=:datMonthStartDate AND Date__c <=:datMonthEndDate AND owner.isactive=true
                                                      AND Owner.userrole.name like'%INDSU%' group by RegionINDSU__c];
                                                      
       List<AggregateResult> lstTotalUserEast=[Select APAC_Region__c region,Count(Id) ttlUser  from user where IsActive=true and userrole.name like'%INDSU Sales rep%' and APAC_Region__c !=null and APAC_Region__c in('East','West','North','south') group by APAC_Region__c]; 
       
       //Logic for arrange Region in N E W S order-----------------------
       List<ttlUsersData> lstTtlUserArrangeOrder=new List<ttlUsersData>();
       for(integer i=0;i<4;i++)
       {
           ttlUsersData objttlUsersData;
           lstTtlUserArrangeOrder.add(new ttlUsersData());
       }
 
       for(AggregateResult objAgr: lstTotalUserEast)
       {
        ttlUsersData objttlUsersDataNew=new ttlUsersData();
         if(String.valueOf(objAgr.get('region')).trim().toUpperCase()=='NORTH')
         {
             objttlUsersDataNew.strRegion=objAgr.get('region') ==null ? null : String.valueOf(objAgr.get('region')).trim().toUpperCase();
             objttlUsersDataNew.ttlUsers=objAgr.get('ttlUser') ==null ? null : Integer.valueOf(objAgr.get('ttlUser'));
              
             lstTtlUserArrangeOrder[0]=objttlUsersDataNew;

         }
         if(String.valueOf(objAgr.get('region')).trim().toUpperCase()=='EAST')
         {
             objttlUsersDataNew.strRegion=objAgr.get('region') ==null ? null : String.valueOf(objAgr.get('region')).trim().toUpperCase();
             objttlUsersDataNew.ttlUsers=objAgr.get('ttlUser') ==null ? null : Integer.valueOf(objAgr.get('ttlUser'));
              
             lstTtlUserArrangeOrder[1]=objttlUsersDataNew;
         }
         if(String.valueOf(objAgr.get('region')).trim().toUpperCase()=='WEST')
         {
             objttlUsersDataNew.strRegion=objAgr.get('region') ==null ? null : String.valueOf(objAgr.get('region')).trim().toUpperCase();
             objttlUsersDataNew.ttlUsers=objAgr.get('ttlUser') ==null ? null : Integer.valueOf(objAgr.get('ttlUser'));
              
             lstTtlUserArrangeOrder[2]=objttlUsersDataNew;
         }
         if(String.valueOf(objAgr.get('region')).trim().toUpperCase()=='SOUTH')
         {
             objttlUsersDataNew.strRegion=objAgr.get('region') ==null ? null : String.valueOf(objAgr.get('region')).trim().toUpperCase();
             objttlUsersDataNew.ttlUsers=objAgr.get('ttlUser') ==null ? null : Integer.valueOf(objAgr.get('ttlUser'));
              
             lstTtlUserArrangeOrder[3]=objttlUsersDataNew;

         }
       }
       //END Logic here----
                         
       Map<String,Integer> mapHrsRegion=new Map<string,Integer>();
        
       system.debug('lstCallSumamry1 '+lstCallSumamry1 );                 
       
        FOR(AggregateResult MapAR: lstCallSumamry1)
        {
          mapHrsRegion.put(String.valueOf(MapAR.get('region')).toUpperCase(),Integer.valueOf(MapAR.get('Calls')));
        }

        //Calculate National Calls hrs Per Day Per Sales Rep for the current month
        Decimal noofDaysMTD=currentDate.Day();
        Decimal noOfWorkingDays=double.valueOf(Label.SFE_Field_Days);
        Decimal noOfWeekMTD=double.valueOf(noofDaysMTD/7.0)*noOfWorkingDays;      
                
        FOR(ttlUsersData AR: lstTtlUserArrangeOrder)
        {                
            AvgCallsData objCallSummary=new AvgCallsData();            
            objCallSummary.strRegion1=AR.strRegion;            
            objCallSummary.ttlNoCalls=Integer.valueOf(mapHrsRegion.get(objCallSummary.strRegion1))==null ? 0 : Integer.valueOf(mapHrsRegion.get(objCallSummary.strRegion1));
            objCallSummary.ttlNoUsers=AR.ttlUsers;                   
            Decimal rounded;
            
            if(objCallSummary.ttlNoCalls!=0 && objCallSummary.ttlNoUsers!=0)
            {
                rounded = (objCallSummary.ttlNoCalls / objCallSummary.ttlNoUsers);        
            }
            else
            {
                rounded =0;
            }
            Decimal noOfTtlAvgcallsPerDay=double.valueOf(rounded/noOfWeekMTD);     
            objCallSummary.avgCalls= noOfTtlAvgcallsPerDay.setScale(2);

            lstAvgCallsData.add(objCallSummary);                    
        }                                                           
    }

    
   Public static List<AggregateResult> lstCallSumamry1;
       
    //Average National calls
    public void avgNatCallsChart() 
    {
        //List<Data1> lstdata1 = new List<Data1>();
        lstAvgNatCalls =new List<avgNatCalls>(); 
        date currentDate = Date.today();
        Date datMonthStartDate;
        Date datMonthEndDate;
        
        //datMonthStartDate=System.Today().addDays(-1000);
        //datMonthEndDate=System.Today().addDays(26);
         datMonthStartDate=date.newInstance(currentDate.year(), currentDate.month(), 1);
         datMonthEndDate=datMonthStartDate.addMonths(1) - 1;
            
        decimal totalHrs=0;
        decimal ttlusers=0; 
         
        LIST<AggregateResult> lstTtlHrs= [SELECT Sum(Actual_Calls__c) Calls
                                                      FROM Call_Summary__c 
                                                      WHERE Date__c >=:datMonthStartDate AND Date__c <=:datMonthEndDate AND owner.isactive=true
                                                      AND Owner.userrole.name like'%INDSU%'];
                                                      
        LIST<AggregateResult> lstTtlUsers=[Select Count(Id) ttlUser  from user where userrole.name like'%INDSU Sales rep%' and APAC_Region__c !=null and IsActive=true]; 
        
         FOR(AggregateResult MapttlHrs: lstTtlHrs)
            {
              if(Integer.valueOf(MapttlHrs.get('Calls'))!=null)
              {
                totalHrs=Integer.valueOf(MapttlHrs.get('Calls'));
              }
              else
              {
               totalHrs=0;
              }
            }
        
        FOR(AggregateResult MapTtlUsrs: lstTtlUsers)
        {
          ttlusers=Integer.valueOf(MapTtlUsrs.get('ttlUser'));
        }
              
        avgNatCalls objdata1=new avgNatCalls();
                
        //get rounded decimal value
        Decimal rounded;
        if(totalHrs!=0)
        {
            rounded = (totalHrs/ttlusers);        
        }
        else
        {
            rounded =0;
        }
        
        //Calculate National Calls hrs Per Day Per Sales Rep for the current month
        decimal noofDaysMTD=currentDate.Day();
        Decimal noOfWorkingDays=double.valueOf(Label.SFE_Field_Days);
        Decimal noOfWeekMTD=double.valueOf(noofDaysMTD/7.0)*noOfWorkingDays;      
        Decimal noOfTtlAvgcallsPerDay=double.valueOf(rounded/noOfWeekMTD); 
        
        objdata1.TtlOTAvg=noOfTtlAvgcallsPerDay.setScale(2);
        objdata1.strRegion1='Avg National Actual Calls '+ '('+objdata1.TtlOTAvg +')';
        objdata1.strValues='';
        
        system.debug('***here '+ noOfWorkingDays + ' '+ noOfWeekMTD);
        lstAvgNatCalls.add(objdata1);
           
    }
    
    
    public void SendMailToUserOnly()
    {   
        String strSenderName = Label.Email_INDSU_Dashborad;
      
        EmailTemplate et;
        //Added by Neha Jain for a new report, containing only few main fields from the report                               
        
        String[] toAddresses = strSenderName.split(',');    
       
        
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();        
        
        mail.setToAddresses(toAddresses);
      
        mail.setBccSender(false);
        mail.setUseSignature(false);
        mail.setSaveAsActivity(false);        
      
        mail.setTargetObjectId(Userinfo.getUserId()); //email recipient id
        
        //Send HTML body in email to end user
       //html body to be sent in mail for Dashboard      
       
       string htmlBodyCalendar = '<table width="60%" border="1"><thead style="background-color: grey"><tr><th style="font-weight:bold" align="center">Region</th><th style="font-weight:bold" align="center">Average Calls</th><th style="font-weight:bold" align="center">Average OT Hrs</th></tr></thead>';
       
        htmlBodyCalendar += '<tr><td align="center">National</td><td align="center">'+ lstAvgNatCalls[0].TtlOTAvg +'</td><td align="center">'+ lstAvgOTHours[0].TtlOTAvg +'</td></tr>';
        htmlBodyCalendar += '<tr><td align="center">North</td><td align="center">'+ lstAvgCallsData[0].avgCalls  +'</td><td align="center">'+ Data[0].OTAvg  +'</td></tr>';
        htmlBodyCalendar += '<tr><td align="center">East</td><td align="center">'+ lstAvgCallsData[1].avgCalls  +'</td><td align="center">'+ Data[1].OTAvg  +'</td></tr>';
        htmlBodyCalendar += '<tr><td align="center">West</td><td align="center">'+ lstAvgCallsData[2].avgCalls  +'</td><td align="center">'+ Data[2].OTAvg  +'</td></tr>';
        htmlBodyCalendar += '<tr><td align="center">South</td><td align="center">'+ lstAvgCallsData[3].avgCalls  +'</td><td align="center">'+ Data[3].OTAvg  +'</td></tr>';
        htmlBodyCalendar += '</table>';
        
       string strMailBody = '<html><body style="size:5pt;font-family:arial;">  Hello All,' + '<br/><br/>';
       strMailBody = strMailBody + 'Please find below the Average OT Hours and Average Calls for the current month(India Surgical).'; 
       strMailBody = strMailBody + '<br/><br/>' + htmlBodyCalendar;
       strMailBody = strMailBody + '<br/><br/>' + 'To view the dashboard, please click on the link, or copy and paste it in your browser. ' + Label.IND_OTHrs_Dashboard_Url; 
       strMailBody = strMailBody + '<br/><br/><br/>' + 'Thank you & Warm Regards' + '<br/>' + '(This is a system generated email sent you by the Bausch & Lomb Salesforce Surgical, please do not reply to this email)</body></html>'; 
       
       mail.setSubject('IND SU : Avg OT Hours and Avg Calls (Current Month)');
       mail.setHtmlBody(strMailBody);
       
        //send mail and trap results
            try{
                List<Messaging.SendEmailResult> results = Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });  
                system.debug('***results---' + '--'  + results  + '***results.get(0).isSuccess()---' + results.get(0).isSuccess());
                 if (!results.get(0).isSuccess()) {
                    System.StatusCode statusCode = results.get(0).getErrors()[0].getStatusCode();
                    String errorMessage = results.get(0).getErrors()[0].getMessage();
                    system.debug('***statusCode---' + statusCode + '***errorMessage---' + errorMessage);
                }
            }
            catch(Exception ex){
                 
                 system.debug('***Exception sending mail -----' + ex);
            }
           
        //Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }  
   
    Public Class Data
    {
        Public String strRegion1{get; set;}      
        public decimal ttlNoUsers{get;set;}  
        public decimal OTAvg{get;set;} 
        Public decimal ttlNoHrs{get;set;}                     
    }
    Public Class AvgCallsData
    {
        Public String strRegion1{get; set;}      
        public decimal ttlNoUsers{get;set;}  
        public decimal avgCalls{get;set;} 
        Public decimal ttlNoCalls{get;set;}                     
    }
    Public Class ttlUsersData
    {
        Public String strRegion{get; set;}      
        public decimal ttlUsers{get;set;}  
    }
    Public Class avgNatCalls
    {
        Public String strRegion1{get; set;}  
        Public String strValues{get; set;}       
        public decimal TtlOTAvg{get;set;}                                
    }    
   Public Class Data1
    {
        Public String strRegion1{get; set;}  
        Public String strValues{get; set;}       
        public decimal TtlOTAvg{get;set;}                                
    }    
}