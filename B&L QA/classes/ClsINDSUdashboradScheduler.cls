global class ClsINDSUdashboradScheduler implements Schedulable{ 
    global void execute(SchedulableContext SC) {        
                
        CtrlINDSU_OTHrs_Dashboard DailyPlanMatrixReport = new CtrlINDSU_OTHrs_Dashboard();
        DailyPlanMatrixReport.SendMailToUserOnly();
        
    }
    
  

}