/**
 * 
 *   Call Summary Scheduler to call the method to Send SFE Calling Matrix Report for the Past Week.
 *
 *   Author             |Author-Email                            |Date       |Comment
 *   -------------------|--------------------------------------  |-----------|--------------------------------------------------
 *   Parag Sharma       |parag.sharma@rishabhsoft.com            |15-Apr-2013|First Draft
 *
 */
global class ClsSFECallingMatrixReportScheduler implements Schedulable{ 
    global void execute(SchedulableContext SC) {        
        clsSFECallingMatrixCustomReport DailyMailCallSummary = new clsSFECallingMatrixCustomReport();
        DailyMailCallSummary.InitCurrentMonth();        
        DailyMailCallSummary.exportToExcel();
        
        clsSFEPlanMatrixCustomReport DailyPlanAPACCallSummary = new clsSFEPlanMatrixCustomReport();
        DailyPlanAPACCallSummary.exportToExcel();
        
    }
}