/**
 * 
 *   APAC Scheduler to call the method to Send Email for Notifications for open Physcian visits of Sales Exceutives to Managers
 *   to all Area and Regional Managers
 *
 *   Author             |Author-Email                            |Date       |Comment
 *   -------------------|--------------------------------------  |-----------|--------------------------------------------------
 *   Tarun Solanki      |tarun.solanki@bausch.com                |17-Dec-2013|First Draft
 *
 */
global class clsNotifyOpenPhysicianMangersScheduler implements Schedulable{ 
    global void execute(SchedulableContext SC) {        
        
        CtrlNotifyPhysicianVisitsManagers controllerObject = new CtrlNotifyPhysicianVisitsManagers();
        controllerObject.sendMail();
        
    }
 }