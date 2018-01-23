/**
 * 
 *   APAC Scheduler to call the method to Send Email for Notifications for open Store visits to Sales Exceutives
 *
 *   Author             |Author-Email                            |Date       |Comment
 *   -------------------|--------------------------------------  |-----------|--------------------------------------------------
 *  Tarun Solanki       |tarun.solanki@bausch.com                |17-Dec-2013|First Draft
 *  Tarun Solanki       |tarun.solanki@bausch.com                |20-Dec-2013|Modified for Batch Class
 *
 */
global class clsNotifyOpenPhysicianScheduler implements Schedulable{ 
    global void execute(SchedulableContext SC) {        
        Batch_NotifyPhysicianVisits controller = new Batch_NotifyPhysicianVisits() ;  
        Integer batchSize = 1;  
        database.executebatch(controller , batchSize);  
        
    }
    
    

}