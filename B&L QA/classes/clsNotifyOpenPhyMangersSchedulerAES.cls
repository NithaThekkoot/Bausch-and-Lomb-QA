/**
 * 
 *   APAC Scheduler to call the method to Send Email for Notifications for open Physcian visits of Sales Exceutives to Managers
 *   to all Area and Regional Managers
 *
 *   Author             |Author-Email                            |Date       |Comment
 *   -------------------|--------------------------------------  |-----------|--------------------------------------------------
 *   Tarun Solanki      |tarun.solanki@bausch.com                |18-June-2014|First Draft
 *
 */
global class clsNotifyOpenPhyMangersSchedulerAES implements Schedulable{ 
    global void execute(SchedulableContext SC) {        
        
        CtrlNotifyPhysicianVisitsManagersAES controllerObject = new CtrlNotifyPhysicianVisitsManagersAES();
        controllerObject.sendMail();
        
    }
 }