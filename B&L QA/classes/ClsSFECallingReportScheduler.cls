/**
 * 
 *   Call Summary Scheduler to call the method to Send SFE Calling Report for the Past Week.
 *
 *   Author             |Author-Email                            |Date       |Comment
 *   -------------------|--------------------------------------  |-----------|--------------------------------------------------
 *   Neha Jain          |neha.jain@bausch.com                    |13-Mar-2014|First Draft
 *
 */
global class ClsSFECallingReportScheduler implements Schedulable{ 
    global void execute(SchedulableContext SC) {        
        clsSFECallingMatrixCustomReport DailyMailCallSummary = new clsSFECallingMatrixCustomReport();
        DailyMailCallSummary.callingReport = true;
        DailyMailCallSummary.InitCurrentMonth();        
        DailyMailCallSummary.exportToExcel();
        
        
    }
}