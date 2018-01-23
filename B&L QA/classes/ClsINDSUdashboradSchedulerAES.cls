global class ClsINDSUdashboradSchedulerAES implements Schedulable{ 
    global void execute(SchedulableContext SC) {        
                
        CtrlINDAesthetics_Dashboard DailyPlanMatrixReport = new CtrlINDAesthetics_Dashboard();
        DailyPlanMatrixReport.SendMailToUserOnly();
        
    }
    
  

}