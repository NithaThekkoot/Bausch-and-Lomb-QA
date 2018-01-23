/**
 *   Call Summary Scheduler to call the method to Send SFE Calling Report for the Past Week.
 *
 *   Author             |Author-Email                            |Date       |Comment
 *   -------------------|--------------------------------------  |-----------|--------------------------------------------------
 *   Tarun Solanki      |Tarun.Solanki@bausch.com             |18-June-2014|First Draft
 *
 */
global class ClsSFECallingReportSchedulerAES implements Schedulable{ 
    global void execute(SchedulableContext SC) {        
        clsSFECallingMatrixCustomReportINDAES DailyMailCallSummary = new clsSFECallingMatrixCustomReportINDAES();
        DailyMailCallSummary.callingReport = true;
        DailyMailCallSummary.InitCurrentMonth();        
        DailyMailCallSummary.exportToExcel();
        
        
    }
}